//
//  WMSegmentViewController.m
//  InjoyYZDZ
//
//  Created by 念念不忘必有回响 on 2018/5/23.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "WMSegmentViewController.h"


@interface WMSegmentViewController ()<UIScrollViewDelegate>

/**顶部视图容器*/
@property (nonatomic,weak) UIScrollView *titleScrollView;

/**中间视图容器*/
@property (nonatomic,weak) UIScrollView *containerView;

/**顶部下划线*/
@property (nonatomic,weak) UIView *lineView;

@property (nonatomic,strong) NSArray <NSString *>*titlesArray;
@property (nonatomic,strong) NSArray <NSString *>*imagesArray;
@property (nonatomic,strong) NSArray <NSString *>*selectImagesArray;
/**所有按钮的宽度*/
@property (nonatomic,strong) NSMutableArray <NSNumber *>*titlesForW;

/**所有按钮*/
@property (nonatomic,strong) NSMutableArray <UIButton *>*titlesButton;

/**topView间距*/
@property (nonatomic,assign) NSInteger spacing;





@end

@implementation WMSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titlesForW = [[NSMutableArray alloc]init];
    _titlesButton = [[NSMutableArray alloc]init];
    
    _spacing = 10;
}


#pragma mark - 头部视图部分
-(void)segmentWithTitles:(NSArray<NSString *> *)titles images:(NSArray<NSString *> *)images selectImages:(NSArray<NSString *> *)selectImages{
    
    if (titles.count == 0 || titles == nil) {
        return;
    }
    _titlesArray = titles;
    self.imagesArray = images;
    self.selectImagesArray = selectImages;
    UIScrollView * topView = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, 50))];
    topView.showsVerticalScrollIndicator = NO;
    topView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:topView];
    self.titleScrollView = topView;
    
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(topView.frame)))];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    self.containerView = contentView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blueColor];
    self.lineView = lineView;
    
    CGFloat scrollW = 0;
    CGFloat titleForW = 0;
    CGFloat titleForX = 0;
    NSInteger spacing = _spacing;
    NSInteger titleFont = 15;
    
