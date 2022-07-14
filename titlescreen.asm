// Title screen code 

titlescreencode:
	lda #$35
	sta $01


checkforhiscore:	
	sei 
	
// Clear out interrupts from last 
// set of routines 
	
	lda #0
	sta $d019
	sta $d01a
	lda skilllevelbackup
	sta skilllevel 
	lda skilllevel
	clc 
	adc #$31
	sta skilllevelchar
	lda #1
	sta runner_speed1
	sta runner_speed1
	sta runner_speed1
	lda #0
	sta runner_dir1
	lda #1
	sta runner_dir2
	lda #0
	sta runner_dir3
	
	lda #0
	
	sta firebutton
	sta gameoptionmode
	sta $d020 
	sta $d021
	lda #$81
	sta $dc0d
	sta $dd0d
	
	ldx #$48
	ldy #$ff
	stx $fffe
	sty $ffff
	lda #$0b 
	sta $d011 
	ldx #$00
silencetitle:
	lda #$00
	sta $d400,x 
	inx 
	cpx #$18
	bne silencetitle
	jsr waitdelay
	
	
	lda #<scrolltext
	sta messread+1
	lda #>scrolltext 
	sta messread+2
	
	lda #$1b
	sta ypos 
	lda #0
	sta ydelay
	sta textmode
	
// Completely clear out the screen RAM 
// for the title screen. 
	
	ldx #$00
clearoutpreviousmem:
	lda #$20
	sta $c400,x
	sta $c500,x
	sta $c600,x
	sta $c6e8,x 
	lda #14
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $dae8,x
	inx 
	bne clearoutpreviousmem
	
	lda #0
	sta $d020
	sta $d021 
	sta $d015

	// Copy logo graphics colour data
	// to screen colour RAM
	
	ldx #$00
fetchrow:
	lda logocolour,x
	sta $d800,x
	lda logocolour+(1*40),x 
	sta $d800+(1*40),x
	lda logocolour+(2*40),x
	sta $d800+(2*40),x
	lda logocolour+(3*40),x
	sta $d800+(3*40),x
	lda logocolour+(4*40),x
	sta $d800+(4*40),x
	lda logocolour+(5*40),x
	sta $d800+(5*40),x
	lda logocolour+(6*40),x
	sta $d800+(6*40),x
	lda logocolour+(7*40),x 
	sta $d800+(7*40),x
	inx 
	cpx #40
	bne fetchrow
	
// Make a filled sprite box and then 
// position it onto the divider raster,
// so that it hides the upscroll flicker

	ldx #$00
makeblank:
	lda #$ff
	sta $c000,x 
	inx 
	cpx #$40
	bne makeblank 
	
		
		//Now position 
		
		lda #$18 
		sta $d000
		 
		adc #$2f
		sta $d002 
		adc #$30
		sta $d004
		adc #$30 
		sta $d006 
		adc #$30 
		sta $d008 
		adc #$30 
		sta $d00a 
		adc #$2f 
		sta $d00c 
		adc #$2f 
		sta $d00e 
		lda #$7f
		sta $d015 
		lda #0
		sta $d01c
		lda #$60
		sta $d010
		lda #$00
		sta $d017 
		lda #$7f
		sta $d01d 
		lda #$00
		sta $d01b 
		ldx #$00
yposspr:
		lda #$6a
		sta $d001,x
		inx
		inx
		cpx #$10
		bne yposspr
	
		// Set up the blank sprite
		ldx #$00
type:	lda #$00
		sta $c7f8,x 
		lda #0
		sta $d027,x
		inx 
		cpx #8
		bne type 
// Setup the IRQ raster interrupts 
	
	ldx #<tirq1
	ldy #>tirq1
	lda #$7f
	sta $dc0d
	stx $fffe
	sty $ffff
	ldx #<tnmi
	ldy #>tnmi 
	stx $fffa
	stx $fffc
	sty $fffb
	sty $fffd 
	lda #$2a
	sta $d012
	lda #$1b
	sta $d011
	lda #$01
	sta $d019
	sta $d01a
	lda #title_music
	jsr musicinit
	cli
	jmp titleloop
	
