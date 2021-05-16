###########################################################################
### 1. [X] Imprimir os elementos estáticos				###
### 2. [X] Movimentar o lolo com WASD					###
### 2.1 [X] tentar implementar movimentação em blocos <- OLHA AQUI 	###
### 3. [X] Travar a movimentação dentro do mapa				###
### 4. [X] Colisões com objetos estáticos				###
### 5. [X] Menu inicial e tela de encerramento				###
### 5.1 [X] Menu inicial com 2 opções					###
### 5.1.1 [X] Start							###
### 5.1.2 [X] Password							###
### 5.2 [X] Tela de encerramento					###
### 5.2.1 [X] Passou de fase						###
### 5.2.2 [X] Zerou							###
### 5.2.3 [X] Perdeu							###
### 6. [X] Imprimir os elementos dinâmicos				###
### 7. [X] Colisões com objetos dinâmicos				###
### 8. [X] Inimigos							###
### 9. [] Colisões com ataques inimigos					###
### 10. [X] Morte							###
### Lembrete: FASE SECRETA COM PUZZLES				    	###
### Lembrete: BOSS FINAL SANS UNDERTALE				    	###
###########################################################################
.data
.include "./common.asm"
.text
main:	
	start_menu()


###########################
#  Executa o menu inicial #
###########################
START_MENU:
	li t0, FRAME_0
	la s0, start_menu_1
	jal IMPRIME
	# Tela com 'START' selecionado
	li t0, FRAME_1
	la s0, start_menu_2
	jal IMPRIME
	# Tela com 'PASSWORD' selecionado
	li s0, MMIO_set
	li a0, DOWN			# a0 = 'S'
	li a1, UP			# a1 = 'W'
	li a2, SELECT			# a2 = 'E'
	
SM_POLL_LOOP:				# LOOP de leitura e captura de tecla
	lb t1,(s0)
	beqz t1,SM_POLL_LOOP		
	li s11,MMIO_add
	lw s11, (s11)			
	# Tecla capturada em S11, 'W' troca para frame 0, 'S' para frame 1 e 'E' seleciona um
	beq s11, a2, SM_SELECTED
	beq s11, a1, SM_START
	beq s11, a0, SM_PASSWORD
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
	la s0,GOLDEN_WIND_NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,GOLDEN_WIND_NOTES		# define o endereço das notas
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
	SWITCH_FRAME()
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
	j START_MENU
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
# Refresca o estado a porta #
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
	SAVEW(t1,DOOR_STATE)
	ret

##########################################
# Testar colisão entre lolo e um inimigo #
##########################################
COLISION_TEST:
	LOADW(t1,LOLO_POSX)
	LOADW(t2,LOLO_POSY)
	LOADW(t3,ENEMY_POSX)
	LOADW(t4,ENEMY_POSY)
	beq t1,t3,CT_1
	ret
CT_1:
	beq t2,t4,CT_HIT
	ret
CT_HIT:
	LOADW(t1,LIFE_COUNTER)
	addi t1,t1,-1
	bnez t1,CT_ALIVE
	you_died()
CT_ALIVE:
	SAVEW(t1,LIFE_COUNTER)
	li t1,74
	li t2,36
	SAVEW(t1,LOLO_POSX)
	SAVEW(t2,LOLO_POSY)
	ret

			
.include "game.asm"
.include "enemy.asm"
.include "walk.asm"
.include "render.asm"
