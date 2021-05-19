.data
.include "macros.asm"
.include "MACROSv21.s"
.text

# [X] Refatorar
# [X] Contadores
#	[X] Vidas
# [] Visual
#	[] Mapa
#	[] Inimigo
#	[] Objetos
# 	[] Lolo
# [X] Efeitos sonoros
# [X] Animação do inimigo
# [] Baús
# [] Objetos dinamicos
# [] Refazer as fases (com oq eu tiver conseguido implementar acima)

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

.include "common.asm"	
.include "game.asm"
.include "enemy.asm"
.include "walk.asm"
.include "render.asm"
.include "SYSTEMv21.s"
