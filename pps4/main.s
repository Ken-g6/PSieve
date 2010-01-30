	.file	"main.c"
	.text
	.p2align 4,,15
	.type	handle_signal, @function
handle_signal:
.LFB77:
	cmpl	$15, %edi
	ja	.L4
	movl	$1, %eax
	movl	%edi, %ecx
	salq	%cl, %rax
	testl	$32774, %eax
	je	.L4
	movb	$1, stopping(%rip)
.L4:
	rep
	ret
.LFE77:
	.size	handle_signal, .-handle_signal
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"idle"
.LC1:
	.string	"normal"
.LC2:
	.string	"none"
	.text
	.p2align 4,,15
	.type	parse_option, @function
parse_option:
.LFB84:
	subq	$8, %rsp
.LCFI0:
	movq	%rsi, %r8
	cmpl	$104, %edi
	je	.L14
	jle	.L31
	cmpl	$114, %edi
	je	.L17
	.p2align 4,,9
	.p2align 3
	jle	.L32
	cmpl	$122, %edi
	.p2align 4,,7
	.p2align 3
	je	.L19
	cmpl	$256, %edi
	.p2align 4,,7
	.p2align 3
	je	.L20
	cmpl	$116, %edi
	.p2align 4,,5
	.p2align 3
	jne	.L7
	movl	$32, %ecx
	movl	$1, %edx
	movl	$num_threads, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L31:
	cmpl	$67, %edi
	je	.L10
	jle	.L33
	cmpl	$81, %edi
	.p2align 4,,7
	.p2align 3
	je	.L12
	cmpl	$99, %edi
	.p2align 4,,7
	.p2align 3
	je	.L13
	cmpl	$80, %edi
	.p2align 4,,5
	.p2align 3
	jne	.L7
	movabsq	$4611686018427387904, %rcx
	movl	$4, %edx
	movl	$pmax, %edi
	addq	$8, %rsp
	jmp	parse_uint64
	.p2align 4,,10
	.p2align 3
.L32:
	cmpl	$112, %edi
	je	.L15
	cmpl	$113, %edi
	je	.L34
.L7:
	movq	%r8, %rsi
	addq	$8, %rsp
	jmp	app_parse_option
	.p2align 4,,10
	.p2align 3
.L33:
	cmpl	$63, %edi
	je	.L8
	cmpl	$66, %edi
	jne	.L7
	movl	$134217728, %ecx
	movl	$1024, %edx
	movl	$blocksize_opt, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$4, %ecx
	movl	$2, %edx
	movl	$blocks_opt, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L19:
	movl	$.LC0, %edi
	movl	$5, %ecx
	repz cmpsb
	je	.L35
	cmpb	$108, (%r8)
	je	.L36
.L27:
	movl	$.LC1, %edi
	movl	$7, %ecx
	movq	%r8, %rsi
	repz cmpsb
	jne	.L28
	movl	$0, priority_opt(%rip)
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L26:
	incl	priority_opt(%rip)
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L17:
	movl	$-1, %ecx
	xorl	%edx, %edx
	movl	$report_opt, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L8:
	movl	$-3, %eax
.L24:
	addq	$8, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	movl	$-1, %ecx
	xorl	%edx, %edx
	movl	$checkpoint_opt, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L12:
	movl	$-2147483648, %ecx
	movl	$3, %edx
	movl	$qmax, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L34:
	movl	$1, quiet_opt(%rip)
	xorl	%eax, %eax
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L15:
	movq	%rsi, pmin_str(%rip)
	movabsq	$4611686018427387903, %rcx
	movl	$3, %edx
	movl	$pmin, %edi
	addq	$8, %rsp
	jmp	parse_uint64
	.p2align 4,,10
	.p2align 3
.L10:
	movl	$131072, %ecx
	movl	$16, %edx
	movl	$chunksize_opt, %edi
	addq	$8, %rsp
	jmp	parse_uint
	.p2align 4,,10
	.p2align 3
.L14:
	movl	$1, help_opt(%rip)
	xorl	%eax, %eax
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L35:
	movl	$19, priority_opt(%rip)
	xorl	%eax, %eax
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L36:
	cmpb	$111, 1(%r8)
	jne	.L27
	cmpb	$119, 2(%r8)
	jne	.L27
	cmpb	$0, 3(%r8)
	.p2align 4,,5
	.p2align 3
	jne	.L27
	movl	$10, priority_opt(%rip)
	xorl	%eax, %eax
	jmp	.L26
.L28:
	movl	$.LC2, %edi
	movl	$5, %ecx
	movq	%r8, %rsi
	repz cmpsb
	jne	.L29
	movl	$-1, priority_opt(%rip)
	xorl	%eax, %eax
	jmp	.L26
.L29:
	movl	$19, %ecx
	xorl	%edx, %edx
	movq	%r8, %rsi
	movl	$priority_opt, %edi
	call	parse_uint
	jmp	.L26
.LFE84:
	.size	parse_option, .-parse_option
	.p2align 4,,15
	.type	thread_cleanup, @function
thread_cleanup:
.LFB87:
	pushq	%rbx
.LCFI1:
	movq	%rdi, %rbx
	movl	$exiting_mutex, %edi
	movslq	%ebx,%rbx
	call	pthread_mutex_lock
	leaq	(%rbx,%rbx,2), %rbx
	movl	$exiting_cond, %edi
	movb	$1, thread_data+16(,%rbx,8)
	call	pthread_cond_signal
	movl	$exiting_mutex, %edi
	popq	%rbx
	jmp	pthread_mutex_unlock
.LFE87:
	.size	thread_cleanup, .-thread_cleanup
	.section	.rodata.str1.1
.LC3:
	.string	"Thread %d starting\n"
.LC4:
	.string	"\nThread %d completed"
.LC5:
	.string	"\nThread %d interrupted"
	.text
	.p2align 4,,15
	.type	thread_fun, @function
thread_fun:
.LFB88:
	pushq	%r15
.LCFI2:
	xorl	%esi, %esi
	pushq	%r14
.LCFI3:
	pushq	%r13
.LCFI4:
	pushq	%r12
.LCFI5:
	pushq	%rbp
.LCFI6:
	pushq	%rbx
.LCFI7:
	subq	$248, %rsp
.LCFI8:
	movq	%rdi, 40(%rsp)
	leaq	64(%rsp), %rdi
	call	__sigsetjmp
	testl	%eax, %eax
	jne	.L55
	movl	40(%rsp), %eax
	leaq	64(%rsp), %rdi
	movl	%eax, 48(%rsp)
	xorl	%r15d, %r15d
	call	__pthread_register_cancel
	xorl	%r14d, %r14d
	movl	40(%rsp), %ecx
	movl	$.LC3, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	xorl	%ebp, %ebp
	call	__fprintf_chk
	movq	sv(%rip), %rax
	movq	$0, 232(%rsp)
	movl	140(%rax), %eax
	movl	40(%rsp), %edi
	movl	%eax, 52(%rsp)
	call	app_thread_init
	xorl	%r9d, %r9d
	movl	52(%rsp), %eax
	decl	%eax
	leaq	8(,%rax,8), %rax
	movq	%rax, 32(%rsp)
	movslq	48(%rsp),%rax
	leaq	(%rax,%rax,2), %rax
	salq	$3, %rax
	movq	%rax, 24(%rsp)
	movzbl	stopping(%rip), %eax
	testb	%al, %al
	jne	.L42
	.p2align 4,,10
	.p2align 3
