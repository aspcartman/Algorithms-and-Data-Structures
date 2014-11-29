//
// Created by ASPCartman on 29/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "NSArray+ADS_Search.h"

@implementation NSArray (ADS_Search)
- (NSInteger) ads_searchLinear:(id)object
{
	for (NSInteger i = 0; i < self.count; ++i)
	{
		if ([self[(NSUInteger) i] isEqual:object])
		{
			return i;
		}
	}
	return NSNotFound;
}

- (NSInteger) ads_searchBinary:(id)object withComparator:(NSComparator)comparator
{
	NSUInteger low = 0, mid, high = self.count - 1;
	while (low <= high)
	{
		mid = low + (high - low) / 2;
		switch (comparator(self[mid], object))
		{
			case NSOrderedAscending:
				low = mid + 1;
				break;
			case NSOrderedSame:
				return mid;
			case NSOrderedDescending:
				high = mid - 1;
				break;
		}
	}
	return NSNotFound;
}
@end