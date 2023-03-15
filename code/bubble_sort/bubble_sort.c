#include <stdint.h>
#include <stdbool.h>

void bubble_sort(uint16_t a[], int dim)  {
    _Bool swapped;
    do {
        swapped = false;
        for (int i = 0; i < dim - 1; i++)
            if ( a[i] > a[i + 1]) {
                int aux = a[i];
                a[i] = a[i + 1];
                a[i + 1] = aux;
                swapped = true;
            };
        dim--;
    } while (swapped);
}

#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))

int16_t array[] = { 20, -3, 45, 7, 5, -9, 0, -1, 15, 2};

int main() {
	bubble_sort(array, ARRAY_SIZE(array));
}