.L50:
	leaq	232(%rsp), %rsi
	movq	sv(%rip), %rdi
	call	get_chunk
	movq	%rax, %r9
	cmpq	pmax(%rip), %rax
	jae	.L42
	movl	52(%rsp), %eax
	testl	%eax, %eax
	je	.L43
	movq	$0, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L47:
	movq	232(%rsp), %rax
	movq	56(%rsp), %rdx
	movq	(%rax,%rdx), %rbx
	testq	%rbx, %rbx
	je	.L44
	movl	56(%rsp), %r8d
	xorl	%eax, %eax
	sall	$3, %r8d
	jmp	.L46
	.p2align 4,,10
	.p2align 3
.L45:
	movq	%rbx, %rax
	movl	%r12d, %ecx
	shrq	%cl, %rax
	movq	%rax, %rbx
	shrq	%rbx
	je	.L44
	leal	1(%r13), %eax
.L46:
	bsfq	%rbx, %r12
	mov	%ebp, %edx
	leal	(%rax,%r12), %r13d
	incq	%r15
	leal	(%r13,%r8), %eax
	incl	%ebp
	leaq	(%r9,%rax,2), %rax
	addq	%rax, %r14
	movq	%rax, 176(%rsp,%rdx,8)
	cmpl	$6, %ebp
	jne	.L45
	movl	%r8d, 16(%rsp)
	movq	%r9, 8(%rsp)
	leaq	176(%rsp), %rsi
	movl	48(%rsp), %edi
	xorb	%bpl, %bpl
	call	app_thread_fun
	movq	8(%rsp), %r9
	movl	16(%rsp), %r8d
	jmp	.L45
	.p2align 4,,10
	.p2align 3
.L44:
	addq	$8, 56(%rsp)
	movq	32(%rsp), %rax
	cmpq	%rax, 56(%rsp)
	jne	.L47
.L43:
	movq	%r9, %rsi
	movq	%r9, 8(%rsp)
	movq	sv(%rip), %rdi
	movq	%r15, %r12
	call	free_chunk
	movq	%r14, %rbx
	movzbl	checkpointing(%rip), %eax
	movq	8(%rsp), %r9
	testb	%al, %al
	jne	.L56
.L49:
	movzbl	stopping(%rip), %eax
	movq	%r12, %r15
	movq	%rbx, %r14
	testb	%al, %al
	je	.L50
.L42:
	movq	%r9, 8(%rsp)
	leaq	176(%rsp), %rsi
	movl	%ebp, %edx
	movl	48(%rsp), %edi
	call	app_thread_fun1
	movslq	48(%rsp),%rax
	movl	48(%rsp), %edi
	leaq	(%rax,%rax,2), %rax
	movq	%r15, thread_data(,%rax,8)
	movq	%r14, thread_data+8(,%rax,8)
	call	app_thread_fini
	movq	8(%rsp), %r9
	cmpq	pmax(%rip), %r9
	jae	.L57
	movl	48(%rsp), %ecx
	movl	$.LC5, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
.L52:
	movl	$checkpoint_semaphoreA, %edi
	movb	$1, no_more_checkpoints(%rip)
	call	sem_post
	leaq	64(%rsp), %rdi
	call	__pthread_unregister_cancel
	movl	$exiting_mutex, %edi
	call	pthread_mutex_lock
	movslq	48(%rsp),%rax
	movl	$exiting_cond, %edi
	leaq	(%rax,%rax,2), %rax
	movb	$1, thread_data+16(,%rax,8)
	call	pthread_cond_signal
	movl	$exiting_mutex, %edi
	call	pthread_mutex_unlock
	addq	$248, %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L56:
	movq	%r9, 8(%rsp)
	leaq	176(%rsp), %rsi
	movl	%ebp, %edx
	movl	48(%rsp), %edi
	xorl	%ebp, %ebp
	call	app_thread_fun1
	movq	24(%rsp), %rdx
	movl	$checkpoint_semaphoreA, %edi
	movq	%r15, thread_data(%rdx)
	movq	%r14, thread_data+8(%rdx)
	call	sem_post
	movl	$checkpoint_semaphoreB, %edi
	call	sem_wait
	movq	8(%rsp), %r9
	jmp	.L49
.L57:
	movl	48(%rsp), %ecx
	movl	$.LC4, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L52
.L55:
	movq	40(%rsp), %rdi
	call	thread_cleanup
	leaq	64(%rsp), %rdi
	call	__pthread_unwind_next
.LFE88:
	.size	thread_fun, .-thread_fun
	.section	.rodata.str1.1
.LC6:
	.string	"r"
.LC7:
	.string	"ppconfig.txt"
.LC8:
	.string	"= \n\r\t\013"
.LC9:
	.string	"%s: unrecognised option `%s'\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC10:
	.string	"%s: option `%s' doesn't allow an argument\n"
	.align 8
.LC11:
	.string	"%s: option `%s' requires an argument\n"
	.section	.rodata.str1.1
.LC12:
	.string	"%s: invalid argument %s %s\n"
	.section	.rodata.str1.8
	.align 8
.LC13:
	.string	"%s: out of range argument %s %s\n"
	.section	.rodata.str1.1
.LC14:
	.string	"%s: invalid argument -%c %s\n"
.LC15:
	.string	"%s: invalid argument --%s %s\n"
	.section	.rodata.str1.8
	.align 8
.LC16:
	.string	"%s: out of range argument -%c %s\n"
	.align 8
.LC17:
	.string	"%s: out of range argument --%s %s\n"
	.align 8
.LC18:
	.string	"%s: invalid non-option argument %s\n"
	.align 8
.LC19:
	.string	"%s: out of range non-option argument %s\n"
	.align 8
.LC20:
	.string	"-p --pmin=P0       Sieve start: 3 <= P0 <= p (default P0=3)"
	.align 8
.LC21:
	.string	"-P --pmax=P1       Sieve end: p < P1 <= 2^62 (default P1=P0+10^9)"
	.align 8
.LC22:
	.string	"-Q --qmax=Q1       Sieve only with odd primes q < Q1 <= 2^31"
	.align 8
.LC23:
	.string	"-B --blocksize=N   Sieve in blocks of N bytes (default N=%d)\n"
	.align 8
.LC24:
	.string	"-C --chunksize=N   Process blocks in chunks of N bytes (default N=%d)\n"
	.align 8
.LC25:
	.string	"   --blocks=N      Sieve up to N blocks ahead (default N=%d)\n"
	.align 8
.LC26:
	.string	"-c --checkpoint=N  Checkpoint every N seconds (default N=%d)\n"
	.align 8
.LC27:
	.string	"-q --quiet         Don't print factors to screen"
	.align 8
.LC28:
	.string	"-r --report=N      Report status every N seconds (default N=%d)\n"
	.align 8
.LC29:
	.string	"-t --threads=N     Start N child threads (default N=1)"
	.align 8
.LC30:
	.string	"-z --priority=N    Set process priority to nice N or {idle,low,normal}"
	.align 8
.LC31:
	.string	"-h --help          Print this help"
	.align 8
.LC32:
	.string	"pmax not specified, using default pmax = pmin + 1e9\n"
	.align 8
.LC33:
	.string	"Option out of range: pmax must be greater than pmin\n"
	.section	.rodata.str1.1
.LC34:
	.string	"ppcheck%s.txt"
	.section	.rodata.str1.8
	.align 8
.LC35:
	.string	"Sieve started: %lu <= p < %lu\n"
	.section	.rodata.str1.1
.LC36:
	.string	"ppcheckpoint.txt"
	.section	.rodata.str1.8
	.align 8
.LC37:
	.string	"pmin=%lu,p=%lu,count=%lu,sum=0x%lx,checksum=0x%lx\n"
	.align 8
.LC38:
	.string	"Resuming from checkpoint p=%lu in %s\n"
	.align 8
.LC39:
	.string	"Ignoring invalid checkpoint in %s\n"
	.section	.rodata.str1.1
.LC40:
	.string	"pthread_create"
.LC42:
	.string	"M"
.LC44:
	.string	"K"
.LC45:
	.string	""
