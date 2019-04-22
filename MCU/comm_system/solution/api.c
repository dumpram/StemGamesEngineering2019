#include <math.h>

#include "api.h"

#define REAL 0
#define IMAG 1

void dft(complex *input, complex *output, int N) {
	for (int i = 0; i < N; i++) {
		output[i][REAL] = 0;
		output[i][IMAG] = 0;
	}

	for (int k = 0; k < N; k++) {
		for (int i = 0; i < N; i++) {
			output[k][REAL] += input[i][REAL] * cos(2 * (M_PI * k * i) / N);
			output[k][IMAG] -= input[i][IMAG] * sin(2 * (M_PI * k * i) / N);
		}
	}
}

void idft(complex *input, complex *output, int N) {
	for (int i = 0; i < N; i++) {
		output[i][REAL] = 0;
		output[i][IMAG] = 0;
	}

	for (int k = 0; k < N; k++) {
		for (int i = 0; i < N; i++) {
			output[k][REAL] += input[i][REAL] * cos(2 * (M_PI * k * i) / N);
			output[k][IMAG] += input[i][IMAG] * sin(2 * (M_PI * k * i) / N);
		}
	}
}

double abs(complex c1, complex c2) {
   return sqrt( pow(c1[REAL], 2) + pow(c2[IMAG], 2) );
}

double angle(complex c) {
   return atan2( c[IMAG],c[REAL] );
}