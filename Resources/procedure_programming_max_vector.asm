# ACyLab
# Demo for class
# Procedure programming
# Not the smartest programming style but very illustrative

.data
Vector:	.word	97865, 969608, -220579, 828951, -915255, -863769, 479370, 996795, -684829, 480182, 482017, 818441, -279340, 544346, -518712, 166830, 799174, -514301, -828466, -889987, -672678, -704626, -973323, -227289, -918053, 135363, 989251, -951684, -295463, 736667, 681050, 756713, -902332, -842734, 970327, 813175, -178031, 648407, 145710, -88856, -914741, 903035, -145492, -397839, -655260, -183159, -248281, 361929, 548859, 582262, 9518, 922164, -311868, 969521, 917031, -981336, 95482, 437620, -585540, -654474, -493840, 21419, 960277, 245816, 687316, -919142, 986233, -613977, -126220, -836541, 283916, 430292, 458878, -562382, -615509, -374835, -404179, 711238, 638293, 195754, 618067, 134082, -334493, 802752, 272934, -164542, 505063, -629130, -991241, -353185, -886626, 769010, -989500, -325136, 721433, -897086, -142981, -877877, 758866, 545233
msg:	.asciiz	"El valor máximo es: "

.text
Main:	lui	$s0, 0x1234		# Simula el uso de los registros $s0 a $s3 en el programa principal
	lui	$s1, 0x5678		#  
	lui	$s2, 0x9ABC		#
	lui	$s3, 0xDEF0		#

	la	$a0, Vector		# $a0 tiene la dirección de Vector[0]
	
	jal	Maximum			# Llamada a procedimiento Maximum
					# Apuntador a Vector[0] pasado como argumento en $a0
					
Print:	add	$t0, $v0, $zero		# Copia resultado del procedimiento en $t0
	
	li	$v0, 4			# Service call for print
	la	$a0, msg
	syscall
	
	add	$a0, $t0, $zero		# Resultado a imprimir
	li   	$v0, 1			# system call for print integer
	syscall				# print
	
Exit:	li   	$v0, 10			# system call for exit
	syscall				# Exit!

#############################################################################################
# Procedimiento Maximum
# Utilidad: determina el valor más grande contenido en un vector de cien elementos
# Sigue la convención de uso de registros MIPS
# Entrada: apuntador al vector en el registro $a0
# Salida: el valor más grande del vector en $v0
Maximum:

# Con propósito demostrativo, se apilan cuatro registros 'saved', los cuales serán
# empleados para implementar el procedimiento
	
	addi 	$sp, $sp, -16
	sw   	$s0, 0($sp)		# $s0 al stack
	sw   	$s1, 4($sp)		# $s1 al stack
	sw   	$s2, 8($sp)		# $s2 al stack
	sw   	$s3, 12($sp)		# $s3 al stack
	
	addi	$s0, $zero, 99		# $s0 es contador de comparaciones para recorrer el vector
	lw	$s1, 0($a0)		# $s1 = Vector[0]. Máximo parcial
	
Loop:	addi	$a0, $a0, 4		# Apunta a siguiente elemento del vector
	lw	$s2, 0($a0)		# Carga en $s2 el siguiente elemento de vector
	
	slt	$s3, $s2, $s1		# Vector[i] < max. parcial? ($s3 actúa como flag)
	bne	$s3, $zero, index
	add	$s1, $s2, $zero		# Vector[i] >= max. parcial, entonces max. parcial = Vector[i]
	
index:	addi	$s0, $s0, -1		# Decrementa contador de comparaciones
	bne	$s0, $zero, Loop	
	
	add	$v0, $s1, $zero		# Pasa resultado en $v0
	
	lw   	$s3, 12($sp)		# Recupera $s3 del stack
	lw   	$s2, 8($sp)		# Recupera $s2 del stack
	lw   	$s1, 4($sp)		# Recupera $s1 del stack
	lw   	$s0, 0($sp)		# Recupera $s0 del stack
	addi 	$sp, $sp, 16		# Restaura el $sp	
	jr   	$ra			# retorno
# Fin procedimiento Maximum
#############################################################################################
