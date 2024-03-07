#include <stdint.h>

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

void histogram_vowel(char phrase[], uint16_t max_letters, uint16_t occurrences[5])
{
	for (uint16_t i = 0; phrase[i] != '\0' && i < max_letters ; i++ ) {
		int16_t index = find_vowel(phrase[i]);
		if (index != -1)
			occurrences[index]++;
	}
}

#define SIZE 5

#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))

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
