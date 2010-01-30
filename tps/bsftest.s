	.file	"bsftest.c"
.globl __ctzdi2
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Result is %llu\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	xorl	%esi, %esi
	pushl	%ebx
	xorl	%ebx, %ebx
	pushl	%ecx
	subl	$28, %esp
	.p2align 4,,10
	.p2align 3
.L8:
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	call	__ctzdi2
	movl	%eax, %edx
	sarl	$31, %edx
	addl	$1, %eax
	adcl	$0, %edx
	addl	%eax, %ebx
	adcl	%edx, %esi
	cmpl	$232, %esi
	jb	.L8
	jbe	.L10
.L5:
	movl	%ebx, 8(%esp)
	movl	%esi, 12(%esp)
	movl	$.LC0, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$28, %esp
	xorl	%eax, %eax
	popl	%ecx
	popl	%ebx
	popl	%esi
	leave
	leal	-4(%ecx), %esp
	ret
	.p2align 4,,10
	.p2align 3
.L10:
	cmpl	$-726379969, %ebx
	jbe	.L8
	jmp	.L5
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
