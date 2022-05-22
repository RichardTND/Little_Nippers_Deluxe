
// gameirq Pointers and game control logic
system: .byte $00
ntsctimer: .byte $00
rt: .byte $00
firebutton: .byte $00
randtemp: .byte $5a 
random: .byte %10011101,%01011011
selectpointer1: .byte 0
selectpointer2: .byte 0
selectpointer3: .byte 0
levelpointer: .byte 0
sounddelay: .byte 0
soundpointer: .byte 0
soundvalue: .byte 0
splashdelay: .byte 0
crabinwater: .byte 0
jellyfish_enabled: .byte 0
snappysound:	.byte 1
snappysoundpointer: .byte 0
skilllevel: .byte 0
joydelay: .byte 0
time_delayMS: .byte 0
time_delayS: .byte 0
penalty_enabled: .byte 0
crab_released: .byte 0
jingles_allowed_to_play: .byte 0
points_sprite_released: .byte 0
// Animation and sprite pointers 

spr_anim_delay: .byte 0
spr_anim_pointer: .byte 0
chr_anim_delay: .byte 0
chr_anim_store1: .byte 0
chr_anim_store2: .byte 0
crab_place_pointer: .byte 0
spriteHeightPosition: .byte 0
// Runners 

runner_dir1: .byte 0
runner_dir2: .byte 1
runner_dir3: .byte 0
runner_speed1: .byte 0
runner_speed2: .byte 0
runner_speed3: .byte 0
runner_hit1:	.byte 0
runner_hit2:	.byte 0
runner_hit3:	.byte 0

// Collision detection

collision: .byte 0,0,0,0

// Actual sprites 

crab_spr: 		.byte $80
boy_right_spr:	.byte $83
boy_left_spr:  	.byte $87
boy_right_spr2:  .byte $89
boy_left_spr2:	.byte $8d 
girl_right_spr: .byte $8a
girl_left_spr: 	.byte $8e
girl_right_spr2: .byte $90 
girl_left_spr2: .byte $93

boy_body_right_spr:
body_right_spr: .byte $9c
boy_body_left_spr:
body_left_spr:  .byte $9f
boy_body_right_spr2: .byte $a2
boy_body_left_spr2: .byte $a5
girl_body_right_spr: .byte $a8 
girl_body_left_spr: .byte $ab
girl_body_right_spr2: .byte $ae
girl_body_left_spr2: .byte $b1
jelly_fish_spr: .byte $b4

splash_spr:		.byte $b8

			
// Sprite pointers			

startpos:
			.byte $00,$00
			.byte $a8,$00
			.byte $a8,$00
			.byte $00,$00
			.byte $00,$00
			.byte $f0,$00
			.byte $f0,$00
			.byte $00,$00
			
objpos:		.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			.byte $00,$00
			
crab_frame:	
			.byte $80,$81,$82,$83
// Boy's head animation			
boy_right_frame: 
			.byte $84,$85,$86,$85
boy_left_frame:
			.byte $87,$88,$89,$88
boy_right_frame2:
			.byte $8a,$8b,$8c,$8b 
boy_left_frame2:
			.byte $8d,$8e,$8f,$8e 

// Girl's head animation 
girl_right_frame:
			.byte $90,$91,$92,$91
girl_left_frame:	
			.byte $93,$94,$95,$94
girl_right_frame2:
			.byte $96,$97,$98,$97
girl_left_frame2:
			.byte $99,$9a,$9b,$9a

// Boy's body animation 

boy_body_right_frame:
body_right_frame:
			.byte $9c,$9d,$9e,$9d 
boy_body_left_frame:
			.byte $9f,$a0,$a1,$a0 
boy_body_right_frame2:
			.byte $a2,$a3,$a4,$a3 
boy_body_left_frame2:
			.byte $a5,$a6,$a7,$a6

// Girl's body animation 

girl_body_right_frame:
			.byte $a8,$a9,$aa,$a9 
girl_body_left_frame:
			.byte $ab,$ac,$ad,$ac 
girl_body_right_frame2:
			.byte $ae,$af,$b0,$af 
