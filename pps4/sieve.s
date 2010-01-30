	.file	"sieve.c"
	.text
	.p2align 4,,15
	.type	init_residues, @function
init_residues:
.LFB63:
	pushq	%r15
.LCFI0:
	pushq	%r14
.LCFI1:
	pushq	%r13
.LCFI2:
	pushq	%r12
.LCFI3:
	movq	%rdi, %r12
	pushq	%rbp
.LCFI4:
	pushq	%rbx
.LCFI5:
	movl	20(%rdi), %r13d
	movq	(%rdi), %rbp
	testl	%r13d, %r13d
	je	.L10
	movq	sieve_primes(%rip), %r14
	xorl	%ebx, %ebx
	xorl	%r15d, %r15d
	.p2align 4,,10
	.p2align 3
.L9:
	movl	(%r14,%rbx,4), %edi
	xorl	%edx, %edx
	mov	%edi, %r9d
	movl	%edi, %ecx
	movq	%rbp, %rax
	divq	%r9
	subl	%edx, %ecx
	movl	%edx, %r11d
	testl	%edx, %edx
	movl	%ecx, %r10d
	setne	%sil
	leal	(%rcx,%rdi), %edx
	andl	$1, %r10d
	setne	%al
	andb	%sil, %al
	cmove	%ecx, %edx
	movl	%eax, %r8d
	shrl	%edx
	testl	%r10d, %r10d
	sete	%al
	andl	%eax, %esi
	orb	%sil, %r8b
	cmove	%r15d, %edx
	testl	%r11d, %r11d
	leal	(%rdx,%rdi), %edi
	sete	%al
	orl	%r8d, %eax
	cmpq	%r9, %rbp
	setbe	%cl
	testb	%cl, %al
	cmove	%edx, %edi
	movl	%edi, 24(%r12,%rbx,4)
	incq	%rbx
	cmpl	%ebx, %r13d
	ja	.L9
.L10:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.LFE63:
	.size	init_residues, .-init_residues
	.p2align 4,,15
	.type	sieve, @function
sieve:
.LFB65:
	pushq	%r15
.LCFI6:
	movq	%rdx, %r11
	pushq	%r14
.LCFI7:
	pushq	%r13
.LCFI8:
	pushq	%r12
.LCFI9:
	pushq	%rbp
.LCFI10:
	pushq	%rbx
.LCFI11:
	subq	$72, %rsp
.LCFI12:
	movq	%rdi, -80(%rsp)
	movq	%rsi, -88(%rsp)
	movl	%ecx, %edi
	movq	-80(%rsp), %rax
	sall	$6, %edi
	movq	(%rax), %rax
	movq	-80(%rsp), %rdx
	movq	%rax, -72(%rsp)
	movq	8(%rdx), %rdx
	movl	%ecx, -92(%rsp)
	movq	%rdx, -64(%rsp)
	subq	%rax, %rdx
	mov	%edi, %eax
	addq	%rax, %rax
	cmpq	%rax, %rdx
	jb	.L14
	addq	-72(%rsp), %rax
	movq	%rax, -64(%rsp)
	movq	%rax, %r8
.L15:
	movq	-80(%rsp), %rbx
	movl	24(%rbx), %edx
	movl	28(%rbx), %r12d
	movl	32(%rbx), %r13d
	movl	36(%rbx), %eax
	movl	40(%rbx), %ecx
	movq	%r8, (%rbx)
	movl	%r12d, 36(%rsp)
	movl	44(%rbx), %ebx
	movl	%r13d, 40(%rsp)
	movl	%eax, 44(%rsp)
	movl	%ecx, -108(%rsp)
	movq	-80(%rsp), %rax
	movl	%ebx, 48(%rsp)
	movl	72(%rax), %ecx
	movl	76(%rax), %ebx
	movq	-80(%rsp), %r8
	movq	-80(%rsp), %r12
	movl	48(%r8), %r8d
	movl	52(%r12), %r12d
	movl	%r8d, 52(%rsp)
	movl	%r12d, 56(%rsp)
	movl	80(%rax), %r8d
	movq	-80(%rsp), %r13
	movl	64(%rax), %r14d
	movl	56(%r13), %r13d
	movl	68(%rax), %r15d
	movl	%r13d, 60(%rsp)
	movl	84(%rax), %r12d
	movl	60(%rax), %r13d
	cmpl	$2, %edx
	movl	%ecx, -44(%rsp)
	movl	%ebx, -40(%rsp)
	movl	%r8d, -36(%rsp)
	movl	%r12d, -32(%rsp)
	movl	88(%rax), %eax
	movl	%eax, -28(%rsp)
	leal	-3(%rdx), %eax
	cmovle	%edx, %eax
	movl	%eax, %esi
	decl	%esi
	js	.L116
.L18:
	movl	36(%rsp), %eax
	subl	$5, %eax
	cmpl	$4, 36(%rsp)
	cmovle	36(%rsp), %eax
	movl	%eax, %ecx
	subl	$4, %ecx
	movl	%ecx, -52(%rsp)
	js	.L117
.L21:
	movl	40(%rsp), %eax
	subl	$7, %eax
	cmpl	$6, 40(%rsp)
	cmovle	40(%rsp), %eax
	movl	%eax, %r12d
	decl	%r12d
	js	.L118
.L24:
	movl	44(%rsp), %eax
	subl	$11, %eax
	cmpl	$10, 44(%rsp)
	cmovle	44(%rsp), %eax
	movl	%eax, %ebp
	subl	$9, %ebp
	js	.L119
.L27:
	movl	-108(%rsp), %eax
	subl	$13, %eax
	cmpl	$12, -108(%rsp)
	cmovle	-108(%rsp), %eax
	movl	%eax, %ebx
	subl	$12, %ebx
	js	.L120
.L30:
	movl	48(%rsp), %eax
	subl	$17, %eax
	cmpl	$16, 48(%rsp)
	cmovle	48(%rsp), %eax
	movl	%eax, %r8d
	subl	$13, %r8d
	movl	%r8d, -48(%rsp)
	js	.L121
.L33:
	movl	52(%rsp), %eax
	subl	$19, %eax
	cmpl	$18, 52(%rsp)
	cmovle	52(%rsp), %eax
	movl	%eax, %r10d
	subl	$7, %r10d
	js	.L122
.L36:
	movl	56(%rsp), %eax
	subl	$23, %eax
	cmpl	$22, 56(%rsp)
	cmovle	56(%rsp), %eax
	movl	%eax, %r9d
	subl	$18, %r9d
	js	.L123
.L39:
	movl	60(%rsp), %eax
	subl	$29, %eax
	cmpl	$28, 60(%rsp)
	cmovle	60(%rsp), %eax
	movl	%eax, %r8d
	subl	$6, %r8d
	js	.L124
