/* primorial4_x86.S -- Geoffrey Reynolds, November 2008.

   int primorial4_x86(const uint32_t *N, const uint64_t *P, int nmax)
	__attribute__ ((pure));

   N is an array of consecutive odd primes 3,..,nmax,eol
   where eol is any integer greater than nmax.
   P is an array of 4 odd primes.

   Assumes n < 2^31 for all n in N.
   Assumes p < 2^62 for all p in P.
   Assumes stack is 16-aligned.

   Returns the first n in N such that n#+/-1 is divisible by some p in P.
   Returns zero if there is no such n.
*/

	.text

#if defined(_WIN32) || defined(__APPLE__)
# define FUN_NAME _primorial4_x86
#else
# define FUN_NAME primorial4_x86
#endif

	.p2align 4,,15
	.globl	FUN_NAME

FUN_NAME:
	push	%ebx
	push	%ebp
	push	%esi
	push	%edi
	sub	$108, %esp

/*	136(%esp) nmax
	132(%esp) P
	128(%esp) N
	124(%esp) return addr
	120(%esp) ebx
	116(%esp) ebp
	112(%esp) esi
	108(%esp) edi
	104(%esp) N
	100(%esp) new_cw
	 96(%esp) old_cw
	 64(%esp) P[0-3]
	   (%esp) FPU transfer	*/

	fnstcw	96(%esp)
	mov	96(%esp), %ax
	or	$0x0F00, %ax		/* Round to zero, extended precision */
	mov	%ax, 100(%esp)
	fldcw   100(%esp)

	mov	132(%esp), %ecx

	/* %st(0-3) <-- 1/P[0-3] */
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

	/* Copy P[0-3] */
	mov	(%ecx), %eax
	mov	4(%ecx), %edx
	mov	%eax, 64(%esp)
	mov	%edx, 68(%esp)
	mov	8(%ecx), %eax
	mov	12(%ecx), %edx
	mov	%eax, 72(%esp)
	mov	%edx, 76(%esp)
	mov	16(%ecx), %eax
	mov	20(%ecx), %edx
	mov	%eax, 80(%esp)
	mov	%edx, 84(%esp)
	mov	24(%ecx), %eax
	mov	28(%ecx), %edx
	mov	%eax, 88(%esp)
	mov	%edx, 92(%esp)

	/* R[0-3] <-- 2 */
	mov	$2, %eax
	xor	%edx, %edx
	mov	%eax, (%esp)
	mov	%edx, 4(%esp)
	mov	%eax, 8(%esp)
	mov	%edx, 12(%esp)
	mov	%eax, 16(%esp)
	mov	%edx, 20(%esp)
	mov	%eax, 24(%esp)
	mov	%edx, 28(%esp)

	mov	128(%esp), %edx
	jmp	test4

	.p2align 4,,15
loop4:
/*	%st(0-3)	1/P[0-3]
	%esp		R
	%edx		N
	%ebp		n
*/
#if PREFETCH
	prefetchnta 4*PREFETCH(%edx)
