//
//  SDRecordStateView.m
//  SDMarketingManagement
//
//  Created by huihui on 15/11/10.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRecordStateView.h"

@interface SDRecordStateView()

//系列帧动画
@property (nonatomic, strong)NSMutableArray *animationImages;

@end

@implementation SDRecordStateView

#pragma mark -- 创建系列帧动画
-(NSMutableArray *)animationImages
{
    if (_animationImages == nil) {
        
        _animationImages = [NSMutableArray arrayWithCapacity:7];
        for (int i = 1; i <= 7; i ++) {
            UIImage *animationImage = [UIImage imageNamed:[NSString stringWithFormat:@"manager_record%d",i]];
            [_animationImages addObject:animationImage];
        }
        
    }
    
    return _animationImages;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.hidden = YES;
    //创建视图
    [self creatStateView];
}

#pragma mark 创建视图
-(void)creatStateView
{
    //添加录音图像
    self.recordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.recordImageView.image = [UIImage imageNamed:@"manger_record"];
    [self addSubview:self.recordImageView];
    
    //创建录音动画图片
    self.recordingStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5+15, 28.f, 20, 50.f)];
    self.recordingStateImageView.image = [self.animationImages firstObject];
    self.recordingStateImageView.animationImages = self.animationImages;
    self.recordingStateImageView.animationDuration = 1.5f;
    self.recordingStateImageView.animationRepeatCount = 0;
    [self addSubview:self.recordingStateImageView];
}

#pragma mark 开始执行动画
-(void)startAnimating
{
    [self.recordingStateImageView startAnimating];
}

//结束动画
-(void)stopAnimating
{
    [self.recordingStateImageView stopAnimating];
}

@end
