//
//  DDDisplayViewController.m
//  DDDisplayViewControllerDemo
//
//  Created by Poseidon on 2018/2/9.
//  Copyright © 2018年 Poseidon. All rights reserved.
//

#import "DDDisplayViewController.h"
#import "DDDisplayHeader.h"
#import "DDTitleLabel.h"

static NSInteger const baseTag = 10000;

@interface DDDisplayViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *contentView;//内容视图 包括标题 和 内容
@property (nonatomic, strong) UIScrollView *titleScrollView;//标题视图
@property (nonatomic, strong) UICollectionView *contentCollectionView;//内容视图
@property (nonatomic, strong) UIImageView *lineImageView;//标题和内容分割线
@property (nonatomic, strong) UIView *underLine;//选中标题下标

@property (nonatomic, strong) NSMutableArray <DDTitleLabel *> *titleLables;//存放所有的标题视图

@property (nonatomic, assign) NSInteger selectIndex;//当前选择的索引

@property (nonatomic, assign) BOOL isClickTitle;//是否点击标题 YES:执行点击标题动画 不执行scrollViewDidScroll:相关操作

@end

@implementation DDDisplayViewController
#pragma mark - setMethod
- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex != selectIndex) {
        _selectIndex = selectIndex;
        [self resetAllTitleLabels];
    }
}

- (void)setupContentViewFrame:(void(^)(UIView *contentView))contentBlock
{
    if (contentBlock) {
        contentBlock(self.contentView);
        [self setupSubViewsFrame];
    }
}

- (void)setLineImageViewColor:(UIColor *)lineImageViewColor
{
    _lineImageViewColor = lineImageViewColor;
    self.lineImageView.backgroundColor = lineImageViewColor;
}

/**************************************标题************************************/
- (void)setTitleScrollViewContentInset:(UIEdgeInsets)titleScrollViewContentInset
{
    _titleScrollViewContentInset = titleScrollViewContentInset;
    self.titleScrollView.contentInset = titleScrollViewContentInset;
}
- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    _titleScrollViewColor = titleScrollViewColor;
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}
- (void)setTitleHeight:(CGFloat)titleHeight
{
    _titleHeight = titleHeight;
    self.titleScrollView.height = titleHeight;
    self.underLine.y = titleHeight - self.underLineH - self.underLineBottomSpace;
    self.lineImageView.y = titleHeight - 0.5;
    self.contentCollectionView.frame = CGRectMake(0, titleHeight, self.contentView.width, self.contentView.height-titleHeight);
}

/**************************************下标************************************/
- (void)setUnderLineBottomSpace:(CGFloat)underLineBottomSpace
{
    _underLineBottomSpace = underLineBottomSpace;
    self.underLine.y = self.titleHeight - self.underLineH - underLineBottomSpace;
}
- (void)setUnderLineColor:(UIColor *)underLineColor
{
    _underLineColor = underLineColor;
    self.underLine.backgroundColor = underLineColor;
}
- (void)setUnderLineH:(CGFloat)underLineH
{
    _underLineH = underLineH;
    self.underLine.height = underLineH;
    self.underLine.y = self.titleHeight - underLineH - self.underLineBottomSpace;
}

#pragma mark - UIEvent
//点击标题
- (void)titleClikced:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - baseTag;
    if (index == self.selectIndex) return; //点击当前显示的标题 不执行操作  或者在次添加代理执行方法

    self.isClickTitle = YES;
    //点击其他标题
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //记录当前索引
    self.selectIndex = index;
    [self adjustTitlePosition];
    //下标移动动画
    [self underLineMoveAnimation:YES];
    //内容视图动画
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
}

