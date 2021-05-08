.data
#LOLO_POSX:		.word 72
#LOLO_POSY:		.word 36
#CURRENT_FRAME:		.word 0
#.eqv UP			0x77
#.eqv DOWN		0x73
#.eqv LEFT		0x61
#.eqv RIGHT		0x64
#.eqv FRAME_SELECT	0xff200604

#.include "./common.asm"
.include "./sprites/lolo_up/lolo_up_1.data"
.include "./sprites/lolo_down/lolo_down_1.data"
.include "./sprites/lolo_right/lolo_right_1.data"
.include "./sprites/lolo_left/lolo_left_1.data"

.text
LOLO_WALK:
	li t1, UP 				# t1 = 'W'
	li t2, DOWN				# t2 = 'S'
	li t3, RIGHT				# t1 = 'D'
	li t4, LEFT				# t2 = 'A'
	
	
	beq s11,t1,LOLO_WALK_UP			# If tecla apertada = t1 = 'W'
	beq s11,t2,LOLO_WALK_DOWN
	beq s11,t3,LOLO_WALK_RIGHT
	beq s11,t4,LOLO_WALK_LEFT
	j POLL_LOOP
	
LOLO_WALK_UP:
	PRINT_DYN_IMG( tijolo,LOLO_POSX,LOLO_POSY,CURRENT_FRAME )
						# Apaga o lolo do frame atual
	LOADW( t1,CURRENT_FRAME )
	xori t1,t1,0x001
	SAVEW( t1,CURRENT_FRAME )			# Salva na memória o próximo frame
	LOADW(a1,LOLO_POSY)
	addi a1,a1,-16
	# IS DOOR TEST START
	li t1, DOOR_POSX
	li t2, DOOR_POSY
	bne t2,a1,LWU_CONTINUE
	LOADW( t3,LOLO_POSX )
	bne t3,t1,LWU_CONTINUE
	SAVEW( a1,LOLO_POSY )
	PRINT_DYN_IMG( lolo_coca, LOLO_POSX, LOLO_POSY, CURRENT_FRAME )
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				# Troca o frame mostrado no bitmap
	ending()
	# IS DOOR TEST END
LWU_CONTINUE:
	# IS IN MAP TEST START
	li t2, MAP_UPPER_EDGE
	blt a1,t2,LWU_INVALID
	# IS IN MAP TEST END
	# WALKABLE BLOCK TEST START
	LOADW( t3,LOLO_POSX )
	CALCULATE_BLOCK(t3,a1)
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWU_INVALID
	# WALKABLE BLOCK TEST END
	SAVEW( a1,LOLO_POSY )			# Salva a próxima posição Y de LOLO
LWU_INVALID:
	PRINT_DYN_IMG( lolo_up_1, LOLO_POSX, LOLO_POSY, CURRENT_FRAME )
						# Imprime o lolo no próximo frame, na posição atualizada
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				# Troca o frame mostrado no bitmap
	j POLL_LOOP
LOLO_WALK_DOWN:
	PRINT_DYN_IMG( tijolo,LOLO_POSX,LOLO_POSY,CURRENT_FRAME )
						# Apaga o lolo do frame atual
	LOADW( t1,CURRENT_FRAME )
	xori t1,t1,0x001
	SAVEW( t1,CURRENT_FRAME )			# Salva na memória o próximo frame
	LOADW(a1,LOLO_POSY)
	addi a1,a1,16
	# IS IN MAP TEST START
	li t2, MAP_LOWER_EDGE
	bgt a1,t2,LWD_INVALID
	# IS IN MAP TEST END
	# WALKABLE BLOCK TEST START
	LOADW( t3,LOLO_POSX )
	CALCULATE_BLOCK( t3,a1 )
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWD_INVALID
	# WALKABLE BLOCK TEST END
	SAVEW( a1,LOLO_POSY )			# Salva a próxima posição Y de LOLO
LWD_INVALID:
	PRINT_DYN_IMG( lolo_down_1, LOLO_POSX, LOLO_POSY, CURRENT_FRAME )
						# Imprime o lolo no próximo frame, na posição atualizada
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				# Troca o frame mostrado no bitmap
	j POLL_LOOP
LOLO_WALK_RIGHT:
	PRINT_DYN_IMG( tijolo,LOLO_POSX,LOLO_POSY,CURRENT_FRAME )
						# Apaga o lolo do frame atual, printando um tijolo em seu lugar	
	LOADW( t1,CURRENT_FRAME )
	xori t1,t1,0x001
	SAVEW( t1,CURRENT_FRAME )			# Salva na memória o próximo frame		
	LOADW( a1,LOLO_POSX )
	addi a1,a1,16
	# IS IN MAP TEST START
	li t2, MAP_RIGHT_EDGE
	bgt a1,t2,LWR_INVALID
	# IS IN MAP TEST END
	# WALKABLE BLOCK TEST START
	LOADW( t3,LOLO_POSY )
	CALCULATE_BLOCK( a1,t3 )
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWR_INVALID
	# WALKABLE BLOCK TEST END
	SAVEW( a1,LOLO_POSX )			# Salva a próxima posição Y de LOLO	
LWR_INVALID:
	PRINT_DYN_IMG( lolo_right_1, LOLO_POSX, LOLO_POSY, CURRENT_FRAME )
						# Imprime o lolo no próximo frame, na posição atualizada
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				# Troca o frame mostrado no bitmap
	j POLL_LOOP
LOLO_WALK_LEFT:
	PRINT_DYN_IMG( tijolo,LOLO_POSX,LOLO_POSY,CURRENT_FRAME )
						# Apaga o lolo do frame atual
	LOADW( t1,CURRENT_FRAME )
	xori t1,t1,0x001
	SAVEW( t1,CURRENT_FRAME )			# Salva na memória o próximo frame
	LOADW( a1,LOLO_POSX )
	addi a1,a1,-16
	# IS IN MAP TEST START
	li t2, MAP_LEFT_EDGE
	blt a1,t2, LWL_INVALID
	# IS IN MAP TEST END
	# WALKABLE BLOCK TEST START
	LOADW( t3,LOLO_POSY )
	CALCULATE_BLOCK(a1,t3)
	la t2, WALKABLE_BLOCKS
	add t2,t2,t1
	lb t1,(t2)
	bgt t1,zero, LWL_INVALID
	# WALKABLE BLOCK TEST END
	SAVEW( a1,LOLO_POSX )			# Salva a próxima posição Y de LOLO
LWL_INVALID:
	PRINT_DYN_IMG( lolo_left_1, LOLO_POSX, LOLO_POSY, CURRENT_FRAME )
						# Imprime o lolo no próximo frame, na posição atualizada
	li t3, FRAME_SELECT
	LOADW( t1,CURRENT_FRAME )			
	sw t1,(t3)				# Troca o frame mostrado no bitmap
	j POLL_LOOP
