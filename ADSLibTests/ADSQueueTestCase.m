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
#import "ADSSerialQueue.h"

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
	ADSSerialQueue *queue = [ADSSerialQueue new];
	[queue pushObject:@0];
	[queue pushObject:@1];
	for (int i = 0; i <= 1; ++i)
	{
		id obj = [queue popObject];
		XCTAssertEqualObjects(@(i), obj);
	}
	XCTAssertEqual(queue.count, 0);
}

- (void) testFastEnumeration
{
	ADSSerialQueue *queue = [ADSSerialQueue new];

	NSArray *original = @[@1,@2,@3];
	for (id obj in original)
	{
		[queue pushObject:obj];
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
	ADSSerialQueue *queue = [ADSSerialQueue queue];

	for (id obj in @[@1,@2,@3])
	{
		[queue pushObject:obj];
	}

	NSMutableArray *result = [NSMutableArray new];
	for (NSNumber *obj in queue)
	{
		[result addObject:obj];
		if ([obj isEqualToNumber:@3])
		{
			[queue pushObject:@4];
		}
	}

	id a = @[@(1),@(2),@(3),@(4)];
	XCTAssertEqualObjects(result, a);
	XCTAssertEqual(queue.count, 0);
}

- (void) testThreadSafety
{
	ADSSerialQueue *queue = [ADSSerialQueue new];
	NSUInteger count = 1000;
	for (NSUInteger i = 0; i < count; ++i)
	{
		[queue pushObject:@(i)];
	}
	[queue enableThreadSafety];
	
	NSMutableArray *result = [NSMutableArray new];
	dispatch_semaphore_t lock = dispatch_semaphore_create(1);
	dispatch_group_t group = dispatch_group_create();

	for (NSUInteger i = 0; i < 4; ++i)
	{
		dispatch_group_async(group, dispatch_queue_create("Test Queue", DISPATCH_QUEUE_CONCURRENT), ^{
			for (id object in queue)
			{
				dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
				[result addObject:object];
				dispatch_semaphore_signal(lock);
			}
		});
	}

	dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

	XCTAssertEqual(result.count, count);
	XCTAssertEqual(queue.count, 0);
}
@end
