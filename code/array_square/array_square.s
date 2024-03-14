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
	.bss

	.stack
	.space	128
stack_top:

/*------------------------------------------------------
uint8_t array[] = 20, 10, 4, 6;

uint16_t result[4];

*/

	.data
array:
	.byte	20, 10, 4, 6

	.bss
result:
	.space	4 * 2

/*------------------------------------------------------
int main() {
	array_square(result, array, 4);
}
*/
	.text
main:
	push	lr

	ldr	r0, result_addr
	ldr	r1, array_addr
	mov	r2, #4
	bl	array_square
	pop	pc

result_addr:
	.word	result
array_addr:
	.word	array

/* ---------------------------------------------------------------------
uint16_t multiply(uint8_t, uint8_t);

void array_square(<r0><r4> uint16_t result[], <r1><r5> uint8_t array[], <r2><r6> uint16_t array_size) {
	for (<r7> uint16_t i = 0; i < array_size; ++i)
		result[i] = multiply(array[i], array[i]);
}
*/
array_square:
	push	lr
	push	r4
	push	r5
	push	r6
	push	r7
	mov	r4, r0	; uint16_t result[]
	mov	r5, r1	; uint8_t array[]
	mov	r6, r2	; uint16_t array_size
	mov	r7, #0	; uint16_t i = 0
array_square_for:
	cmp	r7, r6
	bhs	array_square_for_end
	ldr	r0, [r5, r7]
	mov	r1, r0
	bl	multiply
	add	r1, r7, r7
	str	r0, [r4, r1]
	add	r7, r7, #1
	b	array_square_for
array_square_for_end:
	pop	r7
	pop	r6
	pop	r5
	pop	r4
	pop	pc

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