#endif

	fildl	(%edx)
	lea	4(%edx), %edx
	mov	%edx, 104(%esp)

	fildll	(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(2), %st(0)
	fistpll	32(%esp)
	fildll	8(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(3), %st(0)
	fistpll	40(%esp)
	fildll	16(%esp)
	fmul	%st(1), %st(0)
	fmul	%st(4), %st(0)
	fistpll	48(%esp)
	fildll	24(%esp)
	fmulp	%st(0), %st(1)
	fmul	%st(4), %st(0)
	fistpll	56(%esp)


	/* %ecx:%ebx <-- P[0]*floor(R[0]*n/p) */
	mov	64(%esp), %esi
	mov	%esi, %eax
	mov	32(%esp), %ebx
	mov	36(%esp), %ecx
	mul	%ebx
	imul	%esi, %ecx
	imul	68(%esp), %ebx
	add	%edx, %ecx
	add	%ebx, %ecx
	mov	%eax, %ebx

	/* %edx:%eax <-- R[0]*n */
	mov	(%esp), %eax
	mov	4(%esp), %edi
	mul	%ebp
	imul	%ebp, %edi
	add	%edi, %edx

	/* %edx:%eax <-- R[0]*n - P[0]*floor(R[0]*n/p) */
	sub	%ebx, %eax
	sbb	%ecx, %edx

	mov	68(%esp), %edi
	mov	%eax, %ebx
	mov	%edx, %ecx

	sub	%esi, %ebx
	sbb	%edi, %ecx	/* >= predicted */
	jl	0f
	mov	%ebx, %eax
	mov	%ecx, %edx
0:
	mov	%eax, (%esp)
	mov	%edx, 4(%esp)

	cmp	$1, %eax	/* ZF=0 predicted */
	jne	1f
	test	%edx, %edx	/* ZF=0 predicted */
	jz	done4
1:
	sub	$1, %esi	/* CF=0 assumed since P[0] odd */
	cmp	%esi, %eax	/* ZF=0 predicted */
	jne	2f
	cmp	%edi, %edx	/* ZF=0 predicted */
	jz	done4
2:

	/* %ecx:%ebx <-- P[1]*floor(R[1]*n/P[1]) */
	mov	72(%esp), %esi
	mov	%esi, %eax
	mov	40(%esp), %ebx
	mov	44(%esp), %ecx
	mul	%ebx
	imul	%esi, %ecx
	imul	76(%esp), %ebx
	add	%edx, %ecx
	add	%ebx, %ecx
	mov	%eax, %ebx

	/* %edx:%eax <-- R[1]*n */
	mov	8(%esp), %eax
	mov	12(%esp), %edi
	mul	%ebp
	imul	%ebp, %edi
	add	%edi, %edx

	/* %edx:%eax <-- R[1]*n - P[1]*floor(R[1]*n/P[1]) */
	sub	%ebx, %eax
	sbb	%ecx, %edx

	mov	76(%esp), %edi
	mov	%eax, %ebx
	mov	%edx, %ecx

	sub	%esi, %ebx
	sbb	%edi, %ecx	/* >= predicted */
	jl	0f
	mov	%ebx, %eax
	mov	%ecx, %edx

0:
	mov	%eax, 8(%esp)
	mov	%edx, 12(%esp)

	cmp	$1, %eax	/* ZF=0 predicted */
	jne	1f
	test	%edx, %edx	/* ZF=0 predicted */
	jz	done4
1:
	sub	$1, %esi	/* CF=0 assumed since P[1] odd */
	cmp	%esi, %eax	/* ZF=0 predicted */
	jne	2f
	cmp	%edi, %edx	/* ZF=0 predicted */
	jz	done4
2:

	/* %ecx:%ebx <-- P[2]*floor(R[2]*n/P[2]) */
	mov	80(%esp), %esi
	mov	%esi, %eax
	mov	48(%esp), %ebx
	mov	52(%esp), %ecx
	mul	%ebx
	imul	%esi, %ecx
	imul	84(%esp), %ebx
	add	%edx, %ecx
	add	%ebx, %ecx
	mov	%eax, %ebx

	/* %edx:%eax <-- R[2]*n */
	mov	16(%esp), %eax
	mov	20(%esp), %edi
	mul	%ebp
	imul	%ebp, %edi
	add	%edi, %edx

	/* %edx:%eax <-- R[2]*n - P[2]*floor(R[2]*n/P[2]) */
	sub	%ebx, %eax
	sbb	%ecx, %edx

	mov	84(%esp), %edi
	mov	%eax, %ebx
	mov	%edx, %ecx

	sub	%esi, %ebx
	sbb	%edi, %ecx	/* >= predicted */
	jl	0f
	mov	%ebx, %eax
	mov	%ecx, %edx

0:
	mov	%eax, 16(%esp)
	mov	%edx, 20(%esp)

	cmp	$1, %eax	/* ZF=0 predicted */
	jne	1f
	test	%edx, %edx	/* ZF=0 predicted */
	jz	done4
1:
	sub	$1, %esi	/* CF=0 assumed since P[2] odd */
	cmp	%esi, %eax	/* ZF=0 predicted */
	jne	2f
	cmp	%edi, %edx	/* ZF=0 predicted */
	jz	done4
2:

	/* %ecx:%ebx <-- P[3]*floor(R[3]*n/P[3]) */
	mov	88(%esp), %esi
	mov	%esi, %eax
	mov	56(%esp), %ebx
	mov	60(%esp), %ecx
	mul	%ebx
	imul	%esi, %ecx
	imul	92(%esp), %ebx
	add	%edx, %ecx
	add	%ebx, %ecx
	mov	%eax, %ebx

	/* %edx:%eax <-- R[3]*n */
	mov	24(%esp), %eax
	mov	28(%esp), %edi
	mul	%ebp
	imul	%ebp, %edi
	add	%edi, %edx

	/* %edx:%eax <-- R[3]*n - P[3]*floor(R[3]*n/P[3]) */
	sub	%ebx, %eax
	sbb	%ecx, %edx

	mov	92(%esp), %edi
	mov	%eax, %ebx
	mov	%edx, %ecx

	sub	%esi, %ebx
	sbb	%edi, %ecx	/* >= predicted */
	jl	0f
	mov	%ebx, %eax
	mov	%ecx, %edx

0:
	mov	%eax, 24(%esp)
	mov	%edx, 28(%esp)

	cmp	$1, %eax	/* ZF=0 predicted */
	jne	1f
	test	%edx, %edx	/* ZF=0 predicted */
	jz	done4
1:
	sub	$1, %esi	/* CF=0 assumed since P[3] odd */
	cmp	%esi, %eax	/* ZF=0 predicted */
	jne	2f
	cmp	%edi, %edx	/* ZF=0 predicted */
	jz	done4
2:

	mov	104(%esp), %edx
test4:
	mov	(%edx), %ebp
	cmp	%ebp, 136(%esp)
	jae	loop4

	xor	%ebp, %ebp

done4:
	fstp	%st(0)
	fstp	%st(0)
	fstp	%st(0)
	fstp	%st(0)

	fldcw	96(%esp)

	mov	%ebp, %eax

	add	$108, %esp
	pop	%edi
	pop	%esi
	pop	%ebp
	pop	%ebx

	ret
