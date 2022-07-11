// Little nippers intro 

.const exosfxstart = $080d
.const musicinit = $1000
.const musicplay = $1003
.const bmpvid = $3f40 
.const bmpcol = $4328
.const screencolour = $4710 
.const screen = $0400 
.const colour = $d800 
.const gamedata = $4800

BasicUpstart2(introstart)

			*=$080d "PIC SHOWER CODE"
introstart:
			//Disable RUN/RESTORE
			lda #251
			sta $0328
			// Detect C64 video mode
			
			jsr systemdetect
			
			lda #$0b // Screen off 
			sta $d011 // for a bit
			// Draw picture to screen 
			
			ldx #$00
drawpicdat:			
			lda bmpvid,x
			sta screen,x
			lda bmpvid+$100,x
			sta screen+$100,x
			lda bmpvid+$200,x
			sta screen+$200,x
			lda bmpvid+$2e8,x
			sta screen+$2e8,x 
			
			lda bmpcol,x
			sta colour,x
			lda bmpcol+$100,x
			sta colour+$100,x
			lda bmpcol+$200,x
			sta colour+$200,x
			lda bmpcol+$2e8,x 
			sta colour+$2e8,x 
			inx 
			bne drawpicdat 
			
			lda screencolour
			sta $d020 
			sta $d021
			
			lda #$18
			sta $d018 
			sta $d016
			lda #$03
			sta $dd00
			
			// Setup IRQ raster 
			// interrupts
			
			ldx #<irq
			ldy #>irq 
			lda #$7f
			stx $0314
			sty $0315
			sta $dc0d
			lda #$32
			sta $d012
			lda #$3b
			sta $d011 
			lda #$01
			sta $d01a 
			lda #0
			jsr musicinit
			cli 
			
			// Wait for spacebar
wait:			
			lda #16
			bit $dc00
			beq exitpic
			lda #16
			bit $dc01 
			beq exitpic
			jmp wait
			
exitpic:	sei 
			ldx #$31
			ldy #$ea
			lda #$81
			stx $0314
			sty $0315
			sta $dc0d 
			sta $dd0d 
			lda #$00
			sta $d01a 
			sta $d019 
			
			// Clear out the SID
			
			ldx #$00
silence:	lda #$00
			sta $d400,x 
			inx 
			cpx #$18
			bne silence 
			
			// Now restore the screen 
			// properties 
			
			ldx #$00
blackout:	lda #$00
			sta $0400,x
			sta $0500,x
			sta $0600,x
			sta $06e8,x
			sta $d800,x
			sta $d900,x
			sta $da00,x
			sta $dae8,x 
			inx 
			bne blackout 
			
			// Default charset and VIC2
			// attributes 
			
			lda #0
			sta $d020
			sta $d021
			
			lda #$08
			sta $d016
			lda #$14
			sta $d018 
			lda #$1b
			sta $d011
			// Copy transfer routine 
			
			ldx #$00
copytrans:	lda codetransfer,x 			
			sta $0400,x
			inx 
			bne copytrans
			
			lda #$00
			sta $0800 
			cli 
			jmp $0400
			
// Main transfer routine 

codetransfer:
			sei
			lda #$34
			sta $01
transfer:	ldx #$00			
transfer2:	lda gamedata,x
			sta $0801,x
			inx 
			bne transfer2
			inc $0409
			inc $040c
			lda $0409
			bne transfer
			lda #$37
			sta $01
			cli 
			
			jmp exosfxstart
			
// Main IRQ 
			
irq:		inc $d019 
			lda $dc0d
			sta $dd0d 
			lda #$fa
			sta $d012 
			jsr pnplayer
			jmp $ea7e 

// PAL/NTSC timed music player
			
pnplayer:	lda system 
			cmp #1
			beq palmusic
			inc ntsctimer 
			lda ntsctimer 
			cmp #6
			beq resetntsct
palmusic:	jsr musicplay
			rts 
resetntsct: lda #0
			sta ntsctimer 
			rts

// Detect system ID 

systemdetect:
			lda $d012 
			cmp $d012 
			beq *-3
			bmi systemdetect
			cmp #$22
			bcc ntscmode 
			lda #1
			sta system 
			rts 
ntscmode:	lda #0
			sta system 
			rts 
			
system: .byte 0
ntsctimer: .byte 0			
			
// ------------------------------------			
			
			*=$1000 "INTRO MUSIC"
intromusic:
	.import c64 "c64/loadertune.prg"
			
// ------------------------------------			
			
			*=$2000 "INTRO BITMAP"
intropic:
   .import c64 "c64/loaderpic.prg"
			
// ------------------------------------			

			*=$4800 "LINKED GAME"
maingame:
	.import c64 "littlenippers-ready.prg"