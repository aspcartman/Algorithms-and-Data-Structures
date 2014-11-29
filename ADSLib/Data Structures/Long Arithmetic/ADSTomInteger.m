//
// Created by ASPCartman on 29/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "ADSTomInteger.h"

@implementation ADSTomInteger
{
	mp_int _tomInteger;
}

- (instancetype) init
{
	self = [super init];
	if (self)
	{
		int cResult = mp_init_set_int(&_tomInteger, 0);
		NSParameterAssert(cResult == MP_OKAY);
	}
	return self;
}

- (instancetype) initWithString:(NSString *)string base:(int)base
{
	self = [self init];
	if (self)
	{
		int cResult = mp_read_radix(&_tomInteger, [string cStringUsingEncoding:NSASCIIStringEncoding], base);
		NSParameterAssert(cResult == MP_OKAY);
	}
	return self;
}

- (instancetype) initWithNumber:(NSNumber *)number
{
	self = [self init];
	if (self)
	{
		int cResult = mp_set_int(&_tomInteger, number.unsignedLongValue);
		NSParameterAssert(cResult == MP_OKAY);
	}
	return self;
}


- (NSComparisonResult) compare:(ADSTomInteger *)otherInt
{
	int cResult = mp_cmp(&_tomInteger, &otherInt->_tomInteger);
	if (cResult == MP_GT)
	{
		return NSOrderedDescending;
	}
	if (cResult == MP_EQ)
	{
		return NSOrderedSame;
	}
	if (cResult == MP_LT)
	{
		return NSOrderedAscending;
	}

	NSAssert(0, @"Unreachable code");
	return (NSComparisonResult) INT_MAX;
}

- (ADSTomInteger *) multiply:(ADSTomInteger *)otherInt
{
	if (otherInt == nil)
	{
		return nil;
	}

	ADSTomInteger *result = [[ADSTomInteger alloc] init];
	int           cResult = mp_mul(&_tomInteger, &otherInt->_tomInteger, &result->_tomInteger);
	NSParameterAssert(cResult == MP_OKAY);

	return result;
}


- (NSString *) description
{
	char buffer[100] = { 0 };
	int  cResult     = mp_toradix_n(&_tomInteger, buffer, 16, 99);
	NSParameterAssert(cResult == MP_OKAY);

	if (buffer[0] == '-')
	{
		return [NSString stringWithFormat:@"-0x%s", buffer + 1];
	}
	else
	{
		return [NSString stringWithFormat:@"0x%s", buffer];
	}
}
@end