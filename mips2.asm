.data
archivo: .asciiz "testing.txt"
salto: .byte 0x0A # Salto de linea

.align 2
buffer: .space 102

.text 

Main: 
	# Abrimos archivo para lectura
	li $v0, 13
	la $a0, archivo
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0
	
leerBuffer:
	# Leemos el archivo
	li   $v0, 14        
	move $a0, $s0      
	la   $a1, buffer   
	li   $a2,  102   
	syscall            
	move $s1, $v0
	
	la $a0, buffer
	jal largoString
	
	add $t1, $v0, $zero
	
	bne $s1, $zero, leerBuffer
	
	
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
	lb $t2, salto # Debemos omitir este caracter
			
	Loop:	lb $t1, 0($a0) # cargamos byte inicial
		beq $t1, $zero, return
		beq $t1, $t2, suma
		addi $t0, $t0, 1 # $t0 = $t0 + 1
	suma:	addi $a0, $a0, 1 # $a0 = $a0 + 1 direccion byte siguiente
		j Loop
	
	return: add $v0, $t0, $zero # $v0 = contador
		jr $ra
##########################################################

