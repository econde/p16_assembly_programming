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
	.space	128
stack_top:

/*----------------------------------------------------------------
	uint16_t table1[] = {10, 20, 5, 6, 34, 9};
	uint16_t table2[] = {11, 22, 33};
	int16_t p, q;

	int main() {
		p = search(table1, sizeof table1 / sizeof table1[0], 20);
		q = search(table2, sizeof table2 / sizeof table2[0], 31);
	}
*/
	.data
table1:
	.word	10, 20, 5, 6, 34, 9
table1_end:

table2:
	.word	11, 22, 33
table2_end:

	.bss
p:
	.word	0
q:
	.word	0

	.text
main:
	push	lr

	ldr	r0, table1_addr
	mov	r1, #(table1_end - table1) / 2
	mov	r2, #20
	bl	search
	ldr	r1, p_addr
	str	r0, [r1]

	ldr	r0, table2_addr
	mov	r1, #(table2_end - table2) / 2
	mov	r2, #44
	bl	search
	ldr	r1, q_addr
	str	r0, [r1]

	pop	pc

table1_addr:
	.word	table1
table2_addr:
	.word	table2
p_addr:
	.word	p
q_addr:
	.word	q

/*---------------------------------------------------------
<r0> int16_t search(<r0> uint16_t array[], <r1> uint8_t array_size, <r2> uint16_t value) {
	for (<r3> uint8_t i = 0; i < array_size && array[i] != value; ++i)
		;
	if( i < array_size)
		return i;
	return -1;
}
*/

	.text
search:
	push	r4
	mov	r3, #0		; i = 0
search_for:
	cmp	r3, r1		; i < array_size
	bhs	search_for_end
	add	r4, r3, r3
	ldr	r4, [r0, r4]	; array[i] != value
	cmp	r4, r2
	beq	search_for_end
	add	r3, r3, #1 	; ++i
	b	search_for
search_for_end:
	cmp	r3, r1		; if (i < array_size)
	bhs	search_if_end
	mov	r0, r3		; return i
	b	search_end
search_if_end:
	mov	r0, #0		; return -1
	sub	r0, r0, #1
search_end:
	pop	r4
	mov	pc, lr
