// Game code start.

// Initialise all interrupt registers and default pointers. 

gamecode:	sei
			lda #$00 
			sta $d01a 
			sta $d019 
			sta $d017 
			sta $d01d
			sta $d015
			lda #$0b
			sta $d011
			lda #$81 
			sta $dc0d 
			sta $dd0d
			ldx #$48 
			ldy #$ff
			stx $fffe 
			sty $ffff 
			lda #$03
			sta $dd00 
			lda #$18
			sta $d016
			lda #$1e 
			sta $d018
			
			lda #0
			sta levelpointer
			
//Init new game start only score and other pointers

			jsr clearscreenaway
			 
			 // Default some in game pointers 
			ldx #$00
clearspeed:
			lda #1
			sta runner_speed_table,x 
			inx 
			cpx #16
			bne clearspeed
			lda #0
			sta levelpointer

			// Completely initialise the score 

			ldx #$00
zeroscores: lda #$30
			sta scoretext,x
			sta virtualscore,x
			inx 
			cpx #$06
			bne zeroscores 
			lda #0
			sta firebutton
			 

			// 2x2 charset mode before IRQs are in place

			lda #$18 
			sta $d018
			lda #$08
			sta $d016
			lda #$00
			sta $d020
			lda #$00
			sta $dd00
			lda #$1b 
			sta $d011
			
			// Fill screen colour to light grey 			

			ldx #$00
fillgrey:
			lda #$0f
			sta $d800,x
			sta $d900,x
			sta $da00,x
			sta $dae8,x

			inx 
			bne fillgrey

// This raster loop is used to time the in game options selector
// and also continue playing the music from the title screen	
// until the player has pressed fire to play.

waitstart:	
			lda #$f8
			cmp $d012
			bne *-3
			jsr musicplayer
			jsr optionselector
			jsr skillselector
			
			lda $dc00 
			lsr
			lsr
			lsr
			lsr
			lsr
			bit firebutton
			ror firebutton
			bmi waitstart2
			bvc waitstart2
			jmp playsetup
			
waitstart2: lda $dc01 
			lsr 
			lsr 
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi waitstart 
			bvc waitstart
			jmp playsetup 

// Display options screen text 

optionselector:
			
			ldx #$00
			ldy #$00
settext:	lda line1,x
			sta $c400 + (4 * 40),y 
			clc
			adc #$40
			sta $c400 + (4 * 40)+1,y
			adc #$40
			sta $c400 + (5 * 40),y 
			adc #$40
			sta $c400 + (5 * 40)+1,y
			lda line2,x 
			sta $c400 + (7 * 40),y 
			clc
			adc #$40 
			sta $c400 + (7 * 40)+1,y 
			adc #$40 
			sta $c400 + (8 * 40),y 
			adc #$40
			sta $c400 + (8 * 40)+1,y
			lda line3,x
			sta $c400 + (12*40),y
			clc
			adc #$40
			sta $c400 + (12*40)+1,y 
			adc #$40 
			sta $c400 + (13*40),y 
			adc #$40 
			sta $c400 + (13*40)+1,y 
			lda line4,x 
			sta $c400 + (16*40),y 
			clc
			adc #$40 
			sta $c400 + (16*40)+1,y
			adc #$40 
			sta $c400 + (17*40),y 
			adc #$40 
			sta $c400 + (17*40)+1,y
			iny
			iny
			inx 
			cpx #20
			bne settext 
			rts

// Skill level selector code

skillselector:
			
			lda joydelay 
			cmp #8
			beq selectoron
			inc joydelay 
			rts 
selectoron:
			lda #0
			sta joydelay 
			
			lda #1 // UP PORT 2
			bit $dc00 
			beq skilllevelup
			
			lda #1 // UP PORT 1
			bit $dc01 
			beq skilllevelup 
			
			lda #2 // DOWN PORT 2
			bit $dc00 
			beq skillleveldown 
			
			lda #2 // DOWN PORT 2 
			bit $dc01 
			beq skillleveldown 
			rts 
			
skilllevelup:
			 
			inc skilllevel 
			lda skilllevel
			cmp #5
			beq stayas5
			lda skilllevel 
			clc
			adc #$31
			sta skilllevelchar
		
			rts 
stayas5:	lda #4
			sta skilllevel
			clc 
			adc #$31
			sta skilllevelchar
			rts
skillleveldown:
			dec skilllevel 
			lda skilllevel 
			cmp #$ff
			beq stayas0
			clc
			adc #$31
			sta skilllevelchar
			rts
stayas0:	lda #0
			sta skilllevel
			clc
			adc #31
			sta skilllevelchar
			
			rts

// Main game initialise

playsetup:	lda #$0b 
			sta $d011		
			ldx #$00
clearsid:	lda #$00
			sta $d400,x 
			inx 
			cpx #$18 
			bne clearsid
			
			lda #$0f
			sta $d418
			
			lda #0
			sta sounddelay
			lda #0
			sta soundpointer
			
			// Enable multicolour graphics 
			// and set title screen 2x2 charset 
			// to the self-modifying code inside IRQ
			// This is for the GET READY screen.

			lda #$18
			sta $d016
			lda #$18
			sta charsm+1
			lda #$00 
			sta banksm+1

			jsr waitdelay
			lda #7
			sta $d020 
			sta $d021 
			lda #$0c 
			sta $d022
			lda #$01 
			sta $d023 
			lda #$0a 
			sta $d025 
			lda #$01
			sta $d026
			lda #$00
			sta $d015
			lda #$ff
			sta $d01c
			lda #$02
			sta $d027
			ldx #$fb
			txs
			lda #0
			sta snappysound
			sta snappysoundpointer
			
			
