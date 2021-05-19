#########################################	
# Imprime uma tela preta no frame atual #	
#########################################
BLACK_SCREEN:
	li t1,0xFF000000	
	li t2,0xFF012C00	
	beqz t3, BS_PULA
		li t1,0xFF100000	
		li t2,0xFF112C00	
	BS_PULA:
	li t3,0x00000000	
	BS_LOOP:
 	beq t1,t2,BS_FORA	
		sw t3,0(t1)		
		addi t1,t1,4		
		j BS_LOOP		
	BS_FORA:
	ret
#######################
# Lê e reproduz notas #
#######################	
SOUNDTRACK:
	la s0,LAST_GOODBYE_NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,LAST_GOODBYE		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,7			# define o instrumento
	li a3,30		# define o volume

	OST_LOOP:	
	beq t0,s1, OST_FIM		# contador chegou no final? então  vá para FIM
		lw a0,0(s0)		# le o valor da nota
		lw a1,4(s0)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		mv a0,a1		# passa a duração da nota para a pausa
		li a7,32		# define a chamada de syscal 
		ecall			# realiza uma pausa de a0 ms
		addi s0,s0,8		# incrementa para o endereço da próxima nota
		addi t0,t0,1		# incrementa o contador de notas
		j OST_LOOP			# volta ao loop
	
	OST_FIM:
	ret
#########################
# Lê e checa o password	#
#########################
PASSWORD:
	switch_frame()
	frame_address(a1)
	mv t0,a1
	la s0,password_screen
	jal IMPRIME
	frame_refresh()
	li s0, MMIO_set
	PW_POLL_LOOP:		
		lb t1,(s0)
	beqz t1,PW_POLL_LOOP		
	li s11,MMIO_add
	lw s11, (s11)	
	# s11 possui o caractere digitado em password
	li t0, PW_STAGE_ONE
	beq t0,s11,STAGE_ONE
	
	li t0, PW_STAGE_TWO
	beq t0,s11,STAGE_TWO
	
	li t0, PW_STAGE_THREE
	beq t0,s11,STAGE_THREE
	
	li t0, PW_STAGE_FOUR
	beq t0,s11,STAGE_FOUR
	
	li t0, PW_FINAL_STAGE
	beq t0,s11,FINAL_STAGE
	
	li t0,PW_ENDING
	beq t0,s11,NO_CHEATING
	
	j START_MENU
	
	NO_CHEATING:
	ending()
######################################
# Seta todos os blocos para o padrão #
######################################	
RESET_BLOCKS:
	la t0,KEY_BLOCKS
	la t1,WALKABLE_BLOCKS
	la t5,BRIDGE_BLOCKS
	la t6,MORTAL_BLOCKS
	la a1,PUSHABLE_BLOCKS
	li t2,121
	li t3,0
	RB_LOOP:
	bge t3,t2,RB_FORA
		li t4,0
		sb t4,(t0)
		sb t4,(t1)
		sb t4,(t5)
		sb t4,(t6)
		sb t4,(a1)
		addi t0,t0,1
		addi a1,a1,1
		addi t1,t1,1
		addi t5,t5,1
		addi t6,t6,1
		addi t3,t3,1	# contador
		j RB_LOOP
	RB_FORA:
	ret
#############################
# Atualiza o estado a porta #
#############################
DOOR_TEST:
	beqz t0, DT_OPEN
		la s1, porta_fechada
		ret
	DT_OPEN:
	la s1, porta
	ret
##########################################
# Abre a porta após pegar a ultima chave #
# t1 = número de chaves restantes 	 #
##########################################
KEY_TEST:
	beqz t1, KT_OPEN_DOOR
		li t2,1
		beq t1,t2,CHEST_OPEN
			ret
		CHEST_OPEN:
			mv s8,ra
			li t1,1
			savew(t1,SHOOTING_ENEMY)
			render_abs_sprite(open_chest,CHEST_POSX,CHEST_POSY)
			loadw(t1,CHEST_POSX)
			loadw(t2,CHEST_POSY)
			calculate_block(t1,t2)
			la t2,WALKABLE_BLOCKS
			add t2,t2,t1
			li t1,0
			sb t1,(t2)
			mv ra,s8
			ret
	KT_OPEN_DOOR:
	savew(t1,DOOR_STATE)
	ret

##########################################
# Testar colisão entre lolo e um inimigo #
##########################################
COLISION_TEST:
	loadw(t1,LOLO_POSX)
	loadw(t2,LOLO_POSY)
	loadw(t3,CURRENT_ENEMY_POSX)
	loadw(t4,CURRENT_ENEMY_POSY)
	loadw(t5,SHOT_POSX)
	loadw(t6,SHOT_POSY)
	beq t1,t3,CT_1		
		beq t1,t5,CT_2
			ret		# Se o X não coincide, não houve colisão
		CT_2:
		beq t2,t6,CT_HIT
			ret
	CT_1:
	beq t2,t4,CT_HIT	
		ret		# Se o Y não coincide, não houve colisão
	CT_HIT:
	mv s7,ra
	loadw(t1,LIFE_COUNTER)	# Ambos coincidem, houve colisão
	addi t1,t1,-1
	bnez t1,CT_ALIVE	# Se a vida após colisão for 0, morte
		you_died()
	CT_ALIVE:		# Se não, reinicia a posição de lolo no mapa
	savew(t1,LIFE_COUNTER)
	loadw(t1,LOLO_INITIAL_POSX)
	loadw(t2,LOLO_INITIAL_POSY)
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	render_sprite(lolo_coca,LOLO_POSX,LOLO_POSY)
	call SCORE_REFRESH
	sound(HIT)
	mv ra,s7
	ret

###############################################
# Reseta as posições dos inimigos entre fases #
###############################################
RESET_ENEMIES:
	li t1,0
	savew(t1,SHOT_POSX)
	savew(t1,SHOT_POSY)
	savew(t1,CURRENT_ENEMY_POSX)
	savew(t1,CURRENT_ENEMY_POSY)
	ret
	
#####################
# Atualiza o placar #
#####################
SCORE_REFRESH:
	loadw(a7,LIFE_COUNTER)
	li t1,3
	mv a6,ra
	blt a7,t1,SR_JUMP
		render_abs_sprite(score_three,SCORE_POSX,SCORE_POSY)
		mv ra,a6
		ret
	SR_JUMP:
	li t1,2
	blt a7,t1,SR_JUMP_2
		render_abs_sprite(score_two,SCORE_POSX,SCORE_POSY)
		mv ra,a6
		ret
	SR_JUMP_2:
	render_abs_sprite(score_one,SCORE_POSX,SCORE_POSY)
	mv ra,a6
	ret