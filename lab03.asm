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
	
	imprime_str("\nInserte cadena #2 (longitud max: 10): ")
	
	# Leemos la cadena 2
	li $v0, 8
	la $a0, cadena_2
	li $a1, 11
	syscall

	imprime_str("\nInserte cadena #3 (longitud max: 10): ")
	
	# Leemos la cadena 3
	li $v0, 8
	la $a0, cadena_3
	li $a1, 11
	syscall
	
	la $a0, cadena_3
	jal largoString
	
	add $t0, $v0, $zero
	imprime_str("\nLargo de la cadena 3: ")
	imprime_int($t0)
	j Exit

abrirArchivoEntrada:
	# Abrimos archivo para lectura
	li $v0, 13
	la $a0, file_input
	li $a1, 0
	li $a2, 0
	syscall
	move $s0, $v0 # Guardamos el file descriptor 
	
leerArchivoEntrada:
	# Leemos el archivo de a 100 bytes en el buffer
	li   $v0, 14        
	move $a0, $s0      
	la   $a1, buffer   
	li   $a2,  100    
	syscall            
	move $s1, $v0 # Guardamos cantidad de caracteres leidos
	
abrirArchivoSalida:
	# Abrimos el archivo para escritura 
	li $v0, 13		
	la $a0, file_output	
	li $a1, 9		
	li $a2, 0		
	syscall			
	move $s2, $v0 # Guardamos el file descriptor	

# Falta insertar texto en archivo salida
	
cerrarArchivos:
	li   $v0, 16      
	move $a0, $s0      
	syscall           
	
	li   $v0, 16       
	move $a0, $s2   
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
	
	Loop:	lb $t1, 0($a0) # cargamos byte inicial
		beq $t1, $zero, return
		addi $t0, $t0, 1 # $t0 = $t0 + 1
		addi $a0, $a0, 1 # $a0 = $a0 + 1 direccion byte siguiente
		j Loop
	
	return: add $v0, $t0, $zero # $v0 = contador
		jr $ra
##########################################################
	
	
