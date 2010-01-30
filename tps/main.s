	.file	"main.c"
	.text
	.p2align 4,,15
	.type	handle_signal, @function
handle_signal:
	movl	4(%esp), %ecx
	cmpl	$15, %ecx
	ja	.L4
	movl	$1, %eax
	sall	%cl, %eax
	testl	$32774, %eax
	je	.L4
	movb	$1, stopping
.L4:
	rep
	ret
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
	subl	$44, %esp
	cmpl	$99, %eax
	movl	%ebx, 32(%esp)
	movl	%esi, 36(%esp)
	movl	%edi, 40(%esp)
	movl	%edx, %ebx
	je	.L13
	jle	.L30
	cmpl	$114, %eax
	je	.L16
	.p2align 4,,9
	.p2align 3
	jg	.L22
	cmpl	$104, %eax
	.p2align 4,,7
	.p2align 3
	je	.L14
	cmpl	$112, %eax
	.p2align 4,,7
	.p2align 3
	je	.L31
.L7:
	movl	%ecx, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	%eax, (%esp)
	call	app_parse_option
	movl	%eax, %edx
	.p2align 4,,10
	.p2align 3
.L23:
	movl	%edx, %eax
	movl	32(%esp), %ebx
	movl	36(%esp), %esi
	movl	40(%esp), %edi
	addl	$44, %esp
	ret
	.p2align 4,,10
	.p2align 3
.L30:
	cmpl	$67, %eax
	je	.L10
	jle	.L32
	cmpl	$80, %eax
	.p2align 4,,7
	.p2align 3
	je	.L11
	cmpl	$81, %eax
	.p2align 4,,7
	.p2align 3
	jne	.L7
	movl	%edx, 4(%esp)
	movl	$-2147483648, 12(%esp)
	movl	$3, 8(%esp)
	movl	$qmax, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L22:
	cmpl	$122, %eax
	je	.L18
	cmpl	$256, %eax
	.p2align 4,,5
	.p2align 3
	je	.L19
	cmpl	$116, %eax
	.p2align 4,,5
	.p2align 3
	jne	.L7
	movl	%edx, 4(%esp)
	movl	$32, 12(%esp)
	movl	$1, 8(%esp)
	movl	$num_threads, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L32:
	movl	$-3, %edx
	cmpl	$63, %eax
	je	.L23
	cmpl	$66, %eax
	.p2align 4,,3
	.p2align 3
	jne	.L7
	movl	$134217728, 12(%esp)
	movl	$1024, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$blocksize_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L11:
	movl	%edx, 4(%esp)
	movl	$0, 16(%esp)
	movl	$1073741824, 20(%esp)
	movl	$4, 8(%esp)
	movl	$0, 12(%esp)
	movl	$pmax, (%esp)
	call	parse_uint64
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L16:
	movl	%edx, 4(%esp)
	movl	$-1, 12(%esp)
	movl	$0, 8(%esp)
	movl	$report_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L19:
	movl	%edx, 4(%esp)
	movl	$4, 12(%esp)
	movl	$2, 8(%esp)
	movl	$blocks_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L18:
	movl	$.LC0, %edi
	movl	$5, %ecx
	movl	%edx, %esi
	repz cmpsb
	je	.L33
	cmpb	$108, (%edx)
	je	.L34
.L26:
	movl	$.LC1, %edi
	movl	$7, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L27
	movl	$0, priority_opt
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L25:
	incl	priority_opt
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L31:
	movl	%edx, 4(%esp)
	movl	$-1, 16(%esp)
	movl	$1073741823, 20(%esp)
	movl	$3, 8(%esp)
	movl	$0, 12(%esp)
	movl	$pmin, (%esp)
	call	parse_uint64
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L14:
	movl	$1, help_opt
	xorl	%edx, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L10:
	movl	%edx, 4(%esp)
	movl	$131072, 12(%esp)
	movl	$16, 8(%esp)
	movl	$chunksize_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L13:
	movl	%edx, 4(%esp)
	movl	$-1, 12(%esp)
	movl	$0, 8(%esp)
	movl	$checkpoint_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L33:
	movl	$19, priority_opt
	xorl	%edx, %edx
	jmp	.L25
	.p2align 4,,10
	.p2align 3
.L34:
	cmpb	$111, 1(%edx)
	jne	.L26
	cmpb	$119, 2(%edx)
	jne	.L26
	cmpb	$0, 3(%edx)
	.p2align 4,,5
	.p2align 3
	jne	.L26
	movl	$10, priority_opt
	xorl	%edx, %edx
	jmp	.L25
.L27:
	movl	$.LC2, %edi
	movl	$5, %ecx
	movl	%ebx, %esi
	repz cmpsb
	jne	.L28
	movl	$-1, priority_opt
	xorl	%edx, %edx
	jmp	.L25
.L28:
	movl	$19, 12(%esp)
	movl	$0, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$priority_opt, (%esp)
	call	parse_uint
	movl	%eax, %edx
	jmp	.L25
	.size	parse_option, .-parse_option
	.p2align 4,,15
	.type	thread_cleanup, @function
thread_cleanup:
	pushl	%ebx
	subl	$8, %esp
	movl	16(%esp), %ebx
	movl	$exiting_mutex, (%esp)
	leal	(%ebx,%ebx,4), %ebx
	call	pthread_mutex_lock
	movb	$1, thread_data+16(,%ebx,4)
	movl	$exiting_cond, (%esp)
	call	pthread_cond_signal
	movl	$exiting_mutex, 16(%esp)
	addl	$8, %esp
	popl	%ebx
	jmp	pthread_mutex_unlock
	.size	thread_cleanup, .-thread_cleanup
	.section	.rodata.str1.1
.LC3:
	.string	"Thread %d starting\n"
.LC4:
	.string	"Thread %d completed\n"
.LC5:
	.string	"Thread %d interrupted\n"
	.text
	.p2align 4,,15
	.type	thread_fun, @function
thread_fun:
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$188, %esp
	leal	128(%esp), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	__sigsetjmp
	testl	%eax, %eax
	jne	.L57
	movl	208(%esp), %edx
	leal	128(%esp), %eax
	movl	%edx, 28(%esp)
	xorl	%esi, %esi
	call	__pthread_register_cancel
	movl	208(%esp), %ecx
	movl	stderr, %eax
	movl	%ecx, 12(%esp)
	movl	$.LC3, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	sv, %eax
	movl	$0, 172(%esp)
	movl	108(%eax), %eax
	movl	%eax, 60(%esp)
	movl	208(%esp), %eax
	movl	%eax, (%esp)
	call	app_thread_init
	movl	208(%esp), %edx
	movl	$0, 32(%esp)
	leal	(%edx,%edx,4), %edx
	movl	$0, 36(%esp)
	movl	$0, 40(%esp)
	movl	$0, 44(%esp)
	movl	$0, 48(%esp)
	movl	$0, 52(%esp)
	movl	%edx, 24(%esp)
	.p2align 4,,10
	.p2align 3
.L39:
	movzbl	stopping, %eax
	testb	%al, %al
	jne	.L40
	leal	172(%esp), %eax
	movl	%eax, 4(%esp)
	movl	sv, %eax
	movl	%eax, (%esp)
	call	get_chunk
	movl	%eax, 32(%esp)
	movl	%edx, 36(%esp)
	cmpl	pmax+4, %edx
	jbe	.L58
.L40:
	leal	80(%esp), %eax
	movl	208(%esp), %edx
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	movl	%esi, 8(%esp)
	call	app_thread_fun1
	movl	208(%esp), %ecx
	movl	40(%esp), %edx
	leal	(%ecx,%ecx,4), %eax
	movl	44(%esp), %ecx
	movl	%edx, thread_data(,%eax,4)
	movl	%ecx, thread_data+4(,%eax,4)
	movl	48(%esp), %edx
	movl	52(%esp), %ecx
	movl	%edx, thread_data+8(,%eax,4)
	movl	%ecx, thread_data+12(,%eax,4)
	movl	208(%esp), %ecx
	movl	%ecx, (%esp)
	call	app_thread_fini
	movl	36(%esp), %eax
	cmpl	pmax+4, %eax
	jb	.L50
	jbe	.L59