girl_body_left_frame2:
			.byte $b1,$b2,$b3,$b2

// Jellyfish animation 

jellyfish_frame:
			.byte $b4,$b5,$b6,$b7

// Scoring sprites:

score_100_sprite: 
			.byte $b9
score_200_sprite:
			.byte $ba
score_300_sprite:
			.byte $bb
score_500_sprite:
			.byte $bc
score_400_sprite:
			.byte $bd
score_600_sprite:
			.byte $be 
score_1000_sprite:
			.byte $bf

					
// Crab launch order table 

crab_order_table:
			.byte crab_pos_x1
			.byte crab_pos_x2
			.byte crab_pos_x3
			.byte crab_pos_x4
			.byte crab_pos_x5
			.byte crab_pos_x6
			.byte crab_pos_x7
			.byte crab_pos_x8
	
// Runners possible staring position 
// Table 

runner_start_ypos_table:
			.byte $40,$50,$60,$70,$80
			.byte $90,$a0,$80,$90,$40
			.byte $50,$90,$70,$a0,$90
			.byte $90
			 	
			
direction_table:
			.byte $00,$01,$00,$01,$00
			.byte $01,$00,$01,$00,$01
			.byte $00,$01,$00,$01,$00
			.byte $01
			 
			
runner_speed_table:
			.byte $01,$01,$01,$01,$01
			.byte $01,$01,$01,$01,$01
			.byte $01,$01,$01,$01,$01
			.byte $01
			 
			
head_type_table_lo:
			.byte <boy_left_spr
			.byte <boy_right_spr
			.byte <girl_left_spr
			.byte <girl_right_spr

			.byte <boy_left_spr2
			.byte <boy_right_spr2
			.byte <girl_left_spr2
			.byte <girl_right_spr2

			.byte <boy_left_spr
			.byte <boy_right_spr
			.byte <girl_left_spr
			.byte <girl_right_spr

			.byte <boy_left_spr2
			.byte <boy_right_spr2
			.byte <girl_left_spr2
			.byte <girl_right_spr2

head_type_table_hi:			
			.byte >boy_left_spr
			.byte >boy_right_spr
			.byte >girl_left_spr
			.byte >girl_right_spr

			.byte >boy_left_spr2
			.byte >boy_right_spr2
			.byte >girl_left_spr2
			.byte >girl_right_spr2

			.byte >boy_left_spr
			.byte >boy_right_spr
			.byte >girl_left_spr
			.byte >girl_right_spr

			.byte >boy_left_spr2
			.byte >boy_right_spr2
			.byte >girl_left_spr2
			.byte >girl_right_spr2

body_type_table_lo:
			.byte <boy_body_left_spr
			.byte <boy_body_right_spr
			.byte <girl_body_left_spr
			.byte <girl_body_right_spr

			.byte <boy_body_left_spr2
			.byte <boy_body_right_spr2
			.byte <girl_body_left_spr2
			.byte <girl_body_right_spr2

			.byte <boy_body_left_spr
			.byte <boy_body_right_spr
			.byte <girl_body_left_spr
			.byte <girl_body_right_spr

			.byte <boy_body_left_spr2
			.byte <boy_body_right_spr2
			.byte <girl_body_left_spr2
			.byte <girl_body_right_spr2
			
body_type_table_hi:
			
			.byte >boy_body_left_spr
			.byte >boy_body_right_spr
			.byte >girl_body_left_spr
			.byte >girl_body_right_spr

			.byte >boy_body_left_spr2
			.byte >boy_body_right_spr2
			.byte >girl_body_left_spr2
			.byte >girl_body_right_spr2

			.byte >boy_body_left_spr
			.byte >boy_body_right_spr
			.byte >girl_body_left_spr
			.byte >girl_body_right_spr

			.byte >boy_body_left_spr2
			.byte >boy_body_right_spr2
			.byte >girl_body_left_spr2
			.byte >girl_body_right_spr2
			
hair_colour_table:

			.byte $00,$02,$09,$0b 
			.byte $08,$00,$02,$09
			.byte $0b,$08,$00,$02
			.byte $09,$0b,$08,$00
			