#pragma mark - 暂时加入
    if (titles.count == 2) {
        
        titleForW = (self.view.frame.size.width-(titles.count+1)*spacing)/4;
        titleForX = titleForW;
    }else{
        titleForW = (self.view.frame.size.width-(titles.count+1)*spacing)/titles.count;
    }
    for (int i = 0; i < titles.count; i++) {
        NSString *titleString = [titles objectAtIndex:i];
        CGRect titelSize = [self stringHeightByWidth:self.view.frame.size.width title:titleString font:[UIFont systemFontOfSize:titleFont]];
        if (titleForW > titelSize.size.width) {
            [_titlesForW addObject:[NSNumber numberWithFloat:titleForW]];
        }else{
            [_titlesForW addObject:[NSNumber numberWithFloat:titelSize.size.width]];
        }
    }
    
    for (int i = 0; i<titles.count; i++) {
        
        NSNumber *number = [_titlesForW objectAtIndex:i];
        scrollW = scrollW + number.floatValue;
        
        UIButton *titleButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [titleButton setTag:100+i];
        [titleButton setTitle:[titles objectAtIndex:i] forState:(UIControlStateNormal)];
        [titleButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:titleFont];
        titleButton.frame = CGRectMake(titleForX + spacing, 0, number.floatValue, 48);
        titleForX = number.floatValue + titleButton.frame.origin.x;
        [titleButton addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
        titleButton.userInteractionEnabled = YES;
        [topView addSubview:titleButton];
        [_titlesButton addObject:titleButton];
        
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 25);
        
        CGRect lineSize = [self stringHeightByWidth:self.view.frame.size.width title:[titles objectAtIndex:i] font:[UIFont systemFontOfSize:titleFont]];
        
        if (i == 0) {
            if (lineSize.size.width+30 < number.floatValue) {
    lineView.frame = CGRectMake(CGRectGetMinX(titleButton.frame)-10+((number.floatValue-lineSize.size.width-10)/2), CGRectGetMaxY(titleButton.frame)-2, lineSize.size.width+30, 2);

            }else{
                lineView.frame = CGRectMake(0, CGRectGetMaxY(titleButton.frame)-2, number.floatValue, 2);
            }
            [self.view addSubview:lineView];
            
            [titleButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            [titleButton setImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateNormal];
        }else{
            [titleButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [titleButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        }
        
        
    }
    topView.contentSize = CGSizeMake(scrollW + (titles.count+1)*spacing, 50);
    
}

#pragma mark - 头部按钮点击方法
-(void)clickButton:(UIButton *)sender{
    
    for (int i = 0; i<self.titlesButton.count; i++) {
        UIButton *select = [self.titlesButton objectAtIndex:i];
        if (sender.tag == i+100) {
            [select setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            [select setImage:[UIImage imageNamed:self.selectImagesArray[i]] forState:UIControlStateNormal];
        }else{
            [select setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [select setImage:[UIImage imageNamed:self.imagesArray[i]] forState:UIControlStateNormal];
        }
    }
    if (_titlesArray.count == 2) {
        [self selectButtonWithLineView:sender];
    }else{
        [self selectedTitleCenter:sender titlesScrollView:_titleScrollView];


    }
    
}
#pragma mark - 选中按钮下划线改变
-(void)selectButtonWithLineView:(UIButton *)button{
    NSInteger index = button.tag-100;
    NSNumber *number = [_titlesForW objectAtIndex:index];
    
    CGRect lineSize = [self stringHeightByWidth:self.view.frame.size.width title:button.titleLabel.text font:[UIFont systemFontOfSize:15]];
    CXWeakSelf(self)
    [UIView animateWithDuration:0.2 delay:0.04 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        
        if (lineSize.size.width+30 < number.floatValue) {
            //获取button原始x轴之后加上下划线宽的一半
            weakself.lineView.frame = CGRectMake(CGRectGetMinX(button.frame)-10+((number.floatValue-lineSize.size.width-10)/2), CGRectGetMaxY(button.frame)-2, lineSize.size.width+30, 2);
        }else{
            weakself.lineView.frame = CGRectMake(CGRectGetMinX(button.frame)-10, CGRectGetMaxY(button.frame)-2,number.floatValue, 2);
        }
        
    } completion:^(BOOL finished) {
        
    }];
    [self setupChildViewScrollAnimal:button];
    
    
}
#pragma mark - 点击按钮 topView 适当偏移
- (void)selectedTitleCenter:(UIButton *)button titlesScrollView:(UIScrollView *)titlesScrollView{
    
    CGFloat offsetX = button.center.x - titlesScrollView.frame.size.width * 0.6;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = titlesScrollView.contentSize.width - titlesScrollView.frame.size.width;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [titlesScrollView setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    
    [self selectButtonWithLineView:button];
    
    
}
#pragma mark - 点击topButton contnetScroll偏移
-(void)setupChildViewScrollAnimal:(UIButton *)titleButton
{
    if (_isChildScollAnimal) {
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint offset = self.containerView.contentOffset;
            offset.x = (titleButton.tag - 100) * self.view.frame.size.width;
            [self.containerView setContentOffset:offset animated:NO];
        }];
    }else{
        CGPoint offset = self.containerView.contentOffset;
        offset.x = (titleButton.tag - 100)* self.view.frame.size.width;
        [self.containerView setContentOffset:offset animated:NO];
    }
    [self addChildVcView];
    
}
#pragma mark - 中间视图部分
-(void)segmentWithChildViewArrays:(NSArray<UIViewController *> *)childControllerArray{
    
    if (self.childViewControllers.count == 0) {
        self.containerView.contentSize = CGSizeMake(childControllerArray.count*self.view.frame.size.width, self.view.frame.size.height-50);
        
        for (int i = 0; i< childControllerArray.count; i++) {
            UIViewController *baseView = [childControllerArray objectAtIndex:i];
            [self addChildViewController:baseView];
        }
        [self addChildVcView];
    }
    
}

- (void)addChildVcView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSInteger index = round(self.containerView.contentOffset.x / self.view.frame.size.width);
    
    if ([self.delegate respondsToSelector:@selector(selectTopTitleForIndex:)]) {
        [self.delegate selectTopTitleForIndex:index];
    }
    
    UIViewController *childVc;
    if (index >= self.childViewControllers.count) {
        return;
    }
    childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    childVc.view.frame = _containerView.bounds;
    [_containerView addSubview:childVc.view];
    
    
}

#pragma mark - 公共部分
- (CGRect)stringHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font
{
    CGRect ContentRect = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return ContentRect;
}
#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = round(scrollView.contentOffset.x / self.view.frame.size.width);
    [self setSelectedItemAtIndex:index];
}
- (void)setSelectedItemAtIndex:(NSInteger)index {
    for (UIView *view in _titleScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag-100 == index) {
            UIButton *button = (UIButton *)view;
            [self clickButton:button];
        }
    }
}


@end