// Build complete game IRQ raster interrupts 

			lda #$35
			sta $01
			ldx #<gameirq 
			ldy #>gameirq
			lda #$7f
			stx $fffe
			sty $ffff
			ldx #<titlescreencode
			ldy #>titlescreencode
			stx $fffa
			sty $fffb
			stx $fffc
			sty $fffd
			sta $dc0d 
			sta $dd0d
			lda #$2a
			sta $d012
			lda #$1b
			sta $d011 
			lda #$01
			sta $d01a
			sta $d019

			// Play GET READY jingle 

			lda #get_ready_jingle
			jsr musicinit 

			cli 
			jmp mainstart
		
// Main gameirq double raster interrupt. 

gameirq:	sta stacka+1
			stx stackx+1
			sty stacky+1
			asl $d019 
			lda $dc0d 
			sta $dd0d 
			lda #$00
			sta $d012
			
			lda #$1e
			sta $d018
			lda #$08
			sta $d016 
			lda #$03
			sta $dd00 
			
			lda #1
			sta rt 
			jsr animation
			lda jingles_allowed_to_play 
			beq sfxonly 
			jmp musiconly
sfxonly:
			jsr sfxplayer
			jmp skipmusic
musiconly:
			jsr musicplayer
skipmusic:
			ldx #<gameirq2
			ldy #>gameirq2
			stx $fffe
			sty $ffff
stacka:		lda #0
stackx:		ldx #0
stacky:		ldy #0
nmilock:	rti

gameirq2:	sta stacka2+1
			stx stackx2+1
			sty stacky2+1
			asl $d019 
			lda #$f0 
			sta $d012 
charsm:		lda #$12
			sta $d018 
			lda #$18
			sta $d016
banksm:		lda #$00
			sta $dd00
			
			ldx #<gameirq
			ldy #>gameirq 
			stx $fffe
			sty $ffff 
stacka2:	lda #$00
stackx2:	ldx #$00
stacky2:	ldy #$00
			rti

// Main start (init stuff) then set up the GET READY text

mainstart:  lda #$03
			sta $dd00
			lda #0
			sta firebutton
			lda #$12
			sta charsm+1
			lda #%11111111
			sta $d015
			lda #$80
			sta $07f8
			lda #0
			sta crab_place_pointer
			sta splashdelay
			sta crabinwater
			lda #0
			sta objpos+14
			sta objpos+15
			sta snappysound
			sta snappysoundpointer
			
			ldx #$00
setstartpos:
			lda startpos,x
			sta objpos,x 
			inx 
			cpx #16
			bne setstartpos
			jsr expandmsb
		
			jsr setnewpositionr1
			jsr setnewpositionr2
			jsr setnewpositionr3
			lda #$ff
			sta $d015	
skillloop:			
			ldy skilllevel
			lda skillleveltable1,y
			sta skillsm1+1
			lda skillleveltable2,y
			sta skillsm2+1
			iny
			cpy #6
			beq resetskilllevelnow
			jmp skillsm1 
resetskilllevelnow:
			ldy #0
			sty skilllevel
			jmp skillloop
			
skillsm1:	lda #$32
			sta missedtext
skillsm2:	lda #$30
			sta missedtext+1
			
			ldx levelpointer
			lda level_quota_table1,x
			sta quotatext
			lda level_quota_table2,x
			sta quotatext+1
			lda level_speed_table_lo,x
			sta storspd+1
			lda level_speed_table_hi,x 
			sta storspd+2
			
			ldx #$00
storspd:	lda level1_speedtable,x
			sta runner_speed_table,x
			inx 
			cpx #16
			bne storspd
			jsr drawgamescreen
			jsr updatepanel
			lda levelpointer 
			clc 
			adc #$31
			sta levelposition
			lda #sprite_10seconds
			sta spriteSM+1
			lda #1 
			sta jingles_allowed_to_play


			// Disable the jellyfish option at start of a new game 

			lda #0 
			sta jellyfish_enabled
			sta penalty_enabled
			sta crab_released
			sta time_delayMS
			sta firebutton

			// Setup the GET READY screen colour and sprite and other bits

			lda #$07
			sta $d020
			lda #$07
			sta $d021
			ldx #$00
grcol:		lda #$20
			sta $c400,x 
			sta $c500,x 
			sta $c600,x 
			sta $c6e8,x 
			lda #$02
			sta $d800,x
			sta $d900,x
			sta $da00,x 
			sta $dae8-40,x
			inx 
			bne grcol
			lda #0
			sta $d015
			ldx #$00
			ldy #$00
setgrtext:  lda getreadytext,x 
			sta $c400+(10*40),y
			adc #$40 
			sta $c400+(10*40)+1,y
			adc #$40
			sta $c400+(11*40),y 
			adc #$40
			sta $c400+(11*40)+1,y 
			iny
			iny
			inx
			cpx #20
			bne setgrtext
			lda #$18
			sta charsm+1
			jsr waitdelay

// The GET READY screen is now running, wait for the
// fire button and spacebar to be pressed in order
// to start the game.

waittoplay:
			lda $dc00
			lsr
			lsr
			lsr
			lsr
			lsr
			bit firebutton
			ror firebutton 
			bmi waittoplay
			bvc waittoplay2
			jmp readytoplaynow
waittoplay2:
			lda $dc01
			lsr
			lsr
			lsr
			lsr
			lsr
			bit firebutton
			ror firebutton
			bmi waittoplay
			bvc waittoplay

// Fire has now been pressed, draw the main game 
// screen, switch off the music player and 
// enable sound effects. Also display the 
// score panel charset.

readytoplaynow:
			lda #0
			sta firebutton
			jsr drawgamescreen
			ldx #$00
drawscore:  ldy statusmap,x 
			lda statusattribs,y
			sta $dbc0,x 
			inx
			cpx #$28 
			bne drawscore	
			jsr updatepanel		
			lda #$07
			sta $d020 
			sta $d021
			lda #$03
			sta banksm+1
			lda #$12
			sta charsm+1
			lda #0
			sta jingles_allowed_to_play
			ldx #$00
initsidfx:  lda #$00
			sta $d400,x
			inx
			cpx #$18
			bne initsidfx
			lda #$0f
			sta $d418
			jsr sfx_gamestart
			lda #$ff
			sta $d015
