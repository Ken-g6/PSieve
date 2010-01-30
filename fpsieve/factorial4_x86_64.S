/* factorial4_x86_64.S -- Geoffrey Reynolds, December 2008.

   int factorial4_x86_64(int n0, int n1, const uint64_t *F, const uint64_t *P)
     __attribute__ ((pure));

   P is an array of 4 primes.
   F[0-3] = n0! mod P[0-3].
   n0, n1 are positive integers.

   Assumes p < 2^51 for all p in P.
   Assumes n0 < n1 < 2^25. (but 2^25 < n0 < n1 < 2^31 allowed if p > n).

   Returns the least n in (n0,n1] such that n!+/-1 is divisible by some p in P.
   Returns zero if there is no such n.
*/

	.text

#if defined(_WIN32) || defined(__APPLE__)
# define FUN_NAME _factorial4_x86_64
#else
# define FUN_NAME factorial4_x86_64
#endif

	.p2align 4,,15
	.globl	FUN_NAME

FUN_NAME:
	push	%rbp
	push	%rbx
	push	%r12
	push	%r13
	push	%r14
	push	%r15

#if _WIN64
	push	%rsi
	push	%rdi
	sub	$88, %rsp
	movdqa	%xmm6, 32(%rsp)
	movdqa	%xmm7, 48(%rsp)
	movdqa	%xmm8, 64(%rsp)

#define old_mxcsr 80(%rsp)
#define new_mxcsr 84(%rsp)
#define M0   (%rsp)
#define M1  8(%rsp)
#define M2 16(%rsp)
#define M3 24(%rsp)

#else
/* Red zone */
#define old_mxcsr -4(%rsp)
#define new_mxcsr -8(%rsp)
#define M0 -16(%rsp)
#define M1 -24(%rsp)
#define M2 -32(%rsp)
#define M3 -40(%rsp)
#endif

	stmxcsr	old_mxcsr
	mov	old_mxcsr, %eax
	or	$0x6000, %eax		/* Round to zero */
	mov	%eax, new_mxcsr
	ldmxcsr	new_mxcsr

#if _WIN64
	mov	%ecx, %eax	/* n0 */
	mov	%edx, %esi	/* n1 */

	mov	(%r8), %rbp
	mov	8(%r8), %rbx
	mov	16(%r8), %rcx
	mov	24(%r8), %rdx

	mov	24(%r9), %r11
	mov	16(%r9), %r10
	mov	(%r9), %r8
	mov	8(%r9), %r9
#else
	mov	%edi, %eax
	
	mov	(%rcx), %r8
	mov	8(%rcx), %r9
	mov	16(%rcx), %r10
	mov	24(%rcx), %r11

	mov	(%rdx), %rbp
	mov	8(%rdx), %rbx
	mov	16(%rdx), %rcx
	mov	24(%rdx), %rdx
#endif

	mov	$1, %edi
	cvtsi2sd %edi, %xmm5
	cvtsi2sd %edi, %xmm6
	cvtsi2sd %edi, %xmm7
	cvtsi2sd %edi, %xmm8

	cvtsi2sd %r8, %xmm1
	cvtsi2sd %r9, %xmm2
	cvtsi2sd %r10, %xmm3
	cvtsi2sd %r11, %xmm4

	divsd	%xmm1, %xmm5
	divsd	%xmm2, %xmm6
	divsd	%xmm3, %xmm7
	divsd	%xmm4, %xmm8

	lea	-1(%r8), %r12
	lea	-1(%r9), %r13
	lea	-1(%r10), %r14
	lea	-1(%r11), %r15

	mov	%r12, M0
	mov	%r13, M1
	mov	%r14, M2
	mov	%r15, M3

	.p2align 4,,15
loop4:
/*	%xmm5-8		1/P[0-3]
	%r8-%r11	P[0-3]
	%rbp,%rbx-%rdx	F[0-3]
	%esi		n1
	%eax		n
*/
	add	$1, %eax

	cvtsi2sd %rbp, %xmm1
	cvtsi2sd %eax, %xmm0
	cvtsi2sd %rbx, %xmm2
	cvtsi2sd %rcx, %xmm3
	cvtsi2sd %rdx, %xmm4

	imul	%rax, %rbp
	imul	%rax, %rbx
	imul	%rax, %rcx
	imul	%rax, %rdx

	mulsd	%xmm0, %xmm1
	mulsd	%xmm0, %xmm2
	mulsd	%xmm0, %xmm3
	mulsd	%xmm0, %xmm4

	mulsd	%xmm5, %xmm1
	mulsd	%xmm6, %xmm2
	mulsd	%xmm7, %xmm3
	mulsd	%xmm8, %xmm4

	cvtsd2si %xmm1, %r12
	cvtsd2si %xmm2, %r13
	cvtsd2si %xmm3, %r14
	cvtsd2si %xmm4, %r15

	imul	%r8, %r12
	imul	%r9, %r13
	imul	%r10, %r14
	imul	%r11, %r15

	sub	%r12, %rbp
	sub	%r13, %rbx
	sub	%r14, %rcx
	sub	%r15, %rdx

	mov	%rbp, %r12
	mov	%rbx, %r13
	mov	%rcx, %r14
	mov	%rdx, %r15

	sub	%r8, %r12
	jl	0f
	mov	%r12, %rbp
0:	sub	%r9, %r13
	jl	1f
	mov	%r13, %rbx
1:	sub	%r10, %r14
	jl	2f
	mov	%r14, %rcx
2:	sub	%r11, %r15
	jl	3f
	mov	%r15, %rdx
3:

	cmp	$1, %rbp
	je	done4
	cmp	M0, %rbp
	je	done4
	cmp	$1, %rbx
	je	done4
	cmp	M1, %rbx
	je	done4
	cmp	$1, %rcx
	je	done4
	cmp	M2, %rcx
	je	done4
	cmp	$1, %rdx
	je	done4
	cmp	M3, %rdx
	je	done4

	cmp	%eax, %esi
	ja	loop4

	xor	%eax, %eax

done4:
	ldmxcsr	old_mxcsr

#if _WIN64
	movdqa	32(%rsp), %xmm6
	movdqa	48(%rsp), %xmm7
	movdqa	64(%rsp), %xmm8
	add	$88, %rsp
	pop	%rdi
	pop	%rsi
#endif

	pop	%r15
	pop	%r14
	pop	%r13
	pop	%r12
	pop	%rbx
	pop	%rbp

	ret
