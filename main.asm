###########################################################################
### 1. [X] Imprimir os elementos est�ticos				###
### 2. [] Movimentar o lolo com WASD					###
### 2.1 [] tentar implementar movimenta��o em blocos <- OLHA AQUI 	###
### 3. [] Travar a movimenta��o dentro do mapa				###
### 4. [] Colis�es com objetos est�ticos				###
### 5. [] Imprimir os elementos din�micos				###
### 6. [] Colis�es com objetos din�micos				###
### 7. [] Inimigos							###
### 8. [] Colis�es com ataques inimigos					###
### 9. [] Morte								###
###########################################################################
.eqv MAP_INITIAL_POSX		72
.eqv MAP_INITIAL_POSY		34
.eqv MAP_FINAL_POSX		248
.eqv MAP_FINAL_POSY		210
.data
.include "./sprites/blocos/rock.data"
.include "./sprites/bg/map.data"
.include "./macros.asm"
.text
main:	
	la s0,map
	jal IMPRIME
#	jal FUNDO
#	jal ESTATICOS_LEVEL_1
	PRINT_IMG(rock,232,194)
	exit()
	
.include "./procedimentos.asm"
#.include "./levels/level_1/level_1_estatico.asm"
#.include "./levels/interface.asm"
