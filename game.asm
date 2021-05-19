.data
SCORE_POSX:		.word 266
SCORE_POSY:		.word 52
CHEST_POSX:		.word 0
CHEST_POSY:		.word 0
LOLO_INITIAL_POSX:	.word 0
LOLO_INITIAL_POSY:	.word 0
.text

GAME:	
	loadw(t0,CURRENT_LEVEL)
	li t1,1
	beq t0,t1,STAGE_ONE
	li t1,2
	beq t0,t1,STAGE_TWO
	li t1,3
	beq t0,t1,STAGE_THREE
	li t1,4
	beq t0,t1,STAGE_FOUR
	li t1,5
	beq t0,t1,FINAL_STAGE
	ending()
	STAGE_ONE:
		level_title(fase_1)
		j RENDER_STAGE_ONE
	STAGE_TWO:
		level_title(fase_2)
		j RENDER_STAGE_TWO
	STAGE_THREE:
		level_title(fase_3)
		j RENDER_STAGE_THREE
	STAGE_FOUR:
		level_title(fase_4)
		j RENDER_STAGE_FOUR
	FINAL_STAGE:
		level_title(fase_5)
		j RENDER_FINAL_STAGE
	GAMEPLAY:
		switch_frame()
		render_sprite(lolo_coca,LOLO_POSX,LOLO_POSY)
		sleep(500)
		li s0, MMIO_set
		# a0 = tempo
		li a7,30
		ecall
		# Salva o horário no momento em que a fase começou
		savew(a0,CLOCK)
		savew(a0,CLOCK_2)
	POLL_LOOP:				
		lb a6,(s0) # a6 = estado do teclado	
		loadw(t0,CURRENT_LEVEL)
		li a7,30
		ecall # Retorna o horário atual
		mv a1,a0
		loadw(t0,CLOCK)
		sub a0,a0,t0 # a0 = horário atual - inicial
		li t0,150
		ble a0,t0,NOT_YET # se a0 maior que 150 milisegundos, executa uma ação
		savew(a1,CLOCK)	
		loadw(t1,CURRENT_LEVEL)
		li t2,5
		beq t1,t2,STAGE_FIVE_ACTIONS
			li t2,4
			beq t1,t2,STAGE_FOUR_ACTIONS
				li t2,3
				beq t1,t2,STAGE_THREE_ACTIONS
					li t2,2
					beq t1,t2,STAGE_TWO_ACTIONS
						j NOT_YET
					STAGE_TWO_ACTIONS:
					# Fase 2 -> ações
					#loadw(t1,CLOCK_2)
					#sub a1,a1,t1
					#li t2,2000
					#blt a1,t2,NOT_YET
					call ENEMY_SHOT
				STAGE_THREE_ACTIONS:
				# Fase 3 -> ações
				call ENEMY_WALK			
			STAGE_FOUR_ACTIONS:
			# Fase 4 -> ações
			call ENEMIES_WALK
		STAGE_FIVE_ACTIONS:
			# Fase 5 -> ações
			loadw(t1,CLOCK_2)
			sub a1,a1,t1
			li t2,20000 # Se passaram 20 segundos desde o início da fase, passou de fase
			bgt a1,t2,FINAL_STAGE_END
			call ENEMIES_WALK
		NOT_YET:
		beqz a6,POLL_LOOP	# Testa se algo foi digitado, se não, retorna ao loop		
		li s11,MMIO_add
		lw s11, (s11)		# Tecla capturada em s11
		li t1,'r'
		beq s11,t1,RESET_GAME
		call LOLO_WALK 		# Executa a movimentação do LOLO
		j POLL_LOOP	
	
	RESET_GAME:
		reset()
		game()
	
	FINAL_STAGE_END:
		ending()

