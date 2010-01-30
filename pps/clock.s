	.file	"clock.c"
	.text
	.p2align 4,,15
.globl processor_cycles
	.type	processor_cycles, @function
processor_cycles:
#APP
# 77 "../clock.c" 1
	rdtsc
# 0 "" 2
#NO_APP
	ret
	.size	processor_cycles, .-processor_cycles
	.p2align 4,,15
.globl processor_usec
	.type	processor_usec, @function
processor_usec:
	pushl	%ebx
	subl	$88, %esp
	leal	16(%esp), %eax
	movl	$0, (%esp)
	movl	%eax, 4(%esp)
	call	getrusage
	movl	24(%esp), %eax
	movl	28(%esp), %ecx
	addl	16(%esp), %eax
	addl	20(%esp), %ecx
	movl	$1000000, %edx
	movl	%ecx, %ebx
	imull	%edx
	sarl	$31, %ebx
	addl	%ecx, %eax
	adcl	%ebx, %edx
	addl	$88, %esp
	popl	%ebx
	ret
	.size	processor_usec, .-processor_usec
	.p2align 4,,15
.globl elapsed_usec
	.type	elapsed_usec, @function
elapsed_usec:
	pushl	%ebx
	subl	$24, %esp
	leal	16(%esp), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	gettimeofday
	movl	20(%esp), %ecx
	movl	$1000000, %eax
	movl	%ecx, %ebx
	imull	16(%esp)
	sarl	$31, %ebx
	addl	%ecx, %eax
	adcl	%ebx, %edx
	addl	$24, %esp
	popl	%ebx
	ret
	.size	elapsed_usec, .-elapsed_usec
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
