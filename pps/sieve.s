	.file	"sieve.c"
.globl __umoddi3
	.text
	.p2align 4,,15
	.type	init_residues, @function
init_residues:
	pushl	%ebp
	movl	%eax, %edx
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$60, %esp
	movl	%eax, 16(%esp)
	movl	4(%edx), %edx
	movl	(%eax), %eax
	movl	%edx, 44(%esp)
	movl	%eax, 40(%esp)
	movl	16(%esp), %eax
	movl	20(%eax), %eax
	movl	%eax, 48(%esp)
	testl	%eax, %eax
	je	.L12
	movl	sieve_primes, %edx
	xorl	%edi, %edi
	movl	%edx, 20(%esp)
	.p2align 4,,10
	.p2align 3
.L11:
	movl	20(%esp), %eax
	movl	$0, 28(%esp)
	movl	(%eax,%edi,4), %ebp
	movl	28(%esp), %edx
	movl	%ebp, 24(%esp)
	movl	%edx, 12(%esp)
	movl	24(%esp), %eax
	movl	44(%esp), %edx
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	40(%esp), %eax
	movl	%ebp, %ebx
	movl	%eax, (%esp)
	call	__umoddi3
	subl	%eax, %ebx
	movl	%eax, %esi
	testl	%eax, %eax
	leal	(%ebx,%ebp), %ecx
	setne	%dl
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 36(%esp)
	setne	%al
	andb	%dl, %al
	cmove	%ebx, %ecx
	movb	%al, 55(%esp)
	shrl	%ecx
	movl	36(%esp), %eax
	movl	$0, %ebx
	testl	%eax, %eax
	sete	%al
	andl	%eax, %edx
	orb	55(%esp), %dl
	cmovne	%ecx, %ebx
	testl	%esi, %esi
	sete	%cl
	orl	%edx, %ecx
	movl	$1, %edx
	cmpl	$0, 44(%esp)
	ja	.L8
	movl	24(%esp), %eax
	cmpl	%eax, 40(%esp)
	ja	.L8
.L7:
	testb	%dl, %cl
	leal	(%ebx,%ebp), %eax
	movl	16(%esp), %edx
	cmove	%ebx, %eax
	movl	%eax, 24(%edx,%edi,4)
	incl	%edi
	cmpl	%edi, 48(%esp)
	ja	.L11
.L12:
	addl	$60, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L8:
	xorl	%edx, %edx
	jmp	.L7
	.size	init_residues, .-init_residues
	.p2align 4,,15
	.type	sieve, @function
sieve:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$188, %esp
	movl	%eax, 56(%esp)
	movl	%edx, 52(%esp)
	movl	%ecx, 48(%esp)
	movl	208(%esp), %eax
	movl	56(%esp), %ecx
	sall	$5, %eax
	movl	(%ecx), %edx
	movl	%eax, 88(%esp)
	movl	4(%ecx), %ecx
	movl	%edx, 64(%esp)
	movl	%ecx, 68(%esp)
	movl	56(%esp), %edx
	movl	8(%edx), %eax
	movl	12(%edx), %edx
	movl	%eax, %ecx
	movl	%edx, %ebx
	subl	64(%esp), %ecx
	movl	%eax, 72(%esp)
	sbbl	68(%esp), %ebx
	movl	88(%esp), %eax
	movl	%edx, 76(%esp)
	xorl	%edx, %edx
	shldl	$1, %eax, %edx
	addl	%eax, %eax
	cmpl	%edx, %ebx
	jb	.L16
	jbe	.L98
.L89:
	movl	64(%esp), %ecx
	movl	68(%esp), %ebx
	addl	%eax, %ecx
	adcl	%edx, %ebx
	movl	%ecx, 72(%esp)
	movl	%ebx, 76(%esp)
	movl	%ecx, %eax
	movl	%ebx, %edx
.L18:
	movl	56(%esp), %ecx
	movl	36(%ecx), %ebx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	40(%ecx), %eax
	movl	24(%ecx), %edx
	movl	28(%ecx), %esi
	cmpl	$2, %edx
	movl	32(%ecx), %edi
	movl	%ebx, 180(%esp)
	movl	%eax, 44(%esp)
	movl	44(%ecx), %ebx
	movl	48(%ecx), %ebp
	movl	56(%esp), %eax
	movl	52(%ecx), %ecx
	movl	56(%eax), %eax
	movl	%ecx, 100(%esp)
	movl	%eax, 104(%esp)
	movl	56(%esp), %ecx
	leal	-3(%edx), %eax
	movl	60(%ecx), %ecx
	cmovle	%edx, %eax
	movl	%ecx, 108(%esp)
	movl	%eax, 40(%esp)
	subl	$2, %eax
	movl	%eax, 120(%esp)
	js	.L99
.L21:
	cmpl	$4, %esi
	leal	-5(%esi), %eax
	cmovle	%esi, %eax
	movl	%eax, 40(%esp)
	subl	$2, %eax
	movl	%eax, 128(%esp)
	js	.L100
.L24:
	cmpl	$6, %edi
	leal	-7(%edi), %eax
	cmovle	%edi, %eax
	movl	%eax, 40(%esp)
	subl	$4, %eax
	movl	%eax, 136(%esp)
	js	.L101
.L27:
	movl	180(%esp), %eax
	subl	$11, %eax
	cmpl	$10, 180(%esp)
	cmovle	180(%esp), %eax
	movl	%eax, 40(%esp)
	subl	$10, %eax
	movl	%eax, 144(%esp)
	js	.L102
.L30:
	movl	%edx, %ecx
	movl	$1227133513, %eax
	movl	$1108378657, %edx
	sall	%cl, %eax
	movl	%esi, %ecx
	sall	%cl, %edx
	movl	%edi, %ecx
	orl	%eax, %edx
	movl	$270549121, %eax
	sall	%cl, %eax
	movzbl	180(%esp), %ecx
	orl	%eax, %edx
	movl	$4196353, %eax
	sall	%cl, %eax
	movzbl	44(%esp), %ecx
	orl	%eax, %edx
	movl	$67117057, %eax
	sall	%cl, %eax
	orl	%eax, %edx
	movl	44(%esp), %eax
	subl	$13, %eax
	cmpl	$13, 44(%esp)
	cmovl	44(%esp), %eax
	movl	%eax, 44(%esp)
	subl	$6, %eax
	movl	%eax, 152(%esp)
	js	.L103
.L32:
	cmpl	$16, %ebx
	jle	.L33
	subl	$17, %ebx
	movl	$131072, %eax
	movl	%ebx, %ecx
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%ebx, %edx
	subl	$15, %edx
	movl	%edx, 160(%esp)
	js	.L104
.L35:
	cmpl	$18, %ebp
	jle	.L36
	subl	$19, %ebp
	movl	$524288, %edx
	movl	%ebp, %ecx
	movl	%ebp, %ebx
	sall	%cl, %edx
	orl	%eax, %edx
	subl	$13, %ebx
	movl	%ebx, 168(%esp)
	js	.L105
.L38:
	cmpl	$22, 100(%esp)
	jle	.L39
	subl	$23, 100(%esp)
	movl	$8388608, %eax
	movzbl	100(%esp), %ecx
	movl	100(%esp), %esi
	sall	%cl, %eax
	orl	%edx, %eax
	subl	$9, %esi
	js	.L106
.L41:
	cmpl	$28, 104(%esp)
	jle	.L42
	subl	$29, 104(%esp)
	movl	$536870912, %edx
	movzbl	104(%esp), %ecx
	movl	104(%esp), %ebx
	sall	%cl, %edx
	orl	%eax, %edx
	subl	$3, %ebx
	js	.L107
.L44:
	cmpl	$30, 108(%esp)
	jle	.L45
	subl	$31, 108(%esp)
	movl	$-2147483648, %eax
	movzbl	108(%esp), %ecx
	sall	%cl, %eax
	orl	%edx, %eax
	movl	108(%esp), %edx
	decl	%edx
	movl	%edx, 44(%esp)
	js	.L108
