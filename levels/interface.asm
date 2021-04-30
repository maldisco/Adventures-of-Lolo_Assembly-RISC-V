.data
.include "../macros.asm"
.include "../sprites/lolo_down/lolo_down_1.data"

.text
FUNDO:
	la s1, lolo_down_1
	imprime_imagem(264, 32)
	ret
	