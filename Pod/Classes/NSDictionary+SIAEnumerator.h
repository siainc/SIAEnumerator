//
//  NSDictionary+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2014/12/16.
//  Copyright (c) 2014-2015 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SIAEnumerator)

- (id)sia_at:(id)aKey;
- (id)sia_at:(id)aKey ifNil:(id)ifNil;
- (id)sia_at:(id)aKey ifNilBlock:(id (^)())ifNilBlock;

- (void)sia_each:(void (^)(id key, id obj))block;
- (void)sia_eachKey:(void (^)(id key))block;
- (void)sia_eachValue:(void (^)(id obj))block;

- (NSArray *)sia_find:(BOOL (^)(id key, id obj))block;
- (NSDictionary *)sia_findAll:(BOOL (^)(id key, id obj))block;
- (NSDictionary *)sia_reject:(BOOL (^)(id key, id obj))block;
- (NSArray *)sia_assoc:(id)key;
- (NSArray *)sia_rassoc:(id)value;

- (NSArray *)sia_flatten;
- (NSArray *)sia_flattenLevel:(NSUInteger)number;
- (NSDictionary *)sia_invert;

- (BOOL)sia_all:(BOOL (^)(id key, id obj))predicate;
- (BOOL)sia_any:(BOOL (^)(id key, id obj))predicate;
- (NSArray *)sia_map:(id (^)(id key, id obj))block;

@end

@interface NSDictionary (SIAEnumerator2)

- (void)sia_each2:(void (^)(id key, id obj, BOOL *stop))block;
- (void)sia_eachKey2:(void (^)(id key, BOOL *stop))block;
- (void)sia_eachValue2:(void (^)(id obj, BOOL *stop))block;

- (NSArray *)sia_find2:(BOOL (^)(id key, id obj, BOOL *stop))block;
- (NSDictionary *)sia_findAll2:(BOOL (^)(id key, id obj, BOOL *stop))block;
- (NSDictionary *)sia_reject2:(BOOL (^)(id key, id obj, BOOL *stop))block;

- (BOOL)sia_all2:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (BOOL)sia_any2:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (NSArray *)sia_map2:(id (^)(id key, id obj, BOOL *stop))block;

@end
