//
// Created by ASPCartman on 29/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ADS_Search)
- (NSInteger) ads_searchLinear:(id)object;
- (NSInteger) ads_searchBinary:(id)object withComparator:(NSComparator)comparator;
@end