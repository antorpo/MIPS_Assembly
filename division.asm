.data

numero: .space 3 # Reservamos 3 bytes para cada numero separado

.text

Main:
	addi $s3, $zero, 123  # $s3 = 0 + 123
	
	move $a0, $s3
	la $a1, numero

	jal algoritmoDivision
	
	


# $a0 tendra el numero:
# $a1 la direccion donde se van a guardar separados
algoritmoDivision: 
	
	Loop:	blez $a0, Return # Salta si $a0 <= 0
		div $a0, $a0, 10 # %a0 = $a0 / 10
		mfhi $t0 # $t0 guarda el residuo de la division
		addi $t0, $t0, 48 # $t0 = $t0 + 48 (Convierte a ASCII)
		sb $t0, 0($a1) # Guardamos $t0 en la memoria
		addi $a1, $a1, 1 # Nos movemos a la siguiente posicion de memoria
		j Loop
	Return:
		jr $ra
	