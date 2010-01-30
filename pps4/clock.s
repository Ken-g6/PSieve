	.file	"clock.c"
	.text
	.p2align 4,,15
.globl processor_cycles
	.type	processor_cycles, @function
processor_cycles:
.LFB4:
#APP
# 65 "../clock.c" 1
	rdtsc
	shl     $32, %rdx
	or      %rdx, %rax
# 0 "" 2
#NO_APP
	ret
.LFE4:
	.size	processor_cycles, .-processor_cycles
	.p2align 4,,15
.globl processor_usec
	.type	processor_usec, @function
processor_usec:
.LFB3:
	subq	$152, %rsp
.LCFI0:
	xorl	%edi, %edi
	movq	%rsp, %rsi
	call	getrusage
	movq	16(%rsp), %rax
	addq	(%rsp), %rax
	imulq	$1000000, %rax, %rax
	addq	24(%rsp), %rax
	addq	8(%rsp), %rax
	addq	$152, %rsp
	ret
.LFE3:
	.size	processor_usec, .-processor_usec
	.p2align 4,,15
.globl elapsed_usec
	.type	elapsed_usec, @function
elapsed_usec:
.LFB2:
	subq	$24, %rsp
.LCFI1:
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday
	imulq	$1000000, (%rsp), %rax
	addq	8(%rsp), %rax
	addq	$24, %rsp
	ret
.LFE2:
	.size	elapsed_usec, .-elapsed_usec
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
	.long	.LFB4
	.long	.LFE4-.LFB4
	.uleb128 0x0
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB3
	.long	.LFE3-.LFB3
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB3
	.byte	0xe
	.uleb128 0xa0
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB2
	.long	.LFE2-.LFB2
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI1-.LFB2
	.byte	0xe
	.uleb128 0x20
	.align 8
.LEFDE5:
	.ident	"GCC: (Ubuntu 4.3.3-5ubuntu4) 4.3.3"
	.section	.note.GNU-stack,"",@progbits
