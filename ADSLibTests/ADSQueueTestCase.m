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
#import "ADSTomInteger.h"
#import "ADSQueue.h"

#define TEST_SIZE 1000000

@interface ADSQueueTestCase : XCTestCase

@end

@implementation ADSQueueTestCase
{
}

- (void)setUp {
    [super setUp];
}

- (void) testWorks
{
	ADSQueue *queue = [ADSQueue new];
	[queue addObject:@0];
	[queue addObject:@1];
	for (int i = 0; i <= 1; ++i)
	{
		id obj = [queue popObject];
		XCTAssertEqualObjects(@(i), obj);
	}
	XCTAssertEqual(queue.count, 0);
}

- (void) testFastEnumeration
{
	ADSQueue *queue = [ADSQueue new];

	NSArray *original = @[@1,@2,@3];
	for (id obj in original)
	{
		[queue addObject:obj];
	}

	NSMutableArray *result = [NSMutableArray new];
	for (NSNumber *obj in queue)
	{
		[result addObject:obj];
	}

	XCTAssertEqualObjects(original, result);
}

- (void) testFastEnumerationMutable
{
	ADSQueue *queue = [ADSQueue threadSafeQueue];

	for (id obj in @[@1,@2,@3])
	{
		[queue addObject:obj];
	}

	NSMutableArray *result = [NSMutableArray new];
	for (NSNumber *obj in queue)
	{
		[result addObject:obj];
		if ([obj isEqualToNumber:@3])
		{
			[queue addObject:@4];
		}
	}

	id a = @[@(1),@(2),@(3),@(4)];
	XCTAssertEqualObjects(result, a);
	XCTAssertEqual(queue.count, 0);
}
@end
