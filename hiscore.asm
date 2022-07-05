// Little Nippers DX hi score detection
hi_score_checker:

		// Switch off IRQs before checking high scores
		sei 
		lda #$81
		sta $dc0d
		sta $dd0d
		lda #$00
		sta $d019
		sta $d01a
		sta $d015
		lda #$00
		sta $d011
		sta $d020
		sta $d021

		//Initialise starting letter character

		lda #1
		sta letter_char 
		lda #0
		sta name_finished

		// Clear out the SID interrupt 
		// and perform a short delay.

		ldx #$00
clearsidh:
		lda #$00
		sta $d400,x
		inx 
		bne clearsidh 
		jsr waitdelay

		// Setup hi score table directives
		// and place them into zeropages

		ldx #$00
next_one:
		lda hslo,x
		sta $c1
		lda hshi,x
		sta $c2 

		// Check if player's score matches
		// any of the hi scores available
		// on the list. 

		ldy #$00
score_get:
		lda scoretext,y 
score_cmp:
		cmp ($c1),y
		bcc pos_down 
		beq next_digit 
		bcs pos_found 
next_digit:
		iny 
		cpy #scorelen
		bne score_get
		beq pos_found 
pos_down:
		inx
		cpx #listlen
		bne next_one 
		beq no_hiscore
pos_found:
		stx $02 //Store to temporary zeropage
		cpx #listlen-1 
		beq last_score 

		// Read the list and put hi score 
		// values into zero pages, also do
		// the same for names.

		ldx #listlen-1
copy_next:
		lda hslo,x
		sta $c1
		lda hshi,x
		sta $c2
		lda nmlo,x
		sta $d1
		lda nmhi,x
		sta $d2 
		dex
		lda hslo,x
		sta $c3
		lda hshi,x
		sta $c4
		lda nmlo,x 
		sta $d3
		lda nmhi,x
		sta $d4 

		ldy #scorelen-1
copy_score:
		lda ($c3),y 
		sta ($c1),y
		dey
		bpl copy_score 

		ldy #namelen+1
copy_name:
		lda ($d3),y
		sta ($d1),y 
		dey
		bpl copy_name
		cpx $02
		bne copy_next

last_score:
		ldx $02
		lda hslo,x
		sta $c1
		lda hshi,x
		sta $c2
		lda nmlo,x
		sta $d1
		lda nmhi,x
		sta $d2 
		jmp name_entry 

		// Name has been entered place new name
		// and hi score to the table position

place_new_score:
		ldy #scorelen-1
put_score:
		lda scoretext,y 
		sta ($c1),y 
		dey 
		bpl put_score

		ldy #namelen-1 
put_name:	
		lda name,y 
		sta ($d1),y 
		dey 
		bpl put_name 
		jsr SaveHiScore
no_hiscore:

		jmp titlescreencode

// Main name entry. We need to use VIC BANK #$00 for 
// displaying the 2x2 character set for the hi score
// table/name entry routine. 

name_entry:
		lda #$00
		sta $dd00
		lda #$08
		sta $d016
		lda #$18
		sta $d018

		// Copy the well done text message to screen
		// before switching the screen on

		ldx #$00
clearscreenhi:
		lda #$00
		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		lda #$20
		sta $c400,x
		sta $c500,x
		sta $c600,x
		sta $c6e8,x
		inx
		bne clearscreenhi

		// Now put in the well done message onto the screen 

		ldx #$00
		ldy #$00
		txa
copyhimessage:
		lda wowee,x 
		sta $c400+(2*40),y
		clc
		adc #$40
		sta $c400+(2*40)+1,y
		clc 
		adc #$40 
		sta $c400+(3*40),y 
		clc
		adc #$40 
		sta $c400+(3*40)+1,y
		lda hiscoremessage,x
		sta $c400+(6*40),y
		clc
		adc #$40
		sta $c400+(6*40)+1,y
		clc
		adc #$40
		sta $c400+(7*40),y 
		clc 
		adc #$40 
		sta $c400+(7*40)+1,y 
		lda hiscoremessage+20,x 
		sta $c400+(9*40),y
		clc
		adc #$40
		sta $c400+(9*40)+1,y
		clc 
		adc #$40  
		sta $c400+(10*40),y
		clc
		adc #$40 
		sta $c400+(10*40)+1,y
		lda hiscoremessage+40,x 
		sta $c400+(12*40),y
		clc
		adc #$40
		sta $c400+(12*40)+1,y
		clc
		adc #$40 
		sta $c400+(13*40),y
		clc
		adc #$40 
		sta $c400+(13*40)+1,y
		lda hiscoremessage+60,x 
		sta $c400+(15*40),y
		clc
		adc #$40 
		sta $c400+(15*40)+1,y
		clc
		adc #$40 
		sta $c400+(16*40),y
		clc
		adc #$40 
		sta $c400+(16*40)+1,y
		iny
		iny
		inx
		cpx #20 
		bne copyhimessage

		// Clear out the player's name 

		ldx #$00
