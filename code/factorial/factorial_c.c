#include <stdint.h>
#include <limits.h>

uint16_t factorial(uint16_t n) {
	if (n == 0)
		return 1;
	else {
		uint32_t tmp = n * factorial(n - 1);
		return tmp < UINT16_MAX ? tmp : UINT16_MAX;
	}
}

uint16_t a = 8;
uint16_t fa, fb;

int main() {
    fa = factorial(a);
    fb = factorial(9);
}
