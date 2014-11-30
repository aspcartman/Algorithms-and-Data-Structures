//
// Created by ASPCartman on 30/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSQueue : NSObject <NSFastEnumeration>
+ (instancetype) queue;
+ (instancetype) threadSafeQueue;

- (void) enableThreadSafety;
- (void) disableThreadSafety;
- (void) addObject:(id)object;
- (id) popObject;

- (NSUInteger) count;
- (id) objectAtIndexedSubscript:(NSUInteger)i;
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer count:(NSUInteger)len;
@end