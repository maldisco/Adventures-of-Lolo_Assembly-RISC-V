.data
# Constants
.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

.eqv MAP_START_ADDRESS  0x2D4A
.eqv MAP_END_ADDRESS	0x108BA
.eqv MAP_LEFT_EDGE	74
.eqv MAP_UPPER_EDGE	36
.eqv MAP_RIGHT_EDGE	249
.eqv MAP_LOWER_EDGE	211

.eqv DOOR_POSX		186
.eqv DOOR_POSY		20

.eqv UP			0x77	# 'W'
.eqv DOWN		0x73	# 'S'
.eqv LEFT		0x61	# 'A'
.eqv RIGHT		0x64	# 'D'
.eqv SELECT		0x65	# 'E'

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004


.eqv NUMBER_OF_LEVELS	2
# SOUNDTRACK
GOLDEN_WIND_NUM: .word 71
GOLDEN_WIND_NOTES: 59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,1622,60,202,59,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,2838,64,202,62,202,60,202,59,202,60,405,60,202,60,405,60,607,59,405,60,405,64,405,67,1622,60,202,60,4257,59,608,60,202,60,3244

# PTR
CURRENT_FRAME:		.word 0
LOLO_POSX:		.word 74
LOLO_POSY:		.word 36
WALKABLE_BLOCKS:	.space 121		# vetor de 121 elementos, 0 = walkable, 1 = unwalkable
DOOR_STATE:		.word 1 		# 0 -> open, 1 -> closed
KEY_COUNTER:		.word 0	
LIFE_COUNTER:		.word 3
KEY_BLOCKS:		.space 121		# vetor de 121 elementos, 0 = regular, 1 = special
MORTAL_BLOCKS:		.space 121
BRIDGE_BLOCKS:		.space 121
CURRENT_LEVEL:		.word 1

# Include
.include "./sprites/lolo/lolo_coca.data"
.include "./sprites/lolo/lolo_pisca.data"
.include "./sprites/lolo_up/lolo_up_1.data"
.include "./sprites/lolo_down/lolo_down_1.data"
.include "./sprites/lolo_right/lolo_right_1.data"
.include "./sprites/lolo_left/lolo_left_1.data"
.include "./sprites/blocos/tijolo.data"
.include "./sprites/blocos/bridge.data"
.include "./sprites/porta/porta.data"
.include "./sprites/porta/porta_fechada.data"
.include "./sprites/bg/start_menu_1.data"
.include "./sprites/bg/start_menu_2.data"
.include "./sprites/bg/fase_1.data"
.include "./sprites/bg/fase_2.data"
.include "./sprites/bg/fase_3.data"
.include "./sprites/bg/stage_one.data"
.include "./sprites/bg/stage_two.data"
.include "./sprites/bg/stage_three.data"
.include "./sprites/bg/ending.data"
.include "./sprites/bg/death.data"

########################################################
#             PRINTS A 16X16 SPRITE ON THE	       #	 	
#	        (X,Y) COORDINATES PASSED	       #
########################################################
.macro PRINT_STC_IMG(%sprite, %x, %y)
	# escolhe a frame aonde a sprite será desenhada
	frame_address(a1)
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16	
	li t1, %y		# linha 
	li t2, %x		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 	
	addi s1,s1,8		# chega ao .text
	li t1,0			# contador
	li t2, 0xffffff80
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	jal PS_LOOP
.end_macro
########################################################
#       PRINTS THE DOOR IN HER USUAL COORDINATES       #
########################################################
.macro PRINT_DOOR()
	frame_address(a1)
	LOADW(t0, DOOR_STATE)
	jal DOOR_TEST
	li a3,16		# todos os sprites são quadrados 16x16
	li t1, DOOR_POSY		# linha 
	li t2, DOOR_POSX		# coluna
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 	
	addi s1,s1,8		# chega ao .text
	li t1,0			# contador
	li t2, 0xffffff80
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	jal PS_LOOP
.end_macro
########################################################
#           PRINTS 'N' 16x16 SPRITES ON THE	       #	 	
#	    	(X,Y) COORDINATES PASSED	       #
########################################################
.macro mark_as_block(%n, %x, %y)
	li a0, %n
	li a2, %x
	li a3, %y
	jal MARK_AS_BLOCK
.end_macro
########################################################
#            PRINTS A 16X16 SPRITE ON THE	       #	 	
#	 (X,Y)COORDINATES STORED IN AN ADDRESS	       #
########################################################
.macro PRINT_DYN_IMG(%sprite, %current_x, %current_y)
	# escolhe a frame aonde a sprite será desenhada
	frame_address(a1)
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16
	LOADW( t1,%current_y )
	LOADW( t2,%current_x )	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 	
	addi s1,s1,8		# chega ao .text
	li t1,0			# contador
	li t2, 0xffffff80
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	jal PS_LOOP
.end_macro
########################################################
#             PRINTS A 16X16 SPRITE ON THE	       #	 	
#	        (X,Y) COORDINATES PASSED	       #
#		AND SET IT AS A KEY BLOCK	       #
########################################################
.macro mark_as_key(%x, %y)
	li t3, %y
	li t2, %x
	CALCULATE_BLOCK(t2,t3)
	# t1 = block
	la t0, KEY_BLOCKS
	add t0,t0,t1
	li t1,1
	sb t1,(t0)
