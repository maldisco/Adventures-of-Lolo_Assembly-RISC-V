.data
# Constants
.eqv FRAME_0		0xff000000
.eqv FRAME_1		0xff100000
.eqv FRAME_SELECT	0xff200604

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

.eqv PW_STAGE_ONE	0x61	# 'A'
.eqv PW_STAGE_TWO	0x62	# 'B'
.eqv PW_STAGE_THREE	0x63	# 'C'
.eqv PW_STAGE_FOUR	0x64	# 'D'
.eqv PW_FINAL_STAGE	0x68	# 'H'
.eqv PW_ENDING		0x70	# 'P'

.eqv MMIO_set			0xff200000
.eqv MMIO_add			0xff200004
# SOUNDTRACK
LAST_GOODBYE: 55,666,67,333,64,333,62,333,60,333,59,166,60,333,62,832,71,499,73,83,69,83,67,1332,57,666,67,333,64,333,62,333,60,333,62,166,64,333,59,832,62,666,62,333,60,333,59,333,60,333,55,666,67,666,62,1332,60,666,67,333,69,166,67,333,64,333,62,333,64,83,62,83,60,333,60,333,60,166,62,166,64,333,60,333,62,333,62,166,64,166,62,166,64,83,62,83,60,333,63,333,62,333,58,333,62,333,60,666,62,832,55,166,60,166,62,332,55,166,60,166,62,332,56,166,60,166,62,332,56,166,60,166,62,166,69,333,64,333,62,166,60,333,62,333,64,83,62,83,60,333,55,333,57,333,60,333,60,166,62,166,64,333,60,333,62,333,62,166,64,166,62,166,64,83,62,83,60,333,63,333,62,333,58,333,62,333,60,666,62,666
LAST_GOODBYE_NUM:	.word 95
A_VAGUE_HOPE: 72,687,74,687,71,687,72,687,69,2748,76,687,77,687,72,687,74,687,76,2748,74,687,76,687,71,687,74,687,72,1374,71,1374,69,458,71,458,72,458,74,687,72,687,71,2748,72,687,74,687,71,687,72,687,69,2748,76,687,77,687,72,687,74,687,76,2748,74,687,76,687,71,687,74,687,72,916,74,458,76,916,71,458,72,1374,72,687,74,687,71,1374,71,1374,69,5496,76,687,72,687,74,687,79,687,76,2290,76,229,80,229,79,687,81,229,79,458,78,458,76,458,74,458,71,458,76,2290,76,687,72,687,72,458,71,458,74,458
HIT: .word 33,444
FOUND_KEY: .word 72,544
# PTR
TEMP:			.word 0 		# ações temporarias que necessitam de um buffer
CURRENT_FRAME:		.word 0
WALKABLE_BLOCKS:	.space 121		# vetor de 121 elementos, 0 = walkable, 1 = unwalkable
DOOR_STATE:		.word 1 		# 0 -> open, 1 -> closed
KEY_COUNTER:		.word 0	
LIFE_COUNTER:		.word 3
KEY_BLOCKS:		.space 121		# vetor de 121 elementos, 0 = false, 1 = true
MORTAL_BLOCKS:		.space 121		# vetor de 121 elementos, 0 = false, 1 = true
BRIDGE_BLOCKS:		.space 121		# vetor de 121 elementos, 0 = false, 1 = true
PUSHABLE_BLOCKS:	.space 121		# vetor de 121 elementos, 0 = false, 1 = true
CURRENT_LEVEL:		.word 1
CLOCK:			.word 0
CLOCK_2:		.word 0
SCORE_POSX:		.word 266
SCORE_POSY:		.word 52
########################################
# Imprime a porta (coordenadas padrão) #
########################################
.macro print_door()
frame_address(a1)
loadw(t0, DOOR_STATE)
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
######################################################################
# Marca N blocos a partir da coordenada X,Y como blocos não andáveis #
######################################################################
.macro mark_as_block(%n, %x, %y)
li a0, %n
li a2, %x
li a3, %y
jal MARK_AS_BLOCK
.end_macro
##########################################################################
# Imprime uma sprite 16x16 a partir de um endereço encontrado na memória #
##########################################################################
.macro render_sprite(%sprite, %current_x, %current_y)
# escolhe a frame aonde a sprite será desenhada
frame_address(a1)
la s1, %sprite
li a3,16		# todos os sprites são quadrados 16x16
loadw( t1,%current_y )
loadw( t2,%current_x )	
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
######################################################################
# Renderiza a sprite assim como a macro acima, porém nas duas frames #
######################################################################
.macro render_abs_sprite(%sprite, %current_x, %current_y)
# escolhe a frame aonde a sprite será desenhada
li a1,FRAME_0
la s1, %sprite
li a3,16		# todos os sprites são quadrados 16x16
loadw( t1,%current_y )
loadw( t2,%current_x )	
li t3, 320
mul t3,t1,t3		# aux = linhax320 (linha)
add a1,a1,t3
add a1,a1,t2		# endereço inicial = linha x 320 + coluna
mv a2,a1		
li t1,4816		# 15x320 +16	
add a2,a2,t1		# endereço final = endereço inicial + 16x320 + 16 	
li t1,0x100000
add a4,a1,t1		# endereço inicial na frame 1 = endereço inical + 0x100000
addi s1,s1,8		# chega ao .text
li t1,0			# contador
li t2, 0xffffff80
# ==========================================================
# a1 = endereço inicial (frame 0)
# a2 = endereço final (frame 1)
# a3 = numero de pixels a serem pintados por linha
# a4 = endereço da frame 1
# t1 = contador de pixels pintados
# t2 = cor a ser substituida pelo transparente
# ==========================================================
jal PAS_LOOP
.end_macro
################################################
# Marca o bloco nas coordenadas x,y como chave #
################################################
.macro mark_as_key(%x, %y)
li t3, %y
li t2, %x
calculate_block(t2,t3)
# t1 = block
la t0, KEY_BLOCKS
add t0,t0,t1
li t1,1
sb t1,(t0)
.end_macro
#################################################
# Marca o bloco nas coordenadas x,y como mortal #
#################################################
.macro mark_as_mortal(%x, %y)
li t3, %y
li t2, %x
calculate_block(t2,t3)
# t1 = block
la t0, MORTAL_BLOCKS
add t0,t0,t1
li t1,1
sb t1,(t0)
.end_macro
#################################################
# Marca o bloco nas coordenadas x,y como ponte  #
#################################################
.macro mark_as_bridge(%x, %y)
li t3, %y
li t2, %x
calculate_block(t2,t3)
# t1 = block
la t0, BRIDGE_BLOCKS
add t0,t0,t1
li t1,1
sb t1,(t0)
.end_macro
######################################################
# Marca o bloco nas coordenadas x,y como empurrável  #
######################################################
.macro mark_as_pushable(%x, %y)
li t3, %y
li t2, %x
calculate_block(t2,t3)
# t1 = block
la t0, PUSHABLE_BLOCKS
la t2, WALKABLE_BLOCKS
add t0,t0,t1
add t2,t2,t1
li t1,1
sb t1,(t0)
sb t1,(t2)
.end_macro
################################################
# Apaga o bloco nas coordenadas atuais de Lolo #
################################################
.macro erase_block()
switch_frame()
render_sprite(tijolo,LOLO_POSX,LOLO_POSY)
switch_frame()
.end_macro
############################################
# Reseta o estado dos blocos para o padrão #
############################################
.macro reset_blocks()
jal RESET_BLOCKS
.end_macro
#################################
# Apenas chama o menu principal #
#################################
.macro start_menu()
j START_MENU
.end_macro

