//
//  DDDisplayHeader.h
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#ifndef DDDisplayHeader_h
#define DDDisplayHeader_h

#import "UIView+FrameExt.h"

#define DDNavigationBarHeight (44.)
#define DDScreenStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define DDTopHeight (DDNavigationBarHeight + DDScreenStatusBarHeight)

#define DDScreenW [UIScreen mainScreen].bounds.size.width
#define DDScreenH [UIScreen mainScreen].bounds.size.height

static NSString * const DDDisplayViewClickOrScrollDidFinshNotification = @"DDDisplayViewClickOrScrollDidFinshNotification";

static NSString * const CELLID = @"cell";
//标题高度
static CGFloat const DDTitleHeight = 44;
//标题间距
static CGFloat const DDTitleMargin = 20;
//标题字号(正常)
#define DDNormalTitleFont [UIFont systemFontOfSize:15]
//标题颜色
#define DDNormalTitleColor [UIColor blackColor]
//选中标题字号(选中)
#define DDSelectTitleFont [UIFont boldSystemFontOfSize:15]
//选中标题颜色
#define DDSelectTitleColor [UIColor blackColor]
//选中标题颜色背景颜色
#define DDSelectTitleBgColor [UIColor clearColor]

//下标高度
static CGFloat const DDUnderLineH = 2;
//下标距离底部的距离
static CGFloat const DDUnderLineBottomSpace = 0;
//下标颜色
#define DDUnderLineColor [UIColor blackColor]



#endif /* DDDisplayHeader_h */
