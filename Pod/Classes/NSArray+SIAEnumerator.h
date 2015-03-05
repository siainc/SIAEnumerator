//
//  NSArray+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2015 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SIAEnumerator)

@property (nonatomic, readonly) NSInteger sia_firstIndex;
@property (nonatomic, readonly) NSInteger sia_lastIndex;
- (NSInteger)sia_indexFromMinusIndex:(NSInteger)minusIndex;
- (NSInteger)sia_minusIndexFromIndex:(NSInteger)index;
- (BOOL)sia_validateIndex:(NSInteger)index;
- (BOOL)sia_validatePlusIndex:(NSInteger)plusIndex;
- (BOOL)sia_validateMinusIndex:(NSInteger)minusIndex;

@property (nonatomic, readonly) id sia_first;
@property (nonatomic, readonly) id sia_last;
- (NSArray *)sia_firstNumber:(NSUInteger)number;
- (NSArray *)sia_lastNumber:(NSUInteger)number;
- (id)sia_at:(NSInteger)index;
- (id)sia_at:(NSInteger)index ifNil:(id)ifNil;
- (id)sia_at:(NSInteger)index ifNilBlock:(id (^)())ifNilBlock;
- (id)sia_sample;
- (NSArray *)sia_sampleNumber:(NSInteger)number;
- (id)sia_find:(BOOL (^)(id obj))predicate;
- (id)sia_find:(BOOL (^)(id obj))predicate ifNone:(id)ifNone;
- (id)sia_find:(BOOL (^)(id obj))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)sia_findAll:(BOOL (^)(id obj))predicate;
- (NSArray *)sia_reject:(BOOL (^)(id obj))predicate;

- (NSArray *)sia_flatten;
- (NSArray *)sia_flattenLevel:(NSInteger)level;
- (NSArray *)sia_reverse;
- (NSArray *)sia_shuffle;

- (void)sia_each:(void (^)(id obj))block;
- (BOOL)sia_all:(BOOL (^)(id obj))predicate;
- (BOOL)sia_any:(BOOL (^)(id obj))predicate;
- (NSArray *)sia_map:(id (^)(id obj))block;
- (id)sia_max:(NSComparator)cmptr;
- (id)sia_min:(NSComparator)cmptr;
- (id)sia_inject:(id (^)(id result, id obj))injection;
- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initial;
- (NSInteger)sia_inject:(NSInteger (^)(NSInteger result, id obj))injection initialInteger:(NSInteger)initial;
- (NSUInteger)sia_inject:(NSUInteger (^)(NSUInteger result, id obj))injection initialUInteger:(NSUInteger)initial;
- (float)sia_inject:(float (^)(float result, id obj))injection initialFloat:(float)initial;
- (double)sia_inject:(double (^)(double result, id obj))injection initialDouble:(double)initial;
- (CGFloat)sia_inject:(CGFloat (^)(CGFloat result, id obj))injection initialCGFloat:(CGFloat)initial;

@end

@interface NSArray (SIAEnumerator2)

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone;
- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)sia_findAll2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)sia_reject2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

- (void)sia_each2:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (BOOL)sia_all2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (BOOL)sia_any2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)sia_map2:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (id)sia_max2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr;
- (id)sia_min2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr;
- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection;
- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection initialValue:(id)initial;
- (NSInteger)sia_inject2:(NSInteger (^)(NSInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialInteger:(NSInteger)initial;
- (NSUInteger)sia_inject2:(NSUInteger (^)(NSUInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialUInteger:(NSUInteger)initial;
- (float)sia_inject2:(float (^)(float result, id obj, NSUInteger idx, BOOL *stop))injection initialFloat:(float)initial;
- (double)sia_inject2:(double (^)(double result, id obj, NSUInteger idx, BOOL *stop))injection initialDouble:(double)initial;
- (CGFloat)sia_inject2:(CGFloat (^)(CGFloat result, id obj, NSUInteger idx, BOOL *stop))injection initialCGFloat:(CGFloat)initial;

@end

@interface NSMutableArray (SIAEnumerator)

- (id)sia_pop;
- (NSArray *)sia_popNumber:(NSUInteger)number;
- (void)sia_push:(id)object;
- (void)sia_pushObjects:(NSArray *)array;
- (id)sia_shift;
- (NSArray *)sia_shiftNumber:(NSUInteger)number;
- (void)sia_unshift:(id)object;
- (void)sia_unshiftObjects:(NSArray *)array;

- (void)sia_removeIf:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

+ (instancetype)sia_arrayWithObject:(id)anObject count:(NSUInteger)count;
+ (instancetype)sia_arrayWithCapacity:(NSUInteger)numItems initialize:(id (^)(NSUInteger idx, BOOL *stop))initialize;

@end
