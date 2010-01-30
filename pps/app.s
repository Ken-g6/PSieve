	.file	"app.c"
	.text
	.p2align 4,,15
.globl app_thread_init
	.type	app_thread_init, @function
app_thread_init:
	subl	$16, %esp
#APP
# 496 "app.c" 1
	fnstcw 14(%esp)
# 0 "" 2
#NO_APP
	orw	$3840, 14(%esp)
#APP
# 498 "app.c" 1
	fldcw 14(%esp)
# 0 "" 2
#NO_APP
	addl	$16, %esp
	ret
	.size	app_thread_init, .-app_thread_init
	.p2align 4,,15
.globl app_thread_fini
	.type	app_thread_fini, @function
app_thread_fini:
	rep
	ret
	.size	app_thread_fini, .-app_thread_fini
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"s"
.LC1:
	.string	""
.LC2:
	.string	"Found %u factor%s\n"
	.text
	.p2align 4,,15
.globl app_fini
	.type	app_fini, @function
app_fini:
	pushl	%ebx
	subl	$24, %esp
	movl	factors_file, %eax
	movl	%eax, (%esp)
	call	fclose
	movl	factor_count, %ecx
	movl	$.LC1, %edx
	cmpl	$1, %ecx
	movl	%ecx, 8(%esp)
	movl	$.LC0, %eax
	movl	$.LC2, 4(%esp)
	cmove	%edx, %eax
	movl	$1, (%esp)
	movl	%eax, 12(%esp)
	call	__printf_chk
	movl	$factors_mutex, (%esp)
	call	pthread_mutex_destroy
	movl	bitmap, %eax
	testl	%eax, %eax
	je	.L11
	movl	nmin, %ebx
	cmpl	nmax, %ebx
	ja	.L9
	.p2align 4,,10
	.p2align 3
.L12:
	movl	%ebx, %eax
	movl	bitmap, %edx
	subl	nmin, %eax
	incl	%ebx
	movl	(%edx,%eax,4), %eax
	movl	%eax, (%esp)
	call	free
	cmpl	%ebx, nmax
	jae	.L12
.L9:
	movl	bitmap, %eax
	movl	%eax, (%esp)
	call	free
	movl	$0, bitmap
.L11:
	addl	$24, %esp
	popl	%ebx
	ret
	.size	app_fini, .-app_fini
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC3:
	.string	"nmin=%u,nmax=%u,factor_count=%u\n"
	.text
	.p2align 4,,15
.globl app_write_checkpoint
	.type	app_write_checkpoint, @function
app_write_checkpoint:
	subl	$28, %esp
	movl	factors_file, %eax
	movl	%eax, (%esp)
	call	fflush
	movl	factor_count, %eax
	movl	$.LC3, 8(%esp)
	movl	%eax, 20(%esp)
	movl	$1, 4(%esp)
	movl	nmax, %eax
	movl	%eax, 16(%esp)
	movl	nmin, %eax
	movl	%eax, 12(%esp)
	movl	32(%esp), %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	addl	$28, %esp
	ret
	.size	app_write_checkpoint, .-app_write_checkpoint
	.section	.rodata.str1.4
	.align 4
.LC4:
	.string	"nmin=%u,nmax=%u,factor_count=%u"
	.text
	.p2align 4,,15
.globl app_read_checkpoint
	.type	app_read_checkpoint, @function
app_read_checkpoint:
	subl	$44, %esp
	leal	36(%esp), %eax
	movl	$factor_count, 16(%esp)
	movl	%eax, 12(%esp)
	movl	$.LC4, 4(%esp)
	leal	40(%esp), %eax
	movl	%eax, 8(%esp)
	movl	48(%esp), %eax
	movl	%eax, (%esp)
	call	fscanf
	cmpl	$3, %eax
	je	.L21
.L18:
	xorl	%eax, %eax
	addl	$44, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L21:
	movl	40(%esp), %eax
	cmpl	nmin, %eax
	jne	.L18
	movl	36(%esp), %eax
	cmpl	nmax, %eax
	sete	%al
	addl	$44, %esp
	movzbl	%al, %eax
	ret
	.size	app_read_checkpoint, .-app_read_checkpoint
.globl __udivdi3
	.section	.rodata.str1.1
.LC5:
	.string	"%llu | %llu*2^%u%+d\n"
.LC6:
	.string	"UNSAVED: %llu | %llu*2^%u%+d\n"
	.text
	.p2align 4,,15
	.type	test_factor, @function
test_factor:
	subl	$108, %esp
	movl	%ebx, 92(%esp)
	movl	%esi, 96(%esp)
	movl	%edi, 100(%esp)
	movl	%ebp, 104(%esp)
	movl	%eax, 64(%esp)
	movl	%edx, 68(%esp)
	movl	112(%esp), %ebx
	movl	116(%esp), %esi
	movl	120(%esp), %eax
	movl	124(%esp), %edx
	movl	%eax, 60(%esp)
	movl	%edx, 56(%esp)
	movl	$6, 8(%esp)
	movl	$0, 12(%esp)
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	call	__udivdi3
	imull	$6, %edx, %ecx
	movl	%eax, 48(%esp)
	movl	%edx, 52(%esp)
	movl	$6, %eax
	mull	48(%esp)
	leal	(%ecx,%edx), %edx
	movl	%eax, %edi
	movl	%edx, %ebp
	addl	$3, %edi
	adcl	$0, %ebp
	movl	%edi, 72(%esp)
	movl	%ebp, 76(%esp)
	movl	72(%esp), %eax
	movl	76(%esp), %edx
	xorl	%ebx, %eax
	xorl	%esi, %edx
	orl	%eax, %edx
	je	.L28
.L27:
	movl	92(%esp), %ebx
	movl	96(%esp), %esi
	movl	100(%esp), %edi
	movl	104(%esp), %ebp
	addl	$108, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L28:
	movl	bitmap, %ebp
	movl	%ebp, 84(%esp)
	testl	%ebp, %ebp
	je	.L24
	movl	b0, %ebx
	movl	b0+4, %esi
	movl	60(%esp), %ecx
	movl	48(%esp), %eax
	subl	nmin, %ecx
	movl	52(%esp), %edx
	subl	%ebx, %eax
	movl	(%ebp,%ecx,4), %ecx
	sbbl	%esi, %edx
	shrdl	$3, %edx, %eax
	movzbl	(%ecx,%eax), %eax
	movl	48(%esp), %ecx
	subl	%ebx, %ecx
	andl	$7, %ecx
	sarl	%cl, %eax
	testb	$1, %al
	je	.L27
.L24:
	movl	$factors_mutex, (%esp)
	call	pthread_mutex_lock
	movl	factors_file, %eax
	testl	%eax, %eax
	je	.L25
	movl	56(%esp), %edx
	movl	60(%esp), %ecx
	movl	%edx, 32(%esp)
	movl	%ecx, 28(%esp)
	movl	64(%esp), %edx
	movl	72(%esp), %edi
	movl	76(%esp), %ebp
	movl	68(%esp), %ecx
	movl	%edx, 12(%esp)
	movl	%edi, 20(%esp)
	movl	%ebp, 24(%esp)
	movl	%ecx, 16(%esp)
	movl	$.LC5, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	print_factors, %edx
	testl	%edx, %edx
	jne	.L29
.L26:
	incl	factor_count
	movl	$factors_mutex, 112(%esp)
	movl	92(%esp), %ebx
	movl	96(%esp), %esi
	movl	100(%esp), %edi
	movl	104(%esp), %ebp
	addl	$108, %esp
	jmp	pthread_mutex_unlock
	.p2align 4,,10
	.p2align 3
