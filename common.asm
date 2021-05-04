.data
# Constants
.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv MAP_START_ADDRESS  0x2D4A
.eqv MAP_END_ADDRESS	0x108BA
.eqv MAP_LEFT_EDGE	74
.eqv MAP_UPPER_EDGE	36
.eqv MAP_RIGHT_EDGE	249
.eqv MAP_LOWER_EDGE	211

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004
# PTR
CURRENT_FRAME:		.word 0
LOLO_POSX:		.word 74
LOLO_POSY:		.word 36

# Include
.include "./sprites/blocos/tijolo.data"
.include "./sprites/bg/map.data"

########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%sprite, %x, %y, %frame)
	# escolhe a frame aonde a sprite ser� desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:	
	la s1, %sprite
	li a3,16		# todos os sprites s�o quadrados 16x16
	
	li t1, %y		# linha 
	li t2, %x		# coluna
	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endere�o inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endere�o final = endere�o inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endere�o inicial 
	# a2 = endere�o final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
LOOP: 	bge a1,a2,FORA		# Se for o �ltimo endere�o ent�o sai do loop
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra pr�xima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PULA	# testa se o byte � da cor t6
	sb t3, 0(a1)		# pinta o byte
PULA:	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j LOOP			# volta a verificar
FORA:
.end_macro
########################################################
#            IMPRIME N SPRITES 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%n, %sprite, %x, %y, %frame)
	# escolhe a frame aonde a sprite ser� desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:		
	la s1, %sprite
	li a3,16		# todos os sprites s�o quadrados 16x16
	li t1, %y		# linha 
	li t2, %x		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endere�o inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endere�o final = endere�o inicial + 16x320 + 16 
	
	mv a4,a1		# guarda os endere�os inicial e final
	mv a5,a2		# serao usados posteriormente
	li a6,%n		# guarda o numero de blocos a serem desenhados
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endere�o inicial 
	# a2 = endere�o final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# t3 = vari�vel auxiliar de leitura e impress�o de byte
	# t4 = contador de blocos pintados
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
	li t4,0			# segundo contador
LOOP: 	bge a1,a2,FIM		# Se for o �ltimo endere�o ent�o sai do loop	
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra pr�xima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PULA	# testa se o byte � da cor t6
	sb t3, 0(a1)		# pinta o byte
PULA:	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j LOOP			# volta a verificar
FIM:
	addi t4,t4,1
	beq t4,a6,FORA
	addi a1,a4,16		# endere�o inicial do pr�x bloco = endere�o inicial do bloco atual + 16
	addi a2,a5,16		# endere�o final do pr�x bloco = endere�o final do bloco atual + 16
	addi a4,a4,16		# atualiza endere�o inicial atual
	addi a5,a5,16		# atualiza endere�o final atual
	li t1,0
	la s1,%sprite
	addi s1,s1,8
	j LOOP
FORA:
.end_macro
########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_DYN_IMG(%sprite, %buffer_x, %buffer_y, %frame)
	# escolhe a frame aonde a sprite ser� desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:	
	la s1, %sprite
	li a3,16		# todos os sprites s�o quadrados 16x16
	LOADW(t1,%buffer_y)
	LOADW(t2,%buffer_x)	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endere�o inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endere�o final = endere�o inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endere�o inicial 
	# a2 = endere�o final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
LOOP: 	bge a1,a2,FORA		# Se for o �ltimo endere�o ent�o sai do loop
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra pr�xima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PULA	# testa se o byte � da cor t6, se for n�o o desenha
	sb t3, 0(a1)		# pinta o byte
PULA:	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j LOOP			# volta a verificar
FORA:
.end_macro
########################################################
#               DESENHA O BACKGROUND		       #	
########################################################
.macro DRAW_BG(%frame)	
	li t0, 0xff000000
	LOADW(t1,%frame)	# carrega da memoria o frame passado
	beqz t1,VAI		# se for igual a zero, imprime na frame 0
	li t0, 0xff100000	# se n�o, imprime na frame 1
VAI:
	la s0,map
	jal IMPRIME
	PRINT_STC_IMG(11,tijolo,74,36,%frame)
	PRINT_STC_IMG(11,tijolo,74,52,%frame)
	PRINT_STC_IMG(11,tijolo,74,68,%frame)
	PRINT_STC_IMG(11,tijolo,74,84,%frame)
	PRINT_STC_IMG(11,tijolo,74,100,%frame)
	PRINT_STC_IMG(11,tijolo,74,116,%frame)
	PRINT_STC_IMG(11,tijolo,74,132,%frame)
	PRINT_STC_IMG(11,tijolo,74,148,%frame)
	PRINT_STC_IMG(11,tijolo,74,164,%frame)
	PRINT_STC_IMG(11,tijolo,74,180,%frame)
	PRINT_STC_IMG(11,tijolo,74,196,%frame)
.end_macro
########################################################
#   		    FRAME SETUP			       #
########################################################
.macro setup()
	li t3, 0xff200604
	sw t0,(t3)
	DRAW_BG(CURRENT_FRAME)
	li t1,1
	SAVEW(t1,CURRENT_FRAME)
	DRAW_BG(CURRENT_FRAME)
	li t1,0
	SAVEW(t1,CURRENT_FRAME)
.end_macro
########################################################
#   		    SOUNDTRACK			       #
########################################################
.macro ost()
.data
# lista de nota,dura��o,nota,dura��o,nota,dura��o,...
GOLDEN_WIND_NUM: .word 80
GOLDEN_WIND_NOTES: 67,666,64,888,64,111,65,111,66,333,65,333,64,222,62,333,64,333,65,222,67,666,72,666,60,222,62,222,64,333,65,333,64,222,62,333,71,333,69,222,67,666,64,888,64,111,65,111,66,333,65,333,64,222,62,333,64,333,65,222,67,666,72,666,72,222,74,222,76,333,69,333,67,222,66,333,76,333,77,222,79,666,76,888,76,111,77,111,78,333,77,333,76,222,74,333,76,333,77,222,79,666,84,666,72,222,74,222,76,333,77,333,76,222,74,333,83,333,81,222,79,666,76,888,76,111,77,111,78,333,77,333,76,222,74,333,76,333,77,222,79,666,84,666,84,222,86,222,88,333,81,333,79,222,78,333,88,333,85,222
.text
	la s0,GOLDEN_WIND_NUM		# define o endere�o do n�mero de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,GOLDEN_WIND_NOTES		# define o endere�o das notas
	li t0,0			# zera o contador de notas
	li a2,2			# define o instrumento
	li a3,30		# define o volume

LOOP:	beq t0,s1, FIM		# contador chegou no final? ent�o  v� para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a dura��o da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endere�o da pr�xima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP			# volta ao loop
	
FIM:
.end_macro
########################################################
#             CARREGA O VALOR ARMAZENADO	       #
#		    EM UM ENDERE�O	       	       #
########################################################
.macro LOADW(%reg, %label)
	li %reg,0
	la %reg,%label
	lw %reg,(%reg)
.end_macro
########################################################
#               SALVA O VALOR PASSADO		       #
#		    EM UM ENDERE�O	       	       #
########################################################
.macro SAVEW(%reg, %label)
	la t0,%label
	sw %reg,(t0)
.end_macro
########################################################
#               FINALIZA O PROGRAMA		       #	
########################################################
.macro exit()
	li a7,10
	ecall
.end_macro
