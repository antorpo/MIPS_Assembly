.macro print_str (%str)
	.data
myLabel: .asciiz %str
	.text
	
	li $v0, 4
	la $a0, myLabel
	syscall
	.end_macro
	
	print_str ("vane")	#"test1" will be labeled with name "myLabel_M0"
	print_str ("test2")	#"test2" will be labeled with name "myLabel_M1"