//
// Created by ASPCartman on 30/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "ADSSerialQueue.h"
#import "objc/runtime.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"

@interface ADSQueue_ThreadSafe : ADSSerialQueue
@end

@implementation ADSSerialQueue
{
@package
	__strong NSMutableArray *_contents;
	dispatch_semaphore_t    _sema;
}

+ (ADSSerialQueue *) queue
{
	return [[self alloc] init];
}

+ (ADSSerialQueue *) threadSafeQueue
{
	return [ADSQueue_ThreadSafe new];
}

- (instancetype) init
{
	self = [super init];
	if (self)
	{
		_contents = [NSMutableArray new];
	}

	return self;
}


- (void) enableThreadSafety
{
	object_setClass(self, [ADSQueue_ThreadSafe class]);

	ADSQueue_ThreadSafe *castedPtr = (id) self;
	castedPtr->_sema = dispatch_semaphore_create(1);
}

- (void) disableThreadSafety
{
	return;
}

- (void) addObject:(id)object
{
	[_contents addObject:object];
}

- (id) popObject
{
	id object = [_contents firstObject];
	[_contents removeObjectAtIndex:0];
	return object;
}

- (NSUInteger) count
{
	return _contents.count;
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer count:(NSUInteger)len
{
	state->state        = 1;
	state->itemsPtr     = buffer;
	state->mutationsPtr = state->extra + 0; // Ignoring mutations.

	NSInteger count                 = _contents.count;
	NSInteger itemsAlreadyProcessed = state->extra[1];
	NSInteger itemsLeft             = count - itemsAlreadyProcessed;
	if (itemsLeft <= 0)
	{
		[_contents removeAllObjects];
		return 0;
	}

	NSInteger itemsForThisIteration = MIN(itemsLeft, len);
	CFArrayGetValues((__bridge CFArrayRef) _contents, CFRangeMake(itemsAlreadyProcessed, itemsForThisIteration), (void const **) (uintmax_t) buffer);

	state->extra[1] += itemsForThisIteration;

	return (NSUInteger) itemsForThisIteration;
}
@end


@implementation ADSQueue_ThreadSafe

+ (instancetype) new
{
	return [[self alloc] init];
}

- (instancetype) init
{
	self = [super init];
	if (self)
	{
		_sema     = dispatch_semaphore_create(1);
		_contents = [NSMutableArray new];
	}

	return self;
}

- (void) enableThreadSafety
{
	return;
}

- (void) disableThreadSafety
{
	_sema = nil;
	object_setClass(self, [ADSSerialQueue class]);
}

static inline void lock(dispatch_semaphore_t sema)
{
	dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

static inline void unlock(dispatch_semaphore_t sema)
{
	dispatch_semaphore_signal(sema);
}

- (void) addObject:(id)object
{
	lock(_sema);
	[_contents addObject:object];
	unlock(_sema);
}

- (id) popObject
{
	lock(_sema);
	id object = [_contents firstObject];
	if (object)
	{
		[_contents removeObjectAtIndex:0];
	}
	unlock(_sema);
	return object;
}

- (NSUInteger) count
{
	lock(_sema);
	NSUInteger count = _contents.count;
	unlock(_sema);
	return count;
}


- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer count:(NSUInteger)len
{
	state->state        = 1;
	state->itemsPtr     = buffer;
	state->mutationsPtr = state->extra + 0; // Ignoring mutations.

	id object = [self popObject];
	if (object != nil)
	{
		buffer[0] = object;
		return 1;
	}

	return 0;
}
@end

#pragma clang diagnostic pop