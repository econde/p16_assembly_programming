	.section .startup
	b	_start
	b	.

_start:
	ldr	r0, bss_start_addr	; Preencher a secção bss com o zero
	ldr	r1, bss_end_addr
	mov	r2, #0
	b	_start_bss_zero_cond
_start_bss_zero:
	str	r2, [r0]
	add	r0, r0, #2
_start_bss_zero_cond:
	cmp	r0, r1
	blo	_start_bss_zero

	ldr	sp, stack_top_addr	; Inicializar SP no topo do stack

	mov	r0, pc			; Invocar a função main sem limitação de alcance
	add	lr, r0, #4
	ldr	pc, main_addr
	b	.

stack_top_addr:
	.word	stack_top
main_addr:
	.word	main
bss_start_addr:
	.word	bss_start
bss_end_addr:
	.word	bss_end

	.text
	.rodata
	.data
	.bss
bss_start:
	.section .bss_end
bss_end:

	.stack
	.equ	STACK_MAX_SIZE, 1024
	.space	STACK_MAX_SIZE * 2
stack_top:


/*------------------------------------------------------------------------------
int16_t find_vowel(char letter)
{
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
	mov	r1, #'a'	; case 'a':
	cmp	r0, r1
	bne	case_e
	mov	r0, #0		; return 0;
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
	mov	r0, #0		; return -1
	sub	r0, r0, #1
	mov	pc, lr

/*------------------------------------------------------------------------------
void histogram_vowel(<r0> <r4> char phrase[], <r1> <r5> uint16_t max_letters,
			<r2> <r6> uint16_t occurrences[5])
{
	for (<r7> uint16_t i = 0; phrase[i] != '\0' && i < max_letters ; i++ ) {
		<r0> int16_t index = find_vowel(phrase[i];
		if (index != -1)
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
	mov	r7, #0		; i = 0
	b	for_cond
for:
	bl	find_vowel	; phrase[i] é deixado em R0 no teste da condição do for
	add	r1, r0, #1	; (if (... != -1) (-1 + 1 == 0)
	bzs	if_end
	add	r0, r0, r0	; occurrences[idx]++
	ldr	r1, [r6, r0]	; index * 2 = index * sizeof(uint16_t)
	add	r1, r1, #1
	str	r1, [r6, r0]
if_end:
	add	r7, r7, #1
for_cond:
	ldrb	r0, [r4, r7]	; for(...; phrase[i] != '\0'
	sub	r0, r0, #0
	beq	for_end
	cmp	r7, r5		; && i < max_letters; ...)
	blo	for
for_end:
	pop	r6
	pop	r5
	pop	r4
	pop	pc

/*------------------------------------------------------------------------------

#define SIZE 5

uint16_t occurrences1[SIZE];
uint16_t occurrences2[SIZE];
uint16_t occurrences3[SIZE];

char phrase1[] = "aeiou";
char phrase2[] = "a ee iii oooo uuuuu";

int main()
{
	histogram_vowel(phrase1, 15, occurrences1);
	histogram_vowel(phrase2, 19, occurrences2);
	histogram_vowel("Hello world", 7, occurrences3);
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
	.asciz	"aeiou"
phrase2:
	.asciz	"a ee iii oooo uuuuu"

	.rodata
phrase3:
	.asciz	"Hello world"

	.text
main:
	push	lr

	ldr	r0, phrase1_addr
	mov	r1, #15
	ldr	r2, occurrences1_addr
	bl	histogram_vowel

	ldr	r0, phrase2_addr
	mov	r1, #19
	ldr	r2, occurrences2_addr
	bl	histogram_vowel

	ldr	r0, phrase3_addr
	mov	r1, #7
	ldr	r2, occurrences3_addr
	bl	histogram_vowel

	pop	pc

phrase1_addr:
	.word	phrase1
phrase2_addr:
	.word	phrase2
phrase3_addr:
	.word	phrase3

occurrences1_addr:
	.word	occurrences1
occurrences2_addr:
	.word	occurrences2
occurrences3_addr:
	.word	occurrences3
