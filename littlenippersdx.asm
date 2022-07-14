/*-------------------------------------
           LITTLE NIPPERS DX
		   
A fun summer themed hi score attack 
challenge, based on the original 4K
Craptastic 2022 compo entry coded in 
KickAssembler.
	
	CODE AND SOUND: RICHARD BAYLISS
	GRAPHICS:		HUGUES POISSEROUX
	MUSIC:          RICHARD BAYLISS
	
       (C)2022 THE NEW DIMENSION
https://richard-tnd.itch.io/littlenippers
--------------------------------------*/
.var cheatmode = 0
.var testwithnohisaver = 1

// Variables & constants

.label screen = $0400
.label colour = $d800 
.label scorepos = $07c6 
.label targetpos = $07d4
.label misspos = $07dc
.label hiscorepos = $07e2
.label titlestart = $054c
.label levelposition = $07cf
.label skilllevelcharposition = $05fd
.label musicinit = $7000
.label musicplay = $7003
.label tscreen = $c400
.label endscreen = $1200
.label decruncher = $1800
.label decrunchaddrlo = $1810
.label decrunchaddrhi = $1811
.label gamescreen = $6800 
.label attribs = $6c00

.label crab_pos_x1 = $10
.label crab_pos_x2 = $24
.label crab_pos_x3 = $38
.label crab_pos_x4 = $4c
.label crab_pos_x5 = $60
.label crab_pos_x6 = $74
.label crab_pos_x7 = $88
.label crab_pos_x8 = $9c

.label collisionleft = $06
.label collisionright = $0c
.label collisiontop = $0c
.label collisionbottom = $18

.label runner_height1 = $40
.label runner_height2 = $50
.label runner_height3 = $60 
.label runner_height4 = $70 
.label runner_height5 = $80 
.label runner_height6 = $90 
.label runner_height7 = $a0

.label sprite_10seconds = $c0
.label sprite_0seconds = $ca

.label title_music = $00
.label get_ready_jingle = $01 
.label game_over_jingle = $02
.label well_done_jingle = $03
.label hi_score_music = $04

.label scorelen = 6
.label namelen = 9
.label listlen = 10

.label nobonusspr = $3ea0
.label bonusx2spr = $32f0
.label bonusx3spr = $3330
.label bonusx4spr = $3370
.label bonusx5spr = $33b0

.label scoresprite1 = $2e70 
.label scoresprite2 = $2eb0
.label scoresprite3 = $2ef0 
.label scoresprite4 = $2f30
.label scoresprite5 = $2f70
.label scoresprite6 = $2fb0
.label scoresprite7 = $2ff0
//--------------------------------------

// Basic 16384
BasicUpstart2(CodeStart)

.if (testwithnohisaver == 1)
{
} else {
	* = $1000 "DISK LOADER/SAVER RTNS"
	.import source "diskaccess.asm" 
}
//--------------------------------------
	* = $1200 "END SCREEN"
	.import binary "c64/endscreen.bin"
	
//--------------------------------------

	
	
	* = $1800 "EXOMIZER DECRUNCH ROUTINE"
	.import c64 "c64/exodecruncher.prg"

//--------------------------------------
	
	* = $1a00 "LEVEL 5 CRUNCHED GFX"
beach5chars:
	.import c64 "beachcharset5.prg"
beach5charsend: .byte 0

beach5screen:
	.import c64 "beachscreen5.prg"
beach5screenend: .byte 0

beach5attribs:
	.import c64 "beachattribs5.prg"
beach5attribsend: .byte 0

//--------------------------------------	

// Main game sprite data
			* = $2000 "SPRITES"
	.import binary "c64/gamesprites.bin"
//--------------------------------------
			* = $3400
			.import source "ending.asm"
//--------------------------------------
// Status panel data 

			* = $3800 "PANEL 1X1 CHARSET"
 .import binary "c64/statuscharset.bin"
//--------------------------------------
			* = $3c00 "PANEL COLOUR ATTRIBUTES"
