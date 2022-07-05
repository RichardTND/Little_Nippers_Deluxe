CodeStart:

onetimepncheck:			
mode1:		lda $d012 
mode2:		cmp $d012 
			beq mode2
			bmi mode1
			cmp #$20 
			bcc ntsc 
			lda #$01
			sta system 
			jmp skipsystemmode
ntsc:		lda #0
			sta system
			
			
skipsystemmode:			

           jsr LoadHiScores
            // Automatically copy and paste first place hi 
            // score position to the in hi score panel

            ldx #$00
copy1stplaceposscore:
            lda hiscore1,x
            sta hiscoretext,x 
            inx 
            cpx #scorelen 
            bne copy1stplaceposscore

            // TODO: Disk loading of hi scores (Where applicable)

			jmp titlescreencode

        .import source "gamecode.asm"