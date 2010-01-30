	.file	"util.c"
	.text
	.p2align 4,,15
.globl parse_uint64
	.type	parse_uint64, @function
parse_uint64:
.LFB62:
	movq	%rbx, -48(%rsp)
.LCFI0:
	movq	%rbp, -40(%rsp)
.LCFI1:
	movq	%rsi, %rbx
	movq	%r12, -32(%rsp)
.LCFI2:
	movq	%r13, -24(%rsp)
.LCFI3:
	movq	%r14, -16(%rsp)
.LCFI4:
	movq	%r15, -8(%rsp)
.LCFI5:
	movq	%rdx, %r14
	subq	$72, %rsp
.LCFI6:
	movq	%rdi, %r15
	movq	%rcx, %r13
	leaq	16(%rsp), %r12
	call	__errno_location
	xorl	%edx, %edx
	movq	%rax, %rbp
	movq	%r12, %rsi
	movq	%rbx, %rdi
	movl	$0, (%rax)
	call	strtoull
	movl	(%rbp), %esi
	movq	%rax, %rbx
	testl	%esi, %esi
	jne	.L2
	cmpq	%r13, %rax
	jbe	.L36
.L2:
	movl	$-2, %eax
.L32:
	movq	24(%rsp), %rbx
	movq	32(%rsp), %rbp
	movq	40(%rsp), %r12
	movq	48(%rsp), %r13
	movq	56(%rsp), %r14
	movq	64(%rsp), %r15
	addq	$72, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L36:
	movq	16(%rsp), %rcx
	cmpb	$116, (%rcx)
	ja	.L3
	movzbl	(%rcx), %eax
	jmp	*.L17(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L17:
	.quad	.L4
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L5
	.quad	.L3
	.quad	.L3
	.quad	.L6
	.quad	.L3
	.quad	.L7
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L8
	.quad	.L3
	.quad	.L9
	.quad	.L3
	.quad	.L3
	.quad	.L10
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L11
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L5
	.quad	.L3
	.quad	.L3
	.quad	.L6
	.quad	.L3
	.quad	.L12
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L13
	.quad	.L3
	.quad	.L14
	.quad	.L3
	.quad	.L3
	.quad	.L15
	.quad	.L3
	.quad	.L3
	.quad	.L3
	.quad	.L16
	.text
	.p2align 4,,10
	.p2align 3
.L3:
	movl	$-1, %eax
	.p2align 4,,2
	.p2align 3
	jmp	.L32
.L15:
	movl	$20, %eax
.L25:
	addl	$10, %eax
.L20:
	addl	$10, %eax
.L19:
	addl	$10, %eax
.L18:
	cmpb	$0, 1(%rcx)
	jne	.L3
	movl	%eax, %ecx
	shrq	%cl, %r13
	cmpq	%r13, %rbx
	ja	.L2
	salq	%cl, %rbx
.L4:
	cmpq	%r14, %rbx
	jb	.L2
	movq	%rbx, (%r15)
	xorl	%eax, %eax
	jmp	.L32
.L14:
	movl	$10, %eax
	jmp	.L19
.L13:
	movl	$10, %eax
	.p2align 4,,3
	.p2align 3
	jmp	.L18
.L12:
	movl	$10, %eax
	.p2align 4,,5
	.p2align 3
	jmp	.L20
.L16:
	movl	$10, %eax
	.p2align 4,,5
	.p2align 3
	jmp	.L25
.L5:
	xorl	%edx, %edx
	leaq	1(%rcx), %rdi
	movq	%r12, %rsi
	call	strtoul
	movq	%rax, %rdx
	movl	(%rbp), %eax
	testl	%eax, %eax
	jne	.L2
	movq	16(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L3
	movl	%edx, %eax
	testl	%edx, %edx
	je	.L4
	movq	%r13, %rdx
	shrq	%rdx
	cmpq	%rdx, %rbx
	ja	.L2
	decl	%eax
	jmp	.L30
.L31:
	decl	%eax
	cmpq	%rbx, %rdx
	jb	.L2
.L30:
	addq	%rbx, %rbx
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	jne	.L31
	.p2align 4,,4
	.p2align 3
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L7:
	movl	$3, %eax
.L23:
	addl	$3, %eax
.L22:
	leal	3(%rax), %esi
.L21:
	cmpb	$0, 1(%rcx)
	jne	.L3
	testl	%esi, %esi
	je	.L4
	shrq	$3, %r13
	movabsq	$2361183241434822607, %rcx
	movq	%rcx, %rax
	mulq	%r13
	movq	%rdx, %rcx
	shrq	$4, %rcx
	cmpq	%rcx, %rbx
	jbe	.L34
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L27:
	cmpq	%rcx, %rbx
	ja	.L2
.L34:
	imulq	$1000, %rbx, %rbx
	subl	$3, %esi
	.p2align 4,,5
	.p2align 3
	jne	.L27
	.p2align 4,,5
	.p2align 3
	jmp	.L4
.L6:
	xorl	%edx, %edx
	leaq	1(%rcx), %rdi
	movq	%r12, %rsi
	call	strtoul
	movl	(%rbp), %ecx
	movq	%rax, %rdx
	testl	%ecx, %ecx
	jne	.L2
	movq	16(%rsp), %rax
	cmpb	$0, (%rax)
	jne	.L3
	movl	%edx, %esi
	testl	%edx, %edx
	je	.L4
	movabsq	$-3689348814741910323, %rax
	mulq	%r13
	movq	%rdx, %rcx
	leal	-1(%rsi), %edx
	shrq	$3, %rcx
	cmpq	%rcx, %rbx
	jbe	.L28
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L29:
	decl	%edx
	cmpq	%rcx, %rbx
	ja	.L2
.L28:
	leaq	(%rbx,%rbx,4), %rax
	testl	%edx, %edx
	leaq	(%rax,%rax), %rbx
	.p2align 4,,2
	.p2align 3
	jne	.L29
	.p2align 4,,2
	.p2align 3
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L11:
	movl	$3, %eax
.L24:
	addl	$3, %eax
	jmp	.L23
.L10:
	movl	$6, %eax
	.p2align 4,,5
	.p2align 3
	jmp	.L24
.L9:
	movl	$3, %eax
	.p2align 4,,3
	.p2align 3
	jmp	.L22
.L8:
	movl	$3, %esi
	.p2align 4,,5
	.p2align 3
	jmp	.L21
.LFE62:
	.size	parse_uint64, .-parse_uint64
	.p2align 4,,15
.globl parse_uint
	.type	parse_uint, @function
parse_uint:
.LFB61:
	pushq	%rbx
.LCFI7:
	mov	%edx, %edx
	subq	$16, %rsp
.LCFI8:
	movq	%rdi, %rbx
	mov	%ecx, %ecx
	leaq	8(%rsp), %rdi
	call	parse_uint64
	movl	%eax, %edx
	testl	%eax, %eax
	jne	.L38
	movq	8(%rsp), %rax
	movl	%eax, (%rbx)
.L38:
	movl	%edx, %eax
	addq	$16, %rsp
	popq	%rbx
	ret
.LFE61:
	.size	parse_uint, .-parse_uint
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"realloc"
	.text
	.p2align 4,,15
.globl xrealloc
	.type	xrealloc, @function
xrealloc:
.LFB59:
	subq	$8, %rsp
.LCFI9:
	call	realloc
	testq	%rax, %rax
	je	.L43
	addq	$8, %rsp
	ret
.L43:
	movl	$.LC0, %edi
	call	perror
	movl	$1, %edi
	call	exit
.LFE59:
	.size	xrealloc, .-xrealloc
	.section	.rodata.str1.1
.LC1:
	.string	"malloc"
	.text
	.p2align 4,,15
.globl xmalloc
	.type	xmalloc, @function
xmalloc:
.LFB58:
	subq	$8, %rsp
.LCFI10:
	call	malloc
	testq	%rax, %rax
	je	.L47
	addq	$8, %rsp
	ret
.L47:
	movl	$.LC1, %edi
	call	perror
	movl	$1, %edi
	call	exit
.LFE58:
	.size	xmalloc, .-xmalloc
	.p2align 4,,15
.globl xstrdup
	.type	xstrdup, @function
xstrdup:
.LFB60:
	pushq	%rbx
.LCFI11:
	testq	%rdi, %rdi
	movq	%rdi, %rbx
	je	.L53
	call	strlen
	leaq	1(%rax), %rdi
	call	malloc
	testq	%rax, %rax
	je	.L54
	movq	%rbx, %rsi
	movq	%rax, %rdi
	popq	%rbx
	jmp	strcpy
	.p2align 4,,10
	.p2align 3
.L53:
	xorl	%eax, %eax
	popq	%rbx
	ret
.L54:
	movl	$.LC1, %edi
	call	perror
	movl	$1, %edi
	call	exit
.LFE60:
	.size	xstrdup, .-xstrdup
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
	.long	.LFB62
	.long	.LFE62-.LFB62
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI1-.LFB62
	.byte	0x86
	.uleb128 0x6
	.byte	0x83
	.uleb128 0x7
	.byte	0x4
	.long	.LCFI5-.LCFI1
	.byte	0x8f
	.uleb128 0x2
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8d
	.uleb128 0x4
	.byte	0x8c
	.uleb128 0x5
	.byte	0x4
	.long	.LCFI6-.LCFI5
	.byte	0xe
	.uleb128 0x50
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB61
	.long	.LFE61-.LFB61
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI7-.LFB61
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI8-.LCFI7
	.byte	0xe
	.uleb128 0x20
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB59
	.long	.LFE59-.LFB59
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI9-.LFB59
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB58
	.long	.LFE58-.LFB58
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI10-.LFB58
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE7:
.LSFDE9:
	.long	.LEFDE9-.LASFDE9
.LASFDE9:
	.long	.LASFDE9-.Lframe1
	.long	.LFB60
	.long	.LFE60-.LFB60
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI11-.LFB60
	.byte	0xe
	.uleb128 0x10
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE9:
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
