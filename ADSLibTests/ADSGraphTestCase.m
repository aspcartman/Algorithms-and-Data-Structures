//
// Created by ASPCartman on 24/12/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSArray+ADS_Sorting.h"
#import "ADSGraph.h"

#define TEST_SIZE 1000000

@interface ADSGraphTestCase : XCTestCase
@end

@implementation ADSGraphTestCase
{
}

- (void) testTopologicalSort
{
	NSString *task     = @"Task";
	NSString *subtask  = @"Subtask";
	NSString *task2    = @"Task2";
	NSString *subtask2 = @"Subtask2";

	ADSGraph *graph = [ADSGraph new];
	[graph addNode:task];
	[graph addNode:subtask2];
	[graph addNode:subtask];
	[graph addNode:task2];

	[graph addEdgeFrom:task to:subtask];
	[graph addEdgeFrom:task2 to:subtask2];

	NSArray *result       = [graph topologicallySortedArray];
	NSArray *actualResult = @[ task, task2, subtask, subtask2 ];
	XCTAssertEqualObjects(result, actualResult);
}

- (void) testStressFill
{
	ADSGraph         *graph = [ADSGraph new];
	static const int count  = 10000;

	[self measureBlock:^{
		for (int i = 0; i < count; ++i)
		{
			[graph addNode:[NSString stringWithFormat:@"Task%d", i]];
			[graph addNode:[NSString stringWithFormat:@"SubTask%d", i]];
			[graph addNode:[NSString stringWithFormat:@"SubSubTask%d", i]];
		}

		for (int i = 0; i < count; ++i)
		{
			[graph addEdgeFrom:[NSString stringWithFormat:@"Task%d", i]
							to:[NSString stringWithFormat:@"SubTask%d", i]];
			[graph addEdgeFrom:[NSString stringWithFormat:@"SubTask%d", i]
							to:[NSString stringWithFormat:@"SubSubTask%d", i]];
			if (i < count - 1)
			{
				[graph addEdgeFrom:[NSString stringWithFormat:@"Task%d", i]
								to:[NSString stringWithFormat:@"Task%d", i + 1]];
				[graph addEdgeFrom:[NSString stringWithFormat:@"SubTask%d", i]
								to:[NSString stringWithFormat:@"SubTask%d", i + 1]];
				[graph addEdgeFrom:[NSString stringWithFormat:@"SubSubTask%d", i]
								to:[NSString stringWithFormat:@"SubSubTask%d", i + 1]];
			}
		}
	}];
}

- (void) testStressTopologicalSort
{
	ADSGraph         *graph = [ADSGraph new];
	static const int count  = 10000;

	for (int i = 0; i < count; ++i)
	{
		[graph addNode:[NSString stringWithFormat:@"Task%d", i]];
		[graph addNode:[NSString stringWithFormat:@"SubTask%d", i]];
		[graph addNode:[NSString stringWithFormat:@"SubSubTask%d", i]];
	}

	for (int i = 0; i < count; ++i)
	{
		[graph addEdgeFrom:[NSString stringWithFormat:@"Task%d", i]
						to:[NSString stringWithFormat:@"SubTask%d", i]];
		[graph addEdgeFrom:[NSString stringWithFormat:@"SubTask%d", i]
						to:[NSString stringWithFormat:@"SubSubTask%d", i]];
		if (i < count - 1)
		{
			[graph addEdgeFrom:[NSString stringWithFormat:@"Task%d", i]
							to:[NSString stringWithFormat:@"Task%d", i + 1]];
			[graph addEdgeFrom:[NSString stringWithFormat:@"SubTask%d", i]
							to:[NSString stringWithFormat:@"SubTask%d", i + 1]];
			[graph addEdgeFrom:[NSString stringWithFormat:@"SubSubTask%d", i]
							to:[NSString stringWithFormat:@"SubSubTask%d", i + 1]];
		}
	}

	[self measureBlock:^{
		[graph topologicallySortedArray];
	}];
}

@end