.L47:
	notl	%eax
	movl	48(%esp), %edx
	cmpl	$1, 208(%esp)
	movl	%eax, (%edx)
	jbe	.L48
	movl	$1, 84(%esp)
	movl	44(%esp), %edi
	jmp	.L70
	.p2align 4,,10
	.p2align 3
.L109:
	movl	124(%esp), %edx
	movl	132(%esp), %ecx
	movl	140(%esp), %ebx
	movl	%edx, 120(%esp)
	movl	%ecx, 128(%esp)
	movl	%ebx, 136(%esp)
	movl	148(%esp), %eax
	movl	172(%esp), %ebx
	movl	156(%esp), %edx
	movl	164(%esp), %ecx
	movl	%ebx, 168(%esp)
	movl	%eax, 144(%esp)
	movl	%edx, 152(%esp)
	movl	%ecx, 160(%esp)
	movl	176(%esp), %esi
	movl	%ebp, %ebx
	movl	%edi, 44(%esp)
.L70:
	movl	120(%esp), %ecx
	movl	120(%esp), %eax
	incl	%ecx
	movl	136(%esp), %edx
	subl	$2, %eax
	leal	26(%ebx), %ebp
	cmovs	%ecx, %eax
	movl	144(%esp), %ecx
	movl	%eax, 124(%esp)
	movl	128(%esp), %eax
	addl	$3, %eax
	movl	%eax, 132(%esp)
	movl	128(%esp), %eax
	subl	$2, %eax
	cmovs	132(%esp), %eax
	addl	$3, %edx
	movl	%eax, 132(%esp)
	movl	136(%esp), %eax
	subl	$4, %eax
	cmovs	%edx, %eax
	incl	%ecx
	movl	%eax, 140(%esp)
	movl	160(%esp), %edx
	movl	144(%esp), %eax
	subl	$10, %eax
	cmovs	%ecx, %eax
	movl	168(%esp), %ecx
	movl	%eax, 148(%esp)
	movl	152(%esp), %eax
	addl	$7, %eax
	movl	%eax, 156(%esp)
	movl	152(%esp), %eax
	subl	$6, %eax
	cmovs	156(%esp), %eax
	addl	$2, %edx
	movl	%eax, 156(%esp)
	movl	160(%esp), %eax
	subl	$15, %eax
	cmovs	%edx, %eax
	addl	$6, %ecx
	movl	%eax, 164(%esp)
	movl	$1108378657, %edx
	movl	168(%esp), %eax
	subl	$13, %eax
	cmovs	%ecx, %eax
	movzbl	120(%esp), %ecx
	movl	%eax, 172(%esp)
	leal	14(%esi), %eax
	movl	%eax, 176(%esp)
	movl	%esi, %eax
	subl	$9, %eax
	cmovs	176(%esp), %eax
	movl	%eax, 176(%esp)
	movl	%ebx, %eax
	subl	$3, %eax
	cmovns	%eax, %ebp
	addl	$30, %edi
	movl	44(%esp), %eax
	decl	%eax
	cmovns	%eax, %edi
	movl	$1227133513, %eax
	sall	%cl, %eax
	movzbl	128(%esp), %ecx
	sall	%cl, %edx
	movzbl	136(%esp), %ecx
	orl	%eax, %edx
	movl	$270549121, %eax
	sall	%cl, %eax
	movzbl	144(%esp), %ecx
	orl	%eax, %edx
	movl	$4196353, %eax
	sall	%cl, %eax
	movzbl	152(%esp), %ecx
	orl	%eax, %edx
	movl	$67117057, %eax
	sall	%cl, %eax
	movzbl	160(%esp), %ecx
	orl	%eax, %edx
	movl	$131073, %eax
	sall	%cl, %eax
	movzbl	168(%esp), %ecx
	orl	%eax, %edx
	movl	$524289, %eax
	sall	%cl, %eax
	movl	%esi, %ecx
	orl	%eax, %edx
	movl	$8388609, %eax
	sall	%cl, %eax
	movl	%ebx, %ecx
	orl	%eax, %edx
	movl	84(%esp), %ebx
	movl	$536870913, %eax
	sall	%cl, %eax
	movzbl	44(%esp), %ecx
	orl	%eax, %edx
	movl	$-2147483647, %eax
	sall	%cl, %eax
	orl	%eax, %edx
	movl	48(%esp), %eax
	notl	%edx
	movl	%edx, (%eax,%ebx,4)
	incl	%ebx
	movl	%ebx, 84(%esp)
	cmpl	%ebx, 208(%esp)
	ja	.L109
	movl	124(%esp), %eax
	movl	132(%esp), %edx
	movl	140(%esp), %ecx
	movl	148(%esp), %ebx
	movl	%eax, 120(%esp)
	movl	%edx, 128(%esp)
	movl	%ecx, 136(%esp)
	movl	%ebx, 144(%esp)
	movl	156(%esp), %eax
	movl	164(%esp), %edx
	movl	172(%esp), %ecx
	movl	%eax, 152(%esp)
	movl	%edx, 160(%esp)
	movl	%ecx, 168(%esp)
	movl	176(%esp), %esi
	movl	%ebp, %ebx
	movl	%edi, 44(%esp)
.L48:
	movl	56(%esp), %eax
	movl	120(%esp), %edx
	movl	128(%esp), %ecx
	movl	%edx, 24(%eax)
	movl	%ecx, 28(%eax)
	movl	136(%esp), %edx
	movl	144(%esp), %ecx
	movl	%edx, 32(%eax)
	movl	%ecx, 36(%eax)
	movl	152(%esp), %edx
	movl	160(%esp), %ecx
	movl	%edx, 40(%eax)
	movl	%ecx, 44(%eax)
	movl	168(%esp), %edx
	movl	%ebx, 56(%eax)
	movl	44(%esp), %ecx
	movl	20(%eax), %ebx
	movl	%edx, 48(%eax)
	movl	%esi, 52(%eax)
	movl	%ecx, 60(%eax)
	movl	%ebx, 92(%esp)
	cmpl	$10, %ebx
	jbe	.L71
	movl	sieve_primes, %eax
	movl	$10, %ebp
	movl	%eax, 60(%esp)
	movl	56(%esp), %ebx
	.p2align 4,,10
	.p2align 3
.L74:
	movl	60(%esp), %edx
	movl	24(%ebx,%ebp,4), %ecx
	movl	(%edx,%ebp,4), %edi
	cmpl	%ecx, 88(%esp)
	jbe	.L72
	leal	(%ecx,%edi), %esi
	movl	%esi, %ebx
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L110:
	addl	%edi, %esi
.L73:
	movl	%ecx, %eax
	addl	%edi, %ebx
	shrl	$5, %eax
	andl	$31, %ecx
	movl	$1, %edx
	sall	%cl, %edx
	movl	48(%esp), %ecx
	notl	%edx
	andl	%edx, (%ecx,%eax,4)
	movl	%ebx, %eax
	movl	%esi, %ecx
	subl	%edi, %eax
	cmpl	%eax, 88(%esp)
	ja	.L110
.L72:
	subl	88(%esp), %ecx
	movl	56(%esp), %ebx
	movl	%ecx, 24(%ebx,%ebp,4)
	incl	%ebp
	cmpl	%ebp, 92(%esp)
	ja	.L74
.L71:
	movl	56(%esp), %eax
	movl	16(%eax), %eax
	movl	%eax, 96(%esp)
	cmpl	%eax, 92(%esp)
	jae	.L75
	movl	92(%esp), %edx
	movl	sieve_primes, %ecx
	xorl	%esi, %esi
	movl	(%ecx,%edx,4), %edi
	movl	%edi, %eax
	movl	%edi, %ebx
	mull	%edi
	movl	%eax, 32(%esp)
	movl	%edx, 36(%esp)
	cmpl	%edx, 76(%esp)
	jb	.L75
	ja	.L90
	cmpl	%eax, 72(%esp)
	jbe	.L75
