//
//  UIView+SIAEnumerator.h
//  SIAEnumerator
//
//  Created by KUROSAKI Ryota on 2013/12/20.
//  Copyright (c) 2013-2018 SI Agency Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SIAEnumerator)

- (NSEnumerator *)sia_superviewEnumerator;
- (NSEnumerator *)sia_recursiveSubviewsEnumerator;
- (NSEnumerator *)sia_recursiveSubviewsEnumeratorWithMaxDepth:(NSInteger)maxDepth;

- (nullable UIView *)sia_recursiveSubviewAtIndex:(NSInteger)index maxDepth:(NSInteger)maxDepth;
- (nullable UIView *)sia_nextRecursiveSubviewWithPreviousView:(nullable UIView *)currentView maxDepth:(NSInteger)maxDepth;
- (nullable UIView *)sia_nextSiblingSubviewWithPreviousView:(UIView *)currentView;
- (NSInteger)sia_depthToView:(UIView *)view;

@end

@interface SIASubviewsEnumerator : NSEnumerator

- (instancetype)initWithView:(UIView *)rootView maxDepth:(NSInteger)maxDepth;

@property (nonatomic, strong, readonly) UIView *rootView;
@property (nonatomic, assign, readonly) NSInteger maxDepth;

@end

NS_ASSUME_NONNULL_END
