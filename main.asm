###########################################################################
### 1. [X] Imprimir os elementos estáticos				###
### 2. [X] Movimentar o lolo com WASD					###
### 2.1 [X] tentar implementar movimentação em blocos <- OLHA AQUI 	###
### 3. [] Travar a movimentação dentro do mapa				###
### 4. [] Colisões com objetos estáticos				###
### 5. [] Imprimir os elementos dinâmicos				###
### 6. [] Colisões com objetos dinâmicos				###
### 7. [] Inimigos							###
### 8. [] Colisões com ataques inimigos					###
### 9. [] Morte								###
###########################################################################
.eqv MAP_INITIAL_POSX		72
.eqv MAP_INITIAL_POSY		36
.eqv MAP_FINAL_POSX		248
.eqv MAP_FINAL_POSY		212
.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004
.eqv FRAME_0			0xff000000
.eqv FRAME_1			0xff100000

.data
.include "./sprites/lolo/lolo_coca.data"
#.include "./sprites/bg/map.data"
.include "./macros.asm"
.text
main:	
	li t3, 0xff200604
	sw t0,(t3)
	REDRAW_BG(CURRENT_FRAME)
	LOADW(t1,CURRENT_FRAME)
	xori t1,t1,0x001
	SAVEW(t1,CURRENT_FRAME)
	REDRAW_BG(CURRENT_FRAME)
	LOADW(t1,CURRENT_FRAME)
	xori t1,t1,0x001
	SAVEW(t1,CURRENT_FRAME)
	PRINT_DYN_IMG(lolo_coca,LOLO_POSX,LOLO_POSY,CURRENT_FRAME)
	li s0, MMIO_set
POLL_LOOP:				# LOOP de leitura e captura de tecla
	li s0, MMIO_set
	lb t1,(s0)
	beqz t1,POLL_LOOP		# Enquanto não houver nenhuma tecla apertada, retorna ao loop
	li s11,MMIO_add
	lw s11, (s11)			# Tecla capturada em S11
	jal LOLO_WALK
	j POLL_LOOP
	exit()
	
.include "./procedimentos.asm"
.include "walk.asm"
