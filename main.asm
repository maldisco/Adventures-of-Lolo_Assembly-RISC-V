###########################################################################
### 1. [X] Imprimir os elementos estáticos				###
### 2. [] Movimentar o lolo com WASD					###
### 2.1 [] tentar implementar movimentação em blocos <- OLHA AQUI 	###
### 3. [] Travar a movimentação dentro do mapa				###
### 4. [] Colisões com objetos estáticos				###
### 5. [] Imprimir os elementos dinâmicos				###
### 6. [] Colisões com objetos dinâmicos				###
### 7. [] Inimigos							###
### 8. [] Colisões com ataques inimigos					###
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