.L90:
	movl	92(%esp), %edx
	leal	4(%ecx,%edx,4), %ecx
	movl	%edx, %ebp
	movl	%ecx, 112(%esp)
	movl	56(%esp), %ecx
	leal	24(%ecx,%edx,4), %ecx
	movl	%ecx, 116(%esp)
	.p2align 4,,10
	.p2align 3
.L97:
	movl	68(%esp), %ecx
	movl	64(%esp), %edx
	movl	%ecx, 4(%esp)
	movl	%ebx, 8(%esp)
	movl	%esi, 12(%esp)
	movl	%edx, (%esp)
	call	__umoddi3
	movl	%eax, %ecx
	testl	%eax, %eax
	je	.L80
	movl	%edi, %eax
	subl	%ecx, %eax
	testb	$1, %al
	leal	(%eax,%edi), %edx
	movl	%eax, %ecx
	cmovne	%edx, %ecx
	shrl	%ecx
.L80:
	cmpl	%esi, 68(%esp)
	ja	.L82
	jb	.L91
	cmpl	%ebx, 64(%esp)
	jbe	.L91
	.p2align 4,,10
	.p2align 3
.L82:
	cmpl	%ecx, 88(%esp)
	.p2align 4,,5
	.p2align 3
	jbe	.L84
	leal	(%ecx,%edi), %esi
	movl	%esi, %ebx
	jmp	.L85
	.p2align 4,,10
	.p2align 3
.L111:
	addl	%edi, %esi
.L85:
	movl	%ecx, %eax
	addl	%edi, %ebx
	shrl	$5, %eax
	andl	$31, %ecx
	movl	$1, %edx
	sall	%cl, %edx
	movl	48(%esp), %ecx
	notl	%edx
	andl	%edx, (%ecx,%eax,4)
	movl	%ebx, %eax
	movl	%esi, %ecx
	subl	%edi, %eax
	cmpl	%eax, 88(%esp)
	ja	.L111
.L84:
	subl	88(%esp), %ecx
	movl	116(%esp), %ebx
	incl	%ebp
	movl	%ecx, (%ebx)
	cmpl	%ebp, 96(%esp)
	jbe	.L78
	movl	112(%esp), %ebx
	xorl	%esi, %esi
	movl	(%ebx), %edi
	addl	$4, 112(%esp)
	addl	$4, 116(%esp)
	movl	%edi, %eax
	movl	%edi, %ebx
	mull	%edi
	movl	%eax, 24(%esp)
	movl	%edx, 28(%esp)
	cmpl	%edx, 76(%esp)
	jae	.L112
.L78:
	movl	64(%esp), %edx
	movl	52(%esp), %ebx
	movl	56(%esp), %eax
	movl	68(%esp), %ecx
	movl	%ebp, 20(%eax)
	movl	%edx, (%ebx)
	movl	%ecx, 4(%ebx)
	movl	208(%esp), %edx
	testl	%edx, %edx
	je	.L87
	movl	88(%esp), %ecx
	andl	$31, %ecx
	je	.L87
	movl	$1, %eax
	movl	208(%esp), %edx
	sall	%cl, %eax
	movl	48(%esp), %ecx
	decl	%eax
	andl	%eax, -4(%ecx,%edx,4)
.L87:
	movl	208(%esp), %eax
	addl	$188, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L45:
	movl	$-2147483647, %eax
	movzbl	108(%esp), %ecx
	sall	%cl, %eax
	orl	%edx, %eax
	movl	108(%esp), %edx
	decl	%edx
	movl	%edx, 44(%esp)
	jns	.L47
.L108:
	movl	108(%esp), %ecx
	addl	$30, %ecx
	movl	%ecx, 44(%esp)
	jmp	.L47
.L42:
	movl	$536870913, %edx
	movzbl	104(%esp), %ecx
	movl	104(%esp), %ebx
	sall	%cl, %edx
	orl	%eax, %edx
	subl	$3, %ebx
	jns	.L44
.L107:
	movl	104(%esp), %ebx
	addl	$26, %ebx
	jmp	.L44
.L39:
	movl	$8388609, %eax
	movzbl	100(%esp), %ecx
	movl	100(%esp), %esi
	sall	%cl, %eax
	orl	%edx, %eax
	subl	$9, %esi
	jns	.L41
.L106:
	movl	100(%esp), %esi
	addl	$14, %esi
	jmp	.L41
.L36:
	movl	$524289, %edx
	movl	%ebp, %ecx
	movl	%ebp, %ebx
	sall	%cl, %edx
	orl	%eax, %edx
	subl	$13, %ebx
	movl	%ebx, 168(%esp)
	jns	.L38
.L105:
	addl	$6, %ebp
	movl	%ebp, 168(%esp)
	jmp	.L38
.L33:
	movl	$131073, %eax
	movl	%ebx, %ecx
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%ebx, %edx
	subl	$15, %edx
	movl	%edx, 160(%esp)
	jns	.L35
.L104:
	addl	$2, %ebx
	movl	%ebx, 160(%esp)
	jmp	.L35
.L98:
	cmpl	%eax, %ecx
	jae	.L89
.L16:
	shrdl	$1, %ebx, %ecx
	movl	72(%esp), %eax
	movl	%ecx, %ebx
	movl	%ecx, 88(%esp)
	addl	$31, %ebx
	movl	76(%esp), %edx
	shrl	$5, %ebx
	movl	%ebx, 208(%esp)
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L91:
	addl	%edi, %ecx
	jmp	.L82
	.p2align 4,,10
	.p2align 3
.L112:
	ja	.L97
	cmpl	%eax, 72(%esp)
	.p2align 4,,6
	.p2align 3
	jbe	.L78
	.p2align 4,,8
	.p2align 3
	jmp	.L97
.L101:
	movl	40(%esp), %eax
	addl	$3, %eax
	movl	%eax, 136(%esp)
	jmp	.L27
.L100:
	movl	40(%esp), %ecx
	addl	$3, %ecx
	movl	%ecx, 128(%esp)
	jmp	.L24
.L99:
	movl	40(%esp), %eax
	incl	%eax
	movl	%eax, 120(%esp)
	jmp	.L21
.L103:
	movl	44(%esp), %eax
	addl	$7, %eax
	movl	%eax, 152(%esp)
	jmp	.L32
.L102:
	movl	40(%esp), %ecx
	incl	%ecx
	movl	%ecx, 144(%esp)
	jmp	.L30
.L75:
	movl	92(%esp), %ebp
	jmp	.L78
	.size	sieve, .-sieve
	.p2align 4,,15
.globl free_chunk
	.type	free_chunk, @function
free_chunk:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	64(%esp), %eax
	movl	68(%esp), %edx
	movl	72(%esp), %ecx
	movl	%eax, 28(%esp)
	movl	%edx, 24(%esp)
	movl	%ecx, 20(%esp)
	movl	%eax, (%esp)
	call	pthread_mutex_lock
	movl	28(%esp), %eax
	movl	128(%eax), %eax
	movl	%eax, 32(%esp)
	testl	%eax, %eax
	je	.L114
	movl	28(%esp), %edx
	movl	28(%esp), %esi
	movl	124(%edx), %edx
	xorl	%edi, %edi
	movl	%edx, 36(%esp)
	.p2align 4,,10
	.p2align 3
.L118:
	movl	132(%esi), %ebp
	cmpl	%ebp, 36(%esp)
	jbe	.L115
	movl	144(%esi), %edx
	movl	140(%esi), %eax
	movl	20(%esp), %ecx
	movl	%eax, 8(%esp)
	movl	%edx, 12(%esp)
	cmpl	%ecx, %edx
	ja	.L115
	jb	.L120
	movl	24(%esp), %edx
	cmpl	%edx, %eax
	ja	.L115
