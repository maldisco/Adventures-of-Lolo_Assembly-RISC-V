###########################################################################
### 1. [X] Imprimir os elementos est�ticos				###
### 2. [X] Movimentar o lolo com WASD					###
### 2.1 [X] tentar implementar movimenta��o em blocos <- OLHA AQUI 	###
### 3. [X] Travar a movimenta��o dentro do mapa				###
### 4. [] Colis�es com objetos est�ticos				###
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
#	ost()
	PRINT_DYN_IMG(lolo_coca,LOLO_POSX,LOLO_POSY,CURRENT_FRAME)
	li s0, MMIO_set
POLL_LOOP:				# LOOP de leitura e captura de tecla
	li s0, MMIO_set
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

.include "walk.asm"
