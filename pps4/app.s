	.file	"app.c"
	.text
	.p2align 4,,15
.globl lg2
	.type	lg2, @function
lg2:
.LFB582:
	xorl	%eax, %eax
	movq	%rdi, %rdx
	shrq	%rdx
	je	.L3
	.p2align 4,,10
	.p2align 3
.L6:
	incl	%eax
	shrq	%rdx
	jne	.L6
.L3:
	rep
	ret
.LFE582:
	.size	lg2, .-lg2
	.p2align 4,,15
.globl app_thread_init
	.type	app_thread_init, @function
app_thread_init:
.LFB584:
#APP
# 679 "app.c" 1
	fnstcw -2(%rsp)
# 0 "" 2
#NO_APP
	orw	$3840, -2(%rsp)
#APP
# 681 "app.c" 1
	fldcw -2(%rsp)
# 0 "" 2
#NO_APP
	ret
.LFE584:
	.size	app_thread_init, .-app_thread_init
	.p2align 4,,15
.globl fillbitskip
	.type	fillbitskip, @function
fillbitskip:
.LFB587:
	pushq	%r13
.LCFI0:
	movl	bitsatatime(%rip), %ecx
	movq	%rdi, %r13
	pushq	%r12
.LCFI1:
	movl	$1, %eax
	pushq	%rbp
.LCFI2:
	sall	%cl, %eax
	pushq	%rbx
.LCFI3:
	movl	%eax, %edx
	movq	%rsi, %rbx
	shrl	$31, %edx
	leal	(%rdx,%rax), %edi
	leaq	1(%rsi), %rax
	sarl	%edi
	shrq	%rax
	movslq	%edi,%rdx
	cmpl	$1, %edi
	movq	%rax, (%r13,%rdx,8)
	movq	$0, (%r13)
	jle	.L18
	movl	%edi, %r10d
	.p2align 4,,10
	.p2align 3
.L16:
	movl	%r10d, %r12d
	sarl	%r12d
	cmpl	%r12d, %edi
	jle	.L13
	leal	(%r10,%r10), %eax
	leal	(%r12,%r10), %r11d
	cltq
	leaq	0(,%rax,8), %rbp
	leal	(%r12,%r12), %eax
	cltq
	leaq	(%r13,%rax,8), %r9
	movslq	%r10d,%rax
	leaq	0(,%rax,8), %rsi
	leal	(%r12,%rdi), %eax
	cltq
	leaq	(%r13,%rax,8), %r8
	movslq	%r12d,%rax
	leaq	(%r13,%rax,8), %rcx
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L21:
	movq	%rdx, %rax
	shrq	%rax
	movq	%rax, (%rcx)
	movq	%rbx, %rax
.L17:
	addl	%r10d, %r11d
	leaq	1(%rax,%rdx), %rax
	addq	%rbp, %r9
	shrq	%rax
	addq	%rsi, %rcx
	movq	%rax, (%r8)
	addq	%rsi, %r8
	movl	%r11d, %eax
	subl	%r10d, %eax
	cmpl	%eax, %edi
	jle	.L13
.L15:
	movq	(%r9), %rdx
	testb	$1, %dl
	je	.L21
	leaq	(%rbx,%rdx), %rax
	shrq	%rax
	movq	%rax, (%rcx)
	xorl	%eax, %eax
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L13:
	movl	%r12d, %r10d
	cmpl	$1, %r12d
	jg	.L16
.L18:
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
.LFE587:
	.size	fillbitskip, .-fillbitskip
	.p2align 4,,15
.globl app_thread_fini
	.type	app_thread_fini, @function
app_thread_fini:
.LFB591:
	rep
	ret
.LFE591:
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
.LFB594:
	pushq	%rbx
.LCFI4:
	movq	factors_file(%rip), %rdi
	call	fclose
	movl	factor_count(%rip), %edx
	movl	$.LC1, %eax
	cmpl	$1, %edx
	movl	$.LC2, %esi
	movl	$1, %edi
	movl	$.LC0, %ecx
	cmove	%rax, %rcx
	xorl	%eax, %eax
	call	__printf_chk
	movl	$factors_mutex, %edi
	call	pthread_mutex_destroy
	cmpq	$0, bitmap(%rip)
	je	.L30
	movl	nmin(%rip), %ebx
	cmpl	nmax(%rip), %ebx
	ja	.L28
	.p2align 4,,10
	.p2align 3
.L31:
	movl	%ebx, %eax
	movq	bitmap(%rip), %rdx
	subl	nmin(%rip), %eax
	incl	%ebx
	movq	(%rdx,%rax,8), %rdi
	call	free
	cmpl	%ebx, nmax(%rip)
	jae	.L31
.L28:
	movq	bitmap(%rip), %rdi
	call	free
	movq	$0, bitmap(%rip)
.L30:
	popq	%rbx
	ret
.LFE594:
	.size	app_fini, .-app_fini
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"nmin=%u,nmax=%u,factor_count=%u\n"
	.text
	.p2align 4,,15
.globl app_write_checkpoint
	.type	app_write_checkpoint, @function
app_write_checkpoint:
.LFB593:
	pushq	%rbx
.LCFI5:
	movq	%rdi, %rbx
	movq	factors_file(%rip), %rdi
	call	fflush
	movq	%rbx, %rdi
	movl	factor_count(%rip), %r9d
	movl	nmax(%rip), %r8d
	movl	nmin(%rip), %ecx
	movl	$.LC3, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	popq	%rbx
	jmp	__fprintf_chk
.LFE593:
	.size	app_write_checkpoint, .-app_write_checkpoint
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"nmin=%u,nmax=%u,factor_count=%u"
	.text
	.p2align 4,,15
.globl app_read_checkpoint
	.type	app_read_checkpoint, @function
app_read_checkpoint:
.LFB592:
	subq	$24, %rsp
.LCFI6:
	xorl	%eax, %eax
	leaq	16(%rsp), %rcx
	leaq	20(%rsp), %rdx
	movl	$factor_count, %r8d
	movl	$.LC4, %esi
	call	fscanf
	cmpl	$3, %eax
	je	.L39
.L36:
	xorl	%eax, %eax
	addq	$24, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L39:
	movl	20(%rsp), %eax
	cmpl	nmin(%rip), %eax
	jne	.L36
	movl	16(%rsp), %eax
	cmpl	nmax(%rip), %eax
	sete	%al
	addq	$24, %rsp
	movzbl	%al, %eax
	ret
.LFE592:
	.size	app_read_checkpoint, .-app_read_checkpoint
	.section	.rodata.str1.1
.LC5:
	.string	"%lu | %lu*2^%u%+d\n"
.LC6:
	.string	"UNSAVED: %lu | %lu*2^%u%+d\n"
	.text
	.p2align 4,,15
	.type	test_factor, @function
test_factor:
.LFB575:
	movq	%rbx, -32(%rsp)
.LCFI7:
	movq	%rbp, -24(%rsp)
.LCFI8:
	movq	%r12, -16(%rsp)
.LCFI9:
	movq	%r13, -8(%rsp)
.LCFI10:
	movq	%rsi, %rbx
	subq	$40, %rsp
.LCFI11:
	movq	%rdi, %r13
	movl	%edx, %ebp
	movl	%ecx, %r12d
	testb	$1, %sil
	je	.L45
	movq	bitmap(%rip), %rdi
	testq	%rdi, %rdi
	je	.L42
	movl	nmin(%rip), %eax
	cmpl	%edx, %eax
	ja	.L45
	subl	%eax, %edx
	movq	%rsi, %rcx
	movq	(%rdi,%rdx,8), %rdx
	shrq	%rcx
	movq	b0(%rip), %rsi
	movq	%rcx, %rax
	subl	%esi, %ecx
	subq	%rsi, %rax
	andl	$7, %ecx
	shrq	$3, %rax
	mov	%eax, %eax
	movzbl	(%rdx,%rax), %eax
	sarl	%cl, %eax
	testb	$1, %al
	je	.L45
.L42:
	movl	$factors_mutex, %edi
	call	pthread_mutex_lock
	movq	factors_file(%rip), %rdi
	testq	%rdi, %rdi
	je	.L43
	xorl	%eax, %eax
	movl	%r12d, (%rsp)
	movl	%ebp, %r9d
	movq	%rbx, %r8
	movq	%r13, %rcx
	movl	$.LC5, %edx
	movl	$1, %esi
	call	__fprintf_chk
	movl	print_factors(%rip), %eax
	testl	%eax, %eax
	jne	.L46
.L44:
	incl	factor_count(%rip)
	movq	8(%rsp), %rbx
	movq	16(%rsp), %rbp
	movq	24(%rsp), %r12
	movq	32(%rsp), %r13
	movl	$factors_mutex, %edi
	addq	$40, %rsp
	jmp	pthread_mutex_unlock
	.p2align 4,,10
	.p2align 3
