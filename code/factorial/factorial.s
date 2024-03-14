	.section .startup
	b	_start
	b	.

_start:
	ldr	sp, stack_top_addr
	mov	r0, pc
	add	lr, r0, #4
	ldr	pc, main_addr
	b	.

stack_top_addr:
	.word	stack_top

main_addr:
	.word	main

	.text
	.data

	.section .stack
	.equ	STACK_SIZE, 1024
	.space	STACK_SIZE
stack_top:

/*-------------------------------------------------------------
uint16_t a = 8;
uint16_t fa, fb;

int main() {
    fa = factorial(a);
    fb = factorial(9);
}
*/
	.data
a:
	.word	8

	.bss
fa:
	.word	0
fb:
	.word	0

	.text
main:
	push	lr

	ldr	r0, a_addr
	ldr	r0, [r0]
	bl	factorial
	ldr	r2, fa_addr
	str	r0, [r2]

	mov	r0, #9
	bl	factorial
	ldr	r2, fb_addr
	str	r0, [r2]

	pop	pc

a_addr:
	.word	a
fa_addr:
	.word	fa
fb_addr:
	.word	fa

/*------------------------------------------------------------

uint16_t factorial(<r0><r4>uint16_t n) {
	if (n == 0)
		return 1;
	else {
		uint32_t <r1:r0> tmp = n * factorial(n - 1);
		return tmp < UINT16_MAX ? tmp : UINT16_MAX;
	}
}
*/
	.equ	UINT16_MAX, 0xffff

factorial:
	add	r0, r0, #0	; if (n == 0)
	beq	return_1
	push	lr
	push	r4
	mov	r4, r0
	sub	r0, r0, #1	; factorial(n - 1)
	bl	factorial
	mov	r1, r4
	bl	multiply	; n * factorial(n - 1)
	add	r1, r1, #0	; tmp > UINT16_MAX ?
	bzs	return_tmp
	mov	r0, #UINT16_MAX & 0xff
	movt	r0, #UINT16_MAX >> 8
return_tmp:
	pop	r4
	pop	pc
return_1:
	mov	r0, #1	; return 1
	mov	pc, lr

/*-------------------------------------------------------------
uint32_t multiply(<r0> uint16_t multiplicand, <r1> uint16_t multiplier)) {
	<r2:r0> uint32_t multiplicandi = (uint32_t) multiplicand;
	<r4:r3> uint32_t product = 0;
	while ( multiplier > 0 ) {
		if ( (multiplier & 1) != 0 )
			product += multiplicandi;
		multiplier >>= 1;
		multiplicandi <<= 1;
	}
	<r1:r0> return product;
}
*/
multiply:
	push	r4
	mov	r2, #0	; <r2:r0> uint32_t multiplicandi = (uint32_t) multiplicand;
	mov	r3, #0	; <r4:r3> uint32_t product = 0;
	mov	r4, #0
multiply_while:
	add	r1, r1, #0	; while ( multiplier > 0 )
	beq	multiply_return
	lsr	r1, r1, #1	; if ( (multiplier & 1) != 0 )
	bcc	multiply_if_end
	add	r3, r3, r0	; product += multiplicandi;
	adc	r4, r4, r2
multiply_if_end:
	lsl	r0, r0, #1	; multiplicandi <<= 1;
	adc	r2, r2, r2
	b	multiply_while
multiply_return:
	mov	r0, r3		; <r1:r0> return product;
	mov	r1, r4
	pop	r4
	mov	pc, lr
