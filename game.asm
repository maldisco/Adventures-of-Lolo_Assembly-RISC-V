GAME:	
	LOADW(t0,CURRENT_LEVEL)
	li t1,1
	beq t0,t1,STAGE_ONE
	li t1,2
	beq t0,t1,STAGE_TWO
	li t1,3
	beq t0,t1,STAGE_THREE
	li t1,4
	beq t0,t1,STAGE_FOUR
	ending()
STAGE_ONE:
	level_title(fase_1)
	stage_one()
	j GAMEPLAY
STAGE_TWO:
	level_title(fase_2)
	stage_two()
	j GAMEPLAY
STAGE_THREE:
	level_title(fase_3)
	stage_three()
	j GAMEPLAY
STAGE_FOUR:
	level_title(fase_4)
	stage_four()
GAMEPLAY:
	SWITCH_FRAME()
	PRINT_DYN_IMG(lolo_coca,LOLO_POSX,LOLO_POSY)
	li s0, MMIO_set
	li a7,30
	ecall
	SAVEW(a0,CLOCK)
POLL_LOOP:				# LOOP de leitura e captura de tecla
#	li s0, MMIO_set
	lb a6,(s0)
	# A cada 1 segundo o RARS executa alguma ação
	LOADW(t0,CURRENT_LEVEL)
	li t1,4
	blt t0,t1,AINDA_NAO
	li a7,30
	ecall
	mv a1,a0
	LOADW(t0,CLOCK)
	sub a0,a0,t0
	li t0,1000
	ble a0,t0,AINDA_NAO
	SAVEW(a1,CLOCK)
	li a7,1
	li a0,5
	ecall
	jal ENEMY_WALK
AINDA_NAO:
	#
	beqz a6,POLL_LOOP		# Enquanto não houver nenhuma tecla apertada, retorna ao loop
	li s11,MMIO_add
	lw s11, (s11)			# Tecla capturada em S11
	jal LOLO_WALK
	j POLL_LOOP	