.L55:
	movl	208(%esp), %ecx
	movl	stderr, %eax
	movl	%ecx, 12(%esp)
	movl	$.LC4, 8(%esp)
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	__fprintf_chk
.L52:
	movl	$checkpoint_semaphoreA, (%esp)
	movb	$1, no_more_checkpoints
	call	sem_post
	leal	128(%esp), %eax
	call	__pthread_unregister_cancel
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_lock
	movl	208(%esp), %edx
	movl	$exiting_cond, (%esp)
	leal	(%edx,%edx,4), %eax
	movb	$1, thread_data+16(,%eax,4)
	call	pthread_cond_signal
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_unlock
	addl	$188, %esp
	xorl	%eax, %eax
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
.L58:
	jb	.L54
	cmpl	pmax, %eax
	jae	.L40
.L54:
	movl	60(%esp), %ebx
	testl	%ebx, %ebx
	je	.L42
	movl	$0, 64(%esp)
	.p2align 4,,10
	.p2align 3
.L46:
	movl	172(%esp), %eax
	movl	64(%esp), %ecx
	movl	(%eax,%ecx,4), %ebx
	testl	%ebx, %ebx
	je	.L43
	sall	$5, %ecx
	xorl	%eax, %eax
	movl	%ecx, 68(%esp)
	movl	%ecx, %edx
	jmp	.L45
	.p2align 4,,10
	.p2align 3
.L44:
	movl	%ebx, %eax
	movl	%edi, %ecx
	shrl	%cl, %eax
	movl	%eax, %ebx
	shrl	%ebx
	je	.L43
.L60:
	leal	1(%ebp), %eax
	movl	68(%esp), %edx
.L45:
	bsfl	%ebx, %edi
	addl	$1, 40(%esp)
	leal	(%eax,%edi), %ebp
	adcl	$0, 44(%esp)
	leal	(%ebp,%edx), %eax
	xorl	%edx, %edx
	shldl	$1, %eax, %edx
	addl	%eax, %eax
	addl	32(%esp), %eax
	adcl	36(%esp), %edx
	movl	%eax, 80(%esp,%esi,8)
	addl	%eax, 48(%esp)
	movl	%edx, 84(%esp,%esi,8)
	adcl	%edx, 52(%esp)
	incl	%esi
	cmpl	$6, %esi
	jne	.L44
	leal	80(%esp), %ecx
	movl	28(%esp), %eax
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	xorw	%si, %si
	call	app_thread_fun
	movl	%ebx, %eax
	movl	%edi, %ecx
	shrl	%cl, %eax
	movl	%eax, %ebx
	shrl	%ebx
	jne	.L60
	.p2align 4,,10
	.p2align 3
.L43:
	incl	64(%esp)
	movl	64(%esp), %eax
	cmpl	%eax, 60(%esp)
	ja	.L46
.L42:
	movl	40(%esp), %edx
	movl	32(%esp), %eax
	movl	44(%esp), %ecx
	movl	%edx, 72(%esp)
	movl	%eax, 4(%esp)
	movl	36(%esp), %edx
	movl	sv, %eax
	movl	%ecx, 76(%esp)
	movl	%eax, (%esp)
	movl	48(%esp), %edi
	movl	52(%esp), %ebp
	movl	%edx, 8(%esp)
	call	free_chunk
	movzbl	checkpointing, %eax
	testb	%al, %al
	jne	.L61
.L48:
	movl	72(%esp), %eax
	movl	76(%esp), %edx
	movl	%eax, 40(%esp)
	movl	%edx, 44(%esp)
	movl	%edi, 48(%esp)
	movl	%ebp, 52(%esp)
	jmp	.L39
.L61:
	leal	80(%esp), %eax
	movl	28(%esp), %edx
	movl	%esi, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	xorl	%esi, %esi
	call	app_thread_fun1
	movl	24(%esp), %ecx
	movl	76(%esp), %edx
	movl	72(%esp), %eax
	movl	%edx, thread_data+4(,%ecx,4)
	movl	%eax, thread_data(,%ecx,4)
	movl	%edi, thread_data+8(,%ecx,4)
	movl	%ebp, thread_data+12(,%ecx,4)
	movl	$checkpoint_semaphoreA, (%esp)
	call	sem_post
	movl	$checkpoint_semaphoreB, (%esp)
	call	sem_wait
	jmp	.L48
.L59:
	movl	32(%esp), %edx
	cmpl	pmax, %edx
	jae	.L55
.L50:
	movl	208(%esp), %eax
	movl	$.LC5, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L52
.L57:
	movl	208(%esp), %eax
	movl	%eax, (%esp)
	call	thread_cleanup
	leal	128(%esp), %eax
	call	__pthread_unwind_next
	.size	thread_fun, .-thread_fun
	.section	.rodata.str1.1
.LC6:
	.string	"r"
.LC7:
	.string	"tpconfig.txt"
.LC8:
	.string	"= \n\r\t\013"
.LC9:
	.string	"%s: unrecognised option `%s'\n"
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC10:
	.string	"%s: option `%s' doesn't allow an argument\n"
	.align 4
.LC11:
	.string	"%s: option `%s' requires an argument\n"
	.section	.rodata.str1.1
.LC12:
	.string	"%s: invalid argument %s %s\n"
	.section	.rodata.str1.4
	.align 4
.LC13:
	.string	"%s: out of range argument %s %s\n"
	.section	.rodata.str1.1
.LC14:
	.string	"%s: invalid argument -%c %s\n"
.LC15:
	.string	"%s: invalid argument --%s %s\n"
	.section	.rodata.str1.4
	.align 4
.LC16:
	.string	"%s: out of range argument -%c %s\n"
	.align 4
.LC17:
	.string	"%s: out of range argument --%s %s\n"
	.align 4
.LC18:
	.string	"%s: invalid non-option argument %s\n"
	.align 4
.LC19:
	.string	"%s: out of range non-option argument %s\n"
	.align 4
.LC20:
	.string	"-p --pmin=P0       Sieve start: 3 <= P0 <= p (default P0=3)"
	.align 4
.LC21:
	.string	"-P --pmax=P1       Sieve end: p < P1 <= 2^62 (default P1=P0+10^9)"
	.align 4
.LC22:
	.string	"-Q --qmax=Q1       Sieve only with odd primes q < Q1 <= 2^31"
	.align 4
.LC23:
	.string	"-B --blocksize=N   Sieve in blocks of N bytes (default N=%d)\n"
	.align 4
.LC24:
	.string	"-C --chunksize=N   Process blocks in chunks of N bytes (default N=%d)\n"
	.align 4
.LC25:
	.string	"   --blocks=N      Sieve up to N blocks ahead (default N=%d)\n"
	.align 4
.LC26:
	.string	"-c --checkpoint=N  Checkpoint every N seconds (default N=%d)\n"
	.align 4
.LC27:
	.string	"-r --report=N      Report status every N seconds (default N=%d)\n"
	.align 4
.LC28:
	.string	"-t --threads=N     Start N child threads (default N=1)"
	.align 4
.LC29:
	.string	"-z --priority=N    Set process priority to nice N or {idle,low,normal}"
	.align 4
.LC30:
	.string	"-h --help          Print this help"
	.align 4
.LC31:
	.string	"pmax not specified, using default pmax = pmin + 1e9\n"
	.align 4
.LC32:
	.string	"Option out of range: pmax must be greater than pmin\n"
	.align 4
.LC34:
	.string	"Sieve started: %llu <= p < %llu\n"
	.section	.rodata.str1.1