.L120:
	xorl	%edx, %edx
	movl	28(%esp), %ecx
	movl	120(%ecx), %eax
	shldl	$1, %eax, %edx
	addl	%eax, %eax
	addl	8(%esp), %eax
	adcl	12(%esp), %edx
	cmpl	%edx, 20(%esp)
	ja	.L115
	jae	.L123
.L121:
	leal	1(%ebp), %edx
	movl	28(%esp), %ecx
	leal	(%edi,%edi,4), %eax
	movl	%edx, 132(%ecx,%eax,4)
	cmpl	124(%ecx), %edx
	je	.L124
	.p2align 4,,10
	.p2align 3
.L114:
	movl	28(%esp), %eax
	movl	%eax, 64(%esp)
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	jmp	pthread_mutex_unlock
	.p2align 4,,10
	.p2align 3
.L123:
	cmpl	%eax, 24(%esp)
	jb	.L121
	.p2align 4,,10
	.p2align 3
.L115:
	incl	%edi
	addl	$20, %esi
	cmpl	%edi, 32(%esp)
	ja	.L118
	.p2align 4,,2
	.p2align 3
	jmp	.L114
.L124:
	movzbl	104(%ecx), %edx
	leal	1(%edx), %eax
	testb	%dl, %dl
	movb	%al, 104(%ecx)
	jne	.L114
	movl	%ecx, %eax
	addl	$48, %eax
	movl	%eax, (%esp)
	call	pthread_cond_broadcast
	jmp	.L114
	.size	free_chunk, .-free_chunk
	.p2align 4,,15
.globl next_chunk
	.type	next_chunk, @function
next_chunk:
	subl	$28, %esp
	movl	%ebx, 16(%esp)
	movl	%esi, 20(%esp)
	movl	32(%esp), %ebx
	movl	%edi, 24(%esp)
	movl	%ebx, (%esp)
	call	pthread_mutex_lock
	movl	96(%ebx), %esi
	movl	100(%ebx), %edi
	movl	%ebx, (%esp)
	call	pthread_mutex_unlock
	movl	%esi, %eax
	movl	%edi, %edx
	movl	16(%esp), %ebx
	movl	20(%esp), %esi
	movl	24(%esp), %edi
	addl	$28, %esp
	ret
	.size	next_chunk, .-next_chunk
	.p2align 4,,15
.globl get_chunk
	.type	get_chunk, @function
get_chunk:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	64(%esp), %esi
	movl	%esi, (%esp)
	call	pthread_mutex_lock
	cmpb	$0, 107(%esi)
	jne	.L128
	leal	24(%esi), %eax
	leal	48(%esi), %edi
	movl	%eax, 12(%esp)
	jmp	.L129
	.p2align 4,,10
	.p2align 3
.L131:
	movzbl	105(%esi), %ebx
	cmpl	128(%esi), %ebx
	jne	.L134
.L130:
	movl	%esi, 4(%esp)
	movl	%edi, (%esp)
	call	pthread_cond_wait
	cmpb	$0, 107(%esi)
	jne	.L128
.L129:
	cmpb	$0, 106(%esi)
	jne	.L131
	cmpb	$0, 104(%esi)
	.p2align 4,,5
	.p2align 3
	je	.L131
	movl	12(%esp), %edx
	movl	%edx, (%esp)
	call	pthread_mutex_trylock
	testl	%eax, %eax
	jne	.L131
	movl	128(%esi), %ebx
	testl	%ebx, %ebx
	je	.L132
	movl	124(%esi), %ecx
	xorl	%ebp, %ebp
	movl	%esi, %edx
	cmpl	%ecx, 132(%esi)
	jne	.L133
	jmp	.L132
	.p2align 4,,10
	.p2align 3
.L136:
	movl	152(%edx), %eax
	addl	$20, %edx
	cmpl	%ecx, %eax
	je	.L135
.L133:
	incl	%ebp
	cmpl	%ebx, %ebp
	jb	.L136
.L135:
	movl	%esi, (%esp)
	call	pthread_mutex_unlock
	movl	112(%esi), %ecx
	leal	(%ebp,%ebp,4), %eax
	movl	%ecx, (%esp)
	sall	$2, %eax
	leal	(%esi,%eax), %ebx
	leal	140(%esi,%eax), %edx
	movl	148(%ebx), %ecx
	leal	212(%esi), %eax
	call	sieve
	movl	%esi, (%esp)
	movl	%eax, 32(%esp)
	call	pthread_mutex_lock
	xorl	%edx, %edx
	movl	120(%esi), %eax
	addl	%eax, %eax
	addl	140(%ebx), %eax
	adcl	144(%ebx), %edx
	cmpl	%edx, 224(%esi)
	ja	.L137
	jb	.L154
	cmpl	%eax, 220(%esi)
	ja	.L137
.L154:
	movb	$1, 106(%esi)
	movl	108(%esi), %ebx
	xorl	%edx, %edx
	movl	32(%esp), %ecx
	decl	%ecx
	movl	%ecx, %eax
	divl	%ebx
	movl	%eax, %ecx
	movl	%eax, 8(%esp)
	incl	%ecx
	imull	%ebx, %ecx
	cmpl	%ecx, 32(%esp)
	jae	.L139
	leal	(%ebp,%ebp,4), %eax
	movl	32(%esp), %edx
	leal	148(%esi,%eax,4), %ebx
	sall	$2, %edx
	movl	(%ebx), %eax
	.p2align 4,,10
	.p2align 3
.L140:
	movl	$0, (%eax,%edx)
	incl	32(%esp)
	addl	$4, %edx
	cmpl	32(%esp), %ecx
	ja	.L140
.L139:
	movl	124(%esi), %edx
	notl	8(%esp)
	leal	(%ebp,%ebp,4), %eax
	addl	%edx, 8(%esp)
	leal	(%esi,%eax,4), %eax
	movl	8(%esp), %edx
	movl	$0, 136(%eax)
	movl	%edx, 132(%eax)
	jmp	.L141
.L137:
	leal	(%ebp,%ebp,4), %eax
	leal	(%esi,%eax,4), %eax
	movl	$0, 132(%eax)
	movl	$0, 136(%eax)
.L141:
	decb	104(%esi)
	movzbl	105(%esi), %eax
	cmpl	128(%esi), %eax
	je	.L157
.L142:
	movl	12(%esp), %edx
	movl	%edx, (%esp)
	call	pthread_mutex_unlock
	movl	%edi, (%esp)
	call	pthread_cond_broadcast
	movzbl	105(%esi), %ebx
	.p2align 4,,10
	.p2align 3
.L134:
	movl	96(%esi), %eax
	movl	100(%esi), %edx
	movl	$0, 20(%esp)
	movl	%eax, 24(%esp)
	movl	%edx, 28(%esp)
	leal	(%ebx,%ebx,4), %ecx
	movl	68(%esp), %edi
	leal	(%esi,%ecx,4), %ecx
	movl	136(%ecx), %edx
	movl	%edx, %eax
	incl	%edx
	imull	108(%esi), %eax
	movl	%edx, 136(%ecx)
	sall	$2, %eax
	movl	100(%esi), %edx
	addl	148(%ecx), %eax
	movl	%eax, (%edi)
	movl	116(%esi), %eax
	addl	%eax, %eax
	movl	%eax, 16(%esp)
	movl	96(%esi), %eax
	addl	%eax, 16(%esp)
	adcl	%edx, 20(%esp)
	movl	16(%esp), %eax
	movl	20(%esp), %edx
	movl	%eax, 96(%esi)
	movl	%edx, 100(%esi)
	cmpl	224(%esi), %edx
	jae	.L158
