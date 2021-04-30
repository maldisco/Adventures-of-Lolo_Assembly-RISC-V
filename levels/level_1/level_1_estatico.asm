.data
.include "../../macros.asm"
.include "../../sprites/blocos/rock.data"
.include "../../sprites/blocos/arbusto.data"
.text
ESTATICOS_LEVEL_1:	
	#####################
	# LINHA 1
	#####################
	la s1, rock		# endereço do arquivo
	imprime_imagem(72,34)
	la s1, rock
	imprime_imagem(88,34)
	la s1, rock
	imprime_imagem(104,34)
	la s1, rock
	imprime_imagem(120,34)
	la s1, rock
	imprime_imagem(136,34)
	la s1, rock
	imprime_imagem(152,34)
	la s1, rock
	imprime_imagem(184,34)
	la s1, rock
	imprime_imagem(200,34)
	la s1, arbusto
	imprime_imagem(216,34)
	la s1, arbusto
	imprime_imagem(232,34)
	#####################
	# LINHA 2
	#####################
	la s1, rock
	imprime_imagem(72,50)
	la s1, arbusto
	imprime_imagem(88,50)
	la s1, arbusto
	imprime_imagem(104,50)
	la s1, rock
	imprime_imagem(120,50)
	la s1, rock
	imprime_imagem(184,50)
	la s1, rock
	imprime_imagem(200,50)
	la s1, arbusto
	imprime_imagem(216,50)
	la s1, arbusto
	imprime_imagem(232,50)
	#####################
	# LINHA 3
	#####################
	la s1, arbusto
	imprime_imagem(88,66)
	la s1, arbusto
	imprime_imagem(104,66)
	la s1, rock
	imprime_imagem(120,66)
	la s1, rock
	imprime_imagem(136,66)
	la s1, rock
	imprime_imagem(152,66)
	la s1, rock
	imprime_imagem(184,66)
	la s1, rock
	imprime_imagem(200,66)
	la s1, rock
	imprime_imagem(216,66)
	la s1, arbusto
	imprime_imagem(232,66)
	#####################
	# LINHA 4
	#####################
	la s1, arbusto
	imprime_imagem(104,82)
	la s1, arbusto
	imprime_imagem(120,82)
	la s1, rock
	imprime_imagem(136,82)
	la s1, rock
	imprime_imagem(152,82)
	la s1, rock
	imprime_imagem(184,82)
	la s1, rock
	imprime_imagem(200,82)
	la s1, rock
	imprime_imagem(216,82)
	la s1, arbusto
	imprime_imagem(232,82)
	#####################
	# LINHA 5
	#####################
	la s1, rock
	imprime_imagem(136,98)
	la s1, rock
	imprime_imagem(152,98)
	la s1, rock
	imprime_imagem(184,98)
	la s1, rock
	imprime_imagem(200,98)
	la s1, arbusto
	imprime_imagem(216,98)
	#####################
	# LINHA 6
	#####################	
	la s1, rock
	imprime_imagem(200,114)
	#####################
	# LINHA 8
	#####################	
	la s1, arbusto
	imprime_imagem(88,130)
	la s1, arbusto
	imprime_imagem(104,130)
	#####################
	# LINHA 9
	#####################	
	la s1, arbusto
	imprime_imagem(72,146)
	la s1, arbusto
	imprime_imagem(88,146)
	la s1, arbusto
	imprime_imagem(104,146)
	la s1, arbusto
	imprime_imagem(120,146)
	la s1, arbusto
	imprime_imagem(184,146)
	la s1, arbusto
	imprime_imagem(200,146)
	#####################
	# LINHA 10
	#####################	
	la s1, arbusto
	imprime_imagem(72,162)
	la s1, arbusto
	imprime_imagem(88,162)
	la s1, arbusto
	imprime_imagem(104,162)
	la s1, arbusto
	imprime_imagem(120,162)
	la s1, arbusto
	imprime_imagem(184,162)
	la s1, arbusto
	imprime_imagem(200,162)
	la s1, arbusto
	imprime_imagem(216,162)
	#####################
	# LINHA 11
	#####################	
	la s1, rock
	imprime_imagem(72,178)
	la s1, arbusto
	imprime_imagem(88,178)
	la s1, arbusto
	imprime_imagem(104,178)
	la s1, rock
	imprime_imagem(120,178)
	la s1, arbusto
	imprime_imagem(200,178)
	la s1, arbusto
	imprime_imagem(216,178)
	#####################
	# LINHA 12
	#####################	
	la s1, rock
	imprime_imagem(72,194)
	la s1, rock
	imprime_imagem(88,194)
	la s1, rock
	imprime_imagem(104,194)
	la s1, rock
	imprime_imagem(120,194)
	la s1, rock
	imprime_imagem(136,194)
	la s1, rock
	imprime_imagem(152,194)
	ret