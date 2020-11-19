.data 
msg: .asciiz "El largo del String es: "
texto: .asciiz "aSDwefosdlkmvoiwierantonioasdnmqwoieqwiondasantonioajsdoiqweoiantonioasd123"
cadena: .asciiz "antonio"
salto: .byte 0x0A # Salto de linea

.text

Main: 
	la $a0, texto
	jal largoString


Print:	add $t0, $v0, $zero		
	
	li $v0, 4			
	la $a0, msg
	syscall
	
	add $a0, $t0, $zero		
	li $v0, 1			
	syscall			

Exit:	
	# Termina le ejecucion del programa
	li $v0, 10 
	syscall
	
##########################################################
# Procedimiento largoString
# Utilidad: Determina el largo en bytes de una cadena
# Entrada: Apuntador al primer byte de la cadena en $a0
# Salida: Conteo de los bytes diferentes de nulo en $v0
largoString:
	add $t0, $zero, $zero #  inicializa $t1 sera contador = 0
	lb $t2, salto
			
	Loop:	lb $t1, 0($a0) # cargamos byte inicial
		beq $t1, $zero, return
		addi $t0, $t0, 1 # $t0 = $t0 + 1
		addi $a0, $a0, 1 # $a0 = $a0 + 1 direccion byte siguiente
		j Loop
	
	return: add $v0, $t0, $zero # $v0 = contador
		jr $ra
##########################################################
