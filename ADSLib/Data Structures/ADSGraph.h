//
// Created by ASPCartman on 24/12/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADSGraphPath
@property (nonatomic, readonly, strong) NSArray *path;
@property (nonatomic, readonly, strong) NSNumber *value;
@end

@interface ADSGraph : NSObject
- (void) addNode:(id)object;
- (void) addDependencyFrom:(id)from to:(id)to;
- (void) addEdgeFrom:(id)from to:(id)to;
- (void) addEdgeFrom:(id)from to:(id)to value:(NSNumber *)value;
- (NSArray *) topologicallySortedArray;
@end