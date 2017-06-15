.section .data
	
	archivoE: .asciz "entrada.txt"
	archivoS: .asciz "salida.txt"
	
	entrada: 	.long 0
	salida:    	.long 0
	sumOri:  	.long 0
	sumDes: 	.long 0
	
	r:  .asciz "r"                                                                  
	w: .asciz "w"
	
	form: .asciz "%s"
	
	error:   .asciz "\nNo existe el archivo 'entrada.txt'\n\nIntroduzca cualquier tecla para continuar\n"
	errorC: .asciz "\nNo existe el archivo 'salida.txt'\n\nIntroduzca cualquier tecla para continuar\n"
	
	sucess:   .asciz "\nExiste un error en el archivo de salida\n\nIntroduzca cualquier tecla para continuar\n"
	sucess2: .asciz "\n No existen errores en el archivo de salida\n\nIntroduzca cualquier tecla para continuar\n"
	
.section .bss

	contador: .space 4
	caracter: .space 4
	opcion:    .space 4
	
.section .text

.globl DetectarError

DetectarError:
	
	leal r, %eax  
	pushl %eax  				# Se apila R, indicando que el archivo se abre en modo lectura
	leal archivoE, %eax
	
	pushl %eax
	call fopen    				# Se apila el nombre del archivo que se va a abrir
	addl $8, %esp
	
	movl %eax, entrada
	
	cmpl $0, entrada 			# Si el archivo entrada es igual a 0, significa que no existe y se marca el error
	je error1

	leal r, %eax
	pushl %eax   				# Se apila R, indicando que el archivo se abre en modo lectura
	leal archivoS, %eax
	
	pushl %eax
	call fopen
	addl $8, %esp
	
	movl %eax, salida
	
	cmpl $0, salida
	je error2
	
while:

	pushl entrada 			
	call fgetc					#Se llama funcion fgetc que toma un caracter del archivo
	addl $4, %esp

	movl %eax, caracter		
	cmpl $0, caracter			#Si el caracter es menor que 0, se llego al final del archivo
	jl endwhile
	
	movl caracter, %eax
	addl %eax, sumOri
	
	jmp while			

endwhile:
	
	
	pushl entrada
	call fclose					#Se cierra el archivo de entrada
	addl $4, %esp
	
	leal r, %eax
	pushl %eax
	leal archivoS, %eax
	
	pushl %eax
	call fopen					#Se abre el archivo de salida
	addl $8, %esp
	
while2:

	pushl salida
	call fgetc					#Se van obteniendo los caracteres del archivo de entrada
	addl $4, %esp
	
	movl %eax, caracter		
	cmpl $0, caracter			#Si el caracter es menor que 0, se llego al final del archivo
	jl endwhile2
	
	movl caracter, %eax
	addl %eax, sumDes
	
	jmp while2

endwhile2:

	pushl salida
	call fclose   				#Se cierra el archivo de salida
	addl $4, %esp
	
	movl sumOri, %eax
	cmpl %eax, sumDes			#Se comparan las sumas de los archivos para ver si existe un error
	je SinError
	
	pushl $sucess
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	
exit:
	movl $0, sumDes
	movl $0, sumOri
	ret   							#Salida
	
error1: 							#Rutina de tratamiento de error

	pushl $error
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	jmp exit

error2: 							#Rutina de tratamiento de error
	
	pushl $errorC
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	jmp exit

SinError:

	pushl $sucess2
	call printf
	addl $4, %esp
	
	pushl $opcion
	pushl $form
	call scanf
	addl $8,%esp
	jmp exit