.L29:
	movl	56(%esp), %ecx
	movl	76(%esp), %edx
	movl	%ecx, 28(%esp)
	movl	60(%esp), %edi
	movl	72(%esp), %eax
	movl	%edx, 20(%esp)
	movl	68(%esp), %ecx
	movl	64(%esp), %edx
	movl	%edi, 24(%esp)
	movl	%eax, 16(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 12(%esp)
	movl	$.LC5, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L25:
	movl	56(%esp), %ecx
	movl	76(%esp), %edx
	movl	%ecx, 28(%esp)
	movl	60(%esp), %edi
	movl	72(%esp), %eax
	movl	%edx, 20(%esp)
	movl	68(%esp), %ecx
	movl	64(%esp), %edx
	movl	%edi, 24(%esp)
	movl	%eax, 16(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 12(%esp)
	movl	$.LC6, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	jmp	.L26
	.size	test_factor, .-test_factor
.globl __ctzdi2
	.p2align 4,,15
.globl app_thread_fun
	.type	app_thread_fun, @function
app_thread_fun:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$380, %esp
	movl	404(%esp), %eax
	movdqa	xones.7356, %xmm0
	movl	%eax, 168(%esp)
	movdqa	%xmm0, 176(%esp)
	movl	nstart, %eax
	movl	168(%esp), %edx
	movl	%eax, 196(%esp)
	addl	$40, %edx
	movl	%edx, 172(%esp)
#APP
# 603 "app.c" 1
	fildll (%edx)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	168(%esp), %ecx
	addl	$32, %ecx
	movl	%ecx, 260(%esp)
#APP
# 603 "app.c" 1
	fildll (%ecx)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	168(%esp), %ebx
	addl	$24, %ebx
	movl	%ebx, 264(%esp)
#APP
# 603 "app.c" 1
	fildll (%ebx)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	168(%esp), %esi
	addl	$16, %esi
	movl	%esi, 112(%esp)
#APP
# 603 "app.c" 1
	fildll (%esi)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	168(%esp), %edi
	addl	$8, %edi
	movl	%edi, 268(%esp)
#APP
# 603 "app.c" 1
	fildll (%edi)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	168(%esp), %ebp
#APP
# 603 "app.c" 1
	fildll (%ebp)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	$30, %ecx
	bsrl	%eax, %eax
	movl	$1, %ebx
	xorl	$31, %eax
	movdqa	(%ebp), %xmm6
	subl	%eax, %ecx
	movdqa	16(%ebp), %xmm7
	sall	%cl, %ebx
	movdqa	32(%ebp), %xmm5
	testl	%ebx, 196(%esp)
	je	.L31
	movdqa	%xmm0, %xmm1
	leal	320(%esp), %eax
	paddq	%xmm6, %xmm1
	movl	%eax, 116(%esp)
	psrlq	$1, %xmm1
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm6, %xmm0
	paddq	%xmm1, %xmm0
	movdqa	176(%esp), %xmm1
	psrlq	$1, %xmm0
	pand	%xmm0, %xmm1
	psubq	176(%esp), %xmm1
	pandn	%xmm6, %xmm1
	paddq	%xmm1, %xmm0
	movdqa	176(%esp), %xmm1
	psrlq	$1, %xmm0
	paddq	%xmm7, %xmm1
	movdqa	%xmm0, 320(%esp)
	psrlq	$1, %xmm1
	movdqa	176(%esp), %xmm0
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm7, %xmm0
	paddq	%xmm1, %xmm0
	movdqa	176(%esp), %xmm1
	psrlq	$1, %xmm0
	pand	%xmm0, %xmm1
	psubq	176(%esp), %xmm1
	pandn	%xmm7, %xmm1
	paddq	%xmm1, %xmm0
	movdqa	176(%esp), %xmm1
	psrlq	$1, %xmm0
	paddq	%xmm5, %xmm1
	movdqa	%xmm0, 336(%esp)
	psrlq	$1, %xmm1
	movdqa	176(%esp), %xmm0
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	movdqa	176(%esp), %xmm1
	psrlq	$1, %xmm0
	pand	%xmm0, %xmm1
	psubq	176(%esp), %xmm1
	pandn	%xmm5, %xmm1
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, 352(%esp)
.L293:
	movdqa	%xmm6, %xmm0
	psrlq	$32, %xmm0
	movdqa	%xmm0, 96(%esp)
	.p2align 4,,10
	.p2align 3
.L292:
	shrl	%ebx
	je	.L294
.L44:
#APP
# 859 "app.c" 1
	fildll 320(%esp)
	fmul %st(0)
	fmul %st(1)
	fistpll 272(%esp)
# 0 "" 2
# 866 "app.c" 1
	fildll 328(%esp)
	fmul %st(0)
	fmul %st(2)
	fistpll 280(%esp)
# 0 "" 2
# 873 "app.c" 1
	fildll 336(%esp)
	fmul %st(0)
	fmul %st(3)
	fistpll 288(%esp)
# 0 "" 2
# 880 "app.c" 1
	fildll 344(%esp)
	fmul %st(0)
	fmul %st(4)
	fistpll 296(%esp)
# 0 "" 2
# 887 "app.c" 1
	fildll 352(%esp)
	fmul %st(0)
	fmul %st(5)
	fistpll 304(%esp)
# 0 "" 2
# 894 "app.c" 1
	fildll 360(%esp)
	fmul %st(0)
	fmul %st(6)
	fistpll 312(%esp)
# 0 "" 2
#NO_APP
	testl	%ebx, 196(%esp)
	je	.L33
	movdqa	272(%esp), %xmm0
	movl	116(%esp), %ecx
	movdqa	%xmm0, %xmm4
	movdqa	(%ecx), %xmm1
	psrlq	$32, %xmm4
	movdqa	%xmm1, %xmm2
	pmuludq	%xmm6, %xmm4
	psrlq	$32, %xmm2
	leal	272(%esp), %esi
	pmuludq	%xmm1, %xmm2
	pmuludq	%xmm1, %xmm1
	psllq	$33, %xmm2
	paddd	%xmm2, %xmm1
	movdqa	96(%esp), %xmm2
	pmuludq	%xmm0, %xmm2
	pmuludq	%xmm6, %xmm0
	paddd	%xmm4, %xmm2
	psllq	$32, %xmm2
	paddd	%xmm2, %xmm0
	psubq	%xmm0, %xmm1
	movdqa	176(%esp), %xmm0
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm6, %xmm0
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, (%ecx)
	psubq	%xmm6, %xmm0
	pmovmskb	%xmm0, %eax
	testb	%al, %al
	js	.L34
	movl	168(%esp), %ebp
	movl	(%ebp), %edi
	movl	4(%ebp), %ebp
	subl	%edi, 320(%esp)
	sbbl	%ebp, 324(%esp)
.L34:
	testw	%ax, %ax
	js	.L35
	movl	268(%esp), %ecx
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	subl	%eax, 328(%esp)
	sbbl	%edx, 332(%esp)
.L35:
	movdqa	16(%esi), %xmm1
	movl	116(%esp), %edi
	movdqa	%xmm1, %xmm4
	movdqa	16(%edi), %xmm2
	psrlq	$32, %xmm4
	movdqa	%xmm2, %xmm0
	pmuludq	%xmm7, %xmm4
	psrlq	$32, %xmm0
	pmuludq	%xmm2, %xmm0
	pmuludq	%xmm2, %xmm2
	psllq	$33, %xmm0
	paddd	%xmm0, %xmm2
	movdqa	%xmm7, %xmm0
	psrlq	$32, %xmm0
	pmuludq	%xmm1, %xmm0
	pmuludq	%xmm7, %xmm1
	paddd	%xmm4, %xmm0
	psllq	$32, %xmm0
	paddd	%xmm0, %xmm1
	movdqa	176(%esp), %xmm0
	psubq	%xmm1, %xmm2
	pand	%xmm2, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm7, %xmm0
	paddq	%xmm2, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, 16(%edi)
	psubq	%xmm7, %xmm0
	pmovmskb	%xmm0, %ecx
	testb	%cl, %cl
	js	.L36
	movl	112(%esp), %ebp
	movl	(%ebp), %eax
	movl	4(%ebp), %edx
	subl	%eax, 336(%esp)
	sbbl	%edx, 340(%esp)
.L36:
	testw	%cx, %cx
	js	.L37
	movl	264(%esp), %ecx
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	subl	%eax, 344(%esp)
	sbbl	%edx, 348(%esp)
.L37:
	movdqa	32(%esi), %xmm1
	movl	116(%esp), %edi
	movdqa	%xmm1, %xmm4
	movdqa	32(%edi), %xmm2
	psrlq	$32, %xmm4
	movdqa	%xmm2, %xmm0
	pmuludq	%xmm5, %xmm4
	psrlq	$32, %xmm0
	pmuludq	%xmm2, %xmm0
	pmuludq	%xmm2, %xmm2
	psllq	$33, %xmm0
	paddd	%xmm0, %xmm2
	movdqa	%xmm5, %xmm0
	psrlq	$32, %xmm0
	pmuludq	%xmm1, %xmm0
	pmuludq	%xmm5, %xmm1
	paddd	%xmm4, %xmm0
	psllq	$32, %xmm0
	paddd	%xmm0, %xmm1
	movdqa	176(%esp), %xmm0
	psubq	%xmm1, %xmm2
	pand	%xmm2, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm5, %xmm0
	paddq	%xmm2, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, 32(%edi)
	psubq	%xmm5, %xmm0
	pmovmskb	%xmm0, %ecx
	testb	%cl, %cl
	js	.L38
	movl	260(%esp), %ebp
	movl	(%ebp), %eax
	movl	4(%ebp), %edx
	subl	%eax, 352(%esp)
	sbbl	%edx, 356(%esp)
.L38:
	testw	%cx, %cx
	js	.L292
	movl	172(%esp), %ecx
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	subl	%eax, 360(%esp)
	sbbl	%edx, 364(%esp)
	shrl	%ebx
	jne	.L44
.L294:
	movl	nstep, %eax
	cmpl	$1, %eax
	jbe	.L295
	movd	%eax, %xmm0
	movdqa	xkmax, %xmm7
	leal	272(%esp), %eax
	movdqa	%xmm0, 144(%esp)
	movl	%eax, 92(%esp)
	movd	144(%esp), %xmm5
	movl	92(%esp), %edx
	movd	%xmm5, 140(%esp)
	movdqa	%xmm7, 208(%esp)
	leal	288(%esp), %eax
	cmpl	%edx, 112(%esp)
	jae	.L296
.L246:
	movl	168(%esp), %ecx
	movl	116(%esp), %ebx
	movdqu	(%ecx), %xmm0
	movl	112(%esp), %esi
	psubq	(%ebx), %xmm0
	movdqa	%xmm0, 272(%esp)
	movdqu	(%esi), %xmm0
	psubq	336(%esp), %xmm0
	movdqa	%xmm0, (%eax)
	movdqu	16(%esi), %xmm0
	psubq	352(%esp), %xmm0
	movdqa	%xmm0, 16(%eax)
	movl	320(%esp), %ecx
	movl	324(%esp), %ebx
.L127:
	movl	%ebx, %esi
	movl	%ecx, %edi
	movl	%ecx, %ebx
	andl	$1, %edi
	movl	%edi, 28(%esp)
	je	.L128
	movl	272(%esp), %ebx
	movl	276(%esp), %esi
.L128:
	movl	%ebx, (%esp)
	movl	%ebx, %edi
	movl	%esi, 4(%esp)
	xorl	%ebx, %ebx
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%ebx, %ebp
	movl	%edi, 48(%esp)
	movl	%ebp, 52(%esp)
	cmpl	kmax+4, %ebp
	jbe	.L297
.L129:
	movl	28(%esp), %ecx
	testl	%ecx, %ecx
	jne	.L132
	movl	272(%esp), %ebx
	movl	276(%esp), %ecx
.L133:
	cmpl	kmax+4, %ecx
	ja	.L134
	jae	.L298
.L249:
	cmpl	kmin+4, %ecx
	jae	.L299
.L134:
	movl	328(%esp), %ebx
	movl	332(%esp), %esi
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 28(%esp)
	je	.L137
	movl	280(%esp), %ebx
	movl	284(%esp), %esi
.L137:
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	movl	%ebx, %edi
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	xorl	%edx, %edx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%edx, %ebp
	movl	%edi, 56(%esp)
	movl	%ebp, 60(%esp)
	cmpl	kmax+4, %ebp
	ja	.L138
	jae	.L300
.L251:
	movl	60(%esp), %ebp
	cmpl	kmin+4, %ebp
	jae	.L301
.L138:
	movl	28(%esp), %esi
	testl	%esi, %esi
	jne	.L141
	movl	280(%esp), %ebx
	movl	284(%esp), %ecx
.L142:
	cmpl	kmax+4, %ecx
	ja	.L143
	jae	.L302
.L253:
	cmpl	kmin+4, %ecx
	jae	.L303
.L143:
	movl	336(%esp), %ebx
	movl	340(%esp), %esi
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 28(%esp)
	je	.L146
	movl	288(%esp), %ebx
	movl	292(%esp), %esi
.L146:
	movl	%ebx, (%esp)
	movl	%ebx, %edi
	movl	%esi, 4(%esp)
	xorl	%ebx, %ebx
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%ebx, %ebp
	movl	%edi, 64(%esp)
	movl	%ebp, 68(%esp)
	cmpl	kmax+4, %ebp
	ja	.L147
	jae	.L304
.L255:
	movl	68(%esp), %ebp
	cmpl	kmin+4, %ebp
	jae	.L305
.L147:
	movl	28(%esp), %ecx
	testl	%ecx, %ecx
	jne	.L150
	movl	288(%esp), %ebx
	movl	292(%esp), %ecx
.L151:
	cmpl	kmax+4, %ecx
	ja	.L152
	jae	.L306
.L257:
	cmpl	kmin+4, %ecx
	jae	.L307
.L152:
	movl	344(%esp), %ebx
	movl	348(%esp), %esi
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 28(%esp)
	je	.L155
	movl	296(%esp), %ebx
	movl	300(%esp), %esi
.L155:
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	movl	%ebx, %edi
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	xorl	%edx, %edx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%edx, %ebp
	movl	%edi, 72(%esp)
	movl	%ebp, 76(%esp)
	cmpl	kmax+4, %ebp
	ja	.L156
	jae	.L308
.L259:
	movl	76(%esp), %ebp
	cmpl	kmin+4, %ebp
	jae	.L309
.L156:
	movl	28(%esp), %esi
	testl	%esi, %esi
	jne	.L159
	movl	296(%esp), %ebx
	movl	300(%esp), %ecx
.L160:
	cmpl	kmax+4, %ecx
	ja	.L161
	jae	.L310
.L261:
	cmpl	kmin+4, %ecx
	jae	.L311
.L161:
	movl	352(%esp), %ebx
	movl	356(%esp), %esi
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 28(%esp)
	je	.L164
	movl	304(%esp), %ebx
	movl	308(%esp), %esi
.L164:
	movl	%ebx, (%esp)
	movl	%ebx, %edi
	movl	%esi, 4(%esp)
	xorl	%ebx, %ebx
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%ebx, %ebp
	movl	%edi, 80(%esp)
	movl	%ebp, 84(%esp)
	cmpl	kmax+4, %ebp
	ja	.L165
	jae	.L312
.L263:
	movl	84(%esp), %ebp
	cmpl	kmin+4, %ebp
	jae	.L313
.L165:
	movl	28(%esp), %ecx
	testl	%ecx, %ecx
	jne	.L168
	movl	304(%esp), %ebx
	movl	308(%esp), %ecx
.L169:
	cmpl	kmax+4, %ecx
	ja	.L170
	jae	.L314
.L265:
	cmpl	kmin+4, %ecx
	jae	.L315
.L170:
	movl	360(%esp), %ebx
	movl	364(%esp), %esi
	movl	%ebx, %eax
	andl	$1, %eax
	movl	%eax, 28(%esp)
	je	.L173
	movl	312(%esp), %ebx
	movl	316(%esp), %esi
.L173:
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	movl	%ebx, %edi
	call	__ctzdi2
	movl	%esi, %ebp
	movl	%eax, %ecx
	xorl	%edx, %edx
	shrl	%cl, %ebp
	shrdl	%esi, %edi
	testb	$32, %al
	cmovne	%ebp, %edi
	cmovne	%edx, %ebp
	movl	%edi, 40(%esp)
	movl	%ebp, 44(%esp)
	cmpl	kmax+4, %ebp
	ja	.L174
	jae	.L316
.L267:
	movl	44(%esp), %ebp
	cmpl	kmin+4, %ebp
	jae	.L317
.L174:
	movl	28(%esp), %eax
	testl	%eax, %eax
	je	.L177
	movl	360(%esp), %ebx
	movl	364(%esp), %ecx
.L178:
	cmpl	kmax+4, %ecx
	ja	.L179
	jae	.L318
.L269:
	cmpl	kmin+4, %ecx
	jae	.L319
.L179:
	movl	196(%esp), %eax
	cmpl	nmin, %eax
	jbe	.L182
#APP
# 1122 "app.c" 1
	fildl nstep
	fld1
	fscale
	fstp %st(1)
# 0 "" 2
# 1127 "app.c" 1
	fmul %st(0), %st(1)
# 0 "" 2
# 1129 "app.c" 1
	fmul %st(0), %st(2)
# 0 "" 2
# 1132 "app.c" 1
	fmul %st(0), %st(3)
# 0 "" 2
# 1135 "app.c" 1
	fmul %st(0), %st(4)
# 0 "" 2
# 1138 "app.c" 1
	fmul %st(0), %st(5)
# 0 "" 2
# 1141 "app.c" 1
	fmul %st(0), %st(6)
# 0 "" 2
# 1150 "app.c" 1
	fstp %st(0)
# 0 "" 2
#NO_APP
	movl	116(%esp), %edx
	movl	116(%esp), %ecx
	addl	$16, %edx
	addl	$32, %ecx
	movl	%edx, 124(%esp)
	movl	%ecx, 120(%esp)
	.p2align 4,,10
	.p2align 3
.L231:
#APP
# 1158 "app.c" 1
	fildll 320(%esp)
	fmul %st(1)
	fistpll 272(%esp)
# 0 "" 2
# 1164 "app.c" 1
	fildll 328(%esp)
	fmul %st(2)
	fistpll 280(%esp)
# 0 "" 2
# 1170 "app.c" 1
	fildll 336(%esp)
	fmul %st(3)
	fistpll 288(%esp)
# 0 "" 2
# 1176 "app.c" 1
	fildll 344(%esp)
	fmul %st(4)
	fistpll 296(%esp)
# 0 "" 2
# 1182 "app.c" 1
	fildll 352(%esp)
	fmul %st(5)
	fistpll 304(%esp)
# 0 "" 2
# 1188 "app.c" 1
	fildll 360(%esp)
	fmul %st(6)
	fistpll 312(%esp)
# 0 "" 2
#NO_APP
	movdqa	272(%esp), %xmm1
	movl	nstep, %ebx
	movl	168(%esp), %esi
	subl	%ebx, 196(%esp)
	movl	116(%esp), %edi
	movdqa	(%esi), %xmm6
	movdqa	(%edi), %xmm2
	movdqa	%xmm1, %xmm3
	movd	140(%esp), %xmm5
	movdqa	%xmm6, %xmm0
	psrlq	$32, %xmm3
	psrlq	$32, %xmm0
	pmuludq	%xmm6, %xmm3
	pmuludq	%xmm1, %xmm0
	psllq	%xmm5, %xmm2
	pmuludq	%xmm6, %xmm1
	paddd	%xmm3, %xmm0
	psllq	$32, %xmm0
	paddd	%xmm0, %xmm1
	psubq	%xmm1, %xmm2
	movdqa	%xmm2, (%edi)
	psubq	%xmm6, %xmm2
	pmovmskb	%xmm2, %ecx
	testb	%cl, %cl
	js	.L183
	movl	168(%esp), %ebx
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	subl	%eax, 320(%esp)
	sbbl	%edx, 324(%esp)
.L183:
	testw	%cx, %cx
	js	.L184
	movl	268(%esp), %esi
	movl	(%esi), %eax
	movl	4(%esi), %edx
	subl	%eax, 328(%esp)
	sbbl	%edx, 332(%esp)
.L184:
	movdqa	288(%esp), %xmm1
	movl	112(%esp), %edi
	movl	124(%esp), %ebp
	movdqa	(%edi), %xmm5
	movdqa	(%ebp), %xmm2
	movdqa	%xmm1, %xmm3
	movd	140(%esp), %xmm7
	movdqa	%xmm5, %xmm0
	psrlq	$32, %xmm3
	psrlq	$32, %xmm0
	pmuludq	%xmm5, %xmm3
	pmuludq	%xmm1, %xmm0
	psllq	%xmm7, %xmm2
	pmuludq	%xmm5, %xmm1
	paddd	%xmm3, %xmm0
	movl	116(%esp), %eax
	psllq	$32, %xmm0
	paddd	%xmm0, %xmm1
	psubq	%xmm1, %xmm2
	movdqa	%xmm2, 16(%eax)
	psubq	%xmm5, %xmm2
	pmovmskb	%xmm2, %ecx
	testb	%cl, %cl
	js	.L185
	movl	112(%esp), %ebx
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	subl	%eax, 336(%esp)
	sbbl	%edx, 340(%esp)
.L185:
	testw	%cx, %cx
	js	.L186
	movl	264(%esp), %esi
	movl	(%esi), %eax
	movl	4(%esi), %edx
	subl	%eax, 344(%esp)
	sbbl	%edx, 348(%esp)
.L186:
	movdqa	304(%esp), %xmm1
	movl	260(%esp), %edi
	movl	120(%esp), %ebp
	movdqa	(%edi), %xmm5
	movdqa	(%ebp), %xmm2
	movdqa	%xmm1, %xmm3
	movd	140(%esp), %xmm7
	movdqa	%xmm5, %xmm0
	psrlq	$32, %xmm3
	psrlq	$32, %xmm0
	pmuludq	%xmm5, %xmm3
	pmuludq	%xmm1, %xmm0
	psllq	%xmm7, %xmm2
	pmuludq	%xmm5, %xmm1
	paddd	%xmm3, %xmm0
	movl	116(%esp), %eax
	psllq	$32, %xmm0
	paddd	%xmm0, %xmm1
	psubq	%xmm1, %xmm2
	movdqa	%xmm2, 32(%eax)
	psubq	%xmm5, %xmm2
	pmovmskb	%xmm2, %ecx
	testb	%cl, %cl
	js	.L187
	movl	260(%esp), %ebx
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	subl	%eax, 352(%esp)
	sbbl	%edx, 356(%esp)
.L187:
	testw	%cx, %cx
	js	.L188
	movl	172(%esp), %esi
	movl	(%esi), %eax
	movl	4(%esi), %edx
	subl	%eax, 360(%esp)
	sbbl	%edx, 364(%esp)
.L188:
	movl	116(%esp), %edi
	movdqa	%xmm6, %xmm3
	movdqa	(%edi), %xmm1
	movdqa	176(%esp), %xmm0
	psubq	%xmm1, %xmm3
	movdqa	%xmm1, %xmm2
	pand	%xmm1, %xmm0
	pxor	%xmm3, %xmm2
	psubq	176(%esp), %xmm0
	pand	%xmm0, %xmm2
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm1
	movdqa	%xmm3, 272(%esp)
	psubq	208(%esp), %xmm1
	pmovmskb	%xmm1, %ebp
	movl	%ebp, %eax
	testb	%al, %al
	jns	.L189
	movl	168(%esp), %edx
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	272(%esp), %ecx
	sbbl	276(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L189
	ja	.L271
	cmpl	kmin, %ecx
	jae	.L271
	.p2align 4,,10
	.p2align 3
.L189:
	testw	%bp, %bp
	.p2align 4,,4
	.p2align 3
	jns	.L193
	movl	268(%esp), %edx
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	280(%esp), %ecx
	sbbl	284(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L193
	ja	.L272
	cmpl	kmin, %ecx
	jae	.L272
	.p2align 4,,10
	.p2align 3
.L193:
	movl	124(%esp), %eax
	movl	112(%esp), %edx
	movdqa	(%eax), %xmm1
	movdqa	(%edx), %xmm3
	movdqa	%xmm1, %xmm2
	psubq	%xmm1, %xmm3
	movdqa	176(%esp), %xmm0
	pxor	%xmm3, %xmm2
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pand	%xmm0, %xmm2
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm1
	movdqa	%xmm3, 288(%esp)
	psubq	208(%esp), %xmm1
	pmovmskb	%xmm1, %ebp
	movl	%ebp, %ecx
	testb	%cl, %cl
	jns	.L197
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	288(%esp), %ecx
	sbbl	292(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L197
	ja	.L273
	cmpl	kmin, %ecx
	jae	.L273
	.p2align 4,,10
	.p2align 3
.L197:
	testw	%bp, %bp
	.p2align 4,,4
	.p2align 3
	jns	.L201
	movl	264(%esp), %edx
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	296(%esp), %ecx
	sbbl	300(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L201
	ja	.L274
	cmpl	kmin, %ecx
	jae	.L274
	.p2align 4,,10
	.p2align 3
.L201:
	movl	120(%esp), %eax
	movl	260(%esp), %edx
	movdqa	(%eax), %xmm1
	movdqa	(%edx), %xmm3
	movdqa	%xmm1, %xmm2
	psubq	%xmm1, %xmm3
	movdqa	176(%esp), %xmm0
	pxor	%xmm3, %xmm2
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pand	%xmm0, %xmm2
	pxor	%xmm2, %xmm3
	pxor	%xmm2, %xmm1
	movdqa	%xmm3, 304(%esp)
	psubq	208(%esp), %xmm1
	pmovmskb	%xmm1, %ebp
	movl	%ebp, %ecx
	testb	%cl, %cl
	jns	.L205
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	304(%esp), %ecx
	sbbl	308(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L205
	ja	.L275
	cmpl	kmin, %ecx
	jae	.L275
	.p2align 4,,10
	.p2align 3
.L205:
	testw	%bp, %bp
	.p2align 4,,4
	.p2align 3
	jns	.L209
	movl	172(%esp), %edx
	movl	(%edx), %esi
	movl	4(%edx), %edi
	movl	%esi, %ecx
	movl	%edi, %ebx
	subl	312(%esp), %ecx
	sbbl	316(%esp), %ebx
	cmpl	kmin+4, %ebx
	jb	.L209
	ja	.L276
	cmpl	kmin, %ecx
	jae	.L276
	.p2align 4,,10
	.p2align 3
.L209:
	movl	272(%esp), %eax
	movl	276(%esp), %edx
#APP
# 1301 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok0		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok0:
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	%ebx, %ecx
	xorl	%eax, %eax
	shrdl	%edx, %esi
	movl	%edx, %edi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%eax, %edi
	cmpl	kmax+4, %edi
	ja	.L213
	jb	.L277
	cmpl	kmax, %esi
	ja	.L213
.L277:
	cmpl	kmin+4, %edi
	jb	.L213
	ja	.L278
	cmpl	kmin, %esi
	jae	.L278
	.p2align 4,,10
	.p2align 3
.L213:
	movl	280(%esp), %eax
	movl	284(%esp), %edx
#APP
# 1317 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok1		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok1:
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	%ebx, %ecx
	xorl	%eax, %eax
	shrdl	%edx, %esi
	movl	%edx, %edi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%eax, %edi
	cmpl	kmax+4, %edi
	ja	.L216
	jb	.L279
	cmpl	kmax, %esi
	ja	.L216
.L279:
	cmpl	kmin+4, %edi
	jb	.L216
	ja	.L280
	cmpl	kmin, %esi
	jae	.L280
	.p2align 4,,10
	.p2align 3
.L216:
	movl	288(%esp), %eax
	movl	292(%esp), %edx
#APP
# 1333 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok2		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok2:
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	%ebx, %ecx
	xorl	%eax, %eax
	shrdl	%edx, %esi
	movl	%edx, %edi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%eax, %edi
	cmpl	kmax+4, %edi
	ja	.L219
	jb	.L281
	cmpl	kmax, %esi
	ja	.L219
.L281:
	cmpl	kmin+4, %edi
	jb	.L219
	ja	.L282
	cmpl	kmin, %esi
	jae	.L282
	.p2align 4,,10
	.p2align 3
.L219:
	movl	296(%esp), %eax
	movl	300(%esp), %edx
#APP
# 1349 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok3		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok3:
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	%ebx, %ecx
	xorl	%eax, %eax
	shrdl	%edx, %esi
	movl	%edx, %edi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%eax, %edi
	cmpl	kmax+4, %edi
	ja	.L222
	jb	.L283
	cmpl	kmax, %esi
	ja	.L222
.L283:
	cmpl	kmin+4, %edi
	jb	.L222
	ja	.L284
	cmpl	kmin, %esi
	jae	.L284
	.p2align 4,,10
	.p2align 3
.L222:
	movl	304(%esp), %eax
	movl	308(%esp), %edx
#APP
# 1365 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok4		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok4:
# 0 "" 2
#NO_APP
	movl	%eax, %esi
	movl	%ebx, %ecx
	xorl	%eax, %eax
	shrdl	%edx, %esi
	movl	%edx, %edi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%eax, %edi
	cmpl	kmax+4, %edi
	ja	.L225
	jb	.L285
	cmpl	kmax, %esi
	ja	.L225
.L285:
	cmpl	kmin+4, %edi
	jb	.L225
	ja	.L286
	cmpl	kmin, %esi
	jae	.L286
	.p2align 4,,10
	.p2align 3
.L225:
	movl	312(%esp), %eax
	movl	316(%esp), %edx
#APP
# 1381 "app.c" 1
	bsfl	%eax, %ebx	
	jnz	bsflok5		
	bsfl	%edx, %ebx	
	addl	$32, %ebx	
bsflok5:
# 0 "" 2
#NO_APP
	xorl	%ebp, %ebp
	movl	%ebx, %ecx
	movl	%eax, %esi
	movl	%edx, %edi
	shrdl	%edx, %esi
	shrl	%cl, %edi
	testb	$32, %bl
	cmovne	%edi, %esi
	cmovne	%ebp, %edi
	cmpl	kmax+4, %edi
	ja	.L228
	jb	.L287
	cmpl	kmax, %esi
	ja	.L228
.L287:
	cmpl	kmin+4, %edi
	jb	.L228
	ja	.L288
	cmpl	kmin, %esi
	jae	.L288
	.p2align 4,,10
	.p2align 3
.L228:
	movl	196(%esp), %ebx
	cmpl	nmin, %ebx
	ja	.L231
.L182:
#APP
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1426 "app.c" 1
	fstp %st(0)
# 0 "" 2
#NO_APP
	addl	$380, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L33:
	movdqa	272(%esp), %xmm1
	movl	116(%esp), %edi
	movdqa	%xmm1, %xmm4
	movdqa	(%edi), %xmm0
	psrlq	$32, %xmm4
	movdqa	%xmm0, %xmm2
	pmuludq	%xmm6, %xmm4
	psrlq	$32, %xmm2
	leal	272(%esp), %esi
	pmuludq	%xmm0, %xmm2
	pmuludq	%xmm0, %xmm0
	psllq	$33, %xmm2
	paddd	%xmm2, %xmm0
	movdqa	96(%esp), %xmm2
	pmuludq	%xmm1, %xmm2
	pmuludq	%xmm6, %xmm1
	paddd	%xmm4, %xmm2
	psllq	$32, %xmm2
	paddd	%xmm2, %xmm1
	psubq	%xmm1, %xmm0
	movdqa	%xmm0, (%edi)
	psubq	%xmm6, %xmm0
	pmovmskb	%xmm0, %eax
	testb	%al, %al
	js	.L39
	movl	168(%esp), %ecx
	movl	(%ecx), %edx
	movl	4(%ecx), %ecx
	subl	%edx, 320(%esp)
	sbbl	%ecx, 324(%esp)
.L39:
	testw	%ax, %ax
	js	.L40
	movl	268(%esp), %edi
	movl	(%edi), %eax
	movl	4(%edi), %edx
	subl	%eax, 328(%esp)
	sbbl	%edx, 332(%esp)
.L40:
	movdqa	16(%esi), %xmm2
	movl	116(%esp), %ebp
	movdqa	%xmm2, %xmm4
	movdqa	16(%ebp), %xmm0
	psrlq	$32, %xmm4
	movdqa	%xmm0, %xmm1
	pmuludq	%xmm7, %xmm4
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pmuludq	%xmm0, %xmm0
	psllq	$33, %xmm1
	paddd	%xmm1, %xmm0
	movdqa	%xmm7, %xmm1
	psrlq	$32, %xmm1
	pmuludq	%xmm2, %xmm1
	pmuludq	%xmm7, %xmm2
	paddd	%xmm4, %xmm1
	psllq	$32, %xmm1
	paddd	%xmm1, %xmm2
	psubq	%xmm2, %xmm0
	movdqa	%xmm0, 16(%ebp)
	psubq	%xmm7, %xmm0
	pmovmskb	%xmm0, %ecx
	testb	%cl, %cl
	js	.L41
	movl	112(%esp), %edi
	movl	(%edi), %eax
	movl	4(%edi), %edx
	subl	%eax, 336(%esp)
	sbbl	%edx, 340(%esp)
.L41:
	testw	%cx, %cx
	js	.L42
	movl	264(%esp), %ebp
	movl	(%ebp), %eax
	movl	4(%ebp), %edx
	subl	%eax, 344(%esp)
	sbbl	%edx, 348(%esp)
.L42:
	movdqa	32(%esi), %xmm2
	movl	116(%esp), %eax
	movdqa	%xmm2, %xmm4
	movdqa	32(%eax), %xmm0
	psrlq	$32, %xmm4
	movdqa	%xmm0, %xmm1
	pmuludq	%xmm5, %xmm4
	psrlq	$32, %xmm1
	pmuludq	%xmm0, %xmm1
	pmuludq	%xmm0, %xmm0
	psllq	$33, %xmm1
	paddd	%xmm1, %xmm0
	movdqa	%xmm5, %xmm1
	psrlq	$32, %xmm1
	pmuludq	%xmm2, %xmm1
	pmuludq	%xmm5, %xmm2
	paddd	%xmm4, %xmm1
	psllq	$32, %xmm1
	paddd	%xmm1, %xmm2
	psubq	%xmm2, %xmm0
	movdqa	%xmm0, 32(%eax)
	psubq	%xmm5, %xmm0
	pmovmskb	%xmm0, %ecx
	testb	%cl, %cl
	js	.L43
	movl	260(%esp), %esi
	movl	(%esi), %eax
	movl	4(%esi), %edx
	subl	%eax, 352(%esp)
	sbbl	%edx, 356(%esp)
.L43:
	testw	%cx, %cx
	js	.L292
	movl	172(%esp), %edi
	movl	(%edi), %eax
	movl	4(%edi), %edx
	subl	%eax, 360(%esp)
	sbbl	%edx, 364(%esp)
	jmp	.L292
	.p2align 4,,10
	.p2align 3
.L31:
	movdqa	%xmm0, %xmm1
	leal	320(%esp), %edx
	paddq	%xmm6, %xmm1
	movdqa	176(%esp), %xmm0
	psrlq	$1, %xmm1
	movl	%edx, 116(%esp)
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm6, %xmm0
	paddq	%xmm0, %xmm1
	movdqa	176(%esp), %xmm0
	psrlq	$1, %xmm1
	movdqa	%xmm1, 320(%esp)
	movdqa	176(%esp), %xmm1
	paddq	%xmm7, %xmm1
	psrlq	$1, %xmm1
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm7, %xmm0
	paddq	%xmm0, %xmm1
	movdqa	176(%esp), %xmm0
	psrlq	$1, %xmm1
	movdqa	%xmm1, 336(%esp)
	movdqa	176(%esp), %xmm1
	paddq	%xmm5, %xmm1
	psrlq	$1, %xmm1
	pand	%xmm1, %xmm0
	psubq	176(%esp), %xmm0
	pandn	%xmm5, %xmm0
	paddq	%xmm0, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, 352(%esp)
	jmp	.L293
	.p2align 4,,10
	.p2align 3
.L297:
	jae	.L320
.L247:
	movl	52(%esp), %ebp
	cmpl	kmin+4, %ebp
	jb	.L129
	.p2align 4,,3
	.p2align 3
	ja	.L248
	movl	48(%esp), %edx
	cmpl	kmin, %edx
	jb	.L129
.L248:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L129
	movl	%ebx, 8(%esp)
	movl	52(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	48(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	(%esi), %eax
	movl	4(%esi), %edx
	call	test_factor
	jmp	.L129
	.p2align 4,,10
	.p2align 3
.L132:
	movl	320(%esp), %ebx
	movl	324(%esp), %ecx
	jmp	.L133
	.p2align 4,,10
	.p2align 3
.L296:
	cmpl	168(%esp), %eax
	jb	.L246
	movl	168(%esp), %edi
	movl	320(%esp), %ecx
	movl	(%edi), %eax
	movl	4(%edi), %edx
	subl	%ecx, %eax
	movl	324(%esp), %ebx
	movl	%eax, 272(%esp)
	sbbl	%ebx, %edx
	movl	%edx, 276(%esp)
	movl	8(%edi), %eax
	movl	12(%edi), %edx
	subl	328(%esp), %eax
	movl	%eax, 280(%esp)
	sbbl	332(%esp), %edx
	movl	%edx, 284(%esp)
	movl	16(%edi), %eax
	movl	20(%edi), %edx
	subl	336(%esp), %eax
	movl	%eax, 288(%esp)
	sbbl	340(%esp), %edx
	movl	%edx, 292(%esp)
	movl	24(%edi), %eax
	movl	28(%edi), %edx
	subl	344(%esp), %eax
	sbbl	348(%esp), %edx
	movl	%eax, 296(%esp)
	movl	%edx, 300(%esp)
	movl	32(%edi), %eax
	movl	36(%edi), %edx
	subl	352(%esp), %eax
	sbbl	356(%esp), %edx
	movl	%eax, 304(%esp)
	movl	%edx, 308(%esp)
	movl	40(%edi), %eax
	movl	44(%edi), %edx
	subl	360(%esp), %eax
	sbbl	364(%esp), %edx
	movl	%eax, 312(%esp)
	movl	%edx, 316(%esp)
	jmp	.L127
	.p2align 4,,10
	.p2align 3
.L288:
	cmpl	nstep, %ebx
	jae	.L228
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	172(%esp), %ecx
	movl	360(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	movl	196(%esp), %ebx
	cmpl	nmin, %ebx
	ja	.L231
	jmp	.L182
	.p2align 4,,10
	.p2align 3
.L286:
	cmpl	nstep, %ebx
	jae	.L225
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	260(%esp), %ecx
	movl	352(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	jmp	.L225
	.p2align 4,,10
	.p2align 3
.L284:
	cmpl	nstep, %ebx
	jae	.L222
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	264(%esp), %ecx
	movl	344(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	jmp	.L222
	.p2align 4,,10
	.p2align 3
.L282:
	cmpl	nstep, %ebx
	jae	.L219
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	112(%esp), %ecx
	movl	336(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	jmp	.L219
	.p2align 4,,10
	.p2align 3
.L280:
	cmpl	nstep, %ebx
	jae	.L216
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	268(%esp), %ecx
	movl	328(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	jmp	.L216
	.p2align 4,,10
	.p2align 3
.L278:
	cmpl	nstep, %ebx
	jae	.L213
	movl	%esi, (%esp)
	movl	%edi, 4(%esp)
	movl	168(%esp), %ecx
	movl	320(%esp), %eax
	movl	196(%esp), %ebp
	andl	$1, %eax
	addl	%eax, %eax
	decl	%eax
	movl	%eax, 12(%esp)
	leal	(%ebx,%ebp), %eax
	movl	%eax, 8(%esp)
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	call	test_factor
	jmp	.L213
	.p2align 4,,10
	.p2align 3
.L276:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	364(%esp), %eax
	xorl	360(%esp), %edx
	movl	196(%esp), %ebp
	orl	%edx, %eax
	movl	%ebp, 8(%esp)
	cmpl	$1, %eax
	movl	%ecx, (%esp)
	sbbl	%eax, %eax
	movl	%ebx, 4(%esp)
	orl	$1, %eax
	movl	%edi, %edx
	movl	%eax, 12(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L209
	.p2align 4,,10
	.p2align 3
.L272:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	332(%esp), %eax
	xorl	328(%esp), %edx
	movl	196(%esp), %ebp
	orl	%edx, %eax
	movl	%ebp, 8(%esp)
	cmpl	$1, %eax
	movl	%ecx, (%esp)
	sbbl	%eax, %eax
	movl	%ebx, 4(%esp)
	orl	$1, %eax
	movl	%edi, %edx
	movl	%eax, 12(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L193
	.p2align 4,,10
	.p2align 3
.L273:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	340(%esp), %eax
	xorl	336(%esp), %edx
	movl	%ecx, (%esp)
	orl	%edx, %eax
	movl	%ebx, 4(%esp)
	cmpl	$1, %eax
	movl	%edi, %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	196(%esp), %eax
	movl	%eax, 8(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L197
	.p2align 4,,10
	.p2align 3
.L274:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	348(%esp), %eax
	xorl	344(%esp), %edx
	movl	196(%esp), %ebp
	orl	%edx, %eax
	movl	%ebp, 8(%esp)
	cmpl	$1, %eax
	movl	%ecx, (%esp)
	sbbl	%eax, %eax
	movl	%ebx, 4(%esp)
	orl	$1, %eax
	movl	%edi, %edx
	movl	%eax, 12(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L201
	.p2align 4,,10
	.p2align 3
.L275:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	356(%esp), %eax
	xorl	352(%esp), %edx
	movl	%ecx, (%esp)
	orl	%edx, %eax
	movl	%ebx, 4(%esp)
	cmpl	$1, %eax
	movl	%edi, %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	196(%esp), %eax
	movl	%eax, 8(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L205
	.p2align 4,,10
	.p2align 3
.L271:
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	324(%esp), %eax
	xorl	320(%esp), %edx
	movl	%ecx, (%esp)
	orl	%edx, %eax
	movl	%ebx, 4(%esp)
	cmpl	$1, %eax
	movl	%edi, %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	196(%esp), %eax
	movl	%eax, 8(%esp)
	movl	%esi, %eax
	call	test_factor
	jmp	.L189
	.p2align 4,,10
	.p2align 3
.L177:
	movl	312(%esp), %ebx
	movl	316(%esp), %ecx
	jmp	.L178
	.p2align 4,,10
	.p2align 3
.L168:
	movl	352(%esp), %ebx
	movl	356(%esp), %ecx
	jmp	.L169
	.p2align 4,,10
	.p2align 3
.L159:
	movl	344(%esp), %ebx
	movl	348(%esp), %ecx
	jmp	.L160
	.p2align 4,,10
	.p2align 3
.L150:
	movl	336(%esp), %ebx
	movl	340(%esp), %ecx
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L141:
	movl	328(%esp), %ebx
	movl	332(%esp), %ecx
	jmp	.L142
	.p2align 4,,10
	.p2align 3
.L295:
	movl	168(%esp), %edx
	movl	(%edx), %eax
	movl	4(%edx), %edx
	movl	%eax, 128(%esp)
	movl	%edx, 132(%esp)
	.p2align 4,,10
	.p2align 3
.L124:
	movl	324(%esp), %ecx
	movl	kmax+4, %edi
	movl	320(%esp), %edx
	movl	kmax, %ebp
	cmpl	%edi, %ecx
	ja	.L46
	jb	.L55
	cmpl	%ebp, %edx
	jbe	.L55
.L46:
	movl	128(%esp), %ebx
	movl	132(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	ja	.L55
	jb	.L49
	cmpl	%ebx, %ebp
	jb	.L49
	.p2align 4,,10
	.p2align 3
.L55:
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	je	.L48
	movl	%edx, %ebx
	movl	%ecx, %esi
.L54:
	cmpl	%esi, %edi
	jb	.L49
	ja	.L233
	cmpl	%ebx, %ebp
	.p2align 4,,3
	.p2align 3
	jb	.L49
.L233:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L49
	.p2align 4,,4
	.p2align 3
	ja	.L234
	cmpl	kmin, %ebx
	jae	.L234
	.p2align 4,,10
	.p2align 3
.L49:
	movl	268(%esp), %esi
	movl	332(%esp), %ecx
	movl	(%esi), %ebx
	movl	328(%esp), %edx
	movl	4(%esi), %esi
	movl	%ebx, 224(%esp)
	movl	%esi, 228(%esp)
	cmpl	%edi, %ecx
	ja	.L57
	jb	.L66
	cmpl	%ebp, %edx
	jbe	.L66
.L57:
	movl	224(%esp), %ebx
	movl	228(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	ja	.L66
	jb	.L60
	cmpl	%ebx, %ebp
	jb	.L60
	.p2align 4,,10
	.p2align 3
.L66:
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	je	.L59
	movl	%edx, %ebx
	movl	%ecx, %esi
.L65:
	cmpl	%esi, %edi
	jb	.L60
	ja	.L235
	cmpl	%ebx, %ebp
	.p2align 4,,3
	.p2align 3
	jb	.L60
.L235:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L60
	.p2align 4,,4
	.p2align 3
	ja	.L236
	cmpl	kmin, %ebx
	jae	.L236
	.p2align 4,,10
	.p2align 3
.L60:
	movl	112(%esp), %esi
	movl	340(%esp), %ecx
	movl	(%esi), %ebx
	movl	336(%esp), %edx
	movl	4(%esi), %esi
	movl	%ebx, 232(%esp)
	movl	%esi, 236(%esp)
	cmpl	%edi, %ecx
	ja	.L68
	jb	.L77
	cmpl	%ebp, %edx
	jbe	.L77
.L68:
	movl	232(%esp), %ebx
	movl	236(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	ja	.L77
	jb	.L71
	cmpl	%ebx, %ebp
	jb	.L71
	.p2align 4,,10
	.p2align 3
.L77:
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	je	.L70
	movl	%edx, %ebx
	movl	%ecx, %esi
.L76:
	cmpl	%esi, %edi
	jb	.L71
	ja	.L237
	cmpl	%ebx, %ebp
	.p2align 4,,3
	.p2align 3
	jb	.L71
.L237:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L71
	.p2align 4,,4
	.p2align 3
	ja	.L238
	cmpl	kmin, %ebx
	jae	.L238
	.p2align 4,,10
	.p2align 3
.L71:
	movl	264(%esp), %esi
	movl	348(%esp), %ecx
	movl	(%esi), %ebx
	movl	344(%esp), %edx
	movl	4(%esi), %esi
	movl	%ebx, 240(%esp)
	movl	%esi, 244(%esp)
	cmpl	%edi, %ecx
	ja	.L79
	jb	.L88
	cmpl	%ebp, %edx
	jbe	.L88
.L79:
	movl	240(%esp), %ebx
	movl	244(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	ja	.L88
	jb	.L82
	cmpl	%ebx, %ebp
	jb	.L82
	.p2align 4,,10
	.p2align 3
.L88:
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	je	.L81
	movl	%edx, %ebx
	movl	%ecx, %esi
.L87:
	cmpl	%esi, %edi
	jb	.L82
	ja	.L239
	cmpl	%ebx, %ebp
	.p2align 4,,3
	.p2align 3
	jb	.L82
.L239:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L82
	.p2align 4,,4
	.p2align 3
	ja	.L240
	cmpl	kmin, %ebx
	jae	.L240
	.p2align 4,,10
	.p2align 3
.L82:
	movl	260(%esp), %esi
	movl	356(%esp), %ecx
	movl	(%esi), %ebx
	movl	352(%esp), %edx
	movl	4(%esi), %esi
	movl	%ebx, 248(%esp)
	movl	%esi, 252(%esp)
	cmpl	%edi, %ecx
	ja	.L90
	jb	.L99
	cmpl	%ebp, %edx
	jbe	.L99
.L90:
	movl	248(%esp), %ebx
	movl	252(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	ja	.L99
	jb	.L93
	cmpl	%ebx, %ebp
	jb	.L93
	.p2align 4,,10
	.p2align 3
.L99:
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	.p2align 4,,3
	.p2align 3
	je	.L92
	movl	%edx, %ebx
	movl	%ecx, %esi
.L98:
	cmpl	%esi, %edi
	jb	.L93
	ja	.L241
	cmpl	%ebx, %ebp
	.p2align 4,,3
	.p2align 3
	jb	.L93
.L241:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L93
	.p2align 4,,4
	.p2align 3
	ja	.L242
	cmpl	kmin, %ebx
	jae	.L242
	.p2align 4,,10
	.p2align 3
.L93:
	movl	172(%esp), %esi
	movl	364(%esp), %ecx
	movl	(%esi), %ebx
	movl	360(%esp), %edx
	movl	4(%esi), %esi
	movl	%ebx, 200(%esp)
	movl	%esi, 204(%esp)
	cmpl	%edi, %ecx
	jb	.L101
	ja	.L243
	cmpl	%ebp, %edx
	jbe	.L101
.L243:
	movl	200(%esp), %ebx
	movl	204(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	cmpl	%esi, %edi
	jb	.L103
	ja	.L101
	cmpl	%ebx, %ebp
	jb	.L103
	.p2align 4,,10
	.p2align 3
.L101:
	movl	%edx, %eax
	movl	%edx, %ebx
	andl	$1, %eax
	movl	%ecx, %esi
	testl	%eax, %eax
	jne	.L106
	movl	200(%esp), %ebx
	movl	204(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
.L106:
	cmpl	%edi, %esi
	ja	.L103
	jb	.L244
	cmpl	%ebp, %ebx
	ja	.L103
.L244:
	cmpl	kmin+4, %esi
	.p2align 4,,4
	.p2align 3
	jb	.L103
	.p2align 4,,4
	.p2align 3
	ja	.L245
	cmpl	kmin, %ebx
	jae	.L245
	.p2align 4,,10
	.p2align 3
.L103:
	incl	196(%esp)
	movl	196(%esp), %ebp
	cmpl	nmax, %ebp
	ja	.L182
	movl	320(%esp), %ecx
	movl	324(%esp), %ebx
	movl	%ecx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L112
	movl	168(%esp), %edi
	xorl	%eax, %eax
	movl	(%edi), %esi
	xorl	%edx, %edx
	movl	4(%edi), %edi
	movl	%esi, 128(%esp)
	movl	%edi, 132(%esp)
.L113:
	addl	%ecx, %eax
	movl	332(%esp), %esi
	adcl	%ebx, %edx
	movl	328(%esp), %ebx
	shrdl	$1, %edx, %eax
	xorl	%ecx, %ecx
	shrl	%edx
	movl	%eax, 320(%esp)
	movl	%edx, 324(%esp)
	movl	%ebx, %eax
	xorl	%edx, %edx
	andl	$1, %eax
	testl	%eax, %eax
	je	.L115
	movl	268(%esp), %edi
	movl	(%edi), %edx
	movl	4(%edi), %ecx
.L115:
	addl	%ebx, %edx
	movl	336(%esp), %ebx
	adcl	%esi, %ecx
	movl	%ebx, %eax
	shrdl	$1, %ecx, %edx
	andl	$1, %eax
	shrl	%ecx
	movl	%edx, 328(%esp)
	movl	%ecx, 332(%esp)
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movl	340(%esp), %esi
	testl	%eax, %eax
	je	.L117
	movl	112(%esp), %ebp
	movl	(%ebp), %edx
	movl	4(%ebp), %ecx
.L117:
	addl	%ebx, %edx
	movl	344(%esp), %ebx
	adcl	%esi, %ecx
	movl	%ebx, %eax
	shrdl	$1, %ecx, %edx
	andl	$1, %eax
	shrl	%ecx
	movl	%edx, 336(%esp)
	movl	%ecx, 340(%esp)
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movl	348(%esp), %esi
	testl	%eax, %eax
	je	.L119
	movl	264(%esp), %eax
	movl	(%eax), %edx
	movl	4(%eax), %ecx
.L119:
	addl	%ebx, %edx
	movl	352(%esp), %ebx
	adcl	%esi, %ecx
	movl	%ebx, %eax
	shrdl	$1, %ecx, %edx
	andl	$1, %eax
	shrl	%ecx
	movl	%edx, 344(%esp)
	movl	%ecx, 348(%esp)
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movl	356(%esp), %esi
	testl	%eax, %eax
	je	.L121
	movl	260(%esp), %edi
	movl	(%edi), %edx
	movl	4(%edi), %ecx
.L121:
	addl	%ebx, %edx
	movl	360(%esp), %ebx
	adcl	%esi, %ecx
	movl	%ebx, %eax
	shrdl	$1, %ecx, %edx
	andl	$1, %eax
	shrl	%ecx
	movl	%edx, 352(%esp)
	movl	%ecx, 356(%esp)
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movl	364(%esp), %esi
	testl	%eax, %eax
	je	.L123
	movl	172(%esp), %ebp
	movl	(%ebp), %edx
	movl	4(%ebp), %ecx
.L123:
	addl	%ebx, %edx
	adcl	%esi, %ecx
	shrdl	$1, %ecx, %edx
	shrl	%ecx
	movl	%edx, 360(%esp)
	movl	%ecx, 364(%esp)
	jmp	.L124
	.p2align 4,,10
	.p2align 3
.L245:
	xorl	%ebx, %edx
	movl	%esi, %eax
	movl	196(%esp), %edi
	xorl	%ecx, %eax
	movl	%edi, 8(%esp)
	orl	%edx, %eax
	movl	%ebx, (%esp)
	cmpl	$1, %eax
	movl	%esi, 4(%esp)
	sbbl	%eax, %eax
	movl	204(%esp), %edx
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	200(%esp), %eax
	call	test_factor
	jmp	.L103
	.p2align 4,,10
	.p2align 3
.L242:
	xorl	%ebx, %edx
	movl	196(%esp), %edi
	movl	%esi, %eax
	movl	%edi, 8(%esp)
	xorl	%ecx, %eax
	movl	%ebx, (%esp)
	orl	%edx, %eax
	movl	%esi, 4(%esp)
	cmpl	$1, %eax
	movl	252(%esp), %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	248(%esp), %eax
	call	test_factor
	movl	kmax, %ebp
	movl	kmax+4, %edi
	jmp	.L93
	.p2align 4,,10
	.p2align 3
.L240:
	xorl	%ebx, %edx
	movl	196(%esp), %edi
	movl	%esi, %eax
	movl	%edi, 8(%esp)
	xorl	%ecx, %eax
	movl	%ebx, (%esp)
	orl	%edx, %eax
	movl	%esi, 4(%esp)
	cmpl	$1, %eax
	movl	244(%esp), %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	240(%esp), %eax
	call	test_factor
	movl	kmax, %ebp
	movl	kmax+4, %edi
	jmp	.L82
	.p2align 4,,10
	.p2align 3
.L238:
	xorl	%ebx, %edx
	movl	196(%esp), %edi
	movl	%esi, %eax
	movl	%edi, 8(%esp)
	xorl	%ecx, %eax
	movl	%ebx, (%esp)
	orl	%edx, %eax
	movl	%esi, 4(%esp)
	cmpl	$1, %eax
	movl	236(%esp), %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	232(%esp), %eax
	call	test_factor
	movl	kmax, %ebp
	movl	kmax+4, %edi
	jmp	.L71
	.p2align 4,,10
	.p2align 3
.L236:
	xorl	%ebx, %edx
	movl	196(%esp), %edi
	movl	%esi, %eax
	movl	%edi, 8(%esp)
	xorl	%ecx, %eax
	movl	%ebx, (%esp)
	orl	%edx, %eax
	movl	%esi, 4(%esp)
	cmpl	$1, %eax
	movl	228(%esp), %edx
	sbbl	%eax, %eax
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	224(%esp), %eax
	call	test_factor
	movl	kmax, %ebp
	movl	kmax+4, %edi
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L234:
	xorl	%ebx, %edx
	movl	%esi, %eax
	movl	%ebx, (%esp)
	xorl	%ecx, %eax
	movl	%esi, 4(%esp)
	orl	%edx, %eax
	movl	196(%esp), %ecx
	cmpl	$1, %eax
	movl	%ecx, 8(%esp)
	sbbl	%eax, %eax
	movl	132(%esp), %edx
	orl	$1, %eax
	movl	%eax, 12(%esp)
	movl	128(%esp), %eax
	call	test_factor
	movl	kmax, %ebp
	movl	kmax+4, %edi
	jmp	.L49
	.p2align 4,,10
	.p2align 3
.L112:
	movl	168(%esp), %edx
	movl	(%edx), %eax
	movl	4(%edx), %edx
	movl	%eax, 128(%esp)
	movl	%edx, 132(%esp)
	jmp	.L113
	.p2align 4,,10
	.p2align 3
.L92:
	movl	248(%esp), %ebx
	movl	252(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	jmp	.L98
	.p2align 4,,10
	.p2align 3
.L59:
	movl	224(%esp), %ebx
	movl	228(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	jmp	.L65
	.p2align 4,,10
	.p2align 3
.L48:
	movl	128(%esp), %ebx
	movl	132(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	jmp	.L54
	.p2align 4,,10
	.p2align 3
.L81:
	movl	240(%esp), %ebx
	movl	244(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	jmp	.L87
	.p2align 4,,10
	.p2align 3
.L70:
	movl	232(%esp), %ebx
	movl	236(%esp), %esi
	subl	%edx, %ebx
	sbbl	%ecx, %esi
	jmp	.L76
	.p2align 4,,10
	.p2align 3
.L318:
	cmpl	kmax, %ebx
	ja	.L179
	jmp	.L269
	.p2align 4,,10
	.p2align 3
.L316:
	cmpl	kmax, %edi
	ja	.L174
	.p2align 4,,6
	.p2align 3
	jmp	.L267
	.p2align 4,,10
	.p2align 3
.L314:
	cmpl	kmax, %ebx
	ja	.L170
	.p2align 4,,6
	.p2align 3
	jmp	.L265
	.p2align 4,,10
	.p2align 3
.L312:
	cmpl	kmax, %edi
	ja	.L165
	.p2align 4,,6
	.p2align 3
	jmp	.L263
	.p2align 4,,10
	.p2align 3
.L310:
	cmpl	kmax, %ebx
	ja	.L161
	.p2align 4,,6
	.p2align 3
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L308:
	cmpl	kmax, %edi
	ja	.L156
	.p2align 4,,6
	.p2align 3
	jmp	.L259
	.p2align 4,,10
	.p2align 3
.L306:
	cmpl	kmax, %ebx
	ja	.L152
	.p2align 4,,6
	.p2align 3
	jmp	.L257
	.p2align 4,,10
	.p2align 3
.L304:
	cmpl	kmax, %edi
	ja	.L147
	.p2align 4,,6
	.p2align 3
	jmp	.L255
	.p2align 4,,10
	.p2align 3
.L302:
	cmpl	kmax, %ebx
	ja	.L143
	.p2align 4,,6
	.p2align 3
	jmp	.L253
	.p2align 4,,10
	.p2align 3
.L300:
	cmpl	kmax, %edi
	ja	.L138
	.p2align 4,,6
	.p2align 3
	jmp	.L251
	.p2align 4,,10
	.p2align 3
.L298:
	cmpl	kmax, %ebx
	ja	.L134
	.p2align 4,,6
	.p2align 3
	jmp	.L249
	.p2align 4,,10
	.p2align 3
.L320:
	cmpl	kmax, %edi
	ja	.L129
	.p2align 4,,6
	.p2align 3
	jmp	.L247
	.p2align 4,,10
	.p2align 3
.L299:
	.p2align 4,,6
	.p2align 3
	ja	.L250
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L134
.L250:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	(%ebp), %eax
	movl	4(%ebp), %edx
	call	test_factor
	jmp	.L134
	.p2align 4,,10
	.p2align 3
.L303:
	ja	.L254
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L143
.L254:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	call	test_factor
	jmp	.L143
	.p2align 4,,10
	.p2align 3
.L301:
	ja	.L252
	movl	56(%esp), %edx
	cmpl	kmin, %edx
	.p2align 4,,3
	.p2align 3
	jb	.L138
.L252:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L138
	movl	%ebx, 8(%esp)
	movl	60(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	56(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	8(%esi), %eax
	movl	12(%esi), %edx
	call	test_factor
	jmp	.L138
	.p2align 4,,10
	.p2align 3
.L311:
	ja	.L262
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L161
.L262:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	24(%ebp), %eax
	movl	28(%ebp), %edx
	call	test_factor
	jmp	.L161
	.p2align 4,,10
	.p2align 3
.L319:
	ja	.L270
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L179
.L270:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	40(%ebp), %eax
	movl	44(%ebp), %edx
	call	test_factor
	jmp	.L179
	.p2align 4,,10
	.p2align 3
.L307:
	ja	.L258
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L152
.L258:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	20(%ebp), %edx
	call	test_factor
	jmp	.L152
	.p2align 4,,10
	.p2align 3
.L315:
	ja	.L266
	cmpl	kmin, %ebx
	.p2align 4,,6
	.p2align 3
	jb	.L170
.L266:
	movl	%ebx, (%esp)
	movl	%ecx, 4(%esp)
	movl	168(%esp), %ebp
	movl	28(%esp), %edx
	movl	196(%esp), %edi
	addl	%edx, %edx
	movl	%edi, 8(%esp)
	movl	$1, %eax
	subl	%edx, %eax
	movl	%eax, 12(%esp)
	movl	32(%ebp), %eax
	movl	36(%ebp), %edx
	call	test_factor
	jmp	.L170
	.p2align 4,,10
	.p2align 3
.L309:
	ja	.L260
	movl	72(%esp), %edx
	cmpl	kmin, %edx
	.p2align 4,,3
	.p2align 3
	jb	.L156
.L260:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L156
	movl	%ebx, 8(%esp)
	movl	76(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	72(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	24(%esi), %eax
	movl	28(%esi), %edx
	call	test_factor
	jmp	.L156
	.p2align 4,,10
	.p2align 3
.L317:
	ja	.L268
	movl	40(%esp), %edx
	cmpl	kmin, %edx
	.p2align 4,,3
	.p2align 3
	jb	.L174
.L268:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L174
	movl	%ebx, 8(%esp)
	movl	44(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	40(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	40(%esi), %eax
	movl	44(%esi), %edx
	call	test_factor
	jmp	.L174
	.p2align 4,,10
	.p2align 3
.L305:
	ja	.L256
	movl	64(%esp), %edx
	cmpl	kmin, %edx
	.p2align 4,,3
	.p2align 3
	jb	.L147
.L256:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L147
	movl	%ebx, 8(%esp)
	movl	68(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	64(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	16(%esi), %eax
	movl	20(%esi), %edx
	call	test_factor
	jmp	.L147
	.p2align 4,,10
	.p2align 3
.L313:
	ja	.L264
	movl	80(%esp), %edx
	cmpl	kmin, %edx
	.p2align 4,,3
	.p2align 3
	jb	.L165
.L264:
	movl	196(%esp), %ecx
	leal	(%eax,%ecx), %ebx
	cmpl	nmax, %ebx
	ja	.L165
	movl	%ebx, 8(%esp)
	movl	84(%esp), %esi
	movl	28(%esp), %eax
	movl	%esi, 4(%esp)
	addl	%eax, %eax
	movl	168(%esp), %esi
	decl	%eax
	movl	80(%esp), %ebx
	movl	%eax, 12(%esp)
	movl	%ebx, (%esp)
	movl	32(%esi), %eax
	movl	36(%esi), %edx
	call	test_factor
	jmp	.L165
	.size	app_thread_fun, .-app_thread_fun
	.p2align 4,,15
.globl app_thread_fun1
	.type	app_thread_fun1, @function
app_thread_fun1:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$108, %esp
	movl	136(%esp), %ebp
	testl	%ebp, %ebp
	je	.L337
	leal	48(%esp), %eax
	cmpl	$19, %ebp
	movl	%eax, 28(%esp)
	ja	.L347
.L323:
	xorl	%ecx, %ecx
	movl	132(%esp), %ebx
	.p2align 4,,10
	.p2align 3
.L329:
	movl	(%ebx,%ecx,8), %eax
	movl	4(%ebx,%ecx,8), %edx
	movl	%eax, 48(%esp,%ecx,8)
	movl	%edx, 52(%esp,%ecx,8)
	incl	%ecx
	cmpl	%ecx, %ebp
	ja	.L329
	cmpl	$5, %ebp
	ja	.L327
	movl	%ebp, %eax
	leal	48(%esp), %edi
	notl	%eax
	addl	$7, %eax
	movl	%eax, 40(%esp)
	leal	0(,%ebp,8), %eax
	addl	%eax, %edi
	addl	%ebx, %eax
	cmpl	$21, 40(%esp)
	leal	-8(%eax), %edx
	ja	.L348
.L330:
	movl	132(%esp), %eax
	leal	48(%esp,%ebp,8), %ecx
	leal	-8(%eax,%ebp,8), %ebx
	.p2align 4,,10
	.p2align 3
.L336:
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$8, %ebx
	addl	$8, %ecx
	leal	96(%esp), %eax
	cmpl	%eax, %ecx
	jne	.L336
	.p2align 4,,10
	.p2align 3
.L327:
	leal	48(%esp), %ebx
	movl	128(%esp), %eax
	movl	%ebx, 4(%esp)
	movl	%eax, (%esp)
	call	app_thread_fun
.L337:
	addl	$108, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L347:
	movl	132(%esp), %eax
	addl	$16, %eax
	cmpl	%eax, 28(%esp)
	jbe	.L349
.L338:
	movl	%ebp, %ecx
	shrl	%ecx
	movl	%ecx, %esi
	addl	%esi, %esi
	je	.L325
	xorl	%edx, %edx
	xorl	%eax, %eax
	movl	132(%esp), %ebx
	.p2align 4,,10
	.p2align 3
.L326:
	movdqu	(%ebx,%eax), %xmm0
	incl	%edx
	movdqa	%xmm0, 48(%esp,%eax)
	addl	$16, %eax
	cmpl	%ecx, %edx
	jb	.L326
	cmpl	%esi, %ebp
	je	.L327
.L325:
	leal	0(,%esi,8), %eax
	movl	132(%esp), %ebx
	leal	48(%esp), %ecx
	addl	%eax, %ebx
	addl	%eax, %ecx
	.p2align 4,,10
	.p2align 3
.L328:
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	incl	%esi
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$8, %ebx
	addl	$8, %ecx
	cmpl	%esi, %ebp
	ja	.L328
	jmp	.L327
	.p2align 4,,10
	.p2align 3
.L349:
	leal	64(%esp), %eax
	cmpl	%eax, 132(%esp)
	jbe	.L323
	.p2align 4,,2
	.p2align 3
	jmp	.L338
	.p2align 4,,10
	.p2align 3
.L348:
	testl	$12, %edi
	jne	.L330
	addl	$8, %eax
	cmpl	%eax, %edi
	.p2align 4,,5
	.p2align 3
	ja	.L339
	leal	16(%edi), %eax
	cmpl	%eax, %edx
	jbe	.L330
.L339:
	movl	40(%esp), %ebx
	movl	%edx, %ecx
	shrl	%ebx
	xorl	%edx, %edx
	movl	%ebx, %eax
	movl	%ebp, %esi
	addl	%eax, %eax
	movl	%eax, 44(%esp)
	je	.L333
	.p2align 4,,10
	.p2align 3
.L340:
	movl	%edx, %eax
	movdqu	(%ecx), %xmm0
	sall	$4, %eax
	incl	%edx
	addl	$16, %ecx
	movdqa	%xmm0, (%edi,%eax)
	cmpl	%ebx, %edx
	jb	.L340
	movl	44(%esp), %ebx
	leal	(%ebp,%ebx), %esi
	cmpl	%ebx, 40(%esp)
	je	.L327
.L333:
	movl	132(%esp), %eax
	leal	48(%esp,%esi,8), %ecx
	leal	-8(%eax,%esi,8), %ebx
	.p2align 4,,10
	.p2align 3
.L335:
	movl	(%ebx), %eax
	movl	4(%ebx), %edx
	incl	%esi
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	addl	$8, %ebx
	addl	$8, %ecx
	cmpl	$5, %esi
	jbe	.L335
	jmp	.L327
	.size	app_thread_fun1, .-app_thread_fun1
	.section	.rodata.str1.4
	.align 4
.LC7:
	.string	"Please specify an input file or both of kmin,kmax\n"
	.section	.rodata.str1.1
.LC8:
	.string	"r"
	.section	.rodata.str1.4
	.align 4
.LC9:
	.string	"ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%llu]"
	.section	.rodata.str1.1
.LC10:
	.string	"%llu:T:%*c:2:%c"
.LC11:
	.string	" %llu %u"
	.section	.rodata.str1.4
	.align 4
.LC12:
	.string	"Invalid line 2 in input file `%s'\n"
	.align 4
.LC13:
	.string	"Invalid header in input file `%s'\n"
	.section	.rodata.str1.1
.LC14:
	.string	" %llu"
	.section	.rodata.str1.4
	.align 4
.LC15:
	.string	" ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%llu]"
	.align 4
.LC16:
	.string	"Error reading input file `%s'\n"
	.section	.rodata.str1.1
.LC17:
	.string	"kmin <= kmax is required\n"
.LC18:
	.string	"kmax < pmin is required\n"
	.section	.rodata.str1.4
	.align 4
.LC19:
	.string	"kmax-kmin < 3*2^36 is required\n"
	.align 4
.LC20:
	.string	"Please specify a value for nmin\n"
	.section	.rodata.str1.1
.LC21:
	.string	"nmin <= nmax is required\n"
.LC22:
	.string	"nstart=%u, nstep=%u\n"
	.section	.rodata.str1.4
	.align 4
.LC23:
	.string	"Read %u terms from ABCD format input file `%s'\n"
	.section	.rodata.str1.1
.LC24:
	.string	" %llu:T:%*c:2:%c"
.globl __umoddi3
	.section	.rodata.str1.4
	.align 4
.LC25:
	.string	"Invalid line %u in input file `%s'\n"
	.align 4
.LC26:
	.string	"Read %u terms from NewPGen format input file `%s'\n"
	.section	.rodata.str1.1
.LC27:
	.string	"tpfactors.txt"
.LC28:
	.string	"a"
	.section	.rodata.str1.4
	.align 4
.LC29:
	.string	"Cannot open factors file `%s'\n"
	.align 4
.LC30:
	.string	"tpsieve initialized: %llu <= k <= %llu, %u <= n <= %u\n"
	.text
	.p2align 4,,15
.globl app_init
	.type	app_init, @function
app_init:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$204, %esp
	movl	input_filename, %eax
	movl	%eax, 92(%esp)
	testl	%eax, %eax
	je	.L439
	movl	kmin+4, %eax
	orl	kmin, %eax
	je	.L354
	movl	kmax+4, %eax
	orl	kmax, %eax
	jne	.L440
.L354:
	movl	92(%esp), %edx
	movl	$.LC8, 4(%esp)
	movl	%edx, (%esp)
	call	fopen
	movl	%eax, 100(%esp)
	testl	%eax, %eax
	je	.L441
	leal	188(%esp), %edx
	leal	192(%esp), %ecx
	leal	176(%esp), %eax
	movl	%edx, 60(%esp)
	movl	%eax, 16(%esp)
	movl	%edx, 12(%esp)
	movl	100(%esp), %eax
	movl	%ecx, 56(%esp)
	movl	%ecx, 8(%esp)
	movl	$.LC9, 4(%esp)
	movl	%eax, (%esp)
	call	fscanf
	cmpl	$3, %eax
	je	.L442
.L356:
	leal	199(%esp), %eax
	movl	$.LC10, 4(%esp)
	movl	%eax, 12(%esp)
	leal	160(%esp), %eax
	movl	%eax, 8(%esp)
	movl	100(%esp), %eax
	movl	%eax, (%esp)
	call	fscanf
	cmpl	$2, %eax
	jne	.L358
	cmpb	$51, 199(%esp)
	je	.L443
.L358:
	movl	92(%esp), %ecx
	movl	$.LC13, 8(%esp)
	movl	%ecx, 12(%esp)
.L438:
	movl	stderr, %eax
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$1, (%esp)
	call	exit
	.p2align 4,,10
	.p2align 3
.L442:
	movl	192(%esp), %eax
	cmpl	188(%esp), %eax
	jne	.L356
	movl	176(%esp), %edx
	movl	180(%esp), %ecx
	movl	$2, file_format
	movl	%edx, 76(%esp)
	movl	%ecx, 72(%esp)
	movl	%eax, 96(%esp)
.L357:
	movl	96(%esp), %eax
	leal	168(%esp), %edx
	movl	%eax, 148(%esp)
	movl	72(%esp), %ebx
	movl	76(%esp), %eax
	movl	%ebx, 140(%esp)
	movl	%eax, 136(%esp)
	movl	%edx, 64(%esp)
	movl	%edx, %ecx
	jmp	.L361
	.p2align 4,,10
	.p2align 3
.L444:
	movl	72(%esp), %ebx
	movl	176(%esp), %edx
	movl	180(%esp), %esi
	movl	76(%esp), %eax
	movl	%edx, 68(%esp)
	movl	%eax, %edi
	movl	%ebx, %ebp
	cmpl	%esi, %ebx
	ja	.L363
	jb	.L364
	cmpl	68(%esp), %eax
	jae	.L363
.L364:
	movl	68(%esp), %eax
	movl	%esi, %ebp
	movl	%eax, %edi
.L363:
	leal	176(%esp), %ecx
	movl	60(%esp), %eax
	movl	%ecx, 16(%esp)
	movl	56(%esp), %edx
	movl	100(%esp), %ecx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC15, 4(%esp)
	movl	%ecx, (%esp)
	call	fscanf
	cmpl	$3, %eax
	jne	.L365
	movl	192(%esp), %esi
	cmpl	188(%esp), %esi
	jne	.L365
	movl	180(%esp), %edx
	movl	176(%esp), %eax
	movl	%edx, 80(%esp)
	movl	%eax, 84(%esp)
	cmpl	%edx, 140(%esp)
	jb	.L366
	ja	.L367
	cmpl	%eax, 136(%esp)
	jbe	.L366
.L367:
	movl	84(%esp), %eax
	movl	80(%esp), %ebx
	movl	%eax, 136(%esp)
	movl	%ebx, 140(%esp)
.L366:
	movl	80(%esp), %ecx
	movl	%edi, 76(%esp)
	movl	%ebp, 72(%esp)
	cmpl	%ecx, %ebp
	ja	.L368
	jb	.L369
	movl	84(%esp), %eax
	cmpl	%eax, %edi
	jae	.L368
.L369:
	movl	84(%esp), %edx
	movl	80(%esp), %ecx
	movl	%edx, 76(%esp)
	movl	%ecx, 72(%esp)
.L368:
	cmpl	%esi, 96(%esp)
	movl	96(%esp), %eax
	cmova	%esi, %eax
	cmpl	148(%esp), %esi
	movl	%eax, 96(%esp)
	cmovbe	148(%esp), %esi
.L370:
	movl	%esi, 148(%esp)
	movl	64(%esp), %ecx
.L361:
	movl	100(%esp), %eax
	movl	%ecx, 8(%esp)
	movl	$.LC14, 4(%esp)
	movl	%eax, (%esp)
	call	fscanf
	decl	%eax
	jne	.L444
	movl	168(%esp), %eax
	movl	172(%esp), %edx
	addl	%eax, 176(%esp)
	movl	148(%esp), %esi
	adcl	%edx, 180(%esp)
	jmp	.L370
	.p2align 4,,10
	.p2align 3
.L440:
	movl	nmin, %esi
	testl	%esi, %esi
	je	.L354
	movl	nmax, %ebx
	testl	%ebx, %ebx
	je	.L354
	.p2align 4,,10
	.p2align 3
.L353:
	movl	kmin+4, %ebp
	movl	kmax+4, %esi
	movl	kmin, %edi
	movl	kmax, %ebx
	cmpl	%esi, %ebp
	jb	.L385
	jbe	.L445
.L426:
	movl	stderr, %eax
	movl	$25, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC17, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
	.p2align 4,,10
	.p2align 3
.L443:
	movl	60(%esp), %edx
	leal	176(%esp), %ecx
	movl	100(%esp), %eax
	movl	$1, file_format
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	%eax, (%esp)
	call	fscanf
	cmpl	$2, %eax
	jne	.L446
	movl	176(%esp), %eax
	movl	180(%esp), %edx
	movl	188(%esp), %ecx
	movl	%eax, 76(%esp)
	movl	%edx, 72(%esp)
	movl	%ecx, 96(%esp)
	cmpl	$2, file_format
	je	.L357
	movl	%edx, %ebx
	movl	%ecx, 148(%esp)
	movl	%eax, %edi
	movl	%ebx, %ebp
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L375:
	movl	180(%esp), %edx
	movl	176(%esp), %ecx
	cmpl	%edx, 72(%esp)
	jb	.L371
	ja	.L372
	cmpl	%ecx, 76(%esp)
	jbe	.L371
.L372:
	movl	%ecx, 76(%esp)
	movl	%edx, 72(%esp)
.L371:
	cmpl	%edx, %ebp
	ja	.L373
	jb	.L374
	cmpl	%ecx, %edi
	jae	.L373
.L374:
	movl	%ecx, %eax
	movl	%edx, %ebx
	movl	%eax, %edi
	movl	%ebx, %ebp
.L373:
	movl	188(%esp), %eax
	movl	96(%esp), %edx
	cmpl	%eax, 96(%esp)
	cmova	%eax, %edx
	cmpl	%eax, 148(%esp)
	movl	%edx, 96(%esp)
	cmovae	148(%esp), %eax
	movl	%eax, 148(%esp)
.L360:
	movl	60(%esp), %ecx
	leal	176(%esp), %eax
	movl	100(%esp), %edx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	%edx, (%esp)
	call	fscanf
	cmpl	$2, %eax
	je	.L375
	movl	76(%esp), %eax
	movl	72(%esp), %ebx
	movl	%eax, 136(%esp)
	movl	%ebx, 140(%esp)
.L365:
	movl	100(%esp), %ecx
	movl	%ecx, (%esp)
	call	ferror
	testl	%eax, %eax
	jne	.L447
	movl	100(%esp), %edx
	movl	%edx, (%esp)
	call	fclose
	cmpl	$2, file_format
	je	.L448
.L377:
	movl	140(%esp), %edx
	cmpl	%edx, kmin+4
	ja	.L378
	jb	.L425
	movl	136(%esp), %ecx
	cmpl	%ecx, kmin
	jb	.L425
	.p2align 4,,10
	.p2align 3
.L378:
	movl	kmax, %edx
	movl	kmax+4, %eax
	movl	%eax, %ecx
	orl	%edx, %ecx
	je	.L380
	cmpl	%ebp, %eax
	jb	.L381
	jbe	.L449
	.p2align 4,,10
	.p2align 3
.L380:
	movl	%edi, kmax
	movl	%ebp, kmax+4
.L381:
	movl	96(%esp), %eax
	cmpl	%eax, nmin
	jae	.L383
	movl	%eax, nmin
.L383:
	movl	nmax, %eax
	testl	%eax, %eax
	je	.L384
	cmpl	148(%esp), %eax
	jbe	.L353
.L384:
	movl	148(%esp), %edx
	movl	%edx, nmax
	jmp	.L353
	.p2align 4,,10
	.p2align 3
.L425:
	movl	136(%esp), %eax
	movl	140(%esp), %edx
	movl	%eax, kmin
	movl	%edx, kmin+4
	jmp	.L378
	.p2align 4,,10
	.p2align 3
.L445:
	cmpl	%ebx, %edi
	ja	.L426
.L385:
	cmpl	pmin+4, %esi
	jb	.L387
	.p2align 4,,4
	.p2align 3
	jbe	.L450
.L427:
	movl	stderr, %eax
	movl	$24, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC18, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
	.p2align 4,,10
	.p2align 3
.L450:
	cmpl	pmin, %ebx
	jae	.L427
.L387:
	movl	%ebx, %eax
	movl	%esi, %edx
	subl	%edi, %eax
	sbbl	%ebp, %edx
	cmpl	$47, %edx
	ja	.L451
	movl	nmin, %ecx
	movl	%ecx, 124(%esp)
	testl	%ecx, %ecx
	je	.L452
	movl	nmax, %eax
	movl	%eax, 52(%esp)
	testl	%eax, %eax
	jne	.L391
	movl	124(%esp), %edx
	movl	%edx, nmax
	movl	%edx, 52(%esp)
.L392:
	movl	%edi, (%esp)
	movl	%ebp, 4(%esp)
	movl	$6, 8(%esp)
	movl	$0, 12(%esp)
	call	__udivdi3
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	movl	$6, %ebx
	movl	%eax, b0
	movl	%edx, b0+4
	movl	$6, 8(%esp)
	movl	$0, 12(%esp)
	call	__udivdi3
	imull	$6, b0+4, %ecx
	movl	%eax, b1
	movl	%edx, b1+4
	movl	b0, %eax
	movl	pmin+4, %ebp
	mull	%ebx
	movl	$1, nstep
	leal	(%ecx,%edx), %edi
	movl	%eax, %esi
	movl	b1, %eax
	addl	$3, %esi
	adcl	$0, %edi
	movl	%esi, kmin
	mull	%ebx
	imull	$6, b1+4, %ecx
	movl	%eax, 32(%esp)
	addl	%ecx, %edx
	movl	%edi, kmin+4
	movl	%edx, 36(%esp)
	movl	32(%esp), %esi
	movl	36(%esp), %edi
	addl	$3, %esi
	movl	32(%esp), %eax
	adcl	$0, %edi
	movl	36(%esp), %edx
	addl	$4, %eax
	movl	%esi, kmax
	adcl	$0, %edx
	movl	%eax, xkmax
	movl	%edx, xkmax+4
	movl	%eax, xkmax+8
	movl	%edx, xkmax+12
	movl	%esi, %eax
	movl	pmin, %edx
	addl	%esi, %eax
	movl	%edx, 88(%esp)
	movl	%edi, kmax+4
	movl	%edi, %edx
	shldl	$1, %esi, %edx
	cmpl	%edx, %ebp
	ja	.L393
	jae	.L453
.L428:
	movl	$1, %ecx
	.p2align 4,,10
	.p2align 3
.L395:
	movl	52(%esp), %eax
	subl	124(%esp), %eax
	leal	1(%eax), %edx
	cmpl	%ecx, %edx
	jae	.L399
	movl	%edx, nstep
.L399:
	movl	nstep, %ebx
	cmpl	$1, %ebx
	jbe	.L454
	xorl	%edx, %edx
	divl	%ebx
	imull	%ebx, %eax
	addl	124(%esp), %eax
	movl	%eax, nstart
.L401:
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC22, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	input_filename, %ebp
	testl	%ebp, %ebp
	je	.L402
	movl	nmax, %eax
	subl	nmin, %eax
	leal	4(,%eax,4), %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	nmin, %esi
	movl	%eax, bitmap
	cmpl	nmax, %esi
	ja	.L403
	.p2align 4,,10
	.p2align 3
.L433:
	movl	%esi, %ebx
	movl	b1, %eax
	subl	nmin, %ebx
	movl	b1+4, %edx
	sall	$2, %ebx
	addl	bitmap, %ebx
	addl	$8, %eax
	adcl	$0, %edx
	subl	b0, %eax
	sbbl	b0+4, %edx
	shrdl	$3, %edx, %eax
	movl	%eax, (%esp)
	call	xmalloc
	movl	b1+4, %edx
	movl	%eax, (%ebx)
	movl	bitmap, %ecx
	movl	b1, %eax
	movl	%esi, %ebx
	addl	$8, %eax
	adcl	$0, %edx
	subl	b0, %eax
	sbbl	b0+4, %edx
	subl	nmin, %ebx
	shrdl	$3, %edx, %eax
	movl	(%ecx,%ebx,4), %ecx
	incl	%esi
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	%ecx, (%esp)
	call	memset
	cmpl	%esi, nmax
	jae	.L433
.L403:
	cmpl	$2, file_format
	je	.L455
	movl	input_filename, %ecx
	movl	$.LC8, 4(%esp)
	movl	%ecx, 132(%esp)
	movl	%ecx, (%esp)
	call	fopen
	movl	%eax, 116(%esp)
	testl	%eax, %eax
	je	.L456
	movl	%eax, %edx
	movl	$.LC24, 4(%esp)
	leal	199(%esp), %eax
	movl	%edx, (%esp)
	movl	%eax, 12(%esp)
	leal	160(%esp), %eax
	movl	%eax, 8(%esp)
	call	fscanf
	cmpl	$2, %eax
	jne	.L415
	cmpb	$51, 199(%esp)
	je	.L457
.L415:
	movl	132(%esp), %edx
	movl	$.LC13, 8(%esp)
	movl	%edx, 12(%esp)
	jmp	.L438
	.p2align 4,,10
	.p2align 3
.L453:
	cmpl	%eax, 88(%esp)
	jbe	.L428
.L393:
	movl	$2, %ecx
	.p2align 4,,10
	.p2align 3
.L398:
	movl	%esi, %eax
	movl	%edi, %edx
	leal	1(%ecx), %ebx
	shldl	%eax, %edx
	sall	%cl, %eax
	testb	$32, %cl
	je	.L466
	movl	%eax, %edx
	xorl	%eax, %eax
.L466:
	cmpl	%ebp, %edx
	jbe	.L458
.L396:
	movl	%ecx, nstep
	jmp	.L395
	.p2align 4,,10
	.p2align 3
.L458:
	jb	.L429
	cmpl	88(%esp), %eax
	.p2align 4,,3
	.p2align 3
	jae	.L396
.L429:
	movl	%ebx, %ecx
	.p2align 4,,6
	.p2align 3
	jmp	.L398
	.p2align 4,,10
	.p2align 3
.L391:
	cmpl	%eax, 124(%esp)
	.p2align 4,,3
	.p2align 3
	jbe	.L392
	movl	stderr, %eax
	movl	$25, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC21, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
.L408:
	leal	168(%esp), %eax
	movl	$0, 104(%esp)
	movl	%eax, 64(%esp)
	.p2align 4,,10
	.p2align 3
.L412:
	movl	160(%esp), %eax
	movl	164(%esp), %edx
	subl	b0, %eax
	movl	192(%esp), %ecx
	sbbl	b0+4, %edx
	movl	bitmap, %edi
	subl	nmin, %ecx
	movl	%eax, %ebx
	shrdl	$3, %edx, %ebx
	movl	$1, %edx
	addl	(%edi,%ecx,4), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	sall	%cl, %edx
	orb	%dl, (%ebx)
	incl	104(%esp)
	jmp	.L409
	.p2align 4,,10
	.p2align 3
.L410:
	movl	168(%esp), %eax
	movl	172(%esp), %edx
	addl	160(%esp), %eax
	movl	192(%esp), %ecx
	adcl	164(%esp), %edx
	movl	%eax, 160(%esp)
	movl	%edx, 164(%esp)
	subl	b0, %eax
	movl	bitmap, %edi
	sbbl	b0+4, %edx
	movl	%eax, %ebx
	subl	nmin, %ecx
	shrdl	$3, %edx, %ebx
	addl	(%edi,%ecx,4), %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	sall	%cl, %ebp
	movl	%ebp, %ecx
	orb	%cl, (%ebx)
	incl	104(%esp)
.L409:
	movl	64(%esp), %eax
	movl	108(%esp), %edx
	movl	%eax, 8(%esp)
	movl	$.LC14, 4(%esp)
	movl	%edx, (%esp)
	call	fscanf
	movl	%eax, %ebp
	cmpl	$1, %eax
	je	.L410
	leal	160(%esp), %ecx
	movl	56(%esp), %eax
	movl	%ecx, 16(%esp)
	movl	60(%esp), %edx
	movl	108(%esp), %ecx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC15, 4(%esp)
	movl	%ecx, (%esp)
	call	fscanf
	cmpl	$3, %eax
	jne	.L411
	movl	188(%esp), %eax
	cmpl	192(%esp), %eax
	je	.L412
.L411:
	movl	108(%esp), %eax
	movl	%eax, (%esp)
	call	ferror
	testl	%eax, %eax
	jne	.L459
	movl	108(%esp), %ecx
	movl	%ecx, (%esp)
	call	fclose
	movl	128(%esp), %eax
	movl	104(%esp), %edx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC23, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	.p2align 4,,10
	.p2align 3
.L402:
	movl	factors_filename, %ebx
	testl	%ebx, %ebx
	je	.L460
.L422:
	movl	factors_filename, %eax
	movl	$.LC28, 4(%esp)
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, factors_file
	testl	%eax, %eax
	je	.L461
	movl	$0, 4(%esp)
	movl	$factors_mutex, (%esp)
	call	pthread_mutex_init
	movl	nmax, %eax
	movl	kmax+4, %edx
	movl	%eax, 28(%esp)
	movl	%edx, 20(%esp)
	movl	nmin, %eax
	movl	kmin+4, %edx
	movl	%eax, 24(%esp)
	movl	%edx, 12(%esp)
	movl	kmax, %eax
	movl	$.LC30, 4(%esp)
	movl	%eax, 16(%esp)
	movl	$1, (%esp)
	movl	kmin, %eax
	movl	%eax, 8(%esp)
	call	__printf_chk
	movl	stdout, %eax
	movl	%eax, (%esp)
	call	fflush
	addl	$204, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.p2align 4,,10
	.p2align 3
.L439:
	movl	kmin+4, %eax
	orl	kmin, %eax
	je	.L352
	movl	kmax+4, %eax
	orl	kmax, %eax
	jne	.L353
.L352:
	movl	stderr, %eax
	movl	$50, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC7, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
	.p2align 4,,10
	.p2align 3
.L454:
	movl	124(%esp), %ecx
	movl	%ecx, nstart
	movl	%ecx, %eax
	jmp	.L401
	.p2align 4,,10
	.p2align 3
.L455:
	movl	input_filename, %ecx
	movl	$.LC8, 4(%esp)
	movl	%ecx, 128(%esp)
	movl	%ecx, (%esp)
	call	fopen
	movl	%eax, 108(%esp)
	testl	%eax, %eax
	je	.L462
	leal	192(%esp), %ecx
	leal	188(%esp), %eax
	leal	160(%esp), %edx
	movl	%ecx, 56(%esp)
	movl	%edx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	108(%esp), %edx
	movl	%eax, 60(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC9, 4(%esp)
	movl	%edx, (%esp)
	call	fscanf
	cmpl	$3, %eax
	jne	.L407
	movl	188(%esp), %eax
	cmpl	192(%esp), %eax
	je	.L408
.L407:
	movl	128(%esp), %ecx
	movl	$.LC13, 8(%esp)
	movl	%ecx, 12(%esp)
	jmp	.L438
	.p2align 4,,10
	.p2align 3
.L448:
	imull	$6, 140(%esp), %ecx
	movl	$6, %ebx
	movl	136(%esp), %eax
	mull	%ebx
	addl	%ecx, %edx
	movl	%eax, 40(%esp)
	movl	%edx, 44(%esp)
	movl	%edi, %eax
	movl	40(%esp), %edx
	movl	44(%esp), %ecx
	addl	$3, %edx
	adcl	$0, %ecx
	movl	%edx, 136(%esp)
	movl	%ecx, 140(%esp)
	mull	%ebx
	imull	$6, %ebp, %ecx
	movl	%eax, %edi
	leal	(%ecx,%edx), %esi
	addl	$3, %edi
	movl	%esi, %ebp
	adcl	$0, %ebp
	jmp	.L377
	.p2align 4,,10
	.p2align 3
.L457:
	leal	188(%esp), %ecx
	leal	168(%esp), %eax
	movl	$0, 112(%esp)
	xorl	%ebp, %ebp
	movl	%ecx, 60(%esp)
	movl	%eax, 64(%esp)
	.p2align 4,,10
	.p2align 3
.L437:
	movl	60(%esp), %ecx
	movl	64(%esp), %eax
	movl	116(%esp), %edx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	%edx, (%esp)
	call	fscanf
	cmpl	$2, %eax
	jne	.L463
	incl	%ebp
	movl	168(%esp), %ebx
	movl	172(%esp), %esi
	movl	$6, 8(%esp)
	movl	$0, 12(%esp)
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	call	__umoddi3
	movl	%eax, %ecx
	xorl	$3, %ecx
	orl	%edx, %ecx
	jne	.L464
	cmpl	kmin+4, %esi
	jb	.L437
	ja	.L430
	cmpl	kmin, %ebx
	jb	.L437
.L430:
	cmpl	kmax+4, %esi
	ja	.L437
	jb	.L431
	cmpl	kmax, %ebx
	ja	.L437
.L431:
	movl	nmin, %eax
	movl	188(%esp), %edi
	movl	%eax, 120(%esp)
	cmpl	%eax, %edi
	jb	.L437
	cmpl	nmax, %edi
	ja	.L437
	movl	%ebx, (%esp)
	movl	%esi, 4(%esp)
	movl	$6, 8(%esp)
	movl	$0, 12(%esp)
	call	__udivdi3
	movl	bitmap, %esi
	subl	b0, %eax
	sbbl	b0+4, %edx
	movl	%eax, %ecx
	subl	120(%esp), %edi
	shrdl	$3, %edx, %ecx
	movl	(%esi,%edi,4), %ebx
	movl	$1, %edx
	addl	%ecx, %ebx
	movl	%eax, %ecx
	andl	$7, %ecx
	sall	%cl, %edx
	orb	%dl, (%ebx)
	incl	112(%esp)
	jmp	.L437
.L449:
	cmpl	%edi, %edx
	jbe	.L381
	jmp	.L380
	.p2align 4,,10
	.p2align 3
.L463:
	movl	116(%esp), %ecx
	movl	%ecx, (%esp)
	call	ferror
	testl	%eax, %eax
	jne	.L465
	movl	116(%esp), %edx
	movl	%edx, (%esp)
	call	fclose
	movl	132(%esp), %ecx
	movl	112(%esp), %eax
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC26, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	jmp	.L402
.L460:
	movl	$.LC27, factors_filename
	jmp	.L422
.L464:
	movl	132(%esp), %ecx
	movl	stderr, %eax
	movl	%ecx, 16(%esp)
	movl	%ebp, 12(%esp)
	movl	$.LC25, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$1, (%esp)
	call	exit
.L441:
	movl	92(%esp), %ecx
	movl	%ecx, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L452:
	movl	stderr, %eax
	movl	$32, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC20, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
.L451:
	movl	stderr, %eax
	movl	$31, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC19, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
.L447:
	movl	92(%esp), %eax
	movl	$.LC16, 8(%esp)
	movl	%eax, 12(%esp)
	jmp	.L438
.L456:
	movl	132(%esp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L461:
	movl	factors_filename, %eax
	movl	$.LC29, 8(%esp)
	movl	%eax, 12(%esp)
	jmp	.L438
.L446:
	movl	92(%esp), %edx
	movl	$.LC12, 8(%esp)
	movl	%edx, 12(%esp)
	jmp	.L438
.L462:
	movl	128(%esp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L465:
	movl	132(%esp), %eax
	movl	$.LC16, 8(%esp)
	movl	%eax, 12(%esp)
	jmp	.L438
.L459:
	movl	128(%esp), %edx
	movl	$.LC16, 8(%esp)
	movl	%edx, 12(%esp)
	jmp	.L438
	.size	app_init, .-app_init
	.section	.rodata.str1.1
.LC31:
	.string	"-k --kmin=K0"
	.section	.rodata.str1.4
	.align 4
.LC32:
	.string	"-K --kmax=K1       Sieve for primes k*2^n+/-1 with K0 <= k <= K1"
	.section	.rodata.str1.1
.LC33:
	.string	"-n --nmin=N0"
	.section	.rodata.str1.4
	.align 4
.LC34:
	.string	"-N --nmax=N1       Sieve for primes k*2^n+/-1 with N0 <= n <= N1"
	.align 4
.LC35:
	.string	"-i --input=FILE    Read initial sieve from FILE"
	.align 4
.LC36:
	.string	"-f --factors=FILE  Write factors to FILE (default `%s')\n"
	.text
	.p2align 4,,15
.globl app_help
	.type	app_help, @function
app_help:
	subl	$12, %esp
	movl	$.LC31, (%esp)
	call	puts
	movl	$.LC32, (%esp)
	call	puts
	movl	$.LC33, (%esp)
	call	puts
	movl	$.LC34, (%esp)
	call	puts
	movl	$.LC35, (%esp)
	call	puts
	movl	$.LC27, 8(%esp)
	movl	$.LC36, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	addl	$12, %esp
	ret
	.size	app_help, .-app_help
	.section	.rodata.str1.4
	.align 4
.LC37:
	.string	"tpsieve version 0.3.2 (testing)"
	.align 4
.LC38:
	.string	"Compiled Sep  1 2009 with GCC 4.3.3"
	.text
	.p2align 4,,15
.globl app_banner
	.type	app_banner, @function
app_banner:
	subl	$12, %esp
	movl	$.LC37, (%esp)
	call	puts
	movl	$.LC38, (%esp)
	call	puts
	addl	$12, %esp
	ret
	.size	app_banner, .-app_banner
	.p2align 4,,15
.globl app_parse_option
	.type	app_parse_option, @function
app_parse_option:
	subl	$28, %esp
	movl	32(%esp), %edx
	movl	36(%esp), %eax
	subl	$75, %edx
	cmpl	$38, %edx
	jbe	.L486
.L485:
	xorl	%eax, %eax
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L486:
	jmp	*.L480(,%edx,4)
	.section	.rodata
	.align 4
	.align 4
.L480:
	.long	.L473
	.long	.L485
	.long	.L485
	.long	.L474
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L485
	.long	.L475
	.long	.L485
	.long	.L485
	.long	.L476
	.long	.L485
	.long	.L477
	.long	.L485
	.long	.L485
	.long	.L478
	.long	.L485
	.long	.L485
	.long	.L479
	.text
	.p2align 4,,10
	.p2align 3
.L479:
	movl	$0, print_factors
	.p2align 4,,3
	.p2align 3
	jmp	.L485
	.p2align 4,,10
	.p2align 3
.L473:
	movl	$-1, 16(%esp)
	movl	$1073741823, 20(%esp)
	movl	$1, 8(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 4(%esp)
	movl	$kmax, (%esp)
	call	parse_uint64
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L474:
	movl	$2147483647, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$nmax, (%esp)
	call	parse_uint
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L475:
	movl	40(%esp), %edx
	testl	%edx, %edx
	je	.L483
	movl	%eax, (%esp)
	call	xstrdup
.L483:
	movl	%eax, factors_filename
	xorl	%eax, %eax
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L476:
	movl	40(%esp), %ecx
	testl	%ecx, %ecx
	je	.L482
	movl	%eax, (%esp)
	call	xstrdup
.L482:
	movl	%eax, input_filename
	xorl	%eax, %eax
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L477:
	movl	$-1, 16(%esp)
	movl	$1073741823, 20(%esp)
	movl	$1, 8(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 4(%esp)
	movl	$kmin, (%esp)
	call	parse_uint64
	addl	$28, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L478:
	movl	$2147483647, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$nmin, (%esp)
	call	parse_uint
	addl	$28, %esp
	ret
	.size	app_parse_option, .-app_parse_option
	.local	factors_file
	.comm	factors_file,4,4
	.local	factor_count
	.comm	factor_count,4,4
	.local	bitmap
	.comm	bitmap,4,4
	.local	nmin
	.comm	nmin,4,4
	.local	nmax
	.comm	nmax,4,4
	.local	nstart
	.comm	nstart,4,4
	.local	nstep
	.comm	nstep,4,4
	.local	kmax
	.comm	kmax,8,8
	.local	kmin
	.comm	kmin,8,8
	.section	.rodata
	.align 16
	.type	xones.7356, @object
	.size	xones.7356, 16
xones.7356:
	.long	1
	.long	0
	.long	1
	.long	0
	.local	b0
	.comm	b0,8,8
	.data
	.align 4
	.type	print_factors, @object
	.size	print_factors, 4
print_factors:
	.long	1
	.local	input_filename
	.comm	input_filename,4,4
	.local	b1
	.comm	b1,8,8
	.local	file_format
	.comm	file_format,4,4
	.local	factors_filename
	.comm	factors_filename,4,4
	.local	xkmax
	.comm	xkmax,16,16
	.local	factors_mutex
	.comm	factors_mutex,24,4
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
