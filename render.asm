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

MARK_AS_BLOCK:
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
MAB_LOOP:	
	bge t4,t5,MAB_LOOP_FORA	
	sb t3,(t2)		
	addi t4,t4,1
	addi t2,t2,1
	j MAB_LOOP
MAB_LOOP_FORA:
	ret	
