//
// Created by ASPCartman on 29/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tommath.h"

@interface ADSTomInteger : NSObject
{

}
- (instancetype) initWithString:(NSString *)string base:(int)base;
- (instancetype) initWithNumber:(NSNumber *)number;

- (NSComparisonResult) compare:(ADSTomInteger *)otherInt;
- (ADSTomInteger *) multiply:(ADSTomInteger *)otherInt;
@end