.LC49:
	.string	"ETA %d %b %H:%M"
	.section	.rodata.str1.8
	.align 8
.LC50:
	.string	"p=%lu, %.*f%s p/sec, %.2f CPU cores, %.1f%% done. %s  "
	.section	.rodata.str1.1
.LC51:
	.string	"w"
	.section	.rodata.str1.8
	.align 8
.LC52:
	.string	"pmin=%lu,p=%lu,count=%lu,sum=0x%016lx,checksum=0x%016lx\n"
	.section	.rodata.str1.1
.LC53:
	.string	"\nWaiting for threads to exit"
.LC54:
	.string	"Thread %d failed: %p\n"
	.section	.rodata.str1.8
	.align 8
.LC55:
	.string	"\nSieve complete: %lu <= p < %lu\n"
	.align 8
.LC56:
	.string	"\nSieve incomplete: %lu <= p < %lu\n"
	.section	.rodata.str1.1
.LC57:
	.string	"count=%lu,sum=0x%016lx\n"
	.section	.rodata.str1.8
	.align 8
.LC59:
	.string	"Elapsed time: %.2f sec. (%.2f init + %.2f sieve) at %.0f p/sec.\n"
	.align 8
.LC60:
	.string	"Processor time: %.2f sec. (%.2f init + %.2f sieve) at %.0f p/sec.\n"
	.align 8
.LC61:
	.string	"Average processor utilization: %.2f (init), %.2f (sieve)\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
.LFB89:
	pushq	%r15
.LCFI9:
	movq	%rsi, %r15
	pushq	%r14
.LCFI10:
	pushq	%r13
.LCFI11:
	pushq	%r12
.LCFI12:
	pushq	%rbp
.LCFI13:
	pushq	%rbx
.LCFI14:
	subq	$632, %rsp
.LCFI15:
	movl	%edi, 44(%rsp)
	movq	%fs:40, %rax
	movq	%rax, 616(%rsp)
	xorl	%eax, %eax
	leaq	448(%rsp), %r14
	call	elapsed_usec
	movq	%rax, program_start_time(%rip)
	call	app_banner
	movl	$.LC6, %esi
	movl	$.LC7, %edi
	call	fopen
	movq	%rax, %r13
	testq	%rax, %rax
	je	.L59
	.p2align 4,,10
	.p2align 3
.L221:
	movq	%r13, %rdx
	movl	$128, %esi
	movq	%r14, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L234
	movl	$.LC8, %esi
	movq	%r14, %rdi
	call	strtok
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L221
	cmpb	$35, (%rax)
	je	.L221
	movl	$.LC8, %esi
	xorl	%edi, %edi
	call	strtok
	movq	long_opts(%rip), %rsi
	movq	%rax, 64(%rsp)
	testq	%rsi, %rsi
	je	.L61
	movl	$long_opts+32, %ebp
	xorl	%r12d, %r12d
	jmp	.L63
	.p2align 4,,10
	.p2align 3
.L235:
	movq	(%rbp), %rsi
	incl	%r12d
	addq	$32, %rbp
	testq	%rsi, %rsi
	je	.L61
.L63:
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L235
	movslq	%r12d,%rdx
	movq	%rdx, %rax
	salq	$5, %rax
	movl	long_opts+8(%rax), %eax
	testl	%eax, %eax
	jne	.L66
	cmpq	$0, 64(%rsp)
	je	.L67
	movq	%rbx, %r8
	movl	$.LC7, %ecx
	movl	$.LC10, %edx
	jmp	.L231
	.p2align 4,,10
	.p2align 3
.L234:
	movq	%r13, %rdi
	call	fclose
.L59:
	movl	$-1, 444(%rsp)
	movq	short_opts(%rip), %r12
	leaq	444(%rsp), %rbp
.L73:
	movq	%rbp, %r8
	movl	$long_opts, %ecx
	movq	%r12, %rdx
	movq	%r15, %rsi
	movl	44(%rsp), %edi
	call	getopt_long
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L236
	xorl	%edx, %edx
	movq	optarg(%rip), %rsi
	movl	%ebx, %edi
	call	parse_option
	cmpl	$-1, %eax
	je	.L76
	testl	%eax, %eax
	je	.L77
	cmpl	$-2, %eax
	.p2align 4,,5
	.p2align 3
	je	.L237
.L233:
	movl	$1, %edi
	.p2align 4,,5
	.p2align 3
	call	exit
	.p2align 4,,10
	.p2align 3
.L77:
	movl	$-1, 444(%rsp)
	jmp	.L73
	.p2align 4,,10
	.p2align 3
.L76:
	movl	444(%rsp), %eax
	cmpl	$-1, %eax
	je	.L238
	cltq
	movq	optarg(%rip), %r9
	salq	$5, %rax
	movq	(%r15), %rcx
	movq	long_opts(%rax), %r8
	movl	$.LC15, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L233
.L237:
	movl	444(%rsp), %eax
	cmpl	$-1, %eax
	je	.L239
	cltq
	movq	optarg(%rip), %r9
	salq	$5, %rax
	movq	(%r15), %rcx
	movq	long_opts(%rax), %r8
	movl	$.LC17, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L233
.L66:
	decl	%eax
	je	.L240
.L67:
	leaq	1(%rdx,%rdx), %rax
	salq	$4, %rax
	movq	long_opts(%rax), %rdx
	testq	%rdx, %rdx
	je	.L68
	movl	long_opts+8(%rax), %eax
	movl	%eax, (%rdx)
	jmp	.L221
.L240:
	cmpq	$0, 64(%rsp)
	jne	.L67
	movq	%rbx, %r8
	movl	$.LC7, %ecx
	movl	$.LC11, %edx
.L231:
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L233
.L239:
	movq	optarg(%rip), %r9
	movl	%ebx, %r8d
	movq	(%r15), %rcx
	movl	$.LC16, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L233
.L238:
	movq	optarg(%rip), %r9
	movl	%ebx, %r8d
	movq	(%r15), %rcx
	movl	$.LC14, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L233
.L236:
	movl	optind(%rip), %eax
	cmpl	%eax, 44(%rsp)
	jle	.L83
.L209:
	cltq
	xorl	%edx, %edx
	xorl	%edi, %edi
	movq	(%r15,%rax,8), %rsi
	call	parse_option
	cmpl	$-1, %eax
	je	.L86
	testl	%eax, %eax
	jne	.L241
	movl	optind(%rip), %eax
	incl	%eax
	movl	%eax, optind(%rip)
	cmpl	%eax, 44(%rsp)
	jg	.L209
.L83:
	movl	help_opt(%rip), %r12d
	testl	%r12d, %r12d
	jne	.L242
	cmpq	$2, pmin(%rip)
	ja	.L90
	movq	$3, pmin(%rip)
.L90:
	movabsq	$4611686018427387904, %rax
	cmpq	%rax, pmax(%rip)
	jbe	.L91
	movq	%rax, pmax(%rip)
.L91:
	movq	pmin(%rip), %rdx
	movq	pmax(%rip), %rax
	cmpq	%rax, %rdx
	jb	.L92
	testq	%rax, %rax
	jne	.L93
	movabsq	$4611686017427387903, %rax
	cmpq	%rax, %rdx
	jbe	.L243
.L93:
	movl	$.LC33, %edi
	movq	stderr(%rip), %rcx
	movl	$52, %edx
	movl	$1, %esi
	call	fwrite
	movl	$1, %edi
	call	exit
	.p2align 4,,10
	.p2align 3
.L68:
	movl	long_opts+8(%rax), %edi
	movl	$.LC7, %edx
	movq	64(%rsp), %rsi
	call	parse_option
	cmpl	$-1, %eax
	je	.L71
	testl	%eax, %eax
	je	.L221
	cmpl	$-2, %eax
	.p2align 4,,5
	.p2align 3
	jne	.L233
	movq	64(%rsp), %r9
	movq	%rbx, %r8
	movl	$.LC7, %ecx
	movl	$.LC13, %edx
