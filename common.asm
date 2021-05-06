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
.eqv WALKABLE_BLOCKS_PATH   0x10010114

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004
# PTR
CURRENT_FRAME:		.word 0
LOLO_POSX:		.word 74
LOLO_POSY:		.word 36
WALKABLE_BLOCKS:	.space 121

# Include
.include "./sprites/blocos/tijolo.data"
.include "./sprites/blocos/rock.data"
.include "./sprites/blocos/arvore.data"
.include "./sprites/blocos/arbusto.data"
.include "./sprites/bg/map.data"

########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%sprite, %x, %y, %frame)
	# escolhe a frame aonde a sprite será desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:	
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16
	
	li t1, %y		# linha 
	li t2, %x		# coluna
	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
LOOP: 	bge a1,a2,FORA		# Se for o último endereço então sai do loop
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PULA	# testa se o byte é da cor t6
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
	li t1, %x
	li t2, %y
	CALCULATE_BLOCK(t1,t2)		# Bloco (x,y) = T1
	la t2,WALKABLE_BLOCKS
	add t2,t2,t1
	li t3,1
	li t4,0
	li t5,%n
	jal PSI_LOOP_0
	# escolhe a frame aonde a sprite será desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:		
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16
	li t1, %y		# linha 
	li t2, %x		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	mv a4,a1		# guarda os endereços inicial e final
	mv a5,a2		# serao usados posteriormente
	li a6,%n		# guarda o numero de blocos a serem desenhados
	
	addi s1,s1,8		# chega ao .text
	li t1,0			# contador
	li t2, 0xffffff80
	li t4,0			# segundo contador
	la a7,%sprite
	# ==========================================================
	# a1 = endereço inicial (atualizado a cada bloco)
	# a2 = endereço final (atualizado a cada bloco)
	# a3 = numero de pixels a serem pintados por linha
	# a4 = endereço inicial bloco 1
	# a5 = endereço final bloco 1
	# a6 = numero de blocos a serem pintados
	# a7 = endereço da sprite a ser pintada
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# t3 = variável auxiliar de leitura e impressão de byte
	# t4 = contador de blocos pintados
	# ==========================================================
	jal PSI_LOOP
.end_macro
########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_DYN_IMG(%sprite, %buffer_x, %buffer_y, %frame)
	# escolhe a frame aonde a sprite será desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:	
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16
	LOADW(t1,%buffer_y)
	LOADW(t2,%buffer_x)	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
LOOP: 	bge a1,a2,FORA		# Se for o último endereço então sai do loop
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PULA	# testa se o byte é da cor t6, se for não o desenha
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
	li t0, 0xff100000	# se não, imprime na frame 1
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
	#reset walkable blocks
	la t1,WALKABLE_BLOCKS
	li t2,121
	li t3,0
LOOP:	bge t3,t2,FORA
	li t4,0
	sb t4,(t1)
	addi t1,t1,1
	addi t3,t3,1
	j LOOP
FORA:
.end_macro
########################################################
#   		    IMPRIME LEVEL 1		       #
########################################################
.macro level_1()
	PRINT_STC_IMG(4,rock,90,116,CURRENT_FRAME)
	PRINT_STC_IMG(4,arbusto,90,132,CURRENT_FRAME)
	la t1,CURRENT_FRAME
	lw t2, (t1)
	xori t2,t2,0x001
	sw t2, (t1)
	PRINT_STC_IMG(4,rock,90,116,CURRENT_FRAME)
	PRINT_STC_IMG(4,arbusto,90,132,CURRENT_FRAME)
	la t1,CURRENT_FRAME
	lw t2, (t1)
	xori t2,t2,0x001
	sw t2, (t1)
	
.end_macro
########################################################
#   		    SOUNDTRACK			       #
########################################################
.macro ost()
.data
# lista de nota,duração,nota,duração,nota,duração,...
GOLDEN_WIND_NUM: .word 71
GOLDEN_WIND_NOTES: 59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,1622,60,202,59,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,2838,64,202,62,202,60,202,59,202,60,405,60,202,60,405,60,607,59,405,60,405,64,405,67,1622,60,202,60,4257,59,608,60,202,60,3244

.text
	la s0,GOLDEN_WIND_NUM		# define o endereço do número de notas
	lw s1,0(s0)		# le o numero de notas
	la s0,GOLDEN_WIND_NOTES		# define o endereço das notas
	li t0,0			# zera o contador de notas
	li a2,7			# define o instrumento
	li a3,30		# define o volume

LOOP:	beq t0,s1, FIM		# contador chegou no final? então  vá para FIM
	lw a0,0(s0)		# le o valor da nota
	lw a1,4(s0)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	mv a0,a1		# passa a duração da nota para a pausa
	li a7,32		# define a chamada de syscal 
	ecall			# realiza uma pausa de a0 ms
	addi s0,s0,8		# incrementa para o endereço da próxima nota
	addi t0,t0,1		# incrementa o contador de notas
	j LOOP			# volta ao loop
	
FIM:
.end_macro
########################################################
#             CARREGA O VALOR ARMAZENADO	       #
#		    EM UM ENDEREÇO	       	       #
########################################################
.macro LOADW(%reg, %label)
	li %reg,0
	la %reg,%label
	lw %reg,(%reg)
.end_macro
########################################################
#             CALCULA O BLOCO UTILIZANDO 	       #
#		AS COORDENADAS (X,Y)	       	       #
########################################################
.macro CALCULATE_BLOCK(%regx,%regy)
	mv t1,%regx
	mv t3,%regy
	addi t1,t1,-74
	li t2,16
	div t1,t1,t2		# X grid = T1
	addi t3,t3,-36
	li t2,16
	div t3,t3,t2		# Y grid = T3
	li t2,11
	mul t3,t3,t2		
	add t1,t1,t3		# Bloco (x,y) = T1
.end_macro
########################################################
#               SALVA O VALOR PASSADO		       #
#		    EM UM ENDEREÇO	       	       #
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
