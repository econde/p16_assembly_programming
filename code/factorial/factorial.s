	.file	"factorial.c"
	.text
	.globl	factorial
	.type	factorial, @function
factorial:
.LFB0:
	.cfi_startproc
	endbr64
	testw	%di, %di
	jne	.L8
	movl	$1, %eax
	ret
.L8:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	leal	-1(%rdi), %edi
	movzwl	%di, %edi
	call	factorial
	movzwl	%ax, %edx
	movzwl	%bx, %eax
	imull	%edx, %eax
	movl	%eax, %ebx
	movl	$65535, %eax
	cmpl	%eax, %ebx
	cmovbe	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE0:
	.size	factorial, .-factorial
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movzwl	a(%rip), %edi
	call	factorial
	movw	%ax, fa(%rip)
	movl	$9, %edi
	call	factorial
	movw	%ax, fb(%rip)
	movl	$0, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.globl	fb
	.bss
	.align 2
	.type	fb, @object
	.size	fb, 2
fb:
	.zero	2
	.globl	fa
	.align 2
	.type	fa, @object
	.size	fa, 2
fa:
	.zero	2
	.globl	a
	.data
	.align 2
	.type	a, @object
	.size	a, 2
a:
	.value	8
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
