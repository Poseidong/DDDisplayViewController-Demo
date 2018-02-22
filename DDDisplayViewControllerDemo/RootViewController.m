//
//  RootViewController.m
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)setUpAllViewControllers
{
    HomeViewController *vc1 = [[HomeViewController alloc] init];
    vc1.view.backgroundColor = [UIColor magentaColor];
    vc1.title = @"首页";
    [self addChildViewController:vc1];
    
    HomeViewController *vc2 = [[HomeViewController alloc] init];
    vc2.view.backgroundColor = [UIColor orangeColor];
    vc2.title = @"通讯录";
    [self addChildViewController:vc2];
    
    HomeViewController *vc3 = [[HomeViewController alloc] init];
    vc3.view.backgroundColor = [UIColor yellowColor];
    vc3.title = @"朋友圈";
    [self addChildViewController:vc3];
    
    HomeViewController *vc4 = [[HomeViewController alloc] init];
    vc4.view.backgroundColor = [UIColor lightGrayColor];
    vc4.title = @"发现";
    [self addChildViewController:vc4];
    
    HomeViewController *vc5 = [[HomeViewController alloc] init];
    vc5.view.backgroundColor = [UIColor whiteColor];
    vc5.title = @"附近的人";
    [self addChildViewController:vc5];
    
    HomeViewController *vc6 = [[HomeViewController alloc] init];
    vc6.view.backgroundColor = [UIColor darkTextColor];
    vc6.title = @"我";
    [self addChildViewController:vc6];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpAllViewControllers];
    
//    self.lineImageViewColor = [UIColor redColor];
//
    self.titleScrollViewContentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.titleContentInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.titleHeight = 40;
//    self.norColor = [UIColor orangeColor];
//    self.titleFont = [UIFont systemFontOfSize:14];
//    self.selColor = [UIColor redColor];
//    self.selTitleFont = [UIFont boldSystemFontOfSize:14];
//
//    self.underLineH = 2;
//    self.underLineBottomSpace = 0;
//    self.underLineColor = [UIColor redColor];
//
//    self.isDelayScroll = NO;
    
//    [self setupContentViewFrame:^(UIView *contentView) {
//        contentView.frame = CGRectMake(0, 64, 320, 568);
//    }];
    
//    self.isShowUnderLine = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
