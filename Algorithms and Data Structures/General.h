#include <sys/types.h>

#ifdef __cplusplus
template <typename T>
extern void printArray(T array, size_t count);

extern "C" {
#endif

#include "TemplatesMacroses.h"

#define C_TEMPLATE_HEADER(T)\
extern void printArray_##T(T *array, size_t count);
ALL_TYPES_1(C_TEMPLATE_HEADER)
#undef C_TEMPLATE_HEADER

#ifdef __cplusplus
}
#endif