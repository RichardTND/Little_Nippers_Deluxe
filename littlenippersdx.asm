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

// Variables & constants
.var ready_to_crunch = 0 //Change to 1 when ready to use Exomizer
.var cheatmode = 0
.const screen = $0400
.const colour = $d800 
.const scorepos = $07c6 
.const targetpos = $07d4
.const misspos = $07dc
.const hiscorepos = $07e2
.const titlestart = $054c
.const levelposition = $07cf
.const skilllevelcharposition = $05fd
.const musicinit = $1000
.const musicplay = $1003

.var crab_pos_x1 = $10
.var crab_pos_x2 = $24
.var crab_pos_x3 = $38
.var crab_pos_x4 = $4c
.var crab_pos_x5 = $60
.var crab_pos_x6 = $74
.var crab_pos_x7 = $88
.var crab_pos_x8 = $9c

.var collisionleft = $06
.var collisionright = $0c
.var collisiontop = $0c
.var collisionbottom = $18

.var runner_height1 = $40
.var runner_height2 = $50
.var runner_height3 = $60 
.var runner_height4 = $70 
.var runner_height5 = $80 
.var runner_height6 = $90 
.var runner_height7 = $a0

.var sprite_10seconds = $c0
.var sprite_0seconds = $ca

.var title_music = $00
.var get_ready_jingle = $01 
.var game_over_jingle = $02
.var well_done_jingle = $03
//--------------------------------------
// Main game charset data 

.if (ready_to_crunch==1) {
		* = $0800 "GAME SCREEN CHARSET"
gamecharset:
	.import binary "c64/gamecharset.bin"
} else {
// Basic 16384
BasicUpstart2(CodeStart)
}
// Title music 
			* = $1000 "MUSIC"
	.import c64 "c64/music.prg"
//--------------------------------------
// Main game sprite data
			* = $2000 "SPRITES"
	.import binary "c64/gamesprites.bin"
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
// Charset attributes data
			* = * "GAME SCREEN COLOUR ATTRIBUTES"
attribs:	
	.import binary "c64/gameattribs.bin"
//--------------------------------------	
// Game screen data
			* = * "GAME SCREEN"
gamescreen:	
	.import binary "c64/gamescreen.bin"
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
// Title code 
	* = $9000 "TITLE SCREEN CODE"
	.import source "titlescreen.asm"
//--------------------------------------	
// Title logo bitmap
	* = $a000 "LOGO BITMAP"
	.import c64 "c64/logo_bitmap.prg"
//--------------------------------------
// Screen memory for title screen to be
// set to BANK 0, $c400-$c7e8
// 2x2 for title screen charset 
	* = $e000 "Titlescreen Charset"
	.import c64 "c64/2x2charset.prg"
//--------------------------------------

.if (ready_to_crunch ==1) {

} else {
	* = $f000 "GAME SCREEN CHARSET"
}
gamecharset:
	.import binary "c64/gamecharset.bin"
//--------------------------------------	