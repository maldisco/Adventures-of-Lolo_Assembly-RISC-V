# ===========================================
# 1. [X] Imprimir os elementos est�ticos
# 2. [] Movimentar o lolo com WASD
# 3. [] Travar a movimenta��o dentro do mapa
# 4. [] Colis�es com objetos est�ticos
# 5. [] Imprimir os elementos din�micos
# 6. [] Colis�es com objetos din�micos
# 7. [] Inimigos
# 8. [] Colis�es com ataques inimigos
# 9. [] Implementar vit�ria/derrota
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
