# Lab 03
# Antonio Gonzalez Restrepo - Vanessa Tocasuche Ochoa

# Macro para pedir datos en ventana

.macro escribirarchivosalida(%descriptor, %buffer, %offset, %int)
	
	li $v0, 15
	move $a0, %descriptor
	la $a1, %buffer(%offset)
	move $a2, %int
	syscall
	
.end_macro

.macro inputdialog_str (%str, %espacio)
	.data
	texto: .asciiz %str
	.align 2
	cadena: .space %espacio
	
	.text
	li $v0, 54
	la $a0, texto
	la $a1, cadena
	li $a2, %espacio
	syscall
	
.end_macro 

	
.data
file_input: .asciiz "testing.txt" 
file_output: .asciiz "resultado.txt"


salto: .byte 0x0A # Salto de linea
separador: .byte 0x20, 0x3A, 0x20 #espacio y gui�n
repeticiones: .asciiz " repeticiones. \n"

.align 2 # Direccionamos el buffer a una direccion de palabra
buffer: .space 100 # Reservamos 100B para lectura del archivo iterado.

numero: .space 10 # Reservamos 3 bytes para cada numero en ascii
	
.text 
	
Main:	
	inputdialog_str("\nInserte cadena #1 (longitud max: 10): ", 11)
		
	jal abrirArchivoEntrada
	jal leerArchivoEntrada
	
	#Calculamos largo de la cadena 1 y llenado de parametros: 
	la $a0, cadena_M0
	jal largoString

	la $a1, buffer
	move $a3, $v0 # $a3 guarda el largo de la cadena 1
	
	jal contarFrecuencia
	move $s5, $v0 
	
	jal cerrarArchivoEntrada
	
	jal abrirArchivoSalida
	escribirarchivosalida( $s1, cadena_M0, $zero, $a3) # escribe el nombre de cadena
	addi $t9, $zero, 3
	escribirarchivosalida( $s1, separador, $zero, $t9) # escirbe separadores
	
	move $a0, $s5
	la $a1, numero
	jal decToAscii
	move $t8, $v0
	addi $t9, $zero, 10
	sub $t9, $t9, $t8
	escribirarchivosalida( $s1, numero, $t8, $t9)
	addi $t9, $zero, 16
	escribirarchivosalida( $s1, repeticiones, $zero, $t9) # escirbe separadores
	
	
	
	inputdialog_str("\nInserte cadena #2 (longitud max: 10): ", 11)
		
	jal abrirArchivoEntrada
	jal leerArchivoEntrada
	

	la $a0, cadena_M1
	jal largoString

	la $a1, buffer
	move $a3, $v0 # $a3 guarda el largo de la cadena 2
	
	jal contarFrecuencia
	move $s6, $v0 
	
	jal cerrarArchivoEntrada
	

	escribirarchivosalida( $s1, cadena_M1, $zero, $a3) # escribe el nombre de cadena
	addi $t9, $zero, 3
	escribirarchivosalida( $s1, separador, $zero, $t9) # escirbe separadores
	
	move $a0, $s6
	la $a1, numero
	jal decToAscii
	move $t8, $v0
	addi $t9, $zero, 10
	sub $t9, $t9, $t8
	escribirarchivosalida( $s1, numero, $t8, $t9)
	addi $t9, $zero, 16
	escribirarchivosalida( $s1, repeticiones, $zero, $t9) # escirbe separadores
	
	
	
	inputdialog_str("\nInserte cadena #3 (longitud max: 10): ", 11)
	
	jal abrirArchivoEntrada
	jal leerArchivoEntrada
	

	la $a0, cadena_M2
	jal largoString

	la $a1, buffer
	move $a3, $v0 # $a3 guarda el largo de la cadena 2
	
	jal contarFrecuencia
	move $s7, $v0 
	
	jal cerrarArchivoEntrada
	

	escribirarchivosalida( $s1, cadena_M2, $zero, $a3) # escribe el nombre de cadena
	addi $t9, $zero, 3
	escribirarchivosalida( $s1, separador, $zero, $t9) # escirbe separadores
	
	move $a0, $s7
	la $a1, numero
	jal decToAscii
	move $t8, $v0
	addi $t9, $zero, 10
	sub $t9, $t9, $t8
	escribirarchivosalida( $s1, numero, $t8, $t9)
	addi $t9, $zero, 16
	escribirarchivosalida( $s1, repeticiones, $zero, $t9) # escirbe separadores
	
	# $s0 contiene el file descriptor del archivo de entrada
	# $s1 contiene el file descriptor del archivo de salida
	# $s5, $s6 y $s7 contienen la frecuencia de las 3 cadenas
	
	jal cerrarArchivoSalida
	
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
	move $s1, $v0 # Guardamos el file descriptor	
	jr $ra 
	
escribirArchivoSalida:
	
	li $v0, 15		
	move $a0, $s1		
	#la $a1, input_buffer	
	move $a2, $t1		
	syscall
	jr $ra
	
cerrarArchivoEntrada:
	li   $v0, 16      
	move $a0, $s0      
	syscall          
	jr $ra 

cerrarArchivoSalida:
	li   $v0, 16       
	move $a0, $s1   
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
				bne $t4, $t5, elifFreq
				addi $t3, $t3, 1
				addi $t1, $t1, 1
				j endIfFreq
			elifFreq:
				lb $t7, 0($a0)
				bne $t4, $t7, elseFreq
				addi $t3, $a0, 1
				addi $t1, $zero, 1
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

#################################################################
# $a0 tendra el numero:
# $a1 la direccion donde se van a guardar separados

# $ v0: ubicacion del primer digito del n�mero

decToAscii: 
	move $t2, $a1
	addi $t2, $t2, 9
	add $t1, $zero, 10	#Contador de n�mero de digitos
	
	#bne $a0, $zero, Loopdec
		#addi $t1, $t1, -1
		
	Loopdec:
		bltz $a0, ReturnAscii # Salta si $a0 <= 0
		div $a0, $a0, 10 # %a0 = $a0 / 10
		mfhi $t0 # $t0 guarda el residuo de la division
		addi $t0, $t0, 48 # $t0 = $t0 + 48 (Convierte a ASCII)
		sb $t0, 0($t2) # Guardamos $t0 en la memoria
		addi $t2, $t2, -1 # Nos movemos a la siguiente posicion de memoria
		addi $t1, $t1, -1
		beq $a0, $zero, ReturnAscii
		j Loopdec
	ReturnAscii:
		move $v0, $t1
		jr $ra

#################################################################


	
	
