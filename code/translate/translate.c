#include<stdint.h>

uint8_t values1[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
uint8_t values2[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

void translate(uint8_t array1[], uint16_t index1,
			   uint8_t array2[], uint16_t index2, uint16_t size, uint8_t value) {
	for (uint16_t i = 0; i < size; i++, index1++, index2++) {
		array1[index1] = array2[index2] + value;
	}
}

void main(void) {
	translate(values1, 2, values2, 6, 3, 10);
}