.LC35:
	.string	"tpcheckpoint.txt"
	.section	.rodata.str1.4
	.align 4
.LC36:
	.string	"pmin=%llu,p=%llu,count=%llu,sum=0x%llx,checksum=0x%llx\n"
	.align 4
.LC37:
	.string	"Resuming from checkpoint p=%llu in %s\n"
	.align 4
.LC38:
	.string	"Ignoring invalid checkpoint in %s\n"
	.section	.rodata.str1.1
.LC39:
	.string	"pthread_create"
.LC41:
	.string	"M"
.LC43:
	.string	"K"
.LC44:
	.string	""
	.section	.rodata.str1.4
	.align 4
.LC47:
	.string	"p=%llu, %.*f%s p/sec, %.2fx%.0fMHz CPU, %.1f%% done\n"
	.section	.rodata.str1.1
.LC48:
	.string	"w"
	.section	.rodata.str1.4
	.align 4
.LC49:
	.string	"pmin=%llu,p=%llu,count=%llu,sum=0x%016llx,checksum=0x%016llx\n"
.globl __udivdi3
.globl __umoddi3
	.section	.rodata.str1.1
.LC50:
	.string	"Waiting for threads to exit\n"
.LC51:
	.string	"Thread %d failed: %p\n"
	.section	.rodata.str1.4
	.align 4
.LC52:
	.string	"Sieve complete: %llu <= p < %llu\n"
	.align 4
.LC53:
	.string	"Sieve incomplete: %llu <= p < %llu\n"
	.section	.rodata.str1.1
.LC54:
	.string	"count=%llu,sum=0x%016llx\n"
	.section	.rodata.str1.4
	.align 4
.LC56:
	.string	"Elapsed time: %.2f sec. (%.2f init + %.2f sieve) at %.0f p/sec.\n"
	.align 4
.LC57:
	.string	"Processor time: %.2f sec. (%.2f init + %.2f sieve) at %.0f p/sec.\n"
	.align 4
.LC58:
	.string	"Average processor utilization: %.2f (init), %.2f (sieve)\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	subl	$504, %esp
	movl	(%ecx), %eax
	movl	%gs:20, %edx
	movl	%edx, 500(%esp)
	xorl	%edx, %edx
	movl	4(%ecx), %ecx
	movl	%eax, 60(%esp)
	movl	%ecx, 56(%esp)
	leal	372(%esp), %ebp
	call	elapsed_usec
	movl	%eax, program_start_time
	movl	%edx, program_start_time+4
	call	app_banner
	movl	$.LC6, 4(%esp)
	movl	$.LC7, (%esp)
	call	fopen
	movl	%eax, %edi
	testl	%eax, %eax
	je	.L63
	.p2align 4,,10
	.p2align 3
.L217:
	movl	%edi, 8(%esp)
	movl	$128, 4(%esp)
	movl	%ebp, (%esp)
	call	fgets
	testl	%eax, %eax
	je	.L229
	movl	$.LC8, 4(%esp)
	movl	%ebp, (%esp)
	call	strtok
	movl	%eax, %ebx
	testl	%eax, %eax
	je	.L217
	cmpb	$35, (%eax)
	je	.L217
	movl	$.LC8, 4(%esp)
	movl	$0, (%esp)
	call	strtok
	movl	%eax, 132(%esp)
	movl	long_opts, %eax
	testl	%eax, %eax
	je	.L65
	xorl	%esi, %esi
	jmp	.L67
	.p2align 4,,10
	.p2align 3
.L230:
	incl	%esi
	movl	%esi, %eax
	sall	$4, %eax
	movl	long_opts(%eax), %eax
	testl	%eax, %eax
	je	.L65
.L67:
	movl	%eax, 4(%esp)
	movl	%ebx, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L230
	movl	%esi, %eax
	sall	$4, %eax
	movl	long_opts+4(%eax), %eax
	testl	%eax, %eax
	jne	.L70
	movl	132(%esp), %eax
	testl	%eax, %eax
	je	.L71
	movl	%ebx, 16(%esp)
	movl	$.LC7, 12(%esp)
	movl	$.LC10, 8(%esp)
	jmp	.L226
	.p2align 4,,10
	.p2align 3
.L229:
	movl	%edi, (%esp)
	call	fclose
.L63:
	movl	$-1, 364(%esp)
	movl	short_opts, %edi
	leal	364(%esp), %esi
.L77:
	movl	60(%esp), %ebx
	movl	56(%esp), %ecx
	movl	%ebx, (%esp)
	movl	%esi, 16(%esp)
	movl	$long_opts, 12(%esp)
	movl	%edi, 8(%esp)
	movl	%ecx, 4(%esp)
	call	getopt_long
	movl	%eax, %ebx
	cmpl	$-1, %eax
	je	.L231
	xorl	%ecx, %ecx
	movl	optarg, %edx
	movl	%ebx, %eax
	call	parse_option
	cmpl	$-1, %eax
	je	.L80
	testl	%eax, %eax
	je	.L81
	cmpl	$-2, %eax
	.p2align 4,,5
	.p2align 3
	je	.L232
.L228:
	movl	$1, (%esp)
	.p2align 4,,5
	.p2align 3
	call	exit
	.p2align 4,,10
	.p2align 3
.L81:
	movl	$-1, 364(%esp)
	jmp	.L77
	.p2align 4,,10
	.p2align 3
.L80:
	movl	364(%esp), %edx
	cmpl	$-1, %edx
	je	.L233
	movl	optarg, %eax
	sall	$4, %edx
	movl	%eax, 20(%esp)
	movl	56(%esp), %ecx
	movl	long_opts(%edx), %eax
	movl	%eax, 16(%esp)
	movl	(%ecx), %eax
	movl	$.LC15, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L228
.L232:
	movl	364(%esp), %edx
	cmpl	$-1, %edx
	je	.L234
	movl	optarg, %eax
	sall	$4, %edx
	movl	%eax, 20(%esp)
	movl	long_opts(%edx), %eax
	movl	56(%esp), %edx
	movl	%eax, 16(%esp)
	movl	(%edx), %eax
	movl	$.LC17, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L228
.L70:
	decl	%eax
	je	.L235
.L71:
	movl	%esi, %eax
	sall	$4, %eax
	movl	long_opts+8(%eax), %edx
	testl	%edx, %edx
	je	.L72
	movl	long_opts+12(%eax), %eax
	movl	%eax, (%edx)
	jmp	.L217
.L235:
	movl	132(%esp), %eax
	testl	%eax, %eax
	jne	.L71
	movl	%ebx, 16(%esp)
	movl	$.LC7, 12(%esp)
	movl	$.LC11, 8(%esp)
.L226:
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L228
.L234:
	movl	optarg, %eax
	movl	%ebx, 16(%esp)
	movl	%eax, 20(%esp)
	movl	56(%esp), %ebx
	movl	(%ebx), %eax
	movl	$.LC16, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L228
.L233:
	movl	optarg, %eax
	movl	56(%esp), %edx
	movl	%eax, 20(%esp)
	movl	%ebx, 16(%esp)
	movl	(%edx), %eax
	movl	$.LC14, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L228
.L231:
	movl	optind, %eax
	cmpl	%eax, 60(%esp)
	jle	.L87
.L205:
	movl	56(%esp), %ecx
	movl	(%ecx,%eax,4), %edx
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	call	parse_option
	cmpl	$-1, %eax
	je	.L90
	testl	%eax, %eax
	jne	.L236
	movl	optind, %eax
	incl	%eax
	movl	%eax, optind
	cmpl	%eax, 60(%esp)
	jg	.L205
.L87:
	movl	help_opt, %ecx
	testl	%ecx, %ecx
	jne	.L237
	cmpl	$0, pmin+4
	ja	.L94
	cmpl	$2, pmin
	ja	.L94
	movl	$3, pmin
	movl	$0, pmin+4
