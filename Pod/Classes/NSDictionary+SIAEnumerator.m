//
//  NSDictionary+SIAEnumerator.m
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2014/12/16.
//  Copyright (c) 2014-2018 SI Agency Inc. All rights reserved.
//

#import "NSDictionary+SIAEnumerator.h"
#import "NSArray+SIAEnumerator.h"

@implementation NSDictionary (SIAEnumerator)

- (nullable id)sia_at:(id)aKey {
    return [self objectForKey:aKey];
}

- (nullable id)sia_at:(id)aKey ifNil:(nullable id)ifNil {
    id value = [self objectForKey:aKey];
    return value ?: ifNil;
}

- (nullable id)sia_at:(id)aKey ifNilBlock:(nullable id (^)(void))ifNilBlock {
    id value = [self objectForKey:aKey];
    return value ?: ifNilBlock();
}

- (void)sia_each:(void (^)(id key, id obj))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, obj);
    }];
}

- (void)sia_eachKey:(void (^)(id key))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key);
    }];
}

- (void)sia_eachValue:(void (^)(id obj))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj);
    }];
}

- (NSArray *)sia_map:(id (^)(id key, id obj))block {
    return [self sia_map2:^id(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }];
}

- (nullable NSArray *)sia_find:(BOOL (^)(id key, id obj))block {
    return [self sia_find2:^BOOL(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }];
}

- (nullable NSArray *)sia_assoc:(id)key {
    id value = [self objectForKey:key];
    return value ? @[key, value] : nil;
}

- (nullable NSArray *)sia_rassoc:(id)value {
    __block NSArray *pair = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:value]) {
            pair = @[key, obj];
            *stop = YES;
        }
    }];
    return pair;
}

- (NSDictionary *)sia_filter:(BOOL (^)(id key, id obj))block {
    return [self sia_filter2:^BOOL(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }];
}

- (NSDictionary *)sia_findAll:(BOOL (^)(id key, id obj))block {
    return [self sia_filter:block];
}

- (NSDictionary *)sia_reject:(BOOL (^)(id key, id obj))block {
    return [self sia_reject2:^BOOL(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }];
}

- (NSArray *)sia_flatten {
    return [self sia_flattenLevel:1];
}

- (NSArray *)sia_flattenLevel:(NSUInteger)number {
    NSMutableArray *array = @[].mutableCopy;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:@[key, obj]];
    }];
    return [array sia_flattenLevel:number];
}

- (NSDictionary *)sia_invert {
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        dictionary[obj] = key;
    }];
    return dictionary;
}

- (BOOL)sia_all:(BOOL (^)(id key, id obj))predicate {
    return [self sia_all2:^BOOL(id key, id obj, BOOL *stop) {
        return predicate(key, obj);
    }];
}

- (BOOL)sia_any:(BOOL (^)(id key, id obj))predicate {
    return [self sia_any2:^BOOL(id key, id obj, BOOL *stop) {
        return predicate(key, obj);
    }];
}

@end

@implementation NSDictionary (SIAEnumerator2)

- (void)sia_each2:(void (^)(id key, id obj, BOOL *stop))block {
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)sia_eachKey2:(void (^)(id key, BOOL *stop))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(key, stop);
    }];
}

- (void)sia_eachValue2:(void (^)(id obj, BOOL *stop))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj, stop);
    }];
}

- (nullable NSArray *)sia_find2:(BOOL (^)(id key, id obj, BOOL *stop))block {
    __block NSArray *array = nil;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key, obj, stop)) {
            array = @[key, obj];
            *stop = YES;
        }
    }];
    return array;
}

- (NSDictionary *)sia_filter2:(BOOL (^)(id key, id obj, BOOL *stop))block {
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL pass = block(key, obj, stop);
        if (pass) {
            dictionary[key] = obj;
        }
    }];
    return dictionary;
}

- (NSDictionary *)sia_findAll2:(BOOL (^)(id key, id obj, BOOL *stop))block {
    return [self sia_filter2:block];
}

- (NSDictionary *)sia_reject2:(BOOL (^)(id key, id obj, BOOL *stop))block {
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL pass = block(key, obj, stop);
        if (!pass) {
            dictionary[key] = obj;
        }
    }];
    return dictionary;
}

- (BOOL)sia_all2:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    __block BOOL all = YES;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL result = predicate(key, obj, stop);
        if (!result) {
            all = NO;
            *stop = YES;
        }
    }];
    return all;
}

- (BOOL)sia_any2:(BOOL (^)(id key, id obj, BOOL *stop))predicate {
    __block BOOL any = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL result = predicate(key, obj, stop);
        if (result) {
            any = YES;
            *stop = YES;
        }
    }];
    return any;
}


- (NSArray *)sia_map2:(id (^)(id key, id obj, BOOL *stop))block {
    NSMutableArray *array = @[].mutableCopy;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = block(key, obj, stop);
        if (object) {
            [array addObject:object];
        }
    }];
    return array;
}

@end
