//
//  NSDictionary+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2014/12/16.
//  Copyright (c) 2014-2018 SI Agency Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (SIAEnumerator)

// access element
- (nullable ObjectType)sia_at:(KeyType)aKey;
- (nullable ObjectType)sia_at:(KeyType)aKey ifNil:(nullable ObjectType)ifNil;
- (nullable ObjectType)sia_at:(KeyType)aKey ifNilBlock:(nullable ObjectType (^)(void))ifNilBlock;

// access all
- (void)sia_each:(void (^)(KeyType key, ObjectType obj))block;
- (void)sia_eachKey:(void (^)(KeyType key))block;
- (void)sia_eachValue:(void (^)(ObjectType obj))block;
- (NSArray *)sia_map:(id (^)(KeyType key, ObjectType obj))block;

// find
- (nullable NSArray *)sia_find:(BOOL (^)(KeyType key, ObjectType obj))block;
- (nullable NSArray *)sia_assoc:(KeyType)key;
- (nullable NSArray *)sia_rassoc:(ObjectType)value;

// filter
- (NSDictionary<KeyType, ObjectType> *)sia_filter:(BOOL (^)(KeyType key, ObjectType obj))block;
- (NSDictionary<KeyType, ObjectType> *)sia_findAll:(BOOL (^)(KeyType key, ObjectType obj))block __attribute__ ((deprecated));
- (NSDictionary<KeyType, ObjectType> *)sia_reject:(BOOL (^)(KeyType key, ObjectType obj))block;

// transform
- (NSArray *)sia_flatten;
- (NSArray *)sia_flattenLevel:(NSUInteger)number;
- (NSDictionary<KeyType, ObjectType> *)sia_invert;

// reduce
- (BOOL)sia_all:(BOOL (^)(KeyType key, ObjectType obj))predicate;
- (BOOL)sia_any:(BOOL (^)(KeyType key, ObjectType obj))predicate;

@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (SIAEnumerator2)

- (void)sia_each2:(void (^)(KeyType key, ObjectType obj, BOOL *stop))block;
- (void)sia_eachKey2:(void (^)(KeyType key, BOOL *stop))block;
- (void)sia_eachValue2:(void (^)(ObjectType obj, BOOL *stop))block;

- (nullable NSArray *)sia_find2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))block;
- (NSDictionary<KeyType, ObjectType> *)sia_filter2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))block;
- (NSDictionary<KeyType, ObjectType> *)sia_findAll2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))block __attribute__ ((deprecated));
- (NSDictionary<KeyType, ObjectType> *)sia_reject2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))block;

- (NSArray *)sia_map2:(id (^)(KeyType key, ObjectType obj, BOOL *stop))block;

- (BOOL)sia_all2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate;
- (BOOL)sia_any2:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate;

@end

NS_ASSUME_NONNULL_END
