//
//  NSEnumerator+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2015 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEnumerator (SIAEnumerator)

- (id)sia_find:(BOOL (^)(id obj))predicate;
- (id)sia_find:(BOOL (^)(id obj))predicate ifNone:(id)ifNone;
- (id)sia_find:(BOOL (^)(id obj))predicate ifNoneBlock:(id (^)())ifNoneBlock;
- (NSArray *)sia_findAll:(BOOL (^)(id obj))predicate;
- (NSArray *)sia_reject:(BOOL (^)(id obj))predicate;

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

@interface NSEnumerator (SIAEnumerator2)

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

@interface SIAEnumerator : NSEnumerator

+ (SIAEnumerator *)enumeratorWithTraceBlock:(id (^)(NSInteger index, id previousObject))traceBlock;

@end
