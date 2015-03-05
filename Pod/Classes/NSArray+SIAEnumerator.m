//
//  NSArray+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2015 SI Agency Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This code needs compiler option -fobjc_arc
#endif

#import "NSArray+SIAEnumerator.h"

#import "NSEnumerator+SIAEnumerator.h"

@implementation NSArray (SIAEnumerator)
@dynamic sia_first;
@dynamic sia_firstIndex;
@dynamic sia_lastIndex;

- (NSInteger)sia_firstIndex
{
    return self.count > 0 ? 0 : NSNotFound;
}

- (NSInteger)sia_lastIndex
{
    return self.count > 0 ? self.count - 1 : NSNotFound;
}

- (NSInteger)sia_indexFromMinusIndex:(NSInteger)minusIndex
{
    if ([self sia_validateMinusIndex:minusIndex]) {
        return self.count + minusIndex;
    }
    return NSNotFound;
}

- (NSInteger)sia_minusIndexFromIndex:(NSInteger)index
{
    if ([self sia_validatePlusIndex:index]) {
        return index - self.count;
    }
    return NSNotFound;
}

- (BOOL)sia_validateIndex:(NSInteger)index
{
    return [self sia_validatePlusIndex:index] || [self sia_validateMinusIndex:index];
}

- (BOOL)sia_validatePlusIndex:(NSInteger)plusIndex
{
    return 0 <= plusIndex && plusIndex < self.count;
}

- (BOOL)sia_validateMinusIndex:(NSInteger)minusIndex
{
    return self.count * -1 <= minusIndex && minusIndex < 0;
}

- (id)sia_first
{
    return [self sia_at:0 ifNil:nil];
}

- (id)sia_last
{
    return self.lastObject;
}

- (NSArray *)sia_firstNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(0, MIN(number, self.count))];
}

- (NSArray *)sia_lastNumber:(NSUInteger)number
{
    return [self subarrayWithRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                               MIN(number, self.count))];
}

- (id)sia_at:(NSInteger)index
{
    return [self sia_at:index ifNil:nil];
}

- (id)sia_at:(NSInteger)index ifNil:(id)ifNil
{
    if ([self sia_validatePlusIndex:index]) {
        return self[index];
    }
    else if ([self sia_validateMinusIndex:index]) {
        NSInteger normalizedIndex = [self sia_indexFromMinusIndex:index];
        return self[normalizedIndex];
    }
    else {
        return ifNil;
    }
}

- (id)sia_at:(NSInteger)index ifNilBlock:(id (^)())ifNilBlock
{
    if ([self sia_validatePlusIndex:index]) {
        return self[index];
    }
    else if ([self sia_validateMinusIndex:index]) {
        NSInteger normalizedIndex = [self sia_indexFromMinusIndex:index];
        return self[normalizedIndex];
    }
    else {
        if (ifNilBlock) {
            return ifNilBlock();
        }
        return nil;
    }
}

- (id)sia_sample
{
    NSInteger sampleIndex = arc4random() % self.count;
    return self[sampleIndex];
}

- (NSArray *)sia_sampleNumber:(NSInteger)number
{
    NSAssert(0 <= number && number <= self.count, @"配列要素数以内であること");
    NSMutableArray *source = self.mutableCopy;
    NSMutableArray *destination = @[].mutableCopy;
    for (int i = 0; i < number; i++) {
        NSInteger sampleIndex = arc4random() % source.count;
        [destination addObject:source[sampleIndex]];
        [source removeObjectAtIndex:sampleIndex];
    }
    return destination;
}

- (id)sia_find:(BOOL (^)(id obj))predicate
{
    return [self sia_find:predicate ifNone:nil];
}

- (id)sia_find:(BOOL (^)(id obj))predicate ifNone:(id)ifNone
{
    return [self.objectEnumerator sia_find:predicate ifNone:ifNone];
}

- (id)sia_find:(BOOL (^)(id obj))predicate
   ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self.objectEnumerator sia_find:predicate ifNoneBlock:ifNoneBlock];
}

- (NSArray *)sia_findAll:(BOOL (^)(id obj))predicate
{
    return [self.objectEnumerator sia_findAll:predicate];
}

- (NSArray *)sia_reject:(BOOL (^)(id obj))predicate
{
    return [self.objectEnumerator sia_reject:predicate];
}

- (NSArray *)sia_flatten
{
    return [self sia_flattenLevel:-1];
}

- (NSArray *)sia_flattenLevel:(NSInteger)level
{
    NSMutableArray *array = @[].mutableCopy;
    if (level == 0) {
        return self.copy;
    }
    for (id obj in self) {
        @autoreleasepool {
            if ([obj isKindOfClass:[NSArray class]]) {
                [array addObjectsFromArray:[obj sia_flattenLevel:level>0 ? level-1 : -1]];
            }
            else {
                [array addObject:obj];
            }
        }
    }
    return array;
}

- (NSArray *)sia_reverse
{
    return self.reverseObjectEnumerator.allObjects;
}

- (NSArray *)sia_shuffle
{
    return [self sia_sampleNumber:self.count];
}

- (void)sia_each:(void (^)(id obj))block
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (BOOL)sia_all:(BOOL (^)(id obj))predicate
{
    return [self.objectEnumerator sia_all:predicate];
}

- (BOOL)sia_any:(BOOL (^)(id obj))predicate
{
    return [self.objectEnumerator sia_any:predicate];
}