clearname:
		lda #$20
		sta name,x
		inx
		cpx #namelen
		bne clearname

		// Reset the position of the player's name 
		// so that the name can be entered from the 
		// start.

		lda #<name 
		sta namesm+1
		lda #>name 
		sta namesm+2 

// Setup an exclusive IRQ raster interrupt for the hi 
// score table routine.

		ldx #<hi_irq 
		ldy #>hi_irq 
		lda #$7f 
		stx $fffe
		sty $ffff

		ldx #<nmi
		ldy #>nmi 
		stx $fffa
		stx $fffc
		sty $fffb
		sty $fffd
		
		sta $dc0d
		sta $dd0d
		lda #$2e 
		sta $d012 
		lda #$1b
		sta $d011
		lda #$01
		sta $d019
		sta $d01a
		 
		lda #hi_score_music
		jsr musicinit
		cli 
name_entry_loop:
// The main name entry loop routine
		jsr synctimer
		jsr titlecolourwash

		// Display name on screen
		ldx #$00
		ldy #$00
		txa
show_name:
		lda name,x 
		sta $c6b3+120,y
		clc
		adc #$40
		sta $c6b3+121,y 
		clc
		adc #$40
		sta $c6db+120,y
		clc
		adc #$40 
		sta $c6db+121,y
		iny
		iny
		inx
		cpx #9 
		bne show_name

		// Check if name input has finished 

		lda name_finished 
		bne stop_name_entry 
		jsr joycheck
		jmp name_entry_loop 
stop_name_entry: 
		jmp place_new_score		

// Joystick control name entry check routine
//(Must be read from both ports)

joycheck:
		lda letter_char 
namesm:	sta name 
		lda joy_delay 
		cmp #6
		beq joy_hi_ok 
		inc joy_delay 
		rts 

joy_hi_ok:
		lda #0
		sta joy_delay 

		// Check joystick direction up 

hi_up: 	lda #1
		bit $dc00
		beq letter_goes_up
		lda #1
		bit $dc01
		beq letter_goes_up 
		jmp hi_down
letter_goes_up:
		jmp letter_up 

hi_down: 
		lda #2
		bit $dc00 
		beq letter_goes_down 
		lda #2
		bit $dc00
		beq letter_goes_down 
		jmp hi_fire
letter_goes_down:
		jmp letter_down

hi_fire:
		lda $dc00
		lsr
		lsr
		lsr
		lsr
		lsr
		bit firebutton
		ror firebutton 
		bmi hi_fire2
		bvc hi_fire2
		jmp select
hi_fire2:
		lda $dc01
		lsr
		lsr
		lsr
		lsr
		lsr
		bit firebutton 
		ror firebutton 
		bmi nohijoy
		bvc nohijoy
		jmp select 
nohijoy: rts
		// Letter goes up
letter_up:
		inc letter_char 
		lda letter_char 
		cmp #27
		beq make_up_arrow
		cmp #33
		beq a_char 
		rts
make_up_arrow:
		lda #30
		sta letter_char
		rts
auto_space:
		lda #32 //Spacebar character
		sta letter_char 
		rts 
a_char:	lda #1
		sta letter_char
		rts

		// Letter goes down
letter_down:
		dec letter_char 
		lda letter_char
		beq space_char 
		lda letter_char 
		cmp #29
		beq z_char
		rts 
space_char:
		lda #32
		sta letter_char
		rts 
z_char:
		lda #26
		sta letter_char
		rts

// Char selected, check for delete or end
// character. Or switch to next char position
// until reached ninth character position
select:	lda letter_char 
check_delete_char:
		cmp #31
		bne check_end_char 
		lda namesm+1
		cmp #<name 
		beq do_not_go_back 
		dec namesm+1
		jsr name_housekeep 
do_not_go_back:
		rts

		// Check end character
check_end_char:
		cmp #30
		bne char_is_ok
		lda #32
		sta letter_char
		jmp finished_now

char_is_ok:
		inc namesm+1
		lda namesm+1
		cmp #<name+9 
		beq finished_now 
hi_no_fire:
		rts 

finished_now:
		jsr name_housekeep
		lda #1
		sta name_finished 
		rts 

		// Name housekeeping routine

name_housekeep:
		ldx #$00
clearcharsn:
		lda name,x
		cmp #30
		beq cleanup 
		cmp #31 
		beq cleanup 
		jmp skip_cleanup
cleanup:
		lda #$20
		sta name,x 
skip_cleanup:
		inx
		cpx #9
		bne clearcharsn
		rts

// Finally the IRQ raster interrupt for the hi score
// table.

hi_irq:	sta hstacka+1
		stx hstackx+1
		sty hstacky+1
		asl $d019
		lda $dc0d
		sta $dd0d
		lda #$f8
		sta $d012 
		lda #1
		sta rt
		jsr musicplayer
hstacka: 
		lda #0
hstackx:
		ldx #0
hstacky:
		ldy #0
nmi:	rti



joy_delay: .byte 0
letter_char: .byte 1
name_finished: .byte 0


wowee:      .text "      wowee!!!      "
hiscoremessage:
			.text "your score is great "
			.text " please enter your  "
			.text "name for the hall of"
			.text "       fame.        "
