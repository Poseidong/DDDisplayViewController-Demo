//
//  DDTitleLabel.m
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#import "DDTitleLabel.h"

@implementation DDTitleLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initState];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initState];
    }
    return self;
}

- (void)initState
{
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:15];
    self.userInteractionEnabled = YES;
}

- (void)addTarget:(nullable id)target action:(nullable SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

@end