.L143:
	leal	(%ebx,%ebx,4), %eax
	movl	136(%esi,%eax,4), %eax
	movl	%eax, 36(%esp)
	cmpl	124(%esi), %eax
	je	.L159
	.p2align 4,,10
	.p2align 3
.L145:
	movl	%esi, (%esp)
	call	pthread_mutex_unlock
	movl	24(%esp), %eax
	movl	28(%esp), %edx
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L158:
	jbe	.L160
.L155:
	movb	$1, 107(%esi)
	jmp	.L145
	.p2align 4,,10
	.p2align 3
.L128:
	movl	220(%esi), %eax
	movl	224(%esi), %edx
	movl	%eax, 24(%esp)
	movl	%edx, 28(%esp)
	jmp	.L145
.L160:
	cmpl	220(%esi), %eax
	jb	.L143
	jmp	.L155
.L159:
	leal	1(%ebx), %edi
	movl	128(%esi), %ebp
	movl	$0, %eax
	cmpl	%ebp, %edi
	cmove	%eax, %edi
.L146:
	cmpl	%ebx, %edi
	je	.L151
	leal	(%edi,%edi,4), %eax
	leal	132(%esi,%eax,4), %ecx
	jmp	.L152
	.p2align 4,,10
	.p2align 3
.L161:
	movl	%eax, %edi
.L152:
	movl	36(%esp), %edx
	cmpl	(%ecx), %edx
	jbe	.L147
	movl	20(%esp), %edx
	movl	16(%esp), %eax
	xorl	12(%ecx), %edx
	xorl	8(%ecx), %eax
	orl	%eax, %edx
	je	.L148
.L147:
	leal	1(%edi), %eax
	xorl	%edi, %edi
	cmpl	%eax, %ebp
	je	.L146
	addl	$20, %ecx
	cmpl	%ebx, %eax
	jne	.L161
.L151:
	movl	%ebp, %edx
	movb	%dl, 105(%esi)
	jmp	.L145
.L148:
	movl	%edi, %eax
	movb	%al, 105(%esi)
	jmp	.L145
.L157:
	movl	%ebp, %eax
	movb	%al, 105(%esi)
	jmp	.L142
.L132:
	xorl	%ebp, %ebp
	jmp	.L135
	.size	get_chunk, .-get_chunk
	.p2align 4,,15
.globl destroy_sieve
	.type	destroy_sieve, @function
destroy_sieve:
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$16, %esp
	movl	32(%esp), %edi
	movl	%edi, (%esp)
	call	pthread_mutex_destroy
	leal	24(%edi), %eax
	movl	%eax, (%esp)
	call	pthread_mutex_destroy
	leal	48(%edi), %eax
	movl	%eax, (%esp)
	call	pthread_cond_destroy
	movl	128(%edi), %esi
	testl	%esi, %esi
	je	.L163
	leal	(%esi,%esi,4), %eax
	leal	128(%edi,%eax,4), %ebx
.L164:
	movl	(%ebx), %eax
	decl	%esi
	movl	%eax, (%esp)
	subl	$20, %ebx
	call	free
	testl	%esi, %esi
	jne	.L164
.L163:
	movl	%edi, 32(%esp)
	addl	$16, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	jmp	free
	.size	destroy_sieve, .-destroy_sieve
	.p2align 4,,15
.globl free_sieve_primes
	.type	free_sieve_primes, @function
free_sieve_primes:
	subl	$12, %esp
	movl	sieve_primes, %eax
	testl	%eax, %eax
	je	.L169
	movl	%eax, (%esp)
	call	free
	movl	$0, sieve_primes
.L169:
	addl	$12, %esp
	ret
	.size	free_sieve_primes, .-free_sieve_primes
	.p2align 4,,15
.globl create_gfn_sieve
	.type	create_gfn_sieve, @function
create_gfn_sieve:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$76, %esp
	movl	104(%esp), %esi
	movl	116(%esp), %edx
	movl	96(%esp), %eax
	orl	$1, %esi
	orl	$1, %eax
	movl	108(%esp), %edi
	movl	%eax, 48(%esp)
	testl	%edx, %edx
	movl	100(%esp), %eax
	movl	%eax, 52(%esp)
	je	.L202
	movl	sieve_primes, %ebx
.L171:
	movl	num_sieve_primes, %ecx
	movl	36(%ebx), %eax
	movl	%ecx, 44(%esp)
	testl	%ecx, %ecx
	je	.L172
	cmpl	%eax, %edx
	movl	%eax, %ecx
	movl	44(%esp), %eax
	cmovae	%edx, %ecx
	leal	-8(%ebx,%eax,4), %edx
	cmpl	-4(%ebx,%eax,4), %ecx
	jb	.L174
	jmp	.L173
	.p2align 4,,10
	.p2align 3
.L175:
	movl	(%edx), %eax
	subl	$4, %edx
	cmpl	%ecx, %eax
	jbe	.L173
.L174:
	decl	44(%esp)
	.p2align 4,,2
	.p2align 3
	jne	.L175
.L172:
	movl	$236, (%esp)
	call	xmalloc
	movl	48(%esp), %ecx
	movl	52(%esp), %ebx
	movl	%eax, 36(%esp)
	movl	%ecx, 212(%eax)
	movl	%ebx, 216(%eax)
	movl	%esi, 220(%eax)
	movl	%edi, 224(%eax)
	movl	$0, 228(%eax)
	movl	$0, 232(%eax)
.L196:
	movl	36(%esp), %ecx
	movl	$0, 4(%esp)
	movl	%ecx, (%esp)
	movl	$2, %ebp
	call	pthread_mutex_init
	movl	36(%esp), %eax
	movl	$0, 4(%esp)
	addl	$24, %eax
	movl	%eax, (%esp)
	call	pthread_mutex_init
	movl	36(%esp), %eax
	movl	$0, 4(%esp)
	addl	$48, %eax
	movl	%eax, (%esp)
	call	pthread_cond_init
	movl	$2, %eax
	cmpl	$1, 128(%esp)
	jbe	.L188
	movl	$4, %ebp
	cmpl	$4, 128(%esp)
	cmovbe	128(%esp), %ebp
	movl	%ebp, %eax
.L188:
	movl	52(%esp), %ecx
	movl	36(%esp), %ebx
	movl	48(%esp), %edx
	movl	%ecx, 100(%ebx)
	movb	%al, 104(%ebx)
	movb	%al, 105(%ebx)
	movb	$0, 106(%ebx)
	movb	$0, 107(%ebx)
	movl	%edx, 96(%ebx)
	movl	124(%esp), %ecx
	movl	120(%esp), %esi
	andl	$-4, %ecx
	andl	$-4, %esi
	cmpl	$7, %esi
	ja	.L189
	movl	$8, %esi
	movl	$2, %ebx
.L190:
	movl	%ecx, %eax
	shrl	%eax
	cmpl	%eax, %esi
	jbe	.L191
	leal	(%esi,%esi), %ecx
	movl	%ecx, %eax
	shrl	%eax
.L192:
	movl	$2, %edi
	cmpl	%eax, %esi
	jbe	.L193
.L194:
	movl	36(%esp), %ecx
	movl	%edi, %eax
	movl	%ebx, 108(%ecx)
	imull	%ebx, %eax
	movl	%edi, 124(%ecx)
	sall	$5, %ebx
	movl	%eax, 112(%ecx)
	movl	%ebx, 116(%ecx)
	sall	$5, %eax
	movl	%ebp, 128(%ecx)
	movl	%eax, 120(%ecx)
	movl	%ecx, %ebx
	xorl	%esi, %esi
.L195:
	movl	%edi, 132(%ebx)
	movl	%edi, 136(%ebx)
	movl	$0, 140(%ebx)
	movl	$0, 144(%ebx)
	movl	36(%esp), %edx
	incl	%esi
	movl	112(%edx), %eax
	sall	$2, %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	%eax, 148(%ebx)
	addl	$20, %ebx
	cmpl	%esi, %ebp
	ja	.L195
	movl	36(%esp), %eax
	addl	$76, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L191:
	cmpl	$268435456, %ecx
	ja	.L203
