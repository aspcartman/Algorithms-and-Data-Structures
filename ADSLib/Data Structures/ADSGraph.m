//
// Created by ASPCartman on 24/12/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "ADSSerialQueue.h"
#import "ADSGraph.h"

@interface ADSGraphEdge : NSObject
{
@package
	__strong id       target;
	__strong NSNumber *value;
}
+ (instancetype) edgeTo:(id)aTarget value:(NSNumber *)aValue;
@end

@implementation ADSGraphEdge
+ (instancetype) edgeTo:(id)aTarget value:(NSNumber *)aValue
{
	ADSGraphEdge *edge = [self new];
	edge->target = aTarget;
	edge->value  = aValue ? : @(0);
	return edge;
}
@end

@implementation ADSGraphPath
@end

@implementation ADSGraph
{
	__strong NSMutableSet *_nodes;
	__strong NSMapTable   *_edges;
	__strong NSMapTable   *_depth;
}

- (instancetype) init
{
	self = [super init];
	if (self)
	{
		_nodes = [NSMutableSet new];
		_edges = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
		_depth = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
	}

	return self;
}

- (void) addNode:(id)object
{
	[_nodes addObject:object];
	[_edges setObject:[NSMutableSet new] forKey:object];
	[_depth setObject:@(0u) forKey:object];
}

- (void) addDependencyFrom:(id)from to:(id)to
{
	[self addEdgeFrom:to to:from];
}

- (void) addEdgeFrom:(id)from to:(id)to
{
	[self addEdgeFrom:from to:to value:nil];
}

- (void) addEdgeFrom:(id)from to:(id)to value:(NSNumber *)value
{
	NSParameterAssert([_nodes containsObject:from]);
	NSParameterAssert([_nodes containsObject:to]);

	NSMutableSet *edgesFromNode = [_edges objectForKey:from];
	[edgesFromNode addObject:[ADSGraphEdge edgeTo:to value:value]];

	[_depth setObject:@([[_depth objectForKey:to] unsignedIntegerValue] + 1u) forKey:to];
}

- (NSArray *) topologicallySortedArray
{
	ADSSerialQueue *queue = [ADSSerialQueue new];

	for (id node in _nodes)
	{
		if ([[_depth objectForKey:node] isEqual:@(0u)])
		{
			[queue pushObject:node];
		}
	}

	NSAssert(queue.count, @"Graph has a cycle!");

	NSMutableArray *result     = [NSMutableArray new];
	NSMapTable *depthMutableCopy = [_depth mutableCopy];

	for (id node in queue)
	{
		[result addObject:node];

		for (ADSGraphEdge *edge in [_edges objectForKey:node])
		{
			id targetNode = edge->target;
			NSUInteger currentDepth = [[depthMutableCopy objectForKey:targetNode] unsignedIntegerValue];
			NSParameterAssert(currentDepth);
			NSNumber *depth = @(currentDepth - 1u);

			if ([depth isEqualToNumber:@(0u)])
			{
				[queue pushObject:targetNode];
			}
			else
			{
				[depthMutableCopy setObject:depth forKey:targetNode];
			}
		}
	}

	NSAssert(result.count == _nodes.count, @"Graph has a cycle!");

	return result;
}

- (NSArray*) findBestWayFrom:(id)startNode to:(id)endNode
{
	NSParameterAssert([_nodes containsObject:startNode]);
	NSParameterAssert([_nodes containsObject:endNode]);

	if (startNode == endNode)
	{
		return @[startNode];
	}
}
@end