#pragma mark - UseMethod
//刷新所有的标题
- (void)refreshTitleView
{
    NSUInteger count = self.childViewControllers.count;
    if (!count) return;
    
    if (self.titleLables.count) {
        [self.titleLables removeAllObjects];
        [self.titleLables makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    //设置所有标题
    [self setupAllTitleLabels];
    //设置标题视图frame和contentSize
    [self setupTitleScrollView];
}
//设置标题视图frame和contentSize
- (void)setupTitleScrollView
{
    DDTitleLabel *label = [self.titleLables lastObject];
    if (label) {
        CGFloat totalW = label.x + label.width + self.titleScrollView.contentInset.left + self.titleScrollView.contentInset.right;
        self.titleScrollView.contentSize = CGSizeMake(totalW, self.titleHeight);
        if (totalW >= self.contentView.width) {
            self.titleScrollView.width = self.contentView.width;
        } else {
            self.titleScrollView.width = totalW;
            self.titleScrollView.x = (self.contentView.width - totalW)/2.0;
        }
    }
}
//设置所有标题
- (void)setupAllTitleLabels
{
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    for (int i = 0; i < titles.count; i++) {
        NSString *title = [titles objectAtIndex:i];
        if ([title isKindOfClass:[NSNull class]]) {
            // 抛异常
            NSException *excp = [NSException exceptionWithName:@"DDDisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [excp raise];
        }
        
        DDTitleLabel *label = [[DDTitleLabel alloc] init];
        label.text = title;
        label.tag = i + baseTag;
        [label addTarget:self action:@selector(titleClikced:)];
        //设置选中标题状态
        if (i == self.selectIndex) {
            label.font = self.selTitleFont;
            label.textColor = self.selColor;
            label.backgroundColor = self.selBgColor;
        } else {
            label.font = self.titleFont;
            label.textColor = self.norColor;
            label.backgroundColor = [UIColor clearColor];
        }
        
        //x 坐标
        CGFloat x = 0;
        DDTitleLabel *lastLabel = [self.titleLables lastObject];
        if (lastLabel) {
            x = lastLabel.x + lastLabel.width + self.titleMargin;
        }
        //width
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:label.font}];
        CGFloat labelW = ceil(size.width) + self.titleContentInset.left + self.titleContentInset.right;
        //frame
        label.frame = CGRectMake(x, self.titleContentInset.top, labelW, self.titleHeight - self.titleContentInset.bottom);
        
        //设置下标位置
        if (i == self.selectIndex) {
            self.underLine.x = label.x;
            self.underLine.width = labelW;
        }
        
        [self.titleScrollView addSubview:label];
        [self.titleLables addObject:label];
        
    }
    [self.titleScrollView bringSubviewToFront:self.underLine];
}
//重置所有标题
- (void)resetAllTitleLabels
{
    //记录上一个label 设置下一个label的 x 坐标
    __block DDTitleLabel *lastLabel;
    [self.titleLables enumerateObjectsUsingBlock:^(DDTitleLabel * _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.selectIndex) {
            label.font = self.selTitleFont;
            label.textColor = self.selColor;
            label.backgroundColor = self.selBgColor;
        } else {
            label.font = self.titleFont;
            label.textColor = self.norColor;
            label.backgroundColor = [UIColor clearColor];
        }
        //x坐标
        if (lastLabel) {
            label.x = lastLabel.x + lastLabel.width + self.titleMargin;
        }
        //width
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        CGFloat labelW = ceil(size.width) + self.titleContentInset.left + self.titleContentInset.right;
        label.width = labelW;
        
        lastLabel = label;
    }];
}

#pragma mark - 下标移动动画
//点击标题下标移动动画
- (void)underLineMoveAnimation:(BOOL)animation
{
    DDTitleLabel *label = [self.titleLables objectAtIndex:self.selectIndex];
    if (label) {
        NSTimeInterval duration = animation ? 0.25 : 0;
        [UIView animateWithDuration:duration animations:^{
            self.underLine.x = label.x;
            self.underLine.width = label.width;
        } completion:^(BOOL finished) {
            self.isClickTitle = NO;
        }];
    }
}
/**
 滑动内容视图下标移动动画

 @param nextIndex 下一个标题的索引
 @param offsetX 当前标题的偏移量与滑动偏移量的差值
 */
