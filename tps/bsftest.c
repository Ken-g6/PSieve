#include <stdio.h>
#include <stdint.h>
//#include <string.h>
#include <inttypes.h>
//#include <getopt.h>

int main(void) {
	uint64_t i=1000000, imax;
	i = i*i;
	imax = i + 1000000;
	for(i=0; i < imax; ++i) {
		int j = __builtin_ctzll(i);
		i += j;
	}
	printf("Result is %"PRIu64"\n", i);
	return 0;
}
