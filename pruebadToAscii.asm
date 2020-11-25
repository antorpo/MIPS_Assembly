
.data
	num: .space 1
	

.text
	addi $s3, $zero, 123
	sb $s3, num
	addi $sp, $sp, -4
	addi $s0, $zero,0
	
loop:
	ble $s3, $zero, end_loop
	div $s3, $s3, 10
	mfhi $t0
	addi $t1, $t0, 48
	add $s0, $s0, $t1
	j loop
	
end_loop:		
	
	j exit
	
	
	
	
exit: 	li $v0, 10
	syscall
	

##########################################################
# Procedimiento para pasar a ascii
# Utilidad: Determina el largo en bytes de una cadena
# Entrada: Apuntador al primer byte de la cadena en $a0
# Salida: Conteo de los bytes diferentes de nulo en $v0
dectoascii:
	add $t0, $zero, $zero 	#  inicializa $t1 sera contador = 0
	#lb $t2, salto 		# Debemos omitir este caracter
	add $t3, $a0, $zero
			
	Loop:	lb $t1, 0($t3) 		# cargamos byte inicial
		beq $t1, $zero, return
		beq $t1, $t2, suma # Si encontramos el salto de linea no contamos
		addi $t0, $t0, 1 # $t0 = $t0 + 1
	suma:	addi $t3, $t3, 1 # $a0 = $a0 + 1 direccion byte siguiente
		j Loop
	
	return: add $v0, $t0, $zero # $v0 = contador
		jr $ra
##########################################################