- (void)underLineMoveWithNextIndex:(NSInteger)nextIndex offset:(CGFloat)offsetX
{
    //如果越界直接返回
    if (nextIndex < 0 || nextIndex > self.titleLables.count) return;
    //当前的标题
    DDTitleLabel *selectL = [self.titleLables objectAtIndex:self.selectIndex];
    //下一个标题
    DDTitleLabel *nextL = [self.titleLables objectAtIndex:nextIndex];
    //标题宽度差值
    CGFloat difTitleW = nextL.width - selectL.width;
    //标题X坐标的差值
    CGFloat difTitleX = nextL.x - selectL.x;
    //滑动比例
    CGFloat ratio = fabs(offsetX/self.contentView.width);
    //设置洗标的x坐标和宽度
    self.underLine.x = selectL.x + ratio * difTitleX;
    self.underLine.width = selectL.width + ratio *difTitleW;
    
    //记录当前索引
    int difOffsetX = (int)round(offsetX/self.contentView.width);
    if (abs(difOffsetX) == 1) {
        //如果偏移大于一半 就记录索引
        self.selectIndex = nextIndex;
        [self adjustTitlePosition];
    }
}
//适应title的位置 全部显示在父视图(contentView)内
- (void)adjustTitlePosition
{
    DDTitleLabel *titleL = [self.titleLables objectAtIndex:self.selectIndex];
    //将 self.titleScrollView 视图上的 titleL 的 frame 转化为 titleL 相对于 self.contentView 的 frame
    CGRect rect = [self.titleScrollView convertRect:titleL.frame toView:self.contentView];
    if (rect.origin.x < 0) {
        //如果当前标题在父视图左边侧显示不全(不显示)
        [self.titleScrollView setContentOffset:CGPointMake(titleL.x - self.titleScrollView.contentInset.left, 0) animated:YES];
    }
    if (rect.origin.x+rect.size.width > self.contentView.width) {
        //如果当前标题在父视图右侧显示不全(不显示)
        [self.titleScrollView setContentOffset:CGPointMake(titleL.x + titleL.width + self.titleScrollView.contentInset.right - self.contentView.width, 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //延迟滚动 不执行下列操作
    if (self.isDelayScroll) return;
    //如果点击标题不执行下面的操作
    if (self.isClickTitle) return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    //当前停留标题的偏移量
    CGFloat selectOffsetX = self.selectIndex * self.contentView.width;
    //偏移量的差值
    CGFloat difOffsetX = offsetX - selectOffsetX;
    //下一个标题的索引
    NSInteger nextIndex;
    if (difOffsetX > 0) {// 右滑
        nextIndex = (NSInteger)ceil(offsetX/self.contentView.width);
    } else {// 左滑
        nextIndex = (NSInteger)floor(offsetX/self.contentView.width);
    }
    //执行动画
    [self underLineMoveWithNextIndex:nextIndex offset:difOffsetX];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //延迟滚动
    if (self.isDelayScroll) {
        NSInteger index = (NSInteger)round(scrollView.contentOffset.x/self.contentView.width);
        if (index == self.selectIndex) return; //滑动到当前显示的标题(滑动后回到起始标题) 不执行操作
        
        //记录当前索引
        self.selectIndex = index;
        [self adjustTitlePosition];
        //下标移动动画
        [self underLineMoveAnimation:YES];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    //移除之前的子视图
    if (cell.contentView.subviews.count) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    UIViewController *vc = self.childViewControllers[indexPath.item];
    vc.view.frame = CGRectMake(0, 0, self.contentCollectionView.width, self.contentCollectionView.height);
    [cell.contentView addSubview:vc.view];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentCollectionView.bounds.size;
}

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initState];
    [self initUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.childViewControllers.count) {
        self.contentView.hidden = NO;
        self.underLine.hidden = !self.isShowUnderLine;
        [self refreshTitleView];
        [self.contentCollectionView reloadData];
    }
}

#pragma mark - initUI
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleScrollView];
    [self.contentView addSubview:self.contentCollectionView];
    [self.contentView addSubview:self.lineImageView];
    [self.titleScrollView addSubview:self.underLine];

    [self setupSubViewsFrame];
    
}

- (void)setupSubViewsFrame
{
    self.titleScrollView.frame = CGRectMake(0, 0, self.contentView.width, self.titleHeight);
    self.contentCollectionView.frame = CGRectMake(0, self.titleHeight, self.contentView.width, self.contentView.height-self.titleHeight);
    self.lineImageView.frame = CGRectMake(0, self.titleHeight-0.5, self.contentView.width, 0.5);
    self.underLine.frame = CGRectMake(0, self.titleHeight-self.underLineH-self.underLineBottomSpace, 100, self.underLineH);
}

- (void)initState
{
    self.selectIndex = 0;
    //标题
    self.titleMargin = DDTitleMargin;
    self.titleHeight = DDTitleHeight;
    self.titleFont = DDNormalTitleFont;
    self.norColor = DDNormalTitleColor;
    self.selTitleFont = DDSelectTitleFont;
    self.selColor = DDSelectTitleColor;
    self.selBgColor = DDSelectTitleBgColor;
    //下标
    self.isShowUnderLine = YES;
    self.underLineH = DDUnderLineH;
    self.underLineBottomSpace = DDUnderLineBottomSpace;
    self.underLineColor = DDUnderLineColor;
}

#pragma mark - lazyLoad
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DDTopHeight, DDScreenW, DDScreenH-DDTopHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.hidden = YES;
    }
    return _contentView;
}
- (UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _titleScrollView;
}
- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineImageView;
}
- (UICollectionView *)contentCollectionView
{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, DDScreenW, DDScreenH-64) collectionViewLayout:layout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        [_contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
    }
    return _contentCollectionView;
}
- (UIView *)underLine
{
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = [UIColor blackColor];
        _underLine.hidden = YES;
    }
    return _underLine;
}
- (NSMutableArray *)titleLables
{
    if (!_titleLables) {
        _titleLables = @[].mutableCopy;
    }
    return _titleLables;
}

@end
