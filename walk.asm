.data
LOLO_POSX:		.word 74
LOLO_POSY:		.word 36
.text

LOLO_WALK:
	li t1, UP 				# t1 = 'W'
	li t2, DOWN				# t2 = 'S'
	li t3, RIGHT				# t1 = 'D'
	li t4, LEFT				# t2 = 'A'
	
	beq s11,t1,LOLO_WALK_UP			# s11 = tecla digitada
	beq s11,t2,LOLO_WALK_DOWN
	beq s11,t3,LOLO_WALK_RIGHT
	beq s11,t4,LOLO_WALK_LEFT
	j POLL_LOOP
	
LOLO_WALK_UP:
	jal ERASE_CURRENT_BLOCK																						
	switch_frame()			
	loadw(a1,LOLO_POSY)
	addi a1,a1,-16
	jal IS_DOOR				# Testa se o destino é uma porta
	li t2, MAP_UPPER_EDGE	
	blt a1,t2,LWU_INVALID			# Testa se Lolo saiu do mapa ( Y maior que borda superior do mapa)
		loadw(t3,LOLO_POSX)
		calculate_block(t3,a1)
		jal IS_MORTAL_BLOCK		# Testa se o bloco destino é um bloco mortal
		la t2, WALKABLE_BLOCKS
		add t3,t2,t1
		lb t3,(t3)
		bgtz t3, LWU_INVALID 		# Testa se é um bloco andável
			savew(a1,LOLO_POSY)	# Atualiza a posição de Lolo para a próxima renderização
			jal IS_KEY_BLOCK
	LWU_INVALID:
	jal COLISION_TEST
	render_sprite(lolo_up_1,LOLO_POSX,LOLO_POSY)						
	frame_refresh()				
	j POLL_LOOP
LOLO_WALK_DOWN:
	jal ERASE_CURRENT_BLOCK
	switch_frame()			
	loadw(a1,LOLO_POSY)
	addi a1,a1,16
	li t2, MAP_LOWER_EDGE
	bgt a1,t2,LWD_INVALID 			# Teste está no mapa
		loadw(t3,LOLO_POSX)
		calculate_block(t3,a1)
		jal IS_MORTAL_BLOCK		# Testa se é um bloco mortal
		LWD_NOT_MORTAL:		
		la t2, WALKABLE_BLOCKS
		add t3,t2,t1
		lb t3,(t3)
		bgtz t3,LWD_INVALID
			savew(a1,LOLO_POSY)	# Atualiza a posição de Lolo para a próxima renderização
			jal IS_KEY_BLOCK
	LWD_INVALID:
	jal COLISION_TEST			# Testa colisão com inimigo
	render_sprite( lolo_down_1, LOLO_POSX, LOLO_POSY)					
	frame_refresh()				
	j POLL_LOOP
LOLO_WALK_RIGHT:
	jal ERASE_CURRENT_BLOCK			
	switch_frame()					
	loadw( a1,LOLO_POSX )
	addi a1,a1,16
	li t2, MAP_RIGHT_EDGE
	bgt a1,t2,LWR_INVALID			# Testa se está no mapa
		loadw( t3,LOLO_POSY )
		calculate_block( a1,t3 )
		jal IS_MORTAL_BLOCK		# Testa se é um bloco mortal
		LWR_NOT_MORTAL:
		la t2, WALKABLE_BLOCKS
		add t3,t2,t1
		lb t3,(t3)
		bgtz t3,LWR_INVALID		# Testa se é um bloco andável
			savew(a1,LOLO_POSX)	# Atualiza a posição de Lolo para a próxima renderização
			jal IS_KEY_BLOCK
	LWR_INVALID:
	jal COLISION_TEST			# Testa colisão com inimigo
	render_sprite(lolo_right_1, LOLO_POSX, LOLO_POSY)						
	frame_refresh()					
	j POLL_LOOP
LOLO_WALK_LEFT:
	jal ERASE_CURRENT_BLOCK		
	switch_frame()			
	loadw(a1,LOLO_POSX)
	addi a1,a1,-16
	li t2, MAP_LEFT_EDGE
	blt a1,t2, LWL_INVALID			# Testa se está no mapa
		loadw( t3,LOLO_POSY )
		calculate_block(a1,t3)
		jal IS_MORTAL_BLOCK		# Testa se é um bloco mortal
		LWL_NOT_MORTAL:
		la t2, WALKABLE_BLOCKS
		add t3,t2,t1
		lb t3,(t3)
		bgtz t3,LWL_INVALID		# Testa se é um bloco andável
			savew(a1,LOLO_POSX)	# Atualiza a posição de Lolo para a próxima renderização
			jal IS_KEY_BLOCK
	LWL_INVALID:
	jal COLISION_TEST
	render_sprite(lolo_left_1, LOLO_POSX, LOLO_POSY)
	frame_refresh()					
	j POLL_LOOP
	
#################################
# Verifica se é um bloco mortal #
#################################
IS_MORTAL_BLOCK:
	la t2, MORTAL_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, NOT_MORTAL
		loadw(t3,LIFE_COUNTER)
		addi t3,t3,-1
		beqz t3, DEAD
			savew(t3,LIFE_COUNTER)
			li t1,74
			li t2,36
			savew(t1,LOLO_POSX)
			savew(t2,LOLO_POSY)
			render_sprite(lolo_pisca,LOLO_POSX,LOLO_POSY)
			call SCORE_REFRESH
			sound(HIT)
			frame_refresh()	
			j POLL_LOOP
		DEAD:
		switch_frame()
		you_died()
	NOT_MORTAL:
	ret
################################
# Verifica se é um bloco chave #
################################
IS_KEY_BLOCK:
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, IKB_INVALID	# Testa se o bloco está marcado como KEY no vetor KEY_BLOCKS
		li t3,0
		sb t3,(t2)
		loadw(t2,KEY_COUNTER)
		addi t2,t2,-1	
		savew(t2,KEY_COUNTER)
		mv s7,ra
		door_refresh()
		erase_block()
		sound(FOUND_KEY)
		mv ra,s7	
	IKB_INVALID:
	ret

#######################
# Apaga o bloco atual #
#######################	
ERASE_CURRENT_BLOCK:			
	loadw(t3,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	calculate_block(t3,t2)
	# Calcula o bloco atual de lolo (vai ser apagado)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	mv a7,ra
	beqz t3, LWU_NOT_BRIDGE  # Testa se deve apagar com ponte
		render_sprite(bridge,LOLO_POSX,LOLO_POSY)
		mv ra,a7
		ret
	LWU_NOT_BRIDGE:
	render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
	mv ra,a7
	ret

################################
# Testa se o bloco é uma porta #
################################
IS_DOOR:
	li t1, DOOR_POSX
	li t2, DOOR_POSY		
	bne t2,a1,ID_FALSE			# Se a coordenada Y de lolo e da porta não coincidem, pula
		loadw( t3,LOLO_POSX )
		bne t3,t1,ID_FALSE		# Se coincidem, testa a coordenada X
			loadw(t1,DOOR_STATE)
			bnez t1, ID_FALSE 	# Testa se a porta está aberta (state = 1)
				savew( a1,LOLO_POSY )
				render_sprite(lolo_coca, LOLO_POSX, LOLO_POSY)
				frame_refresh()						
				finished_level()	
	ID_FALSE:
	ret