#############################
# Renderiza a primeira fase #
#############################
RENDER_STAGE_ONE:
	switch_frame()
	frame_address(a1)
	mv t0,a1
	la s0,stage_one
	jal IMPRIME
	print_door()
	loadw(t1,CURRENT_FRAME)
	li t2,FRAME_SELECT
	sw t1,(t2)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_one
	jal IMPRIME
	print_door()
	li t1,74
	li t2,100
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	savew(t1,LOLO_INITIAL_POSX)
	savew(t2,LOLO_INITIAL_POSY)
	li t1,3
	savew(t1,KEY_COUNTER)
	mark_as_block(7,HORIZONTAL,74,36)
	mark_as_block(5,HORIZONTAL,74,52)
	mark_as_block(4,HORIZONTAL,90,68)
	mark_as_block(3,HORIZONTAL,106,84)
	mark_as_block(4,HORIZONTAL,122,100)
	mark_as_block(6,VERTICAL,202,36)
	mark_as_block(5,VERTICAL,218,36)
	mark_as_block(4,VERTICAL,234,36)
	mark_as_key(154,52)
	mark_as_key(234,100)
	mark_as_block(2,HORIZONTAL,90,132)
	mark_as_block(4,HORIZONTAL,74,148)
	mark_as_block(4,HORIZONTAL,74,164)
	mark_as_block(4,HORIZONTAL,74,180)
	mark_as_block(7,HORIZONTAL,74,196)
	mark_as_block(2,HORIZONTAL,186,148)
	mark_as_block(3,HORIZONTAL,186,164)
	mark_as_block(2,HORIZONTAL,202,180)
	mark_as_chest(138,180)
	mark_as_pushable(186,100)
	loadw(a0,LIFE_COUNTER)
	render_abs_sprite(score_three,SCORE_POSX,SCORE_POSY)
	j GAMEPLAY
#############################
# Renderiza a segunda fase  #
#############################
RENDER_STAGE_TWO:
	li t1,2
	savew(t1,CURRENT_LEVEL)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	print_door()
	loadw(t1,CURRENT_FRAME)
	li t2,FRAME_SELECT
	sw t1,(t2)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	print_door()
	li t1,138
	li t2,196
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	savew(t1,LOLO_INITIAL_POSX)
	savew(t2,LOLO_INITIAL_POSY)
	li t3, 4
	savew(t3, KEY_COUNTER)
	mark_as_block(3,HORIZONTAL,138,36)
	mark_as_block(3,HORIZONTAL,138,52)
	mark_as_block(2,HORIZONTAL,154,68)
	mark_as_mortal(3,HORIZONTAL,74,84)
	mark_as_mortal(3,HORIZONTAL,74,100)
	mark_as_bridge(122,84)
	mark_as_bridge(122,100)
	mark_as_bridge(218,84)
	mark_as_bridge(218,100)
	mark_as_mortal(5,HORIZONTAL,138,84)
	mark_as_mortal(5,HORIZONTAL,138,100)
	mark_as_mortal(4,HORIZONTAL,170,196)
	mark_as_mortal(8,VERTICAL,234,84)
	mark_as_mortal(106,36)
	mark_as_mortal(74,164)
	mark_as_block(2,HORIZONTAL,186,132)
	mark_as_block(4,HORIZONTAL,154,148)
	mark_as_block(2,HORIZONTAL,154,164)
	mark_as_block(2,HORIZONTAL,90,116)
	mark_as_block(2,HORIZONTAL,90,132)
	mark_as_key(90,52)
	mark_as_key(202,52)
	mark_as_key(186,164)
	mark_as_chest(74,116)
	mark_as_pushable(170,180)
	set_shooting_enemy(90,164,16,92)
	call SCORE_REFRESH
	j GAMEPLAY
