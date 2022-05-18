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

            // Disable the kernal and then grab the charset from $f000 and put at $0800
            sei

.if (ready_to_crunch==1) {
} else {            
            lda #$34
            sta $01

            ldx #$00
grabcharset:
            lda gamecharset,x 
            sta $0800,x 
            lda gamecharset+$100,x 
            sta $0900,x 
            lda gamecharset+$200,x
            sta $0a00,x 
            lda gamecharset+$300,x 
            sta $0b00,x 
            lda gamecharset+$400,x 
            sta $0c00,x 
            lda gamecharset+$500,x
            sta $0d00,x 
            lda gamecharset+$600,x 
            sta $0e00,x 
            lda gamecharset+$6ff,x 
            sta $0eff,x 
            inx 
            bne grabcharset

            lda #$37 
            sta $01 
            cli
}
            // TODO: Disk loading of hi scores (Where applicable)

			jmp titlescreencode

        .import source "gamecode.asm"