// Main synchronized game loop 

mainloop:	jsr synctimer
			
			jsr playercontrol
			
			jmp mainloop 
			
// Synchronize timer with gameirq raster 
// interrupt.

synctimer:	lda #0
			sta rt
			cmp rt 
			beq *-3
			
// Expand sprite MSB also 
		
expandmsb:	ldx #$00
expandloop:	lda objpos+1,x
			sta $d001,x
			lda objpos,x 
			asl 
			ror $d010 
			sta $d000,x 
			inx 
			inx 
			cpx #$10
			bne expandloop
			rts
			
// Animation 

animation:	jsr animsprites 
			jsr animbackground
			jsr runnerscode
			jsr pointsprcode
			rts
// Animate sprites			
			
animsprites:	
			lda spr_anim_delay
			cmp #2
			beq spranimmain 
			inc spr_anim_delay
			rts 
spranimmain:
			lda #0
			sta spr_anim_delay 
			
			ldx spr_anim_pointer
			lda crab_frame,x
			sta crab_spr

			lda boy_right_frame,x
			sta boy_right_spr

			lda boy_left_frame,x
			sta boy_left_spr

			lda boy_right_frame2,x 
			sta boy_right_spr2 

			lda boy_left_frame2,x 
			sta boy_left_spr2

			lda girl_right_frame,x
			sta girl_right_spr

			lda girl_left_frame,x
			sta girl_left_spr

			lda girl_right_frame2,x
			sta girl_right_spr2 

			lda girl_left_frame2,x
			sta girl_left_spr2

			lda boy_body_right_frame,x 
			sta boy_body_right_spr 

			lda boy_body_left_frame,x 
			sta boy_body_left_spr 

			lda boy_body_right_frame2,x 
			sta boy_body_right_spr2

			lda boy_body_left_frame2,x
			sta boy_body_left_spr2

			lda girl_body_right_frame,x 
			sta girl_body_right_spr

			lda girl_body_left_frame,x 
			sta girl_body_left_spr

			lda girl_body_right_frame2,x 
			sta girl_body_right_spr2

			lda girl_body_left_frame2,x 
			sta girl_body_left_spr2

			lda jellyfish_frame,x 
			sta jelly_fish_spr
			inx
			cpx #4
			beq animloop
			inc spr_anim_pointer
			rts 
animloop:	ldx #0
			stx spr_anim_pointer
			rts
					
// In game background animation 

animbackground:
/*
			lda chr_anim_delay
			cmp #3
			beq dochranim
			inc chr_anim_delay 
			rts 
dochranim:	lda #0
			sta chr_anim_delay 
			lda $0800+(76*8)+7
			sta chr_anim_store1
			lda $0800+(77*8)+7
			sta chr_anim_store2 
			ldx #7
scrollchr:	lda $0800+(76*8)-1,x 
			sta $0800+(76*8),x
			lda $0800+(77*8)-1,x 
			sta $0800+(77*8),x 
			dex
			bpl scrollchr 
			lda chr_anim_store1
			sta $0800+(76*8)
			lda chr_anim_store2
			sta $0800+(77*8)
*/
			rts
			
// Player game control 
crabdeathanim:
			lda splash_spr
			sta $07f8
			lda #$0e
			sta $d027
			lda splashdelay
			cmp #20
			beq splashdone
			inc splashdelay
			rts 
splashdone:	lda #0
			sta objpos
			lda #0
			sta crabinwater
			jmp missed 

// Main player control ... If the the crab / jellyfish is in the water 
// call crab splat routine (above). Otherwise wait for
// either the SPACEBAR or FIRE to be pressed to launch
// the crab / jellyfish. Otherwise test failure time interval  

playercontrol:
			
			lda crabinwater
			cmp #1
			beq crabdeathanim
			jsr testcrabmovement
			jsr collider
			lda $dc00 
			lsr
			lsr
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi nofire1
			bvc nofire1

			// Fire has been pressed, so ignore penalty and launch crab / jellyfish

			lda #0
			sta penalty_enabled
			lda #0
			sta objpos+14
			sta objpos+15
			jmp testcrablauncher

nofire1:	lda $dc01
			lsr 
			lsr 
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi nocontrol
			bvc nocontrol

			// Spacebar has also been pressed, so ignore penalty and launch crab / jellyfish
	
			lda #0
			sta objpos+14
			sta objpos+15
			lda #0
			sta penalty_enabled 
			jmp testcrablauncher

nocontrol:	
			// Penalty test 
			// If the crab / jellyfish has NOT been released
			// perform the time check before it is released
			// automatically.

testpenalty:
			lda crab_released 
			bne nopenalty
			inc time_delayMS
			lda time_delayMS
			cmp #$30
			beq countinseconds
			rts 

countinseconds:
			lda #0
			sta time_delayMS 
			ldx crab_place_pointer
			lda crab_order_table,x
			sta objpos+14
			lda #$d4
			sta objpos+15
spriteSM:
			lda #sprite_10seconds		
			sta $07ff
			lda #0
			sta $d02e
			inc spriteSM+1
			lda spriteSM+1
			cmp #sprite_0seconds
			beq setup_fail
			cmp #sprite_0seconds+1 
			beq out
			jmp nopenalty

			// Time is up. Automatically the make crab / jellyfish
			// enter the sea and lose a life. 

setup_fail: jsr sfx_fail
			lda #sprite_0seconds
			sta $07ff
			lda #1
			sta penalty_enabled
			
			rts

			// Crab is launched before time runs out, so okay.
out:
			lda #0
			sta objpos+14
			sta objpos+15
			jmp launchcrab

nopenalty:			
			rts


// Check if crab Y position is offset 
// if so, then a crab is ready for 
// launching.

testcrablauncher:

			lda #0
			sta firebutton
			lda objpos
			beq launchcrab
			jmp nocontrol

// Crab is okay to be launched. Call 
// the table read routine for crab 
// launching 