statusattribs:			
 .import binary "c64/statusattribs.bin"
statusmap:
 .import binary "c64/statuspanelmap.bin"
//--------------------------------------
//Main code (Should be small enough 
//to fit.
			* = $4000 "GAME CODE"
	
	.import source "onetime.asm"
//--------------------------------------
// Compressed game data
//--------------------------------------
// Crunched data 
	*=* "LEVELS 1 TO 3 CRUNCHED DATA"
	
	 	 
beach1chars:
	.import c64 "beachcharset1.prg"
beach1charsend: .byte 0 
	 
beach1screen:
	.import c64 "beachscreen1.prg"
beach1screenend: .byte 0 
	 
beach1attribs:
	.import c64 "beachattribs1.prg"
beach1attribsend: .byte 0 
	 	 
beach2chars:
	.import c64 "beachcharset2.prg"
beach2charsend: .byte 0 
	  
beach2screen:
	.import c64 "beachscreen2.prg"
beach2screenend: .byte 0 
	 	 
beach2attribs:
	.import c64 "beachattribs2.prg"
beach2attribsend: .byte 0
 	 
beach3chars:
	.import c64 "beachcharset3.prg"
beach3charsend: .byte 0 
	 	 
beach3screen:
	.import c64 "beachscreen3.prg"
beach3screenend: .byte 0 
	 	  
beach3attribs:
	.import c64 "beachattribs3.prg"
beach3attribsend: .byte 0 

//--------------------------------------	
//--------------------------------------	

	 
	 
//--------------------------------------	
// Title music 
			* = $7000 "MUSIC"
	.import c64 "c64/music.prg"
	
			*= $8100 "END SCROLL TEXT ...   "
	
endscroll:
	.text "£££ congratulations £££ "
	.text "you have completed a full skill "
	.text "level of ££££££ little nippers deluxe ££££££   "
	.text "you will now move to a new location where "
	.text "there will be less crabs at your disposal "
	.text "but even more points to be scored £££    "
	.text "press spacebar or fire to continue £££          "
	.text "                                                "
	.byte 0
	
endscroll2:
	.text "£££ congratulations £££ you have completed "
	.text "££££££ little nippers deluxe ££££££    there are "
	.text "no more locations to go to and the crabs and jell"
	.text "yfish are very pleased that it is now raining £££"
	.text "   no pesky kids are around to disturb them £££  "
	.text "now is the time to check if you have scored a hi "
	.text "score position £££    press spacebar or fire to "
	.text "continue £££                                     "
	.byte 0
//--------------------------------------
// Title logo video RAM 
	* = $8400 "LOGO VIDEO RAM"
logoscreen:
	.import c64 "c64/logo_vidram.prg"
//--------------------------------------	
// Title logo colour RAM 
	* = $8800 "LOGO COLOUR RAM"
logocolour:
	.import c64 "c64/logo_colram.prg"	
//--------------------------------------	
// Title code (including hi score detection)
	* = $9000 "TITLE SCREEN CODE"
	.import source "titlescreen.asm"
	* = $9b00 "HI SCORE TABLE CODE"
	.import source "hiscore.asm"
//--------------------------------------
	
//--------------------------------------	
// Title logo bitmap
	* = $a000 "LOGO BITMAP"
	.import c64 "c64/logo_bitmap.prg"
//--------------------------------------


* = $c800 "LEVEL 4 CRUNCHED GRAPHICS"
beach4chars:
	.import c64 "beachcharset4.prg"
beach4charsend: .byte 0

beach4screen:
	.import c64 "beachscreen4.prg"
beach4screenend: .byte 0

beach4attribs:
	.import c64 "beachattribs4.prg"
beach4attribsend: .byte 0


	
	
	
	
//--------------------------------------
// Screen memory for title screen to be
// set to BANK 0, $c400-$c7e8
// 2x2 for title screen charset 
	* = $e000 "Titlescreen Charset"
	.import c64 "c64/2x2charset.prg"
//--------------------------------------

