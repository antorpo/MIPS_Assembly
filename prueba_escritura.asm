# Prueba para imprimir en un archivo un String.
.macro escribirarchivosalida (%descriptor, %buffer, %largo)
	li $v0,  15
	move $a0, %descriptor
	la $a1, %buffer
	li $a2, %largo
	syscall
.end_macro 

.data
file_output: .asciiz "salida.txt"

palabra: .asciiz "Hola como estas"
palabra2: .asciiz "Bien bien bien"

.align 2
buffer: .space 100 

.text 

Main:
	jal abrirArchivoSalida
	escribirarchivosalida($s1, palabra, 50) # Utilizamos el macro para escribir en el archivo
	jal cerrarArchivoSalida
	j Exit

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
	# Escribimos en el archivo
	# Aunque podemos modificar este procedimiento para escribir lo que queramos
	li $v0, 15		
	move $a0, $s1		
	la $a1,	palabra	
	li $a2, 50		
	syscall
	jr $ra

cerrarArchivoSalida:
	li   $v0, 16       
	move $a0, $s1   
	syscall            
	jr $ra

Exit:	li $v0, 10			
	syscall	