launchcrab:
			jsr sfx_launchcrab
			lda #1
			sta crab_released

			lda #1
			sta snappysound
			ldx crab_place_pointer
			lda crab_order_table,x
			sta objpos
			lda #$d4
			sta objpos+1
			inx 
			cpx #8
			beq reset
			inc crab_place_pointer
			rts 
reset:		ldx #0
			stx crab_place_pointer
			rts
			
// Test the crab movement, if position 
// X and Y <> 0 then the crab can move 

testcrabmovement:			
			
			lda objpos
			beq skip
			 
testcrabposy:			
			lda objpos+1
			bne movecrab
skip:		rts

// Crab/jellyfish can move. Make it move up 
// until it reaches the sea or hits 
// a runner's buttom half.

movecrab:	lda jellyfish_enabled
			cmp #1 
			bne objectiscrab
			lda jelly_fish_spr
			sta $07f8 
			lda #$04
			sta $d027 
			jmp movementloop
objectiscrab:						
			lda crab_spr
			sta $07f8 
			lda #$02
			sta $d027

			// The crab / jellyfish is moving

movementloop:
			ldy objpos+1
			dey
			dey 
			cpy #$32
			bcs updateposy
			lda #0
			sta snappysound

			// Ensure crab is offset, but still moves to the top 

			lda objpos
			beq skip_fail
			jsr sfx_crabsplash
			lda #$00
			sta splashdelay
			sta jellyfish_enabled
			lda #1
			sta crabinwater
			jmp nextS
			
skip_fail:	lda #0 
			sta crab_released
			sta penalty_enabled
			ldy #0
			sty objpos+1
			sty objpos
nextS:			
			lda #0
			sta time_delayMS
			lda #sprite_10seconds
			sta spriteSM+1	
		 
			rts
			
updateposy:	sty objpos+1
		    
			rts
			
// The crab jumps into the water 
// add a value to the missed counter 
// After reached 20, game over

missed:		
.if (cheatmode==1) {
} else {
			dec missedtext+1
			lda missedtext+1
			cmp #$2f
			bne misscheck 
			lda #$39
			sta missedtext+1
			dec missedtext
misscheck:	lda missedtext+1
			cmp #$30
			beq misscheck2
			jmp missok
misscheck2:	lda missedtext 
			cmp #$30 
			beq gamelost
}
			jmp missok
			
gamelost:			
			jsr clearscreenaway
			jsr sfx_gameover
			jmp gameover
missok:		jsr updatepanel
			rts 
			
// The total number of misses has 
// expired. The game is over.

gameover:	
			jsr clearscreenaway
			ldx #$00
settored:	lda #$02
			sta $d800,x
			sta $d900,x
			sta $da00,x
			sta $dae8,x
			inx 
			bne settored
			
			lda #$00
			sta banksm+1
			lda #$18
			sta charsm+1

			// Display game over text 

			ldx #$00
			ldy #$00
showgameover:
			lda gameovertext,x
			sta $c400+(10*40),y
			clc
			adc #$40 
			sta $c400+(10*40)+1,y
			adc #$40 
			sta $c400+(11*40),y 
			adc #$40 
			sta $c400+(11*40)+1,y
			iny
			iny
			inx
			cpx #20 
			bne showgameover
			lda #1 
			sta jingles_allowed_to_play
			lda #2 
			jsr musicinit
			
			lda scoretext
			sec 
			lda hiscoretext+5
			sbc scoretext+5
			lda hiscoretext+4
			sbc scoretext+4
			lda hiscoretext+3
			sbc scoretext+3
			lda hiscoretext+2
			sbc scoretext+2
			lda hiscoretext+1
			sbc scoretext+1
			lda hiscoretext
			sbc scoretext 
			bpl skiphi 
			
			
			ldx #$00
makehiscore: 
			lda scoretext,x
			sta hiscoretext,x
			inx 
			cpx #6
			bne makehiscore
			
skiphi:		jsr updatepanel			
			
			lda #$00
			sta $d015
			ldx #$00
plotgameover:
			lda gameovertext,x 
			sta titlestart+80,x
			lda #2
			sta titlestart+$d400+80,x
			inx
			cpx #20
			bne plotgameover 

			lda #0
			sta firebutton 
			jsr waitdelay
goloop:		jsr synctimer
			
			lda $dc00 
			lsr
			lsr
			lsr
			lsr
			lsr
			bit firebutton
			ror firebutton
			bmi goloop1
			bvc goloop1
			jmp checkforhiscore
goloop1:	lda $dc01 
			lsr
			lsr
			lsr
			lsr
			lsr
			bit firebutton
			ror firebutton
			bmi goloop
			bvc goloop
			jmp checkforhiscore
					
// Runners code 

			//Setup runner 1
runnerscode:
			jsr runner1
			jsr runner2 
			jsr runner3
			rts 
			
runner1:	
			//When not hit, head on body
			lda objpos+3
			clc
			adc #18
			sta objpos+5
			
runner1frame1:
			lda boy_left_spr
			sta $07f9
runner1frame2:
			lda body_left_spr
			sta $07fa
runner1colour1:
			lda #$00  //Hair colour
			sta $d028
runner1colour2: 
			lda #$06  //Shorts colour
			sta $d029
			lda runner_dir1
			beq runner1left 
			jmp runner1right 
			
runner1left:
			lda objpos+2
			sec 
			sbc runner_speed1
			cmp #$f0 
			bcc storerunner1left
			jmp setnewpositionr1
storerunner1left:			
			sta objpos+2
			sta objpos+4
			rts 
runner1right:
			lda objpos+2
			clc
			adc runner_speed1
			cmp #$b0
			bcc storerunner1right 
			jmp setnewpositionr1 
storerunner1right:
			sta objpos+2
			sta objpos+4
			rts
