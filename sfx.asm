//Simplistic sound effects tables 

//53272

// Crab / jellyfish  launch

crablaunch_ad:  .byte $0a
crablaunch_sr:  .byte $aa
crablaunch_wav: .byte $81,$81,$81,$81
				.byte $00,$00,$00,$00
				.byte $00,$00,$00,$00
crablaunch_freq1:
				.byte $22,$32,$42,$52
				.byte $00,$00,$00,$00
				.byte $00,$00,$00,$00
crablaunch_freq2:
				.byte $52,$42,$32,$22
				.byte $00,$00,$00,$00
				.byte $00,$00,$00,$00

// Crab / jellyfish fall in water

crabsplash_ad:	.byte $0a
crabsplash_sr:	.byte $aa
crabsplash_wav:	.byte $81,$81,$81,$81
				.byte $81,$81,$81,$81
				.byte $81,$81,$00,$00
crabsplash_freq1:
				.byte $28,$26,$24,$22
				.byte $20,$1e,$1c,$14
				.byte $12,$10,$0e,$00
crabsplash_freq2:
				.byte $03,$04,$05,$06
				.byte $07,$08,$00,$00
				.byte $00,$00,$00,$00

// Crab / jellyfish nip runners

crabnip_ad:		.byte $0a
crabnip_sr:  	.byte $aa
crabnip_wav:	.byte $41,$41,$41,$41
				.byte $41,$41,$41,$41
				.byte $41,$41,$00,$00
				
crabnip_freq1:	.byte $40,$3c,$38,$34
				.byte $30,$2c,$28,$24
				.byte $20,$1c,$18,$00
				
crabnip_freq2:	.byte $40,$3c,$38,$34
				.byte $30,$2c,$28,$24
				.byte $20,$1c,$18,$00

// Jellyfish awarded

jellyfish_bonus_ad:   .byte $0a
jellyfish_bonus_sr:   .byte $aa 
jellyfish_bonus_wav:  .byte $41,$41,$41,$41
                .byte $41,$41,$41,$41 
                .byte $41,$40,$00,$00

jellyfish_bonus_freq1: .byte $01,$02,$03,$04 
                 .byte $01,$02,$03,$04
                 .byte $01,$00,$00,$00

jellyfish_bonus_freq2: .byte $67,$27,$13,$67 
                 .byte $27,$13,$67,$27 
                 .byte $13,$00,$00,$00

fail_ad:		 .byte $0a
fail_sr:		 .byte $aa
fail_wav:		 .byte $41,$41,$11,$11
				 .byte $41,$41,$41,$41
				 .byte $41,$41,$00,$00

fail_freq1:		 .byte $05,$05,$00,$03
				 .byte $03,$03,$03,$03
				 .byte $03,$03,$03,$03

fail_freq2:		 .byte $05,$05,$00,$03
				 .byte $03,$03,$03,$03
				 .byte $03,$03,$03,$03
// Well done sfx (To do, delete and replace with jingles from title music source)
				
welldone_ad:	.byte $0a
welldone_sr:	.byte $0a 
welldone_wav:	.byte $41,$41,$41,$41
				.byte $41,$41,$41,$41
				.byte $41,$41,$41,$41
				.byte $41,$41,$00,$00
				
welldone_freq1:	.byte $20,$20,$20,$20
				.byte $24,$24,$24,$24
				.byte $27,$27,$27,$27
				.byte $2c,$2c,$2c,$00
				
welldone_freq2: .byte $30,$34,$37,$3c
				.byte $30,$34,$37,$3c
				.byte $30,$34,$37,$3c
				.byte $30,$34,$37,$00
				
// Game start sfx

gamestart_ad:	.byte $0a 
gamestart_sr:	.byte $0a 
gamestart_wav:	.byte $41,$41,$41,$41
				.byte $41,$41,$41,$41
				.byte $41,$41,$41,$41
				.byte $21,$00,$00,$00
gamestart_freq1:
				.byte $01,$01,$01,$01
				.byte $01,$01,$01,$01
				.byte $01,$01,$01,$01
				.byte $01,$01,$01,$01
gamestart_freq2:
				.byte $08,$0c,$10,$14
				.byte $18,$1c,$20,$24
				.byte $28,$2c,$30,$34
				.byte $38,$3c,$40,$00
				

// Crab / Jellyfish snappy movement waveform                
				
snappy_wav:		.byte $81,$81,$81,$81
				.byte $00,$81,$00,$00
				.byte $81,$00,$81,$00
				.byte $00,$81,$00,$00
snappy_wavend:
				
snappy_freq:	.byte $16,$00,$26,$00
				.byte $00,$10,$00,$00
				.byte $16,$00,$26,$00
				.byte $00,$10,$00,$00
				
// Goat tracker based SFX table for bonus 

sfx_bonuspoints: .byte $0e,$ee,$88,$b0,$41,$ba,$ca,$da,$ca,$ba,$aa,$00	