.L193:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%esi
	movl	%eax, %edi
	jmp	.L194
.L189:
	movl	%esi, %ebx
	shrl	$2, %ebx
	jmp	.L190
.L202:
	movl	$1, %eax
	movl	sieve_primes, %ebx
	subl	num_sieve_primes, %eax
	sall	$2, %eax
	negl	%eax
	movl	(%ebx,%eax), %edx
	jmp	.L171
.L203:
	movl	$268435456, %ecx
	movl	$134217728, %eax
	jmp	.L192
.L173:
	movl	44(%esp), %edx
	leal	236(,%edx,4), %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	44(%esp), %edx
	movl	48(%esp), %ecx
	movl	%edx, 228(%eax)
	movl	%edx, 232(%eax)
	movl	52(%esp), %ebx
	movl	%ecx, 212(%eax)
	movl	%ebx, 216(%eax)
	movl	%esi, 220(%eax)
	xorl	%ebx, %ebx
	movl	%edi, 224(%eax)
	movl	sieve_primes, %ecx
	movl	%eax, 36(%esp)
	movl	%ecx, 60(%esp)
	movl	48(%esp), %eax
	movzbl	112(%esp), %ecx
	movl	52(%esp), %edx
	movl	$0, 40(%esp)
	shldl	%eax, %edx
	sall	%cl, %eax
	testb	$32, %cl
	cmovne	%eax, %edx
	cmovne	%ebx, %eax
	movl	%edx, %edi
	movl	%eax, %esi
	shrl	%cl, %edi
	shrdl	%edx, %esi
	xorl	%ebp, %ebp
	movl	%edx, %ebx
	testb	$32, %cl
	movl	%eax, %ecx
	cmovne	%edi, %esi
	movl	48(%esp), %eax
	cmovne	%ebp, %edi
	addl	$1, %ecx
	adcl	$0, %ebx
	movl	%ecx, 24(%esp)
	movl	%ebx, 28(%esp)
	xorl	%esi, %eax
	movl	52(%esp), %ebx
	xorl	%edi, %ebx
	orl	%eax, %ebx
	movl	%ebx, 20(%esp)
	.p2align 4,,10
	.p2align 3
.L186:
	movl	40(%esp), %eax
	movl	60(%esp), %edx
	movl	112(%esp), %esi
	movl	(%edx,%eax,4), %ebp
	testl	%esi, %esi
	je	.L204
	leal	1(%ebp), %esi
	movl	%ebp, 64(%esp)
	shrl	%esi
	movl	$0, 68(%esp)
	movl	112(%esp), %ebx
	movl	$1, %edi
	jmp	.L180
	.p2align 4,,10
	.p2align 3