##############################
# Renderiza a terceira fase  #
##############################
RENDER_STAGE_THREE:
	li t1,3
	savew(t1,CURRENT_LEVEL)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	print_door()
	loadw(t1,CURRENT_FRAME)
	li t2,FRAME_SELECT
	sw t1,(t2)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	print_door()
	li t1,170
	li t2,164
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	savew(t1,LOLO_INITIAL_POSX)
	savew(t2,LOLO_INITIAL_POSY)
	li t3, 5
	savew(t3, KEY_COUNTER)
	mark_as_block(3,HORIZONTAL,106,52)
	mark_as_block(3,HORIZONTAL,106,68)
	mark_as_block(5,VERTICAL,122,100)
	mark_as_block(3,VERTICAL,154,116)
	mark_as_block(2,VERTICAL,202,100)
	mark_as_block(1,VERTICAL,170,148)
	mark_as_block(1,VERTICAL,234,196)
	mark_as_mortal(3,HORIZONTAL,170,52)
	mark_as_mortal(3,HORIZONTAL,170,68)
	mark_as_mortal(7,HORIZONTAL,106,84)
	mark_as_mortal(3,HORIZONTAL,186,148)
	mark_as_mortal(3,HORIZONTAL,186,164)
	mark_as_mortal(7,HORIZONTAL,122,180)
	mark_as_mortal(8,VERTICAL,90,68)
	mark_as_bridge(106,180)
	mark_as_pushable(154,100)
	mark_as_key(154,68)
	mark_as_key(170,132)
	mark_as_key(234,180)
	mark_as_key(218,196)
	mark_as_chest(106,100)
	set_enemy(0,74,36,16,1,11)
	call SCORE_REFRESH
	j GAMEPLAY
###########################
# Renderiza a quarta fase #
###########################
RENDER_STAGE_FOUR:
	li t1,4
	savew(t1,CURRENT_LEVEL)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_four
	jal IMPRIME
	print_door()
	loadw(t1,CURRENT_FRAME)
	li t2,FRAME_SELECT
	sw t1,(t2)
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_four
	jal IMPRIME
	print_door()
	li t1,154
	li t2,164
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	savew(t1,LOLO_INITIAL_POSX)
	savew(t2,LOLO_INITIAL_POSY)
	li t3, 4
	savew(t3, KEY_COUNTER)
	mark_as_block(5,HORIZONTAL,90,52)
	mark_as_block(3,HORIZONTAL,186,84)
	mark_as_block(3,HORIZONTAL,186,148)
	mark_as_block(5,HORIZONTAL,90,180)
	mark_as_block(1,HORIZONTAL,218,68)
	mark_as_block(1,HORIZONTAL,218,164)
	mark_as_block(5,VERTICAL,170,84)
	mark_as_mortal(4,HORIZONTAL,90,100)
	mark_as_mortal(3,HORIZONTAL,90,116)
	mark_as_mortal(4,HORIZONTAL,90,132)
	mark_as_bridge(74,116)
	mark_as_pushable(170,52)
	mark_as_pushable(106,68)
	mark_as_pushable(106,164)
	mark_as_pushable(170,180)
	mark_as_pushable(218,100)
	mark_as_pushable(218,116)
	mark_as_pushable(218,132)
	mark_as_chest(138,116)
	mark_as_key(186,100)
	mark_as_key(186,116)
	mark_as_key(186,132)
	set_enemy(0,74,36,16,0,11)
	set_enemy(1,74,196,16,110,121)
	li t1,2
	savew(t1,NUMBER_OF_ENEMIES)
	call SCORE_REFRESH
	j GAMEPLAY
###########################
# Renderiza a quinta fase #
###########################
RENDER_FINAL_STAGE:
	li t1,1
	savew(t1,LIFE_COUNTER)
	li t1,5
	savew(t1,CURRENT_LEVEL)
	frame_address(a1)
	mv t0,a1	
	la s0,final_stage
	jal IMPRIME
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,final_stage
	jal IMPRIME
	mark_as_block(11,HORIZONTAL,74,100)
	li t1,202
	li t2,148
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	set_enemy(0,90,116,16,54,66)
	set_enemy(1,218,132,-16,65,77)
	set_enemy(2,90,148,16,76,88)
	set_enemy(3,218,164,-16,87,99)
	set_enemy(4,90,180,16,98,110)
	set_enemy(5,218,196,-16,109,121)	
	li t1,6
	savew(t1,NUMBER_OF_ENEMIES)
	li t1,1
	savew(t1,TOGGLE_RNG)
	j GAMEPLAY		