setnewpositionr1:
			jsr randomread
			and #$0f
			sta selectpointer1
			ldx selectpointer1
			lda head_type_table_lo,x 
			sta runner1frame1+1
			lda head_type_table_hi,x 
			sta runner1frame1+2
			lda body_type_table_lo,x
			sta runner1frame2+1
			lda body_type_table_hi,x 
			sta runner1frame2+2
			
			lda hair_colour_table,x
			sta runner1colour1+1
			lda shorts_colour_table,x
			sta runner1colour2+1
			
			lda direction_table,x
			sta runner_dir1
			lda runner_speed_table,x 
			sta runner_speed1
			
			jsr randomread
			sta selectpointer1
			ldx selectpointer1
			lda runner_start_ypos_table,x
			sta objpos+3
			lda runner_dir1 
			beq storeleftrunner1 
			lda #$00
			sta objpos+2
			sta objpos+4
			rts
storeleftrunner1:
			lda #$aa
			sta objpos+2
			sta objpos+4
			rts
			
			// Runner 2

runner2:	
			//When not hit, head on body
			lda objpos+7
			clc
			adc #18
			sta objpos+9
			
runner2frame1:
			lda girl_right_spr
			sta $07fb
runner2frame2:
			lda body_right_spr
			sta $07fc
runner2colour1:
			lda #$02  //Hair colour
			sta $d02a
runner2colour2: 
			lda #$04  //Shorts colour
			sta $d02b
			lda runner_dir2
			beq runner2left 
			jmp runner2right 
			
runner2left:
			lda objpos+6
			sec 
			sbc runner_speed2
			cmp #$e0 
			bcc storerunner2left
			jmp setnewpositionr2
			
storerunner2left:			
		
			sta objpos+6
			sta objpos+8
			rts 
runner2right:
			 
			lda objpos+6
			clc
			adc runner_speed2
			cmp #$b0
			bcc storerunner2right 
			jmp setnewpositionr2
storerunner2right:
			sta objpos+6
			sta objpos+8
			rts
setnewpositionr2:
			 
			jsr randomread
			and #$0f
			sta selectpointer2
			ldx selectpointer2
			lda head_type_table_lo,x 
			sta runner2frame1+1
			lda head_type_table_hi,x 
			sta runner2frame1+2
			lda body_type_table_lo,x
			sta runner2frame2+1
			lda body_type_table_hi,x 
			sta runner2frame2+2
			
			lda hair_colour_table,x
			sta runner2colour1+1
			lda shorts_colour_table,x
			sta runner2colour2+1
			
			lda direction_table,x
			sta runner_dir2
			lda runner_speed_table,x 
			sta runner_speed2
			jsr randomread
			sta selectpointer2
			ldx selectpointer2
			lda runner_start_ypos_table,x
			sta objpos+7
			lda runner_dir2
			beq storeleftrunner2
			lda #$00
			sta objpos+6
			sta objpos+8
			rts
storeleftrunner2:
			lda #$aa
			sta objpos+6
			sta objpos+8
			rts
				
			// Runner 3

runner3:	
			//When not hit, head on body
			lda objpos+11
			clc
			adc #18
			sta objpos+13
			
runner3frame1:
			lda boy_left_spr
			sta $07fd
runner3frame2:
			lda body_left_spr
			sta $07fe
runner3colour1:
			lda #$06  //Hair colour
			sta $d02c
runner3colour2: 
			lda #$02  //Shorts colour
			sta $d02d
			lda runner_dir3
			beq runner3left 
			jmp runner3right 
			
runner3left:
			lda objpos+10
			sec 
			sbc runner_speed3
			cmp #$f0
			bcc storerunner3left
			jmp setnewpositionr3
			
storerunner3left:			
			sta objpos+10
			sta objpos+12
			rts 
runner3right:
			lda objpos+10
			clc
			adc runner_speed3
			cmp #$b0
			bcc storerunner3right 
			jmp setnewpositionr3
			
storerunner3right:
			sta objpos+10
			sta objpos+12
			rts
setnewpositionr3:
			jsr randomread
			and #$0f
			sta selectpointer3
			ldx selectpointer3
			lda head_type_table_lo,x 
			sta runner3frame1+1
			lda head_type_table_hi,x 
			sta runner3frame1+2
			lda body_type_table_lo,x
			sta runner3frame2+1
			lda body_type_table_hi,x 
			sta runner3frame2+2
			
			lda hair_colour_table,x
			sta runner3colour1+1
			lda shorts_colour_table,x
			sta runner3colour2+1
			
			lda direction_table,x
			sta runner_dir3
			lda runner_speed_table,x 
			sta runner_speed3
			
			jsr randomread
			sta selectpointer3
			ldx selectpointer3
			lda runner_start_ypos_table,x
			sta objpos+11
			lda runner_dir3
			beq storeleftrunner3
			lda #$00
			sta objpos+10
			sta objpos+12
			rts
storeleftrunner3:
			lda #$aa
			sta objpos+10
			sta objpos+12
			rts

// Random routine 

randomread:	lda random+1
			sta randtemp 
			lda random 
			asl 
			rol randtemp 
			asl
			rol randtemp 
			clc 
			adc random 
			pha 
			lda randtemp
			adc random+1
			sta random+1
			pla 
			adc #$11
			sta random 
			lda random+1
			adc #$36 
			sta random+1
			and #$0f
			 
			rts

				// Collision detection 

collider:	// Collision ignored if penalty has been enabled 

			lda penalty_enabled
			cmp #1 
			bne collision_active
			rts 

collision_active:


			lda objpos
			sec 
			sbc #collisionleft
			sta collision
			clc 
			adc #collisionright
			sta collision+1 
			lda objpos+1 
			sec 
			sbc #collisiontop
			sta collision+2
			clc 
			adc #collisionbottom
			sta collision+3
			
			jsr testrunnercol1
			jsr testrunnercol2
			jsr testrunnercol3 
			rts
// Test crab to runner 1 collision 
// Only collision at the bottom sprite
			
