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
##########################################
# Marca N blocos na horizontal como algo #
# N = a0				 #
##########################################
HORIZONTAL:
	li t1,1
	li t2,0
	H_LOOP:	
	bge t2,a0,H_LOOP_OUT		# Loop de quantos blocos serão marcados
		sb t1,(a3)		# Marca como unwalkable no vetor 'walkable blocks'
		addi t2,t2,1
		addi a3,a3,1
		j H_LOOP		
	H_LOOP_OUT:
	ret	
#######################################
# Marca N blocos na verical como algo #
# N = a0			      #
#######################################
VERTICAL:
	li t1,1
	li t2,0
	V_LOOP:	
	bge t2,a0,V_LOOP_OUT		# Loop de quantos blocos serão marcados
		sb t1,(a3)		# Marca como unwalkable no vetor 'walkable blocks'
		addi t2,t2,1
		addi a3,a3,11
		j V_LOOP		
	V_LOOP_OUT:
	ret
#################################
# Loop imprime uma sprite 16x16 #
# nas duas frames		#		 
#################################
PAS_LOOP: 	
	bge a1,a2,PAS_FORA			# Se for o último endereço então sai do loop
		bne t1,a3, PAS_CONTINUA		# Testa se 16 pixels foram pintados (1 linha)
			sub a1,a1,a3
			sub a4,a4,a3
			addi a1,a1,320		
			addi a4,a4,320
			li t1,0			# Desce para a próxima linha
		PAS_CONTINUA:
		lb t3, 0(s1)			# Carriga o byte da sprite
		beq t3, t2, PAS_PULA		# Testa se o byte é da cor t2
			sb t3, 0(a1)		# Pinta o byte no endereço do BitMap
			sb t3, 0(a4)
		PAS_PULA:	
		addi t1,t1,1
		addi a1,a1,1 
		addi a4,a4,1
		addi s1,s1,1
		j PAS_LOOP			
	PAS_FORA:
	ret
