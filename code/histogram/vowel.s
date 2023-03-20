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
	.equ	STACK_SIZE, 1024
	.space	STACK_SIZE
stack_top:


/*------------------------------------------------------------------------------
int16_t find_vowel(uint8_t letter) {
	switch (letter) {
		case 'a':
			return 0;
		case 'e':
			return 1;
		case 'i':
			return 2;
		case 'o':
			return 3;
		case 'u':
			return 4;
		default:
			return -1;
	}
}
*/
	.text
find_vowel:
case_a:
	mov	r1, #'a'
	cmp	r0, r1
	bne	case_e
	mov	r0, #0
	mov	pc, lr
case_e:
	mov	r1, #'e'
	cmp	r0, r1
	bne	case_i
	mov	r0, #1
	mov	pc, lr
case_i:
	mov	r1, #'i'
	cmp	r0, r1
	bne	case_o
	mov	r0, #2
	mov	pc, lr
case_o:
	mov	r1, #'o'
	cmp	r0, r1
	bne	case_u
	mov	r0, #3
	mov	pc, lr
case_u:
	mov	r1, #'u'
	cmp	r0, r1
	bne	default
	mov	r0, #4
	mov	pc, lr
default:
	mov	r0, #-1 & 0xff
	movt	r0, #(-1 >> 8) & 0xff
	mov	pc, lr

/*------------------------------------------------------------------------------
void histogram_vowel(<r0> <r4> uint8_t phrase[], <r1> <r5> uint16_t max_letters,
			<r2> <r6> uint16_t occurrences[5]) {
	for (<r7> uint16_t i = 0; phrase[i] != '\0' && i < max_letters ; i++ ) {
		<r0> int16_t idx;
		if ( (idx = find_vowel(phrase[i]) ) != -1 )
			occurrences[idx]++;
	}
}
*/
	.text
histogram_vowel:
	push	lr
	push	r4
	push	r5
	push	r6
	mov	r4, r0
	mov	r5, r1
	mov	r6, r2
	mov	r7, #0
	b	for_cond
for:
	bl	find_vowel
	add	r1, r0, #1
	bzs	if_end
	add	r0, r0, r0	; escalar
	ldr	r1, [r6, r0]
	add	r1, r1, #1
	str	r1, [r6, r0]
if_end:
	add	r7, r7, #1
for_cond:
	ldrb	r0, [r4, r7]
	sub	r0, r0, #0
	beq	for_end
	cmp	r7, r5
	blo	for
for_end:
	pop	r6
	pop	r5
	pop	r4
	pop	pc

/*------------------------------------------------------------------------------

#define SIZE 5

#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))

uint16_t occurrences1[SIZE];
uint16_t occurrences2[SIZE];
uint16_t occurrences3[SIZE];

uint8_t phrase1[] = "aaeaa eiee ioi oa u";
uint8_t phrase2[] = "a ee iii oooo uuuuu";
uint8_t phrase3[] = "aeiou";

int main() {
	histogram_vowel(phrase1, ARRAY_SIZE(phrase1), occurrences1);
	histogram_vowel(phrase2, ARRAY_SIZE(phrase1), occurrences2);
	histogram_vowel(phrase3, ARRAY_SIZE(phrase1), occurrences3);
}
*/
	.bss
	.equ	SIZE, 5

occurrences1:
	.space	SIZE * 2
occurrences2:
	.space	SIZE * 2
occurrences3:
	.space	SIZE * 2

	.data
phrase1:
	.asciz	"aaeaa eiee ioi oa u"
phrase1_end:
phrase2:
	.asciz	"a ee iii oooo uuuuu"
phrase2_end:
phrase3:
	.asciz	"aeiou"
phrase3_end:

	.text

	.equ	PHRASE1_SIZE, (phrase1_end - phrase1) / 2
	.equ	PHRASE2_SIZE, (phrase2_end - phrase2) / 2
	.equ	PHRASE3_SIZE, (phrase3_end - phrase3) / 2

main:
	push	lr

	ldr	r0, addressof_phrase1
	mov	r1, #PHRASE1_SIZE
	ldr	r2, addressof_occurrences1
	bl	histogram_vowel

	ldr	r0, addressof_phrase2
	mov	r1, #PHRASE2_SIZE
	ldr	r2, addressof_occurrences2
	bl	histogram_vowel

	ldr	r0, addressof_phrase3
	mov	r1, #PHRASE3_SIZE
	ldr	r2, addressof_occurrences3
	bl	histogram_vowel

	pop	pc

addressof_phrase1:
	.word	phrase1
addressof_phrase2:
	.word	phrase2
addressof_phrase3:
	.word	phrase3

addressof_occurrences1:
	.word	occurrences1
addressof_occurrences2:
	.word	occurrences2
addressof_occurrences3:
	.word	occurrences3
