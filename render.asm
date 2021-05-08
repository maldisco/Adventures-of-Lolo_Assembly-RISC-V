#################################
#      LOOP PRINT N SPRITES	#
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
	li a1,FRAME_0		# endereco inicial da Memoria VGA - Frame 0
	LOADW(t0,CURRENT_FRAME)
	beqz t0, PSI_PULA_1
	li a1,FRAME_1		# endereco inicial da Memoria VGA - Frame 1
PSI_PULA_1:	
	mv t1, a3		# linha 
	mv t2, a2		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 15x320 + 16 	
	mv a7, s1
	li a3,16		# todos os sprites são quadrados 16x16
	mv a4,a1		# guarda os endereços inicial e final
	mv a5,a2		# serao usados posteriormente
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
#     LOOPS PRINT STC IMG	#		 
#################################
PSI_LOOP_2: 	
	bge a1,a2,PSI_FORA_2		# Se for o último endereço então sai do loop
	bne t1,a3, PSI_CONTINUA_2
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
PSI_CONTINUA_2:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PSI_PULA_2	# testa se o byte é da cor t6
	sb t3, 0(a1)		# pinta o byte
PSI_PULA_2:	
	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j PSI_LOOP_2			# volta a verificar
PSI_FORA_2:
	ret
#################################
#     LOOPS PRINT DYN IMG	#		 
#################################
# RENDERING
PDI_LOOP: 	
	bge a1,a2,PDI_FORA		# Se for o último endereço então sai do loop
	bne t1,a3, PDI_CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra próxima linha
PDI_CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PDI_PULA	# testa se o byte é da cor t6, se for não o desenha
	sb t3, 0(a1)		# pinta o byte
PDI_PULA:	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j PDI_LOOP			# volta a verificar
PDI_FORA:
	ret