// Main IRQ raster interrupt routines 

// IRQ 1 - Main music player

tirq1:
	sta tstacka1+1
	stx tstackx1+1
	sty tstacky1+1
	asl $d019 
	lda $dc0d 
	sta $dd0d
	lda #$2a
	sta $d012 
	 
	lda #$7b
	sta $d011
	lda #$08 
	sta $d016 
	lda #$18
	sta $d018 
	lda #$00
	sta $dd00

	lda #1
	sta rt
	jsr musicplayer
//	lda #0
//	sta $d020

	ldx #<tirq2
	ldy #>tirq2
	stx $fffe
	sty $ffff
tstacka1:
	lda #0
tstackx1:
	ldx #0
tstacky1:
	ldy #0
tnmi:	
	rti 
	
// IRQ 2 logo displayer 

tirq2:	
	sta tstacka2+1
	stx tstackx2+1
	sty tstacky2+1
	asl $d019 
	lda #$6a
	sta $d012

 
	lda #$3b   //Bitmap mode active 
	sta $d011 
	lda #$18   //Multi colour active 
	sta $d016  //and charset $a000
	sta $d018
	lda #$01   // VIC Bank $01
	sta $dd00 
//	lda #$01
//	sta $d020 
	
	ldx #<tirq3
	ldy #>tirq3 
	stx $fffe 
	sty $ffff 
tstacka2:	
	lda #$00
tstackx2:
	ldx #$00
tstacky2:
	ldy #$00
	rti
	
// IRQ 3 logo displayer 

tirq3:
	sta tstacka3+1
	stx tstackx3+1
	sty tstacky3+1
	asl $d019 
	lda #$72 // mini divider for scroll 
	sta $d012
 
	lda #$70
	sta $d011
	lda #$08
	sta $d016 
	lda #$18
	sta $d018 
	lda #$00
	sta $dd00
	
//	lda #2
//	sta $d020
	ldx #<tirq4 
	ldy #>tirq4 
	stx $fffe 
	sty $ffff 
tstacka3:
	lda #0
tstackx3:
	ldx #0
tstacky3:
	ldy #0
	rti
	
// IRQ 4 upscroll displayer 

tirq4:
	sta tstacka4+1
	stx tstackx4+1
	sty tstacky4+1
	asl $d019 
	lda #$f0
	sta $d012
	lda ypos  
	ora #$10
	sta $d011 
 
	
	// lda #3
	// sta $d020
	ldx #<tirq5
	ldy #>tirq5 
	stx $fffe 
	sty $ffff 
tstacka4: 
	lda #0
tstackx4:
	ldx #0
tstacky4:
	ldy #0
	rti
	
//Finally bottom X position 

tirq5:
	sta stacka5+1
	stx stackx5+1
	sty stacky5+1
	asl $d019 
	lda #$fa 
	sta $d012 
	 
	 ldx #5
	 dex 
	 bne *-1
	lda #$7b
	sta $d011 
	 
//	lda #4
//	sta $d020 
	ldx #<tirq1
	ldy #>tirq1
	stx $fffe
	sty $ffff 
stacka5:
	lda #0
stackx5:
	ldx #0
stacky5:
	ldy #0
	rti

// Music player (PAL/NTSC)

musicplayer:
	lda system
	cmp #1
	beq pal 
	inc ntsctimer
	lda ntsctimer 
	cmp #6
	beq resetntsc
pal:
	jsr musicplay 
	rts 
resetntsc:
	lda #0
	sta ntsctimer 
	rts 
	
// Main title loop. 

titleloop:
	lda #0
	sta rt
	cmp rt
	beq *-3
	jsr upscroll
	jsr titlecolourwash
	lda $dc00 
	lsr 
	lsr 
	lsr 
	lsr 
	lsr 
	bit firebutton
	ror firebutton
	bmi titleloop2
	bvc titleloop2
	jmp gamecode
