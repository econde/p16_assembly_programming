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

/*-----------------------------------------------------------------------
#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))

int16_t array[] = { 20, -3, 45, 7, 5, -9, 0, -1, 15, 2};

int main() {
	sort(array, ARRAY_SIZE(array));
}
*/
	.data
array:
	.word	20, 3, 45, 7, 5, 9, 15, 2
array_end:

	.equ	ARRAY_SIZE, (array_end - array) / 2

	.text
main:
	push	lr
	ldr	r0, array_addr
	mov	r1, #ARRAY_SIZE
	bl	sort
	pop	pc

array_addr:
	.word	array

/*-----------------------------------------------------------------------
void sort(<r0> int16_t a[], <r1> uint16_t dim) {
	<r2> _Bool swapped;
	do {
		swapped = false;
		for (<r3> uint16_t i = 0; i < dim - 1; i++)
			if ( a[i] > a[i + 1]) {
				int aux = a[i];
				a[i] = a[i + 1];
				a[i + 1] = aux;
				swapped = true;
			};
		dim--;
	} while (swapped);
}
*/

	.equ	false, 0
	.equ	true, !false
sort:
	push	r4
	push	r5
	push	r6
	sub	r1, r1, #1	; dim - 1
sort_do:
	mov	r2, #false	; do {
	mov	r3, #0		; i = 0
sort_for:
	cmp	r3, r1		; i – (dim - 1)
	bhs	sort_for_end	; if (i < dim-1)
	add	r4, r3, r3
	ldr	r5, [r0, r4]	; r5 = a[i]
	add	r4, r4, #2
	ldr	r6, [r0, r4]	; r6 = a[i + 1]
	cmp	r6, r5		; a[i + 1] - a[i]
	bge	sort_if_end	; if (a[i] < a[i + 1])
	str	r5, [r0, r4]	; troca a[i] com a[i + 1]
	sub	r4, r4, #2
	str	r6, [r0, r4]
	mov	r2, #true	; swap = true
sort_if_end:
	add	r3, r3, #1	; i++
	b	sort_for
sort_for_end:
	sub	r1, r1, #1	; dim--
	mov	r4, #true
	cmp	r2, r4
	beq	sort_do		; } while (swapped)
	pop	r6
	pop	r5
	pop	r4
	mov	pc, lr		; return