.L42:
	movl	%edx, %ecx
	movabsq	$-7905747460161236407, %rax
	movabsq	$1190112520884487201, %rdx
	salq	%cl, %rax
	movzbl	36(%rsp), %ecx
	salq	%cl, %rdx
	movzbl	40(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$-9150747060186627967, %rax
	salq	%cl, %rax
	movzbl	44(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$36046397799139329, %rax
	salq	%cl, %rax
	movzbl	-108(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$4504149450301441, %rax
	salq	%cl, %rax
	movzbl	48(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$2251816993685505, %rax
	salq	%cl, %rax
	movzbl	52(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$144115462954287105, %rax
	salq	%cl, %rax
	movzbl	56(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$70368752566273, %rax
	salq	%cl, %rax
	movzbl	60(%rsp), %ecx
	orq	%rax, %rdx
	movabsq	$288230376688582657, %rax
	salq	%cl, %rax
	movl	%r13d, %ecx
	orq	%rax, %rdx
	movabsq	$4611686020574871553, %rax
	salq	%cl, %rax
	orq	%rax, %rdx
	leal	-31(%r13), %eax
	cmpl	$31, %r13d
	cmovge	%eax, %r13d
	movl	%r13d, %eax
	subl	$2, %eax
	movl	%eax, -108(%rsp)
	js	.L125
.L44:
	cmpl	$36, %r14d
	jle	.L45
	subl	$37, %r14d
	movabsq	$137438953472, %rax
	movl	%r14d, %ecx
	movl	%r14d, %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$27, %r13d
	movl	%r13d, 20(%rsp)
	js	.L126
.L47:
	cmpl	$40, %r15d
	jle	.L48
	subl	$41, %r15d
	movabsq	$2199023255552, %rdx
	movl	%r15d, %ecx
	movl	%r15d, %r13d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$23, %r13d
	movl	%r13d, 24(%rsp)
	js	.L127
.L50:
	cmpl	$42, -44(%rsp)
	jle	.L51
	subl	$43, -44(%rsp)
	movabsq	$8796093022208, %rax
	movzbl	-44(%rsp), %ecx
	movl	-44(%rsp), %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$21, %r13d
	movl	%r13d, 28(%rsp)
	js	.L128
.L53:
	cmpl	$46, -40(%rsp)
	jle	.L54
	subl	$47, -40(%rsp)
	movabsq	$140737488355328, %rdx
	movzbl	-40(%rsp), %ecx
	movl	-40(%rsp), %r13d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$17, %r13d
	movl	%r13d, 32(%rsp)
	js	.L129
.L56:
	cmpl	$52, -36(%rsp)
	jle	.L57
	subl	$53, -36(%rsp)
	movabsq	$9007199254740992, %rax
	movzbl	-36(%rsp), %ecx
	movl	-36(%rsp), %r15d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$11, %r15d
	js	.L130
.L59:
	cmpl	$58, -32(%rsp)
	jle	.L60
	subl	$59, -32(%rsp)
	movabsq	$576460752303423488, %rdx
	movzbl	-32(%rsp), %ecx
	movl	-32(%rsp), %r14d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$5, %r14d
	js	.L131
.L62:
	cmpl	$60, -28(%rsp)
	jle	.L63
	subl	$61, -28(%rsp)
	movabsq	$2305843009213693952, %rax
	movzbl	-28(%rsp), %ecx
	movl	-28(%rsp), %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$3, %r13d
	js	.L132
.L65:
	notq	%rax
	cmpl	$1, -92(%rsp)
	movq	%rax, (%r11)
	jbe	.L66
	movl	-52(%rsp), %eax
	movl	-48(%rsp), %edx
	movl	%eax, 68(%rsp)
	movl	%edx, 64(%rsp)
	movl	-92(%rsp), %eax
	movq	$0, -24(%rsp)
	subl	$2, %eax
	leaq	8(,%rax,8), %rax
	movq	%rax, -104(%rsp)
	jmp	.L89
	.p2align 4,,10
	.p2align 3
.L87:
	movl	-52(%rsp), %r12d
	movl	-48(%rsp), %eax
	movl	%r12d, 68(%rsp)
	movl	16(%rsp), %edx
	movl	-12(%rsp), %esi
	movl	-8(%rsp), %r12d
	movl	-4(%rsp), %ebp
	movl	(%rsp), %ebx
	movl	%eax, 64(%rsp)
	movl	4(%rsp), %r10d
	movl	8(%rsp), %r9d
	movl	12(%rsp), %r8d
	movl	%edx, -108(%rsp)
.L89:
	leal	2(%rsi), %ecx
	movl	-52(%rsp), %edx
	movl	%esi, %eax
	decl	%eax
	cmovs	%ecx, %eax
	leal	1(%rbx), %ecx
	incl	%edx
	movl	%eax, -12(%rsp)
	movl	-52(%rsp), %eax
	subl	$4, %eax
	cmovns	%eax, %edx
	leal	6(%r12), %eax
	movl	%edx, -52(%rsp)
	movl	%eax, -8(%rsp)
	leal	2(%rbp), %edx
	movl	%r12d, %eax
	decl	%eax
	cmovs	-8(%rsp), %eax
	movl	%eax, -8(%rsp)
	movl	%ebp, %eax
	subl	$9, %eax
	cmovs	%edx, %eax
	movl	-48(%rsp), %edx
	movl	%eax, -4(%rsp)
	movl	%ebx, %eax
	subl	$12, %eax
	cmovs	%ecx, %eax
	leal	23(%r8), %ecx
	addl	$4, %edx
	movl	%eax, (%rsp)
	movl	-48(%rsp), %eax
	subl	$13, %eax
	cmovns	%eax, %edx
	leal	12(%r10), %eax
	movl	%edx, -48(%rsp)
	movl	%eax, 4(%rsp)
	leal	5(%r9), %edx
	movl	%r10d, %eax
	subl	$7, %eax
	cmovs	4(%rsp), %eax
	movl	%eax, 4(%rsp)
	movl	%r9d, %eax
	subl	$18, %eax
	cmovs	%edx, %eax
	movabsq	$-7905747460161236407, %rdx
	movl	%eax, 8(%rsp)
	movl	%r8d, %eax
	subl	$6, %eax
	cmovs	%ecx, %eax
	movl	%esi, %ecx
	movl	%eax, 12(%rsp)
	movl	-108(%rsp), %eax
	addl	$29, %eax
	movl	%eax, 16(%rsp)
	movl	-108(%rsp), %eax
	subl	$2, %eax
	cmovs	16(%rsp), %eax
	salq	%cl, %rdx
	movl	%eax, 16(%rsp)
	movzbl	68(%rsp), %ecx
	movabsq	$1190112520884487201, %rax
	salq	%cl, %rax
	movl	%r12d, %ecx
	orq	%rdx, %rax
	movabsq	$-9150747060186627967, %rdx
	salq	%cl, %rdx
	movl	%ebp, %ecx
	orq	%rdx, %rax
	movabsq	$36046397799139329, %rdx
	salq	%cl, %rdx
	movl	%ebx, %ecx
	orq	%rdx, %rax
	movq	-24(%rsp), %rbx
	movabsq	$4504149450301441, %rdx
	salq	%cl, %rdx
	movzbl	64(%rsp), %ecx
	orq	%rdx, %rax
	movabsq	$2251816993685505, %rdx
	salq	%cl, %rdx
	movl	%r10d, %ecx
	orq	%rdx, %rax
	movabsq	$144115462954287105, %rdx
	salq	%cl, %rdx
	movl	%r9d, %ecx
	orq	%rdx, %rax
	movabsq	$70368752566273, %rdx
	salq	%cl, %rdx
	movl	%r8d, %ecx
	orq	%rdx, %rax
	movq	-104(%rsp), %r8
	movabsq	$288230376688582657, %rdx
	salq	%cl, %rdx
	movzbl	-108(%rsp), %ecx
	orq	%rdx, %rax
	movabsq	$4611686020574871553, %rdx
	salq	%cl, %rdx
	orq	%rdx, %rax
	notq	%rax
	movq	%rax, 8(%r11,%rbx)
	addq	$8, %rbx
	movq	%rbx, -24(%rsp)
	cmpq	%r8, %rbx
	jne	.L87
	movq	$0, -120(%rsp)
	movl	20(%rsp), %r12d
	jmp	.L88
	.p2align 4,,10
	.p2align 3
.L90:
	movl	24(%rsp), %ebp
	subl	$23, %ebp
	js	.L133
.L91:
	movl	28(%rsp), %esi
	subl	$21, %esi
	js	.L134
.L92:
	movl	32(%rsp), %ebx
	subl	$17, %ebx
	js	.L135
.L93:
	movl	%r15d, %r10d
	subl	$11, %r10d
	js	.L136
.L94:
	movl	%r14d, %r9d
	subl	$5, %r9d
	js	.L137
.L95:
	movl	%r13d, %r8d
	subl	$3, %r8d
	js	.L138
.L96:
	movzbl	20(%rsp), %ecx
	movabsq	$137438953473, %rdx
	movabsq	$2199023255553, %rax
	salq	%cl, %rdx
	movzbl	24(%rsp), %ecx
	salq	%cl, %rax
	movzbl	28(%rsp), %ecx
	orq	%rdx, %rax
	movabsq	$8796093022209, %rdx
	salq	%cl, %rdx
	movzbl	32(%rsp), %ecx
	orq	%rdx, %rax
	movabsq	$140737488355329, %rdx
	salq	%cl, %rdx
	movl	%r15d, %ecx
	orq	%rdx, %rax
	movabsq	$9007199254740993, %rdx
	salq	%cl, %rdx
	movl	%r14d, %ecx
	orq	%rdx, %rax
	movabsq	$576460752303423489, %rdx
	salq	%cl, %rdx
	movl	%r13d, %ecx
	orq	%rdx, %rax
	movq	-120(%rsp), %r13
	movabsq	$2305843009213693953, %rdx
	salq	%cl, %rdx
	orq	%rdx, %rax
	notq	%rax
	andq	%rax, 8(%r11,%r13)
	addq	$8, %r13
	movq	%r13, -120(%rsp)
	cmpq	%r13, -24(%rsp)
	je	.L139
	movl	%r12d, 20(%rsp)
	movl	%ebp, 24(%rsp)
	movl	%esi, 28(%rsp)
	movl	%ebx, 32(%rsp)
	movl	%r10d, %r15d
	movl	%r9d, %r14d
	movl	%r8d, %r13d
.L88:
	subl	$27, %r12d
	jns	.L90
	movl	20(%rsp), %r12d
	movl	24(%rsp), %ebp
	addl	$10, %r12d
	subl	$23, %ebp
	jns	.L91
.L133:
	movl	24(%rsp), %ebp
	movl	28(%rsp), %esi
	addl	$18, %ebp
	subl	$21, %esi
	jns	.L92
.L134:
	movl	28(%rsp), %esi
	movl	32(%rsp), %ebx
	addl	$22, %esi
	subl	$17, %ebx
	jns	.L93
.L135:
	movl	32(%rsp), %ebx
	movl	%r15d, %r10d
	addl	$30, %ebx
	subl	$11, %r10d
	jns	.L94
.L136:
	movl	%r14d, %r9d
	leal	42(%r15), %r10d
	subl	$5, %r9d
	jns	.L95
.L137:
	movl	%r13d, %r8d
	leal	54(%r14), %r9d
	subl	$3, %r8d
	jns	.L96
.L138:
	leal	58(%r13), %r8d
	jmp	.L96
.L139:
	movl	%r12d, 20(%rsp)
	movl	%ebp, 24(%rsp)
	movl	%esi, 28(%rsp)
	movl	%ebx, 32(%rsp)
	movl	%r10d, %r15d
	movl	%r9d, %r14d
	movl	%r8d, %r13d
	movl	16(%rsp), %eax
	movl	-12(%rsp), %esi
	movl	-8(%rsp), %r12d
	movl	-4(%rsp), %ebp
	movl	(%rsp), %ebx
	movl	4(%rsp), %r10d
	movl	8(%rsp), %r9d
	movl	12(%rsp), %r8d
	movl	%eax, -108(%rsp)
.L66:
	movq	-80(%rsp), %rdx
	movl	-52(%rsp), %ecx
	movl	%r12d, 32(%rdx)
	movl	%ecx, 28(%rdx)
	movl	20(%rsp), %r12d
	movl	%ebx, 40(%rdx)
	movl	%r8d, 56(%rdx)
	movl	-48(%rsp), %ebx
	movl	-108(%rsp), %r8d
	movl	%ebx, 44(%rdx)
	movl	%r12d, 64(%rdx)
	movl	24(%rsp), %eax
	movl	28(%rsp), %ecx
	movl	32(%rsp), %ebx
	movl	20(%rdx), %r12d
	movl	%esi, 24(%rdx)
	movl	%ebp, 36(%rdx)
	movl	%r10d, 48(%rdx)
	movl	%r9d, 52(%rdx)
	movl	%r8d, 60(%rdx)
	movl	%eax, 68(%rdx)
	movl	%ecx, 72(%rdx)
	movl	%ebx, 76(%rdx)
	movl	%r15d, 80(%rdx)
	movl	%r14d, 84(%rdx)
	movl	%r13d, 88(%rdx)
	cmpl	$17, %r12d
	jbe	.L98
	leal	-18(%r12), %eax
	movq	sieve_primes(%rip), %rbp
	xorl	%r10d, %r10d
	movl	$1, %esi
	leaq	4(,%rax,4), %rbx
	.p2align 4,,10
	.p2align 3
.L101:
	movq	-80(%rsp), %r8
	movl	68(%rbp,%r10), %r9d
	movl	92(%r8,%r10), %edx
	cmpl	%edx, %edi
	jbe	.L99
	leal	(%rdx,%r9), %r8d
	.p2align 4,,10
	.p2align 3
.L100:
	movl	%edx, %eax
	movl	%edx, %ecx
	shrl	$6, %eax
	andl	$63, %ecx
	mov	%eax, %eax
	addl	%r9d, %r8d
	movq	%rsi, %r13
	addl	%r9d, %edx
	salq	%cl, %r13
	movq	%r13, %rcx
	notq	%rcx
	andq	%rcx, (%r11,%rax,8)
	movl	%r8d, %eax
	subl	%r9d, %eax
	cmpl	%eax, %edi
	ja	.L100
.L99:
	subl	%edi, %edx
	movq	-80(%rsp), %rax
	movl	%edx, 92(%rax,%r10)
	addq	$4, %r10
	cmpq	%rbx, %r10
	jne	.L101
.L98:
	movq	-80(%rsp), %rdx
	movl	16(%rdx), %r13d
	cmpl	%r13d, %r12d
	jae	.L102
	movq	sieve_primes(%rip), %rbp
	mov	%r12d, %edx
	movl	(%rbp,%rdx,4), %r9d
	mov	%r9d, %r8d
	movq	%r8, %rax
	imulq	%r8, %rax
	cmpq	%rax, -64(%rsp)
	jbe	.L102
	movl	%r12d, %r10d
	movq	%rdx, %rsi
	movl	$1, %ebx
	.p2align 4,,10
	.p2align 3
.L103:
	xorl	%edx, %edx
	movq	-72(%rsp), %rax
	divq	%r8
	testl	%edx, %edx
	je	.L105
	movl	%r9d, %eax
	subl	%edx, %eax
	testb	$1, %al
	leal	(%rax,%r9), %edx
	cmove	%eax, %edx
	shrl	%edx
.L105:
	cmpq	%r8, -72(%rsp)
	leal	(%rdx,%r9), %eax
	cmovbe	%eax, %edx
	cmpl	%edx, %edi
	jbe	.L108
	leal	(%rdx,%r9), %r8d
	.p2align 4,,10
	.p2align 3
.L109:
	movl	%edx, %eax
	movl	%edx, %ecx
	shrl	$6, %eax
	andl	$63, %ecx
	mov	%eax, %eax
	addl	%r9d, %r8d
	movq	%rbx, %r12
	addl	%r9d, %edx
	salq	%cl, %r12
	movq	%r12, %rcx
	notq	%rcx
	andq	%rcx, (%r11,%rax,8)
	movl	%r8d, %eax
	subl	%r9d, %eax
	cmpl	%eax, %edi
	ja	.L109
.L108:
	subl	%edi, %edx
	movq	-80(%rsp), %rax
	incl	%r10d
	movl	%edx, 24(%rax,%rsi,4)
	cmpl	%r10d, %r13d
	jbe	.L104
	mov	%r10d, %esi
	movl	(%rbp,%rsi,4), %r9d
	mov	%r9d, %r8d
	movq	%r8, %rax
	imulq	%r8, %rax
	cmpq	%rax, -64(%rsp)
	ja	.L103
.L104:
	movq	-80(%rsp), %rdx
	movq	-72(%rsp), %rbx
	movq	-88(%rsp), %rcx
	movl	-92(%rsp), %eax
	movl	%r10d, 20(%rdx)
	movq	%rbx, (%rcx)
	testl	%eax, %eax
	je	.L111
	movl	%edi, %ecx
	andl	$63, %ecx
	je	.L111
	movl	-92(%rsp), %edx
	movl	$1, %eax
	decl	%edx
	salq	%cl, %rax
	decq	%rax
	andq	%rax, (%r11,%rdx,8)
.L111:
	movl	-92(%rsp), %eax
	addq	$72, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L63:
	movabsq	$2305843009213693953, %rax
	movzbl	-28(%rsp), %ecx
	movl	-28(%rsp), %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$3, %r13d
	jns	.L65
.L132:
	movl	-28(%rsp), %r13d
	addl	$58, %r13d
	jmp	.L65
.L60:
	movabsq	$576460752303423489, %rdx
	movzbl	-32(%rsp), %ecx
	movl	-32(%rsp), %r14d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$5, %r14d
	jns	.L62
.L131:
	movl	-32(%rsp), %r14d
	addl	$54, %r14d
	jmp	.L62
.L57:
	movabsq	$9007199254740993, %rax
	movzbl	-36(%rsp), %ecx
	movl	-36(%rsp), %r15d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$11, %r15d
	jns	.L59
.L130:
	movl	-36(%rsp), %r15d
	addl	$42, %r15d
	jmp	.L59
.L54:
	movabsq	$140737488355329, %rdx
	movzbl	-40(%rsp), %ecx
	movl	-40(%rsp), %r13d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$17, %r13d
	movl	%r13d, 32(%rsp)
	jns	.L56
.L129:
	movl	-40(%rsp), %eax
	addl	$30, %eax
	movl	%eax, 32(%rsp)
	jmp	.L56
.L51:
	movabsq	$8796093022209, %rax
	movzbl	-44(%rsp), %ecx
	movl	-44(%rsp), %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$21, %r13d
	movl	%r13d, 28(%rsp)
	jns	.L53
.L128:
	movl	-44(%rsp), %edx
	addl	$22, %edx
	movl	%edx, 28(%rsp)
	jmp	.L53
.L48:
	movabsq	$2199023255553, %rdx
	movl	%r15d, %ecx
	movl	%r15d, %r13d
	salq	%cl, %rdx
	orq	%rax, %rdx
	subl	$23, %r13d
	movl	%r13d, 24(%rsp)
	jns	.L50
.L127:
	addl	$18, %r15d
	movl	%r15d, 24(%rsp)
	jmp	.L50
.L45:
	movabsq	$137438953473, %rax
	movl	%r14d, %ecx
	movl	%r14d, %r13d
	salq	%cl, %rax
	orq	%rdx, %rax
	subl	$27, %r13d
	movl	%r13d, 20(%rsp)
	jns	.L47
.L126:
	addl	$10, %r14d
	movl	%r14d, 20(%rsp)
	jmp	.L47
.L14:
	movq	%rdx, %rdi
	movq	-64(%rsp), %r8
	shrq	%rdi
	leal	63(%rdi), %ecx
	shrl	$6, %ecx
	movl	%ecx, -92(%rsp)
	jmp	.L15
.L125:
	addl	$29, %r13d
	movl	%r13d, -108(%rsp)
	jmp	.L44
.L124:
	leal	23(%rax), %r8d
	jmp	.L42
.L123:
	leal	5(%rax), %r9d
	.p2align 4,,2
	.p2align 3
	jmp	.L39
.L122:
	leal	12(%rax), %r10d
	.p2align 4,,5
	.p2align 3
	jmp	.L36
.L121:
	addl	$4, %eax
	movl	%eax, -48(%rsp)
	.p2align 4,,2
	.p2align 3
	jmp	.L33
.L120:
	leal	1(%rax), %ebx
	.p2align 4,,2
	.p2align 3
	jmp	.L30
.L119:
	leal	2(%rax), %ebp
	.p2align 4,,2
	.p2align 3
	jmp	.L27
.L118:
	leal	6(%rax), %r12d
	.p2align 4,,5
	.p2align 3
	jmp	.L24
.L117:
	incl	%eax
	movl	%eax, -52(%rsp)
	.p2align 4,,3
	.p2align 3
	jmp	.L21
.L116:
	leal	2(%rax), %esi
	.p2align 4,,3
	.p2align 3
	jmp	.L18
.L102:
	movl	%r12d, %r10d
	.p2align 4,,3
	.p2align 3
	jmp	.L104
.LFE65:
	.size	sieve, .-sieve
	.p2align 4,,15
.globl next_chunk
	.type	next_chunk, @function
next_chunk:
.LFB74:
	movq	128(%rdi), %rax
	ret
.LFE74:
	.size	next_chunk, .-next_chunk
	.p2align 4,,15
.globl free_chunk
	.type	free_chunk, @function
free_chunk:
.LFB76:
	pushq	%rbp
.LCFI13:
	movq	%rsi, %rbp
	pushq	%rbx
.LCFI14:
	movq	%rdi, %rbx
	subq	$8, %rsp
.LCFI15:
	call	pthread_mutex_lock
	movl	160(%rbx), %r9d
	testl	%r9d, %r9d
	je	.L143
	movl	156(%rbx), %r8d
	movq	%rbx, %rcx
	xorl	%esi, %esi
	.p2align 4,,10
	.p2align 3
.L145:
	movl	168(%rcx), %edx
	cmpl	%edx, %r8d
	jbe	.L144
	movq	176(%rcx), %rdi
	cmpq	%rbp, %rdi
	ja	.L144
	mov	152(%rbx), %eax
	leaq	(%rdi,%rax,2), %rax
	cmpq	%rax, %rbp
	jb	.L148
.L144:
	incl	%esi
	addq	$24, %rcx
	cmpl	%esi, %r9d
	ja	.L145
.L143:
	addq	$8, %rsp
	movq	%rbx, %rdi
	popq	%rbx
	popq	%rbp
	jmp	pthread_mutex_unlock
	.p2align 4,,10
	.p2align 3
.L148:
	incl	%edx
	mov	%esi, %eax
	leaq	(%rax,%rax,2), %rax
	movl	%edx, 168(%rbx,%rax,8)
	cmpl	156(%rbx), %edx
	jne	.L143
	movzbl	136(%rbx), %edx
	leal	1(%rdx), %eax
	testb	%dl, %dl
	movb	%al, 136(%rbx)
	jne	.L143
	leaq	80(%rbx), %rdi
	call	pthread_cond_broadcast
	jmp	.L143
.LFE76:
	.size	free_chunk, .-free_chunk
	.p2align 4,,15
.globl get_chunk
	.type	get_chunk, @function
get_chunk:
.LFB75:
	pushq	%r15
.LCFI16:
	pushq	%r14
.LCFI17:
	pushq	%r13
.LCFI18:
	pushq	%r12
.LCFI19:
	pushq	%rbp
.LCFI20:
	pushq	%rbx
.LCFI21:
	movq	%rdi, %rbx
	subq	$24, %rsp
.LCFI22:
	movq	%rsi, 16(%rsp)
	call	pthread_mutex_lock
	cmpb	$0, 139(%rbx)
	jne	.L150
	leaq	40(%rbx), %r14
	leaq	80(%rbx), %rbp
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L153:
	movzbl	137(%rbx), %esi
	cmpl	160(%rbx), %esi
	jne	.L156
.L152:
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	call	pthread_cond_wait
	cmpb	$0, 139(%rbx)
	jne	.L150
.L151:
	cmpb	$0, 138(%rbx)
	jne	.L153
	cmpb	$0, 136(%rbx)
	je	.L153
	movq	%r14, %rdi
	call	pthread_mutex_trylock
	testl	%eax, %eax
	jne	.L153
	movl	160(%rbx), %esi
	testl	%esi, %esi
	je	.L154
	movl	156(%rbx), %ecx
	xorl	%r13d, %r13d
	movq	%rbx, %rdx
	cmpl	%ecx, 168(%rbx)
	jne	.L155
	jmp	.L154
	.p2align 4,,10
	.p2align 3
.L158:
	movl	192(%rdx), %eax
	addq	$24, %rdx
	cmpl	%ecx, %eax
	je	.L157
.L155:
	incl	%r13d
	cmpl	%esi, %r13d
	jb	.L158
.L157:
	movq	%rbx, %rdi
	call	pthread_mutex_unlock
	movl	144(%rbx), %ecx
	mov	%r13d, %eax
	leaq	264(%rbx), %rdi
	movq	%rax, (%rsp)
	leaq	(%rax,%rax,2), %rax
	salq	$3, %rax
	leaq	(%rbx,%rax), %r15
	leaq	176(%rbx,%rax), %rsi
	leaq	184(%r15), %rdx
	movq	%rdx, 8(%rsp)
	movq	184(%r15), %rdx
	call	sieve
	movq	%rbx, %rdi
	movl	%eax, %r12d
	call	pthread_mutex_lock
	movl	152(%rbx), %eax
	addl	%eax, %eax
	mov	%eax, %eax
	addq	176(%r15), %rax
	cmpq	%rax, 272(%rbx)
	ja	.L159
	movl	140(%rbx), %esi
	leal	-1(%r12), %ecx
	xorl	%edx, %edx
	movl	%ecx, %eax
	movb	$1, 138(%rbx)
	divl	%esi
	movl	%eax, %edi
	leal	1(%rdi), %ecx
	imull	%esi, %ecx
	cmpl	%ecx, %r12d
	jae	.L160
	movq	8(%rsp), %rsi
	movq	(%rsi), %rax
	.p2align 4,,10
	.p2align 3
.L174:
	mov	%r12d, %edx
	incl	%r12d
	movq	$0, (%rax,%rdx,8)
	cmpl	%r12d, %ecx
	ja	.L174
.L160:
	movq	(%rsp), %rdx
	notl	%edi
	leaq	(%rdx,%rdx,2), %rax
	addl	156(%rbx), %edi
	leaq	160(%rbx,%rax,8), %rax
	movl	%edi, 8(%rax)
	movl	$0, 12(%rax)
	jmp	.L162
.L159:
	leaq	160(%r15), %rax
	movl	$0, 8(%rax)
	movl	$0, 12(%rax)
.L162:
	decb	136(%rbx)
	movzbl	137(%rbx), %eax
	cmpl	160(%rbx), %eax
	je	.L177
.L163:
	movq	%r14, %rdi
	call	pthread_mutex_unlock
	movq	%rbp, %rdi
	call	pthread_cond_broadcast
	movzbl	137(%rbx), %esi
	.p2align 4,,10
	.p2align 3
.L156:
	movq	128(%rbx), %rbp
	movl	140(%rbx), %eax
	mov	%esi, %edx
	leaq	(%rdx,%rdx,2), %rdx
	leaq	(%rbx,%rdx,8), %rdx
	leaq	160(%rdx), %rcx
	imull	12(%rcx), %eax
	salq	$3, %rax
	addq	184(%rdx), %rax
	movq	16(%rsp), %rdx
	movq	%rax, (%rdx)
	movl	12(%rcx), %eax
	leal	1(%rax), %edi
	movl	%edi, 12(%rcx)
	movl	148(%rbx), %eax
	addl	%eax, %eax
	mov	%eax, %ecx
	addq	%rbp, %rcx
	movq	%rcx, 128(%rbx)
	cmpq	272(%rbx), %rcx
	jae	.L178
	cmpl	156(%rbx), %edi
	jne	.L165
	leal	1(%rsi), %edx
	movl	160(%rbx), %r8d
	movl	$0, %eax
	cmpl	%r8d, %edx
	cmove	%eax, %edx
.L166:
	cmpl	%esi, %edx
	jne	.L176
	jmp	.L171
	.p2align 4,,10
	.p2align 3
.L172:
	movl	%eax, %edx
.L176:
	mov	%edx, %eax
	leaq	(%rax,%rax,2), %rax
	leaq	(%rbx,%rax,8), %rax
	cmpl	168(%rax), %edi
	jbe	.L167
	cmpq	176(%rax), %rcx
	je	.L168
.L167:
	leal	1(%rdx), %eax
	xorl	%edx, %edx
	cmpl	%eax, %r8d
	je	.L166
	cmpl	%esi, %eax
	jne	.L172
.L171:
	movb	%r8b, 137(%rbx)
	jmp	.L165
	.p2align 4,,10
	.p2align 3
.L178:
	movb	$1, 139(%rbx)
.L165:
	movq	%rbx, %rdi
	call	pthread_mutex_unlock
	addq	$24, %rsp
	movq	%rbp, %rax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L150:
	movq	272(%rbx), %rbp
	jmp	.L165
.L168:
	movb	%dl, 137(%rbx)
	jmp	.L165
.L177:
	movb	%r13b, 137(%rbx)
	jmp	.L163
.L154:
	xorl	%r13d, %r13d
	jmp	.L157
.LFE75:
	.size	get_chunk, .-get_chunk
	.p2align 4,,15
.globl destroy_sieve
	.type	destroy_sieve, @function
destroy_sieve:
.LFB73:
	pushq	%rbp
.LCFI23:
	movq	%rdi, %rbp
	pushq	%rbx
.LCFI24:
	subq	$8, %rsp
.LCFI25:
	call	pthread_mutex_destroy
	leaq	40(%rbp), %rdi
	call	pthread_mutex_destroy
	leaq	80(%rbp), %rdi
	call	pthread_cond_destroy
	movl	160(%rbp), %ebx
	testl	%ebx, %ebx
	je	.L180
.L183:
	decl	%ebx
	mov	%ebx, %eax
	leaq	(%rax,%rax,2), %rax
	movq	184(%rbp,%rax,8), %rdi
	call	free
	testl	%ebx, %ebx
	jne	.L183
.L180:
	addq	$8, %rsp
	movq	%rbp, %rdi
	popq	%rbx
	popq	%rbp
	jmp	free
.LFE73:
	.size	destroy_sieve, .-destroy_sieve
	.p2align 4,,15
.globl free_sieve_primes
	.type	free_sieve_primes, @function
free_sieve_primes:
.LFB68:
	subq	$8, %rsp
.LCFI26:
	movq	sieve_primes(%rip), %rdi
	testq	%rdi, %rdi
	je	.L187
	call	free
	movq	$0, sieve_primes(%rip)
.L187:
	addq	$8, %rsp
	ret
.LFE68:
	.size	free_sieve_primes, .-free_sieve_primes
	.p2align 4,,15
.globl create_gfn_sieve
	.type	create_gfn_sieve, @function
create_gfn_sieve:
.LFB72:
	pushq	%r15
.LCFI27:
	pushq	%r14
.LCFI28:
	movq	%rsi, %r14
	pushq	%r13
.LCFI29:
	orq	$1, %r14
	pushq	%r12
.LCFI30:
	movl	%edx, %r13d
	pushq	%rbp
.LCFI31:
	movq	%rdi, %rbp
	pushq	%rbx
.LCFI32:
	orq	$1, %rbp
	subq	$24, %rsp
.LCFI33:
	testl	%ecx, %ecx
	movl	%r8d, 12(%rsp)
	movl	%r9d, 8(%rsp)
	je	.L218
	movl	num_sieve_primes(%rip), %edx
	movq	sieve_primes(%rip), %rsi
.L189:
	movl	64(%rsi), %eax
	movl	%edx, %ebx
	testl	%edx, %edx
	je	.L190
	cmpl	%eax, %ecx
	leal	-1(%rbx), %edx
	cmovb	%eax, %ecx
	mov	%edx, %eax
	cmpl	(%rsi,%rax,4), %ecx
	jb	.L219
	jmp	.L191
	.p2align 4,,10
	.p2align 3
.L193:
	leal	-1(%rbx), %edx
	mov	%edx, %eax
	cmpl	%ecx, (%rsi,%rax,4)
	jbe	.L191
.L219:
	movl	%edx, %ebx
	testl	%edx, %edx
	jne	.L193
.L190:
	movl	$288, %edi
	call	xmalloc
	movq	%rax, %r12
	movq	%rbp, 264(%rax)
	movq	%r14, 272(%rax)
	movl	$0, 280(%rax)
	movl	$0, 284(%rax)
.L213:
	xorl	%esi, %esi
	movq	%r12, %rdi
	movl	$2, %r14d
	call	pthread_mutex_init
	xorl	%esi, %esi
	leaq	40(%r12), %rdi
	call	pthread_mutex_init
	xorl	%esi, %esi
	leaq	80(%r12), %rdi
	call	pthread_cond_init
	movl	$2, %eax
	cmpl	$1, 80(%rsp)
	jbe	.L205
	movl	$4, %r14d
	cmpl	$4, 80(%rsp)
	cmovbe	80(%rsp), %r14d
	movl	%r14d, %eax
.L205:
	movb	%al, 136(%r12)
	movb	%al, 137(%r12)
	movb	$0, 138(%r12)
	movb	$0, 139(%r12)
	movq	%rbp, 128(%r12)
	movl	8(%rsp), %ecx
	movl	12(%rsp), %r8d
	andl	$-8, %ecx
	andl	$-8, %r8d
	cmpl	$15, %r8d
	ja	.L206
	movl	$16, %r8d
	movl	$2, %esi
.L207:
	movl	%ecx, %eax
	shrl	%eax
	cmpl	%eax, %r8d
	jbe	.L208
	leal	(%r8,%r8), %ecx
	movl	%ecx, %eax
	shrl	%eax
.L209:
	movl	$2, %r13d
	cmpl	%eax, %r8d
	jbe	.L210
.L211:
	movl	%esi, 140(%r12)
	movl	%r13d, %eax
	movl	%r13d, 156(%r12)
	imull	%esi, %eax
	movl	%r14d, 160(%r12)
	movl	%eax, 144(%r12)
	sall	$6, %esi
	sall	$6, %eax
	movl	%esi, 148(%r12)
	movl	%eax, 152(%r12)
	movq	%r12, %rbx
	xorl	%ebp, %ebp
.L212:
	movl	%r13d, 168(%rbx)
	movl	%r13d, 172(%rbx)
	movq	$0, 176(%rbx)
	mov	144(%r12), %edi
	incl	%ebp
	salq	$3, %rdi
	call	xmalloc
	movq	%rax, 184(%rbx)
	addq	$24, %rbx
	cmpl	%ebp, %r14d
	ja	.L212
	addq	$24, %rsp
	movq	%r12, %rax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L208:
	cmpl	$268435456, %ecx
	ja	.L220
.L210:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%r8d
	movl	%eax, %r13d
	jmp	.L211
.L206:
	movl	%r8d, %esi
	shrl	$3, %esi
	jmp	.L207
.L218:
	movl	num_sieve_primes(%rip), %edx
	movq	sieve_primes(%rip), %rsi
	leal	-1(%rdx), %eax
	movl	(%rsi,%rax,4), %ecx
	jmp	.L189
.L220:
	movl	$268435456, %ecx
	movl	$134217728, %eax
	jmp	.L209
.L191:
	mov	%ebx, %edi
	leaq	288(,%rdi,4), %rdi
	call	xmalloc
	movl	%r13d, %ecx
	movq	%r14, 272(%rax)
	movq	%rax, %r12
	movq	%rbp, 264(%rax)
	movl	%ebx, 280(%rax)
	movl	%ebx, 284(%rax)
	movq	sieve_primes(%rip), %r14
	movq	%rbp, %rax
	xorl	%r11d, %r11d
	salq	%cl, %rax
	xorl	%r10d, %r10d
	movq	%rax, %r15
	incq	%rax
	shrq	%cl, %r15
	movq	%rax, 16(%rsp)
	.p2align 4,,10
	.p2align 3
.L203:
	movl	(%r14,%r10), %r9d
	movl	$1, %r8d
	mov	%r9d, %edi
	testl	%r13d, %r13d
	je	.L195
	leal	1(%r9), %eax
	mov	%r9d, %edi
	shrl	%eax
	movl	%r13d, %esi
	movl	$1, %r8d
	jmp	.L198
	.p2align 4,,10
	.p2align 3
.L221:
	imulq	%rcx, %rcx
	xorl	%edx, %edx
	movq	%rcx, %rax
	divq	%rdi
	movl	%edx, %eax
.L198:
	mov	%eax, %ecx
	testb	$1, %sil
	je	.L197
	mov	%eax, %ecx
	xorl	%edx, %edx
	mov	%r8d, %eax
	imulq	%rcx, %rax
	divq	%rdi
	movl	%edx, %r8d
.L197:
	shrl	%esi
	jne	.L221
.L195:
	xorl	%edx, %edx
	movl	%r9d, %esi
	movq	%rbp, %rax
	subl	%r8d, %esi
	divq	%rdi
	movl	%edx, %ecx
	cmpl	%edx, %esi
	jb	.L199
	movl	%esi, %edx
	subl	%ecx, %edx
.L200:
	testb	$1, %dl
	leal	(%rdx,%r9), %eax
	cmovne	%eax, %edx
	shrl	%edx
	cmpl	$31, %r13d
	ja	.L202
	cmpq	%rbp, %r15
	je	.L222
.L202:
	movl	%edx, 288(%r12,%r10)
	incl	%r11d
	addq	$4, %r10
	cmpl	%r11d, %ebx
	ja	.L203
	jmp	.L213
	.p2align 4,,10
	.p2align 3
.L199:
	leal	(%rsi,%r9), %edx
	subl	%ecx, %edx
	jmp	.L200
	.p2align 4,,10
	.p2align 3
.L222:
	leal	(%rdx,%r9), %eax
	cmpq	%rdi, 16(%rsp)
	cmovbe	%eax, %edx
	jmp	.L202
.LFE72:
	.size	create_gfn_sieve, .-create_gfn_sieve
	.p2align 4,,15
.globl create_sieve
	.type	create_sieve, @function
create_sieve:
.LFB69:
	pushq	%r15
.LCFI34:
	movq	%rdi, %rax
	pushq	%r14
.LCFI35:
	orq	$1, %rax
	pushq	%r13
.LCFI36:
	movl	%r9d, %r15d
	pushq	%r12
.LCFI37:
	movl	$3, %r13d
	pushq	%rbp
.LCFI38:
	movq	%rsi, %rbp
	pushq	%rbx
.LCFI39:
	subq	$8, %rsp
.LCFI40:
	cmpq	$1, %rdi
	movl	%ecx, 4(%rsp)
	cmova	%rax, %r13
	movl	%r8d, (%rsp)
	orq	$1, %rbp
	testl	%edx, %edx
	jne	.L226
	movabsq	$4611686014132420609, %rax
	movl	$2147483647, %edx
	cmpq	%rax, %rbp
	jbe	.L245
.L226:
	movq	sieve_primes(%rip), %rsi
	movl	num_sieve_primes(%rip), %ebx
	movl	64(%rsi), %eax
	testl	%ebx, %ebx
	je	.L230
	cmpl	%eax, %edx
	leal	-1(%rbx), %ecx
	cmovb	%eax, %edx
	mov	%ecx, %eax
	cmpl	(%rsi,%rax,4), %edx
	jb	.L244
	jmp	.L230
	.p2align 4,,10
	.p2align 3
.L232:
	leal	-1(%rbx), %ecx
	mov	%ecx, %eax
	cmpl	%edx, (%rsi,%rax,4)
	jbe	.L230
.L244:
	movl	%ecx, %ebx
	testl	%ecx, %ecx
	jne	.L232
.L230:
	mov	%ebx, %edi
	movl	$2, %r14d
	leaq	288(,%rdi,4), %rdi
	call	xmalloc
	movq	%rax, %r12
	leaq	264(%rax), %rdi
	movq	%r13, 264(%rax)
	movq	%rbp, 272(%rax)
	movl	%ebx, 280(%rax)
	movl	$17, 284(%rax)
	call	init_residues
	xorl	%esi, %esi
	movq	%r12, %rdi
	call	pthread_mutex_init
	xorl	%esi, %esi
	leaq	40(%r12), %rdi
	call	pthread_mutex_init
	xorl	%esi, %esi
	leaq	80(%r12), %rdi
	call	pthread_cond_init
	movl	$2, %eax
	cmpl	$1, %r15d
	jbe	.L234
	movl	$4, %r14d
	cmpl	$4, %r15d
	cmovbe	%r15d, %r14d
	movl	%r14d, %eax
.L234:
	movb	%al, 136(%r12)
	movb	%al, 137(%r12)
	movb	$0, 138(%r12)
	movb	$0, 139(%r12)
	movq	%r13, 128(%r12)
	movl	(%rsp), %ecx
	movl	4(%rsp), %edi
	andl	$-8, %ecx
	andl	$-8, %edi
	cmpl	$15, %edi
	ja	.L235
	movl	$16, %edi
	movl	$2, %esi
.L236:
	movl	%ecx, %eax
	shrl	%eax
	cmpl	%eax, %edi
	jbe	.L237
	leal	(%rdi,%rdi), %ecx
	movl	%ecx, %eax
	shrl	%eax
.L238:
	movl	$2, %r13d
	cmpl	%eax, %edi
	jbe	.L239
.L240:
	movl	%esi, 140(%r12)
	movl	%r13d, %eax
	movl	%r13d, 156(%r12)
	imull	%esi, %eax
	movl	%r14d, 160(%r12)
	movl	%eax, 144(%r12)
	sall	$6, %esi
	sall	$6, %eax
	movl	%esi, 148(%r12)
	movl	%eax, 152(%r12)
	movq	%r12, %rbx
	xorl	%ebp, %ebp
.L241:
	movl	%r13d, 168(%rbx)
	movl	%r13d, 172(%rbx)
	movq	$0, 176(%rbx)
	mov	144(%r12), %edi
	incl	%ebp
	salq	$3, %rdi
	call	xmalloc
	movq	%rax, 184(%rbx)
	addq	$24, %rbx
	cmpl	%ebp, %r14d
	ja	.L241
	addq	$8, %rsp
	movq	%r12, %rax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L237:
	cmpl	$268435456, %ecx
	ja	.L246
.L239:
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%edi
	movl	%eax, %r13d
	jmp	.L240
	.p2align 4,,10
	.p2align 3
.L235:
	movl	%edi, %esi
	shrl	$3, %esi
	jmp	.L236
	.p2align 4,,10
	.p2align 3
.L246:
	movl	$268435456, %ecx
	movl	$134217728, %eax
	jmp	.L238
	.p2align 4,,10
	.p2align 3
.L245:
	testq	%rbp, %rbp
	js	.L228
	cvtsi2sdq	%rbp, %xmm0
.L229:
	sqrtsd	%xmm0, %xmm0
	cvttsd2siq	%xmm0, %rdx
	jmp	.L226
.L228:
	movq	%rbp, %rax
	shrq	%rax
	orq	$1, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L229
.LFE69:
	.size	create_sieve, .-create_sieve
.globl __popcountdi2
	.p2align 4,,15
.globl init_sieve_primes
	.type	init_sieve_primes, @function
init_sieve_primes:
.LFB67:
	pushq	%r15
.LCFI41:
	pushq	%r14
.LCFI42:
	pushq	%r13
.LCFI43:
	pushq	%r12
.LCFI44:
	pushq	%rbp
.LCFI45:
	pushq	%rbx
.LCFI46:
	subq	$19384, %rsp
.LCFI47:
	movq	%fs:40, %rax
	movq	%rax, 19368(%rsp)
	xorl	%eax, %eax
	movl	%edi, 12(%rsp)
	cmpq	$0, sieve_primes(%rip)
	je	.L294
.L248:
	movl	12(%rsp), %eax
	andl	$1, %eax
	cmpl	$1, %eax
	movl	lim_sieve_primes(%rip), %eax
	sbbl	$-1, 12(%rsp)
	cmpl	12(%rsp), %eax
	jb	.L295
.L284:
	movq	19368(%rsp), %rbx
	xorq	%fs:40, %rbx
	jne	.L296
	addq	$19384, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L295:
	mov	%eax, %eax
	movl	$3, %ebp
	movq	%rax, %rdx
	mov	12(%rsp), %r15d
	orq	$1, %rdx
	movq	sieve_primes(%rip), %rsi
	cmpq	$1, %rax
	movl	num_sieve_primes(%rip), %ebx
	cmova	%rdx, %rbp
	movl	64(%rsi), %eax
	orq	$1, %r15
	testl	%ebx, %ebx
	cvtsi2sdq	%r15, %xmm0
	sqrtsd	%xmm0, %xmm0
	cvttsd2siq	%xmm0, %rdx
	je	.L262
	cmpl	%eax, %edx
	movl	%eax, %edi
	cmovae	%edx, %edi
	leal	-1(%rbx), %edx
	mov	%edx, %eax
	cmpl	(%rsi,%rax,4), %edi
	jb	.L292
	jmp	.L262
	.p2align 4,,10
	.p2align 3
.L265:
	leal	-1(%rdx), %ecx
	mov	%ecx, %eax
	cmpl	%edi, (%rsi,%rax,4)
	jbe	.L264
	movl	%ecx, %edx
.L292:
	testl	%edx, %edx
	jne	.L265
.L264:
	movl	%edx, %ebx
.L262:
	mov	%ebx, %edi
	leaq	16(%rsp), %r13
	leaq	24(,%rdi,4), %rdi
	call	xmalloc
	movq	%rbp, (%rax)
	movq	%rax, %r14
	movq	%r15, 8(%rax)
	movl	%ebx, 16(%rax)
	movl	$17, 20(%rax)
	movq	%rax, %rdi
	xorl	%ebp, %ebp
	call	init_residues
.L266:
	movl	$2048, %ecx
	movq	%r13, %rdx
	leaq	19304(%rsp), %rsi
	movq	%r14, %rdi
	call	sieve
	movl	%eax, %r12d
	testl	%eax, %eax
	je	.L297
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L267:
	movq	(%r13,%rbx,8), %rdi
	incq	%rbx
	call	__popcountdi2
	addl	%eax, %ebp
	cmpl	%ebx, %r12d
	ja	.L267
	jmp	.L266
.L297:
	movq	%r14, %rdi
	movl	$3, %r12d
	call	free
	movl	num_sieve_primes(%rip), %esi
	movq	sieve_primes(%rip), %rdi
	leal	1(%rbp,%rsi), %esi
	salq	$2, %rsi
	call	xrealloc
	cvtsi2sdq	%r15, %xmm0
	movq	%rax, sieve_primes(%rip)
	sqrtsd	%xmm0, %xmm0
	mov	lim_sieve_primes(%rip), %eax
	movq	sieve_primes(%rip), %rsi
	movq	%rax, %rdx
	movl	num_sieve_primes(%rip), %ebx
	orq	$1, %rdx
	cmpq	$1, %rax
	movl	64(%rsi), %eax
	cmova	%rdx, %r12
	cvttsd2siq	%xmm0, %rdx
	testl	%ebx, %ebx
	je	.L275
	cmpl	%eax, %edx
	movl	%eax, %edi
	cmovae	%edx, %edi
	leal	-1(%rbx), %edx
	mov	%edx, %eax
	cmpl	(%rsi,%rax,4), %edi
	jb	.L293
	jmp	.L275
	.p2align 4,,10
	.p2align 3
.L278:
	leal	-1(%rdx), %ecx
	mov	%ecx, %eax
	cmpl	(%rsi,%rax,4), %edi
	jae	.L277
	movl	%ecx, %edx
.L293:
	testl	%edx, %edx
	jne	.L278
.L277:
	movl	%edx, %ebx
.L275:
	mov	%ebx, %edi
	leaq	24(,%rdi,4), %rdi
	call	xmalloc
	movl	%ebx, 16(%rax)
	movq	%rax, %rbp
	movq	%r12, (%rax)
	movq	%r15, 8(%rax)
	movl	$17, 20(%rax)
	movq	%rax, %rdi
	call	init_residues
	movl	num_sieve_primes(%rip), %ebx
.L279:
	movl	$2048, %ecx
	movq	%r13, %rdx
	leaq	19304(%rsp), %rsi
	movq	%rbp, %rdi
	call	sieve
	movl	%eax, %r11d
	testl	%eax, %eax
	je	.L283
	movq	sieve_primes(%rip), %r10
	movl	19304(%rsp), %r8d
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L282:
	movq	(%r13,%r9,8), %rax
	testq	%rax, %rax
	je	.L280
	movl	%r9d, %edi
	xorl	%edx, %edx
	sall	$6, %edi
	.p2align 4,,10
	.p2align 3
.L281:
	bsfq	%rax, %rcx
	movq	%rax, %rsi
	shrq	%cl, %rsi
	leal	(%rdx,%rcx), %ecx
	mov	%ebx, %edx
	leal	(%rcx,%rdi), %eax
	incl	%ebx
	leal	(%r8,%rax,2), %eax
	movl	%eax, (%r10,%rdx,4)
	movq	%rsi, %rax
	leal	1(%rcx), %edx
	shrq	%rax
	jne	.L281
.L280:
	incq	%r9
	cmpl	%r9d, %r11d
	ja	.L282
	jmp	.L279
.L283:
	movq	%rbp, %rdi
	.p2align 4,,5
	.p2align 3
	call	free
	movq	sieve_primes(%rip), %rax
	mov	%ebx, %edx
	movl	$-1, (%rax,%rdx,4)
	movl	12(%rsp), %eax
	movl	%ebx, num_sieve_primes(%rip)
	movl	%eax, lim_sieve_primes(%rip)
	jmp	.L284
.L294:
	movb	$3, 19312(%rsp)
	movb	$5, 19313(%rsp)
	movb	$7, 19314(%rsp)
	movb	$11, 19315(%rsp)
	movb	$13, 19316(%rsp)
	movb	$17, 19317(%rsp)
	movb	$19, 19318(%rsp)
	movb	$23, 19319(%rsp)
	movb	$29, 19320(%rsp)
	movb	$31, 19321(%rsp)
	movb	$37, 19322(%rsp)
	movb	$41, 19323(%rsp)
	movb	$43, 19324(%rsp)
	movb	$47, 19325(%rsp)
	movb	$53, 19326(%rsp)
	movb	$59, 19327(%rsp)
	movb	$61, 19328(%rsp)
	movb	$67, 19329(%rsp)
	movb	$71, 19330(%rsp)
	movb	$73, 19331(%rsp)
	movb	$79, 19332(%rsp)
	movb	$83, 19333(%rsp)
	movb	$89, 19334(%rsp)
	movb	$97, 19335(%rsp)
	movb	$101, 19336(%rsp)
	movb	$103, 19337(%rsp)
	movb	$107, 19338(%rsp)
	movb	$109, 19339(%rsp)
	movb	$113, 19340(%rsp)
	movb	$127, 19341(%rsp)
	movb	$-125, 19342(%rsp)
	movb	$-119, 19343(%rsp)
	movb	$-117, 19344(%rsp)
	leaq	16400(%rsp), %rdi
	movb	$-107, 19345(%rsp)
	movl	$2896, %edx
	movb	$-105, 19346(%rsp)
	movb	$-99, 19347(%rsp)
	movb	$-93, 19348(%rsp)
	movb	$-89, 19349(%rsp)
	movb	$-83, 19350(%rsp)
	movb	$-77, 19351(%rsp)
	movb	$-75, 19352(%rsp)
	movb	$-65, 19353(%rsp)
	movb	$-63, 19354(%rsp)
	movb	$-59, 19355(%rsp)
	movb	$-57, 19356(%rsp)
	movb	$-45, 19357(%rsp)
	movl	$-1, %esi
	call	memset
	leaq	19312(%rsp), %r8
	movl	$1, %r9d
	leaq	46(%r8), %r10
.L251:
	movzbl	(%r8), %edi
	leal	-3(%rdi), %eax
	shrl	%eax
	leal	(%rax,%rdi), %edx
	cmpl	$23167, %edx
	ja	.L249
	leal	(%rdi,%rdx), %esi
	.p2align 4,,10
	.p2align 3
.L250:
	movl	%edx, %eax
	movl	%edx, %ecx
	shrl	$6, %eax
	andl	$63, %ecx
	mov	%eax, %eax
	addl	%edi, %esi
	movq	%r9, %rbx
	addl	%edi, %edx
	salq	%cl, %rbx
	movq	%rbx, %rcx
	notq	%rcx
	andq	%rcx, 16400(%rsp,%rax,8)
	movl	%esi, %eax
	subl	%edi, %eax
	cmpl	$23167, %eax
	jbe	.L250
.L249:
	incq	%r8
	cmpq	%r10, %r8
	jne	.L251
	movl	$19168, %edi
	call	xmalloc
	xorl	%edx, %edx
	movq	%rax, %r8
	movq	%rax, sieve_primes(%rip)
	xorl	%edi, %edi
	movl	$3, %esi
.L253:
	movl	%edx, %eax
	movl	%edx, %ecx
	shrl	$6, %eax
	andl	$63, %ecx
	mov	%eax, %eax
	movq	16400(%rsp,%rax,8), %rax
	shrq	%cl, %rax
	testb	$1, %al
	je	.L252
	mov	%edi, %eax
	incl	%edi
	movl	%esi, (%r8,%rax,4)
.L252:
	incl	%edx
	addl	$2, %esi
	cmpl	$23168, %edx
	jne	.L253
	movl	$-1, 19164(%r8)
	movl	$4791, num_sieve_primes(%rip)
	movl	$46348, lim_sieve_primes(%rip)
	jmp	.L248
.L296:
	call	__stack_chk_fail
.LFE67:
	.size	init_sieve_primes, .-init_sieve_primes
.globl sieve_primes
	.bss
	.align 8
	.type	sieve_primes, @object
	.size	sieve_primes, 8
sieve_primes:
	.zero	8
.globl num_sieve_primes
	.align 4
	.type	num_sieve_primes, @object
	.size	num_sieve_primes, 4
num_sieve_primes:
	.zero	4
	.local	lim_sieve_primes
	.comm	lim_sieve_primes,4,4
	.section	.eh_frame,"a",@progbits
.Lframe1:
	.long	.LECIE1-.LSCIE1
.LSCIE1:
	.long	0x0
	.byte	0x1
	.string	"zR"
	.uleb128 0x1
	.sleb128 -8
	.byte	0x10
	.uleb128 0x1
	.byte	0x3
	.byte	0xc
	.uleb128 0x7
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x1
	.align 8
.LECIE1:
.LSFDE1:
	.long	.LEFDE1-.LASFDE1
.LASFDE1:
	.long	.LASFDE1-.Lframe1
	.long	.LFB63
	.long	.LFE63-.LFB63
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB63
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI1-.LCFI0
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI2-.LCFI1
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI3-.LCFI2
	.byte	0xe
	.uleb128 0x28
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI4-.LCFI3
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI5-.LCFI4
	.byte	0xe
	.uleb128 0x38
	.byte	0x83
	.uleb128 0x7
	.byte	0x86
	.uleb128 0x6
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB65
	.long	.LFE65-.LFB65
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI6-.LFB65
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI7-.LCFI6
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI8-.LCFI7
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI9-.LCFI8
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI10-.LCFI9
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI11-.LCFI10
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI12-.LCFI11
	.byte	0xe
	.uleb128 0x80
	.byte	0x83
	.uleb128 0x7
	.byte	0x86
	.uleb128 0x6
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB74
	.long	.LFE74-.LFB74
	.uleb128 0x0
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB76
	.long	.LFE76-.LFB76
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI13-.LFB76
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI14-.LCFI13
	.byte	0xe
	.uleb128 0x18
	.byte	0x83
	.uleb128 0x3
	.byte	0x4
	.long	.LCFI15-.LCFI14
	.byte	0xe
	.uleb128 0x20
	.align 8
.LEFDE7:
.LSFDE9:
	.long	.LEFDE9-.LASFDE9
.LASFDE9:
	.long	.LASFDE9-.Lframe1
	.long	.LFB75
	.long	.LFE75-.LFB75
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI16-.LFB75
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI17-.LCFI16
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI18-.LCFI17
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI19-.LCFI18
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI20-.LCFI19
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI21-.LCFI20
	.byte	0xe
	.uleb128 0x38
	.byte	0x83
	.uleb128 0x7
	.byte	0x86
	.uleb128 0x6
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI22-.LCFI21
	.byte	0xe
	.uleb128 0x50
	.align 8
.LEFDE9:
.LSFDE11:
	.long	.LEFDE11-.LASFDE11
.LASFDE11:
	.long	.LASFDE11-.Lframe1
	.long	.LFB73
	.long	.LFE73-.LFB73
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI23-.LFB73
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI24-.LCFI23
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI25-.LCFI24
	.byte	0xe
	.uleb128 0x20
	.byte	0x83
	.uleb128 0x3
	.align 8
.LEFDE11:
.LSFDE13:
	.long	.LEFDE13-.LASFDE13
.LASFDE13:
	.long	.LASFDE13-.Lframe1
	.long	.LFB68
	.long	.LFE68-.LFB68
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI26-.LFB68
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE13:
.LSFDE15:
	.long	.LEFDE15-.LASFDE15
.LASFDE15:
	.long	.LASFDE15-.Lframe1
	.long	.LFB72
	.long	.LFE72-.LFB72
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI27-.LFB72
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI28-.LCFI27
	.byte	0xe
	.uleb128 0x18
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI29-.LCFI28
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI30-.LCFI29
	.byte	0xe
	.uleb128 0x28
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.byte	0x4
	.long	.LCFI31-.LCFI30
	.byte	0xe
	.uleb128 0x30
	.byte	0x86
	.uleb128 0x6
	.byte	0x4
	.long	.LCFI32-.LCFI31
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI33-.LCFI32
	.byte	0xe
	.uleb128 0x50
	.byte	0x83
	.uleb128 0x7
	.align 8
.LEFDE15:
.LSFDE17:
	.long	.LEFDE17-.LASFDE17
.LASFDE17:
	.long	.LASFDE17-.Lframe1
	.long	.LFB69
	.long	.LFE69-.LFB69
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI34-.LFB69
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI35-.LCFI34
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI36-.LCFI35
	.byte	0xe
	.uleb128 0x20
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI37-.LCFI36
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI38-.LCFI37
	.byte	0xe
	.uleb128 0x30
	.byte	0x86
	.uleb128 0x6
	.byte	0x8c
	.uleb128 0x5
	.byte	0x4
	.long	.LCFI39-.LCFI38
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI40-.LCFI39
	.byte	0xe
	.uleb128 0x40
	.byte	0x83
	.uleb128 0x7
	.align 8
.LEFDE17:
.LSFDE19:
	.long	.LEFDE19-.LASFDE19
.LASFDE19:
	.long	.LASFDE19-.Lframe1
	.long	.LFB67
	.long	.LFE67-.LFB67
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI41-.LFB67
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI42-.LCFI41
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI43-.LCFI42
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI44-.LCFI43
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI45-.LCFI44
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI46-.LCFI45
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI47-.LCFI46
	.byte	0xe
	.uleb128 0x4bf0
	.byte	0x83
	.uleb128 0x7
	.byte	0x86
	.uleb128 0x6
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.align 8
.LEFDE19:
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
