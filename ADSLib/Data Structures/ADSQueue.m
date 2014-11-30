//
// Created by ASPCartman on 30/11/14.
// Copyright (c) 2014 ASPCartman. All rights reserved.
//

#import "ADSQueue.h"
#import "objc/runtime.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
@class ADSQueue_NotThreadSafe;

@interface ADSQueue_NotThreadSafe : ADSQueue
{
@package
	__strong NSMutableArray *_contents;
}
@end

@interface ADSQueue_ThreadSafe : ADSQueue
{
@package
	__strong NSMutableArray *_contents;
	dispatch_semaphore_t    _sema;
}
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-noreturn"

static inline void classClusterAssert() __attribute__((noreturn))
{
	NSCAssert(0, @"This is a class cluster.");
}

#pragma clang diagnostic pop

@implementation ADSQueue
{
}
+ (instancetype) alloc
{
	Class c = [self class];
	id ptr = class_getInstanceSize([ADSQueue_NotThreadSafe class]) > class_getInstanceSize([ADSQueue_ThreadSafe class]) ? [ADSQueue_NotThreadSafe allocWithZone:NSDefaultMallocZone()] : [ADSQueue_ThreadSafe allocWithZone:NSDefaultMallocZone()];
	object_setClass(ptr, c);
	return ptr;
}

+ (instancetype) new
{
	return [self queue];
}

+ (ADSQueue *) queue
{
	return [ADSQueue_NotThreadSafe new];
}

+ (ADSQueue *) threadSafeQueue
{
	return [ADSQueue_ThreadSafe new];
}

- (instancetype) init
{
	NSAssert(self.class != [ADSQueue class], @"This is a class cluster, call designated factory methods instead.");
	return self = [super init];
}

- (void) enableThreadSafety
{
	classClusterAssert();
}

- (void) disableThreadSafety
{
	classClusterAssert();
}

- (void) addObject:(id)object
{
	classClusterAssert();
}

- (id) popObject
{
	classClusterAssert();
}

- (NSUInteger) count
{
	classClusterAssert();
}

- (id) objectAtIndexedSubscript:(NSUInteger)i
{
	classClusterAssert();
}

- (NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained[])buffer count:(NSUInteger)len
{
	classClusterAssert();
}
@end

@implementation ADSQueue_NotThreadSafe

+ (instancetype) new
{
	return [[self alloc] init];
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
	id contents = _contents;

	_contents = nil;

	object_setClass(self, [ADSQueue_ThreadSafe class]);
	ADSQueue_ThreadSafe *castedPtr = (id) self;

	castedPtr->_contents = contents;
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

- (id) objectAtIndexedSubscript:(NSUInteger)i
{
	return _contents[i];
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
	id contents = _contents;

	_contents = nil;
	_sema = nil;

	object_setClass(self, [ADSQueue_NotThreadSafe class]);
	ADSQueue_NotThreadSafe *castedPtr = (id) self;

	castedPtr->_contents = contents;
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

- (id) objectAtIndexedSubscript:(NSUInteger)i
{
	lock(_sema);
	id object = _contents[i];
	unlock(_sema);
	return object;
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