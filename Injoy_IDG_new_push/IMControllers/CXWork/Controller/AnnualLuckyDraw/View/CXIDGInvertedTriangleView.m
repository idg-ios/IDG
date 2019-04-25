//
//  CXIDGInvertedTriangleView.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGInvertedTriangleView.h"
#import "CXIDGAnnualLuckyDrawViewController.h"

@implementation CXIDGInvertedTriangleView

- (instancetype)init
{
    self = [super init];
    self.frame = CGRectMake(0, 0, kRightBtnWidth - (kClickViewLeftSpace*2), kClickBottomSpace);
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 0.0);
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,(kRightBtnWidth - (kClickViewLeftSpace*2) - 5)/2,0);//设置起点
    CGContextAddLineToPoint(context,(kRightBtnWidth - (kClickViewLeftSpace*2))/2,5);
    CGContextAddLineToPoint(context,(kRightBtnWidth - (kClickViewLeftSpace*2) + 5)/2,0);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [RGBACOLOR(246.0, 244.0, 245.0, 1.0) setFill]; //设置填充色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}

@end
