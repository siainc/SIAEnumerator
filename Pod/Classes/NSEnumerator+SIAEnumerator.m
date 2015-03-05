//
//  NSEnumerator+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2015 SI Agency Inc. All rights reserved.
//

#import "NSEnumerator+SIAEnumerator.h"

@implementation NSEnumerator (SIAEnumerator)

- (id)sia_find:(BOOL (^)(id obj))predicate
{
    return [self sia_find:predicate ifNoneBlock:nil];
}

- (id)sia_find:(BOOL (^)(id obj))predicate ifNone:(id)ifNone
{
    return [self sia_find:predicate ifNoneBlock:^id{
        return ifNone;
    }];
}

- (id)sia_find:(BOOL (^)(id obj))predicate ifNoneBlock:(id (^)())ifNoneBlock
{
    return [self sia_find2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    } ifNoneBlock:ifNoneBlock];
}

- (NSArray *)sia_findAll:(BOOL (^)(id obj))predicate
{
    return [self sia_findAll2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (NSArray *)sia_reject:(BOOL (^)(id obj))predicate
{
    return [self sia_reject2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (void)sia_each:(void (^)(id obj))block
{
    return [self sia_each2:^(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
}

- (BOOL)sia_all:(BOOL (^)(id obj))predicate
{
    return [self sia_all2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (BOOL)sia_any:(BOOL (^)(id obj))predicate
{
    return [self sia_any2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (NSArray *)sia_map:(id (^)(id obj))block
{
    return [self sia_map2:^id(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
}

- (id)sia_max:(NSComparator)cmptr
{
    return [self sia_max2:^NSComparisonResult(id obj1, id obj2, BOOL *stop) {
        return cmptr(obj1, obj2);
    }];
}

- (id)sia_min:(NSComparator)cmptr
{
    return [self sia_min2:^NSComparisonResult(id obj1, id obj2, BOOL *stop) {
        return cmptr(obj1, obj2);
    }];
}

- (id)sia_inject:(id (^)(id result, id obj))injection
{
    return [self sia_inject:injection initialValue:nil];
}

- (id)sia_inject:(id (^)(id result, id obj))injection initialValue:(id)initial
{
    return [self sia_inject2:^id(id result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialValue:initial];
}

- (NSInteger)sia_inject:(NSInteger (^)(NSInteger result, id obj))injection initialInteger:(NSInteger)initial
{
    return [self sia_inject2:^NSInteger(NSInteger result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialInteger:initial];
}

- (NSUInteger)sia_inject:(NSUInteger (^)(NSUInteger result, id obj))injection initialUInteger:(NSUInteger)initial
{
    return [self sia_inject2:^NSUInteger(NSUInteger result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialUInteger:initial];
}

- (float)sia_inject:(float (^)(float result, id obj))injection initialFloat:(float)initial
{
    return [self sia_inject2:^float(float result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialFloat:initial];
}

- (double)sia_inject:(double (^)(double result, id obj))injection initialDouble:(double)initial
{
    return [self sia_inject2:^double(double result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialDouble:initial];
}

- (CGFloat)sia_inject:(CGFloat (^)(CGFloat result, id obj))injection initialCGFloat:(CGFloat)initial
{
    return [self sia_inject2:^CGFloat(CGFloat result, id obj, NSUInteger idx, BOOL *stop) {
        return injection(result, obj);
    } initialCGFloat:initial];
}

@end

@implementation NSEnumerator (SIAEnumerator2)

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    return [self sia_find2:predicate ifNone:nil];
}

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone
{
    return [self sia_find2:predicate ifNoneBlock:^id {
        return ifNone;
    }];
}

- (id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)())ifNoneBlock
{
    __block id object = nil;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            BOOL pass = predicate(obj, idx, &stop);
            if (pass) {
                object = obj;
                break;
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    if (object == nil) {
        object = ifNoneBlock();
    }
    return object;
}

- (NSArray *)sia_findAll2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = @[].mutableCopy;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            BOOL pass = predicate(obj, idx, &stop);
            if (pass) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (NSArray *)sia_reject2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    NSMutableArray *array = @[].mutableCopy;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            BOOL pass = predicate(obj, idx, &stop);
            if (!pass) {
                [array addObject:obj];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (void)sia_each2:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            block(obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
}

- (BOOL)sia_all2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    BOOL isYesAll = YES;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            isYesAll = predicate(obj, idx, &stop);
            if (!isYesAll) {
                break;
            }
            if (stop) {
                isYesAll = NO;
                break;
            }
            idx++;
        }
    }
    return isYesAll;
}

- (BOOL)sia_any2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
    BOOL isYesAny = NO;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            isYesAny = predicate(obj, idx, &stop);
            if (isYesAny) {
                break;
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return isYesAny;
}

- (NSArray *)sia_map2:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    NSMutableArray *array = @[].mutableCopy;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            id object = block(obj, idx, &stop);
            if (object) {
                [array addObject:object];
            }
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return array;
}

- (id)sia_max2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr
{
    id maxObject = nil;
    BOOL stop = NO;
    for (id obj in self) {
        @autoreleasepool {
            if (maxObject == nil) {
                maxObject = obj;
            }
            else if (cmptr(maxObject, obj, &stop) == NSOrderedAscending) {
                maxObject = obj;
            }
            if (stop) {
                break;
            }
        }
    }
    return maxObject;
}

- (id)sia_min2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr
{
    id minObject = nil;
    BOOL stop = NO;
    for (id obj in self) {
        @autoreleasepool {
            if (minObject == nil) {
                minObject = obj;
            }
            else if (cmptr(minObject, obj, &stop) == NSOrderedDescending) {
                minObject = obj;
            }
            if (stop) {
                break;
            }
        }
    }
    return minObject;
}

- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection
{
    return [self sia_inject2:injection initialValue:nil];
}

- (id)sia_inject2:(id (^)(id result, id obj, NSUInteger idx, BOOL *stop))injection initialValue:(id)initial
{
    id result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (NSInteger)sia_inject2:(NSInteger (^)(NSInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialInteger:(NSInteger)initial;
{
    NSInteger result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (NSUInteger)sia_inject2:(NSUInteger (^)(NSUInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialUInteger:(NSUInteger)initial;
{
    NSUInteger result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (float)sia_inject2:(float (^)(float result, id obj, NSUInteger idx, BOOL *stop))injection initialFloat:(float)initial;
{
    float result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (double)sia_inject2:(double (^)(double result, id obj, NSUInteger idx, BOOL *stop))injection initialDouble:(double)initial;
{
    double result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (CGFloat)sia_inject2:(CGFloat (^)(CGFloat result, id obj, NSUInteger idx, BOOL *stop))injection initialCGFloat:(CGFloat)initial
{
    CGFloat result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = injection(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

@end

@interface SIAEnumerator ()
@property (nonatomic, copy) id (^traceBlock)(NSInteger index, id previousObject);
@property (nonatomic, strong) id currentObject;
@end

@implementation SIAEnumerator

+ (SIAEnumerator *)enumeratorWithTraceBlock:(id (^)(NSInteger index, id previousObject))traceBlock
{
    SIAEnumerator *enumerator = [[SIAEnumerator alloc] init];
    enumerator.traceBlock = traceBlock;
    return enumerator;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    if (state->state == 0) {
        state->mutationsPtr = (unsigned long *)(__bridge void *)self;
    }
    else if (self.currentObject == nil) {
        return 0;
    }
    
    state->itemsPtr = buffer;
    
    NSInteger containedCount = 0;
    for (int i = 0; i < len; i++) {
        @autoreleasepool {
            self.currentObject = self.traceBlock(state->state, self.currentObject);
            if (self.currentObject != nil) {
                state->itemsPtr[i] = self.currentObject;
                containedCount++;
                state->state++;
            }
            else {
                break;
            }
        }
    }
    
    return containedCount;
}

@end