titleloop2:
	lda $dc01 
	lsr 
	lsr 
	lsr 
	lsr 
	lsr 
	bit firebutton
	ror firebutton
	bmi titleloop
	bvc titleloop
	jmp gamecode
	
// Title screen and hi score upscroll 
// text routine 

upscroll:
	lda ydelay 
	cmp #1
	beq scrollup
	inc ydelay
skipshift:
	rts
scrollup:
	lda #0
	sta ydelay

	lda ypos
	sec
	sbc #1
	and #$07 
	sta ypos 
	bcs skipshift
	ora #$10
	sta ypos2
      ldx #$27
shiftrows:
	  lda tscreen+360,x 
	  sta tscreen+320,x
      lda tscreen+400,x
      sta tscreen+360,x
      lda tscreen+440,x
      sta tscreen+400,x
      lda tscreen+480,x
      sta tscreen+440,x
      lda tscreen+520,x
      sta tscreen+480,x
      lda tscreen+560,x
      sta tscreen+520,x
      lda tscreen+600,x
      sta tscreen+560,x
      lda tscreen+640,x
      sta tscreen+600,x
      dex
      bpl shiftrows
      ldx #$27
shiftrows2:      
      lda tscreen+680,x
      sta tscreen+640,x
      lda tscreen+720,x
      sta tscreen+680,x
      lda tscreen+760,x
      sta tscreen+720,x
      lda tscreen+800,x
      sta tscreen+760,x
      lda tscreen+840,x
      sta tscreen+800,x
      lda tscreen+880,x
      sta tscreen+840,x
      lda tscreen+920,x
      sta tscreen+880,x

      dex
      
      bpl shiftrows2

updatemessage:
	ldx #0
messread:
	lda scrolltext,x
	sta $02,x
	cmp #$00
	beq wraptext 
	inx 
	cpx #20
	bne messread 
	jmp store 
wraptext:
	lda #<scrolltext 
	sta messread+1
	lda #>scrolltext
	sta messread+2 
	jmp messread

store:
	lda textmode
	cmp #1
	beq lower
	cmp #2
	beq linespace
upper:
	ldx	#$00
	ldy #$00
	txa 
upperloop:
	lda $02,x 
	sta tscreen+920,y 
	eor #$40
	sta tscreen+920+1,y 
	iny
	iny
	inx
	cpx #$14
	bne upperloop
	lda #1
	sta textmode
	rts

lower:
	ldx #$00
	ldy #$00
	txa
lowerloop:
	lda $02,x 
	eor #$80 
	sta $c400+920,y
	eor #$40
	sta $c400+920+1,y	
	iny
	iny
	inx
	cpx #$14
	bne lowerloop 
	lda #2
	sta textmode
	rts
linespace:
	ldx #$00
dospace:
	lda #$20
	sta $c400+920,x
	inx
	cpx #40 
	bne dospace 
	lda #0 
	sta textmode 

	lda messread+1
	clc
	adc #20
	sta messread+1

	lda messread+2
	adc #0
	sta messread+2 
	bcs exit
exit:
	rts

// Titlescreen colour wash routine 

titlecolourwash:
				lda colourdelay
				cmp #2
				beq colourok
				inc colourdelay 
				rts 
colourok:		lda #0
				sta colourdelay
				ldx colourpointer
				lda colourtable,x 
				sta rowcolourtable+19
				inx
				cpx #colourtableend-colourtable 
				beq resetcolourtable
				inc colourpointer
				jmp calculaterows
resetcolourtable:
				ldx #0
				stx colourpointer
			 
calculaterows:	ldx #$00
shiftcolleft:   lda rowcolourtable+1,x 
				sta rowcolourtable,x
				inx
				cpx #19
				bne shiftcolleft 
				ldx #19
shiftcollright: lda rowcolourtable+19,x 
				sta rowcolourtable+20,x								 				
				dex
				bpl shiftcollright 
				ldx #$00
paintrowseg1:	lda rowcolourtable,x
				ldy gameoptionmode
				cpy #1
				bne ignorerows
				sta $d800+80,x
				sta $d800+120,x
				sta $d800+160,x
				sta $d800+200,x
				sta $d800+240,x
