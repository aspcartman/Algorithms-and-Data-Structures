//
//  ADSArraySortByCountingTestCase.m
//  Algorithms and Data Structures
//
//  Created by ASPCartman on 28/11/14.
//  Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSArray+ADS_Sorting.h"
#define TEST_SIZE 1000000

@interface ADSArraySortByCountingTestCase : XCTestCase

@end

@implementation ADSArraySortByCountingTestCase
{
	__strong NSArray *_testArray;
	__strong NSArray *_sortedTestArray;
}

- (void)setUp {
    [super setUp];
	if (!_testArray || !_sortedTestArray)
	{
		NSMutableArray *testArray = [NSMutableArray new];
		for (NSUInteger i = 0; i < TEST_SIZE; ++i)
		{
			[testArray addObject:@(arc4random()%2)];
		}
		_testArray = [testArray copy];

		_sortedTestArray = [testArray sortedArrayUsingSelector:@selector(compare:)];
	}
}

- (void) testSorts
{
	XCTAssertEqualObjects([_testArray ads_sortedArrayWithComparator:^(id a, id b){return [a compare:b];}], _sortedTestArray);
}

- (void)testMyPerfomance {
    // This is an example of a performance test case.
    [self measureBlock:^{
		[_testArray ads_sortedArrayWithComparator:^(id a, id b){return [a compare:b];}];
    }];
}

- (void) testStandardPerfomance
{
	[self measureBlock:^{
		[_testArray sortedArrayUsingSelector:@selector(compare:)];
	}];
}
@end
