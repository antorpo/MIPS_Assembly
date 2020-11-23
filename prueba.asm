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
		

.macro messagedialog_str(%str, %tipo)
	.data 
	mensaje: .asciiz %str
	
	# Tipo: 
	# 0 - Error
	# 1 - Information
	# 2 - Warning
	# 3 - Question
	.text
	li $v0, 55
	la $a0, mensaje
	li $a1, %tipo
	syscall
.end_macro 

		
.text

Main:
	# Usamos la macro para pedir los datos y almacenarlos en un espacio de memoria.
	inputdialog_str("Inserte cadena #1: (max 10 caracteres) ", 11)
	inputdialog_str("Inserte cadena #2: (max 10 caracteres) ", 11)
	inputdialog_str("Inserte cadena #3: (max 10 caracteres) ", 11)

Print:			
	# Usamos la macro para imprimir un mensaje.
	messagedialog_str("Test mensaje de error", 0)
	messagedialog_str("Test mensaje de informacion", 1)
	messagedialog_str("Test mensaje de alerta", 2)
	messagedialog_str("Test mensaje de pregunta", 3)
	
	li $v0, 4			
	la $a0, cadena_M0
	syscall
	
	li $v0, 4			
	la $a0, cadena_M1
	syscall
	
	li $v0, 4			
	la $a0, cadena_M2
	syscall
	
Exit:	li $v0, 10			
	syscall				