.end_macro
########################################################
#             PRINTS A 16X16 SPRITE ON THE	       #	 	
#	        (X,Y) COORDINATES PASSED	       #
#	       AND SET IT AS A MORTAL BLOCK	       #
########################################################
.macro mark_as_mortal(%x, %y)
	li t3, %y
	li t2, %x
	CALCULATE_BLOCK(t2,t3)
	# t1 = block
	la t0, MORTAL_BLOCKS
	add t0,t0,t1
	li t1,1
	sb t1,(t0)
.end_macro
########################################################
#             PRINTS A 16X16 SPRITE ON THE	       #	 	
#	        (X,Y) COORDINATES PASSED	       #
#	       AND SET IT AS A MORTAL BLOCK	       #
########################################################
.macro mark_as_bridge(%x, %y)
	li t3, %y
	li t2, %x
	CALCULATE_BLOCK(t2,t3)
	# t1 = block
	la t0, BRIDGE_BLOCKS
	add t0,t0,t1
	li t1,1
	sb t1,(t0)
.end_macro
########################################################
#          ERASE A BLOCK IN LOLO'S COORDINATES	       #
########################################################
.macro ERASE_BLOCK()
	SWITCH_FRAME()
	PRINT_DYN_IMG(tijolo,LOLO_POSX,LOLO_POSY)
	SWITCH_FRAME()
.end_macro
########################################################
#   		    BLOCK RESET 		       #
########################################################
.macro reset_walkable_blocks()
	jal RESET_WALKABLE_BLOCKS
.end_macro
########################################################
#   		    START MENU			       #
########################################################
.macro start_menu()
	j START_MENU
.end_macro
########################################################
#   		    RENDER STAGE 1		       #
########################################################
.macro stage_one()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_one
	jal IMPRIME
	li t1,0
	SAVEW(t1, DOOR_STATE)
	PRINT_DOOR()
	SWITCH_FRAME()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_one
	jal IMPRIME
	PRINT_DOOR()
	mark_as_block(4,122,36 )
	mark_as_block(2,218,36 )
	mark_as_block(3,138,52 )
	mark_as_block(1,234,52 )
	mark_as_block(3,138,68 )
	mark_as_block(1,170,84 )
	mark_as_block(8,74,148 )
	mark_as_block(8,74,164 )
	mark_as_block(8,74,180 )
	mark_as_block(8,74,196 )
	mark_as_block(1,234,196 )	
.end_macro
########################################################
#   		    PRINT STAGE 2		       #
########################################################
.macro stage_two()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	PRINT_DOOR()
	SWITCH_FRAME()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_two
	jal IMPRIME
	PRINT_DOOR()
	li t3, 3
	SAVEW(t3, KEY_COUNTER)
	mark_as_block(4,122,36)
	mark_as_block(2,218,36)
	mark_as_block(3,138,52)
	mark_as_block(1,234,52)
	mark_as_block(3,138,68)
	mark_as_key(234,68)
	mark_as_block(1,170,84)
	mark_as_block(1,170,84)
	mark_as_key(74,132)
	mark_as_block(1,74,148)
	mark_as_block(2,74,164)
	mark_as_block(3,74,180)
	mark_as_block(4,74,196)
	mark_as_key(218,196)
	mark_as_block(1,234,196)
.end_macro
########################################################
#   		    PRINT STAGE 3		       #
########################################################
.macro stage_three()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	PRINT_DOOR()
	SWITCH_FRAME()
	frame_address(a1)
	mv t0,a1	
	la s0,stage_three
	jal IMPRIME
	PRINT_DOOR()
	li t3, 2
	SAVEW(t3, KEY_COUNTER)
	mark_as_block(1,90,52)
	mark_as_block(1,106,52)
	mark_as_block(1,90,68)
	mark_as_block(1,218,52)
	mark_as_block(1,202,52)
	mark_as_block(1,218,68)
	mark_as_mortal(122, 84)
	mark_as_mortal(138, 84)
	mark_as_mortal(154, 84)
	mark_as_mortal(170, 84)
	mark_as_mortal(186, 84)
	mark_as_mortal(186, 100)
	mark_as_mortal(186, 116)
	mark_as_mortal(186, 132)
	mark_as_mortal(186, 148)
	mark_as_mortal(122, 148)
	mark_as_mortal(138, 148)
	mark_as_bridge(154, 148)	
	mark_as_mortal(170, 148)
	mark_as_mortal(122, 100)
	mark_as_mortal(122, 116)
	mark_as_mortal(122, 132)
	mark_as_key(154, 116)
	mark_as_block(1,90,180)
	mark_as_block(1,106,180)
	mark_as_block(1,90,164)
	mark_as_block(1,218,180)
	mark_as_block(1,202,180)
	mark_as_key(234, 196)
	mark_as_block(1,218,164)
	
