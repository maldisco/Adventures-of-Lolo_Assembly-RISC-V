.data
.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
CURRENT_FRAME:		.word 0
LOLO_POSX:		.word 72
LOLO_POSY:		.word 38
########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%sprite, %x, %y, %frame)
.text
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
	li t1,5136		# 16x320 +16	
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
LOOP: 	beq a1,a2,FORA		# Se for o último endereço então sai do loop
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
.text

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
	li t1,5136		# 16x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	mv a4,a1		# guarda os endereços inicial e final
	mv a5,a2		# serao usados posteriormente
	li a6,%n		# guarda o numero de blocos a serem desenhados
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# t3 = variável auxiliar de leitura e impressão de byte
	# t4 = contador de blocos pintados
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
	li t4,0			# segundo contador
LOOP: 	beq a1,a2,FIM		# Se for o último endereço então sai do loop	
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
FIM:
	addi t4,t4,1
	beq t4,a6,FORA
	addi a1,a4,16		# endereço inicial do próx bloco = endereço inicial do bloco atual + 16
	addi a2,a5,16		# endereço final do próx bloco = endereço final do bloco atual + 16
	addi a4,a4,16		# atualiza endereço inicial atual
	addi a5,a5,16		# atualiza endereço final atual
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
.text

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
	li t1,5136		# 16x320 +16	
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
LOOP: 	beq a1,a2,FORA		# Se for o último endereço então sai do loop
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
#            APAGA O SPRITE DESENHADO NAS	       #	 	
#	      COORDENADAS (X,Y) PASSADAS               #
#	     PINTANDO UM TIJOLO, QUE É O	       #  
#	     BLOCO PADRÃO NA CAMADA ZERO               #
########################################################
.macro ERASE(%buffer_x, %buffer_y, %frame)
.data
.include "./sprites/blocos/tijolo.data"
.text
	# escolhe a frame aonde a sprite será desenhada
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,%frame)
	beqz t0, PULA_1
	li a1,FRAME_1
PULA_1:	
	la s1, tijolo
	li a3,16		# todos os sprites são quadrados 16x16

	LOADW(t1,%buffer_y)
	LOADW(t2,%buffer_x)	
	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,5136		# 16x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pinados
	# ==========================================================
	li t1,0			# contador
LOOP: 	beq a1,a2,FORA		# Se for o último endereço então sai do loop
	bne t1,a3, CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	sb t3, 0(a1)		# pinta o byte
	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j LOOP			# volta a verificar
FORA:
.end_macro
########################################################
#               REDESENHA O BACKGROUND		       #	
########################################################
.macro REDRAW_BG(%frame)
.data
.include "./sprites/bg/map.data"	
.text	
	li t0, 0xff000000
	LOADW(t1,%frame)	# carrega da memoria o frame passado
	beqz t1,VAI		# se for igual a zero, imprime na frame 0
	li t0, 0xff100000	# se não, imprime na frame 1
VAI:
	la s0,map
	jal IMPRIME
.end_macro
########################################################
#             CARREGA O VALOR ARMAZENADO	       #
#		    EM UM ENDEREÇO	       	       #
########################################################
.macro LOADW(%reg, %label)
.text
	li %reg,0
	la %reg,%label
	lw %reg,(%reg)
.end_macro
########################################################
#               SALVA O VALOR PASSADO		       #
#		    EM UM ENDEREÇO	       	       #
########################################################
.macro SAVEW(%reg, %label)
.text
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