- (NSArray *)sia_map:(id (^)(id obj))block
{
    return [self.objectEnumerator sia_map:block];
}

- (id)sia_max:(NSComparator)cmptr
{
    return [self.objectEnumerator sia_max:cmptr];
}

- (id)sia_min:(NSComparator)cmptr
{
    return [self.objectEnumerator sia_min:cmptr];
}

- (id)sia_inject:(id (^)(id result, id obj))injection
{
    return [self sia_inject:injection initialValue:nil];
}

- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initial
{
    return [self.objectEnumerator sia_inject:injection initialValue:initial];
}

- (NSInteger)sia_inject:(NSInteger (^)(NSInteger result, id obj))injection initialInteger:(NSInteger)initial
{
    return [self.objectEnumerator sia_inject:injection initialInteger:initial];
}

- (NSUInteger)sia_inject:(NSUInteger (^)(NSUInteger result, id obj))injection initialUInteger:(NSUInteger)initial
{
    return [self.objectEnumerator sia_inject:injection initialUInteger:initial];
}

- (float)sia_inject:(float (^)(float result, id obj))injection initialFloat:(float)initial
{
    return [self.objectEnumerator sia_inject:injection initialFloat:initial];
}

- (double)sia_inject:(double (^)(double result, id obj))injection initialDouble:(double)initial
{
    return [self.objectEnumerator sia_inject:injection initialDouble:initial];
}

- (CGFloat)sia_inject:(CGFloat (^)(CGFloat result, id obj))injection initialCGFloat:(CGFloat)initial
{
    return [self.objectEnumerator sia_inject:injection initialCGFloat:initial];
}

@end

@implementation NSArray (SIAEnumerator2)

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_find2:predicate ifNone:nil];
}

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self.objectEnumerator sia_find2:predicate ifNone:ifNone];
}

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
   ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self.objectEnumerator sia_find2:predicate ifNoneBlock:ifNoneBlock];
}

- (NSArray *)sia_findAll2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_findAll2:predicate];
}

- (NSArray *)sia_reject2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_reject2:predicate];
}

- (void)sia_each2:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (BOOL)sia_all2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_all2:predicate];
}

- (BOOL)sia_any2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self.objectEnumerator sia_any2:predicate];
}

- (NSArray *)sia_map2:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    return [self.objectEnumerator sia_map2:block];
}

- (id)sia_max2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr
{
    return [self.objectEnumerator sia_max2:cmptr];
}

- (id)sia_min2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr
{
    return [self.objectEnumerator sia_min2:cmptr];
}

- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection
{
    return [self sia_inject2:injection initialValue:nil];
}

- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection initialValue:(id)initial
{
    return [self.objectEnumerator sia_inject2:injection initialValue:initial];
}

- (NSInteger)sia_inject2:(NSInteger (^)(NSInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialInteger:(NSInteger)initial
{
    return [self.objectEnumerator sia_inject2:injection initialInteger:initial];
}

- (NSUInteger)sia_inject2:(NSUInteger (^)(NSUInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialUInteger:(NSUInteger)initial
{
    return [self.objectEnumerator sia_inject2:injection initialUInteger:initial];
}

- (float)sia_inject2:(float (^)(float result, id obj, NSUInteger idx, BOOL *stop))injection initialFloat:(float)initial
{
    return [self.objectEnumerator sia_inject2:injection initialFloat:initial];
}

- (double)sia_inject2:(double (^)(double result, id obj, NSUInteger idx, BOOL *stop))injection initialDouble:(double)initial
{
    return [self.objectEnumerator sia_inject2:injection initialDouble:initial];
}

- (CGFloat)sia_inject2:(CGFloat (^)(CGFloat result, id obj, NSUInteger idx, BOOL *stop))injection initialCGFloat:(CGFloat)initial
{
    return [self.objectEnumerator sia_inject2:injection initialCGFloat:initial];
}

@end

@implementation NSMutableArray (SIAEnumerator)

- (id)sia_pop
{
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

- (NSArray *)sia_popNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self sia_lastNumber:number]];
    [self removeObjectsInRange:NSMakeRange(MAX((NSInteger)self.count - (NSInteger)number, 0),
                                           MIN(number, self.count))];
    return array;
}

- (void)sia_push:(id)object
{
    [self addObject:object];
}

- (void)sia_pushObjects:(NSArray *)array
{
    [self addObjectsFromArray:array];
}

- (id)sia_shift
{
    id object = self.sia_first;
    if ([self sia_validateIndex:0]) {
        [self removeObjectAtIndex:0];
    }
    return object;
}

- (NSArray *)sia_shiftNumber:(NSUInteger)number
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:number];
    [array addObjectsFromArray:[self sia_firstNumber:number]];
    [self removeObjectsInRange:NSMakeRange(0, MIN(number, self.count))];
    return array;
}

- (void)sia_unshift:(id)object
{
    [self insertObject:object atIndex:0];
}

- (void)sia_unshiftObjects:(NSArray *)array
{
    [self insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
}

- (void)sia_removeIf:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:predicate];
    [self removeObjectsAtIndexes:indexSet];
}

+ (instancetype)sia_arrayWithObject:(id)anObject count:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [array addObject:anObject];
    }
    return array;
}

+ (instancetype)sia_arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:numItems];
    BOOL stop = NO;
    for (NSUInteger i = 0; i < numItems; i++) {
        @autoreleasepool {
            id obj = initialize(i, &stop);
            if (obj) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
        }
    }
    return array;
}

@end
