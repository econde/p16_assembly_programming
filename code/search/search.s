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

	.section .stack
	.space	128
stack_top:

/*----------------------------------------------------------------
	#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
	uint16_t table1[] = {10, 20, 5, 6, 34, 9};
	uint16_t table2[] = {11, 22, 33};
	uint16_t p, q;

	int main() {
		p = search(table1, ARRAY_SIZE(table1), 20);
		q = search(table2, ARRAY_SIZE(table2), 31);
	}
*/
	.data
table1:
	.word	10, 20, 5, 6, 34, 9
table1_end:

table2:
	.word	11, 22, 33
table2_end:

	.equ	TABLE1_SIZE, (table1_end - table1) / 2

	.bss
p:
	.word	0
q:
	.word	0

	.text
main:
	push	lr
	ldr	r0, addressof_table1
	mov	r1, #TABLE1_SIZE
	mov	r2, #20
	bl	search
	ldr	r1, addressof_p
	str	r0, [r1]

	ldr	r0, addressof_table2
	mov	r1, #(table2_end - table2) / 2
	mov	r2, #44
	bl	search
	ldr	r1, addressof_q
	str	r0, [r1]
	pop	pc

addressof_table1:
	.word	table1
addressof_table2:
	.word	table2
addressof_p:
	.word	p
addressof_q:
	.word	q

/*---------------------------------------------------------
<r0> uint16_t search(<r0> uint16_t array[], <r1> uint8_t array_size,
		 <r2> uint16_t value) {
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
	mov	r3, #0		/* r3 - i */
search_for:
	cmp	r3, r1		/* i - array_size */
	bhs	search_for_end
	ldr	r4, [r0, r3]	/* array[i] != value */
	cmp	r4, r2
	beq	search_for_end
	add	r3, r3, #2 	/* ++i */
	b	search_for
search_for_end:
	cmp	r3, r1		/* if (i < array_size) */
	bhs	search_if_end
	lsr	r0, r3, #1	/* return i */
	b	search_end
search_if_end:
	mov	r0, #0		/* return -1 */
	sub	r0, r0, #1
search_end:
	pop	r4
	mov	pc, lr
