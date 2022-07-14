//Hi-score saver/loader routine

dname:	.text "S:" //Indicate SCRATCH previous filename (If file on disk exists)
fname:	.text "THE BEST CRABS"
.const fnamelen = *-fname //Length of filename
.const dnamelen = *-dname //Deletion of filename

//Hi score table to be saved to disk. Before that can be done
//stop all interrupts from playing. Then save the filename
//HI SCORE TABLE to disk.

SaveHiScore:
			jsr KillAllInterrupts 
			jsr savefile
			
//After finishing saving hi score table - or tape version]			
//detected. Execute main program			
			
SkipHiScoreSaver:
			rts

//This subroutine loads in high scores. Before that can
//be done. Switch off the screen (for a professional 
//load) then load the filename HI SCORE TABLE to disk.
//Should it not exist. A filename HI SCORE TABLE should
//be written.
			
LoadHiScores:
			lda #0 		//After decrunching the program
			sta $d020	//Force black screen+border
			sta $d021
			lda #$0b
			sta $d011 //Screen off
			jsr loadfile	//Then load filename.
			
SkipHiScoreLoader:
			rts

savefile:	lda #$0b
			sta $d011 //Screen off
			
			//If this game is loaded from tape, the
			//saver / loader for the hi score table will
			//skip
			
			ldx device		//Check device already used.
			cpx #$08 	//Note. Refer to 1541 Users manual
			bcc skipsave //to understand drive commands.
			lda #$0f 
			tay
			jsr $ffba
			jsr resetdevice
			lda #dnamelen 
			ldx #<dname 
			ldy #>dname 
			jsr $ffbd 	
			jsr $ffc0
			lda #$0f 
			jsr $ffc3 
			jsr $ffcc
			
			lda #$0f 
			ldx device 
			tay
			jsr $ffba 
			jsr resetdevice
			lda #fnamelen 	//Length of filename
			ldx #<fname 	//Lo byte address of filename
			ldy #>fname 	//Hi byte address of filename
			jsr $ffbd 
			lda #$fb 
			ldx #<HiScoreTableStart	//Lo-byte of start address of hiscore table
			ldy #>HiScoreTableStart //Hi-byte of start address of hiscore table
			stx $fb			 
			sty $fc 
			ldx #<HiScoreTableEnd	//Lo byte of end address for hiscore  
			ldy #>HiScoreTableEnd	//Hi byte of end address for hiscore
			jsr $ffd8
skipsave:
			rts
			
//Load filename from current device. If the device			
//however is from TAPE, ignore it!			
			
loadfile:
			ldx device 
			cpx #$08 
			bcc skipload 
			
			lda #$0f 
			tay 
			jsr $ffba 
			jsr resetdevice 
			lda #fnamelen 
			ldx #<fname 
			ldy #>fname
			jsr $ffbd
			lda #$00 
			jsr $ffd5 
			bcc loaded
			jsr savefile
loaded:
skipload:	rts

//Initalise disk drive

resetdevice:
			lda #$01 
			ldx #<initdrive
			ldy #>initdrive
			jsr $ffbd 
			jsr $ffc0 
			lda #$0f 
			jsr $ffc3 
			jsr $ffcc
			rts
			
KillAllInterrupts:
			sei
			lda #$00
			sta $d01a
			sta $d019 
			lda #$81
			sta $dc0d 
			sta $dd0d 
			ldx #$48
			ldy #$ff
			stx $fffe
			sty $ffff 
			lda #$00
nosn:		sta $d400,x
			inx
			cpx #$18
			bne nosn
			lda #$37
			sta $01
			jsr $e3bf
			
			cli 
			rts
initdrive:
			.text "I:"
			
device:		.byte 0