//
//  UIView+CXIDGShadow.m
//  InjoyIDG
//
//  Created by wtz on 2018/6/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "UIView+CXIDGShadow.h"

@implementation UIView (CXIDGShadow)

#define uinitpx (Screen_Width/375.0)
#define viewmargin (15 * uinitpx)
#define margin (5*uinitpx)
#define scale (16/46.0)
#define  imageViewSize (46*uinitpx)

-(void)addShadow{
    [self addShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 2)];
}


- (void)addShadowColor:(UIColor *)color
{
    [self addShadowColor:color offset:CGSizeMake(0, 2)];
}

-(void)addShadowColor:(UIColor *)color offset:(CGSize)offsert
{
    UIView * shadowView= [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor whiteColor];
    // 禁止将 AutoresizingMask 转换为 Constraints
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview insertSubview:shadowView belowSubview:self];
    // 添加 right 约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:shadowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.superview addConstraint:rightConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.superview addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.superview addConstraint:topConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.superview addConstraint:bottomConstraint];
    shadowView.layer.shadowColor = color.CGColor;
    shadowView.layer.shadowOffset = offsert;
    shadowView.layer.shadowOpacity = 0.05;
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.cornerRadius = imageViewSize/2.0;
    shadowView.clipsToBounds = NO;
}

@end