########################################################
# Configura um inimigo nas posições X,Y, com uma velo- #
# cidade específica e blocos inicial e final por onde  #
# ele vai se movimentar				       #
# - Adiciona cada um desses atributos a um vetor       #			       
########################################################
.macro set_enemy(%enemy_num,%posx,%posy,%speed,%initial_block,%final_block)
li t2,%enemy_num
li t3,4
mul t2,t2,t3
la t3,ENEMY_POSX
add t3,t3,t2
li t1,%posx
sw t1,(t3)
savew(t1,CURRENT_ENEMY_POSX)
la t3,ENEMY_POSY
add t3,t3,t2
li t1,%posy
sw t1,(t3)
savew(t1,CURRENT_ENEMY_POSY)
la t3,ENEMY_SPEED
add t3,t3,t2
li t1,%speed
sw t1,(t3)
savew(t1,CURRENT_ENEMY_SPEED)
la t3,ENEMY_INITIAL_BLOCK
add t3,t3,t2
li t1,%initial_block
sw t1,(t3)
savew(t1,CURRENT_ENEMY_I_BLOCK)
la t3,ENEMY_FINAL_BLOCK
add t3,t3,t2
li t1,%final_block
sw t1,(t3)
savew(t1,CURRENT_ENEMY_F_BLOCK)
render_sprite(enemy,CURRENT_ENEMY_POSX,CURRENT_ENEMY_POSY)
.end_macro
#####################################################
# Configura um inimigo que atira nas posições X e Y #
# - As informações serão utilizadas para efetuar o  #
# disparo					    #			       
#####################################################
.macro set_shooting_enemy(%posx,%posy,%speed,%final_block)
li t1,%posx
savew(t1,SHOT_POSX)
li t1,%posx
savew(t1,SHOT_INITIAL_POSX)
li t1,%posy
savew(t1,SHOT_POSY)
li t1,%speed
savew(t1,SHOT_SPEED)
li t1,%final_block
savew(t1,SHOT_FINAL_BLOCK)
.end_macro
#############################
# Apenas chama a soundtrack #
#############################
.macro ost()
jal SOUNDTRACK
.end_macro
###################
# Efeitos sonoros #
###################
.macro sound(%label)
li a2,7
li a3,30
la t0,%label
lw a0,0(t0)
lw a1,4(t0)
call midiOut
.end_macro
#######################
# Apenas chama o jogo #
#######################
.macro game()
j GAME
.end_macro
###############################################
# Executa o encerramento do jogo (zerando)    #
# Tela preta -> tela de encerramento + musica #
###############################################
.macro ending()
sleep(2000)
loadw(t3,CURRENT_FRAME)
jal BLACK_SCREEN
frame_address(t1)
mv t0,t1
la s0, ending
jal IMPRIME
ost()
li t1,1
savew(t1,CURRENT_LEVEL)
start_menu()
.end_macro
###############################################
# Executa o encerramento do jogo (morrendo)   #
# Tela preta -> tela de morte		      #
###############################################
.macro you_died()
sleep(2000)
loadw(t3,CURRENT_FRAME)
li t2, FRAME_SELECT
sw t3(t2)
jal BLACK_SCREEN
frame_address(t1)
mv t0,t1
la s0, death
jal IMPRIME
sleep(4000)
li t1,3
savew(t1,LIFE_COUNTER)
li t1,1
savew(t1,CURRENT_LEVEL)
reset()
li t1,0
savew(t1,CURRENT_ENEMY_POSX)
savew(t1,CURRENT_ENEMY_POSY)
savew(t1,CURRENT_ENEMY_SPEED)
savew(t1,CURRENT_ENEMY_I_BLOCK)
savew(t1,CURRENT_ENEMY_F_BLOCK)
start_menu()
.end_macro
########################################
# Procedimentos após o fim de uma fase #
########################################
.macro  finished_level()
sleep(2000)
loadw(t1, CURRENT_LEVEL)
addi t1,t1,1
savew(t1, CURRENT_LEVEL)
reset()
game()
.end_macro
##########################
# Procedimentos pré-fase #
# Tela preta -> título   #
##########################
.macro level_title(%level)
loadw(t3,CURRENT_FRAME)
jal BLACK_SCREEN
sleep(500)
frame_address(t1)
mv t0,t1
la s0, %level
jal IMPRIME
sleep(3500)
.end_macro
########################################################
#  Carrega um conteúdo da memória para um registrador  #	
########################################################
.macro loadw(%reg, %label)
li %reg,0
la %reg,%label
lw %reg,(%reg)
.end_macro
######################################
#  Retorna o endereço da frame atual #	
######################################
.macro frame_address(%reg)
loadw(%reg,CURRENT_FRAME)
li t0,0xff0
add %reg,t0,%reg
slli %reg,%reg,20
.end_macro
###################################################
# Calcula o bloco utilizando as coordenadas (X,Y) #
###################################################
.macro calculate_block(%regx,%regy)
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
# Retorna T1 como bloco (x,y)
.end_macro
#################################################
# Salva na memória o conteúdo de um registrador #
#################################################
.macro savew(%reg, %label)
la t0,%label
sw %reg,(t0)
.end_macro
####################################################
# Reseta blocos, estado da porta e posição do Lolo #	
####################################################
.macro reset()
reset_blocks()
li t1,1
savew(t1,DOOR_STATE)
li t1,74
savew(t1,LOLO_POSX)
li t1,36
savew(t1,LOLO_POSY)
.end_macro
#################################################
# Troca o estado da frame armazenado na memória #
# PS: não troca a frame no bitmap		#	
#################################################
.macro switch_frame()
loadw(t1,CURRENT_FRAME)
xori t1,t1,0x001
savew(t1,CURRENT_FRAME)
.end_macro
###############################################################
# Troca a frame no bitmap para o estado armazenado na memória #	
###############################################################
.macro frame_refresh()
loadw(t1,CURRENT_FRAME)
li t0,FRAME_SELECT
sw t1,(t0)
.end_macro
###############################################
# Atualiza o estado da porta (aberta,fechada) #	
###############################################
.macro door_refresh()
loadw(t1, KEY_COUNTER)
jal KEY_TEST
print_door()
switch_frame()
print_door()
switch_frame()
.end_macro
###################################
# Pausa o programa por N segundos #	
###################################
.macro sleep(%n)
li a0,%n
li a7,32
ecall
.end_macro


