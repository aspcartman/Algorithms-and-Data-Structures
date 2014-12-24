//
// Created by ASPCartman on 30/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSSerialQueue : NSObject <NSFastEnumeration>
+ (instancetype) queue;
+ (instancetype) threadSafeQueue;

- (void) enableThreadSafety;
- (void) disableThreadSafety;
- (void) pushObject:(id)object;
- (id) popObject;

- (NSUInteger) count;
- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer count:(NSUInteger)len;
@end