.end_macro
########################################################
#   		    SOUNDTRACK			       #
########################################################
.macro ost()
	jal SOUNDTRACK
.end_macro
########################################################
#   		       GAME			       #
########################################################
.macro game()
	j GAME
.end_macro
########################################################
#   		      ENDING			       #
########################################################
.macro ending()
	sleep(2000)
	LOADW(t3,CURRENT_FRAME)
	jal BLACK_SCREEN
	frame_address(t1)
	mv t0,t1
	la s0, ending
	jal IMPRIME
	ost()
	start_menu()
.end_macro
########################################################
#   		      RIP			       #
########################################################
.macro you_died()
	sleep(2000)
	LOADW(t3,CURRENT_FRAME)
	jal BLACK_SCREEN
	frame_address(t1)
	mv t0,t1
	la s0, death
	jal IMPRIME
	ost()
	start_menu()
.end_macro
########################################################
#   		 FINISHED LEVEL			       #
########################################################
.macro  finished_level()
	sleep(2000)
	LOADW(t1, CURRENT_LEVEL)
	addi t1,t1,1
	SAVEW(t1, CURRENT_LEVEL)
	reset()
	game()
.end_macro
########################################################
#        PRINT A BLACK SCREEN THEN LEVEL TITLE	       #
########################################################
.macro level_title(%level)
	LOADW(t3,CURRENT_FRAME)
	jal BLACK_SCREEN
	sleep(500)
	frame_address(t1)
	mv t0,t1
	la s0, %level
	jal IMPRIME
	sleep(3500)
.end_macro
########################################################
#             LOAD THE CONTENT OF AN ADDRESS	       #
#		    INTO A REGISTER	       	       #
########################################################
.macro LOADW(%reg, %label)
	li %reg,0
	la %reg,%label
	lw %reg,(%reg)
.end_macro
########################################################
#             RETURN FRAME ADDRESS		       #
########################################################
.macro frame_address(%reg)
	LOADW(%reg,CURRENT_FRAME)
	li t0,0xff0
	add %reg,t0,%reg
	slli %reg,%reg,20
.end_macro
########################################################
#             CALCULATE THE BLOCK USING		       #
#		 THE COORDINATES (X,Y)	       	       #
########################################################
.macro CALCULATE_BLOCK(%regx,%regy)
	mv t1,%regx
	mv t3,%regy
	addi t1,t1,-74
	li t2,16
	div t1,t1,t2		# X grid = T1
	addi t3,t3,-36
	li t2,16
	div t3,t3,t2		# Y grid = T3
	li t2,11
	mul t3,t3,t2		
	add t1,t1,t3		# Bloco (x,y) = T1
	# Returns T1 as XY block
.end_macro
########################################################
#          STORES THE CONTENT OF A REGISTER	       #
#	      IN THE ADDRESS OF A LABEL	       	       #
########################################################
.macro SAVEW(%reg, %label)
	la t0,%label
	sw %reg,(t0)
.end_macro
########################################################
#                  EXIT THE PROGRAM		       #	
########################################################
.macro exit()
	li a7,10
	ecall
.end_macro
########################################################
#         THINGS TO RESET AFTER EVERY LEVEL	       #	
########################################################
.macro reset()
	reset_walkable_blocks()
	li t1,1
	SAVEW(t1,DOOR_STATE)
	li t1,74
	SAVEW(t1,LOLO_POSX)
	li t1,36
	SAVEW(t1,LOLO_POSY)
.end_macro
########################################################
#             SWITCH CURRENT FRAME		       #	
########################################################
.macro SWITCH_FRAME()
	LOADW(t1,CURRENT_FRAME)
	xori t1,t1,0x001
	SAVEW(t1,CURRENT_FRAME)
.end_macro
########################################################
#             DOOR REFRESH (OPEN, CLOSE)	       #	
########################################################
.macro door_refresh()
	LOADW(t1, KEY_COUNTER)
	jal KEY_TEST
	PRINT_DOOR()
	SWITCH_FRAME()
	PRINT_DOOR()
	SWITCH_FRAME()
.end_macro
########################################################
#             SLEEP FOR N MILLISECONDS		       #	
########################################################
.macro sleep(%n)
	li a0,%n
	li a7,32
	ecall
.end_macro
