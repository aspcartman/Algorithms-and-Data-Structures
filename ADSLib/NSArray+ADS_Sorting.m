//
// Created by ASPCartman on 28/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "NSArray+ADS_Sorting.h"
#import "NSMutableArray+ADS_Sorting.h"

@implementation NSArray (ADS_Sorting)
- (NSArray*) ads_sortedArrayWithComparator:(NSComparator)comparator
{
	NSMutableArray *mutableCopy = [self mutableCopy];
	[mutableCopy ads_sortArrayByCountingWithComparator:comparator];
	return [mutableCopy copy];
}
@end