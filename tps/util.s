	.file	"util.c"
.globl __udivdi3
	.text
	.p2align 4,,15
.globl parse_uint64
	.type	parse_uint64, @function
parse_uint64:
	subl	$76, %esp
	movl	88(%esp), %eax
	movl	92(%esp), %edx
	movl	%ebx, 60(%esp)
	movl	%esi, 64(%esp)
	movl	%edi, 68(%esp)
	movl	%ebp, 72(%esp)
	movl	%eax, 28(%esp)
	movl	%edx, 24(%esp)
	movl	96(%esp), %eax
	movl	100(%esp), %edx
	movl	%eax, 32(%esp)
	movl	%edx, 36(%esp)
	leal	52(%esp), %ebp
	call	__errno_location
	movl	$0, (%eax)
	movl	%eax, %ebx
	movl	$0, 8(%esp)
	movl	84(%esp), %eax
	movl	%ebp, 4(%esp)
	movl	%eax, (%esp)
	call	strtoull
	movl	%eax, %esi
	movl	%edx, %edi
	movl	(%ebx), %eax
	testl	%eax, %eax
	jne	.L2
	cmpl	36(%esp), %edx
	jbe	.L59
.L2:
	movl	$-2, %eax
.L41:
	movl	60(%esp), %ebx
	movl	64(%esp), %esi
	movl	68(%esp), %edi
	movl	72(%esp), %ebp
	addl	$76, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L59:
	jb	.L43
	cmpl	32(%esp), %esi
	ja	.L2
.L43:
	movl	52(%esp), %edx
	cmpb	$116, (%edx)
	.p2align 4,,3
	.p2align 3
	jbe	.L60
.L4:
	movl	$-1, %eax
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L60:
	movzbl	(%edx), %eax
	.p2align 4,,2
	.p2align 3
	jmp	*.L18(,%eax,4)
	.section	.rodata
	.align 4
	.align 4
.L18:
	.long	.L5
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L6
	.long	.L4
	.long	.L4
	.long	.L7
	.long	.L4
	.long	.L8
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L9
	.long	.L4
	.long	.L10
	.long	.L4
	.long	.L4
	.long	.L11
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L12
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L6
	.long	.L4
	.long	.L4
	.long	.L7
	.long	.L4
	.long	.L13
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L14
	.long	.L4
	.long	.L15
	.long	.L4
	.long	.L4
	.long	.L16
	.long	.L4
	.long	.L4
	.long	.L4
	.long	.L17
	.text
.L17:
	movl	$10, %eax
.L26:
	addl	$10, %eax
.L21:
	addl	$10, %eax
.L20:
	leal	10(%eax), %ecx
.L19:
	cmpb	$0, 1(%edx)
	jne	.L4
	movl	36(%esp), %edx
	xorl	%ebx, %ebx
	movl	32(%esp), %eax
	shrdl	%edx, %eax
	shrl	%cl, %edx
	testb	$32, %cl
	cmovne	%edx, %eax
	cmovne	%ebx, %edx
	cmpl	%edx, %edi
	ja	.L2
	jb	.L45
	cmpl	%eax, %esi
	ja	.L2
.L45:
	shldl	%esi, %edi
	xorl	%eax, %eax
	sall	%cl, %esi
	testb	$32, %cl
	cmovne	%esi, %edi
	cmovne	%eax, %esi
.L5:
	cmpl	24(%esp), %edi
	jb	.L2
	ja	.L47
	cmpl	28(%esp), %esi
	jb	.L2
.L47:
	movl	80(%esp), %edx
	xorl	%eax, %eax
	movl	%esi, (%edx)
	movl	%edi, 4(%edx)
	jmp	.L41
.L16:
	movl	$20, %eax
	jmp	.L26
.L15:
	movl	$10, %eax
	jmp	.L20
.L14:
	movl	$10, %ecx
	.p2align 4,,5
	.p2align 3
	jmp	.L19
.L13:
	movl	$10, %eax
	.p2align 4,,5
	.p2align 3
	jmp	.L21
.L12:
	movl	$3, %eax
.L25:
	addl	$3, %eax
.L24:
	addl	$3, %eax
.L23:
	leal	3(%eax), %ebx
