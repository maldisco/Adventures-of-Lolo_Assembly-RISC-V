# ===========================================
# 1. [X] Imprimir os elementos estáticos
# 2. [] Movimentar o lolo com WASD
# 3. [] Travar a movimentação dentro do mapa
# 4. [] Colisões com objetos estáticos
# 5. [] Imprimir os elementos dinâmicos
# 6. [] Colisões com objetos dinâmicos
# 7. [] Inimigos
# 8. [] Colisões com ataques inimigos
# 9. [] Implementar vitória/derrota
# ===========================================

.data
.include "./sprites/lolo/lolo_front_1.data"
.include "./sprites/bg/map.data"
.include "./macros.asm"
.text
main:	
	la s0,map
	jal IMPRIME
	jal FUNDO
	jal ESTATICOS_LEVEL_1
	exit()
	
.include "./procedimentos.asm"
.include "./levels/level_1/level_1_estatico.asm"
.include "./levels/interface.asm"
