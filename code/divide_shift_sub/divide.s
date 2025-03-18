	.text
	b	program
	b	.
program:
	ldr	sp, stack_top_addr
	bl	main
	b	.

stack_top_addr:
	.word	stack_top

/*---------------------------------------------------------------------
int main() {
	q = division(d, e);
	r = division(43, 7);
}
*/

main:
	push	lr
	ldr	r0, d_addr
	ldr	r0, [r0]
	ldr	r1, e_addr
	ldr	r1, [r1]
	bl	divide
	ldr	r1, q_addr
	str	r0, [r1]
	mov	r0, #43
	mov	r1, #7
	bl	divide
	ldr	r1, r_addr
	str	r0, [r1]
	pop	lr
	mov	pc, lr

d_addr:
	.word	d
e_addr:
	.word	e
q_addr:
	.word	q
r_addr:
	.word	r

/*--------------------------------------------------------------------
<r0> uint16_t divide(<r0> uint16_t dividend, <r1> uint16_t divisor) {
	<r2> uint16_t i = 16;
	<r3> uint16_t rest = 0, <r4> quocient = 0;
	do {
		uint16_t dividend_bit = dividend >> 15;
		dividend <<= 1;
		rest <<= 1;
		quotient <<= 1;
		rest += dividend_bit;
		if (rest >= divisor) {
			rest -= divisor;
			quotient += 1;
		}
	} while (--i > 0);
	return quotient;
}
*/

divide:
	push	r4
	mov	r3, #0		; rest = 0;
	mov	r4, #0		; quocient = 0;
	mov	r2, #16		; uint16_t i = 16;
div_while:			; uint16 dividend_msb = dividend >> 15;
	lsl	r0, r0, #1	; dividend <<= 1;
	adc	r3, r3, r3	; rest <<= 1; rest += dividend_bit;
	lsl	r4, r4, #1	; quotient <<= 1;
	cmp	r3, r1		; if (rest >= divisor) {
	blo	div_if_end
	sub	r3, r3, r1	; rest -= divisor;
	add	r4, r4, #1	; quotient += 1;
div_if_end:
	sub	r2, r2, #1	; } while (--i > 0);
	bne	div_while
	mov	r0, r4		; return quotient;
	pop	r4
	mov	pc, lr

;-----------------------------------------------------------------------
;	Secção onde são alojadas as variáveis

	.data
/*---------------------------------------------------------------------
uint16_t q, r, d = 200, e = 10;

*/
	.data
q:
	.word	0
r:
	.word	0
d:
	.word	200
e:
	.word	10

;-------------------------------------------------------------------------------
;	Reserva de área de memória para Stack

	.stack

	.equ    STACK_MAX_SIZE, 1024
	.space	STACK_MAX_SIZE * 2
stack_top:

