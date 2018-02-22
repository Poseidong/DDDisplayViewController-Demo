//
//  UIView+FrameExt.h
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (FrameExt)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;


@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
