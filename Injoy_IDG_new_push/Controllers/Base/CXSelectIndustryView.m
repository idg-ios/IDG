//
//  CXSelectIndustryView.m
//  InjoyERP
//
//  Created by haihualai on 2016/12/21.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXSelectIndustryView.h"

#define INDUSTRY_CONTENT_HEIGHT 45.f
#define INDUSTRY_TITLE_HEIGHT   35.f
#define INDUSTRY_SPACE  10.f
#define INDUSTRY_MAGRIN_X Screen_Width*0.10

@implementation CXSelectIndustryView

#pragma mark -- 创建行业选择视图
-(instancetype)init
{
    if (self = [super init]) {
        
        CGFloat orgin_x = INDUSTRY_MAGRIN_X;
        CGFloat height =  INDUSTRY_TITLE_HEIGHT + 6*INDUSTRY_CONTENT_HEIGHT + 8*INDUSTRY_SPACE;
        CGFloat orgin_y = (Screen_Height - height)/2.f;
        CGFloat width = Screen_Width - 2*INDUSTRY_MAGRIN_X;
        [self setFrame:CGRectMake(orgin_x, orgin_y, width, height)];
        [self setBackgroundColor:kColorWithRGB(242, 250, 240)];
        self.layer.cornerRadius = 3.f;
        
        //    创建界面
        [self createUI];
    }
    return self;
}


#pragma mark -- 创建界面
-(void)createUI
{
    //标题
    CGFloat width = self.frame.size.width - 2*INDUSTRY_SPACE;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(INDUSTRY_SPACE, INDUSTRY_SPACE, width, INDUSTRY_TITLE_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择所在行业";
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self addSubview:titleLabel];
    
    NSArray *contentArray = @[@"综合行业",@"服装鞋帽业",@"电器业",@"五金工具业",@"食品业",@"电商业"];
    CGFloat origin_y = 2*INDUSTRY_SPACE + INDUSTRY_TITLE_HEIGHT;
    for (NSInteger i = 0; i < 6; i++) {
        
        //添加背景视图
        CGFloat item_y = origin_y + i*(INDUSTRY_CONTENT_HEIGHT+INDUSTRY_SPACE);
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(INDUSTRY_SPACE, item_y, width, INDUSTRY_CONTENT_HEIGHT)];
        [bgView setBackgroundColor:kColorWithRGB(215, 235, 209)];
        bgView.layer.cornerRadius = 3.f;
        bgView.tag = i+1;
        [self addSubview:bgView];
        
        //添加内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(INDUSTRY_SPACE+6.f, INDUSTRY_SPACE, 120.f, INDUSTRY_CONTENT_HEIGHT-2*INDUSTRY_SPACE)];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        contentLabel.text = contentArray[i];
        contentLabel.tag = i+1;
        contentLabel.userInteractionEnabled = YES;
        contentLabel.font = [UIFont systemFontOfSize:18.f];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:contentLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width - INDUSTRY_SPACE - 8.f, 15.f, 8.f, 15.f)];
        imageView.image = [UIImage imageNamed:@"erp_industry"];
        [bgView addSubview:imageView];
        
        //添加点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTap:)];
        [bgView addGestureRecognizer:tap];
    }
}

#pragma mark -- 单个视图点击事件
-(void)itemViewTap:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    NSInteger tag = tapView.tag;
    
    NSInteger clickIndex = 0;
    
    switch (tag) {
        case 1:
            clickIndex = 1;
            break;
            
        case 2:
            clickIndex = 2;
            break;
            
        case 3:
            clickIndex = 5;
            break;
            
        case 4:
            clickIndex = 3;
            break;
            
        case 5:
            clickIndex = 4;
            break;
            
        case 6:
            clickIndex = 6;
            break;
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(industryView:clickItem:)]) {
        [self.delegate industryView:self clickItem:clickIndex];
    }
    
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)showInView:(UIView *)view
{
    UIView *bgView = [[UIView alloc] initWithFrame:view.frame];
    [bgView setBackgroundColor:[UIColor colorWithRed:67/255.f green:71/255.f blue:69/255.f alpha:0.5]];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [bgView addGestureRecognizer:tap];
    
    [view addSubview:bgView];
    self.bgView = bgView;
    [view addSubview:self];
}

#pragma mark -- 点击页面的事件
-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.bgView];
    if (!CGRectContainsPoint(self.frame, location)) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }
}

@end
