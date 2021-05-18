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
	loadw(t3,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	calculate_block(t3,t2)
	# Calcula o bloco atual de lolo (vai ser apagado)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWU_NOT_BRIDGE
		render_sprite(bridge,LOLO_POSX,LOLO_POSY)
		# Se � uma ponte, imprime uma ponte
		j LWU_IS_BRIDGE
	LWU_NOT_BRIDGE:
		render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
		# Se � um tijolo, imprime um tijolo
	LWU_IS_BRIDGE:						
	switch_frame()			
	loadw(a1,LOLO_POSY)
	addi a1,a1,-16
	# In�cio teste '� uma porta'
	li t1, DOOR_POSX
	li t2, DOOR_POSY
	bne t2,a1,LWU_CONTINUE	# Se a coordenada Y de lolo e da porta n�o coincidem, pula
		loadw( t3,LOLO_POSX )
		bne t3,t1,LWU_CONTINUE	# Se coincidem, testa a coordenada X
			loadw(t1,DOOR_STATE)
			bnez t1, LWU_INVALID # Testa se a porta est� aberta (state = 1)
				savew( a1,LOLO_POSY )
				render_sprite(lolo_coca, LOLO_POSX, LOLO_POSY)
				li t3, FRAME_SELECT
				loadw(t1,CURRENT_FRAME)			
				sw t1,(t3)
				# Se � uma porta, e est� aberta, fase finalizada				
				finished_level()
	# Fim teste '� uma porta'
	LWU_CONTINUE:
	li t2, MAP_UPPER_EDGE	
	blt a1,t2,LWU_INVALID	# Testa se Lolo saiu do mapa ( Y maior que borda superior do mapa)
	loadw( t3,LOLO_POSX )
	calculate_block(t3,a1)
	jal IS_MORTAL_BLOCK	# Testa se o bloco destino � um bloco mortal
	LWU_NOT_MORTAL:
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWU_NOT_KEY	# Testa se o bloco est� marcado como KEY no vetor KEY_BLOCKS
		li t3,0
		sb t3,(t2)
		loadw(t2,KEY_COUNTER)
		addi t2,t2,-1	
		savew(t2,KEY_COUNTER)
		door_refresh()
		loadw(a1,LOLO_POSY)
		addi a1,a1,-16
		savew(a1,LOLO_POSY)
		erase_block()		
		j LWU_IS_KEY	
	LWU_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWU_INVALID # Testa se � um bloco and�vel
		savew(a1,LOLO_POSY)	# Se sim, atualiza a posi��o de Lolo para a pr�xima renderiza��o	
	LWU_IS_KEY:
	LWU_INVALID:
	jal COLISION_TEST
	render_sprite(lolo_up_1,LOLO_POSX,LOLO_POSY)						
	li t3, FRAME_SELECT
	loadw( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_DOWN:
	loadw(t3,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	calculate_block(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWD_NOT_BRIDGE
		render_sprite(bridge,LOLO_POSX,LOLO_POSY)
		j LWD_IS_BRIDGE
	LWD_NOT_BRIDGE:
	render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
	LWD_IS_BRIDGE:
	switch_frame()			
	loadw(a1,LOLO_POSY)
	addi a1,a1,16
	li t2, MAP_LOWER_EDGE
	bgt a1,t2,LWD_INVALID 	# Teste est� no mapa
	# In�cio teste '� um bloco and�vel'
	loadw( t3,LOLO_POSX )
	calculate_block( t3,a1 )
	jal IS_MORTAL_BLOCK	# Testa se � um bloco mortal
	LWD_NOT_MORTAL:		
		# In�cio teste '� um bloco chave'
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWD_NOT_KEY	# Testa se � um bloco-chave
		li t3,0
		sb t3,(t2)
		loadw(t2,KEY_COUNTER)
		addi t2,t2,-1
		savew(t2,KEY_COUNTER)
		door_refresh()
		loadw(a1,LOLO_POSY)
		addi a1,a1,16
		savew(a1,LOLO_POSY)
		erase_block()		
		j LWD_IS_KEY	
	LWD_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWD_INVALID
		# Fim teste '� um bloco and�vel'
		savew(a1,LOLO_POSY)			
	LWD_IS_KEY:
	LWD_INVALID:
	jal COLISION_TEST	# Testa colis�o com inimigo
	render_sprite( lolo_down_1, LOLO_POSX, LOLO_POSY)					
	li t3, FRAME_SELECT
	loadw( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_RIGHT:
	loadw(t3,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	calculate_block(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWR_NOT_BRIDGE
		render_sprite(bridge,LOLO_POSX,LOLO_POSY)
		j LWR_IS_BRIDGE
	LWR_NOT_BRIDGE:
	render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
	LWR_IS_BRIDGE:						
	switch_frame()					
	loadw( a1,LOLO_POSX )
	addi a1,a1,16
	li t2, MAP_RIGHT_EDGE
	bgt a1,t2,LWR_INVALID	# Testa se est� no mapa
	loadw( t3,LOLO_POSY )
	calculate_block( a1,t3 )
	jal IS_MORTAL_BLOCK	# Testa se � um bloco mortal
	LWR_NOT_MORTAL:
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWR_NOT_KEY	# Testa se � um bloco chave
		li t3,0
		sb t3,(t2)
		loadw(t2,KEY_COUNTER)
		addi t2,t2,-1
		savew(t2,KEY_COUNTER)
		door_refresh()
		loadw(a1,LOLO_POSX)
		addi a1,a1,16
		savew(a1,LOLO_POSX)
		erase_block()		
		j LWR_IS_KEY	
	LWR_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWR_INVALID	# Testa se � um bloco and�vel
		savew( a1,LOLO_POSX )				
	LWR_IS_KEY:
	LWR_INVALID:
	jal COLISION_TEST	# Testa colis�o com inimigo
	render_sprite( lolo_right_1, LOLO_POSX, LOLO_POSY)						
	li t3, FRAME_SELECT
	loadw( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
LOLO_WALK_LEFT:
	loadw(t3,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	calculate_block(t3,t2)
	la t2, BRIDGE_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWL_NOT_BRIDGE
		render_sprite(bridge,LOLO_POSX,LOLO_POSY)
		j LWL_IS_BRIDGE
	LWL_NOT_BRIDGE:
	render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
	LWL_IS_BRIDGE:			
	switch_frame()			
	loadw( a1,LOLO_POSX )
	addi a1,a1,-16
	li t2, MAP_LEFT_EDGE
	blt a1,t2, LWL_INVALID		# Testa se est� no mapa
	loadw( t3,LOLO_POSY )
	calculate_block(a1,t3)
	jal IS_MORTAL_BLOCK		# Testa se � um bloco mortal
	LWL_NOT_MORTAL:
	la t2, KEY_BLOCKS
	add t2,t2,t1
	lb t3,(t2)
	beqz t3, LWL_NOT_KEY		# Testa se � um bloco chave
		li t3,0
		sb t3,(t2)
		loadw(t2,KEY_COUNTER)
		addi t2,t2,-1
		savew(t2,KEY_COUNTER)
		door_refresh()
		loadw(a1,LOLO_POSX)
		addi a1,a1,-16
		savew(a1,LOLO_POSX)
		erase_block()		
		j LWL_IS_KEY	
	LWL_NOT_KEY:
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWL_INVALID	# Testa se � um bloco and�vel
		savew(a1,LOLO_POSX)			
	LWL_IS_KEY:
	LWL_INVALID:
	jal COLISION_TEST
	render_sprite( lolo_left_1, LOLO_POSX, LOLO_POSY)
	li t3, FRAME_SELECT
	loadw( t1,CURRENT_FRAME )			
	sw t1,(t3)				
	j POLL_LOOP
	
#################################
# Verifica se � um bloco mortal #
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
	li t3, FRAME_SELECT
	loadw( t1,CURRENT_FRAME )			
	sw t1,(t3)
	j POLL_LOOP
DEAD:
	switch_frame()
	you_died()
NOT_MORTAL:
	ret
