.data
# Constants
.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv MAP_START_ADDRESS  0x2D4A
.eqv MAP_END_ADDRESS	0x108BA
.eqv MAP_LEFT_EDGE	74
.eqv MAP_UPPER_EDGE	36
.eqv MAP_RIGHT_EDGE	249
.eqv MAP_LOWER_EDGE	211
.eqv DOOR_POSX		186
.eqv DOOR_POSY		20
.eqv WALKABLE_BLOCKS_PATH   0x10010114

.eqv UP			0x77
.eqv DOWN		0x73
.eqv LEFT		0x61
.eqv RIGHT		0x64
.eqv SELECT		0x65
.eqv FRAME_SELECT	0xff200604

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004

# SOUNDTRACK
GOLDEN_WIND_NUM: .word 71
GOLDEN_WIND_NOTES: 59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,1622,60,202,59,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,1418,59,405,60,202,60,202,59,202,60,405,67,405,67,405,69,202,67,811,60,202,62,202,64,405,65,202,64,405,65,405,64,608,62,405,60,405,62,2838,64,202,62,202,60,202,59,202,60,405,60,202,60,405,60,607,59,405,60,405,64,405,67,1622,60,202,60,4257,59,608,60,202,60,3244

# PTR
CURRENT_FRAME:		.word 0
LOLO_POSX:		.word 74
LOLO_POSY:		.word 36
WALKABLE_BLOCKS:	.space 121

# Include
.include "./sprites/lolo/lolo_coca.data"
.include "./sprites/blocos/tijolo.data"
.include "./sprites/blocos/rock.data"
.include "./sprites/blocos/arvore.data"
.include "./sprites/blocos/arbusto.data"
.include "./sprites/porta/porta.data"
.include "./sprites/bg/map.data"
.include "./sprites/bg/start_menu_1.data"
.include "./sprites/bg/start_menu_2.data"
.include "./sprites/bg/ending.data"

########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%sprite, %x, %y)
	# escolhe a frame aonde a sprite será desenhada
	jal FRAME_TEST
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
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
	jal PSI_LOOP_2
.end_macro
########################################################
#            IMPRIME N SPRITES 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_STC_IMG(%n, %sprite, %x, %y)
	li a0, %n
	la a1, %sprite
	li a2, %x
	li a3, %y
	jal PRINT_STC_IMG
.end_macro
########################################################
#            IMPRIME UM SPRITE 16X16 NAS	       #	 	
#	    NAS COORDENADAS (X,Y) PASSADAS	       #
########################################################
.macro PRINT_DYN_IMG(%sprite, %buffer_x, %buffer_y)
	# escolhe a frame aonde a sprite será desenhada
	jal FRAME_TEST
	la s1, %sprite
	li a3,16		# todos os sprites são quadrados 16x16
	LOADW( t1,%buffer_y )
	LOADW( t2,%buffer_x )	
	li t3, 320
	mul t3,t1,t3		# aux = linhax320 (linha)
	add a1,a1,t3
	add a1,a1,t2		# endereço inicial = linha x 320 + coluna
	mv a2,a1		
	li t1,4816		# 15x320 +16	
	add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 
	
	addi s1,s1,8		# chega ao .text
	# ==========================================================
	# a1 = endereço inicial 
	# a2 = endereço final
	# a3 = numero de pixels a serem pintados por linha
	# t1 = contador de pixels pintados
	# t2 = cor a ser substituida pelo transparente
	# ==========================================================
	li t1,0			# contador
	li t2, 0xffffff80
	jal PDI_LOOP
.end_macro
########################################################
#               DESENHA O BACKGROUND		       #	
########################################################
.macro DRAW_BG()	
	# carrega da memoria o frame passado
	jal FRAME_TEST
	mv t0,a1
	la s0,map
	jal IMPRIME
	PRINT_STC_IMG( 11,tijolo,74,36 )
	PRINT_STC_IMG( 11,tijolo,74,52 )
	PRINT_STC_IMG( 11,tijolo,74,68 )
	PRINT_STC_IMG( 11,tijolo,74,84 )
	PRINT_STC_IMG( 11,tijolo,74,100 )
	PRINT_STC_IMG( 11,tijolo,74,116 ) 
	PRINT_STC_IMG( 11,tijolo,74,132 )
	PRINT_STC_IMG( 11,tijolo,74,148 )
	PRINT_STC_IMG( 11,tijolo,74,164 )
	PRINT_STC_IMG( 11,tijolo,74,180 )
	PRINT_STC_IMG( 11,tijolo,74,196 )