testrunnercol1:
			lda objpos+4
			cmp collision
			bcc nonip1
			cmp collision+1
			bcs nonip1 
			lda objpos+5
			cmp collision+2
			bcc nonip1
			cmp collision+3
			bcs nonip1
			lda objpos+4
			sta objpos+14
			lda objpos+5
			sta objpos+15
			lda objpos+3
			jsr doscore
			jsr deductquota
			jsr updatepanel
			lda #5
			sta runner_speed1
			lda #0
			sta objpos
			 
nonip1:		rts 

testrunnercol2:
			lda objpos+8
			cmp collision 
			bcc nonip2
			cmp collision+1
			bcs nonip2 
			lda objpos+9
			cmp collision+2
			bcc nonip2
			cmp collision+3
			bcs nonip2 
			
			lda objpos+8
			sta objpos+14
			lda objpos+9
			sta objpos+15
			lda objpos+7
			jsr doscore
			jsr deductquota
			
			jsr updatepanel
			
			lda #5
			sta runner_speed2
			lda #0
			sta objpos
nonip2:		rts 

testrunnercol3:
			lda objpos+12
			cmp collision 
			bcc nonip3 
			cmp collision+1
			bcs nonip3
			lda objpos+13
			cmp collision+2
			bcc nonip3 
			cmp collision+3
			bcs nonip3 
			
			lda objpos+12
			sta objpos+14
			lda objpos+13
			sta objpos+15
			lda objpos+11
			jsr doscore
			jsr deductquota
			
			jsr updatepanel
			
			lda #5
			sta runner_speed3
			
			lda #0
			sta objpos
			
			 
nonip3:		rts
			

// Deduct quota 

deductquota: 
			dec quotatext+1
			lda quotatext+1
			cmp #$2f
			bne skipdeduct 
			lda #$39 
			sta quotatext+1
			dec quotatext
skipdeduct:
			lda quotatext 
			cmp #$30 
			beq checksecondq
			rts 
checksecondq:
			lda quotatext+1
			cmp #$30
			beq levelcomplete
			rts 
levelcomplete:
		
			jsr sfx_welldone
			jsr bonus
			jsr updatepanel
			lda #0
			sta firebutton 
			
			lda #0
			sta $d015
			ldx #0
zerosprp:	lda #$00			
			sta $d000,x 
			sta objpos,x 
			inx 
			cpx #$10
			bne zerosprp
			lda #1 
			sta jingles_allowed_to_play 

// Place welldone text 

			lda #$18
			sta charsm+1
			lda #$00 
			sta banksm+1
			
			ldx #$00 
clearagain: lda #$02
			sta $d800,x 
			sta $d900,x 
			sta $da00,x 
			sta $dae8-40,x
			inx 
			bne clearagain
			ldx #$00
			ldy #$00
putwelldone:
			lda levelcompletetext,x 
			sta $c400+(10*40),y
			clc 
			adc #$40
			sta $c400+(10*40)+1,y
			adc #$40 
			sta $c400+(11*40),y 
			adc #$40 
			sta $c400+(11*40)+1,y 
			iny
			iny
			inx
			cpx #20 
			bne putwelldone 
			lda #well_done_jingle
			jsr musicinit

			jsr waitdelay
waitcomp:	jsr synctimer
			
			lda $dc00
			lsr 
			lsr 
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi lcwait2
			bvc lcwait2
			jmp nextlevel 
lcwait2:	lda $dc01 
			lsr
			lsr 
			lsr 
			lsr 
			lsr 
			bit firebutton
			ror firebutton
			bmi waitcomp
			bvc waitcomp 
nextlevel:  lda #0
			sta jingles_allowed_to_play
			lda #$00
			sta $d011
			inc levelpointer 
			lda levelpointer
			cmp #$08
			beq resettolevel1

			jmp resetmiss
			
// After completing all 8 levels the 
// game moves onto the harder skill 
// level.
			
resettolevel1: 
			lda #0
			sta levelpointer 
			inc skilllevel
			lda #0
			sta firebutton
loopskill:	lda #0
			sta skilllevel
restartlevel:			
			ldx #$00
			stx levelpointer
			
			// Reset no of misses
		
resetmiss:
			lda #$30 
			sta missedtext
			sta missedtext+1
			jmp playsetup
			
doscore:
			cmp #runner_height1
			bne not500pts1

			// Check if the jellyfish has been tossed at the 
			// time the player hits a runner. If it has then
			// 1000 points should be scored.
			
			lda jellyfish_enabled 
			cmp #1 
			bne not_jellyfish1
			jsr make1000ptsspr
			jsr score500
			lda #0
			sta jellyfish_enabled
			jmp continue_score1
not_jellyfish1:
			jsr make500ptsspr
continue_score1:
			jsr sfx_crabnip
			jmp score500

not500pts1:			
			cmp #runner_height2
			bne not500pts2
			lda jellyfish_enabled
			cmp #1 
			bne not_jellyfish2 
			jsr make1000ptsspr 
			jsr score500
			lda #0 
			sta jellyfish_enabled
			jmp continue_score2
not_jellyfish2:
			jsr make500ptsspr
continue_score2:
			jsr sfx_crabnip
			jmp score500

not500pts2: //Heights $60+$70 = 200 pts
			cmp #runner_height3
			bne not300pts1
			lda jellyfish_enabled 
			cmp #1
			bne not_jellyfish3 
			jsr make600ptsspr
			jsr score300
			lda #0
			sta jellyfish_enabled 
			jmp continue_score3
not_jellyfish3:
			jsr make300ptsspr
continue_score3:
			jsr sfx_crabnip
			jmp score300

not300pts1:	cmp #runner_height4
			bne not200pts1 
			lda jellyfish_enabled 
			cmp #1 
			bne not_jellyfish4
			jsr make400ptsspr
			jsr score200 
			lda #0 
			sta jellyfish_enabled 
			jmp continue_score4 
not_jellyfish4:
			jsr make200ptsspr
continue_score4:
			jsr sfx_crabnip
			jmp score200 