.L94:
	cmpl	$1073741824, pmax+4
	jb	.L96
	ja	.L190
	cmpl	$0, pmax
	jbe	.L96
.L190:
	movl	$0, pmax
	movl	$1073741824, pmax+4
.L96:
	movl	pmin+4, %ebx
	movl	pmax+4, %eax
	movl	pmin, %ecx
	movl	pmax, %edx
	cmpl	%eax, %ebx
	jb	.L98
	ja	.L191
	cmpl	%edx, %ecx
	jb	.L98
.L191:
	orl	%edx, %eax
	.p2align 4,,7
	.p2align 3
	jne	.L100
	cmpl	$1073741823, %ebx
	.p2align 4,,5
	.p2align 3
	ja	.L100
	.p2align 4,,7
	.p2align 3
	jb	.L192
	cmpl	$-1000000001, %ecx
	.p2align 4,,7
	.p2align 3
	ja	.L100
.L192:
	movl	stderr, %eax
	movl	$52, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC31, (%esp)
	call	fwrite
	movl	pmin, %eax
	movl	pmin+4, %edx
	addl	$1000000000, %eax
	adcl	$0, %edx
	movl	%eax, pmax
	movl	%edx, pmax+4
.L98:
	movl	$1000000, %ecx
	movl	checkpoint_opt, %eax
	movl	blocksize_opt, %esi
	mull	%ecx
	movl	%eax, checkpoint_period
	movl	%edx, checkpoint_period+4
	movl	report_opt, %eax
	mull	%ecx
	movl	num_threads, %ecx
	movl	%eax, report_period
	movl	%edx, report_period+4
	movl	%esi, %eax
	xorl	%edx, %edx
	divl	chunksize_opt
	cmpl	%ecx, %eax
	jae	.L102
	xorl	%edx, %edx
	movl	%esi, %eax
	divl	%ecx
	movl	%eax, chunksize_opt
	cmpl	$15, %eax
	ja	.L102
	sall	$4, %ecx
	movl	$16, chunksize_opt
	movl	%ecx, blocksize_opt
.L102:
	movl	priority_opt, %eax
	testl	%eax, %eax
	je	.L103
	decl	%eax
	movl	$0, 4(%esp)
	movl	%eax, 8(%esp)
	movl	$0, (%esp)
	call	setpriority
.L103:
	movl	qmax, %ebx
	movl	pmax+4, %ebp
	movl	%ebx, %eax
	movl	pmax, %edi
	mull	%ebx
	cmpl	%ebp, %edx
	jb	.L104
	ja	.L193
	cmpl	%edi, %eax
	jbe	.L104
.L193:
	pushl	%ebp
	pushl	%edi
	fildll	(%esp)
	addl	$8, %esp
	testl	%ebp, %ebp
	jns	.L106
	fadds	.LC33
.L106:
	fnstcw	174(%esp)
	fstpl	176(%esp)
	movzwl	174(%esp), %eax
	fldl	176(%esp)
	movb	$12, %ah
	fsqrt
	movw	%ax, 172(%esp)
	fldcw	172(%esp)
	fistpll	160(%esp)
	fldcw	174(%esp)
	movl	160(%esp), %eax
	movl	%eax, qmax
.L104:
	movl	qmax, %eax
	movl	%eax, (%esp)
	call	init_sieve_primes
	call	app_init
	movl	pmax, %eax
	movl	pmax+4, %edx
	movl	%eax, 20(%esp)
	movl	%edx, 24(%esp)
	movl	pmin, %eax
	movl	pmin+4, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC34, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$.LC6, 4(%esp)
	movl	$.LC35, (%esp)
	call	fopen
	movl	%eax, %esi
	testl	%eax, %eax
	je	.L222
	leal	312(%esp), %eax
	movl	$.LC36, 4(%esp)
	movl	%eax, 24(%esp)
	movl	%esi, (%esp)
	leal	320(%esp), %eax
	movl	%eax, 20(%esp)
	leal	328(%esp), %eax
	movl	%eax, 16(%esp)
	leal	336(%esp), %eax
	movl	%eax, 12(%esp)
	leal	344(%esp), %eax
	movl	%eax, 8(%esp)
	call	fscanf
	cmpl	$5, %eax
	je	.L238
.L109:
	movl	%esi, (%esp)
	call	fclose
.L112:
	movl	$.LC35, 12(%esp)
	movl	$.LC38, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
.L222:
	movl	pmin, %eax
	movl	pmin+4, %ebx
.L108:
	movl	%ebx, pstart+4
	movl	%eax, %ecx
	movl	blocks_opt, %eax
	orl	$1, %ecx
	movl	%ecx, pstart
	movl	%eax, 28(%esp)
	movl	blocksize_opt, %eax
	movl	%eax, 24(%esp)
	movl	chunksize_opt, %eax
	movl	%eax, 20(%esp)
	movl	qmax, %eax
	movl	%eax, 16(%esp)
	movl	pmax+4, %edx
	movl	pmax, %eax
	movl	%edx, 12(%esp)
	movl	%ecx, (%esp)
	movl	%eax, 8(%esp)
	movl	%ebx, 4(%esp)
	call	create_sieve
	movl	%eax, sv
	movl	$handle_signal, 4(%esp)
	movl	$2, (%esp)
	call	signal
	movl	%eax, old_sigint_handler
	decl	%eax
	jne	.L113
	movl	$1, 4(%esp)
	movl	$2, (%esp)
	call	signal
.L113:
	movl	$handle_signal, 4(%esp)
	movl	$15, (%esp)
	call	signal
	movl	%eax, old_sigterm_handler
	decl	%eax
	jne	.L114
	movl	$1, 4(%esp)
	movl	$15, (%esp)
	call	signal
.L114:
	movl	$handle_signal, 4(%esp)
	movl	$1, (%esp)
	call	signal
	movl	%eax, old_sighup_handler
	decl	%eax
	jne	.L115
	movl	$1, 4(%esp)
	movl	$1, (%esp)
	call	signal
.L115:
	movl	$0, 4(%esp)
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_init
	movl	$0, 4(%esp)
	movl	$exiting_cond, (%esp)
	call	pthread_cond_init
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	$checkpoint_semaphoreA, (%esp)
	call	sem_init
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	$checkpoint_semaphoreB, (%esp)
	call	sem_init
	call	elapsed_usec
	movl	%eax, sieve_start_time
	movl	%edx, sieve_start_time+4
	call	processor_usec
	movl	%edx, sieve_start_processor_time+4
	movl	%eax, sieve_start_processor_time
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_lock
	movl	num_threads, %edx
	testl	%edx, %edx
	je	.L116
	xorl	%ebx, %ebx
	xorl	%eax, %eax
	leal	184(%esp), %esi
	jmp	.L118
	.p2align 4,,10
	.p2align 3
.L117:
	incl	%ebx
	movl	%ebx, %eax
	cmpl	%ebx, num_threads
	jbe	.L116
.L118:
	leal	(%esi,%eax,4), %eax
	movl	%ebx, 12(%esp)
	movl	$thread_fun, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	pthread_create
	testl	%eax, %eax
	je	.L117
	movl	$.LC39, (%esp)
	call	perror
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L72:
	movl	long_opts+12(%eax), %eax
	movl	$.LC7, %ecx
	movl	132(%esp), %edx
	call	parse_option
	cmpl	$-1, %eax
	je	.L75
	testl	%eax, %eax
	je	.L217
	cmpl	$-2, %eax
	.p2align 4,,5
	.p2align 3
	jne	.L228
	movl	132(%esp), %eax
	movl	%ebx, 16(%esp)
	movl	%eax, 20(%esp)
	movl	$.LC7, 12(%esp)
	movl	$.LC13, 8(%esp)
