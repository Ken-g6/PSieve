/* primorial4_x86_sse2.S -- Geoffrey Reynolds, October 2008.

   int primorial4_x86_sse2(const uint32_t *N, const uint64_t *P, int nmax)
	__attribute__ ((pure));

   N is an array of consecutive odd primes 3,..,n_max,eol
   where eol is any integer greater than nmax.
   P is an array of 4 primes.

   Assumes n < 2^31 for all n in N.
   Assumes p < 2^62 for all p in P.
   Assumes P is 16-aligned.
   Assumes stack is 16-aligned.

   Returns the first n in N such that n#+/-1 is divisible by some p in P.
   Returns zero if there is no such n.
*/

	.text

#if defined(_WIN32) || defined(__APPLE__)
# define FUN_NAME _primorial4_x86_sse2
#else
# define FUN_NAME primorial4_x86_sse2
#endif

	.p2align 4,,15
	.globl	FUN_NAME

FUN_NAME:
	push	%ebx
	sub	$72, %esp

/*	88(%esp) nmax
	84(%esp) P
	80(%esp) N
	76(%esp) return addr
	72(%esp) ebx
	68(%esp) new_cw
	64(%esp) old_cw
	32(%esp) P[0-3] >> 32
	  (%esp) FPU transfer	*/

	fnstcw	64(%esp)
	mov	64(%esp), %ax
	or	$0x0F00, %ax		/* Round to zero, extended precision */
	mov	%ax, 68(%esp)
	fldcw   68(%esp)

	mov	80(%esp), %edx
	mov	84(%esp), %ecx

	fildll	24(%ecx)
	fld1
	fdivp   %st(0), %st(1)
	fildll	16(%ecx)
	fld1
	fdivp   %st(0), %st(1)
	fildll	8(%ecx)
	fld1
	fdivp   %st(0), %st(1)
	fildll	(%ecx)
	fld1
	fdivp   %st(0), %st(1)

	pcmpeqd	%xmm0, %xmm0
	psrlq	$63, %xmm0
	psllq	$1, %xmm0 /* %xmm0 <-- {2,2} */
	movdqa	%xmm0, %xmm1
	movdqa	%xmm0, (%esp)
	movdqa	%xmm1, 16(%esp)

	movdqa	(%ecx), %xmm2
	movdqa	16(%ecx), %xmm3
	psrlq	$32, %xmm2
	psrlq	$32, %xmm3
	movdqa	%xmm2, 32(%esp)
	movdqa	%xmm3, 48(%esp)

	jmp	test4

	.p2align 4,,15
loop4:
/*	%st(0)-%st(3)	1/P[0-3]
	%xmm0-1		R[0-3]
	%esp		R
	%ecx		P
	%edx		N
	%eax		n
*/
#if PREFETCH
	prefetchnta 4*PREFETCH(%edx)
#endif

	fildl	(%edx)
	lea	4(%edx), %edx

	fildll	(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(2), %st(0)
	fistpll	(%esp)
	fildll	8(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(3), %st(0)
	fistpll	8(%esp)
	fildll	16(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(4), %st(0)
	fistpll	16(%esp)
	fildll	24(%esp)
	fmulp	%st(0), %st(1)
	fmul	%st(4), %st(0)
	fistpll	24(%esp)

	/* %xmm2 <-- {n,n} */
	movd	%eax, %xmm2
	punpcklqdq %xmm2, %xmm2

	/* %xmm0-1 <-- R[0-3]*n */
	movdqa	%xmm0, %xmm6
	movdqa	%xmm1, %xmm7
	psrlq	$32, %xmm6
	psrlq	$32, %xmm7
	pmuludq %xmm2, %xmm0
	pmuludq %xmm2, %xmm1
	pmuludq %xmm2, %xmm6
	pmuludq %xmm2, %xmm7
	psllq   $32, %xmm6
	psllq   $32, %xmm7
	paddq   %xmm6, %xmm0
	paddq   %xmm7, %xmm1

	/* %xmm2 <-- P[0-1]*floor(R[0-1]*n/P[0-1]) */
	movq	(%esp), %xmm2
	movhps	8(%esp), %xmm2
	movdqa	(%ecx), %xmm4

	movdqa	%xmm2, %xmm6
	pshufd	$0xF5, %xmm2, %xmm7
	pmuludq 32(%esp), %xmm6
	pmuludq %xmm4, %xmm7
	pmuludq %xmm4, %xmm2
	psllq   $32, %xmm7
	psllq   $32, %xmm6
	paddq   %xmm7, %xmm2
	paddq   %xmm6, %xmm2

	/* %xmm3 <-- P[2-3]*floor(R[2-3]*n/P[2-3]) */
	movq	16(%esp), %xmm3
	movhps	24(%esp), %xmm3
	movdqa	16(%ecx), %xmm5

	movdqa	%xmm3, %xmm6
	pshufd	$0xF5, %xmm3, %xmm7
	pmuludq 48(%esp), %xmm6
	pmuludq %xmm5, %xmm7
	pmuludq %xmm5, %xmm3
	psllq   $32, %xmm7
	psllq   $32, %xmm6
	paddq   %xmm7, %xmm3
	paddq   %xmm6, %xmm3

	/* Correct %xmm2-3 in the range 0 to P[0-3]-1 */
	pxor    %xmm6, %xmm6
	pxor    %xmm7, %xmm7
	psubq   %xmm2, %xmm0
	psubq   %xmm3, %xmm1
	psubq   %xmm4, %xmm0
	psubq   %xmm5, %xmm1
	pcmpgtd %xmm0, %xmm6
	pcmpgtd %xmm1, %xmm7
	pshufd  $0xF5, %xmm6, %xmm6
	pshufd  $0xF5, %xmm7, %xmm7
	pand    %xmm4, %xmm6
	pand    %xmm5, %xmm7
	paddq	%xmm6, %xmm0
	paddq	%xmm7, %xmm1

	movlps	%xmm0, (%esp)
	movhps	%xmm0, 8(%esp)
	movlps	%xmm1, 16(%esp)
	movhps	%xmm1, 24(%esp)

	/* Compare R[0-3] with 1 and P[0-3]-1 */
	pcmpeqd	%xmm2, %xmm2
	pcmpeqd	%xmm3, %xmm3
	paddq	%xmm2, %xmm4
	paddq	%xmm3, %xmm5
	psrlq	$63, %xmm2
	psrlq	$63, %xmm3

	pcmpeqd	%xmm0, %xmm4
	pcmpeqd	%xmm1, %xmm5
	pcmpeqd	%xmm0, %xmm2
	pcmpeqd	%xmm1, %xmm3

	pshufd  $0xB1, %xmm4, %xmm6
	pshufd  $0xB1, %xmm5, %xmm7
	pand	%xmm6, %xmm4
	pand	%xmm7, %xmm5

	pshufd  $0xB1, %xmm2, %xmm6
	pshufd  $0xB1, %xmm3, %xmm7
	pand	%xmm6, %xmm2
	pand	%xmm7, %xmm3

	por	%xmm4, %xmm5
	por	%xmm2, %xmm3
	por	%xmm3, %xmm5
	pmovmskb %xmm5, %ebx
	test	%ebx, %ebx
	jnz	done4

test4:
	mov	(%edx), %eax
	cmp	%eax, 88(%esp)
	jae	loop4

	xor	%eax, %eax

done4:
	fstp	%st(0)
	fstp	%st(0)
	fstp	%st(0)
	fstp	%st(0)

	fldcw	64(%esp)

	add	$72, %esp
	pop	%ebx

	ret