.L45:
	movq	8(%rsp), %rbx
	movq	16(%rsp), %rbp
	movq	24(%rsp), %r12
	movq	32(%rsp), %r13
	addq	$40, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L46:
	movl	%r12d, %r9d
	movl	%ebp, %r8d
	movq	%rbx, %rcx
	movq	%r13, %rdx
	movl	$.LC5, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L44
	.p2align 4,,10
	.p2align 3
.L43:
	movl	%r12d, %r9d
	movl	%ebp, %r8d
	movq	%rbx, %rcx
	movq	%r13, %rdx
	movl	$.LC6, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L44
.LFE575:
	.size	test_factor, .-test_factor
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"-a --alt=yes|no    Force setting of alt. algorithm (64-bit/SSE2)"
	.align 8
.LC8:
	.string	"-b --bitsatatime=b Bits to use at a time: fiddle with this, 5-9."
	.section	.rodata.str1.1
.LC9:
	.string	"ppfactors.txt"
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"-f --factors=FILE  Write factors to FILE (default `%s')\n"
	.align 8
.LC11:
	.string	"-i --input=FILE    Read initial sieve from FILE"
	.section	.rodata.str1.1
.LC12:
	.string	"-k --kmin=K0"
	.section	.rodata.str1.8
	.align 8
.LC13:
	.string	"-K --kmax=K1       Sieve for primes k*2^n+/-1 with K0 <= k <= K1"
	.section	.rodata.str1.1
.LC14:
	.string	"-n --nmin=N0"
	.section	.rodata.str1.8
	.align 8
.LC15:
	.string	"-N --nmax=N1       Sieve for primes k*2^n+/-1 with N0 <= n <= N1"
	.align 8
.LC16:
	.string	"-R --riesel        Sieve for primes k*2^n-1 instead of +1."
	.text
	.p2align 4,,15
.globl app_help
	.type	app_help, @function
app_help:
.LFB581:
	subq	$8, %rsp
.LCFI12:
	movl	$.LC7, %edi
	call	puts
	movl	$.LC8, %edi
	call	puts
	movl	$.LC9, %edx
	movl	$.LC10, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$.LC11, %edi
	call	puts
	movl	$.LC12, %edi
	call	puts
	movl	$.LC13, %edi
	call	puts
	movl	$.LC14, %edi
	call	puts
	movl	$.LC15, %edi
	call	puts
	movl	$.LC16, %edi
	addq	$8, %rsp
	jmp	puts
.LFE581:
	.size	app_help, .-app_help
	.section	.rodata.str1.8
	.align 8
.LC17:
	.string	"ppsieve version 0.4.0 (testing)"
	.align 8
.LC18:
	.string	"Compiled Dec 12 2009 with GCC 4.3.3"
	.text
	.p2align 4,,15
.globl app_banner
	.type	app_banner, @function
app_banner:
.LFB579:
	subq	$8, %rsp
.LCFI13:
	movl	$.LC17, %edi
	call	puts
	movl	$.LC18, %edi
	addq	$8, %rsp
	jmp	puts
.LFE579:
	.size	app_banner, .-app_banner
	.section	.rodata.str1.8
	.align 8
.LC19:
	.string	"Please specify an input file or both of kmin,kmax\n"
	.section	.rodata.str1.1
.LC20:
	.string	"r"
.LC21:
	.string	"ABCD %lu*2^$a+1 [%u]"
.LC22:
	.string	"%lu:P:%*c:2:%c"
.LC23:
	.string	" %lu %u"
	.section	.rodata.str1.8
	.align 8
.LC24:
	.string	"Invalid line 2 in input file `%s'\n"
	.align 8
.LC25:
	.string	"Invalid header in input file `%s'\n"
	.section	.rodata.str1.1
.LC26:
	.string	"Scanning ABCD file..."
.LC27:
	.string	" ABCD %lu*2^$a+1 [%u]"
.LC28:
	.string	"\rFound K=%lu\r"
	.section	.rodata.str1.8
	.align 8
.LC29:
	.string	"Error reading input file `%s'\n"
	.section	.rodata.str1.1
.LC30:
	.string	"Found K's from %lu to %lu.\n"
.LC31:
	.string	"Found N's from %u to %u.\n"
.LC32:
	.string	"kmin <= kmax is required\n"
.LC33:
	.string	"kmax < pmin is required\n"
	.section	.rodata.str1.8
	.align 8
.LC34:
	.string	"kmax-kmin < 3*2^36 is required\n"
	.section	.rodata.str1.1
.LC35:
	.string	"nmin <= nmax is required\n"
	.section	.rodata.str1.8
	.align 8
.LC36:
	.string	"Algorithm not specified, starting benchmark..."
	.align 8
.LC37:
	.string	"bsf takes %lu; mul takes %lu; "
	.section	.rodata.str1.1
.LC38:
	.string	"using alternate algorithm."
.LC39:
	.string	"using standard algorithm."
.LC40:
	.string	"nstart=%u, nstep=%u\n"
.LC41:
	.string	"Opening file %s\n"
.LC42:
	.string	"Reading ABCD file."
.LC43:
	.string	"\rRead K=%lu\r"
	.section	.rodata.str1.8
	.align 8
.LC44:
	.string	"\nError reading input file `%s'\n"
	.align 8
.LC45:
	.string	"Read %u terms from ABCD format input file `%s'\n"
	.section	.rodata.str1.1
.LC46:
	.string	" %lu:P:%*c:2:%c"
	.section	.rodata.str1.8
	.align 8
.LC47:
	.string	"Invalid line %u in input file `%s'\n"
	.align 8
.LC48:
	.string	"Read %u terms from NewPGen format input file `%s'\n"
	.section	.rodata.str1.1
.LC49:
	.string	"a"
	.section	.rodata.str1.8
	.align 8
.LC50:
	.string	"Cannot open factors file `%s'\n"
	.align 8
.LC51:
	.string	"ppsieve initialized: %lu <= k <= %lu, %u <= n <= %u\n"
	.text
	.p2align 4,,15
.globl app_init
	.type	app_init, @function
app_init:
.LFB583:
	pushq	%r15
.LCFI14:
	xorl	%eax, %eax
	pushq	%r14
.LCFI15:
	pushq	%r13
.LCFI16:
	pushq	%r12
.LCFI17:
	pushq	%rbp
.LCFI18:
	pushq	%rbx
.LCFI19:
	subq	$88, %rsp
.LCFI20:
	cmpl	$0, quiet_opt(%rip)
	sete	%al
	movl	%eax, print_factors(%rip)
	movq	input_filename(%rip), %rax
	movq	%rax, 16(%rsp)
	testq	%rax, %rax
	je	.L166
	cmpq	$0, kmin(%rip)
	je	.L55
	cmpq	$0, kmax(%rip)
	jne	.L167
.L55:
	movl	$.LC20, %esi
	movq	16(%rsp), %rdi
	call	fopen
	movq	%rax, %r12
	testq	%rax, %rax
	je	.L168
	leaq	80(%rsp), %rdx
	movq	%rax, %rdi
	movq	%rdx, (%rsp)
	movq	%rdx, %rcx
	xorl	%eax, %eax
	leaq	64(%rsp), %rdx
	movl	$.LC21, %esi
	call	fscanf
	cmpl	$2, %eax
	je	.L169
	xorl	%eax, %eax
	leaq	87(%rsp), %rcx
	leaq	72(%rsp), %rbx
	movl	$.LC22, %esi
	movq	%rbx, %rdx
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L59
	cmpb	$49, 87(%rsp)
	je	.L170
.L59:
	movq	16(%rsp), %rcx
	movl	$.LC25, %edx
