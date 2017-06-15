.section .data

	menu: .asciz "\nDESARROLLADORES\n\nAbelardo Moreno  CI: 18.002.106	Seccion C1\n\nLuiyit Hernandez CI: 18.269.237	Seccion C1\n\nIntroduzca cualquier tecla para continuar\n"
	form:   .asciz "%s"
	
.section .bss

	opcion:	.space 4

.section .text

	.globl Desarrolladores

Desarrolladores:

	pushl $menu
	call printf				
	addl $4,%esp

	pushl $opcion
	pushl $form			
	call scanf
	addl $8,%esp

	ret

