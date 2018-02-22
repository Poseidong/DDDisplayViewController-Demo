//
//  DDDisplayViewController.h
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDisplayViewController : UIViewController


@property (nonatomic, strong) UIColor *lineImageViewColor; //default [UIColor lightGrayColor].

/**
 设置整体内容的frame 包括 标题滚动视图和内容滚动视图 设置contentView.frame即可.

 @param contentBlock 整体内容视图
 */
- (void)setupContentViewFrame:(void(^)(UIView *contentView))contentBlock;


/**************************************标题************************************/

/**
 标题的缩进
 */
@property (nonatomic, assign) UIEdgeInsets titleContentInset; //default UIEdgeInsetsZero. add additional scroll area around content

/**
 标题父视图的缩进
 */
@property (nonatomic, assign) UIEdgeInsets titleScrollViewContentInset; //default UIEdgeInsetsZero. add additional scroll area around content

/**
 标题滚动视图背景颜色
 */
@property (nonatomic, strong) UIColor *titleScrollViewColor; //default [UIColor whiteColor].

/**
 标题高度
 */
@property (nonatomic, assign) CGFloat titleHeight; //default 44.

/**
 标题间距
 */
@property (nonatomic, assign) CGFloat titleMargin; //default 20.

/**
 正常标题颜色
 */
@property (nonatomic, strong) UIColor *norColor; //default [UIColor blackColor].

/**
 选中标题颜色
 */
@property (nonatomic, strong) UIColor *selColor; //default [UIColor blackColor].

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont; //default [UIFont systemFontOfSize:15]

/**
 选中标题字体
 */
@property (nonatomic, strong) UIFont *selTitleFont; //default [UIFont boldSystemFontOfSize:15]

/**
 *  选中的背景色
 */
@property (nonatomic, strong) UIColor *selBgColor; //default [UIColor clearColor].


/**************************************下标************************************/

/**
 是否需要下标
 */
@property (nonatomic, assign) BOOL isShowUnderLine; //default YES.

/**
 是否延迟滚动下标
 */
@property (nonatomic, assign) BOOL isDelayScroll; //default NO.

/**
 下标颜色
 */
@property (nonatomic, strong) UIColor *underLineColor; //default [UIColor blackColor].

/**
 下标高度
 */
@property (nonatomic, assign) CGFloat underLineH; //default 2.

/**
 下标距底部距离
 */
@property (nonatomic, assign) CGFloat underLineBottomSpace; //default 0.



@end