.L22:
	cmpb	$0, 1(%edx)
	jne	.L4
	testl	%ebx, %ebx
	je	.L5
	movl	32(%esp), %eax
	movl	36(%esp), %edx
	movl	$1000, 8(%esp)
	movl	$0, 12(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__udivdi3
	movl	%eax, %ebp
	movl	%edx, 16(%esp)
	cmpl	%edx, %edi
	ja	.L2
	jb	.L51
	cmpl	%eax, %esi
	.p2align 4,,2
	.p2align 3
	ja	.L2
.L51:
	movl	$1000, %ecx
	.p2align 4,,10
	.p2align 3
.L55:
	imull	$1000, %edi, %edx
	movl	%esi, %eax
	movl	%edx, 20(%esp)
	mull	%ecx
	movl	%edx, %edi
	movl	%eax, %esi
	addl	20(%esp), %edi
	subl	$3, %ebx
	je	.L5
	cmpl	16(%esp), %edi
	ja	.L2
	jb	.L55
	cmpl	%ebp, %esi
	.p2align 4,,6
	.p2align 3
	ja	.L2
	.p2align 4,,9
	.p2align 3
	jmp	.L55
.L11:
	movl	$6, %eax
	.p2align 4,,7
	.p2align 3
	jmp	.L25
.L10:
	movl	$3, %eax
	.p2align 4,,7
	.p2align 3
	jmp	.L23
.L9:
	movl	$3, %ebx
	.p2align 4,,5
	.p2align 3
	jmp	.L22
.L8:
	movl	$3, %eax
	.p2align 4,,5
	.p2align 3
	jmp	.L24
.L7:
	movl	%ebp, 4(%esp)
	leal	1(%edx), %eax
	movl	$0, 8(%esp)
	movl	%eax, (%esp)
	call	strtoul
	movl	%eax, %ebp
	movl	(%ebx), %eax
	testl	%eax, %eax
	jne	.L2
	movl	52(%esp), %eax
	cmpb	$0, (%eax)
	jne	.L4
	testl	%ebp, %ebp
	je	.L5
	movl	32(%esp), %eax
	movl	36(%esp), %edx
	movl	$10, 8(%esp)
	movl	$0, 12(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__udivdi3
	movl	%eax, %ebx
	movl	%edx, 16(%esp)
	cmpl	%edx, %edi
	ja	.L2
	jb	.L44
	cmpl	%eax, %esi
	.p2align 4,,2
	.p2align 3
	ja	.L2
.L44:
	leal	-1(%ebp), %ecx
	movl	$10, %ebp
.L56:
	imull	$10, %edi, %edx
	movl	%esi, %eax
	movl	%edx, 20(%esp)
	mull	%ebp
	movl	%edx, %edi
	movl	%eax, %esi
	addl	20(%esp), %edi
	testl	%ecx, %ecx
	je	.L5
	decl	%ecx
	cmpl	16(%esp), %edi
	ja	.L2
	jb	.L56
	cmpl	%ebx, %esi
	.p2align 4,,5
	.p2align 3
	ja	.L2
	.p2align 4,,9
	.p2align 3
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L6:
	movl	%ebp, 4(%esp)
	leal	1(%edx), %eax
	movl	$0, 8(%esp)
	movl	%eax, (%esp)
	call	strtoul
	movl	%eax, %ebp
	movl	(%ebx), %eax
	testl	%eax, %eax
	jne	.L2
	movl	52(%esp), %eax
	cmpb	$0, (%eax)
	jne	.L4
	testl	%ebp, %ebp
	je	.L5
	movl	36(%esp), %ecx
	movl	32(%esp), %edx
	shrdl	$1, %ecx, %edx
	shrl	%ecx
	cmpl	%ecx, %edi
	ja	.L2
	jb	.L46
	cmpl	%edx, %esi
	ja	.L2
.L46:
	leal	-1(%ebp), %eax
.L57:
	shldl	$1, %esi, %edi
	addl	%esi, %esi
	testl	%eax, %eax
	je	.L5
	decl	%eax
	cmpl	%edi, %ecx
	jb	.L2
	ja	.L57
	cmpl	%esi, %edx
	.p2align 4,,6
	.p2align 3
	jb	.L2
	.p2align 4,,9
	.p2align 3
	jmp	.L57
	.size	parse_uint64, .-parse_uint64
	.p2align 4,,15
.globl parse_uint
	.type	parse_uint, @function
parse_uint:
	subl	$44, %esp
	movl	60(%esp), %eax
	movl	$0, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	56(%esp), %eax
	movl	%eax, 8(%esp)
	movl	52(%esp), %eax
	movl	%eax, 4(%esp)
	leal	32(%esp), %eax
	movl	%eax, (%esp)
	call	parse_uint64
	movl	%eax, %edx
	testl	%eax, %eax
	jne	.L62
	movl	32(%esp), %eax
	movl	48(%esp), %ecx
	movl	%eax, (%ecx)
.L62:
	movl	%edx, %eax
	addl	$44, %esp
	ret
	.size	parse_uint, .-parse_uint
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"realloc"
	.text
	.p2align 4,,15
.globl xrealloc
	.type	xrealloc, @function
xrealloc:
	subl	$12, %esp
	movl	20(%esp), %eax
	movl	%eax, 4(%esp)
	movl	16(%esp), %eax
	movl	%eax, (%esp)
	call	realloc
	testl	%eax, %eax
	je	.L67
	addl	$12, %esp
	ret
.L67:
	movl	$.LC0, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
	.size	xrealloc, .-xrealloc
	.section	.rodata.str1.1
.LC1:
	.string	"malloc"
	.text
	.p2align 4,,15
.globl xmalloc
	.type	xmalloc, @function
xmalloc:
	subl	$12, %esp
	movl	16(%esp), %eax
	movl	%eax, (%esp)
	call	malloc
	testl	%eax, %eax
	je	.L71
	addl	$12, %esp
	ret
.L71:
	movl	$.LC1, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
	.size	xmalloc, .-xmalloc
	.p2align 4,,15
.globl xstrdup
	.type	xstrdup, @function
xstrdup:
	pushl	%ebx
	xorl	%eax, %eax
	subl	$8, %esp
	movl	16(%esp), %ebx
	testl	%ebx, %ebx
	je	.L74
	movl	%ebx, (%esp)
	call	strlen
	incl	%eax
	movl	%eax, (%esp)
	call	malloc
	testl	%eax, %eax
	je	.L77
	movl	%ebx, 4(%esp)
	movl	%eax, (%esp)
	call	strcpy
.L74:
	addl	$8, %esp
	popl	%ebx
	ret
.L77:
	movl	$.LC1, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
	.size	xstrdup, .-xstrdup
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
