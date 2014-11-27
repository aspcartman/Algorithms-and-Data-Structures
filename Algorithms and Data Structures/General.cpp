#include "General.h"

#include <iostream>

template<typename T>
void printArray(T *array, size_t count)
{
	for (size_t i = 0; i < count; ++i)
	{
		std::cout << array[i] << ' ';
	}
	std::cout << std::endl;
}


#define C_TEMPLATE_IMPLEMENTATION(T)\
extern "C" void printArray_##T(T *array, size_t count)\
{\
    return printArray(array, count);\
}

ALL_TYPES_1(C_TEMPLATE_IMPLEMENTATION)
#undef C_TEMPLATE_IMPLEMENTATION