not200pts1:	cmp #runner_height5
			bne not200pts2
			lda jellyfish_enabled 
			cmp #1 
			bne not_jellyfish5 
			jsr make400ptsspr 
			jsr score200 
			lda #0
			sta jellyfish_enabled 
			jmp continue_score5
not_jellyfish5:			
			jsr make200ptsspr
continue_score5:
			jsr sfx_crabnip
			jmp score200

not200pts2:	cmp #runner_height6
			bne not100pts1 
			lda jellyfish_enabled 
			cmp #1
			bne not_jellyfish6
			jsr make200ptsspr
			jsr score100 
			lda #0 
			sta jellyfish_enabled
			jmp continue_score6
not_jellyfish6:
			jsr make100ptsspr
continue_score6:
			jsr sfx_crabnip
			jmp score100 

not100pts1:	cmp #runner_height7
			bne not100pts2
			lda jellyfish_enabled 
			cmp #1 
			bne not_jellyfish7 
			jsr make200ptsspr 
			jsr score200 
			lda #0 
			sta jellyfish_enabled
			jmp continue_score7
not_jellyfish7:			
			jsr make100ptsspr
continue_score7:
			jsr sfx_crabnip
			jmp score100 
not100pts2:	rts

//Transform sprite to points amount 

make100ptsspr:
			lda score_100_sprite
			jmp updatescoresprite
make200ptsspr:
			lda score_200_sprite
			jmp updatescoresprite 
make300ptsspr:
			lda score_300_sprite
			jmp updatescoresprite 
make400ptsspr:
			lda score_400_sprite 
			jmp updatescoresprite 
make500ptsspr:
			lda score_500_sprite
			jmp updatescoresprite
make600ptsspr:
			lda score_600_sprite 
			jmp updatescoresprite 
make1000ptsspr:
			lda score_1000_sprite
updatescoresprite:
			sta $07ff 
			lda #0
			sta $d02e
			rts
			
			

score500:	jsr scoremain
			jsr scoremain 
score300:	jsr scoremain
score200:	jsr scoremain 
score100:	jsr scoremain 
			rts
			
			

scoremain:  inc scoretext+3
			ldx #$03
scoreloop:	lda scoretext,x 
			cmp #$3a 
			bne scoreok
			lda #$30
			sta scoretext,x 
			inc scoretext-1,x 
scoreok:	dex 
			bne scoreloop 
			inc virtualscore+3

			ldx #$03 
vscoreloop:	lda virtualscore,x 
			cmp #$3a 
			bne vscoreok 
			lda #$30 
			sta virtualscore,x 
			inc virtualscore-1,x 
vscoreok:	dex 
			bne vscoreloop
			lda virtualscore+1
			cmp #$31
			beq jellyfish_awarded 
			rts

			// After scoring 10,000 points the next launch 
			// will come a jellyfish. 

jellyfish_awarded:
			lda #1 
			sta jellyfish_enabled 
			ldx #$00
resetvs:	lda #$30 
			sta virtualscore,x 
			inx 
			cpx #6 
			bne resetvs
			jsr sfx_jellyfish
			rts

// Update the score panel by printing the 
// score text onto the status panel.

updatepanel:
			ldx #$00
putpanel:	lda statusmap,x 
			sta $07c0,x 
			ldy statusmap,x 
			lda statusattribs,y 
			sta $dbc0,x 
			inx 
			cpx #$28 
			bne putpanel
			ldx #$00
putscore:	lda scoretext,x
			sta scorepos,x 
			lda hiscoretext,x
			sta hiscorepos,x 
			inx 
			cpx #6
			bne putscore 
			ldx #$00
putstatus:	lda quotatext,x 
			sta targetpos,x 
			lda missedtext,x
			sta misspos,x
			inx 
			cpx #$02
			bne putstatus
			rts
	
// Init routine (Draw game screen)

drawgamescreen:
			ldx #$00
drawscr:	lda gamescreen,x
			sta $0400,x 
			lda gamescreen+$100,x
			sta $0400+$100,x
			lda gamescreen+$200,x
			sta $0400+$200,x
			lda gamescreen+$2e8,x
			sta $0400+$2e8,x 
			ldy gamescreen,x
			lda attribs,y
			sta $d800,x 
			ldy gamescreen+$100,x 
			lda attribs,y 
			sta $d800+$100,x 
			ldy gamescreen+$200,x
			lda attribs,y 
			sta $d800+$200,x 
			ldy gamescreen+$2e8,x 
			lda attribs,y 
			sta $d800+$2e8,x 
			inx 
			bne drawscr 
			rts			
			
// Sound effects player 

sfxplayer:	jsr testsnappy
			lda sounddelay
			cmp #1
			beq sfxok
			inc sounddelay 
			rts 
sfxok:		lda #0
			sta sounddelay
			ldx soundpointer

wav:		lda crablaunch_wav,x
			sta 54276 
freq1:		lda crablaunch_freq1,x
			sta 54272
freq2:		lda crablaunch_freq2,x 
			sta 54273
			inx 
			cpx #12
			beq stopsfx
			inc soundpointer
			rts 
stopsfx:	ldx #11
			stx soundpointer
			rts
			
testsnappy:	lda snappysound
			cmp #1
			beq playsnappysound
			lda #$0e
			sta 54277+7
			lda #$ee
			sta 54278+7
			lda #0
			sta 54273+7
			sta 54272+7
			sta 54276+7
			rts
			
playsnappysound:
			lda #$09
			sta 54277+7
			lda #$99
			sta 54278+7
			ldx snappysoundpointer
			lda snappy_wav,x
			sta 54276+7
			lda snappy_freq,x 
			sta 54272+7
			sta 54273+7
			inx 
			cpx #snappy_wavend-snappy_wav
			beq loopsnappy
			inc snappysoundpointer
			rts 
loopsnappy:	ldx #0
			stx snappysoundpointer 
			rts
			
// initialise sound effects for 
// specific features
			
