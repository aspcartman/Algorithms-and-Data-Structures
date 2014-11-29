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
#import "NSArray+ADS_Search.h"
#define TEST_SIZE 1000000

@interface ADSArraySearchLinearTestCase : XCTestCase
@end

@implementation ADSArraySearchLinearTestCase
{
	__strong NSArray  *_testArray;
	__strong NSNumber *_searchElement;
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
		testArray[testArray.count / 2] = _searchElement;
		_testArray = [testArray copy];
	}
}

- (void) testFinds
{
	XCTAssertEqual([_testArray ads_searchLinear:_searchElement], _testArray.count / 2);
}

- (void) testMyPerfomance
{
	// This is an example of a performance test case.
	[self measureBlock:^{
		[_testArray ads_searchLinear:_searchElement];
	}];
}

- (void) testStandardPerfomance
{
	[self measureBlock:^{
		[_testArray indexOfObject:_searchElement];
	}];
}
@end
