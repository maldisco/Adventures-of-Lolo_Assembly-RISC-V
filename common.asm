# ===========================
#          MACROS
# ===========================
# IMPRIME UMA IMAGEM NAS COORDENADAS PASSADAS
.data

.macro imprime_imagem(%coluna, %linha)
.data

.text
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF000000	# endereco final (futuro)

	li t3, %linha		# linha 80
	li t4, %coluna		# coluna 80
	li t5, 320
	mul t6,t3,t5		# aux = 80x320 (linha), endereço da linha 80
	add t1,t1,t6
	add t1,t1,t4		# endereço inicial = endereço inicial + linha x 320 + coluna
	
	lb t6, 0(s1)		# carrega em t6 o tamanho do lado do quadrado a ser pintado
	add t3,t3,t6		# linha + lado do quaddrado
	add t4,t4,t6		# coluna + lado do quadrado
	mul t6,t3,t5		# aux = (posição inicial + lado do quadrado)x320
	add t2,t2,t6		# 
	add t2,t2,t4		# endereço final = endereço inicial + linha x 320 + coluna
	
	
	li t4,0			# contador
	lb t5,0(s1)		# dimensao do quadrado
	
	addi s1,s1,8		# chega ao .text do lolo.data
	
LOOP: 	beq t1,t2,FORA		# Se for o último endereço então sai do loop
	

	bne t4,t5, CONTINUA
	sub t1,t1,t5
	addi t1,t1,320		
	li t4,0			# pinta 16 pixels depois desce pra próxima linha
CONTINUA:

	lw t3, 0(s1)		# carrega a primeira word do .text do arquivo lolo
	sw t3, 0(t1)		# escreve a word na memória VGA
		
	addi t4,t4,4
	addi t1,t1,4 
	addi s1,s1,4
	j LOOP			# volta a verificar


FORA:
.end_macro
.macro exit()
	li a7,10
	ecall
.end_macro
# ===========================
#     	 PROCEDIMENTOS
# ===========================
.data

.text
# Carrega a imagem
IMPRIME:
	li t0,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	lw s1,0(s0)		# numero de colunas
	lw s2,4(s0)		# numero de linhas
	addi s0,s0,8		# primeiro pixels depois das informações de nlin ncol
	mul t1,s1,s2            # numero total de pixels da imagem
	li t2,0
I_LOOP1:
 	beq t1,t2,I_FIM		# Se for o último endereço então sai do loop
	lw t3,0(s0)		# le um conjunto de 4 pixels : word
	sw t3,0(t0)		# escreve a word na memória VGA
	addi t0,t0,4		# soma 4 ao endereço
	addi s0,s0,4
	addi t2,t2,1		# incrementa contador de bits
	j I_LOOP1		# volta a verificar


# devolve o controle ao sistema operacional
I_FIM:	
	ret