sfx_launchcrab:
			lda crablaunch_ad
			sta ad+1
			lda crablaunch_sr
			sta sr+1
			lda #<crablaunch_wav
			sta wav+1
			lda #>crablaunch_wav
			sta wav+2
			lda #<crablaunch_freq1
			sta freq1+1
			lda #>crablaunch_freq1 
			sta freq1+2
			lda #<crablaunch_freq2 
			sta freq2+1
			lda #>crablaunch_freq2
			sta freq2+2
			jmp initsfx
			
sfx_crabsplash:
			lda crabsplash_ad
			sta ad+1
			lda crabsplash_sr 
			sta sr+1
			lda #<crabsplash_wav
			sta wav+1
			lda #>crabsplash_wav
			sta wav+2
			lda #<crabsplash_freq1
			sta freq1+1
			lda #>crabsplash_freq1
			sta freq1+2
			lda #<crabsplash_freq2 
			sta freq2+1
			lda #>crabsplash_freq2
			sta freq2+2
			jmp initsfx
			
sfx_crabnip:
			lda #0
			sta snappysound
			lda crabnip_ad 
			sta ad+1
			lda crabnip_sr 
			sta sr+1
			lda #<crabnip_wav
			sta wav+1
			lda #>crabnip_wav 
			sta wav+2 
			lda #<crabnip_freq1
			sta freq1+1
			lda #>crabnip_freq1
			sta freq1+2
			lda #<crabnip_freq2 
			sta freq2+1
			lda #>crabnip_freq2 
			sta freq2+2
			jmp initsfx

sfx_jellyfish:
			lda #0 
			sta snappysound 
			lda jellyfish_bonus_ad 
			sta ad+1
			lda jellyfish_bonus_sr 
			sta sr+1
			lda #<jellyfish_bonus_wav
			sta wav+1
			lda #>jellyfish_bonus_wav 
			sta wav+2
			lda #<jellyfish_bonus_freq1 
			sta freq1+1
			lda #>jellyfish_bonus_freq1 
			sta freq1+2
			lda #<jellyfish_bonus_freq2 
			sta freq2+1
			lda #>jellyfish_bonus_freq2 
			sta freq2+2 
			jmp initsfx

sfx_fail:
			lda #0
			sta snappysound
			lda fail_ad 
			sta ad+1
			lda fail_sr 
			sta sr+1
			lda #<fail_wav 
			sta wav+1
			lda #>fail_wav 
			sta wav+2 
			lda #<fail_freq1
			sta freq1+1
			lda #>fail_freq1
			sta freq1+2
			lda #<fail_freq2 
			sta freq2+1
			lda #>fail_freq2
			sta freq2+2
			jmp initsfx

			
sfx_welldone:
			
			lda #0
			sta snappysound
			lda welldone_ad
			sta ad+1
			lda welldone_sr
			sta sr+1
			lda #<welldone_wav
			sta wav+1
			lda #>welldone_wav 
			sta wav+2
			lda #<welldone_freq1
			sta freq1+1
			lda #>welldone_freq1
			sta freq1+2
			lda #<welldone_freq2
			sta freq2+1
			lda #>welldone_freq2 
			sta freq2+2
			jmp initsfx 
			
sfx_gameover:
			
			lda #0
			sta snappysound
			lda gameover_ad
			sta ad+1
			lda gameover_sr 
			sta sr+1
			lda #<gameover_wav 
			sta wav+1
			lda #>gameover_wav 
			sta wav+2
			lda #<gameover_freq1
			sta freq1+1
			lda #>gameover_freq1
			sta freq1+2
			lda #<gameover_freq2
			sta freq2+1
			lda #>gameover_freq2
			sta freq2+2
			jmp initsfx
sfx_gamestart:
			
			lda #0
			sta snappysound
			lda gamestart_ad
			sta ad+1
			lda gamestart_sr 
			sta sr+1
			lda #<gamestart_wav
			sta wav+1
			lda #>gamestart_wav
			sta wav+2
			lda #<gamestart_freq1
			sta freq1+1
			lda #>gamestart_freq1
			sta freq1+2
			lda #<gamestart_freq2
			sta freq2+1
			lda #>gamestart_freq2 
			sta freq2+2
			
// init main sfx 

initsfx:	lda #0
			sta sounddelay
			sta soundpointer
ad:	        lda #$00
			 
			sta 54277
sr:			lda #$00
			 
			sta 54278 
			lda #$88
			sta 54275
			sta 54274
			rts
			
			
// The scoring points sprites code 

pointsprcode:
			lda crab_released
			beq skippointsflycode
			lda objpos+15
			sec
			sbc #4
			cmp #$20
			bcs notout 
			lda #0
			sta time_delayMS
			sta objpos+14
			lda #sprite_10seconds
			sta spriteSM+1

			
			lda #0
			sta crab_released
			rts 
notout:		sta objpos+15
skippointsflycode:
			rts
			
// Subroutine to add bonus points to 
// the score panel according to the 
// number of lives the player has 

bonus:		jsr synctimer
			jsr animbackground
			jsr subtractlivesforbonus
			jsr score500
			jsr updatepanel
			lda missedtext+1
			cmp #$30
			bne bonus 
			lda missedtext
			cmp #$30
			bne bonus 
			rts
subtractlivesforbonus:
			dec missedtext+1
			lda missedtext+1
			cmp #$2f
			bne missok3
			lda #$39
			sta missedtext+1
			dec missedtext
missok3:	rts

// Simple delay subroutine 

waitdelay:  ldx #$00
waitloop1:	ldy #$00
waitloop2:	iny 
			bne waitloop2
			inx 
			bne waitloop1
			rts
			
//Clear screen away 

clearscreenaway:
			ldx #$00
clrloop:	lda #$20
			sta $0400,x
			sta $0500,x
			sta $0600,x
			sta $06e8,x
			sta $c400,x
			sta $c500,x
			sta $c600,x
			sta $c6e8,x
			inx
			bne clrloop 
	 
			rts
			
	.import source "gamepointers.asm"
