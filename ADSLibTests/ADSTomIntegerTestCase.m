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

#define TEST_SIZE 1000000

@interface ADSTomIntegerTestCase : XCTestCase

@end

@implementation ADSTomIntegerTestCase
{
}

- (void)setUp {
    [super setUp];
}

- (void) testPrint
{
	ADSTomInteger *tom = [[ADSTomInteger alloc] initWithString:@"-2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" base:16];
	NSLog(@"%@",[tom multiply:[[ADSTomInteger alloc] initWithString:@"-2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" base:16]]);
}
@end
