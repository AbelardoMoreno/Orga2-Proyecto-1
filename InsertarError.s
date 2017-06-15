.section .data

	archivoE: .asciz "entrada.txt"
	archivoS: .asciz "salida.txt"

	entrada:  .long 0
	salida:     .long 0
	Aux:        .long 2
	
	r:  .asciz "r"                                                                  
	w: .asciz "w"
	
	form: .asciz "%s"
	
	error:    .asciz "\nNo existe el archivo 'entrada.txt'\n\nIntroduzca cualquier tecla para continuar\n"
	errorC:  .asciz "\nEl archivo de entrada posee menos de 100 caracteres\n\nIntroduzca cualquier tecla para continuar\n"
	
	sucess: .asciz "\nEl error fue insertado con exito\n\nIntroduzca cualquier tecla para continuar\n"
	
.section .bss

	contador:  .space 4
	caracter:   .space 4
	opcion:	.space 4
	
.section .text

.globl InsertarError

InsertarError:
	
	leal r, %eax  
	pushl %eax  				# Se apila R, indicando que el archivo se abre en modo lectura
	leal archivoE, %eax
	
	pushl %eax
	call fopen    				# Se apila el nombre del archivo que se va a abrir
	addl $8, %esp
	
	movl %eax, entrada
	
	cmpl $0, entrada 			# Si el archivo entrada es igual a 0, significa que no existe y se marca el error
	je error1

	leal w, %eax
	pushl %eax   				# Se apila W, indicando que el archivo se abre en modo de escritura
	leal archivoS, %eax
	
	pushl %eax
	call fopen
	addl $8, %esp
	
	movl %eax, salida
	
	movl $-1, contador 			#Se inicia el contador en -1

while:

	pushl entrada 			
	call fgetc					#Se llama funcion fgetc que toma un caracter del archivo
	addl $4, %esp

	movl %eax, caracter		
	cmpl $0, caracter			#Si el caracter es menor que 0, se llego al final del archivo
	jl endwhile

	incl contador				#Se incrementa el contador para ver cuantos caracteres posee el archivo de entrada
	
	jmp while			

endwhile:
	
	cmpl $100, contador 		#Si hay menos de 100 caracteres, se muestra el error correspondiente
	jl error2
	
	pushl entrada
	call fclose					#Se cierra el archivo de entrada para volverlo a abrir posteriormente
	addl $4, %esp

	movl contador, %eax
	movl $0, %edx				#Se divide la cantidad de caracteres entre 2, para saber en que posicion insertar el error
	movl Aux, %ebx
	
	divl %ebx
	
	movl %eax, %ebx	
	movl $0, contador			#Se reinicia el contador
	
	leal r, %eax
	pushl %eax
	leal archivoE, %eax
	
	pushl %eax
	call fopen					#Se abre el archivo de entrada
	addl $8, %esp
	
while2:

	pushl entrada
	call fgetc					#Se van obteniendo los caracteres del archivo de entrada
	addl $4, %esp
	
	movl %eax, caracter		
	cmpl $0, caracter			#Si el caracter es menor que 0, se llego al final del archivo
	jl endwhile2
	
	incl contador		

	cmpl %ebx, contador			#Comparacion para saber cuando se llega a la posicion a la que se debe insertar el error
	je modificar

continue:

	pushl salida	
	pushl caracter			
	call fputc					#Se van colocando los caracteres en el archivo de salida, incluyendo el error
	addl $8, %esp
	
	jmp while2

endwhile2:

	pushl entrada
	call fclose					#Se cierran los archivos
	addl $4, %esp

	pushl salida
	call fclose
	addl $4, %esp
	
	pushl $sucess
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	
exit:
	ret   						#Salida
	
error1: 						#Rutina de tratamiento de error

	pushl $error
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	jmp exit
	
modificar:
	
	movl caracter, %eax
	addl $10, %eax				#Se suma 10 al caracter para agregar el error		
	movl %eax, caracter
	jmp continue

error2: 						#Rutina de tratamiento de error
	
	pushl $errorC
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	jmp exit
	