shorts_colour_table:

			.byte $06,$04,$02,$00
			.byte $05,$09,$00,$08
			.byte $02,$04,$06,$08
			.byte $06,$02,$04,$00
			
level1_speedtable:
			.byte $01,$01,$01,$01
			.byte $01,$01,$01,$01
			.byte $01,$01,$01,$01
			.byte $01,$01,$01,$01
			
level2_speedtable:
			.byte $01,$01,$01,$01
			.byte $01,$02,$01,$01
			.byte $01,$01,$01,$01
			.byte $01,$01,$01,$01
			
level3_speedtable:
			.byte $01,$01,$02,$01
			.byte $02,$01,$01,$01
			.byte $01,$01,$02,$01
			.byte $01,$01,$01,$01
			
level4_speedtable:
			.byte $01,$01,$01,$01
			.byte $02,$02,$02,$01
			.byte $01,$02,$01,$02
			.byte $02,$02,$01,$02
			
level5_speedtable:
			.byte $01,$02,$02,$02
			.byte $02,$02,$02,$02
			.byte $02,$01,$02,$02
			.byte $02,$02,$02,$02
			
level6_speedtable:
			.byte $02,$02,$01,$03
			.byte $02,$02,$03,$01
			.byte $02,$02,$02,$03
			.byte $02,$02,$02,$02
			
level7_speedtable:
			.byte $03,$03,$02,$02
			.byte $03,$03,$01,$02
			.byte $03,$03,$02,$02
			.byte $03,$01,$02,$02
			.byte $03,$03,$02,$03
			
level8_speedtable:
			.byte $01,$02,$03,$03
			.byte $03,$03,$01,$02
			.byte $03,$03,$03,$03
			.byte $01,$02,$03,$03
			
level_quota_table1:
			.byte $31
			.byte $31
			.byte $32
			.byte $32
			.byte $31
			.byte $31
			.byte $32
			.byte $32
			
level_quota_table2:
			.byte $30
			.byte $35
			.byte $30
			.byte $35
			.byte $30
			.byte $35
			.byte $30
			.byte $35
			
level_speed_table_lo:
			.byte <level1_speedtable
			.byte <level2_speedtable
			.byte <level3_speedtable
			.byte <level4_speedtable
			.byte <level5_speedtable
			.byte <level6_speedtable
			.byte <level7_speedtable
			.byte <level8_speedtable
			
level_speed_table_hi:			
			.byte >level1_speedtable
			.byte >level2_speedtable
			.byte >level3_speedtable
			.byte >level4_speedtable
			.byte >level5_speedtable
			.byte >level6_speedtable
			.byte >level7_speedtable
			.byte >level8_speedtable
			
			
//Status panel pointers / characters 
			
			// 000000 default
scoretext:	.byte $30,$30,$30
			.byte $30,$30,$30	

virtualscore: .byte $30,$30,$30 
			  .byte $30,$30,$30
			
		    // 000000 default
leveltext:	.byte $30,$31 // 01 default
quotatext:	.byte $31,$35 // 15 default
missedtext:	.byte $30,$30 // 00 default
			
hiscoretext:
			.byte $30,$30,$30
			.byte $30,$30,$30 			
			
line0:		.text "--------------------"	
line1:		.text " please select your "
line2:		.text " level with up/down "
line3:		.text " skill level .... "
skilllevelchar: .text "1  "
line4:		.text " space/fire to play "

getreadytext:
			.text "      get ready     "
levelcompletetext:
			.text "   level complete   "
levellen:
gameovertext: 
			.text "     game over      "

completemessage:
			.text "skill level cleared "
completemessage2:
			.text " try the next one   "
			
skillleveltable1:			
			.byte $32 // 20 crabs 
			.byte $31 // 15 crabs 
			.byte $31 // 10 crabs 
			.byte $30 //  5 crabs 
			.byte $30 // 01 crab
			
skillleveltable2:
			.byte $30 // 20 crabs 
			.byte $35 // 15 crabs 
			.byte $30 // 10 crabs 
			.byte $35 //  5 crabs
			.byte $31 //  1 crab
			
.import source "sfx.asm"