.L224:
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$1, (%esp)
	call	exit
.L236:
	cmpl	$-2, %eax
	jne	.L228
	movl	optind, %eax
	movl	56(%esp), %edx
	movl	(%edx,%eax,4), %eax
	movl	%eax, 16(%esp)
	movl	(%edx), %eax
	movl	$.LC19, 8(%esp)
	movl	%eax, 12(%esp)
	jmp	.L226
.L90:
	movl	optind, %eax
	movl	56(%esp), %ebx
	movl	(%ebx,%eax,4), %eax
	movl	%eax, 16(%esp)
	movl	(%ebx), %eax
	movl	$.LC18, 8(%esp)
	movl	%eax, 12(%esp)
	jmp	.L226
.L75:
	movl	132(%esp), %ecx
	movl	%ebx, 16(%esp)
	movl	%ecx, 20(%esp)
	movl	$.LC7, 12(%esp)
	movl	$.LC12, 8(%esp)
	jmp	.L224
.L65:
	movl	%ebx, 16(%esp)
	movl	$.LC7, 12(%esp)
	movl	$.LC9, 8(%esp)
	jmp	.L226
.L238:
	movl	344(%esp), %ebx
	movl	348(%esp), %ecx
	movl	%ebx, %eax
	movl	%ecx, %edx
	xorl	pmin, %eax
	xorl	pmin+4, %edx
	orl	%eax, %edx
	jne	.L109
	movl	340(%esp), %eax
	movl	336(%esp), %edx
	cmpl	%eax, %ecx
	ja	.L109
	jb	.L194
	cmpl	%edx, %ebx
	jae	.L109
.L194:
	cmpl	pmax+4, %eax
	.p2align 4,,4
	.p2align 3
	ja	.L109
	.p2align 4,,4
	.p2align 3
	jb	.L195
	cmpl	pmax, %edx
	jae	.L109
.L195:
	movl	%esi, (%esp)
	call	app_read_checkpoint
	movl	%esi, (%esp)
	movl	%eax, %ebx
	call	fclose
	testl	%ebx, %ebx
	je	.L112
	movl	336(%esp), %ebx
	movl	340(%esp), %esi
	movl	%ebx, %eax
	movl	%esi, %edx
	addl	344(%esp), %eax
	adcl	348(%esp), %edx
	addl	328(%esp), %eax
	adcl	332(%esp), %edx
	addl	320(%esp), %eax
	adcl	324(%esp), %edx
	xorl	312(%esp), %eax
	movl	%edx, %ecx
	xorl	316(%esp), %ecx
	orl	%eax, %ecx
	jne	.L112
	movl	%ebx, 12(%esp)
	movl	$.LC35, 20(%esp)
	movl	%esi, 16(%esp)
	movl	$.LC37, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	328(%esp), %eax
	movl	332(%esp), %edx
	movl	%eax, cand_count
	movl	%edx, cand_count+4
	movl	320(%esp), %eax
	movl	324(%esp), %edx
	movl	%eax, cand_sum
	movl	%edx, cand_sum+4
	movl	336(%esp), %eax
	movl	340(%esp), %ebx
	jmp	.L108
.L116:
	movl	sieve_start_time, %ecx
	movl	sieve_start_time+4, %ebx
	movl	pstart, %eax
	movl	pstart+4, %edx
	movl	%eax, last_checkpoint_progress
	movl	%edx, last_checkpoint_progress+4
	movl	sieve_start_processor_time, %eax
	movl	sieve_start_processor_time+4, %edx
	movl	%ecx, last_checkpoint_time
	movl	%ebx, last_checkpoint_time+4
	movl	%ecx, last_report_time
	movl	%ebx, last_report_time+4
	movl	%eax, last_report_processor_time
	movl	%edx, last_report_processor_time+4
	call	processor_cycles
	movl	%eax, last_report_processor_cycles
	movl	%edx, last_report_processor_cycles+4
	movl	pstart, %eax
	movl	pstart+4, %edx
	movl	%eax, last_report_progress
	movl	%edx, last_report_progress+4
	jmp	.L119
.L196:
	movl	sv, %eax
	movl	%eax, (%esp)
	call	next_chunk
	movl	%eax, %esi
	movl	%edx, %edi
	movl	96(%esp), %eax
	movl	100(%esp), %edx
	subl	last_report_time, %eax
	sbbl	last_report_time+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L122
	fadds	.LC33
.L122:
	fstpl	176(%esp)
	movl	%esi, %eax
	fldl	176(%esp)
	subl	last_report_progress, %eax
	movl	%edi, %edx
	sbbl	last_report_progress+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L123
	fadds	.LC33
.L123:
	fstpl	176(%esp)
	movl	$.LC41, %ebp
	fldl	176(%esp)
	fdiv	%st(1), %st
	fld1
	fucomip	%st(1), %st
	jbe	.L125
	fmuls	.LC42
	movl	$.LC43, %ebp
.L125:
	fld1
	fucomip	%st(1), %st
	jbe	.L126
	fmuls	.LC42
	movl	$.LC44, %ebp
.L126:
	flds	.LC45
	movl	$3, 128(%esp)
	fucomip	%st(1), %st
	ja	.L130
	flds	.LC46
	movl	$2, 128(%esp)
	fucomip	%st(1), %st
	ja	.L130
	xorl	%eax, %eax
	flds	.LC42
	fucomip	%st(1), %st
	seta	%al
	movl	%eax, 128(%esp)
.L130:
	movl	pmin, %ecx
	movl	pmin+4, %ebx
	movl	%esi, %eax
	movl	%edi, %edx
	subl	%ecx, %eax
	sbbl	%ebx, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L133
	fadds	.LC33
.L133:
	fstpl	176(%esp)
	fldl	176(%esp)
	movl	pmax, %eax
	movl	pmax+4, %edx
	subl	%ecx, %eax
	sbbl	%ebx, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L134
	fadds	.LC33
.L134:
	fstpl	176(%esp)
	movl	112(%esp), %eax
	fldl	176(%esp)
	movl	116(%esp), %edx
	fdivrp	%st, %st(1)
	fmuls	.LC46
	fstpl	48(%esp)
	subl	last_report_processor_cycles, %eax
	sbbl	last_report_processor_cycles+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L135
	fadds	.LC33
.L135:
	fstpl	176(%esp)
	movl	104(%esp), %eax
	fldl	176(%esp)
	movl	108(%esp), %edx
	fdiv	%st(2), %st
	fstpl	40(%esp)
	subl	last_report_processor_time, %eax
	sbbl	last_report_processor_time+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L136
	fadds	.LC33
.L136:
	fstpl	176(%esp)
	movl	128(%esp), %eax
	fldl	176(%esp)
	movl	%ebp, 28(%esp)
	fdivp	%st, %st(2)
	fxch	%st(1)
	movl	%eax, 16(%esp)
	fstpl	32(%esp)
	movl	%esi, 8(%esp)
	fstpl	20(%esp)
	movl	%edi, 12(%esp)
	movl	$.LC47, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	96(%esp), %edx
	movl	100(%esp), %ecx
	movl	%edx, last_report_time
	movl	%ecx, last_report_time+4
	addl	report_period, %edx
	movl	108(%esp), %ebx
	adcl	report_period+4, %ecx
	movl	%edx, 120(%esp)
	movl	%ecx, 124(%esp)
	movl	112(%esp), %eax
	movl	104(%esp), %ecx
	movl	116(%esp), %edx
	movl	%ecx, last_report_processor_time
	movl	%ebx, last_report_processor_time+4
	movl	%eax, last_report_processor_cycles
	movl	%edx, last_report_processor_cycles+4
	movl	%esi, last_report_progress
	movl	%edi, last_report_progress+4
