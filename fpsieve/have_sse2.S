/* have_sse2.S -- Geoffrey Reynolds, November 2008

   int have_sse2(void) __attribute__ ((const));

   Returns 1 if the processor supports SSE2, 0 if not.
*/

	.text

#if defined(_WIN32) || defined(__APPLE__)
# define FUN_NAME _have_sse2
#else
# define FUN_NAME have_sse2
#endif

	.p2align 4,,15
	.globl	FUN_NAME

FUN_NAME:
	push	%ebx

	xor	%eax, %eax
	cpuid
	test	%eax, %eax
	jz	0f

	mov	$1, %eax
	cpuid
	mov	%edx, %eax
	shr	$26, %eax
	and	$1, %eax

0:	pop	%ebx
	ret
