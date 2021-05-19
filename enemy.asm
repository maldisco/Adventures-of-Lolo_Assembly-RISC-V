.data
CURRENT_ENEMY_POSX:	.word 0
ENEMY_POSX:		.word 0,0,0,0,0,0

CURRENT_ENEMY_POSY:	.word 0
ENEMY_POSY:		.word 0,0,0,0,0,0

CURRENT_ENEMY_SPEED:	.word 0
ENEMY_SPEED:		.word 0,0,0,0,0,0

CURRENT_ENEMY_I_BLOCK:	.word 0
ENEMY_INITIAL_BLOCK:	.word 0,0,0,0,0,0

CURRENT_ENEMY_F_BLOCK:	.word 0
ENEMY_FINAL_BLOCK:	.word 0,0,0,0,0,0

.text
ENEMY_WALK:
#	render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()
#	render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame() 			# Apaga o bloco atual
	render_abs_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
	loadw(a1,CURRENT_ENEMY_POSX)	
	loadw(a2,CURRENT_ENEMY_POSY)
	loadw(a3,CURRENT_ENEMY_SPEED)
	add a1,a1,a3			
	calculate_block(a1,a2)		# Calcula a proxima posição do inimigo
	loadw(t2,CURRENT_ENEMY_F_BLOCK)
	bne t1,t2,EW_KEEP		# Se ela for a posição final
		li t2,-16			
		savew(t2,CURRENT_ENEMY_SPEED)	# Velocidade recebe a direção oposta
		j EW_WALK
	EW_KEEP:
	loadw(t2,CURRENT_ENEMY_I_BLOCK)	# Se ela for a posição inicial
	bne t1,t2,EW_WALK
		li t2,16
		savew(t2,CURRENT_ENEMY_SPEED)	# Velocidade recebe a direção oposta
	EW_WALK:
	loadw(a1,CURRENT_ENEMY_POSX)
	loadw(a2,CURRENT_ENEMY_POSY)
	loadw(a3,CURRENT_ENEMY_SPEED)
	add a1,a1,a3
	savew(a1,CURRENT_ENEMY_POSX)
	call COLISION_TEST		# Testa colisão com Lolo
	CT_RETURN:
#	render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()
#	render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#	switch_frame()			# Renderiza o inimigo na próxima posição
	loadw(a3,CURRENT_ENEMY_SPEED)
	bgez a3,EW_RIGHT
		render_abs_sprite(enemy_left,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		j EW_LEFT
	EW_RIGHT:
		render_abs_sprite(enemy_right,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
	EW_LEFT:
	j POLL_LOOP
	
#######################################################################
# Neste loop 6 inimigos são renderizados utilizando as informações de #
# cada um armazenadas em um vetor				      # 
#######################################################################
ENEMIES_WALK:
	la s3,ENEMY_POSX
	la s4,ENEMY_POSY
	la s5,ENEMY_SPEED
	la s6,ENEMY_INITIAL_BLOCK
	la s7,ENEMY_FINAL_BLOCK
	li t5,0
	li t6,6
	EWS_LOOP:
	beq t5,t6,EWS_DONE	# inicio loop
		lw t3,(s3)
		savew(t3,CURRENT_ENEMY_POSX)	
		lw t3,(s4)
		savew(t3,CURRENT_ENEMY_POSY)
		lw t3,(s5)
		savew(t3,CURRENT_ENEMY_SPEED)
		lw t3,(s6)
		savew(t3,CURRENT_ENEMY_I_BLOCK)
		lw t3,(s7)
		savew(t3,CURRENT_ENEMY_F_BLOCK)
		#
#		render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#		switch_frame()
#		render_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
#		switch_frame()
		render_abs_sprite(tijolo,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		loadw(a1,CURRENT_ENEMY_POSX)
		loadw(a2,CURRENT_ENEMY_POSY)
		loadw(a3,CURRENT_ENEMY_SPEED)
		add a1,a1,a3
		calculate_block(a1,a2)
		li a7,42
		ecall			# a0 = numero aleatorio
		li t4,13
		rem t4,a0,t4		# t4 = resto entre a0 e 13
		bnez t4,EWS_RNG	
			li t4,-1
			mul a3,a3,t4	# Se o resto for igual a 0, o inimigo começa a ir para a direção oposta
			savew(a3,CURRENT_ENEMY_SPEED)
			sw a3,(s5)
		EWS_RNG:
 		# 
		loadw(t2,CURRENT_ENEMY_F_BLOCK)
		bne t1,t2,EWS_KEEP
			li t2,-16
			savew(t2,CURRENT_ENEMY_SPEED)
			sw t2,(s5)
			j EWS_WALK
		EWS_KEEP:
		loadw(t2,CURRENT_ENEMY_I_BLOCK)
		bne t1,t2,EWS_WALK
			li t2,16
			savew(t2,CURRENT_ENEMY_SPEED)
			sw t2,(s5)
		EWS_WALK:
		loadw(a1,CURRENT_ENEMY_POSX)
		loadw(a2,CURRENT_ENEMY_POSY)
		loadw(a3,CURRENT_ENEMY_SPEED)
		add a1,a1,a3
		savew(a1,CURRENT_ENEMY_POSX)
		sw a1,(s3)
		call COLISION_TEST
		#render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		#switch_frame()
		#render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		#switch_frame()
		loadw(a3,CURRENT_ENEMY_SPEED)
		bgez a3,EWS_RIGHT
			render_abs_sprite(enemy_left,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
			j EWS_LEFT
		EWS_RIGHT:
			render_abs_sprite(enemy_right,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
		EWS_LEFT:
		addi s3,s3,4
		addi s4,s4,4
		addi s5,s5,4
		addi s6,s6,4
		addi s7,s7,4
		addi t5,t5,1
		j EWS_LOOP
	EWS_DONE:
	j POLL_LOOP
