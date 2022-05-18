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
	sta firebutton
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
	cmp #2 
	beq ydelayok 
	inc ydelay 
scrollexit:
	rts 
	
ydelayok:
	lda #0
	sta ydelay 
	lda ypos 
	sec 
	sbc #1
	and #7
	sta ypos 
	bcs scrollexit 
	jsr hardscroll01
	jsr hardscroll02
	jsr hardscroll03 
	jsr hardscroll04
	//Self-mod text output, after 
	//shifting the screen data upwards 
	
	ldx #$00
	ldy #$00
messread:
	lda scrolltext,x 
	beq wrapupscroll
	clc 
noteor:
	adc #0
	sta $c400+(24*40),y
	eor #$40
	sta $c401+(24*40),y
	iny 
	iny 
	inx 
	cpx #20
	bne messread 
	
	//Should text be normal or rvs mode 
	
	lda textmode 
	beq fliptocase1
	cmp #1
	beq fliptocase0
	rts 
	
fliptocase1:
	// Set RVS on 
	lda #1
	sta textmode 
	lda #$80 
	sta noteor+1
	rts 
	
fliptocase0:
	// Set RVS off 
	lda #0
	sta textmode 
	lda #$00
	sta noteor+1
	
	// Setup new row of the text 
	
	lda messread+1
	clc 
	adc #20
	sta messread+1
	
	lda messread+2
	adc #0
	sta messread+2
	rts 
	
wrapupscroll:
tsm1:
	lda #<scrolltext
	sta messread+1
	lda #>scrolltext
	sta messread+2 
	rts 

		// Hardscroll segment 1 
		
hardscroll01:

	ldx #$00
hs_loop1:
	lda $c400+(9*40),x
	sta $c400+(8*40),x
	lda $c400+(10*40),x
	sta $c400+(9*40),x
	lda $c400+(11*40),x
	sta $c400+(10*40),x 
	lda $c400+(12*40),x
	sta $c400+(11*40),x 
	inx 
	cpx #40 
	bne hs_loop1
	rts 
	
hardscroll02:
	ldx #$00
hs_loop2:
	lda $c400+(13*40),x
	sta $c400+(12*40),x
	lda $c400+(14*40),x
	sta $c400+(13*40),x
	lda $c400+(15*40),x
	sta $c400+(14*40),x
	lda $c400+(16*40),x
	sta $c400+(15*40),x
	inx 
	cpx #40
	bne hs_loop2
	rts 
	
hardscroll03:
	ldx #$00
hs_loop3: 
	lda $c400+(17*40),x
	sta $c400+(16*40),x
	lda $c400+(18*40),x
	sta $c400+(17*40),x
	lda $c400+(19*40),x
	sta $c400+(18*40),x
	lda $c400+(20*40),x
	sta $c400+(19*40),x 
	inx 
	cpx #40
	bne hs_loop3
	rts
hardscroll04:
	ldx #$00
hs_loop4:
	lda $c400+(21*40),x
	sta $c400+(20*40),x
	lda $c400+(22*40),x
	sta $c400+(21*40),x
	lda $c400+(23*40),x 
	sta $c400+(22*40),x 
	lda $c400+(24*40),x
	sta $c400+(23*40),x
	inx 
	cpx #40
	bne hs_loop4 
	rts
	
	

ydelay: .byte 0	
ypos: .byte 0
textmode: .byte 0

//.TEXT "12345678901234567890"
scrolltext:
  .text "                    "
  .text "     welcome to     "
  .text "                    "
  .text "  little nippers dx "
  .text "                    "
  .text " copyright (c) 2022 "
  .text " the new dimension  "
  .text "                    "
  .text "                    "
  .text "   code and sound   "
  .text "         by         "
  .text "  richard bayliss   "
  .text "                    "
  .text "    graphics by     "
  .text " hugues  poisseroux "
  .text "                    "
  .text "   2x2 charset by   "
  .text "       ??????       "
  .text "                    "
  .text "                    "
  .text " press spacebar or  "
  .text "fire on any joystick"
  .text "      to play       "
  .text "                    "
  .text "                    "
  .text "   the snap happy   "
  .text "    hall of fame    "
  .text "                    "
  .text "01. "
name1: .text "richard   "
hiscore1: .text "010000"
.text "02. "
name2: .text "hugues    "
hiscore2: .text "009000"
.text "03. "
name3: .text "martin    "
hiscore3: .text "008000"
.text "04. "
name4: .text "kevin     "
hiscore4: .text "007000"
.text "05. "
name5: .text "anthony   "
hiscore5: .text "006000"
.text "06. "
name6: .text "magnus    "
hiscore6: .text "005000"
.text "07. "
name7: .text "paul      "
hiscore7: .text "004000"
.text "08. "
name8: .text "andrew    "
hiscore8: .text "003000"
.text "09. "
name9: .text "neil      "
hiscore9: .text "002000"
.text "10. "
name10: .text "reset     "
hiscore10: .text "001000"

.text "                    "
.text "                    "
.text "                    "
.text "                    "
.byte 0 
name: .text "         "
nameend:
    