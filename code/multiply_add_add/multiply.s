;-------------------------------------------------------------------------------
;	Secção onde é alojado o código das instruções

	.text

	b	_start
	b	.

_start:
	ldr	sp, stack_top_addr
	bl	main
	b	.

stack_top_addr:
	.word	stack_top

/*
int main() {
	q = 4 * 7;
	p = m * n;
}

int main() {
	q = multiply(4, 7);
	p = multiply(m, n);
}
*/

main:

;	Código da função main e das restantes funções do programa

	push	lr

	mov	r0, #4
	mov	r1, #7
	bl	multiply
	ldr	r1, q_addr
	str	r0, [r1]

	ldr	r0, m_addr
	ldrb	r0, [r0]
	ldr	r1, n_addr
	ldrb	r1, [r1]
	bl	multiply
	ldr	r1, p_addr
	str	r0, [r1]

	pop	pc

m_addr:
	.word	m
n_addr:
	.word	n
p_addr:
	.word	p
q_addr:
	.word	q

/*
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

;-------------------------------------------------------------------------------
;	Secção onde são alojadas as variáveis

	.data

;	Definição das variáveis do programa

/*
uint8_t m = 20, n = 3;

uint16_t p, q;
*/

m:
	.byte	20
n:
	.byte	3
p:
	.word	0
q:
	.word	0

;-------------------------------------------------------------------------------
;	Reserva de área de memória para Stack

	.stack

	.equ    STACK_MAX_SIZE, 1024
	.space	STACK_MAX_SIZE * 2
stack_top:
