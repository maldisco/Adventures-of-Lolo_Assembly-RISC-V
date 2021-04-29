# ===========================
#          MACRO
# ===========================
# IMPRIME UMA IMAGEM NAS COORDENADAS PASSADAS
.data

.macro imprime_imagem(%coluna, %linha)
.data

.text
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF000000	# endereco final (futuro)

	li t3, %linha		# linha 
	li t4, %coluna		# coluna
	li t5, 320
	mul t6,t3,t5		# aux = linhax320 (linha)
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
	li t6, 0xffffff80	
	
	addi s1,s1,8		# chega ao .text
	
	# ==========================================================
	# t1 = endereço inicial 
	# t2 = endereço final
	# t4 = contador de pixels pintados
	# t5 = numero de pixels a serem pintados por linha
	# t6 = cor a ser substituida pelo transparente
	# ==========================================================
	
LOOP: 	beq t1,t2,FORA		# Se for o último endereço então sai do loop
	

	bne t4,t5, CONTINUA
	sub t1,t1,t5
	addi t1,t1,320		
	li t4,0			# pinta 16 pixels depois desce pra próxima linha
CONTINUA:

	lb t3, 0(s1)		# carrega o byte
	beq t3, t6, PULA	# testa se o byte é da cor t6
	sb t3, 0(t1)		# pinta o byte
PULA:		
	addi t4,t4,1
	addi t1,t1,1 
	addi s1,s1,1
	j LOOP			# volta a verificar


FORA:
.end_macro
.macro exit()
	li a7,10
	ecall
.end_macro

