###########################################################################
### 1. [X] Imprimir os elementos est�ticos				###
### 2. [X] Movimentar o lolo com WASD					###
### 2.1 [X] tentar implementar movimenta��o em blocos <- OLHA AQUI 	###
### 3. [X] Travar a movimenta��o dentro do mapa				###
### 4. [X] Colis�es com objetos est�ticos				###
### 5. [] Imprimir os elementos din�micos				###
### 6. [] Colis�es com objetos din�micos				###
### 7. [] Inimigos							###
### 8. [] Colis�es com ataques inimigos					###
### 9. [] Morte								###
###########################################################################
.data
.include "./sprites/lolo/lolo_coca.data"
.include "./common.asm"
.text
main:	
	setup()
	level_1()
	ost()
	PRINT_DYN_IMG(lolo_coca,LOLO_POSX,LOLO_POSY,CURRENT_FRAME)
	li s0, MMIO_set
POLL_LOOP:				# LOOP de leitura e captura de tecla
#	li s0, MMIO_set
	lb t1,(s0)
	beqz t1,POLL_LOOP		# Enquanto n�o houver nenhuma tecla apertada, retorna ao loop
	li s11,MMIO_add
	lw s11, (s11)			# Tecla capturada em S11
	jal LOLO_WALK
	j POLL_LOOP
	exit()
#################################
#	 PRINT BACKGROUND	#
#################################
IMPRIME:
	lw t4,0(s0)		# numero de colunas
	lw t5,4(s0)		# numero de linhas
	addi s0,s0,8		# primeiro pixels depois das informa��es de nlin ncol
	mul t1,t4,t5            # numero total de pixels da imagem
	li t2,0
I_LOOP1:
 	beq t1,t2,I_FIM		# Se for o �ltimo endere�o ent�o sai do loop
	lw t3,0(s0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na mem�ria VGA
	addi t0,t0,4		# soma 4 ao endere�o
	addi s0,s0,4
	addi t2,t2,1		# incrementa contador de bits
	j I_LOOP1		# volta a verificar
I_FIM:	
	ret
#################################
#      LOOP PRINT N SPRITES	#
#################################
PSI_LOOP: 	
	bge a1,a2,PSI_FIM		# Se for o �ltimo endere�o ent�o sai do loop	
	bne t1,a3, PSI_CONTINUA
	sub a1,a1,a3
	addi a1,a1,320		
	li t1,0			# pinta 16 pixels depois desce pra pr�xima linha
PSI_CONTINUA:
	lb t3, 0(s1)		# carrega o byte
	beq t3, t2, PSI_PULA	# testa se o byte � da cor t6
	sb t3, 0(a1)		# pinta o byte
PSI_PULA:	addi t1,t1,1
	addi a1,a1,1 
	addi s1,s1,1
	j PSI_LOOP			# volta a verificar
PSI_FIM:
	addi t4,t4,1
	beq t4,a6,PSI_FORA
	addi a1,a4,16		# endere�o inicial do pr�x bloco = endere�o inicial do bloco atual + 16
	addi a2,a5,16		# endere�o final do pr�x bloco = endere�o final do bloco atual + 16
	addi a4,a4,16		# atualiza endere�o inicial atual
	addi a5,a5,16		# atualiza endere�o final atual
	li t1,0
	mv s1,a7
	addi s1,s1,8
	j PSI_LOOP
PSI_FORA:
	ret
#################################
#      LOOP SET UNWALKABLE	#
#################################
PSI_LOOP_0:	
	bge t4,t5,PSI_FORA_0	
	sb t3,(t2)		# Bloco T1 recebe o valor 1 (unwalkable)
	addi t4,t4,1
	addi t2,t2,1
	j PSI_LOOP_0
PSI_FORA_0:	
	ret
.include "walk.asm"