.L120:
	movl	checkpoint_opt, %eax
	testl	%eax, %eax
	je	.L137
	movl	checkpoint_period, %ebx
	movl	checkpoint_period+4, %esi
	addl	last_checkpoint_time, %ebx
	adcl	last_checkpoint_time+4, %esi
	cmpl	%esi, 100(%esp)
	jae	.L239
.L138:
	movl	checkpoint_opt, %eax
	testl	%eax, %eax
	je	.L137
	cmpl	124(%esp), %esi
	ja	.L137
	jb	.L147
	cmpl	120(%esp), %ebx
	.p2align 4,,5
	.p2align 3
	jb	.L147
.L137:
	movl	120(%esp), %ebx
	movl	124(%esp), %esi
.L147:
	movl	%ebx, (%esp)
	movl	$1000000, 8(%esp)
	movl	$0, 12(%esp)
	movl	%esi, 4(%esp)
	call	__udivdi3
	movl	%ebx, (%esp)
	movl	%eax, 356(%esp)
	movl	$1000000, 8(%esp)
	movl	$0, 12(%esp)
	movl	%esi, 4(%esp)
	leal	356(%esp), %ebx
	call	__umoddi3
	movl	$1000, %ecx
	movl	%ebx, 8(%esp)
	mull	%ecx
	movl	$exiting_mutex, 4(%esp)
	movl	%eax, 360(%esp)
	movl	$exiting_cond, (%esp)
	call	pthread_cond_timedwait
	testl	%eax, %eax
	je	.L148
.L119:
	movzbl	stopping, %eax
	testb	%al, %al
	jne	.L148
	call	elapsed_usec
	movl	%eax, 96(%esp)
	movl	%edx, 100(%esp)
	call	processor_usec
	movl	%eax, 104(%esp)
	movl	%edx, 108(%esp)
	call	processor_cycles
	movl	last_report_time+4, %ecx
	movl	%eax, 112(%esp)
	movl	%edx, 116(%esp)
	movl	report_period, %eax
	movl	report_period+4, %edx
	movl	%eax, 120(%esp)
	movl	%edx, 124(%esp)
	movl	last_report_time, %edx
	addl	%edx, 120(%esp)
	adcl	%ecx, 124(%esp)
	movl	124(%esp), %ecx
	cmpl	%ecx, 100(%esp)
	jb	.L120
	ja	.L196
	movl	120(%esp), %ebx
	cmpl	%ebx, 96(%esp)
	jb	.L120
	.p2align 4,,5
	.p2align 3
	jmp	.L196
.L239:
	.p2align 4,,5
	.p2align 3
	jbe	.L240
.L200:
	movzbl	no_more_checkpoints, %eax
	testb	%al, %al
	.p2align 4,,4
	.p2align 3
	jne	.L138
	movl	num_threads, %eax
	movb	$1, checkpointing
	testl	%eax, %eax
	je	.L140
	xorl	%ebx, %ebx
.L141:
	movl	$checkpoint_semaphoreA, (%esp)
	incl	%ebx
	call	sem_wait
	cmpl	%ebx, num_threads
	ja	.L141
.L140:
	movl	sv, %eax
	movl	%eax, (%esp)
	call	next_chunk
	movl	$.LC48, 4(%esp)
	movl	%eax, 152(%esp)
	movl	%edx, 156(%esp)
	movl	$.LC35, (%esp)
	call	fopen
	movl	%eax, %ebp
	testl	%eax, %eax
	je	.L142
	movl	cand_count, %edx
	movl	cand_count+4, %ecx
	movl	num_threads, %eax
	movl	%edx, 136(%esp)
	movl	%ecx, 140(%esp)
	movl	cand_sum, %esi
	movl	cand_sum+4, %edi
	testl	%eax, %eax
	je	.L143
	leal	(%eax,%eax,4), %eax
	movl	$thread_data, %edx
	leal	thread_data(,%eax,4), %eax
.L144:
	movl	(%edx), %ecx
	movl	4(%edx), %ebx
	addl	%ecx, 136(%esp)
	adcl	%ebx, 140(%esp)
	addl	8(%edx), %esi
	adcl	12(%edx), %edi
	addl	$20, %edx
	cmpl	%eax, %edx
	jne	.L144
.L143:
	movl	pmin, %ecx
	movl	pmin+4, %ebx
	movl	152(%esp), %eax
	movl	156(%esp), %edx
	addl	%ecx, %eax
	movl	%ecx, 12(%esp)
	adcl	%ebx, %edx
	movl	%esi, 36(%esp)
	addl	136(%esp), %eax
	movl	%edi, 40(%esp)
	adcl	140(%esp), %edx
	movl	%ebx, 16(%esp)
	addl	%esi, %eax
	movl	$.LC49, 8(%esp)
	adcl	%edi, %edx
	movl	%eax, 44(%esp)
	movl	%edx, 48(%esp)
	movl	136(%esp), %eax
	movl	140(%esp), %edx
	movl	%eax, 28(%esp)
	movl	%edx, 32(%esp)
	movl	152(%esp), %eax
	movl	156(%esp), %edx
	movl	%eax, 20(%esp)
	movl	%edx, 24(%esp)
	movl	$1, 4(%esp)
	movl	%ebp, (%esp)
	call	__fprintf_chk
	movl	%ebp, (%esp)
	call	app_write_checkpoint
	movl	%ebp, (%esp)
	call	fclose
.L142:
	movl	100(%esp), %ebx
	movl	156(%esp), %ecx
	movl	%ebx, %esi
	movl	152(%esp), %edx
	movl	%ecx, last_checkpoint_progress+4
	movl	%ebx, last_checkpoint_time+4
	movl	96(%esp), %ecx
	movl	num_threads, %eax
	movl	%ecx, %ebx
	movl	%edx, last_checkpoint_progress
	addl	checkpoint_period, %ebx
	movl	%ecx, last_checkpoint_time
	adcl	checkpoint_period+4, %esi
	movb	$0, checkpointing
	testl	%eax, %eax
	je	.L138
	xorl	%edi, %edi
.L145:
	movl	$checkpoint_semaphoreB, (%esp)
	incl	%edi
	call	sem_post
	cmpl	%edi, num_threads
	ja	.L145
	jmp	.L138
	.p2align 4,,10
	.p2align 3
.L240:
	cmpl	%ebx, 96(%esp)
	.p2align 4,,3
	.p2align 3
	jb	.L138
	.p2align 4,,8
	.p2align 3
	jmp	.L200
.L100:
	movl	stderr, %eax
	movl	$52, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC32, (%esp)
	call	fwrite
	movl	$1, (%esp)
	call	exit
.L237:
	movl	$.LC20, (%esp)
	call	puts
	movl	$.LC21, (%esp)
	call	puts
	movl	$.LC22, (%esp)
	call	puts
	movl	$32768, 8(%esp)
	movl	$.LC23, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$128, 8(%esp)
	movl	$.LC24, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$2, 8(%esp)
	movl	$.LC25, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$300, 8(%esp)
	movl	$.LC26, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$60, 8(%esp)
	movl	$.LC27, 4(%esp)
	movl	$1, (%esp)
	call	__printf_chk
	movl	$.LC28, (%esp)
	call	puts
	movl	$.LC29, (%esp)
	call	puts
	movl	$.LC30, (%esp)
	call	puts
	call	app_help
	movl	$0, (%esp)
	call	exit
.L148:
	movl	old_sigint_handler, %eax
	cmpl	$1, %eax
	je	.L150
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	signal
.L150:
	movl	old_sigterm_handler, %eax
	cmpl	$1, %eax
	je	.L151
	movl	%eax, 4(%esp)
	movl	$15, (%esp)
	call	signal
