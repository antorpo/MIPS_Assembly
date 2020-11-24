# ACyLab
# Demo for lab
# File handling in MIPS
# Not the smartest program but very illustrative

.data
file_in:	.asciiz "source.java"
file_out:	.asciiz "output.txt"
sentence:	.byte 0x0A, 0x0D, 0x0A, 0x0D
sentence_cont:	.asciiz "// This is the new ending line"

.align 2
input_buffer:	.space 20000

.text

# Abrir (para leer) un archivo
	li $v0, 13		# Llamada al sistema para abrir archivo
	la $a0, file_in		# Nombre del archivo de entrada
	li $a1, 0		# Abierto para lectura (bandera = 0)
	li $a2, 0		# El modo se ignora
	syscall			# Abrir un archivo (descriptor de archivo devuelto en $ v0)
	move $s0, $v0		# Copiar descriptor de aricho

# Abrir (para escribir) un archivo que no existe
	li $v0, 13		# Llamada al sistema para abrir archivo
	la $a0, file_out	# Nombre de arcchivo de entrada
	li $a1, 9		# abierto para escribir y agregar (bandera=9)
	li $a2, 0		# El modo se ignora
	syscall			# Abrir un archivo (descriptor de archivo devuelto en $ v0)
	move $s1, $v0		# Copiar descriptor de archivo

# Leer del archivo previamente abierto
	li $v0, 14		# Llamada al sistema para leer del archivo
	move $a0, $s0		# Descriptor de archivo
	la $a1, input_buffer	# Dirección del búfer de entrada
	li $a2, 20000		#  Número máximo de caracteres para leer
	syscall			# Leer del archivo
	move $t1, $v0		# Copia del número de caracteres leidos
	
# Archivo de proceso carga memoria

	li $v0, 15		# Llamada al sistema para escribir en un archivo
	move $a0, $s1		# Restaurar el descriptor de archivo (abierto para escritura)
	la $a1, input_buffer	# Dirección del búfer desde el cual escribir
	move $a2, $t1		# Numero de caracteres para escribir
	syscall
	
# Agregar una oración a un archivo

	li $v0, 15		# Llamada al sistema para leer del archivo
	move $a0, $s1		# Restaurar descriptor de archivo (abierto para escritura)
	la $a1, sentence	#  Dirección del búfer desde el que escribir
	li $a2, 40		# Numero de caracteres para escribir
	syscall
	
# Cerrar los archivos
 
	li   $v0, 16       # Llamada al sistema para cerrar el archivo
	move $a0, $s0      # Descriptor de archivo para cerrar
	syscall            # cerrrar archivo
	
	li   $v0, 16       # 
	move $a0, $s1      # 
	syscall            # 
			
Exit:	li   $v0, 10		# Llamada al sistema para salir.
	syscall
