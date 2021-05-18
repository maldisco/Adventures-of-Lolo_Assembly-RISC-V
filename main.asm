.data
.include "./common.asm"
.include "MACROSv21.s"
.text
main:	
	start_menu()


###########################
#  Executa o menu inicial #
###########################
START_MENU:
	li t0, FRAME_0
	la s0, start_menu_1
	call IMPRIME
	# Tela com 'START' selecionado
	li t0, FRAME_1
	la s0, start_menu_2
	call IMPRIME
	# Tela com 'PASSWORD' selecionado
	
	# a0 = tempo
	li a7,30
	ecall
	# Salva o horário no momento em que entrou no menu
	savew(a0,CLOCK)
	
	li s0, MMIO_set
	li a4, DOWN			# a0 = 'S'
	li a5, UP			# a1 = 'W'
	li a6, SELECT			# a2 = 'E'
	
	la s9, A_VAGUE_HOPE
SM_POLL_LOOP:				# LOOP de leitura e captura de tecla
	lb t1,(s0)	# t1 = estado do teclado (0 = nada apertado)
	
	lw t2,(s9)	# t2 = valor da nota
	lw t3,4(s9)	# t3 = duração da nota
	li a7,30
	ecall		# a0 = horário atual
	loadw(t4,CLOCK)	# t4 = horário no loop anterior
	sub t4,a0,t4	# t4  = a0-t4 = passagem de tempo
	ble t4,t3,SM_NAO_TOCA	# se a passagem for maior que a duração da nota, entra
		mv a0,t2
		mv a1,t3
		li a2,7			# instrumento
		li a3,30		# volume
		call midiOut		# toca a nota
		addi s9,s9,8
		li a7,30
		ecall		# a0 = horário atual
		savew(a0,CLOCK)	# salva horário atual para próximo loop
SM_NAO_TOCA:
	
	beqz t1,SM_POLL_LOOP		
	li s11,MMIO_add
	lw s11, (s11)			
	# Tecla capturada em S11, 'W' troca para frame 0, 'S' para frame 1 e 'E' seleciona um
	beq s11, a6, SM_SELECTED
	beq s11, a5, SM_START
	beq s11, a4, SM_PASSWORD
	j SM_POLL_LOOP
	
SM_START:					
	li t2, FRAME_SELECT
	li t3, 0
	sb t3,(t2)
	j SM_POLL_LOOP
	
SM_PASSWORD:
	li t2, FRAME_SELECT
	li t3, 1
	sb t3,(t2)
	j SM_POLL_LOOP
	
SM_SELECTED:
	li t2, FRAME_SELECT
	lb t3, (t2)
	beqz t3, GAME
	j PASSWORD
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
	li t2,121
	li t3,0
RB_LOOP:
	bge t3,t2,RB_FORA
	li t4,0
	sb t4,(t0)
	sb t4,(t1)
	sb t4,(t5)
	sb t4,(t6)
	addi t0,t0,1
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
	beq t1,t3,CT_1
	ret
CT_1:
	beq t2,t4,CT_HIT
	ret
CT_HIT:
	loadw(t1,LIFE_COUNTER)
	addi t1,t1,-1
	bnez t1,CT_ALIVE
	you_died()
CT_ALIVE:
	savew(t1,LIFE_COUNTER)
	li t1,74
	li t2,36
	savew(t1,LOLO_POSX)
	savew(t2,LOLO_POSY)
	render_sprite(lolo_coca,LOLO_POSX,LOLO_POSY)
	j CT_RETURN

			
.include "game.asm"
.include "enemy.asm"
.include "walk.asm"
.include "render.asm"
.include "SYSTEMv21.s"