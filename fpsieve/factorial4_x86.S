/* factorial4_x86.S -- Geoffrey Reynolds, December 2008.

   int factorial4_x86(int n0, int n1, const uint64_t *F, const uint64_t *P)
	__attribute__ ((pure));

   P is an array of 4 odd primes.
   F[0-3] = n0! mod P[0-3].
   n0, n1 are positive integers.

   Assumes n0 < n1 < 2^31.
   Assumes p < 2^62 for all p in P.
   Assumes stack is 16-aligned.

   Returns the least n in (n0,n1] such that n!+/-1 is divisible by some p in P.
   Returns zero if there is no such n.
*/

	.text

#if defined(_WIN32) || defined(__APPLE__)
# define FUN_NAME _factorial4_x86
#else
# define FUN_NAME factorial4_x86
#endif

	.p2align 4,,15
	.globl	FUN_NAME

FUN_NAME:
	push	%ebx
	push	%ebp
	push	%esi
	push	%edi
	sub	$108, %esp

/*	140(%esp) P
	136(%esp) F
	132(%esp) n1
	128(%esp) n0
	124(%esp) return addr
	120(%esp) ebx
	116(%esp) ebp
	112(%esp) esi
	108(%esp) edi
	104(%esp) n1
	100(%esp) new_cw
	 96(%esp) old_cw
	 64(%esp) P[0-3]
	   (%esp) FPU transfer	*/

	fnstcw	96(%esp)
	mov	96(%esp), %ax
	or	$0x0F00, %ax		/* Round to zero, extended precision */
	mov	%ax, 100(%esp)
	fldcw   100(%esp)

	mov	140(%esp), %ecx		/* P */

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

	mov	136(%esp), %ecx		/* F */

	/* R[0-3] <-- F[0-3] */
	mov	(%ecx), %eax
	mov	4(%ecx), %edx
	mov	%eax, (%esp)
	mov	%edx, 4(%esp)
	mov	8(%ecx), %eax
	mov	12(%ecx), %edx
	mov	%eax, 8(%esp)
	mov	%edx, 12(%esp)
	mov	16(%ecx), %eax
	mov	20(%ecx), %edx
	mov	%eax, 16(%esp)
	mov	%edx, 20(%esp)
	mov	24(%ecx), %eax
	mov	28(%ecx), %edx
	mov	%eax, 24(%esp)
	mov	%edx, 28(%esp)

	fildl	128(%esp)	/* n0 */
	mov	132(%esp), %eax	/* n1 */
	mov	128(%esp), %ebp	/* n0 */
	mov	%eax, 104(%esp)	/* n1 */

	.p2align 4,,15
loop4:
/*	%st(0)		n
	%st(1-4)	1/P[0-3]
	%esp		R
	%ebp		n
*/
	add	$1, %ebp
	fld1
	faddp	%st(0), %st(1)

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
	fmul	%st(1), %st(0)
	fmul	%st(5), %st(0)
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

	cmp	%ebp, 104(%esp)
	ja	loop4

	xor	%ebp, %ebp

done4:
	fstp	%st(0)
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
