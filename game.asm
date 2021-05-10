GAME:	
	LOADW(t0,CURRENT_LEVEL)
	li t1,1
	beq t0,t1,STAGE_ONE
	li t1,2
	beq t0,t1,STAGE_TWO
	ending()
STAGE_ONE:
	level_title(fase_1)
	setup()
	stage_one()
	j GAMEPLAY
STAGE_TWO:
	level_title(fase_2)
	setup()
	stage_two()
	j GAMEPLAY
GAMEPLAY:
	PRINT_DYN_IMG( lolo_coca,LOLO_POSX,LOLO_POSY)
	li s0, MMIO_set
POLL_LOOP:				# LOOP de leitura e captura de tecla
#	li s0, MMIO_set
	lb t1,(s0)
	beqz t1,POLL_LOOP		# Enquanto n�o houver nenhuma tecla apertada, retorna ao loop
	li s11,MMIO_add
	lw s11, (s11)			# Tecla capturada em S11
	jal LOLO_WALK
	j POLL_LOOP	