.L229:
	movq	stderr(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movl	$1, %edi
	call	exit
.L241:
	cmpl	$-2, %eax
	jne	.L233
	movslq	optind(%rip),%rax
	movq	(%r15), %rcx
	movq	(%r15,%rax,8), %r8
	movl	$.LC19, %edx
	jmp	.L231
.L86:
	movslq	optind(%rip),%rax
	movq	(%r15), %rcx
	movq	(%r15,%rax,8), %r8
	movl	$.LC18, %edx
	jmp	.L231
.L71:
	movq	64(%rsp), %r9
	movq	%rbx, %r8
	movl	$.LC7, %ecx
	movl	$.LC12, %edx
	jmp	.L229
.L61:
	movq	%rbx, %r8
	movl	$.LC7, %ecx
	movl	$.LC9, %edx
	jmp	.L231
.L243:
	movq	stderr(%rip), %rcx
	movl	$52, %edx
	movl	$1, %esi
	movl	$.LC32, %edi
	call	fwrite
	movq	pmin(%rip), %rax
	addq	$1000000000, %rax
	movq	%rax, pmax(%rip)
.L92:
	cmpq	$0, pmin_str(%rip)
	jne	.L94
	movq	empty_string(%rip), %rax
	movq	%rax, pmin_str(%rip)
.L94:
	movq	pmin_str(%rip), %rbx
	movq	%rbx, %rdi
	call	strlen
	leaq	12(%rax), %rdi
	call	xmalloc
	movl	$.LC34, %ecx
	movq	%rax, %rdi
	movq	%rax, checkpoint_filename(%rip)
	movq	$-1, %rdx
	xorl	%eax, %eax
	movq	%rbx, %r8
	movl	$1, %esi
	call	__sprintf_chk
	xorl	%edx, %edx
	mov	checkpoint_opt(%rip), %eax
	movl	blocksize_opt(%rip), %edi
	imulq	$1000000, %rax, %rax
	movl	num_threads(%rip), %ecx
	movq	%rax, checkpoint_period(%rip)
	mov	report_opt(%rip), %eax
	imulq	$1000000, %rax, %rax
	movq	%rax, report_period(%rip)
	movl	%edi, %eax
	divl	chunksize_opt(%rip)
	cmpl	%ecx, %eax
	jae	.L95
	xorl	%edx, %edx
	movl	%edi, %eax
	divl	%ecx
	movl	%eax, chunksize_opt(%rip)
	cmpl	$15, %eax
	ja	.L95
	sall	$4, %ecx
	movl	$16, chunksize_opt(%rip)
	movl	%ecx, blocksize_opt(%rip)
.L95:
	movl	priority_opt(%rip), %eax
	testl	%eax, %eax
	je	.L96
	leal	-1(%rax), %edx
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setpriority
.L96:
	mov	qmax(%rip), %eax
	movq	pmax(%rip), %rdx
	imulq	%rax, %rax
	cmpq	%rdx, %rax
	ja	.L244
.L97:
	movl	qmax(%rip), %edi
	call	init_sieve_primes
	call	app_init
	movq	pmax(%rip), %r8
	movq	pmin(%rip), %rcx
	movl	$.LC35, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	checkpoint_filename(%rip), %r12
	movl	$.LC6, %esi
	movq	%r12, %rdi
	call	fopen
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L245
.L100:
	leaq	392(%rsp), %rax
	leaq	416(%rsp), %rcx
	movq	%rax, (%rsp)
	leaq	424(%rsp), %rdx
	xorl	%eax, %eax
	leaq	400(%rsp), %r9
	leaq	408(%rsp), %r8
	movl	$.LC37, %esi
	movq	%rbp, %rdi
	call	fscanf
	cmpl	$5, %eax
	je	.L246
.L103:
	movq	%rbp, %rdi
	call	fclose
.L104:
	movq	%r12, %rcx
	movl	$.LC39, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
.L227:
	movq	pmin(%rip), %rax
.L102:
	movq	%rax, %rdi
	movl	blocks_opt(%rip), %r9d
	orq	$1, %rdi
	movl	blocksize_opt(%rip), %r8d
	movq	%rdi, pstart(%rip)
	movl	chunksize_opt(%rip), %ecx
	movl	qmax(%rip), %edx
	movq	pmax(%rip), %rsi
	call	create_sieve
	movl	$handle_signal, %esi
	movq	%rax, sv(%rip)
	movl	$2, %edi
	call	signal
	movq	%rax, old_sigint_handler(%rip)
	decq	%rax
	jne	.L105
	movl	$1, %esi
	movl	$2, %edi
	call	signal
.L105:
	movl	$handle_signal, %esi
	movl	$15, %edi
	call	signal
	movq	%rax, old_sigterm_handler(%rip)
	decq	%rax
	jne	.L106
	movl	$1, %esi
	movl	$15, %edi
	call	signal
.L106:
	movl	$handle_signal, %esi
	movl	$1, %edi
	call	signal
	movq	%rax, old_sighup_handler(%rip)
	decq	%rax
	jne	.L107
	movl	$1, %esi
	movl	$1, %edi
	call	signal
.L107:
	xorl	%esi, %esi
	movl	$exiting_mutex, %edi
	call	pthread_mutex_init
	xorl	%esi, %esi
	movl	$exiting_cond, %edi
	call	pthread_cond_init
	xorl	%edx, %edx
	xorl	%esi, %esi
	movl	$checkpoint_semaphoreA, %edi
	call	sem_init
	xorl	%edx, %edx
	xorl	%esi, %esi
	movl	$checkpoint_semaphoreB, %edi
	call	sem_init
	xorl	%edi, %edi
	call	time
	movq	%rax, sieve_start_date(%rip)
	call	elapsed_usec
	movq	%rax, sieve_start_time(%rip)
	call	processor_usec
	movl	$exiting_mutex, %edi
	movq	%rax, sieve_start_processor_time(%rip)
	call	pthread_mutex_lock
	movl	num_threads(%rip), %ebp
	testl	%ebp, %ebp
	je	.L108
	leaq	112(%rsp), %rbp
	xorl	%ebx, %ebx
	jmp	.L110
	.p2align 4,,10
	.p2align 3
.L109:
	incq	%rbx
	addq	$8, %rbp
	mov	num_threads(%rip), %eax
	cmpq	%rbx, %rax
	jle	.L108
.L110:
	xorl	%esi, %esi
	movq	%rbx, %rcx
	movl	$thread_fun, %edx
	movq	%rbp, %rdi
	call	pthread_create
	testl	%eax, %eax
	je	.L109
	movl	$.LC40, %edi
	call	perror
	jmp	.L233
.L246:
	movq	424(%rsp), %rdx
	cmpq	pmin(%rip), %rdx
	jne	.L103
	movq	416(%rsp), %rax
	cmpq	%rax, %rdx
	jae	.L103
	cmpq	pmax(%rip), %rax
	jae	.L103
	movq	%rbp, %rdi
	call	app_read_checkpoint
	movq	%rbp, %rdi
	movl	%eax, %ebx
	call	fclose
	testl	%ebx, %ebx
	je	.L104
	movq	416(%rsp), %rcx
	movq	%rcx, %rax
	addq	424(%rsp), %rax
	addq	408(%rsp), %rax
	addq	400(%rsp), %rax
	cmpq	392(%rsp), %rax
	jne	.L104
	movq	%r12, %r8
	movl	$.LC38, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	408(%rsp), %rax
	movq	%rax, cand_count(%rip)
	movq	400(%rsp), %rax
	movq	%rax, cand_sum(%rip)
	movq	416(%rsp), %rax
	jmp	.L102
.L108:
	movq	sieve_start_time(%rip), %rdx
	movq	pstart(%rip), %rax
	movq	%rdx, last_checkpoint_time(%rip)
	movq	%rax, last_checkpoint_progress(%rip)
	movq	%rdx, last_report_time(%rip)
	movq	sieve_start_processor_time(%rip), %rax
	movq	%rax, last_report_processor_time(%rip)
	call	processor_cycles
	movq	%rax, last_report_processor_cycles(%rip)
	movq	pstart(%rip), %rax
	movq	%rax, last_report_progress(%rip)
.L111:
	movzbl	stopping(%rip), %eax
	testb	%al, %al
	jne	.L150
	call	elapsed_usec
	movq	%rax, %r14
	call	processor_usec
	movq	%rax, 48(%rsp)
	call	processor_cycles
	movq	report_period(%rip), %r12
	movq	%rax, 56(%rsp)
	addq	last_report_time(%rip), %r12
	cmpq	%r12, %r14
	jae	.L247
.L112:
	movl	checkpoint_opt(%rip), %r9d
	testl	%r9d, %r9d
	je	.L141
	movq	checkpoint_period(%rip), %rbp
	addq	last_checkpoint_time(%rip), %rbp
	cmpq	%rbp, %r14
	jb	.L142
	movzbl	no_more_checkpoints(%rip), %eax
	testb	%al, %al
	jne	.L142
	movl	num_threads(%rip), %r8d
	movb	$1, checkpointing(%rip)
	testl	%r8d, %r8d
	je	.L143
	xorl	%ebx, %ebx
.L144:
	movl	$checkpoint_semaphoreA, %edi
	incl	%ebx
	call	sem_wait
	cmpl	%ebx, num_threads(%rip)
	ja	.L144
.L143:
	movq	sv(%rip), %rdi
	call	next_chunk
	movl	$.LC51, %esi
	movq	%rax, %rbx
	movq	checkpoint_filename(%rip), %rdi
	call	fopen
	movq	%rax, %rbp
	testq	%rax, %rax
	je	.L145
	movl	num_threads(%rip), %eax
	movq	cand_count(%rip), %r9
	movq	cand_sum(%rip), %rsi
	testl	%eax, %eax
	je	.L146
	decl	%eax
	movl	$thread_data, %edx
	leaq	3(%rax,%rax,2), %rax
	leaq	thread_data(,%rax,8), %rax
.L147:
	addq	(%rdx), %r9
	addq	8(%rdx), %rsi
	addq	$24, %rdx
	cmpq	%rax, %rdx
	jne	.L147
.L146:
	movq	pmin(%rip), %rcx
	movq	%rsi, (%rsp)
	leaq	(%rbx,%rcx), %rax
	movq	%rbx, %r8
	addq	%r9, %rax
	movl	$.LC52, %edx
	addq	%rsi, %rax
	movq	%rbp, %rdi
	movq	%rax, 8(%rsp)
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	%rbp, %rdi
	call	app_write_checkpoint
	movq	%rbp, %rdi
	call	fclose
.L145:
	movq	%r14, %rbp
	movl	num_threads(%rip), %edi
	addq	checkpoint_period(%rip), %rbp
	movq	%rbx, last_checkpoint_progress(%rip)
	movq	%r14, last_checkpoint_time(%rip)
	movb	$0, checkpointing(%rip)
	testl	%edi, %edi
	je	.L142
	xorl	%ebx, %ebx
.L148:
	movl	$checkpoint_semaphoreB, %edi
	incl	%ebx
	call	sem_post
	cmpl	%ebx, num_threads(%rip)
	ja	.L148
.L142:
	movl	checkpoint_opt(%rip), %esi
	testl	%esi, %esi
	je	.L141
	movq	%rbp, %rcx
	cmpq	%r12, %rbp
	jb	.L149
.L141:
	movq	%r12, %rcx
.L149:
	movq	%rcx, %rax
	movabsq	$4835703278458516699, %rdx
	movl	$exiting_mutex, %esi
	mulq	%rdx
	movl	$exiting_cond, %edi
	shrq	$18, %rdx
	movq	%rdx, 368(%rsp)
	imulq	$1000000, %rdx, %rdx
	subq	%rdx, %rcx
	leaq	368(%rsp), %rdx
	imulq	$1000, %rcx, %rax
	movq	%rax, 376(%rsp)
	call	pthread_cond_timedwait
	testl	%eax, %eax
	jne	.L111
.L150:
	movq	old_sigint_handler(%rip), %rsi
	cmpq	$1, %rsi
	je	.L152
	movl	$2, %edi
	call	signal
.L152:
	movq	old_sigterm_handler(%rip), %rsi
	cmpq	$1, %rsi
	je	.L153
	movl	$15, %edi
	call	signal
.L153:
	movq	old_sighup_handler(%rip), %rsi
	cmpq	$1, %rsi
	je	.L154
	movl	$1, %edi
	call	signal
.L154:
	movq	stderr(%rip), %rcx
	movl	$28, %edx
	movl	$1, %esi
	movl	$.LC53, %edi
	call	fwrite
	movl	$exiting_mutex, %edi
	call	pthread_mutex_unlock
	movl	num_threads(%rip), %ecx
	testl	%ecx, %ecx
	je	.L155
	xorl	%ebp, %ebp
	xorl	%ebx, %ebx
	movl	$thread_data+40, %edx
	cmpb	$0, thread_data+16(%rip)
	je	.L208
	jmp	.L157
	.p2align 4,,10
	.p2align 3
.L161:
	movzbl	(%rdx), %eax
	addq	$24, %rdx
	testb	%al, %al
	jne	.L248
.L208:
	incl	%ebp
	cmpl	%ebp, %ecx
	.p2align 4,,2
	.p2align 3
	ja	.L161
	movl	%ecx, %ebp
	xorl	%r13d, %r13d
	jmp	.L164
.L247:
	movq	sv(%rip), %rdi
	call	next_chunk
	movq	%r14, %rdx
	movq	%rax, %r13
	subq	last_report_time(%rip), %rdx
	js	.L113
	cvtsi2sdq	%rdx, %xmm0
	movsd	%xmm0, 104(%rsp)
.L114:
	movq	%r13, %rdx
	subq	last_report_progress(%rip), %rdx
	js	.L115
	cvtsi2sdq	%rdx, %xmm0
.L116:
	divsd	104(%rsp), %xmm0
	movsd	.LC41(%rip), %xmm1
	movsd	%xmm0, 88(%rsp)
	movl	$.LC42, %r15d
	ucomisd	%xmm0, %xmm1
	jbe	.L118
	movsd	88(%rsp), %xmm0
	movl	$.LC44, %r15d
	mulsd	.LC43(%rip), %xmm0
	movsd	%xmm0, 88(%rsp)
.L118:
	movsd	.LC41(%rip), %xmm1
	ucomisd	88(%rsp), %xmm1
	jbe	.L119
	movsd	.LC43(%rip), %xmm0
	movl	$.LC45, %r15d
	mulsd	88(%rsp), %xmm0
	movsd	%xmm0, 88(%rsp)
.L119:
	movabsq	$4636737291354636288, %rbx
	movsd	.LC46(%rip), %xmm1
	movl	$3, 76(%rsp)
	movq	%rbx, 32(%rsp)
	ucomisd	88(%rsp), %xmm1
	ja	.L123
	movabsq	$4636737291354636288, %r11
	movsd	.LC47(%rip), %xmm0
	movq	%r11, 32(%rsp)
	movl	$2, 76(%rsp)
	ucomisd	88(%rsp), %xmm0
	ja	.L123
	xorl	%eax, %eax
	movsd	.LC43(%rip), %xmm1
	ucomisd	88(%rsp), %xmm1
	seta	%al
	movl	%eax, 76(%rsp)
.L123:
	movq	pstart(%rip), %rcx
	movq	%r13, %rdx
	movq	last_report_processor_time(%rip), %r12
	movq	pmin(%rip), %rbx
	movq	pmax(%rip), %rbp
	subq	%rcx, %rdx
	js	.L126
	cvtsi2sdq	%rdx, %xmm1
.L127:
	movq	%rbp, %rdx
	subq	%rcx, %rdx
	js	.L128
	cvtsi2sdq	%rdx, %xmm0
.L129:
	divsd	%xmm0, %xmm1
	movb	$0, 576(%rsp)
	xorpd	%xmm0, %xmm0
	movsd	%xmm1, 80(%rsp)
	ucomisd	%xmm0, %xmm1
	jbe	.L130
	cvtsi2sdq	sieve_start_date(%rip), %xmm1
	xorl	%edi, %edi
	movsd	%xmm1, 96(%rsp)
	call	time
	leaq	392(%rsp), %rdi
	subq	sieve_start_date(%rip), %rax
	cvtsi2sdq	%rax, %xmm0
	divsd	80(%rsp), %xmm0
	addsd	96(%rsp), %xmm0
	cvttsd2siq	%xmm0, %rax
	movsd	%xmm0, 96(%rsp)
	movq	%rax, 392(%rsp)
	call	localtime
	movq	%rax, %rcx
	testq	%rax, %rax
	je	.L132
	movl	$.LC49, %edx
	movl	$32, %esi
	leaq	576(%rsp), %rdi
	call	strftime
	testq	%rax, %rax
	jne	.L130
.L132:
	movb	$0, 576(%rsp)
.L130:
	movq	%r13, %rdx
	subq	%rbx, %rdx
	js	.L133
	cvtsi2sdq	%rdx, %xmm0
.L134:
	movq	%rbp, %rdx
	subq	%rbx, %rdx
	js	.L135
	cvtsi2sdq	%rdx, %xmm2
.L136:
	divsd	%xmm2, %xmm0
	movq	48(%rsp), %rdx
	movapd	%xmm0, %xmm2
	subq	%r12, %rdx
	mulsd	32(%rsp), %xmm2
	js	.L137
	cvtsi2sdq	%rdx, %xmm1
.L138:
	leaq	576(%rsp), %r9
	divsd	104(%rsp), %xmm1
	movq	%r15, %r8
	movsd	88(%rsp), %xmm0
	movl	76(%rsp), %ecx
	movq	%r13, %rdx
	movl	$.LC50, %esi
	movl	$1, %edi
	movl	$3, %eax
	call	__printf_chk
	movl	quiet_opt(%rip), %r10d
	testl	%r10d, %r10d
	jne	.L249
	movq	stdout(%rip), %rsi
	movl	$10, %edi
	call	_IO_putc
.L140:
	movq	%r14, %r12
	movq	48(%rsp), %rax
	movq	56(%rsp), %rdx
	movq	%r14, last_report_time(%rip)
	addq	report_period(%rip), %r12
	movq	%rax, last_report_processor_time(%rip)
	movq	%rdx, last_report_processor_cycles(%rip)
	movq	%r13, last_report_progress(%rip)
	jmp	.L112
.L128:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L129
.L126:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L127
.L249:
	movq	stdout(%rip), %rsi
	movl	$13, %edi
	call	_IO_putc
	movq	stdout(%rip), %rdi
	call	fflush
	jmp	.L140
.L137:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L138
.L135:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L136
.L133:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L134
.L115:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L116
.L113:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	movsd	%xmm1, 104(%rsp)
	jmp	.L114
.L245:
	movl	$.LC6, %esi
	movl	$.LC36, %edi
	movl	$.LC36, %r12d
	call	fopen
	movq	%rax, %rbp
	testq	%rax, %rax
	jne	.L100
	jmp	.L227
.L244:
	testq	%rdx, %rdx
	.p2align 4,,5
	.p2align 3
	js	.L98
	cvtsi2sdq	%rdx, %xmm0
.L99:
	sqrtsd	%xmm0, %xmm0
	cvttsd2siq	%xmm0, %rax
	movl	%eax, qmax(%rip)
	jmp	.L97
.L242:
	movl	$.LC20, %edi
	call	puts
	movl	$.LC21, %edi
	call	puts
	movl	$.LC22, %edi
	call	puts
	movl	$32768, %edx
	movl	$.LC23, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$128, %edx
	movl	$.LC24, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$2, %edx
	movl	$.LC25, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$300, %edx
	movl	$.LC26, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$.LC27, %edi
	call	puts
	movl	$60, %edx
	movl	$.LC28, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	movl	$.LC29, %edi
	call	puts
	movl	$.LC30, %edi
	call	puts
	movl	$.LC31, %edi
	call	puts
	call	app_help
	xorl	%edi, %edi
	call	exit
.L98:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L99
.L248:
	movl	%ebp, %ebx
.L157:
	movslq	%ebx,%rax
	leaq	432(%rsp), %rsi
	movq	112(%rsp,%rax,8), %rdi
	xorl	%r13d, %r13d
	call	pthread_join
	movq	432(%rsp), %rax
	testq	%rax, %rax
	je	.L160
	movq	%rax, %r8
	movl	%ebx, %ecx
	movl	$.LC54, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movb	$1, %r13b
	call	__fprintf_chk
	movb	$1, stopping(%rip)
.L160:
	movl	num_threads(%rip), %ecx
	testl	%ecx, %ecx
	je	.L163
.L164:
	xorl	%ebx, %ebx
	leaq	432(%rsp), %r12
.L162:
	cmpl	%ebp, %ebx
	je	.L165
	movslq	%ebx,%rax
	movq	%r12, %rsi
	movq	112(%rsp,%rax,8), %rdi
	call	pthread_join
	movq	432(%rsp), %rax
	testq	%rax, %rax
	je	.L165
	movq	%rax, %r8
	movl	%ebx, %ecx
	movl	$.LC54, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	movl	$1, %r13d
	call	__fprintf_chk
.L165:
	incl	%ebx
	cmpl	%ebx, num_threads(%rip)
	ja	.L162
.L163:
	movl	$exiting_cond, %edi
	call	pthread_cond_destroy
	movl	$exiting_mutex, %edi
	call	pthread_mutex_destroy
	movl	$checkpoint_semaphoreA, %edi
	call	sem_destroy
	movl	$checkpoint_semaphoreB, %edi
	call	sem_destroy
	testl	%r13d, %r13d
	je	.L199
	movq	last_checkpoint_progress(%rip), %r12
.L167:
	movq	pmax(%rip), %rax
	cmpq	%rax, %r12
	jb	.L170
	movq	%rax, %r8
	movq	stderr(%rip), %rdi
	movq	pmin(%rip), %rcx
	movl	$.LC55, %edx
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	checkpoint_filename(%rip), %rdi
	call	remove
.L171:
	call	app_fini
	movq	sv(%rip), %rdi
	call	destroy_sieve
	call	free_sieve_primes
	testl	%r13d, %r13d
	jne	.L172
	movl	num_threads(%rip), %edx
	testl	%edx, %edx
	je	.L173
	movl	$thread_data, %edx
	xorl	%ecx, %ecx
.L174:
	movq	(%rdx), %rax
	incl	%ecx
	addq	%rax, cand_count(%rip)
	movq	8(%rdx), %rax
	addq	$24, %rdx
	addq	%rax, cand_sum(%rip)
	cmpl	%ecx, num_threads(%rip)
	ja	.L174
.L173:
	movq	cand_sum(%rip), %r8
	movq	cand_count(%rip), %rcx
	movl	$.LC57, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
.L172:
	call	elapsed_usec
	movq	%rax, %rbp
	call	processor_usec
	movq	sieve_start_time(%rip), %rcx
	movq	%rbp, %rdx
	movq	%rax, %rbx
	subq	%rcx, %rdx
	js	.L175
	cvtsi2sdq	%rdx, %xmm2
.L176:
	movq	%r12, %rdx
	movq	program_start_time(%rip), %rsi
	subq	pstart(%rip), %rdx
	js	.L177
	cvtsi2sdq	%rdx, %xmm3
.L178:
	divsd	%xmm2, %xmm3
	movsd	.LC58(%rip), %xmm4
	movq	%rcx, %rdx
	mulsd	%xmm4, %xmm3
	divsd	%xmm4, %xmm2
	subq	%rsi, %rdx
	js	.L179
	cvtsi2sdq	%rdx, %xmm1
.L180:
	movq	%rbp, %rdx
	divsd	%xmm4, %xmm1
	subq	%rsi, %rdx
	js	.L181
	cvtsi2sdq	%rdx, %xmm0
.L182:
	divsd	%xmm4, %xmm0
	movl	$.LC59, %edx
	movsd	%xmm4, 16(%rsp)
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$4, %eax
	call	__fprintf_chk
	movq	sieve_start_processor_time(%rip), %rcx
	movq	%rbx, %rdx
	movsd	16(%rsp), %xmm4
	subq	%rcx, %rdx
	js	.L183
	cvtsi2sdq	%rdx, %xmm2
.L184:
	movq	%r12, %rdx
	subq	pstart(%rip), %rdx
	js	.L185
	cvtsi2sdq	%rdx, %xmm3
.L186:
	divsd	%xmm2, %xmm3
	testq	%rcx, %rcx
	mulsd	%xmm4, %xmm3
	divsd	%xmm4, %xmm2
	js	.L187
	cvtsi2sdq	%rcx, %xmm1
.L188:
	divsd	%xmm4, %xmm1
	testq	%rbx, %rbx
	js	.L189
	cvtsi2sdq	%rbx, %xmm0
.L190:
	movl	$.LC60, %edx
	movl	$1, %esi
	divsd	%xmm4, %xmm0
	movq	stderr(%rip), %rdi
	movl	$4, %eax
	call	__fprintf_chk
	movq	sieve_start_processor_time(%rip), %rcx
	movq	%rbx, %rdx
	movq	sieve_start_time(%rip), %rsi
	subq	%rcx, %rdx
	js	.L191
	cvtsi2sdq	%rdx, %xmm0
.L192:
	movq	%rbp, %rdx
	subq	%rsi, %rdx
	js	.L193
	cvtsi2sdq	%rdx, %xmm1
.L194:
	divsd	%xmm1, %xmm0
	testq	%rcx, %rcx
	movapd	%xmm0, %xmm1
	js	.L195
	cvtsi2sdq	%rcx, %xmm0
.L196:
	movq	%rsi, %rdx
	subq	program_start_time(%rip), %rdx
	js	.L197
	cvtsi2sdq	%rdx, %xmm2
.L198:
	movl	$.LC61, %edx
	divsd	%xmm2, %xmm0
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	movl	$2, %eax
	call	__fprintf_chk
	movl	%r13d, %eax
	movq	616(%rsp), %rdx
	xorq	%fs:40, %rdx
	jne	.L250
	addq	$632, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L155:
	movl	$exiting_cond, %edi
	xorl	%r13d, %r13d
	call	pthread_cond_destroy
	movl	$exiting_mutex, %edi
	call	pthread_mutex_destroy
	movl	$checkpoint_semaphoreA, %edi
	call	sem_destroy
	movl	$checkpoint_semaphoreB, %edi
	call	sem_destroy
.L199:
	movq	sv(%rip), %rdi
	call	next_chunk
	movl	$.LC51, %esi
	movq	%rax, %r12
	movq	checkpoint_filename(%rip), %rdi
	call	fopen
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L167
	movl	num_threads(%rip), %eax
	movq	cand_count(%rip), %r9
	movq	cand_sum(%rip), %rsi
	testl	%eax, %eax
	je	.L168
	decl	%eax
	movl	$thread_data, %edx
	leaq	3(%rax,%rax,2), %rax
	leaq	thread_data(,%rax,8), %rax
.L169:
	addq	(%rdx), %r9
	addq	8(%rdx), %rsi
	addq	$24, %rdx
	cmpq	%rax, %rdx
	jne	.L169
.L168:
	movq	pmin(%rip), %rcx
	movq	%rsi, (%rsp)
	leaq	(%r12,%rcx), %rax
	movq	%r12, %r8
	addq	%r9, %rax
	movl	$.LC52, %edx
	addq	%rsi, %rax
	movq	%rbx, %rdi
	movq	%rax, 8(%rsp)
	movl	$1, %esi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	%rbx, %rdi
	call	app_write_checkpoint
	movq	%rbx, %rdi
	call	fclose
	jmp	.L167
	.p2align 4,,10
	.p2align 3
.L250:
	.p2align 4,,6
	.p2align 3
	call	__stack_chk_fail
.L197:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L198
.L195:
	movq	%rcx, %rax
	andl	$1, %ecx
	shrq	%rax
	orq	%rcx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L196
.L193:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L194
.L191:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L192
.L189:
	movq	%rbx, %rax
	movq	%rbx, %rdx
	shrq	%rax
	andl	$1, %edx
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L190
.L187:
	movq	%rcx, %rax
	andl	$1, %ecx
	shrq	%rax
	orq	%rcx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L188
.L185:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm3
	addsd	%xmm3, %xmm3
	jmp	.L186
.L183:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L184
.L181:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L182
.L179:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm1
	addsd	%xmm1, %xmm1
	jmp	.L180
.L177:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm3
	addsd	%xmm3, %xmm3
	jmp	.L178
.L175:
	movq	%rdx, %rax
	andl	$1, %edx
	shrq	%rax
	orq	%rdx, %rax
	cvtsi2sdq	%rax, %xmm2
	addsd	%xmm2, %xmm2
	jmp	.L176
.L170:
	movq	%r12, %r8
	movq	pmin(%rip), %rcx
	movl	$.LC56, %edx
	movl	$1, %esi
	movq	stderr(%rip), %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	jmp	.L171
.LFE89:
	.size	main, .-main
.globl num_threads
	.data
	.align 4
	.type	num_threads, @object
	.size	num_threads, 4
num_threads:
	.long	1
.globl pmin
	.bss
	.align 8
	.type	pmin, @object
	.size	pmin, 8
pmin:
	.zero	8
.globl pmax
	.align 8
	.type	pmax, @object
	.size	pmax, 8
pmax:
	.zero	8
.globl quiet_opt
	.align 4
	.type	quiet_opt, @object
	.size	quiet_opt, 4
quiet_opt:
	.zero	4
	.local	pmin_str
	.comm	pmin_str,8,8
	.section	.rodata
	.align 8
	.type	empty_string, @object
	.size	empty_string, 8
empty_string:
	.quad	.LC45
	.local	checkpoint_filename
	.comm	checkpoint_filename,8,8
	.data
	.align 4
	.type	checkpoint_opt, @object
	.size	checkpoint_opt, 4
checkpoint_opt:
	.long	300
	.align 4
	.type	report_opt, @object
	.size	report_opt, 4
report_opt:
	.long	60
	.align 4
	.type	blocksize_opt, @object
	.size	blocksize_opt, 4
blocksize_opt:
	.long	32768
	.align 4
	.type	chunksize_opt, @object
	.size	chunksize_opt, 4
chunksize_opt:
	.long	128
	.local	priority_opt
	.comm	priority_opt,4,4
	.align 4
	.type	qmax, @object
	.size	qmax, 4
qmax:
	.long	-2147483648
	.align 4
	.type	blocks_opt, @object
	.size	blocks_opt, 4
blocks_opt:
	.long	2
	.local	no_more_checkpoints
	.comm	no_more_checkpoints,1,1
	.local	checkpointing
	.comm	checkpointing,1,1
	.local	stopping
	.comm	stopping,1,1
	.local	cand_count
	.comm	cand_count,8,8
	.local	cand_sum
	.comm	cand_sum,8,8
	.section	.rodata.str1.1
.LC62:
	.string	"pmin"
.LC63:
	.string	"pmax"
.LC64:
	.string	"qmax"
.LC65:
	.string	"blocksize"
.LC66:
	.string	"chunksize"
.LC67:
	.string	"blocks"
.LC68:
	.string	"checkpoint"
.LC69:
	.string	"report"
.LC70:
	.string	"threads"
.LC71:
	.string	"priority"
.LC72:
	.string	"help"
.LC73:
	.string	"quiet"
.LC74:
	.string	"kmin"
.LC75:
	.string	"kmax"
.LC76:
	.string	"nmin"
.LC77:
	.string	"nmax"
.LC78:
	.string	"input"
.LC79:
	.string	"factors"
.LC80:
	.string	"bitsatatime"
.LC81:
	.string	"alt"
.LC82:
	.string	"sse2"
	.section	.rodata
	.align 32
	.type	long_opts, @object
	.size	long_opts, 704
long_opts:
	.quad	.LC62
	.long	1
	.zero	4
	.quad	0
	.long	112
	.zero	4
	.quad	.LC63
	.long	1
	.zero	4
	.quad	0
	.long	80
	.zero	4
	.quad	.LC64
	.long	1
	.zero	4
	.quad	0
	.long	81
	.zero	4
	.quad	.LC65
	.long	1
	.zero	4
	.quad	0
	.long	66
	.zero	4
	.quad	.LC66
	.long	1
	.zero	4
	.quad	0
	.long	67
	.zero	4
	.quad	.LC67
	.long	1
	.zero	4
	.quad	0
	.long	256
	.zero	4
	.quad	.LC68
	.long	1
	.zero	4
	.quad	0
	.long	99
	.zero	4
	.quad	.LC69
	.long	1
	.zero	4
	.quad	0
	.long	114
	.zero	4
	.quad	.LC70
	.long	1
	.zero	4
	.quad	0
	.long	116
	.zero	4
	.quad	.LC71
	.long	1
	.zero	4
	.quad	0
	.long	122
	.zero	4
	.quad	.LC72
	.long	0
	.zero	4
	.quad	0
	.long	104
	.zero	4
	.quad	.LC73
	.long	0
	.zero	4
	.quad	0
	.long	113
	.zero	4
	.quad	.LC74
	.long	1
	.zero	4
	.quad	0
	.long	107
	.zero	4
	.quad	.LC75
	.long	1
	.zero	4
	.quad	0
	.long	75
	.zero	4
	.quad	.LC76
	.long	1
	.zero	4
	.quad	0
	.long	110
	.zero	4
	.quad	.LC77
	.long	1
	.zero	4
	.quad	0
	.long	78
	.zero	4
	.quad	.LC78
	.long	1
	.zero	4
	.quad	0
	.long	105
	.zero	4
	.quad	.LC79
	.long	1
	.zero	4
	.quad	0
	.long	102
	.zero	4
	.quad	.LC80
	.long	1
	.zero	4
	.quad	0
	.long	98
	.zero	4
	.quad	.LC81
	.long	1
	.zero	4
	.quad	0
	.long	97
	.zero	4
	.quad	.LC82
	.long	1
	.zero	4
	.quad	0
	.long	115
	.zero	4
	.quad	0
	.long	0
	.zero	4
	.quad	0
	.long	0
	.zero	4
	.local	help_opt
	.comm	help_opt,4,4
	.section	.rodata.str1.8
	.align 8
.LC83:
	.string	"p:P:Q:B:C:c:r:t:z:hk:K:n:N:i:f:qa:s:b:"
	.section	.rodata
	.align 8
	.type	short_opts, @object
	.size	short_opts, 8
short_opts:
	.quad	.LC83
	.local	pstart
	.comm	pstart,8,8
	.local	sv
	.comm	sv,8,8
	.local	report_period
	.comm	report_period,8,8
	.local	checkpoint_period
	.comm	checkpoint_period,8,8
	.local	program_start_time
	.comm	program_start_time,8,8
	.local	sieve_start_date
	.comm	sieve_start_date,8,8
	.local	sieve_start_time
	.comm	sieve_start_time,8,8
	.local	sieve_start_processor_time
	.comm	sieve_start_processor_time,8,8
	.local	last_checkpoint_time
	.comm	last_checkpoint_time,8,8
	.local	last_checkpoint_progress
	.comm	last_checkpoint_progress,8,8
	.local	last_report_time
	.comm	last_report_time,8,8
	.local	last_report_processor_time
	.comm	last_report_processor_time,8,8
	.local	last_report_processor_cycles
	.comm	last_report_processor_cycles,8,8
	.local	last_report_progress
	.comm	last_report_progress,8,8
	.local	thread_data
	.comm	thread_data,768,32
	.local	exiting_mutex
	.comm	exiting_mutex,40,32
	.local	exiting_cond
	.comm	exiting_cond,48,32
	.local	checkpoint_semaphoreA
	.comm	checkpoint_semaphoreA,32,32
	.local	checkpoint_semaphoreB
	.comm	checkpoint_semaphoreB,32,32
	.local	old_sigint_handler
	.comm	old_sigint_handler,8,8
	.local	old_sigterm_handler
	.comm	old_sigterm_handler,8,8
	.local	old_sighup_handler
	.comm	old_sighup_handler,8,8
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC41:
	.long	0
	.long	1072693248
	.align 8
.LC43:
	.long	0
	.long	1083129856
	.align 8
.LC46:
	.long	0
	.long	1076101120
	.align 8
.LC47:
	.long	0
	.long	1079574528
	.align 8
.LC58:
	.long	0
	.long	1093567616
	.weak	__pthread_unwind_next
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
	.long	.LFB77
	.long	.LFE77-.LFB77
	.uleb128 0x0
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB84
	.long	.LFE84-.LFB84
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB84
	.byte	0xe
	.uleb128 0x10
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB87
	.long	.LFE87-.LFB87
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI1-.LFB87
	.byte	0xe
	.uleb128 0x10
	.byte	0x83
	.uleb128 0x2
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB88
	.long	.LFE88-.LFB88
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI2-.LFB88
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.long	.LCFI3-.LCFI2
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI4-.LCFI3
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI5-.LCFI4
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI6-.LCFI5
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI7-.LCFI6
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI8-.LCFI7
	.byte	0xe
	.uleb128 0x130
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
.LEFDE7:
.LSFDE9:
	.long	.LEFDE9-.LASFDE9
.LASFDE9:
	.long	.LASFDE9-.Lframe1
	.long	.LFB89
	.long	.LFE89-.LFB89
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI9-.LFB89
	.byte	0xe
	.uleb128 0x10
	.byte	0x8f
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI10-.LCFI9
	.byte	0xe
	.uleb128 0x18
	.byte	0x4
	.long	.LCFI11-.LCFI10
	.byte	0xe
	.uleb128 0x20
	.byte	0x4
	.long	.LCFI12-.LCFI11
	.byte	0xe
	.uleb128 0x28
	.byte	0x4
	.long	.LCFI13-.LCFI12
	.byte	0xe
	.uleb128 0x30
	.byte	0x4
	.long	.LCFI14-.LCFI13
	.byte	0xe
	.uleb128 0x38
	.byte	0x4
	.long	.LCFI15-.LCFI14
	.byte	0xe
	.uleb128 0x2b0
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
	.align 8
.LEFDE9:
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
