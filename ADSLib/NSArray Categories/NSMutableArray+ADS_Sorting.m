//
// Created by ASPCartman on 28/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "NSMutableArray+ADS_Sorting.h"

@implementation NSMutableArray (ADS_Sorting)
- (void) ads_sortArrayByCountingWithComparator:(NSComparator)comparator
{
	NSMutableDictionary *counters = [NSMutableDictionary new];

	// Count
	for (id value in self)
	{
		NSUInteger count = [counters[value] unsignedIntegerValue];
		counters[value] = @(count + 1);
	}

	[self removeAllObjects];

	// Sort values
	NSArray *sortedValues = [counters.allKeys sortedArrayUsingComparator:comparator];

	// Put back
	for (id value in sortedValues)
	{
		NSUInteger count = [counters[value] unsignedIntegerValue];
		while (count--)
		{
			[self addObject:value];
		}
	}
}
@end