ignorerows:				
				sta $d800+280,x
				sta $d800+320,x 
				sta $d800+360,x
				sta $d800+400,x
				sta $d800+440,x
				sta $d800+480,x
				sta $d800+520,x 
				sta $d800+560,x
				inx
				cpx #40 
				bne paintrowseg1
				ldx #$00
paintrowseg2:	lda rowcolourtable,x
				sta $d800+600,x
				sta $d800+640,x
				sta $d800+680,x
				sta $d800+720,x
				sta $d800+760,x
				sta $d800+800,x
				sta $d800+840,x
				sta $d800+880,x
				sta $d800+920,x
				inx 
				cpx #40 
				bne paintrowseg2
				
				rts

	
	

ydelay: .byte 0	
ypos: .byte 0
ypos2: .byte 0
textmode: .byte 0
colourdelay: .byte 0
colourpointer: .byte 0
gameoptionmode: .byte 0
colourtable: .byte $09,$02,$08,$0a,$07,$01,$07,$0a,$08,$02,$09 
			 .byte $06,$04,$0e,$03,$0d,$01,$0d,$03,$0e,$04,$06
			 .byte $0b,$0c,$0f,$07,$0d,$01,$0d,$07,$0f,$0c,$0b
colourtableend:

rowcolourtable: .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
				.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
				.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
				.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00



//.TEXT "12345678901234567890"
scrolltext:
  .text "                    "
  .text "     welcome to     "
  .text "                    "
  .text "   little nippers   "
  .text " the deluxe edition "
  .text "                    "
  .text "      (c) 2022      "
  .text " the new dimension  "
  .text "                    "
  .text " brought to you by  "
  .text "zzap 64 micro action"
  .text "                    "
  .text "code, sfx, charsets "
  .text "      and music     "
  .text "         by         "
  .text "  richard bayliss   "
  .text "                    "
  .text "exomizer  decruncher"
  .text "      routines      "
  .text "         by         "
  .text "    magnus lind     "
  .text "                    "
  .text "graphics and sprites"
  .text "         by         "
  .text " hugues  poisseroux "
  .text "                    "
  .text " tape loader system "
  .text "         by         "
  .text "    martin piper    "
  .text "                    "
  .text "                    "
  
  .text "                    "
  .text "--------------------"
  .text "   the snap happy   "
  .text "    hall of fame    "
  .text "--------------------"
  .text "                    "
HiScoreTableStart:  
  .text "01. "
name1: .text "little    "
hiscore1: .text "020000"
.text "02. "
name2: .text "nippers   "
hiscore2: .text "019000"
.text "03. "
name3: .text "deluxe    "
hiscore3: .text "018000"
.text "04. "
name4: .text "by        "
hiscore4: .text "017000"
.text "05. "
name5: .text "richard   "
hiscore5: .text "016000"
.text "06. "
name6: .text "bayliss   "
hiscore6: .text "015000"
.text "07. "
name7: .text "brought   "
hiscore7: .text "014000"
.text "08. "
name8: .text "to you    "
hiscore8: .text "013000"
.text "09. "
name9: .text "by        "
hiscore9: .text "012000"
.text "10. "
name10: .text "zzap      "
hiscore10: .text "011000"
HiScoreTableEnd:
	.text "                    "
	.text "--------------------"
	.text "                    "
	.text " using fire on any  "
	.text "joystick or spacebar"
	.text "launch crabs out of "
	.text "the buckets and nip "
	.text "a limited number of "
	.text "kiddies feet to win "
	.text "each level.         "
	.text "                    "
	.text "for every 10,000 pts"
	.text "you can launch a    "
	.text "jellyfish on your   "
	.text "next turn.          "
	.text "                    "
	.text "crabs are lost when "
	.text "either the crab or  "
	.text "jellyfish ends up   "
	.text "in the deep area of "
	.text "the sea.            "
	.text "                    "
	.text "press space or fire "
	.text "to play and have    "
	.text "loads of fun.       "
	.text "                    "
	.text "--------------------"
	.text "                    "

  
.byte 0 
