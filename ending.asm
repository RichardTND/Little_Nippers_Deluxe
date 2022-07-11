// Game endscreen 

displayendscreen:
			sei 
			lda #$00
			sta $d01a 
			sta $d019 
			lda #$81
			sta $dc0d 
			sta $ddd0d
			ldx #$f8
			ldy #$ff 
			lda #$0b
			sta $d011
			ldx #$00
sndoff2:	lda #$00
			sta $d400,x 
			inx 
			cpx #$18 
			bne sndoff2 
			ldx #$00
offmode:	ldy #$00
			iny 
			bne *-1
			inx 
			bne offmode
			lda #$1e
			sta $d018 
			lda #$08
			sta $d016 
			lda #$03
			sta $dd00
			lda #$07
			sta $d020 
			sta $d021 
			ldx #$00
buildend:	lda endscreen,x
			sta $0400,x
			lda endscreen+$100,x
			sta $0500,x
			lda endscreen+$200,x
			sta $0600,x
			lda endscreen+$2e8,x 
			sta $06e8,x 
			ldy endscreen,x 
			lda statusattribs,y
			sta $d800,x
			ldy endscreen+$100,x
			lda statusattribs,y
			sta $d900,x
			ldy endscreen+$200,x
			lda statusattribs,y 
			sta $da00,x 
			ldy endscreen+$2e8,x 
			lda statusattribs,y 
			sta $dae8,x 
			inx 
			bne buildend 
			lda skilllevel
			cmp #4
			beq forcegamecompletetext
			lda #<endscroll
			sta endmess+1
			sta end01+1
			lda #>endscroll
			sta endmess+2
			sta end02+1
			jmp mainend
forcegamecompletetext:
			lda #<endscroll2
			sta endmess+1
			sta end01+1
			lda #>endscroll2
			sta endmess+2
			sta end02+1
	
			
mainend:			
			lda #0
			sta $d015 
			lda #0
			sta firebutton
			ldx #<endirq
			ldy #>endirq 
			stx $fffe
			sty $ffff
			lda #$7f
			sta $dc0d 
			sta $dd0d 
			lda #$36
			sta $d012
			lda #$1b
			sta $d011
			lda #$01
			sta $d01a 
			lda #4
			jsr musicinit
			lda #0
			sta firebutton
			cli 
waitfireending:			
			lda #0
			sta rt 
			cmp rt 
			beq *-3 
			jsr endscroller
			lda $dc00 
			lsr 
			lsr
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi waitfireending2
			bvc waitfireending2
endend:		lda #0
			sta firebutton
			jmp skill_level_complete
waitfireending2:			
			lda $dc01 
			lsr 
			lsr 
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi waitfireending 
			bvc waitfireending 
			jmp skill_level_complete

endirq:		sta estacka+1
			stx estackx+1
			sty estacky+1
			asl $d019 
			lda $dc0d 
			sta $dd0d 
			lda #$22
			sta $d012
			lda xpos 
			sta $d016 
			ldx #<endirq2 
			ldy #>endirq2 
			stx $fffe 
			sty $ffff
			
estacka:	lda #0
estackx:	ldx #0
estacky:	ldy #0
			rti
			
endirq2:	sta estacka2+1
			stx estackx2+1
			sty estacky2+1
			asl $d019 
			lda #$f0 
			sta $d012 
			lda #$08
			sta $d016 
			ldx #<endirq 
			ldy #>endirq 
			stx $fffe 
			sty $ffff
			lda #1
			sta rt
			jsr musicplayer
estacka2:	lda #0
estackx2:	ldx #0
estacky2:	ldy #0
			rti
			
			
endscroller:
			lda xpos 
			sec 
			sbc #1
			and #7
			sta xpos 
			bcs exitendscroll
			ldx #$00
scrloop:	lda $07c1,x 
			sta $07c0,x 
			lda #6
			sta $dbc0,x 
			inx 
			cpx #$28
			bne scrloop
endmess:	lda endscroll
			bne storx
end01:		lda #<endscroll
			sta endmess+1
end02:		lda #>endscroll 
			sta endmess+2
			jmp endmess 
storx:		sta $07e7 
			inc endmess+1
			bne exitendscroll 
			inc endmess+2 
exitendscroll:
			rts
			
skill_level_complete:
			
			lda skilllevel 
			cmp #4
			beq finishedgame 
			
			sei 
			ldx #$48 
			ldy #$ff 
			stx $fffe 
			sty $ffff
			lda #$00
			sta $d019 
			sta $d01a 
			lda #$81
			sta $dc0d 
			sta $dd0d 
			lda #$0b
			sta $d011
		
			ldx #<gameirq
			ldy #>gameirq 
			lda #$7f 
			stx $fffe
			sty $ffff 
			
			sta $dc0d 
			sta $dd0d 
			lda #$32
			sta $d012
			lda #$1b 
			sta $d011
			lda #$01
			sta $d01a 
			sta $d019 
			ldx #0
			stx levelpointer
			inc skilllevel
			 cli 
			jmp resetmiss
			
finishedgame:
			jmp hi_score_checker
			
xpos:		.byte 0			
