//
//  ADSArraySortByCountingTestCase.m
//  Algorithms and Data Structures
//
//  Created by ASPCartman on 28/11/14.
//  Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSArray+ADS_Search.h"

#define TEST_SIZE 1000000

@interface ADSArraySearchBinaryTestCase : XCTestCase
@end

@implementation ADSArraySearchBinaryTestCase
{
	__strong NSArray  *_testArray;
	__strong NSNumber *_searchElement;
	NSInteger         _elementIndex;
}

- (void) setUp
{
	[super setUp];
	if (!_testArray)
	{
		_searchElement = @(TEST_SIZE + 1);

		NSMutableArray  *testArray = [NSMutableArray new];
		for (NSUInteger i          = 0; i < TEST_SIZE; ++i)
		{
			[testArray addObject:@(arc4random() % TEST_SIZE)];
		}
		testArray[testArray.count - 1] = _searchElement;
		_testArray = [testArray sortedArrayUsingSelector:@selector(compare:)];
	}
}

- (void) testFinds
{
	XCTAssertEqual([_testArray ads_searchBinary:_searchElement withComparator:^(id a, id b) {
		return [a compare:b];
	}], _testArray.count - 1);
}

- (void) testMyPerfomance
{
	// This is an example of a performance test case.
	[self measureBlock:^{
		[_testArray ads_searchBinary:_searchElement withComparator:^(id a, id b) {
			return [a compare:b];
		}];
	}];
}

- (void) testStandardPerfomance
{
	[self measureBlock:^{
		[_testArray indexOfObject:_searchElement];
	}];
}
@end
