   	.section .startup
   	b	_start
   	b	.

   _start:
   	ldr	sp, addressof_stack_top
   	mov	r0, pc
   	add	lr, r0, #4
   	ldr	pc, addressof_main
   	b	.

   addressof_stack_top:
   	.word	stack_top

   addressof_main:
   	.word	main

   	.text
   	.data
	.bss

	.section .stack
	.space	128
stack_top:

/*------------------------------------------------------
uint8_t m = 20, n = 3;

uint16_t p, q;

*/

	.data
m:
	.byte	20
n:
	.byte	3

	.bss
p:
	.word	0
q:
	.word	0

/*------------------------------------------------------
int main() {
	q = 4 * 7;
	p = m * n;
}

int main() {
	q = multiply(4, 7);
	p = multiply(m, n);
}
*/
	.text
main:
	push	lr

	mov	r0, #4
	mov	r1, #7
	bl	multiply
	ldr	r1, addressof_q
	str	r0, [r1]

	ldr	r0, addressof_m
	ldrb	r0, [r0]
	ldr	r1, addressof_n
	ldrb	r1, [r1]
	bl	multiply
	ldr	r1, addressof_p
	str	r0, [r1]

	pop	pc

addressof_m:
	.word	m
addressof_n:
	.word	n
addressof_p:
	.word	p
addressof_q:
	.word	q

/*-----------------------------------------------------------
uint16_t multiply(<r0> uint8_t multiplicand, <r1> uint8_t multiplier)) {
	<r2> uint16_t product = 0;
	while ( multiplier > 0 ) {
		if ( (multiplier & 1) != 0 )
			product += multiplicand;
		multiplier >>= 1;
		multiplicand <<= 1;
	}
	<r0> return product;
}
*/
multiply:
	mov	r2, #0		; <r2> int product = 0;
mul_while:
	add	r1, r1, #0	; while ( multiplier > 0 )
	beq	mul_return
	lsr	r1, r1, #1	; if ( (multiplier & 1) != 0 )
	bcc	mul_if_end
	add	r2, r2, r0	; product += multiplicand;
mul_if_end:
	lsl	r0, r0, #1	; multiplicand <<= 1;
	b	mul_while
mul_return:
	mov	r0, r2
	mov	pc, lr		; <r0> return product;
