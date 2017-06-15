.section .data

	menu: .asciz "\nMENU \n 1. Insertar Error \n 2. Detectar Error \n 3. Desarroladores \n 4. Salir \nIntroduzca la opcion deseada \n"
	form:  .asciz "%s"
	error:  .asciz "Dato Invalido, Introduzca una nueva opcion\n"

.section .bss

	opcion:	.space 4
	
.section .text

.globl main

main: 

	movl $48, opcion 			#Se hace la opcion del menu igual a 0
	
	pushl $menu
	call printf					#Se imprime el menu
	addl $4,%esp

Leer:	
	pushl $opcion
	pushl $form				#Se lee la opcion que se desea accesar del menu
	call scanf
	addl $8,%esp

	
	cmpl $49, opcion			#Si la opcion es 1, se llama a la funcion de insertar error
	je   Insertar

	cmpl $50, opcion			#Si la opcion es 2, se llama a la funcion de detectar error
	je   Detectar

	cmpl $51, opcion			#Si la opcion es 3, se llama a la funcion desarrolladores
	je creditos
	
	cmpl $52, opcion			#Si la opcion es 4, se sale del programa
	je fin
	
	pushl $error
	call printf					#Si no es ninguna de las opciones validas, se muestra el error
	addl $4, %esp
	jmp Leer

Insertar: 

	call InsertarError			#Llamada de funcion
	addl $4,%esp
	jmp main
	
Detectar: 
	
	call DetectarError			#Llamada de funcion
	addl $4,%esp
	jmp main	

creditos:
	
	call Desarrolladores			#Llamada de funcion
	jmp main

fin:							#Salida de programa

	movl $1, %eax
	movl $0, %ebx
	int $0x80
	