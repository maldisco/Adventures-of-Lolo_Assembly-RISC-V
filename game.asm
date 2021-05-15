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
	# Salva o horário no momento em que a fase começou
	SAVEW(a0,CLOCK)
POLL_LOOP:				
	lb a6,(s0)
	# Carrega a estado do teclado em a6 (se 1, então algo foi digitado)
	LOADW(t0,CURRENT_LEVEL)
	li t1,4
	blt t0,t1,NOT_YET
	li a7,30
	ecall
	# Retorna o horário atual
	mv a1,a0
	LOADW(t0,CLOCK)
	sub a0,a0,t0
	# horário atual - inicial
	li t0,500
	ble a0,t0,NOT_YET
	# se maior que 500 milisegundos (0,5 segundos) executa uma ação
	SAVEW(a1,CLOCK)
	jal ENEMY_WALK
NOT_YET:
	beqz a6,POLL_LOOP
	# Testa se algo foi digitado, se não, retorna ao loop		
	li s11,MMIO_add
	lw s11, (s11)			
	# Tecla capturada em s11
	jal LOLO_WALK
	# Executa a movimentação do LOLO
	j POLL_LOOP	