.L151:
	movl	old_sighup_handler, %eax
	cmpl	$1, %eax
	je	.L152
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	signal
.L152:
	movl	stderr, %eax
	movl	$28, 8(%esp)
	movl	%eax, 12(%esp)
	movl	$1, 4(%esp)
	movl	$.LC50, (%esp)
	call	fwrite
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_unlock
	movl	num_threads, %ecx
	testl	%ecx, %ecx
	je	.L153
	xorl	%esi, %esi
	xorl	%ebx, %ebx
	movl	$thread_data+36, %edx
	cmpb	$0, thread_data+16
	je	.L204
	jmp	.L155
	.p2align 4,,10
	.p2align 3
.L159:
	movzbl	(%edx), %eax
	addl	$20, %edx
	testb	%al, %al
	jne	.L241
.L204:
	incl	%esi
	cmpl	%esi, %ecx
	.p2align 4,,2
	.p2align 3
	ja	.L159
	movl	%ecx, %esi
	movl	$0, 76(%esp)
	jmp	.L162
.L241:
	movl	%esi, %ebx
.L155:
	leal	368(%esp), %eax
	movl	%eax, 4(%esp)
	movl	184(%esp,%ebx,4), %eax
	movl	%eax, (%esp)
	call	pthread_join
	movl	368(%esp), %eax
	movl	$0, 76(%esp)
	testl	%eax, %eax
	je	.L158
	movl	%eax, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	$.LC51, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movb	$1, stopping
	movl	$1, 76(%esp)
.L158:
	movl	num_threads, %eax
	testl	%eax, %eax
	je	.L161
.L162:
	xorl	%ebx, %ebx
	leal	368(%esp), %edi
	leal	184(%esp), %ebp
.L160:
	cmpl	%esi, %ebx
	je	.L163
	movl	%edi, 4(%esp)
	movl	(%ebp,%ebx,4), %eax
	movl	%eax, (%esp)
	call	pthread_join
	movl	368(%esp), %eax
	testl	%eax, %eax
	je	.L163
	movl	%eax, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	$.LC51, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$1, 76(%esp)
.L163:
	incl	%ebx
	cmpl	%ebx, num_threads
	ja	.L160
.L161:
	movl	$exiting_cond, (%esp)
	call	pthread_cond_destroy
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_destroy
	movl	$checkpoint_semaphoreA, (%esp)
	call	sem_destroy
	movl	$checkpoint_semaphoreB, (%esp)
	call	sem_destroy
	movl	76(%esp), %eax
	testl	%eax, %eax
	je	.L186
	movl	last_checkpoint_progress, %edx
	movl	last_checkpoint_progress+4, %ecx
	movl	%edx, 64(%esp)
	movl	%ecx, 68(%esp)
.L165:
	movl	pmax+4, %edx
	movl	pmax, %eax
	cmpl	%edx, 68(%esp)
	jb	.L168
	ja	.L202
	cmpl	%eax, 64(%esp)
	jb	.L168
.L202:
	movl	%eax, 20(%esp)
	movl	%edx, 24(%esp)
	movl	pmin, %eax
	movl	pmin+4, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC52, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	$.LC35, (%esp)
	call	remove
.L170:
	call	app_fini
	movl	sv, %eax
	movl	%eax, (%esp)
	call	destroy_sieve
	call	free_sieve_primes
	movl	76(%esp), %ebp
	testl	%ebp, %ebp
	jne	.L171
	movl	num_threads, %edi
	testl	%edi, %edi
	je	.L172
	movl	$thread_data, %ecx
	xorl	%ebx, %ebx
.L173:
	movl	(%ecx), %eax
	movl	4(%ecx), %edx
	addl	%eax, cand_count
	movl	8(%ecx), %eax
	adcl	%edx, cand_count+4
	movl	12(%ecx), %edx
	addl	%eax, cand_sum
	adcl	%edx, cand_sum+4
	incl	%ebx
	addl	$20, %ecx
	cmpl	%ebx, num_threads
	ja	.L173
.L172:
	movl	cand_sum, %eax
	movl	cand_sum+4, %edx
	movl	%eax, 20(%esp)
	movl	%edx, 24(%esp)
	movl	cand_count, %eax
	movl	cand_count+4, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC54, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
.L171:
	call	elapsed_usec
	movl	%eax, 80(%esp)
	movl	%edx, 84(%esp)
	call	processor_usec
	movl	sieve_start_time, %ecx
	movl	%eax, 88(%esp)
	movl	%edx, 92(%esp)
	movl	80(%esp), %eax
	movl	84(%esp), %edx
	subl	%ecx, %eax
	movl	sieve_start_time+4, %ebx
	sbbl	%ebx, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L174
	fadds	.LC33
.L174:
	fstpl	176(%esp)
	movl	64(%esp), %eax
	fldl	176(%esp)
	subl	pstart, %eax
	movl	68(%esp), %edx
	movl	program_start_time, %esi
	sbbl	pstart+4, %edx
	movl	program_start_time+4, %edi
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L175
	fadds	.LC33
.L175:
	fstpl	176(%esp)
	movl	%ecx, %eax
	fldl	176(%esp)
	subl	%esi, %eax
	fdiv	%st(1), %st
	movl	%ebx, %edx
	flds	.LC55
	sbbl	%edi, %edx
	fmul	%st, %st(1)
	fxch	%st(1)
	fstpl	36(%esp)
	fdivrp	%st, %st(1)
	fstpl	28(%esp)
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L176
	fadds	.LC33
.L176:
	fstpl	176(%esp)
	movl	80(%esp), %eax
	fldl	176(%esp)
	movl	84(%esp), %edx
	subl	%esi, %eax
	fdivs	.LC55
	sbbl	%edi, %edx
	fstpl	20(%esp)
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L177
	fadds	.LC33
