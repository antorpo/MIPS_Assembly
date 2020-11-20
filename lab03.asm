# Lab 03
# Antonio Gonzalez Restrepo - Vanessa Tocasuche Ochoa

# Macro para imprimir el String especificado
.macro imprime_str (%str)
	.data
texto: .asciiz %str
	.text
	li $v0, 4
	la $a0, texto
	syscall
.end_macro

# Macro para imprimir el entero especificado (NO SE NECESITA REALMENTE SOLO PARA PRUEBAS)
.macro imprime_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro


.data
file_input: .asciiz "testing.txt" 
file_output: .asciiz "resultado.txt"

# Creamos el espacio para almacenar las cadenas a identificar
cadena_1: .space 11
cadena_2: .space 11
cadena_3: .space 11

salto: .byte 0x0A # Salto de linea

.align 2 # Direccionamos el buffer a una direccion de palabra
buffer: .space 100 # Reservamos 100B para lectura del archivo iterado.
	
.text 
	
Main:	
	imprime_str("\nInserte cadena #1 (longitud max: 10): ")
	
	# Leemos la cadena 1
	li $v0, 8
	la $a0, cadena_1
	li $a1, 11
	syscall
	
	jal abrirArchivoEntrada
	jal leerArchivoEntrada
	
	#Calculamos largo de la cadena 1 y llenado de parametros: 
	la $a0, cadena_1
	jal largoString

	la $a1, buffer
	#add $a2, $s1, $zero # $a2 guarda los datos leidos del buffer
	add $a3, $v0, $zero # $a3 guarda el largo de la cadena 1
	
	jal contarFrecuencia
	move $s7, $v0
	
	j Exit
	

abrirArchivoEntrada:
	# Abrimos archivo para lectura
	li $v0, 13
	la $a0, file_input
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0 # Guardamos el file descriptor 
	jr $ra
	
leerArchivoEntrada:
	# Leemos el archivo de a 100 bytes en el buffer
	li   $v0, 14        
	move $a0, $s0      
	la   $a1, buffer   
	li   $a2,  100    
	syscall            
	move $a2, $v0 # Guardamos cantidad de caracteres leidos
	jr $ra
	
abrirArchivoSalida:
	# Abrimos el archivo para escritura 
	li $v0, 13		
	la $a0, file_output	
	li $a1, 9		
	li $a2, 0		
	syscall			
	move $s2, $v0 # Guardamos el file descriptor	
	jr $ra 
	
# Falta insertar texto en archivo salida
	
cerrarArchivos:
	li   $v0, 16      
	move $a0, $s0      
	syscall           
	
	li   $v0, 16       
	move $a0, $s2   
	syscall            
	jr $ra
	
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
	add $t3, $a0, $zero
			
	Loop:	lb $t1, 0($t3) # cargamos byte inicial
		beq $t1, $zero, return
		beq $t1, $t2, suma # Si encontramos el salto de linea no contamos
		addi $t0, $t0, 1 # $t0 = $t0 + 1
	suma:	addi $t3, $t3, 1 # $a0 = $a0 + 1 direccion byte siguiente
		j Loop
	
	return: add $v0, $t0, $zero # $v0 = contador
		jr $ra
##########################################################


##########################################################
# Procedimiento contarFrecuencia
# Utilidad: Cuenta la frecuencia de apariciones de una cadena
# dentro de un texto.
# Entrada: 
# $a0 - direccion de la cadena
# $a1 - direccion del buffer
# $a2 - cantidad de datos leidos en el buffer
# $a3 - cantidad de caracteres de la cadena
# Salida: 
# $v0 - cantidad de apariciones de la cadena en el texto

contarFrecuencia:
	
	add $t2, $zero, $zero # $t2 sera el contadorRepeticiones
	add $t1, $zero, $zero # $t1 sera el contadorCadena
	add $t3, $a0, $zero # direccion de la cadena
	
	asignaFreq:
	add $t0, $zero, $zero # $t0 sera el contadorBuffer
	add $t6, $a1, $zero # direccion del buffer
	
	beq $a2, $zero, returnFreq # Si ya leimos todos los datos del archivo retornamos
	#blt $a2, $a3, returnFreq # Si los datos leidos son menores que la longitud de la cadena retornamos
			
	loopFreq:	bge $t0, $a2, endLoopFreq # Si contadorBuffer es mayor o igual a datosBuffer salimos.
			lb $t4, 0($t6) # Almacenamos en $t3 el valor de buffer[contadorBuffer]
			lb $t5, 0($t3) # Almacenamos en $t4 el valor de cadena[contadorCadena]
			
			ifFreq: 
				bne $t4, $t5, elseFreq
				addi $t3, $t3, 1
				addi $t1, $t1, 1
				j endIfFreq
			elseFreq:
				add $t3, $a0, $zero
				add $t1, $zero, $zero
			endIfFreq:
			# Aca viene el segundo if contadorCadena == datosCadena
			
			bne $t1, $a3, elseFreq2
			addi $t2, $t2, 1
			add $t3, $a0, $zero
			add $t1, $zero, $zero
			
			elseFreq2: 
			
			# contadorBuffer++
			addi $t6, $t6, 1
			addi $t0, $t0, 1
			j loopFreq
			
	endLoopFreq:	
			# Push 
			addi $sp, $sp, -28
			sw $ra, 0($sp) # Se almacena el registro de retorno $ra en la pila
			sw $a0, 4($sp) # Se almacena direccionCadena
			sw $a1, 8($sp)  # Se almacena direccionBuffer
			sw $a3, 12($sp) # Se almacena datosCadena
			sw $t2, 16($sp) # Se almacena contadorRepeticiones
			sw $t1, 20($sp) # Se almacena contadorCadena
			sw $t3, 24($sp) 
			
			jal leerArchivoEntrada # Leemos otros 100B del buffer
			
			# Pop
			lw $t3, 24($sp)
			lw $t1, 20($sp)
			lw $t2, 16($sp)
			lw $a3, 12($sp)
			lw $a1, 8($sp)
			lw $a0, 4($sp)
			lw $ra, 0($sp)
			addi $sp, $sp, 28
			
			j asignaFreq
			
	returnFreq: 	add $v0, $t2, $zero # $v0 = contador
			jr $ra


##########################################################
	
	
