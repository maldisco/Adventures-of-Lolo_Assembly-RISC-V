# ===========================================
# 1. [] Imprimir os elementos est�ticos
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
.include "./sprites/rock.data"
.include "./macros.asm"

.text
main:	
	la s0,map
	jal IMPRIME
	la s1, rock		#endere�o do arquivo lolo
	imprime_imagem(100,100)
	exit()
	
.include "./procedimentos.asm"
