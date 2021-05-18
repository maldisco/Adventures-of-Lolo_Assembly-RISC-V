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
		li t1,4
		blt t0,t1,NOT_YET
			li a7,30
			ecall # Retorna o horário atual
			mv a1,a0
			loadw(t0,CLOCK)
			sub a0,a0,t0 # a0 = horário atual - inicial
			li t0,150
			ble a0,t0,NOT_YET # se a0 maior que 150 milisegundos, executa uma ação
			savew(a1,CLOCK)	
			loadw(t1,CURRENT_LEVEL)
			li t2,4
			beq t1,t2,STAGE_FOUR_ACTIONS
				# Fase 5 -> ações
				loadw(t1,CLOCK_2)
				sub a1,a1,t1
				li t2,20000 # Se passaram 20 segundos desde o início da fase, passou de fase
				bgt a1,t2,FINAL_STAGE_END
				call ENEMIES_WALK
			STAGE_FOUR_ACTIONS:
				# Fase 4 -> ações
				call ENEMY_WALK
		NOT_YET:
			beqz a6,POLL_LOOP	# Testa se algo foi digitado, se não, retorna ao loop		
			li s11,MMIO_add
			lw s11, (s11)		# Tecla capturada em s11
			call LOLO_WALK 		# Executa a movimentação do LOLO
			j POLL_LOOP	
	
	FINAL_STAGE_END:
		ending()
	
#############################
# Renderiza a primeira fase #
#############################
RENDER_STAGE_ONE:
	frame_address(a1)
	mv t0,a1
	la s0,stage_one
	jal IMPRIME
	li t1,0
	savew(t1, DOOR_STATE)
	print_door()
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_one
	jal IMPRIME
	print_door()
	mark_as_block(4,122,36 )
	mark_as_block(2,218,36 )
	mark_as_block(3,138,52 )
	mark_as_block(1,234,52 )
	mark_as_block(3,138,68 )
	mark_as_block(1,170,84 )
	mark_as_block(8,74,148 )
	mark_as_block(8,74,164 )
	mark_as_block(8,74,180 )
	mark_as_block(8,74,196 )
	mark_as_block(1,234,196 )	
	j GAMEPLAY
#############################
# Renderiza a segunda fase  #
#############################
RENDER_STAGE_TWO:
	li t1,2
	savew(t1,CURRENT_LEVEL)
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	print_door()
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	print_door()
	li t3, 3
	savew(t3, KEY_COUNTER)
	mark_as_block(4,122,36)
	mark_as_block(2,218,36)
	mark_as_block(3,138,52)
	mark_as_block(1,234,52)
	mark_as_block(3,138,68)
	mark_as_key(234,68)
	mark_as_block(1,170,84)
	mark_as_block(1,170,84)
	mark_as_key(74,132)
	mark_as_block(1,74,148)
	mark_as_block(2,74,164)
	mark_as_block(3,74,180)
	mark_as_block(4,74,196)
	mark_as_key(218,196)
	mark_as_block(1,234,196)
	j GAMEPLAY
##############################
# Renderiza a terceira fase  #
##############################
RENDER_STAGE_THREE:
	li t1,3
	savew(t1,CURRENT_LEVEL)
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	print_door()
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	print_door()
	li t3, 2
	savew(t3, KEY_COUNTER)
	mark_as_block(1,90,52)
	mark_as_block(1,106,52)
	mark_as_block(1,90,68)
	mark_as_block(1,218,52)
	mark_as_block(1,202,52)
	mark_as_block(1,218,68)
	mark_as_mortal(122, 84)
	mark_as_mortal(138, 84)
	mark_as_mortal(154, 84)
	mark_as_mortal(170, 84)
	mark_as_mortal(186, 84)
	mark_as_mortal(186, 100)
	mark_as_mortal(186, 116)
	mark_as_mortal(186, 132)
	mark_as_mortal(186, 148)
	mark_as_mortal(122, 148)
	mark_as_mortal(138, 148)
	mark_as_bridge(154, 148)	
	mark_as_mortal(170, 148)
	mark_as_mortal(122, 100)
	mark_as_mortal(122, 116)
	mark_as_mortal(122, 132)
	mark_as_key(154, 116)
	mark_as_block(1,90,180)
	mark_as_block(1,106,180)
	mark_as_block(1,90,164)
	mark_as_block(1,218,180)
	mark_as_block(1,202,180)
	mark_as_key(234, 196)
	mark_as_block(1,218,164)
	j GAMEPLAY
###########################
# Renderiza a quarta fase #
###########################
RENDER_STAGE_FOUR:
	li t1,4
	savew(t1,CURRENT_LEVEL)
	frame_address(a1)
	mv t0,a1	
	la s0,stage_four
	jal IMPRIME
	print_door()
	switch_frame()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_four
	jal IMPRIME
	print_door()
	li t3, 1
	savew(t3, KEY_COUNTER)
	mark_as_mortal(90,52)
	mark_as_mortal(106,52)
	mark_as_mortal(122,52)
	mark_as_mortal(138,52)
	mark_as_mortal(154,52)
	mark_as_mortal(170,52)
	mark_as_mortal(186,52)
	mark_as_mortal(202,52)
	mark_as_mortal(218,52)
	mark_as_mortal(90,180)
	mark_as_mortal(106,180)
	mark_as_mortal(122,180)
	mark_as_mortal(138,180)
	mark_as_bridge(154,180)
	mark_as_mortal(170,180)
	mark_as_mortal(186,180)
	mark_as_mortal(202,180)
	mark_as_mortal(218,180)
	mark_as_mortal(90,84)
	mark_as_mortal(122,84)
	mark_as_mortal(138,84)
	mark_as_bridge(154,84)
	mark_as_mortal(170,84)
	mark_as_mortal(186,84)
	mark_as_mortal(122,148)
	mark_as_mortal(138,148)
	mark_as_mortal(154,148)
	mark_as_mortal(170,148)
	mark_as_mortal(186,148)
	mark_as_mortal(90,68)
	mark_as_mortal(90,84)
	mark_as_mortal(90,100)
	mark_as_mortal(90,116)
	mark_as_mortal(90,132)
	mark_as_mortal(90,148)
	mark_as_mortal(90,164)
	mark_as_mortal(218,68)
	mark_as_mortal(218,84)
	mark_as_mortal(218,100)
	mark_as_mortal(218,116)
	mark_as_mortal(218,132)
	mark_as_mortal(218,148)
	mark_as_mortal(218,164)
	mark_as_mortal(122,100)
	mark_as_mortal(122,116)
	mark_as_mortal(122,132)
	mark_as_mortal(186,100)
	mark_as_mortal(186,116)
	mark_as_mortal(186,132)
	mark_as_key(154,116)
	set_enemy(0,106,164,16,89,97)
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
	mark_as_block(11,74,100)
	li t1,154
	li t2,148
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	set_enemy(0,90,116,16,54,66)
	set_enemy(1,218,132,-16,65,77)
	set_enemy(2,90,148,16,76,88)
	set_enemy(3,218,164,-16,87,99)
	set_enemy(4,90,180,16,98,110)
	set_enemy(5,218,196,-16,109,121)	
	j GAMEPLAY		