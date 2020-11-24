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
		
.text

Main:
	inputdialog_str("Inserte cadena #1: (max 10 caracteres) ", 11)
	inputdialog_str("Inserte cadena #2: (max 10 caracteres) ", 11)
	inputdialog_str("Inserte cadena #3: (max 10 caracteres) ", 11)

Print:			
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