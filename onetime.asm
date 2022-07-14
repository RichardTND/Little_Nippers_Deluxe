CodeStart:	sei 
.if (testwithnohisaver == 1) {
} else {
			lda #$37
			sta $01
			jsr $e3bf
			lda $ba
			sta device
}			
onetimepncheck:			
mode1:		lda $d012 
mode2:		cmp $d012 
			beq mode2
			bmi mode1
			cmp #$20 
			bcc ntsc 
			lda #$01
			sta system 
			lda #$0e
			sta rastime+1
			jmp skipsystemmode
ntsc:		lda #0
			sta system
			lda #$0f
			sta rastime+1
			
			
skipsystemmode:			
.if (testwithnohisaver == 1) {
} else {
           jsr LoadHiScores
}
            // Automatically copy and paste first place hi 
            // score position to the in hi score panel

            ldx #$00
copy1stplaceposscore:
            lda hiscore1,x
            sta hiscoretext,x 
            inx 
            cpx #6
            bne copy1stplaceposscore

            // TODO: Disk loading of hi scores (Where applicable)

			jmp titlescreencode

        .import source "gamecode.asm"