.end_macro
########################################################
#   		    FRAME SETUP			       #
########################################################
.macro setup()
	li t3, 0xff200604
	li t0, 0
	sw t0,(t3)
	DRAW_BG()
	li t1,1
	SAVEW( t1,CURRENT_FRAME )
	DRAW_BG()
	li t1,0
	SAVEW( t1,CURRENT_FRAME )
	#reset walkable blocks
	reset_walkable_blocks()
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
#   		    IMPRIME LEVEL 1		       #
########################################################
.macro first_level()
	PRINT_STC_IMG( porta,186,20 )
	PRINT_STC_IMG( 4,rock,122,36 )
	PRINT_STC_IMG( 2,arbusto,218,36 )
	PRINT_STC_IMG( 3,rock,138,52 )
	PRINT_STC_IMG( 1,rock,234,52 )
	PRINT_STC_IMG( 3,rock,138,68 )
	PRINT_STC_IMG( 1,rock,170,84 )
	PRINT_STC_IMG( 8,rock,74,148 )
	PRINT_STC_IMG( 8,rock,74,164 )
	PRINT_STC_IMG( 8,rock,74,180 )
	PRINT_STC_IMG( 8,rock,74,196 )
	PRINT_STC_IMG( 1,arvore,234,196 )
	la t1,CURRENT_FRAME
	lw t2, (t1)
	xori t2,t2,0x001
	sw t2, (t1)
	PRINT_STC_IMG( porta,186,20 )
	PRINT_STC_IMG( 4,rock,122,36 )
	PRINT_STC_IMG( 2,arbusto,218,36 )
	PRINT_STC_IMG( 3,rock,138,52 )
	PRINT_STC_IMG( 1,rock,234,52 )
	PRINT_STC_IMG( 3,rock,138,68 )
	PRINT_STC_IMG( 1,rock,170,84 )
	PRINT_STC_IMG( 8,rock,74,148 )
	PRINT_STC_IMG( 8,rock,74,164 )
	PRINT_STC_IMG( 8,rock,74,180 )
	PRINT_STC_IMG( 8,rock,74,196 )
	PRINT_STC_IMG( 1,arvore,234,196 )
	la t1,CURRENT_FRAME
	lw t2, (t1)
	xori t2,t2,0x001
	sw t2, (t1)
	
.end_macro
########################################################
#   		    SOUNDTRACK			       #
########################################################
.macro ost()
	jal SOUNDTRACK
.end_macro
########################################################
#   		      ENDING			       #
########################################################
.macro ending()
	sleep( 2000 )
	LOADW( t3,CURRENT_FRAME )
	jal BLACK_SCREEN
	li t0, 0xff0
	LOADW( t3,CURRENT_FRAME )
	add t0, t0, t3
	slli t0,t0,20
	la s0, ending
	jal IMPRIME
	ost()
	start_menu()
.end_macro
########################################################
#             CARREGA O VALOR ARMAZENADO	       #
#		    EM UM ENDEREÇO	       	       #
########################################################
.macro LOADW(%reg, %label)
	li %reg,0
	la %reg,%label
	lw %reg,(%reg)
.end_macro
########################################################
#             CALCULA O BLOCO UTILIZANDO 	       #
#		AS COORDENADAS (X,Y)	       	       #
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
.end_macro
########################################################
#               SALVA O VALOR PASSADO		       #
#		    EM UM ENDEREÇO	       	       #
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
#             SLEEP FOR N MILLISECONDS		       #	
########################################################
.macro sleep(%n)
	li a0,%n
	li a7,32
	ecall
.end_macro