# Include
.include "./sprites/lolo/lolo_coca.data"
.include "./sprites/lolo/lolo_pisca.data"
.include "./sprites/lolo_up/lolo_up_1.data"
.include "./sprites/lolo_down/lolo_down_1.data"
.include "./sprites/lolo_right/lolo_right_1.data"
.include "./sprites/lolo_left/lolo_left_1.data"
.include "./sprites/enemies/enemy.data"
.include "./sprites/enemies/enemy_left.data"
.include "./sprites/enemies/enemy_right.data"
.include "./sprites/enemies/enemy_shot.data"
.include "./sprites/blocos/tijolo.data"
.include "./sprites/blocos/bridge.data"
.include "./sprites/blocos/pblock.data"
.include "./sprites/blocos/score_one.data"
.include "./sprites/blocos/score_two.data"
.include "./sprites/blocos/score_three.data"
.include "./sprites/porta/porta.data"
.include "./sprites/porta/porta_fechada.data"
.include "./sprites/bg/start_menu_1.data"
.include "./sprites/bg/start_menu_2.data"
.include "./sprites/bg/fase_1.data"
.include "./sprites/bg/fase_2.data"
.include "./sprites/bg/fase_3.data"
.include "./sprites/bg/fase_4.data"
.include "./sprites/bg/fase_5.data"
.include "./sprites/bg/stage_one.data"
.include "./sprites/bg/stage_two.data"
.include "./sprites/bg/stage_three.data"
.include "./sprites/bg/stage_four.data"
.include "./sprites/bg/final_stage.data"
.include "./sprites/bg/ending.data"
.include "./sprites/bg/death.data"
.include "./sprites/bg/password_screen.data"

