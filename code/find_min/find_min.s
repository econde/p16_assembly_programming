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

	.stack
	.space	128
stack_top:

/*----------------------------------------------------------------
	uint16_t table1[] = {10, 20, 5, 6, 34, 9};
	uint16_t table2[] = {11, 22, 33};
	int16_t p, q;

	int main() {
		p = find_min(table1, sizeof table1 / sizeof table1[0]);
		q = find_min(table2, sizeof table2 / sizeof table2[0]);
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
	bl	find_min
	ldr	r1, p_addr
	str	r0, [r1]

	ldr	r0, table2_addr
	mov	r1, #(table2_end - table2) / 2
	bl	find_min
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
<r0> int16_t find_min(<r0> uint16_t array[], <r1> uint8_t array_size) {
	<r2> uint16_t min = array[0];
	for (<r3> uint8_t i = 1; i < array_size; ++i)
		if (array[i] < min)
			min = array[i];
	return min;
}
*/

	.text
find_min:
	push	r4
	ldr	r2, [r0]	; min = array[0];
	mov	r3, #0		; i = 0
find_min_for:
	cmp	r3, r1		; i < array_size
	bhs	search_for_end
	add	r4, r3, r3
	ldr	r4, [r0, r4]	; if (array[i] < min)
	cmp	r4, r2
	bhs	find_min_if_end
	mov	r2, r4		;min = array[i]
find_min_if_end:
	add	r3, r3, #1 	; ++i
	b	find_min_for
find_min_for_end:
	mov	r0, r2		; return min
	pop	r4
	mov	pc, lr