.L205:
	movl	%esi, %eax
	movl	68(%esp), %ecx
	mull	%esi
	movl	%ecx, 12(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	movl	64(%esp), %edx
	movl	%edx, 8(%esp)
	call	__umoddi3
	movl	%eax, %esi
.L180:
	testb	$1, %bl
	je	.L179
	movl	68(%esp), %ecx
	movl	%esi, %eax
	movl	%ecx, 12(%esp)
	mull	%edi
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	movl	64(%esp), %edx
	movl	%edx, 8(%esp)
	call	__umoddi3
	movl	%eax, %edi
.L179:
	shrl	%ebx
	jne	.L205
.L177:
	movl	64(%esp), %ecx
	movl	48(%esp), %eax
	movl	52(%esp), %edx
	movl	%ebp, %esi
	movl	68(%esp), %ebx
	subl	%edi, %esi
	movl	%ecx, 8(%esp)
	movl	%ebx, 12(%esp)
	movl	%eax, (%esp)
	movl	%edx, 4(%esp)
	call	__umoddi3
	cmpl	%eax, %esi
	jb	.L181
	movl	%esi, %edx
	subl	%eax, %edx
.L182:
	testb	$1, %dl
	leal	(%edx,%ebp), %eax
	cmove	%edx, %eax
	shrl	%eax
	cmpl	$31, 112(%esp)
	ja	.L184
	movl	20(%esp), %ebx
	testl	%ebx, %ebx
	je	.L206
.L184:
	movl	40(%esp), %ebx
	movl	36(%esp), %edx
	movl	%eax, 236(%edx,%ebx,4)
	incl	%ebx
	movl	%ebx, 40(%esp)
	cmpl	%ebx, 44(%esp)
	ja	.L186
	jmp	.L196
	.p2align 4,,10
	.p2align 3
.L181:
	leal	(%esi,%ebp), %edx
	subl	%eax, %edx
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L206:
	movl	68(%esp), %edx
	cmpl	%edx, 28(%esp)
	ja	.L184
	jb	.L198
	movl	64(%esp), %ecx
	cmpl	%ecx, 24(%esp)
	ja	.L184
.L198:
	addl	%ebp, %eax
	.p2align 4,,3
	.p2align 3
	jmp	.L184
.L204:
	movl	%ebp, 64(%esp)
	movl	$0, 68(%esp)
	movl	$1, %edi
	jmp	.L177
	.size	create_gfn_sieve, .-create_gfn_sieve
	.p2align 4,,15
.globl create_sieve
	.type	create_sieve, @function
create_sieve:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$60, %esp
	movl	84(%esp), %eax
	movl	80(%esp), %ecx
	movl	88(%esp), %ebx
	movl	92(%esp), %esi
	movl	96(%esp), %edx
	movl	108(%esp), %ebp
	cmpl	$0, %eax
	ja	.L208
	movl	$3, 8(%esp)
	movl	$0, 12(%esp)
	cmpl	$1, %ecx
	ja	.L208
.L210:
	orl	$1, %ebx
	movl	%esi, 28(%esp)
	movl	%ebx, 24(%esp)
	testl	%edx, %edx
	jne	.L211
	cmpl	$1073741823, %esi
	jae	.L231
.L212:
	movl	28(%esp), %esi
	fildll	24(%esp)
	testl	%esi, %esi
	js	.L232
.L214:
	fnstcw	46(%esp)
	fstpl	48(%esp)
	movzwl	46(%esp), %eax
	fldl	48(%esp)
	movb	$12, %ah
	fsqrt
	movw	%ax, 44(%esp)
	fldcw	44(%esp)
	fistpll	32(%esp)
	fldcw	46(%esp)
	movl	32(%esp), %eax
	movl	%eax, %edx
	.p2align 4,,10
	.p2align 3
.L211:
	movl	sieve_primes, %esi
	movl	num_sieve_primes, %ebx
	movl	36(%esi), %eax
	testl	%ebx, %ebx
	je	.L215
	cmpl	%eax, %edx
	leal	-8(%esi,%ebx,4), %ecx
	cmovb	%eax, %edx
	cmpl	-4(%esi,%ebx,4), %edx
	jb	.L216
	jmp	.L215
	.p2align 4,,10
	.p2align 3
.L217:
	movl	(%ecx), %eax
	subl	$4, %ecx
	cmpl	%edx, %eax
	jbe	.L215
.L216:
	decl	%ebx
	.p2align 4,,4
	.p2align 3
	jne	.L217
.L215:
	leal	236(,%ebx,4), %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	28(%esp), %ecx
	movl	%eax, %edi
	movl	12(%esp), %edx
	movl	%ecx, 224(%edi)
	movl	8(%esp), %eax
	movl	%edx, 216(%edi)
	movl	%eax, 212(%edi)
	movl	24(%esp), %edx
	leal	212(%edi), %eax
	movl	%edx, 220(%edi)
	movl	%ebx, 228(%edi)
	movl	$10, 232(%edi)
	call	init_residues
	movl	$0, 4(%esp)
	movl	%edi, (%esp)
	call	pthread_mutex_init
	leal	24(%edi), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_mutex_init
	leal	48(%edi), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_cond_init
	movl	$2, 20(%esp)
	movl	$2, %eax
	cmpl	$1, %ebp
	jbe	.L219
	movl	$4, 20(%esp)
	cmpl	$4, %ebp
	cmova	20(%esp), %ebp
	movl	%ebp, 20(%esp)
	movzbl	20(%esp), %eax
.L219:
	movl	12(%esp), %ecx
	movl	8(%esp), %edx
	movl	%ecx, 100(%edi)
	movb	%al, 104(%edi)
	movb	%al, 105(%edi)
	movb	$0, 106(%edi)
	movb	$0, 107(%edi)
	movl	%edx, 96(%edi)
	movl	104(%esp), %ecx
	movl	100(%esp), %esi
	andl	$-4, %ecx
	andl	$-4, %esi
	cmpl	$7, %esi
	ja	.L220
	movl	$8, %esi
	movl	$2, %ebx
.L221:
	movl	%ecx, %eax
	shrl	%eax
	cmpl	%eax, %esi
	jbe	.L222
	leal	(%esi,%esi), %ecx
	movl	%ecx, %eax
	shrl	%eax
.L223:
	movl	$2, %ebp
	cmpl	%eax, %esi
	jbe	.L224
.L225:
	movl	%ebx, 108(%edi)
	movl	%ebp, %eax
	movl	20(%esp), %ecx
	imull	%ebx, %eax
	movl	%ebp, 124(%edi)
	sall	$5, %ebx
	movl	%eax, 112(%edi)
	movl	%ebx, 116(%edi)
	sall	$5, %eax
	movl	%ecx, 128(%edi)
	movl	%eax, 120(%edi)
	movl	%edi, %ebx
	xorl	%esi, %esi
.L226:
	movl	%ebp, 132(%ebx)
	movl	%ebp, 136(%ebx)
	movl	$0, 140(%ebx)
	movl	$0, 144(%ebx)
	movl	112(%edi), %eax
	incl	%esi
	sall	$2, %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	%eax, 148(%ebx)
	addl	$20, %ebx
	cmpl	%esi, 20(%esp)
	ja	.L226
	addl	$60, %esp
	movl	%edi, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L208:
	orl	$1, %ecx
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	jmp	.L210
	.p2align 4,,10
	.p2align 3
.L222:
	cmpl	$268435456, %ecx
	ja	.L233
.L224:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%esi
	movl	%eax, %ebp
	jmp	.L225
	.p2align 4,,10
	.p2align 3
.L220:
	movl	%esi, %ebx
	shrl	$2, %ebx
	jmp	.L221
	.p2align 4,,10
	.p2align 3
.L233:
	movl	$268435456, %ecx
	movl	$134217728, %eax
	jmp	.L223
	.p2align 4,,10
	.p2align 3
.L231:
	.p2align 4,,3
	.p2align 3
	jbe	.L234
.L229:
	movl	$2147483647, %edx
	.p2align 4,,5
	.p2align 3
	jmp	.L211
	.p2align 4,,10
	.p2align 3
.L234:
	cmpl	$1, %ebx
	.p2align 4,,7
	.p2align 3
	jbe	.L212
	.p2align 4,,7
	.p2align 3
	jmp	.L229
.L232:
	fadds	.LC0
	.p2align 4,,4
	.p2align 3
	jmp	.L214
	.size	create_sieve, .-create_sieve
.globl __popcountsi2
	.p2align 4,,15
.globl init_sieve_primes
	.type	init_sieve_primes, @function
init_sieve_primes:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$11276, %esp
	movl	%gs:20, %eax
	movl	%eax, 11260(%esp)
	xorl	%eax, %eax
	movl	sieve_primes, %eax
	testl	%eax, %eax
	je	.L284
.L236:
	movl	11296(%esp), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	movl	lim_sieve_primes, %eax
	sbbl	$-1, 11296(%esp)
	cmpl	11296(%esp), %eax
	jb	.L285
.L272:
	movl	11260(%esp), %edx
	xorl	%gs:20, %edx
	jne	.L286
	addl	$11276, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L285:
	movl	$3, 72(%esp)
	movl	$0, 76(%esp)
	cmpl	$1, %eax
	jbe	.L246
	orl	$1, %eax
	movl	$0, 76(%esp)
	movl	%eax, 72(%esp)
.L246:
	fnstcw	102(%esp)
	movl	11296(%esp), %ecx
	movl	$0, 52(%esp)
	orl	$1, %ecx
	movzwl	102(%esp), %eax
	movl	%ecx, 48(%esp)
	movb	$12, %ah
	fildll	48(%esp)
	movw	%ax, 100(%esp)
	fld	%st(0)
	fstpt	32(%esp)
	movl	sieve_primes, %esi
	fstpl	104(%esp)
	movl	num_sieve_primes, %ebx
	fldl	104(%esp)
	testl	%ebx, %ebx
	fsqrt
	fldcw	100(%esp)
	fistpll	88(%esp)
	fldcw	102(%esp)
	movl	88(%esp), %eax
	movl	%eax, %edx
	movl	36(%esi), %eax
	je	.L251
	cmpl	%eax, %edx
	leal	-8(%esi,%ebx,4), %ecx
	cmovb	%eax, %edx
	cmpl	-4(%esi,%ebx,4), %edx
	jb	.L252
	jmp	.L251
	.p2align 4,,10
	.p2align 3
.L253:
	movl	(%ecx), %eax
	subl	$4, %ecx
	cmpl	%edx, %eax
	jbe	.L251
.L252:
	decl	%ebx
	.p2align 4,,4
	.p2align 3
	jne	.L253
.L251:
	leal	24(,%ebx,4), %eax
	xorl	%esi, %esi
	movl	%eax, (%esp)
	call	xmalloc
	movl	76(%esp), %edx
	movl	%eax, %ebp
	movl	52(%esp), %ecx
	movl	72(%esp), %eax
	movl	%edx, 4(%ebp)
	movl	%eax, (%ebp)
	movl	48(%esp), %edx
	movl	%ecx, 12(%ebp)
	movl	%edx, 8(%ebp)
	movl	%ebx, 16(%ebp)
	movl	$10, 20(%ebp)
	movl	%ebp, %eax
	call	init_residues
.L254:
	movl	$2048, (%esp)
	leal	112(%esp), %ecx
	leal	11200(%esp), %edx
	movl	%ebp, %eax
	call	sieve
	movl	%eax, %edi
	testl	%eax, %eax
	je	.L287
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L255:
	movl	112(%esp,%ebx,4), %eax
	incl	%ebx
	movl	%eax, (%esp)
	call	__popcountsi2
	addl	%eax, %esi
	cmpl	%edi, %ebx
	jb	.L255
	jmp	.L254
.L287:
	movl	%ebp, (%esp)
	xorl	%edi, %edi
	call	free
	addl	num_sieve_primes, %esi
	leal	4(,%esi,4), %eax
	movl	$3, %esi
	movl	%eax, 4(%esp)
	movl	sieve_primes, %eax
	movl	%eax, (%esp)
	call	xrealloc
	movl	%eax, sieve_primes
	movl	lim_sieve_primes, %eax
	cmpl	$1, %eax
	jbe	.L259
	movl	%eax, %esi
	xorl	%edi, %edi
	orl	$1, %esi
.L259:
	cmpl	$1073741823, 52(%esp)
	jae	.L288
.L260:
	movl	52(%esp), %ebp
	fldt	32(%esp)
	testl	%ebp, %ebp
	jns	.L263
	fadds	.LC0
.L263:
	fnstcw	102(%esp)
	fstpl	104(%esp)
	movzwl	102(%esp), %eax
	fldl	104(%esp)
	movb	$12, %ah
	fsqrt
	movw	%ax, 100(%esp)
	fldcw	100(%esp)
	fistpll	88(%esp)
	fldcw	102(%esp)
	movl	88(%esp), %eax
	jmp	.L262
	.p2align 4,,10
	.p2align 3
.L288:
	ja	.L277
	cmpl	$1, 48(%esp)
	jbe	.L260
.L277:
	movl	$2147483647, %eax
.L262:
	movl	sieve_primes, %ebp
	movl	num_sieve_primes, %ebx
	movl	36(%ebp), %edx
	testl	%ebx, %ebx
	je	.L264
	cmpl	%edx, %eax
	leal	-8(%ebp,%ebx,4), %ecx
	cmovae	%eax, %edx
	cmpl	-4(%ebp,%ebx,4), %edx
	jb	.L265
	jmp	.L264
	.p2align 4,,10
	.p2align 3
.L266:
	movl	(%ecx), %eax
	subl	$4, %ecx
	cmpl	%eax, %edx
	jae	.L264
.L265:
	decl	%ebx
	.p2align 4,,4
	.p2align 3
	jne	.L266
.L264:
	leal	24(,%ebx,4), %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	52(%esp), %edx
	movl	%eax, 84(%esp)
	movl	%edi, 4(%eax)
	movl	84(%esp), %ecx
	movl	%esi, (%eax)
	movl	%edx, 12(%ecx)
	movl	48(%esp), %eax
	movl	%ebx, 16(%ecx)
	movl	%eax, 8(%ecx)
	movl	$10, 20(%ecx)
	movl	%ecx, %eax
	call	init_residues
	movl	num_sieve_primes, %edi
.L267:
	movl	$2048, (%esp)
	leal	112(%esp), %ecx
	leal	11200(%esp), %edx
	movl	84(%esp), %eax
	call	sieve
	movl	%eax, 68(%esp)
	testl	%eax, %eax
	je	.L271
	movl	sieve_primes, %edx
	movl	11200(%esp), %ecx
	movl	%edx, 60(%esp)
	movl	%ecx, 44(%esp)
	movl	$0, 64(%esp)
	.p2align 4,,10
	.p2align 3
.L270:
	movl	64(%esp), %esi
	movl	112(%esp,%esi,4), %eax
	testl	%eax, %eax
	je	.L268
	movl	%esi, %ebp
	movl	60(%esp), %edx
	sall	$5, %ebp
	leal	(%edx,%edi,4), %ebx
	xorl	%esi, %esi
	.p2align 4,,10
	.p2align 3
.L269:
	bsfl	%eax, %ecx
	movl	%eax, %edx
	incl	%edi
	shrl	%cl, %edx
	leal	(%esi,%ecx), %ecx
	movl	44(%esp), %esi
	leal	(%ecx,%ebp), %eax
	leal	(%esi,%eax,2), %eax
	leal	1(%ecx), %esi
	movl	%eax, (%ebx)
	addl	$4, %ebx
	movl	%edx, %eax
	shrl	%eax
	jne	.L269
.L268:
	incl	64(%esp)
	movl	68(%esp), %eax
	cmpl	%eax, 64(%esp)
	jb	.L270
	jmp	.L267
.L271:
	movl	84(%esp), %esi
	movl	%esi, (%esp)
	call	free
	movl	sieve_primes, %eax
	movl	$-1, (%eax,%edi,4)
	movl	%edi, num_sieve_primes
	movl	11296(%esp), %eax
	movl	%eax, lim_sieve_primes
	jmp	.L272
.L284:
	leal	8304(%esp), %eax
	movb	$3, 11214(%esp)
	movb	$5, 11215(%esp)
	movb	$7, 11216(%esp)
	movb	$11, 11217(%esp)
	movb	$13, 11218(%esp)
	movb	$17, 11219(%esp)
	movb	$19, 11220(%esp)
	movb	$23, 11221(%esp)
	movb	$29, 11222(%esp)
	movb	$31, 11223(%esp)
	movb	$37, 11224(%esp)
	movb	$41, 11225(%esp)
	movb	$43, 11226(%esp)
	movb	$47, 11227(%esp)
	movb	$53, 11228(%esp)
	movb	$59, 11229(%esp)
	movb	$61, 11230(%esp)
	movb	$67, 11231(%esp)
	movb	$71, 11232(%esp)
	movb	$73, 11233(%esp)
	movb	$79, 11234(%esp)
	movb	$83, 11235(%esp)
	movb	$89, 11236(%esp)
	movb	$97, 11237(%esp)
	movb	$101, 11238(%esp)
	movb	$103, 11239(%esp)
	movb	$107, 11240(%esp)
	movb	$109, 11241(%esp)
	movb	$113, 11242(%esp)
	movb	$127, 11243(%esp)
	movb	$-125, 11244(%esp)
	movb	$-119, 11245(%esp)
	movb	$-117, 11246(%esp)
	leal	11214(%esp), %ebp
	movb	$-107, 11247(%esp)
	movb	$-105, 11248(%esp)
	movb	$-99, 11249(%esp)
	movb	$-93, 11250(%esp)
	movb	$-89, 11251(%esp)
	movb	$-83, 11252(%esp)
	movb	$-77, 11253(%esp)
	movb	$-75, 11254(%esp)
	movb	$-65, 11255(%esp)
	movb	$-63, 11256(%esp)
	movb	$-59, 11257(%esp)
	movb	$-57, 11258(%esp)
	movb	$-45, 11259(%esp)
	movl	$2896, 8(%esp)
	movl	$-1, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	leal	11260(%esp), %edx
	movl	%edx, 28(%esp)
.L239:
	movzbl	(%ebp), %edi
	leal	-3(%edi), %eax
	shrl	%eax
	leal	(%eax,%edi), %ecx
	cmpl	$23167, %ecx
	ja	.L237
	leal	(%edi,%ecx), %esi
	movl	%esi, %ebx
	jmp	.L238
	.p2align 4,,10
	.p2align 3
.L289:
	leal	(%edi,%esi), %esi
.L238:
	movl	%ecx, %eax
	addl	%edi, %ebx
	shrl	$5, %eax
	andl	$31, %ecx
	movl	$1, %edx
	sall	%cl, %edx
	movl	%esi, %ecx
	notl	%edx
	andl	%edx, 8304(%esp,%eax,4)
	movl	%ebx, %eax
	subl	%edi, %eax
	cmpl	$23167, %eax
	jbe	.L289
.L237:
	incl	%ebp
	cmpl	28(%esp), %ebp
	jne	.L239
	movl	$19168, (%esp)
	xorl	%esi, %esi
	call	xmalloc
	movl	$3, %ebx
	movl	%eax, %edi
	movl	%eax, sieve_primes
	xorl	%edx, %edx
.L241:
	movl	%edx, %eax
	movl	%edx, %ecx
	shrl	$5, %eax
	andl	$31, %ecx
	movl	8304(%esp,%eax,4), %eax
	shrl	%cl, %eax
	testb	$1, %al
	je	.L240
	movl	%ebx, (%edi,%esi,4)
	incl	%esi
.L240:
	incl	%edx
	addl	$2, %ebx
	cmpl	$23168, %edx
	jne	.L241
	movl	$-1, 19164(%edi)
	movl	$4791, num_sieve_primes
	movl	$46348, lim_sieve_primes
	jmp	.L236
.L286:
	call	__stack_chk_fail
	.size	init_sieve_primes, .-init_sieve_primes
.globl sieve_primes
	.bss
	.align 4
	.type	sieve_primes, @object
	.size	sieve_primes, 4
sieve_primes:
	.zero	4
.globl num_sieve_primes
	.align 4
	.type	num_sieve_primes, @object
	.size	num_sieve_primes, 4
num_sieve_primes:
	.zero	4
	.local	lim_sieve_primes
	.comm	lim_sieve_primes,4,4
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.long	1602224128
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
