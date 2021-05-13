#################################
#     LOOP PRINT N SPRITES	#
#################################
# a0 =  Numero de blocos	#
# a1 =  Endereço da sprite	#
# a2 =  posição X		#
# a3 =  posição Y		#
#################################
PRINT_STC_IMG:
	mv t1, a2
	mv t2, a3
	mv s1, a1
	CALCULATE_BLOCK(t1,t2)		# Bloco (x,y) = T1
	la t2,WALKABLE_BLOCKS
	add t2,t2,t1
	li t3,1
	li t4,0
	mv t5,a0
# LOOP SET UNWALKABLE BLOCKS
PSI_LOOP_0:	
	bge t4,t5,PSI_FORA_0	
	sb t3,(t2)		
	addi t4,t4,1
	addi t2,t2,1
	j PSI_LOOP_0
PSI_FORA_0:	
	# escolhe a frame aonde a sprite será desenhada
	frame_address(a1)	# endereço do frame atual em a1
	mv t1, a3		# linha 
	mv t2, a2		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 15x320 + 16 
		
	mv a7, s1		# cópia do endereço da sprite
	li a3,16		# todos os sprites são quadrados 16x16
	mv a4,a1		# cópia endereço inicial
	mv a5,a2		# cópia endereço final
	mv a6,a0		# guarda o numero de blocos a serem desenhados
	addi s1,s1,8		# chega ao .text
	li t1,0			# contador
	li t2, 0xffffff80
	li t4,0			# segundo contador
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
PSI_LOOP: 	
	bge a1,a2,PSI_FIM		# Se for o último endereço então sai do loop	
	bne t1,a3, PSI_CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
PSI_CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PSI_PULA	# testa se o byte é da cor t6
	sb t3, 0(a1)		# pinta o byte
PSI_PULA:	
	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j PSI_LOOP			# volta a verificar
PSI_FIM:
	addi t4,t4,1
	beq t4,a6,PSI_FORA
	addi a1,a4,16		# endereço inicial do próx bloco = endereço inicial do bloco atual + 16
	addi a2,a5,16		# endereço final do próx bloco = endereço final do bloco atual + 16
	addi a4,a4,16		# atualiza endereço inicial atual
	addi a5,a5,16		# atualiza endereço final atual
	li t1,0
	mv s1,a7
	addi s1,s1,8
	j PSI_LOOP
PSI_FORA:
	ret
#################################
#      LOOP PRINT 1 SPRITE	#		 
#################################
PS_LOOP: 	
	bge a1,a2,PS_FORA		# Se for o último endereço então sai do loop
	bne t1,a3, PS_CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
PS_CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PS_PULA	# testa se o byte é da cor t6
	sb t3, 0(a1)		# pinta o byte
PS_PULA:	
	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j PS_LOOP			# volta a verificar
PS_FORA:
	ret
#################################
#     	RENDER BACKGROUND	#
#################################
IMPRIME:
	lw t4,0(s0)		# numero de colunas
	lw t5,4(s0)		# numero de linhas
	addi s0,s0,8		# primeiro pixels depois das informações de nlin ncol
	mul t1,t4,t5            # numero total de pixels da imagem
	li t2,0
I_LOOP1:
 	beq t1,t2,I_FIM		# Se for o último endereço então sai do loop
	lw t3,0(s0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na memória VGA
	addi t0,t0,4		# soma 4 ao endereço
	addi s0,s0,4
	addi t2,t2,1		# incrementa contador de bits
	j I_LOOP1		# volta a verificar
I_FIM:	
	ret
