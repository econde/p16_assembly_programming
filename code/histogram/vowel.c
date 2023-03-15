#include <stdint.h>

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

void histogram_vowel(uint8_t phrase[], uint16_t max_letters, uint16_t occurrences[5]) {
	for (uint16_t i = 0; phrase[i] != '\0' && i < max_letters ; i++ ) {
		int16_t idx;
		if ( (idx = find_vowel(phrase[i]) ) != -1 ) {
			occurrences[idx]++;
		}
	}
}

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
