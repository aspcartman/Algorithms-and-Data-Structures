#ifndef TEMPLATES_MACROSES_H_
#define TEMPLATES_MACROSES_H_

#include <stdint.h>

#define ALL_TYPES_1(MACRO)\
MACRO(float)\
MACRO(double)\
MACRO(int)\
MACRO(uint)\
MACRO(int8_t)\
MACRO(int16_t)\
MACRO(int32_t)\
MACRO(int64_t)\
MACRO(uint8_t)\
MACRO(uint16_t)\
MACRO(uint32_t)\
MACRO(uint64_t)

#define DYNAMIC_INT_ARGS uint8_t isSigned, uint8_t size
#define DYNAMIC_INT_IMPLEMENTATION(FUNC, ...)
#endif