.L165:
	movq	stderr(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movl	$1, %edi
	call	exit
.L169:
	movl	$2, file_format(%rip)
	movq	64(%rsp), %r15
	movl	80(%rsp), %r14d
.L58:
	movl	$.LC26, %edi
	call	puts
	call	__ctype_b_loc
	movl	%r14d, 52(%rsp)
	movq	%rax, %r13
	movq	%r15, 40(%rsp)
	.p2align 4,,10
	.p2align 3
.L161:
	movq	%r12, %rdi
	call	_IO_getc
	cmpl	$10, %eax
	jne	.L161
	.p2align 4,,10
	.p2align 3
.L162:
	movq	%r12, %rdi
	call	_IO_getc
	movq	(%r13), %rbp
	movl	%eax, %edx
	movsbq	%al,%rax
	testb	$8, 1(%rbp,%rax,2)
	je	.L171
	movsbl	%dl,%eax
	leal	-48(%rax), %ebx
	jmp	.L66
	.p2align 4,,10
	.p2align 3
.L67:
	leal	(%rbx,%rbx,4), %edx
	movsbl	%cl,%eax
	movq	(%r13), %rbp
	leal	-48(%rax,%rdx,2), %ebx
.L66:
	movq	%r12, %rdi
	call	_IO_getc
	movl	%eax, %ecx
	movsbq	%al,%rax
	testb	$8, 1(%rbp,%rax,2)
	jne	.L67
	addl	%ebx, 80(%rsp)
	cmpb	$10, %cl
	je	.L162
.L145:
	movq	%r12, %rdi
	call	_IO_getc
	cmpb	$10, %al
	je	.L162
	.p2align 4,,4
	.p2align 3
	jmp	.L145
.L167:
	movl	nmin(%rip), %r11d
	testl	%r11d, %r11d
	.p2align 4,,2
	.p2align 3
	je	.L55
	movl	nmax(%rip), %r10d
	testl	%r10d, %r10d
	je	.L55
.L54:
	xorl	%r12d, %r12d
	movq	kmax(%rip), %rsi
	jmp	.L78
.L171:
	movsbl	%dl,%edi
	movq	%r12, %rsi
	call	ungetc
	movl	80(%rsp), %eax
	movq	(%rsp), %rcx
	cmpl	%eax, %r14d
	movl	%eax, %ebp
	leaq	64(%rsp), %rdx
	cmovae	%r14d, %ebp
	movl	$.LC27, %esi
	xorl	%eax, %eax
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L65
	movq	64(%rsp), %rdx
	movl	%edx, %eax
	andl	$15, %eax
	decl	%eax
	je	.L172
.L70:
	movq	stdout(%rip), %rdi
	call	fflush
	movq	64(%rsp), %rax
	movq	40(%rsp), %rdx
	cmpq	%rax, 40(%rsp)
	movl	52(%rsp), %ebx
	cmova	%rax, %rdx
	movq	%r12, %rdi
	cmpq	%rax, %r15
	movq	%rdx, 40(%rsp)
	cmovb	%rax, %r15
	movl	80(%rsp), %eax
	cmpl	%eax, 52(%rsp)
	movl	%eax, %r14d
	cmova	%eax, %ebx
	cmpl	%eax, %ebp
	movl	%ebx, 52(%rsp)
	cmovae	%ebp, %r14d
	call	_IO_getc
	cmpl	$10, %eax
	jne	.L161
	jmp	.L162
.L170:
	xorl	%eax, %eax
	movl	$1, file_format(%rip)
	movq	(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$.LC23, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L173
	movq	64(%rsp), %r15
	movl	80(%rsp), %r14d
	movq	%r15, %rbx
	movl	%r14d, %ebp
	cmpl	$2, file_format(%rip)
	jne	.L61
	jmp	.L58
	.p2align 4,,10
	.p2align 3
.L71:
	movq	64(%rsp), %rax
	cmpq	%rax, %r15
	cmova	%rax, %r15
	cmpq	%rax, %rbx
	cmovb	%rax, %rbx
	movl	80(%rsp), %eax
	cmpl	%eax, %r14d
	cmova	%eax, %r14d
	cmpl	%eax, %ebp
	cmovb	%eax, %ebp
.L61:
	xorl	%eax, %eax
	movq	(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$.LC23, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	je	.L71
	movq	%r15, 40(%rsp)
	movl	%r14d, 52(%rsp)
	movq	%rbx, %r15
.L65:
	movq	%r12, %rdi
	call	ferror
	testl	%eax, %eax
	jne	.L174
	movq	%r12, %rdi
	call	rewind
	movq	%r15, %rcx
	movq	40(%rsp), %rdx
	movl	$.LC30, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	xorl	%eax, %eax
	movl	%ebp, %ecx
	movl	52(%rsp), %edx
	movl	$.LC31, %esi
	movl	$1, %edi
	call	__printf_chk
	movq	40(%rsp), %rax
	cmpq	kmin(%rip), %rax
	jbe	.L73
	movq	%rax, kmin(%rip)
.L73:
	movq	kmax(%rip), %rsi
	testq	%rsi, %rsi
	je	.L74
	cmpq	%rsi, %r15
	jb	.L74
.L75:
	movl	52(%rsp), %edx
	cmpl	nmin(%rip), %edx
	jbe	.L76
	movl	%edx, nmin(%rip)
.L76:
	movl	nmax(%rip), %eax
	testl	%eax, %eax
	je	.L77
	cmpl	%eax, %ebp
	jae	.L78
.L77:
	movl	%ebp, nmax(%rip)
.L78:
	movq	kmin(%rip), %r8
	cmpq	%rsi, %r8
	ja	.L175
	movq	pmin(%rip), %rdi
	cmpq	%rdi, %rsi
	jae	.L176
	movq	%rsi, %rdx
	movabsq	$206158430207, %rax
	subq	%r8, %rdx
	cmpq	%rax, %rdx
	ja	.L177
	movl	nmin(%rip), %r9d
	testl	%r9d, %r9d
	jne	.L82
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	movq	%rdi, %rdx
	shrq	%rdx
	je	.L84
	.p2align 4,,10
	.p2align 3
.L144:
	incl	%ecx
	shrq	%rdx
	jne	.L144
	leal	(%rcx,%rcx), %eax
.L84:
	xorl	%ecx, %ecx
	movq	%rsi, %rdx
	shrq	%rdx
	je	.L87
	.p2align 4,,10
	.p2align 3
.L143:
	incl	%ecx
	shrq	%rdx
	jne	.L143
.L87:
	decl	%eax
	subl	%ecx, %eax
	movl	%eax, nmin(%rip)
.L82:
	movl	nmax(%rip), %ecx
	testl	%ecx, %ecx
	je	.L164
	movl	nmin(%rip), %eax
.L89:
	cmpl	nmax(%rip), %eax
	ja	.L178
	movq	%r8, %rax
	movq	%rsi, %rdx
	shrq	%rax
	shrq	%rdx
	movq	%rax, b0(%rip)
	movq	%rdx, b1(%rip)
	leaq	1(%rax,%rax), %rax
	addq	%rdx, %rdx
	movq	%rax, kmin(%rip)
	leaq	1(%rdx), %rax
	addq	$2, %rdx
	movq	%rax, kmax(%rip)
	movq	%rdx, xkmax(%rip)
	movq	%rdx, %rax
	salq	$32, %rax
	cmpq	%rax, pmax(%rip)
	jb	.L91
	.p2align 4,,10
	.p2align 3
.L142:
	addq	%rdx, %rdx
	movq	%rdx, %rax
	movq	%rdx, xkmax(%rip)
	salq	$32, %rax
	cmpq	pmax(%rip), %rax
	jbe	.L142
.L91:
	movq	%rdx, xkmax+8(%rip)
	movl	$4294967295, %eax
	movq	xkmax(%rip), %rdx
	cmpq	%rax, %rdx
	ja	.L93
	salq	$32, %rdx
	cmpq	pmax(%rip), %rdx
	jbe	.L93
	movl	use_sse2(%rip), %eax
	testl	%eax, %eax
	je	.L93
	decl	%eax
	jle	.L98
	movl	$.LC36, %edi
	call	puts
	call	clock
	movl	$7, %edx
	movq	%rax, %rbp
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L96:
	leaq	0(,%rdx,8), %rbx
	incl	%eax
	subq	%rdx, %rbx
	cmpl	$500000000, %eax
	movq	%rbx, %rdx
	jne	.L96
	call	clock
	movq	%rax, %r14
	call	clock
	subq	%rbp, %r14
	movq	%rax, %r15
	xorl	%ebp, %ebp
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L97:
	bsfq	%rdx, %rax
	incq	%rdx
	addl	%eax, %ebp
	cmpq	$500000000, %rdx
	jne	.L97
	call	clock
	movq	%r14, %rcx
	movq	%rax, %r13
	movl	$.LC37, %esi
	subq	%r15, %r13
	xorl	%eax, %eax
	movq	%r13, %rdx
	movl	$1, %edi
	call	__printf_chk
	cmpl	%ebx, %ebp
	je	.L98
	cmpq	%r14, %r13
	jge	.L98
	movl	$0, sse2_in_range(%rip)
	.p2align 4,,2
	.p2align 3
	jmp	.L99
	.p2align 4,,10
	.p2align 3
.L93:
	movl	sse2_in_range(%rip), %edx
	testl	%edx, %edx
	jne	.L95
.L99:
	movl	$.LC39, %edi
	call	puts
.L100:
	movq	kmax(%rip), %rsi
	movl	$1, nstep(%rip)
	leaq	(%rsi,%rsi), %rax
	movl	$1, %ecx
	cmpq	%rax, pmin(%rip)
	jbe	.L102
	.p2align 4,,10
	.p2align 3
.L141:
	incl	%ecx
	movq	%rsi, %rax
	movl	%ecx, nstep(%rip)
	salq	%cl, %rax
	cmpq	pmin(%rip), %rax
	jb	.L141
.L102:
	movl	bitsatatime(%rip), %esi
	cmpl	%ecx, %esi
	jae	.L104
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%esi
	movl	%eax, %ecx
	movl	%eax, bpernstep(%rip)
	imull	%esi, %ecx
	movl	%ecx, nstep(%rip)
.L104:
	movl	nmax(%rip), %eax
	incl	%eax
	subl	nmin(%rip), %eax
	cmpl	nstep(%rip), %eax
	jae	.L105
	movl	%eax, nstep(%rip)
.L105:
	movl	nmin(%rip), %edx
	xorl	%eax, %eax
	movl	%edx, nstart(%rip)
	movl	nstep(%rip), %ecx
	movl	$.LC40, %esi
	movl	$1, %edi
	call	__printf_chk
	cmpq	$0, input_filename(%rip)
	je	.L106
	movl	nmax(%rip), %edi
	incl	%edi
	subl	nmin(%rip), %edi
	salq	$3, %rdi
	call	xmalloc
	movl	nmin(%rip), %ebp
	movq	%rax, bitmap(%rip)
	cmpl	nmax(%rip), %ebp
	ja	.L107
	.p2align 4,,10
	.p2align 3
.L140:
	movl	%ebp, %ebx
	movq	b1(%rip), %rdi
	subl	nmin(%rip), %ebx
	addq	$8, %rdi
	salq	$3, %rbx
	subq	b0(%rip), %rdi
	addq	bitmap(%rip), %rbx
	shrq	$3, %rdi
	mov	%edi, %edi
	call	xmalloc
	movq	b1(%rip), %rdx
	movq	%rax, (%rbx)
	addq	$8, %rdx
	movl	%ebp, %ecx
	subq	b0(%rip), %rdx
	subl	nmin(%rip), %ecx
	shrq	$3, %rdx
	movq	bitmap(%rip), %rax
	xorl	%esi, %esi
	mov	%edx, %edx
	movq	(%rax,%rcx,8), %rdi
	incl	%ebp
	call	memset
	cmpl	%ebp, nmax(%rip)
	jae	.L140
.L107:
	cmpl	$2, file_format(%rip)
	je	.L179
	movq	input_filename(%rip), %rbp
	testq	%r12, %r12
	je	.L180
.L124:
	xorl	%eax, %eax
	leaq	87(%rsp), %rcx
	leaq	64(%rsp), %rdx
	movl	$.LC46, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L125
	cmpb	$49, 87(%rsp)
	je	.L181
.L125:
	movq	%rbp, %rcx
	movl	$.LC25, %edx
	jmp	.L165
.L74:
	movq	%r15, kmax(%rip)
	movq	%r15, %rsi
	jmp	.L75
.L188:
	movsbl	%dl,%edi
	movq	%r12, %rsi
	call	ungetc
	movq	72(%rsp), %rdx
	movl	%edx, %eax
	andl	$15, %eax
	decl	%eax
	je	.L182
.L115:
	movq	stdout(%rip), %rdi
	call	fflush
	xorl	%eax, %eax
	movq	(%rsp), %rcx
	movq	8(%rsp), %rdx
	movl	$.LC21, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	je	.L122
	movq	%r12, %rdi
	call	ferror
	testl	%eax, %eax
	.p2align 4,,2
	.p2align 3
	jne	.L183
	movq	%r12, %rdi
	call	fclose
	movq	32(%rsp), %rcx
	movl	%r14d, %edx
	movl	$.LC45, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
.L106:
	cmpq	$0, factors_filename(%rip)
	je	.L184
.L130:
	movl	$.LC49, %esi
	movq	factors_filename(%rip), %rdi
	call	fopen
	movq	%rax, factors_file(%rip)
	testq	%rax, %rax
	je	.L185
	movl	bitsatatime(%rip), %ecx
	movl	$1, %edi
	sall	%cl, %edi
	movl	%edi, bitsmask(%rip)
	mov	%edi, %edi
	salq	$3, %rdi
	call	xmalloc
	mov	bitsmask(%rip), %edi
	movq	%rax, bitsskip(%rip)
	salq	$3, %rdi
	call	xmalloc
	mov	bitsmask(%rip), %edi
	movq	%rax, bitsskip+8(%rip)
	salq	$3, %rdi
	call	xmalloc
	mov	bitsmask(%rip), %edi
	movq	%rax, bitsskip+16(%rip)
	salq	$3, %rdi
	call	xmalloc
	mov	bitsmask(%rip), %edi
	movq	%rax, bitsskip+24(%rip)
	salq	$3, %rdi
	call	xmalloc
	mov	bitsmask(%rip), %edi
	movq	%rax, bitsskip+32(%rip)
	salq	$3, %rdi
	call	xmalloc
	xorl	%esi, %esi
	movl	$factors_mutex, %edi
	movq	%rax, bitsskip+40(%rip)
	decl	bitsmask(%rip)
	call	pthread_mutex_init
	movl	nmax(%rip), %r9d
	movl	nmin(%rip), %r8d
	movq	kmax(%rip), %rcx
	movq	kmin(%rip), %rdx
	movl	$.LC51, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movq	stdout(%rip), %rdi
	call	fflush
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L164:
	movl	nmin(%rip), %eax
	movl	%eax, nmax(%rip)
	jmp	.L89
.L98:
	movl	$1, sse2_in_range(%rip)
.L95:
	movl	$.LC38, %edi
	call	puts
	jmp	.L100
.L166:
	cmpq	$0, kmin(%rip)
	je	.L53
	cmpq	$0, kmax(%rip)
	jne	.L54
.L53:
	movl	$.LC19, %edi
	movq	stderr(%rip), %rcx
	movl	$50, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
.L179:
	movq	input_filename(%rip), %rdx
	testq	%r12, %r12
	movq	%rdx, 32(%rsp)
	je	.L186
.L110:
	leaq	72(%rsp), %rax
	leaq	80(%rsp), %rbx
	movq	%rax, 8(%rsp)
	movq	%rax, %rdx
	movq	%rbx, (%rsp)
	xorl	%eax, %eax
	movq	%rbx, %rcx
	movl	$.LC21, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L187
.L139:
	movq	%r12, %rdi
	call	_IO_getc
	cmpl	$10, %eax
	.p2align 4,,2
	.p2align 3
	jne	.L139
	movl	$.LC42, %edi
	xorl	%r14d, %r14d
	call	puts
	call	__ctype_b_loc
	movq	%rax, %r13
.L122:
	movq	72(%rsp), %rax
	movl	$1, %edx
	subq	kmin(%rip), %rax
	movq	%rax, %rcx
	movq	%rax, %rbx
	shrq	%rcx
	shrq	$4, %rbx
	andl	$7, %ecx
	movl	nmin(%rip), %eax
	sall	%cl, %edx
	movl	%edx, 28(%rsp)
	movl	80(%rsp), %edx
	cmpl	%eax, %edx
	jb	.L138
	subl	%eax, %edx
	movq	bitmap(%rip), %rcx
	movq	%rdx, %rax
	mov	%ebx, %edx
	addq	(%rcx,%rax,8), %rdx
	movzbl	28(%rsp), %eax
	orb	%al, (%rdx)
	.p2align 4,,10
	.p2align 3
.L138:
	movq	%r12, %rdi
	call	_IO_getc
	cmpl	$10, %eax
	jne	.L138
	incl	%r14d
	mov	%ebx, %r15d
	.p2align 4,,10
	.p2align 3
.L121:
	movq	%r12, %rdi
	call	_IO_getc
	movq	(%r13), %rbp
	movl	%eax, %edx
	movsbq	%al,%rax
	testb	$8, 1(%rbp,%rax,2)
	je	.L188
	movsbl	%dl,%eax
	leal	-48(%rax), %ebx
	jmp	.L116
	.p2align 4,,10
	.p2align 3
.L117:
	leal	(%rbx,%rbx,4), %edx
	movsbl	%cl,%eax
	movq	(%r13), %rbp
	leal	-48(%rax,%rdx,2), %ebx
.L116:
	movq	%r12, %rdi
	call	_IO_getc
	movl	%eax, %ecx
	movsbq	%al,%rax
	testb	$8, 1(%rbp,%rax,2)
	jne	.L117
	movl	%ebx, %eax
	movl	nmin(%rip), %edx
	addl	80(%rsp), %eax
	movl	%eax, 80(%rsp)
	cmpl	%edx, %eax
	jb	.L118
	cmpl	nmax(%rip), %eax
	ja	.L118
	subl	%edx, %eax
	movq	%rax, %rdx
	movq	bitmap(%rip), %rax
	movq	(%rax,%rdx,8), %rbx
	movzbl	28(%rsp), %edx
	leaq	(%r15,%rbx), %rax
	orb	%dl, (%rax)
.L118:
	cmpb	$10, %cl
	jne	.L137
	incl	%r14d
	jmp	.L121
	.p2align 4,,10
	.p2align 3
.L137:
	movq	%r12, %rdi
	call	_IO_getc
	cmpb	$10, %al
	.p2align 4,,2
	.p2align 3
	jne	.L137
	incl	%r14d
	.p2align 4,,2
	.p2align 3
	jmp	.L121
.L182:
	movl	$.LC43, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L115
.L172:
	movl	$.LC28, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L70
.L181:
	leaq	80(%rsp), %rax
	leaq	72(%rsp), %rdx
	xorl	%r13d, %r13d
	xorl	%ebx, %ebx
	movq	%rax, (%rsp)
	movq	%rdx, 8(%rsp)
	movl	$1, %r14d
	.p2align 4,,10
	.p2align 3
.L163:
	xorl	%eax, %eax
	movq	(%rsp), %rcx
	movq	8(%rsp), %rdx
	movl	$.LC23, %esi
	movq	%r12, %rdi
	call	fscanf
	cmpl	$2, %eax
	jne	.L189
	incl	%ebx
	movq	72(%rsp), %rax
	testb	$1, %al
	je	.L190
	cmpq	kmin(%rip), %rax
	jb	.L163
	cmpq	kmax(%rip), %rax
	ja	.L163
	movl	80(%rsp), %edx
	movl	nmin(%rip), %esi
	cmpl	%esi, %edx
	jb	.L163
	cmpl	nmax(%rip), %edx
	ja	.L163
	movq	%rax, %rcx
	subl	%esi, %edx
	shrq	%rcx
	movq	%rdx, %rsi
	subq	b0(%rip), %rcx
	movq	bitmap(%rip), %rdx
	movq	%rcx, %rax
	incl	%r13d
	shrq	$3, %rax
	andl	$7, %ecx
	mov	%eax, %eax
	addq	(%rdx,%rsi,8), %rax
	movl	%r14d, %edx
	sall	%cl, %edx
	orb	%dl, (%rax)
	jmp	.L163
.L189:
	movq	%r12, %rdi
	call	ferror
	movq	%rbp, %rcx
	movl	$.LC29, %edx
	testl	%eax, %eax
	jne	.L165
	movq	%r12, %rdi
	call	fclose
	movq	%rbp, %rcx
	movl	%r13d, %edx
	movl	$.LC48, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L106
.L184:
	movq	$.LC9, factors_filename(%rip)
	jmp	.L130
.L180:
	movl	$.LC20, %esi
	movq	%rbp, %rdi
	call	fopen
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.L124
	movq	%rbp, %rdi
	call	perror
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L190:
	movq	stderr(%rip), %rdi
	movq	%rbp, %r8
	movl	%ebx, %ecx
	movl	$.LC47, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movl	$1, %edi
	call	exit
.L186:
	movl	$.LC41, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$.LC20, %esi
	movq	32(%rsp), %rdi
	call	fopen
	movq	%rax, %r12
	testq	%rax, %rax
	jne	.L110
	movq	32(%rsp), %rdi
	call	perror
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L175:
	movl	$.LC32, %edi
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
.L176:
	movl	$.LC33, %edi
	movq	stderr(%rip), %rcx
	movl	$24, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
.L177:
	movl	$.LC34, %edi
	movq	stderr(%rip), %rcx
	movl	$31, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
.L178:
	movl	$.LC35, %edi
	movq	stderr(%rip), %rcx
	movl	$25, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
.L168:
	movq	16(%rsp), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L173:
	movq	16(%rsp), %rcx
	movl	$.LC24, %edx
	jmp	.L165
.L174:
	movq	16(%rsp), %rcx
	movl	$.LC29, %edx
	jmp	.L165
.L183:
	movl	$1, %edi
	movq	32(%rsp), %rdx
	movl	$.LC44, %esi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$1, %edi
	call	exit
.L187:
	movq	32(%rsp), %rcx
	movl	$.LC25, %edx
	jmp	.L165
.L185:
	movq	stderr(%rip), %rdi
	movq	factors_filename(%rip), %rcx
	movl	$.LC50, %edx
	movl	$1, %esi
	call	__fprintf_chk
	movl	$1, %edi
	call	exit
.LFE583:
	.size	app_init, .-app_init
	.p2align 4,,15
.globl app_parse_option
	.type	app_parse_option, @function
app_parse_option:
.LFB580:
	subq	$8, %rsp
.LCFI21:
	leal	-75(%rdi), %eax
	cmpl	$40, %eax
	ja	.L204
	mov	%eax, %eax
	jmp	*.L202(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L202:
	.quad	.L193
	.quad	.L204
	.quad	.L204
	.quad	.L194
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L195
	.quad	.L196
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L197
	.quad	.L204
	.quad	.L204
	.quad	.L198
	.quad	.L204
	.quad	.L199
	.quad	.L204
	.quad	.L204
	.quad	.L200
	.quad	.L204
	.quad	.L204
	.quad	.L204
	.quad	.L201
	.quad	.L195
	.text
	.p2align 4,,10
	.p2align 3
.L198:
	testq	%rdx, %rdx
	je	.L203
	movq	%rsi, %rdi
	.p2align 4,,5
	.p2align 3
	call	xstrdup
	movq	%rax, %rsi
.L203:
	movq	%rsi, input_filename(%rip)
	.p2align 4,,10
	.p2align 3
.L204:
	xorl	%eax, %eax
	addq	$8, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L201:
	movl	$0, search_proth(%rip)
	xorl	%eax, %eax
	addq	$8, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L193:
	movabsq	$4611686018427387903, %rcx
	movl	$1, %edx
	movl	$kmax, %edi
	addq	$8, %rsp
	jmp	parse_uint64
	.p2align 4,,10
	.p2align 3
.L194:
	movl	$2147483647, %ecx
	movl	$1, %edx
	movl	$nmax, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L195:
	movzbl	(%rsi), %eax
	cmpb	$121, %al
	je	.L210
	cmpb	$89, %al
	je	.L210
	cmpb	$110, %al
	.p2align 4,,3
	.p2align 3
	je	.L211
	cmpb	$78, %al
	.p2align 4,,5
	.p2align 3
	jne	.L204
.L211:
	movl	$0, use_sse2(%rip)
	.p2align 4,,2
	.p2align 3
	jmp	.L204
	.p2align 4,,10
	.p2align 3
.L196:
	movl	$2147483647, %ecx
	movl	$1, %edx
	movl	$bitsatatime, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L197:
	testq	%rdx, %rdx
	je	.L205
	movq	%rsi, %rdi
	call	xstrdup
	movq	%rax, %rsi
.L205:
	movq	%rsi, factors_filename(%rip)
	xorl	%eax, %eax
	addq	$8, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L199:
	movabsq	$4611686018427387903, %rcx
	movl	$1, %edx
	movl	$kmin, %edi
	addq	$8, %rsp
	jmp	parse_uint64
	.p2align 4,,10
	.p2align 3
.L200:
	movl	$2147483647, %ecx
	movl	$1, %edx
	movl	$nmin, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L210:
	movl	$1, use_sse2(%rip)
	jmp	.L204
.LFE580:
	.size	app_parse_option, .-app_parse_option
	.p2align 4,,15
.globl check_ns
	.type	check_ns, @function
check_ns:
.LFB588:
	pushq	%r15
.LCFI22:
	movl	$1, %eax
	pushq	%r14
.LCFI23:
	xorl	%r14d, %r14d
	pushq	%r13
.LCFI24:
	pushq	%r12
.LCFI25:
	pushq	%rbp
.LCFI26:
	pushq	%rbx
.LCFI27:
	subq	$24, %rsp
.LCFI28:
	movq	%rdi, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movl	bitsatatime(%rip), %edi
	movl	%edi, %ecx
	sall	%cl, %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%eax, %edx
	sarl	%edx
	movslq	%edx,%rax
	leaq	0(,%rax,8), %r15
.L218:
	movq	8(%rsp), %rax
	movq	bitsskip(%r14), %r13
	movq	(%rax,%r14), %rbp
	leaq	1(%rbp), %rax
	shrq	%rax
	cmpl	$1, %edx
	movq	%rax, (%r13,%r15)
	movq	$0, (%r13)
	jle	.L213
	movl	%edx, %r9d
	.p2align 4,,10
	.p2align 3
.L217:
	movl	%r9d, %ebx
	sarl	%ebx
	cmpl	%ebx, %edx
	jle	.L214
	leal	(%r9,%r9), %eax
	leal	(%rbx,%r9), %r10d
	cltq
	leaq	0(,%rax,8), %r12
	leal	(%rbx,%rbx), %eax
	cltq
	leaq	(%r13,%rax,8), %r8
	movslq	%r9d,%rax
	leaq	0(,%rax,8), %r11
	leal	(%rbx,%rdx), %eax
	cltq
	leaq	(%r13,%rax,8), %rdi
	movslq	%ebx,%rax
	leaq	(%r13,%rax,8), %rsi
	jmp	.L216
	.p2align 4,,10
	.p2align 3
.L251:
	movq	%rcx, %rax
	shrq	%rax
	movq	%rax, (%rsi)
	movq	%rbp, %rax
.L236:
	addl	%r9d, %r10d
	leaq	1(%rax,%rcx), %rax
	addq	%r12, %r8
	shrq	%rax
	addq	%r11, %rsi
	movq	%rax, (%rdi)
	addq	%r11, %rdi
	movl	%r10d, %eax
	subl	%r9d, %eax
	cmpl	%eax, %edx
	jle	.L214
.L216:
	movq	(%r8), %rcx
	testb	$1, %cl
	je	.L251
	leaq	(%rcx,%rbp), %rax
	shrq	%rax
	movq	%rax, (%rsi)
	xorl	%eax, %eax
	jmp	.L236
	.p2align 4,,10
	.p2align 3
.L214:
	cmpl	$1, %ebx
	jle	.L213
	movl	%ebx, %r9d
	jmp	.L217
.L213:
	addq	$8, %r14
	cmpq	$48, %r14
	.p2align 4,,3
	.p2align 3
	jne	.L218
	xorl	%r15d, %r15d
.L235:
	movq	16(%rsp), %rcx
	movq	bitsskip(%r15), %r13
	movq	(%rcx,%r15), %rbp
	movq	8(%rcx,%r15), %rbx
	movq	bitsskip+8(%r15), %r12
	mov	nmin(%rip), %r14d
	.p2align 4,,10
	.p2align 3
.L234:
	bsfq	%rbp, %rcx
	movq	%rbp, %rsi
	shrq	%cl, %rsi
	cmpq	kmax(%rip), %rsi
	ja	.L219
	cmpq	kmin(%rip), %rsi
	jb	.L219
	cmpl	nstep(%rip), %ecx
	jb	.L252
	.p2align 4,,10
	.p2align 3
.L219:
	bsfq	%rbx, %rcx
	movq	%rbx, %rsi
	shrq	%cl, %rsi
	cmpq	kmax(%rip), %rsi
	ja	.L220
	cmpq	kmin(%rip), %rsi
	jb	.L220
	cmpl	nstep(%rip), %ecx
	jb	.L253
	.p2align 4,,10
	.p2align 3
.L220:
	movl	bpernstep(%rip), %r8d
	cmpl	$8, %r8d
	jbe	.L254
.L221:
	testl	%r8d, %r8d
	je	.L232
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	xorl	%r9d, %r9d
	.p2align 4,,10
	.p2align 3
.L233:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	incl	%r9d
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
	cmpl	%r9d, %r8d
	ja	.L233
	.p2align 4,,10
	.p2align 3
.L232:
	mov	nstep(%rip), %eax
	addq	%rax, %r14
	mov	nmax(%rip), %eax
	cmpq	%rax, %r14
	jb	.L234
	addq	$16, %r15
	cmpq	$48, %r15
	jne	.L235
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L254:
	mov	%r8d, %eax
	jmp	*.L230(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L230:
	.quad	.L221
	.quad	.L238
	.quad	.L239
	.quad	.L240
	.quad	.L241
	.quad	.L242
	.quad	.L243
	.quad	.L244
	.quad	.L229
	.text
.L229:
	movq	%rbp, %rdx
	movl	bitsmask(%rip), %esi
	movl	bitsatatime(%rip), %edi
	movl	%esi, %eax
	movl	%edi, %ecx
	andl	%ebp, %eax
	shrq	%cl, %rdx
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L228:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L227:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L226:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L225:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L224:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L223:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
.L222:
	movq	%rbp, %rdx
	movl	%edi, %ecx
	movl	%esi, %eax
	shrq	%cl, %rdx
	andl	%ebp, %eax
	movq	(%r13,%rax,8), %rbp
	movl	%esi, %eax
	addq	%rdx, %rbp
	andl	%ebx, %eax
	movq	%rbx, %rdx
	movq	(%r12,%rax,8), %rbx
	shrq	%cl, %rdx
	addq	%rdx, %rbx
	jmp	.L232
.L244:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L228
.L243:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L227
.L242:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L226
.L241:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L225
.L240:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L224
.L239:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L223
.L238:
	movl	bitsatatime(%rip), %edi
	movl	bitsmask(%rip), %esi
	jmp	.L222
.L252:
	leal	(%rcx,%r14), %edx
	movq	8(%rsp), %rax
	movl	$1, %ecx
	movq	(%rax,%r15), %rdi
	call	test_factor
	jmp	.L219
.L253:
	leal	(%rcx,%r14), %edx
	movq	8(%rsp), %rcx
	movq	8(%rcx,%r15), %rdi
	movl	$1, %ecx
	call	test_factor
	jmp	.L220
.LFE588:
	.size	check_ns, .-check_ns
	.p2align 4,,15
.globl app_thread_fun
	.type	app_thread_fun, @function
app_thread_fun:
.LFB589:
	pushq	%r15
.LCFI29:
	leaq	40(%rsi), %rax
	pushq	%r14
.LCFI30:
	pushq	%r13
.LCFI31:
	pushq	%r12
.LCFI32:
	pushq	%rbp
.LCFI33:
	pushq	%rbx
.LCFI34:
	movq	%rsi, %rbx
	subq	$184, %rsp
.LCFI35:
	movdqa	xones.7825(%rip), %xmm2
	movl	nstart(%rip), %r12d
	movq	%rax, 8(%rsp)
#APP
# 874 "app.c" 1
	fildll (%rax)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	leaq	32(%rsi), %rdx
	movq	%rdx, 24(%rsp)
#APP
# 874 "app.c" 1
	fildll (%rdx)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	leaq	24(%rsi), %r15
#APP
# 874 "app.c" 1
	fildll (%r15)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	leaq	16(%rsi), %r13
#APP
# 874 "app.c" 1
	fildll (%r13)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	leaq	8(%rsi), %r14
#APP
# 874 "app.c" 1
	fildll (%r14)
	fld1
	fdivp
# 0 "" 2
# 874 "app.c" 1
	fildll (%rsi)
	fld1
	fdivp
# 0 "" 2
#NO_APP
	movl	$30, %ecx
	bsrl	%r12d, %eax
	movdqa	(%rsi), %xmm3
	xorl	$31, %eax
	movdqa	16(%rsi), %xmm4
	subl	%eax, %ecx
	movdqa	32(%rsi), %xmm5
	movl	$1, %eax
	movl	%eax, %r11d
	sall	%cl, %r11d
	mov	%r12d, %ecx
	movq	%rcx, 16(%rsp)
	testq	%r11, %rcx
	je	.L256
	movdqa	%xmm3, %xmm1
	leaq	32(%rsp), %rax
	paddq	%xmm2, %xmm1
	movq	%rax, (%rsp)
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm3, %xmm0
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, %xmm1
	pand	%xmm2, %xmm1
	psubq	%xmm2, %xmm1
	pandn	%xmm3, %xmm1
	paddq	%xmm1, %xmm0
	movdqa	%xmm4, %xmm1
	psrlq	$1, %xmm0
	paddq	%xmm2, %xmm1
	movdqa	%xmm0, 32(%rsp)
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm4, %xmm0
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, %xmm1
	pand	%xmm2, %xmm1
	psubq	%xmm2, %xmm1
	pandn	%xmm4, %xmm1
	paddq	%xmm1, %xmm0
	movdqa	%xmm5, %xmm1
	psrlq	$1, %xmm0
	paddq	%xmm2, %xmm1
	movdqa	%xmm0, 48(%rsp)
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, %xmm1
	pand	%xmm2, %xmm1
	psubq	%xmm2, %xmm1
	pandn	%xmm5, %xmm1
	paddq	%xmm1, %xmm0
	psrlq	$1, %xmm0
	movdqa	%xmm0, 64(%rsp)
.L306:
	xorl	%ebp, %ebp
	.p2align 4,,10
	.p2align 3
.L305:
	shrq	%r11
	je	.L307
.L276:
#APP
# 1007 "app.c" 1
	fildll 32(%rsp)
	fmul %st(0)
	fmul %st(1)
	fistpll 128(%rsp)
# 0 "" 2
#NO_APP
	movq	32(%rsp), %rdx
	movq	(%rbx), %rdi
	imulq	%rdx, %rdx
	movq	%rdi, %rax
#APP
# 1014 "app.c" 1
	fildll 40(%rsp)
	fmul %st(0)
	fmul %st(2)
	fistpll 136(%rsp)
# 0 "" 2
#NO_APP
	imulq	128(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 32(%rsp)
#APP
# 1021 "app.c" 1
	fildll 48(%rsp)
	fmul %st(0)
	fmul %st(3)
	fistpll 144(%rsp)
# 0 "" 2
# 1028 "app.c" 1
	fildll 56(%rsp)
	fmul %st(0)
	fmul %st(4)
	fistpll 152(%rsp)
# 0 "" 2
# 1035 "app.c" 1
	fildll 64(%rsp)
	fmul %st(0)
	fmul %st(5)
	fistpll 160(%rsp)
# 0 "" 2
# 1042 "app.c" 1
	fildll 72(%rsp)
	fmul %st(0)
	fmul %st(6)
	fistpll 168(%rsp)
# 0 "" 2
#NO_APP
	cmpq	%rdi, %rdx
	jae	.L308
.L258:
	movq	(%r14), %r10
	movq	40(%rsp), %rdx
	movq	%r10, %rax
	imulq	%rdx, %rdx
	imulq	136(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 40(%rsp)
	cmpq	%r10, %rdx
	jae	.L309
.L259:
	movq	(%r13), %r9
	movq	48(%rsp), %rdx
	movq	%r9, %rax
	imulq	%rdx, %rdx
	imulq	144(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 48(%rsp)
	cmpq	%r9, %rdx
	jae	.L310
.L260:
	movq	(%r15), %r8
	movq	56(%rsp), %rdx
	movq	%r8, %rax
	imulq	%rdx, %rdx
	imulq	152(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 56(%rsp)
	cmpq	%r8, %rdx
	jae	.L311
.L261:
	movq	64(%rsp), %rdx
	movq	24(%rsp), %rcx
	imulq	%rdx, %rdx
	movq	(%rcx), %rsi
	movq	%rsi, %rax
	imulq	160(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 64(%rsp)
	cmpq	%rsi, %rdx
	jae	.L312
.L262:
	movq	72(%rsp), %rdx
	movq	8(%rsp), %rax
	imulq	%rdx, %rdx
	movq	(%rax), %rcx
	movq	%rcx, %rax
	imulq	168(%rsp), %rax
	subq	%rax, %rdx
	movq	%rdx, 72(%rsp)
	cmpq	%rcx, %rdx
	jae	.L313
.L263:
	testq	%r11, 16(%rsp)
	je	.L305
	movq	32(%rsp), %rdx
	movq	%rbp, %rax
	testb	$1, %dl
	cmovne	%rdi, %rax
	addq	%rdx, %rax
	movq	40(%rsp), %rdx
	shrq	%rax
	testb	$1, %dl
	movq	%rax, 32(%rsp)
	movq	%rbp, %rax
	cmovne	%r10, %rax
	addq	%rdx, %rax
	movq	48(%rsp), %rdx
	shrq	%rax
	testb	$1, %dl
	movq	%rax, 40(%rsp)
	movq	%rbp, %rax
	cmovne	%r9, %rax
	addq	%rdx, %rax
	movq	56(%rsp), %rdx
	shrq	%rax
	testb	$1, %dl
	movq	%rax, 48(%rsp)
	movq	%rbp, %rax
	cmovne	%r8, %rax
	addq	%rdx, %rax
	movq	64(%rsp), %rdx
	shrq	%rax
	testb	$1, %dl
	movq	%rax, 56(%rsp)
	movq	%rbp, %rax
	cmovne	%rsi, %rax
	addq	%rdx, %rax
	movq	72(%rsp), %rdx
	shrq	%rax
	testb	$1, %dl
	movq	%rax, 64(%rsp)
	movq	%rbp, %rax
	cmovne	%rcx, %rax
	addq	%rdx, %rax
	shrq	%rax
	shrq	%r11
	movq	%rax, 72(%rsp)
	jne	.L276
.L307:
#APP
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
# 1163 "app.c" 1
	fstp %st(0)
# 0 "" 2
#NO_APP
	movl	search_proth(%rip), %ebp
	testl	%ebp, %ebp
	je	.L277
	movq	(%rsp), %rax
	addq	$16, %rax
	cmpq	(%rsp), %r13
	jae	.L314
.L302:
	movdqu	(%rbx), %xmm0
	movq	(%rsp), %rdx
	psubq	(%rdx), %xmm0
	movdqa	%xmm0, (%rdx)
	movdqu	(%r13), %xmm0
	psubq	(%rax), %xmm0
	movdqa	%xmm0, (%rax)
	movdqu	16(%r13), %xmm0
	psubq	16(%rax), %xmm0
	movdqa	%xmm0, 16(%rax)
.L277:
	cmpl	$1, nstep(%rip)
	jbe	.L315
.L280:
	movq	%rbx, %rsi
	movq	(%rsp), %rdi
	call	check_ns
.L301:
	addq	$184, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
	.p2align 3
.L256:
	movdqa	%xmm3, %xmm1
	leaq	32(%rsp), %rdx
	paddq	%xmm2, %xmm1
	movq	%rdx, (%rsp)
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm3, %xmm0
	paddq	%xmm0, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, 32(%rsp)
	movdqa	%xmm4, %xmm1
	paddq	%xmm2, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm4, %xmm0
	paddq	%xmm0, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, 48(%rsp)
	movdqa	%xmm5, %xmm1
	paddq	%xmm2, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, %xmm0
	pand	%xmm2, %xmm0
	psubq	%xmm2, %xmm0
	pandn	%xmm5, %xmm0
	paddq	%xmm0, %xmm1
	psrlq	$1, %xmm1
	movdqa	%xmm1, 64(%rsp)
	jmp	.L306
	.p2align 4,,10
	.p2align 3
.L314:
	cmpq	%rbx, %rax
	jb	.L302
	movq	(%rbx), %rdi
	movq	8(%rbx), %rax
	subq	32(%rsp), %rdi
	subq	40(%rsp), %rax
	movq	%rdi, 32(%rsp)
	movq	%rax, 40(%rsp)
	movq	16(%rbx), %rax
	subq	48(%rsp), %rax
	movq	%rax, 48(%rsp)
	movq	24(%rbx), %rax
	subq	56(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	32(%rbx), %rax
	subq	64(%rsp), %rax
	movq	%rax, 64(%rsp)
	movq	40(%rbx), %rax
	subq	72(%rsp), %rax
	cmpl	$1, nstep(%rip)
	movq	%rax, 72(%rsp)
	ja	.L280
	.p2align 4,,10
	.p2align 3
.L315:
	movq	(%rbx), %rdi
	jmp	.L300
	.p2align 4,,10
	.p2align 3
.L316:
	xorl	%eax, %eax
	movq	(%rbx), %rdi
.L289:
	addq	%rdx, %rax
	movq	40(%rsp), %rdx
	shrq	%rax
	movq	%rax, 32(%rsp)
	xorl	%eax, %eax
	testb	$1, %dl
	je	.L291
	movq	(%r14), %rax
.L291:
	addq	%rdx, %rax
	movq	48(%rsp), %rdx
	shrq	%rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	testb	$1, %dl
	je	.L293
	movq	(%r13), %rax
.L293:
	addq	%rdx, %rax
	movq	56(%rsp), %rdx
	shrq	%rax
	movq	%rax, 48(%rsp)
	xorl	%eax, %eax
	testb	$1, %dl
	je	.L295
	movq	(%r15), %rax
.L295:
	addq	%rdx, %rax
	movq	64(%rsp), %rdx
	shrq	%rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	testb	$1, %dl
	je	.L297
	movq	24(%rsp), %rcx
	movq	(%rcx), %rax
.L297:
	addq	%rdx, %rax
	xorl	%edx, %edx
	shrq	%rax
	movq	%rax, 64(%rsp)
	movq	72(%rsp), %rax
	testb	$1, %al
	je	.L299
	movq	8(%rsp), %rcx
	movq	(%rcx), %rdx
.L299:
	leaq	(%rdx,%rax), %rax
	shrq	%rax
	movq	%rax, 72(%rsp)
.L300:
	movq	32(%rsp), %rsi
	cmpq	kmax(%rip), %rsi
	ja	.L281
	testb	$1, %sil
	je	.L281
	cmpq	kmin(%rip), %rsi
	jb	.L281
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L281:
	movq	40(%rsp), %rsi
	movq	(%r14), %rdi
	cmpq	kmax(%rip), %rsi
	ja	.L282
	testb	$1, %sil
	je	.L282
	cmpq	kmin(%rip), %rsi
	jb	.L282
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L282:
	movq	48(%rsp), %rsi
	movq	(%r13), %rdi
	cmpq	kmax(%rip), %rsi
	ja	.L283
	testb	$1, %sil
	je	.L283
	cmpq	kmin(%rip), %rsi
	jb	.L283
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L283:
	movq	56(%rsp), %rsi
	movq	(%r15), %rdi
	cmpq	kmax(%rip), %rsi
	ja	.L284
	testb	$1, %sil
	je	.L284
	cmpq	kmin(%rip), %rsi
	jb	.L284
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L284:
	movq	64(%rsp), %rsi
	movq	24(%rsp), %rcx
	cmpq	kmax(%rip), %rsi
	movq	(%rcx), %rdi
	ja	.L285
	testb	$1, %sil
	je	.L285
	cmpq	kmin(%rip), %rsi
	jb	.L285
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L285:
	movq	72(%rsp), %rsi
	movq	8(%rsp), %rax
	cmpq	kmax(%rip), %rsi
	movq	(%rax), %rdi
	ja	.L286
	testb	$1, %sil
	je	.L286
	cmpq	kmin(%rip), %rsi
	jb	.L286
	movl	$-1, %ecx
	movl	%r12d, %edx
	call	test_factor
	.p2align 4,,10
	.p2align 3
.L286:
	incl	%r12d
	cmpl	nmax(%rip), %r12d
	ja	.L301
	movq	32(%rsp), %rdx
	testb	$1, %dl
	je	.L316
	movq	(%rbx), %rdi
	movq	%rdi, %rax
	jmp	.L289
.L310:
	subq	%r9, %rdx
	movq	%rdx, 48(%rsp)
	jmp	.L260
.L311:
	subq	%r8, %rdx
	movq	%rdx, 56(%rsp)
	jmp	.L261
.L312:
	subq	%rsi, %rdx
	movq	%rdx, 64(%rsp)
	jmp	.L262
.L313:
	subq	%rcx, %rdx
	movq	%rdx, 72(%rsp)
	jmp	.L263
.L308:
	subq	%rdi, %rdx
	movq	%rdx, 32(%rsp)
	jmp	.L258
.L309:
	subq	%r10, %rdx
	movq	%rdx, 40(%rsp)
	jmp	.L259
.LFE589:
	.size	app_thread_fun, .-app_thread_fun
	.p2align 4,,15
.globl app_thread_fun1
	.type	app_thread_fun1, @function
app_thread_fun1:
.LFB590:
	subq	$56, %rsp
.LCFI36:
	movl	%edx, %r9d
	testl	%edx, %edx
	je	.L326
	movq	%rsp, %r10
	cmpl	$19, %edx
	ja	.L333
.L319:
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L324:
	movq	(%rsi,%rdx,8), %rax
	movq	%rax, (%r10,%rdx,8)
	incq	%rdx
	cmpl	%edx, %r9d
	ja	.L324
	cmpl	$5, %r9d
	ja	.L323
	movl	%r9d, %ecx
	.p2align 4,,10
	.p2align 3
.L325:
	mov	%ecx, %eax
	leal	-1(%rcx), %edx
	incl	%ecx
	movq	(%rsi,%rdx,8), %rdx
	cmpl	$5, %ecx
	movq	%rdx, (%rsp,%rax,8)
	jbe	.L325
.L323:
	movq	%rsp, %rsi
	call	app_thread_fun
.L326:
	addq	$56, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L333:
	leaq	16(%rsi), %rax
	cmpq	%rax, %rsp
	jbe	.L334
.L327:
	movl	%r9d, %r8d
	shrl	%r8d
	movl	%r8d, %ecx
	addl	%ecx, %ecx
	je	.L328
	xorl	%edx, %edx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L322:
	movdqu	(%rsi,%rax), %xmm0
	incl	%edx
	movdqa	%xmm0, (%r10,%rax)
	addq	$16, %rax
	cmpl	%r8d, %edx
	jb	.L322
	cmpl	%ecx, %r9d
	je	.L323
	.p2align 4,,10
	.p2align 3
.L328:
	mov	%ecx, %edx
	incl	%ecx
	movq	(%rsi,%rdx,8), %rax
	cmpl	%ecx, %r9d
	movq	%rax, (%rsp,%rdx,8)
	ja	.L328
	jmp	.L323
	.p2align 4,,10
	.p2align 3
.L334:
	leaq	16(%rsp), %rax
	cmpq	%rax, %rsi
	jbe	.L319
	.p2align 4,,7
	.p2align 3
	jmp	.L327
.LFE590:
	.size	app_thread_fun1, .-app_thread_fun1
	.local	factors_file
	.comm	factors_file,8,8
	.local	factor_count
	.comm	factor_count,4,4
	.local	bitmap
	.comm	bitmap,8,8
	.local	nmin
	.comm	nmin,4,4
	.local	nmax
	.comm	nmax,4,4
	.local	nstart
	.comm	nstart,4,4
	.data
	.align 4
	.type	search_proth, @object
	.size	search_proth, 4
search_proth:
	.long	1
	.local	nstep
	.comm	nstep,4,4
	.local	kmax
	.comm	kmax,8,8
	.local	kmin
	.comm	kmin,8,8
	.section	.rodata
	.align 16
	.type	xones.7825, @object
	.size	xones.7825, 16
xones.7825:
	.quad	1
	.quad	1
	.local	b0
	.comm	b0,8,8
	.data
	.align 4
	.type	print_factors, @object
	.size	print_factors, 4
print_factors:
	.long	1
	.align 4
	.type	bitsatatime, @object
	.size	bitsatatime, 4
bitsatatime:
	.long	8
	.local	input_filename
	.comm	input_filename,8,8
	.local	b1
	.comm	b1,8,8
	.align 4
	.type	use_sse2, @object
	.size	use_sse2, 4
use_sse2:
	.long	2
	.local	sse2_in_range
	.comm	sse2_in_range,4,4
	.align 4
	.type	file_format, @object
	.size	file_format, 4
file_format:
	.long	2
	.local	factors_filename
	.comm	factors_filename,8,8
	.local	xkmax
	.comm	xkmax,16,16
	.local	bitsmask
	.comm	bitsmask,4,4
	.local	bpernstep
	.comm	bpernstep,4,4
	.local	bitsskip
	.comm	bitsskip,48,32
	.local	factors_mutex
	.comm	factors_mutex,40,32
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
	.long	.LFB582
	.long	.LFE582-.LFB582
	.uleb128 0x0
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB584
	.long	.LFE584-.LFB584
	.uleb128 0x0
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB587
	.long	.LFE587-.LFB587
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB587
	.byte	0xe
	.uleb128 0x10
	.byte	0x8d
	.uleb128 0x2
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
	.byte	0x83
	.uleb128 0x5
	.byte	0x86
	.uleb128 0x4
	.byte	0x8c
	.uleb128 0x3
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB591
	.long	.LFE591-.LFB591
	.uleb128 0x0
	.align 8
.LEFDE7:
.LSFDE9:
	.long	.LEFDE9-.LASFDE9
.LASFDE9:
	.long	.LASFDE9-.Lframe1
	.long	.LFB594
	.long	.LFE594-.LFB594
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI4-.LFB594
	.byte	0xe
	.uleb128 0x10
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE9:
.LSFDE11:
	.long	.LEFDE11-.LASFDE11
.LASFDE11:
	.long	.LASFDE11-.Lframe1
	.long	.LFB593
	.long	.LFE593-.LFB593
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI5-.LFB593
	.byte	0xe
	.uleb128 0x10
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE11:
.LSFDE13:
	.long	.LEFDE13-.LASFDE13
.LASFDE13:
	.long	.LASFDE13-.Lframe1
	.long	.LFB592
	.long	.LFE592-.LFB592
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI6-.LFB592
	.byte	0xe
	.uleb128 0x20
	.align 8
.LEFDE13:
.LSFDE15:
	.long	.LEFDE15-.LASFDE15
.LASFDE15:
	.long	.LASFDE15-.Lframe1
	.long	.LFB575
	.long	.LFE575-.LFB575
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI10-.LFB575
	.byte	0x8d
	.uleb128 0x2
	.byte	0x8c
	.uleb128 0x3
	.byte	0x86
	.uleb128 0x4
	.byte	0x83
	.uleb128 0x5
	.byte	0x4
	.long	.LCFI11-.LCFI10
	.byte	0xe
	.uleb128 0x30
	.align 8
.LEFDE15:
.LSFDE17:
	.long	.LEFDE17-.LASFDE17
.LASFDE17:
	.long	.LASFDE17-.Lframe1
	.long	.LFB581
	.long	.LFE581-.LFB581
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI12-.LFB581
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE17:
.LSFDE19:
	.long	.LEFDE19-.LASFDE19
.LASFDE19:
	.long	.LASFDE19-.Lframe1
	.long	.LFB579
	.long	.LFE579-.LFB579
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI13-.LFB579
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE19:
.LSFDE21:
	.long	.LEFDE21-.LASFDE21
.LASFDE21:
	.long	.LASFDE21-.Lframe1
	.long	.LFB583
	.long	.LFE583-.LFB583
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI14-.LFB583
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI15-.LCFI14
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI16-.LCFI15
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI17-.LCFI16
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI18-.LCFI17
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI19-.LCFI18
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI20-.LCFI19
	.byte	0xe
	.uleb128 0x90
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
.LEFDE21:
.LSFDE23:
	.long	.LEFDE23-.LASFDE23
.LASFDE23:
	.long	.LASFDE23-.Lframe1
	.long	.LFB580
	.long	.LFE580-.LFB580
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI21-.LFB580
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE23:
.LSFDE25:
	.long	.LEFDE25-.LASFDE25
.LASFDE25:
	.long	.LASFDE25-.Lframe1
	.long	.LFB588
	.long	.LFE588-.LFB588
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI22-.LFB588
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI23-.LCFI22
	.byte	0xe
	.uleb128 0x18
	.byte	0x8e
	.uleb128 0x3
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI24-.LCFI23
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI25-.LCFI24
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI26-.LCFI25
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI27-.LCFI26
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI28-.LCFI27
	.byte	0xe
	.uleb128 0x50
	.byte	0x83
	.uleb128 0x7
	.byte	0x86
	.uleb128 0x6
	.byte	0x8c
	.uleb128 0x5
	.byte	0x8d
	.uleb128 0x4
	.align 8
.LEFDE25:
.LSFDE27:
	.long	.LEFDE27-.LASFDE27
.LASFDE27:
	.long	.LASFDE27-.Lframe1
	.long	.LFB589
	.long	.LFE589-.LFB589
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI29-.LFB589
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI30-.LCFI29
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI31-.LCFI30
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI32-.LCFI31
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI33-.LCFI32
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI34-.LCFI33
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
	.long	.LCFI35-.LCFI34
	.byte	0xe
	.uleb128 0xf0
	.align 8
.LEFDE27:
.LSFDE29:
	.long	.LEFDE29-.LASFDE29
.LASFDE29:
	.long	.LASFDE29-.Lframe1
	.long	.LFB590
	.long	.LFE590-.LFB590
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI36-.LFB590
	.byte	0xe
	.uleb128 0x40
	.align 8
.LEFDE29:
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
