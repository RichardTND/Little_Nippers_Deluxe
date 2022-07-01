//Little Nippers - Game Decruncher

	*=$0801
	.import c64 "littlenippersdx.exo"
	lda #$00
	sta $d020
	sta $d021
	ldx #$00
clrsc:	lda #$20
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $06e8,x
	lda #$0f
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $dae8,x
	inx
	bne clrsc
	ldx #$00
putliner:
	lda line,x
	sta $0400,x
	inx
	cpx #40
	bne putliner
	rts
	
	//.text "0123456789012345678901234567890123456789"
line: .text "unleashing the grumpy crabs in a moment!"