.L177:
	fstpl	176(%esp)
	movl	$.LC56, 8(%esp)
	fldl	176(%esp)
	movl	$1, 4(%esp)
	fdivs	.LC55
	fstpl	12(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	88(%esp), %eax
	movl	92(%esp), %edx
	movl	sieve_start_processor_time, %ecx
	movl	sieve_start_processor_time+4, %ebx
	subl	%ecx, %eax
	sbbl	%ebx, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L178
	fadds	.LC33
.L178:
	fstpl	176(%esp)
	movl	64(%esp), %eax
	fldl	176(%esp)
	subl	pstart, %eax
	movl	68(%esp), %edx
	sbbl	pstart+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L179
	fadds	.LC33
.L179:
	fstpl	176(%esp)
	fldl	176(%esp)
	fdiv	%st(1), %st
	flds	.LC55
	fmul	%st, %st(1)
	fxch	%st(1)
	fstpl	36(%esp)
	fdivrp	%st, %st(1)
	fstpl	28(%esp)
	pushl	%ebx
	pushl	%ecx
	fildll	(%esp)
	addl	$8, %esp
	testl	%ebx, %ebx
	jns	.L180
	fadds	.LC33
.L180:
	fstpl	176(%esp)
	movl	92(%esp), %esi
	fldl	176(%esp)
	testl	%esi, %esi
	fdivs	.LC55
	fstpl	20(%esp)
	fildll	88(%esp)
	jns	.L181
	fadds	.LC33
.L181:
	fstpl	176(%esp)
	movl	$.LC57, 8(%esp)
	fldl	176(%esp)
	movl	$1, 4(%esp)
	fdivs	.LC55
	fstpl	12(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	88(%esp), %eax
	movl	92(%esp), %edx
	movl	sieve_start_processor_time, %ecx
	movl	sieve_start_processor_time+4, %ebx
	subl	%ecx, %eax
	movl	sieve_start_time, %esi
	sbbl	%ebx, %edx
	movl	sieve_start_time+4, %edi
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L182
	fadds	.LC33
.L182:
	fstpl	176(%esp)
	movl	80(%esp), %eax
	fldl	176(%esp)
	movl	84(%esp), %edx
	subl	%esi, %eax
	sbbl	%edi, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L183
	fadds	.LC33
.L183:
	fstpl	176(%esp)
	fldl	176(%esp)
	fdivrp	%st, %st(1)
	fstpl	20(%esp)
	pushl	%ebx
	pushl	%ecx
	fildll	(%esp)
	addl	$8, %esp
	testl	%ebx, %ebx
	jns	.L184
	fadds	.LC33
.L184:
	fstpl	176(%esp)
	movl	%esi, %eax
	fldl	176(%esp)
	subl	program_start_time, %eax
	movl	%edi, %edx
	sbbl	program_start_time+4, %edx
	pushl	%edx
	pushl	%eax
	fildll	(%esp)
	addl	$8, %esp
	testl	%edx, %edx
	jns	.L185
	fadds	.LC33
.L185:
	fstpl	176(%esp)
	movl	$.LC58, 8(%esp)
	fldl	176(%esp)
	movl	$1, 4(%esp)
	fdivrp	%st, %st(1)
	fstpl	12(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	movl	76(%esp), %eax
	movl	500(%esp), %ebx
	xorl	%gs:20, %ebx
	jne	.L242
	addl	$504, %esp
	popl	%ecx
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
.L168:
	movl	64(%esp), %ecx
	movl	68(%esp), %ebx
	movl	%ecx, 20(%esp)
	movl	%ebx, 24(%esp)
	movl	pmin, %eax
	movl	pmin+4, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC53, 8(%esp)
	movl	$1, 4(%esp)
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	__fprintf_chk
	jmp	.L170
.L153:
	movl	$exiting_cond, (%esp)
	call	pthread_cond_destroy
	movl	$exiting_mutex, (%esp)
	call	pthread_mutex_destroy
	movl	$checkpoint_semaphoreA, (%esp)
	call	sem_destroy
	movl	$checkpoint_semaphoreB, (%esp)
	call	sem_destroy
	movl	$0, 76(%esp)
.L186:
	movl	sv, %eax
	movl	%eax, (%esp)
	call	next_chunk
	movl	$.LC48, 4(%esp)
	movl	%eax, 64(%esp)
	movl	%edx, 68(%esp)
	movl	$.LC35, (%esp)
	call	fopen
	movl	%eax, %ebp
	testl	%eax, %eax
	je	.L165
	movl	cand_count, %eax
	movl	cand_count+4, %edx
	movl	%eax, 144(%esp)
	movl	%edx, 148(%esp)
	movl	num_threads, %eax
	movl	cand_sum, %esi
	movl	cand_sum+4, %edi
	testl	%eax, %eax
	je	.L166
	leal	(%eax,%eax,4), %eax
	movl	$thread_data, %edx
	leal	thread_data(,%eax,4), %eax
.L167:
	movl	(%edx), %ecx
	movl	4(%edx), %ebx
	addl	%ecx, 144(%esp)
	adcl	%ebx, 148(%esp)
	addl	8(%edx), %esi
	adcl	12(%edx), %edi
	addl	$20, %edx
	cmpl	%eax, %edx
	jne	.L167
.L166:
	movl	pmin, %ecx
	movl	pmin+4, %ebx
	movl	64(%esp), %eax
	movl	68(%esp), %edx
	addl	%ecx, %eax
	movl	%ecx, 12(%esp)
	adcl	%ebx, %edx
	movl	%esi, 36(%esp)
	addl	144(%esp), %eax
	movl	%edi, 40(%esp)
	adcl	148(%esp), %edx
	movl	%ebx, 16(%esp)
	addl	%esi, %eax
	movl	$.LC49, 8(%esp)
	adcl	%edi, %edx
	movl	%eax, 44(%esp)
	movl	%edx, 48(%esp)
	movl	144(%esp), %eax
	movl	148(%esp), %edx
	movl	%eax, 28(%esp)
	movl	%edx, 32(%esp)
	movl	64(%esp), %eax
	movl	68(%esp), %edx
	movl	%eax, 20(%esp)
	movl	%edx, 24(%esp)
	movl	$1, 4(%esp)
	movl	%ebp, (%esp)
	call	__fprintf_chk
	movl	%ebp, (%esp)
	call	app_write_checkpoint
	movl	%ebp, (%esp)
	call	fclose
	jmp	.L165
	.p2align 4,,10
	.p2align 3
.L242:
	.p2align 4,,6
	.p2align 3
	call	__stack_chk_fail
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
.LC60:
	.string	"pmin"
.LC61:
	.string	"pmax"
.LC62:
	.string	"qmax"
.LC63:
	.string	"blocksize"
.LC64:
	.string	"chunksize"
.LC65:
	.string	"blocks"
.LC66:
	.string	"checkpoint"
.LC67:
	.string	"report"
.LC68:
	.string	"threads"
.LC69:
	.string	"priority"
.LC70:
	.string	"help"
.LC71:
	.string	"kmin"
.LC72:
	.string	"kmax"
.LC73:
	.string	"nmin"
.LC74:
	.string	"nmax"
.LC75:
	.string	"input"
.LC76:
	.string	"factors"
.LC77:
	.string	"quiet"
	.section	.rodata
	.align 32
	.type	long_opts, @object
	.size	long_opts, 304
long_opts:
	.long	.LC60
	.long	1
	.long	0
	.long	112
	.long	.LC61
	.long	1
	.long	0
	.long	80
	.long	.LC62
	.long	1
	.long	0
	.long	81
	.long	.LC63
	.long	1
	.long	0
	.long	66
	.long	.LC64
	.long	1
	.long	0
	.long	67
	.long	.LC65
	.long	1
	.long	0
	.long	256
	.long	.LC66
	.long	1
	.long	0
	.long	99
	.long	.LC67
	.long	1
	.long	0
	.long	114
	.long	.LC68
	.long	1
	.long	0
	.long	116
	.long	.LC69
	.long	1
	.long	0
	.long	122
	.long	.LC70
	.long	0
	.long	0
	.long	104
	.long	.LC71
	.long	1
	.long	0
	.long	107
	.long	.LC72
	.long	1
	.long	0
	.long	75
	.long	.LC73
	.long	1
	.long	0
	.long	110
	.long	.LC74
	.long	1
	.long	0
	.long	78
	.long	.LC75
	.long	1
	.long	0
	.long	105
	.long	.LC76
	.long	1
	.long	0
	.long	102
	.long	.LC77
	.long	0
	.long	0
	.long	113
	.long	0
	.long	0
	.long	0
	.long	0
	.local	help_opt
	.comm	help_opt,4,4
	.section	.rodata.str1.4
	.align 4
.LC78:
	.string	"p:P:Q:B:C:c:r:t:z:hk:K:n:N:i:f:q"
	.section	.rodata
	.align 4
	.type	short_opts, @object
	.size	short_opts, 4
short_opts:
	.long	.LC78
	.local	pstart
	.comm	pstart,8,8
	.local	sv
	.comm	sv,4,4
	.local	report_period
	.comm	report_period,8,8
	.local	checkpoint_period
	.comm	checkpoint_period,8,8
	.local	program_start_time
	.comm	program_start_time,8,8
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
	.comm	thread_data,640,32
	.local	exiting_mutex
	.comm	exiting_mutex,24,4
	.local	exiting_cond
	.comm	exiting_cond,48,32
	.local	checkpoint_semaphoreA
	.comm	checkpoint_semaphoreA,16,4
	.local	checkpoint_semaphoreB
	.comm	checkpoint_semaphoreB,16,4
	.local	old_sigint_handler
	.comm	old_sigint_handler,4,4
	.local	old_sigterm_handler
	.comm	old_sigterm_handler,4,4
	.local	old_sighup_handler
	.comm	old_sighup_handler,4,4
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC33:
	.long	1602224128
	.align 4
.LC42:
	.long	1148846080
	.align 4
.LC45:
	.long	1092616192
	.align 4
.LC46:
	.long	1120403456
	.align 4
.LC55:
	.long	1232348160
	.weak	__pthread_unwind_next
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
