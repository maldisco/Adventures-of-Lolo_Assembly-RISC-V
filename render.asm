#################################
# Loop imprime uma sprite 16x16 #		 
#################################
PS_LOOP: 	
	bge a1,a2,PS_FORA			# Se for o último endereço então sai do loop
		bne t1,a3, PS_CONTINUA		# Testa se 16 pixels foram pintados (1 linha)
			sub a1,a1,a3
			addi a1,a1,320		
			li t1,0			# Desce para a próxima linha
		PS_CONTINUA:
		lb t3, 0(s1)			# Carriga o byte da sprite
		beq t3, t2, PS_PULA		# Testa se o byte é da cor t6
			sb t3, 0(a1)		# Pinta o byte no endereço do BitMap
		PS_PULA:	
		addi t1,t1,1
		addi a1,a1,1 
		addi s1,s1,1
		j PS_LOOP			
	PS_FORA:
	ret
##########################################
# Imprime algo em toda a frame (320x240) #
##########################################
IMPRIME:
	lw t4,0(s0)			# numero de colunas
	lw t5,4(s0)			# numero de linhas
	addi s0,s0,8			# primeiro pixels depois das informações de nlin ncol
	mul t1,t4,t5          	  	# numero total de pixels da imagem
	li t2,0
	I_LOOP1:
 	beq t1,t2,I_FIM			# Se for o último endereço então sai do loop
		lw t3,0(s0)		# le um conjunto de 4 pixels : word
		sw t3,0(t0)		# escreve a word na memória VGA
		addi t0,t0,4		# soma 4 ao endereço
		addi s0,s0,4
		addi t2,t2,1		# incrementa contador de bits
		j I_LOOP1		# volta a verificar
	I_FIM:	
	ret
####################################
# Marca as coordenadas como bloco  #
####################################
MARK_AS_BLOCK:
	mv t1, a2
	mv t2, a3
	mv s1, a1
	calculate_block(t1,t2)		# Bloco (x,y) = T1
	la t2,WALKABLE_BLOCKS
	add t2,t2,t1
	li t3,1
	li t4,0
	mv t5,a0
	MAB_LOOP:	
	bge t4,t5,MAB_LOOP_FORA		# Loop de quantos blocos serão marcados
		sb t3,(t2)		# Marca como unwalkable no vetor 'walkable blocks'
		addi t4,t4,1
		addi t2,t2,1
		j MAB_LOOP		
	MAB_LOOP_FORA:
	ret	
#################################
# Loop imprime uma sprite 16x16 #		 
#################################
PS_LOOP_TESTE: 	
	bge a1,a2,PS_FORAT			# Se for o último endereço então sai do loop
		bne t1,a3, PS_CONTINUAT		# Testa se 16 pixels foram pintados (1 linha)
			sub a1,a1,a3
			sub a4,a4,a3
			addi a1,a1,320		
			addi a4,a4,320
			li t1,0			# Desce para a próxima linha
		PS_CONTINUAT:
		lb t3, 0(s1)			# Carriga o byte da sprite
		beq t3, t2, PS_PULAT		# Testa se o byte é da cor t6
			sb t3, 0(a1)		# Pinta o byte no endereço do BitMap
			sb t3, 0(a4)
		PS_PULAT:	
		addi t1,t1,1
		addi a1,a1,1 
		addi a4,a4,1
		addi s1,s1,1
		j PS_LOOP_TESTE			
	PS_FORAT:
	ret