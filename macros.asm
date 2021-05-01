.data
.eqv DISPLAY_ADDR       0xFF000000
########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_IMG(%sprite, %x, %y)
.text
	la s1, %sprite
	li a1,DISPLAY_ADDR	# endereco inicial da Memoria VGA - Frame 0
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
.macro PRINT_IMG(%n, %sprite, %x, %y)
.text
	la s1, %sprite
	li a1,DISPLAY_ADDR	# endereco inicial da Memoria VGA - Frame 0
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
#               FINALIZA O PROGRAMA		       #	
########################################################
.macro exit()
	li a7,10
	ecall
.end_macro

