//
//  NSEnumerator+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2011/09/13.
//  Copyright (c) 2011-2018 SI Agency Inc. All rights reserved.
//

#import "NSEnumerator+SIAEnumerator.h"

@implementation NSEnumerator (SIAEnumerator)

- (nullable id)sia_find:(BOOL (^)(id obj))predicate {
    return [self sia_find:predicate ifNoneBlock:nil];
}

- (nullable id)sia_find:(BOOL (^)(id obj))predicate ifNone:(nullable id)ifNone {
    return [self sia_find:predicate ifNoneBlock:^id{
        return ifNone;
    }];
}

- (nullable id)sia_find:(BOOL (^)(id obj))predicate ifNoneBlock:(nullable id (^)(void))ifNoneBlock {
    return [self sia_find2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    } ifNoneBlock:ifNoneBlock];
}

- (NSArray *)sia_filter:(BOOL (^)(id obj))predicate {
    return [self sia_filter2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (NSArray *)sia_findAll:(BOOL (^)(id obj))predicate {
    return [self sia_filter:predicate];
}

- (NSArray *)sia_reject:(BOOL (^)(id obj))predicate {
    return [self sia_reject2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (void)sia_each:(void (^)(id obj))block {
    return [self sia_each2:^(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
}

- (NSArray *)sia_map:(id (^)(id obj))block {
    return [self sia_map2:^id(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
}

- (BOOL)sia_all:(BOOL (^)(id obj))predicate {
    return [self sia_all2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (BOOL)sia_any:(BOOL (^)(id obj))predicate {
    return [self sia_any2:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj);
    }];
}

- (nullable id)sia_maxElement:(NSComparator)cmptr {
    return [self sia_maxElement2:^NSComparisonResult(id obj1, id obj2, BOOL *stop) {
        return cmptr(obj1, obj2);
    }];
}

- (nullable id)sia_minElement:(NSComparator)cmptr {
    return [self sia_minElement2:^NSComparisonResult(id obj1, id obj2, BOOL *stop) {
        return cmptr(obj1, obj2);
    }];
}

- (nullable id)sia_max:(NSComparator)cmptr {
    return [self sia_maxElement:cmptr];
}

- (nullable id)sia_min:(NSComparator)cmptr {
    return [self sia_minElement:cmptr];
}

- (nullable id)sia_reduce:(nullable id)initial combine:(nullable id (^)(id __nullable result, id obj))combine {
    return [self sia_reduce2:initial combine:^id(id result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (NSInteger)sia_reduceInteger:(NSInteger)initial combine:(NSInteger (^)(NSInteger result, id obj))combine {
    return [self sia_reduce2Integer:initial combine:^NSInteger(NSInteger result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (NSUInteger)sia_reduceUInteger:(NSUInteger)initial combine:(NSUInteger (^)(NSUInteger result, id obj))combine {
    return [self sia_reduce2UInteger:initial combine:^NSUInteger(NSUInteger result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (float)sia_reduceFloat:(float)initial combine:(float (^)(float result, id obj))combine {
    return [self sia_reduce2Float:initial combine:^float(float result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (double)sia_reduceDouble:(double)initial combine:(double (^)(double result, id obj))combine {
    return [self sia_reduce2Double:initial combine:^double(double result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (CGFloat)sia_reduceCGFloat:(CGFloat)initial combine:(CGFloat (^)(CGFloat result, id obj))combine {
    return [self sia_reduce2CGFloat:initial combine:^CGFloat(CGFloat result, id obj, NSUInteger idx, BOOL *stop) {
        return combine(result, obj);
    }];
}

- (nullable id)sia_inject:(nullable id (^)(id __nullable result, id obj))injection {
    return [self sia_reduce:nil combine:injection];
}

- (nullable id)sia_inject:(nullable id (^)(id __nullable result, id obj))injection initialValue:(nullable id)initial {
    return [self sia_reduce:initial combine:injection];
}

- (NSInteger)sia_inject:(NSInteger (^)(NSInteger result, id obj))injection initialInteger:(NSInteger)initial {
    return [self sia_reduceInteger:initial combine:injection];
}

- (NSUInteger)sia_inject:(NSUInteger (^)(NSUInteger result, id obj))injection initialUInteger:(NSUInteger)initial {
    return [self sia_reduceUInteger:initial combine:injection];
}

- (float)sia_inject:(float (^)(float result, id obj))injection initialFloat:(float)initial {
    return [self sia_reduceFloat:initial combine:injection];
}

- (double)sia_inject:(double (^)(double result, id obj))injection initialDouble:(double)initial {
    return [self sia_reduceDouble:initial combine:injection];
}

- (CGFloat)sia_inject:(CGFloat (^)(CGFloat result, id obj))injection initialCGFloat:(CGFloat)initial {
    return [self sia_reduceCGFloat:initial combine:injection];
}

@end

@implementation NSEnumerator (SIAEnumerator2)

- (nullable id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    return [self sia_find2:predicate ifNone:nil];
}

- (nullable id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNone:(id)ifNone {
    return [self sia_find2:predicate ifNoneBlock:^id {
        return ifNone;
    }];
}

- (nullable id)sia_find2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate ifNoneBlock:(id (^)(void))ifNoneBlock {
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

- (NSArray *)sia_filter2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
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

- (NSArray *)sia_findAll2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    return [self sia_filter2:predicate];
}

- (NSArray *)sia_reject2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
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

- (void)sia_each2:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
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

- (BOOL)sia_all2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
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

- (BOOL)sia_any2:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
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

- (NSArray *)sia_map2:(id (^)(id obj, NSUInteger idx, BOOL *stop))block {
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

- (nullable id)sia_maxElement2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr {
    id maxObject = nil;
    BOOL stop = NO;
    for (id obj in self) {
        @autoreleasepool {
            if (maxObject == nil) {
                maxObject = obj;
            } else if (cmptr(maxObject, obj, &stop) == NSOrderedAscending) {
                maxObject = obj;
            }
            if (stop) {
                break;
            }
        }
    }
    return maxObject;
}

- (nullable id)sia_minElement2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr {
    id minObject = nil;
    BOOL stop = NO;
    for (id obj in self) {
        @autoreleasepool {
            if (minObject == nil) {
                minObject = obj;
            } else if (cmptr(minObject, obj, &stop) == NSOrderedDescending) {
                minObject = obj;
            }
            if (stop) {
                break;
            }
        }
    }
    return minObject;
}

- (nullable id)sia_max2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr {
    return [self sia_maxElement2:cmptr];
}

- (nullable id)sia_min2:(NSComparisonResult (^)(id obj1, id obj2, BOOL *stop))cmptr {
    return [self sia_minElement2:cmptr];
}

- (nullable id)sia_reduce2:(nullable id)initial combine:(nullable id (^)(id __nullable result, id obj, NSUInteger idx, BOOL *stop))combine {
    id result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (NSInteger)sia_reduce2Integer:(NSInteger)initial combine:(NSInteger (^)(NSInteger result, id obj, NSUInteger idx, BOOL *stop))combine {
    NSInteger result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (NSUInteger)sia_reduce2UInteger:(NSUInteger)initial combine:(NSUInteger (^)(NSUInteger result, id obj, NSUInteger idx, BOOL *stop))combine {
    NSUInteger result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (float)sia_reduce2Float:(float)initial combine:(float (^)(float result, id obj, NSUInteger idx, BOOL *stop))combine {
    float result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (double)sia_reduce2Double:(double)initial combine:(double (^)(double result, id obj, NSUInteger idx, BOOL *stop))combine {
    double result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (CGFloat)sia_reduce2CGFloat:(CGFloat)initial combine:(CGFloat (^)(CGFloat result, id obj, NSUInteger idx, BOOL *stop))combine {
    CGFloat result = initial;
    BOOL stop = NO;
    NSUInteger idx = 0;
    for (id obj in self) {
        @autoreleasepool {
            result = combine(result, obj, idx, &stop);
            if (stop) {
                break;
            }
            idx++;
        }
    }
    return result;
}

- (nullable id)sia_inject2:(nullable id (^)(id __nullable result, id obj, NSUInteger idx, BOOL *stop))injection {
    return [self sia_reduce2:nil combine:injection];
}

- (nullable id)sia_inject2:(nullable id (^)(id __nullable result, id obj, NSUInteger idx, BOOL *stop))injection initialValue:(nullable id)initial {
    return [self sia_reduce2:initial combine:injection];
}

- (NSInteger)sia_inject2:(NSInteger (^)(NSInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialInteger:(NSInteger)initial {
    return [self sia_reduce2Integer:initial combine:injection];
}

- (NSUInteger)sia_inject2:(NSUInteger (^)(NSUInteger result, id obj, NSUInteger idx, BOOL *stop))injection initialUInteger:(NSUInteger)initial {
    return [self sia_reduce2UInteger:initial combine:injection];
}

- (float)sia_inject2:(float (^)(float result, id obj, NSUInteger idx, BOOL *stop))injection initialFloat:(float)initial {
    return [self sia_reduce2Float:initial combine:injection];
}

- (double)sia_inject2:(double (^)(double result, id obj, NSUInteger idx, BOOL *stop))injection initialDouble:(double)initial {
    return [self sia_reduce2Double:initial combine:injection];
}

- (CGFloat)sia_inject2:(CGFloat (^)(CGFloat result, id obj, NSUInteger idx, BOOL *stop))injection initialCGFloat:(CGFloat)initial {
    return [self sia_reduce2CGFloat:initial combine:injection];
}

@end

@interface SIAEnumerator ()
@property (nonatomic, copy) id (^traceBlock)(NSInteger index, id previousObject);
@property (nonatomic, strong) id currentObject;
@end

@implementation SIAEnumerator

+ (SIAEnumerator *)enumeratorWithTraceBlock:(id (^)(NSInteger index, id previousObject))traceBlock {
    SIAEnumerator *enumerator = [[SIAEnumerator alloc] init];
    enumerator.traceBlock = traceBlock;
    return enumerator;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len {
    if (state->state == 0) {
        state->mutationsPtr = (unsigned long *)(__bridge void *)self;
    } else if (self.currentObject == nil) {
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
            } else {
                break;
            }
        }
    }
    
    return containedCount;
}

@end
