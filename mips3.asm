.data
numero1: .byte 0x07
numero2: .byte 0x0A

.text

Main:
	lb $t0, numero1
	lb $t1, numero2
	
	blt $t0, $t1, Ejemplo
	j Exit

Ejemplo: 
	addi $t0, $t0, 5 
	  
Exit: li $v0, 10
      syscall	    