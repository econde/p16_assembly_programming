#include <stdint.h>

uint16_t multiply(uint8_t, uint8_t);

void array_square(uint16_t result[], uint8_t array[], uint16_t array_size) {
	for (uint16_t i = 0; i < array_size; ++i)
		result[i] = multiply(array[i], array[i]);
}

