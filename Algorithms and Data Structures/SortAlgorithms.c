#import "SortAlgorithms.h"
#import <strings.h>
#import <sys/types.h>

void sort(uint *array, uint count, uint max_value)
{
	// Counting
	uint counters[max_value];
	bzero(counters, max_value*sizeof(uint));
	for (uint i = 0; i < count; ++i)
	{
		uint value = array[i];
		counters[value] += 1;
	}

	// Filling
	uint cursor = 0;
	for (uint value = 0; value < max_value; ++value)
	{
		for (uint counter = counters[value]; counter > 0; --counter)
		{
			array[cursor] = value;
			++cursor;
		}
	}
}