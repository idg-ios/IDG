//
//  UIBarButtonItem+Extension.m
//  injoy_XJPDC
//
//  Created by 念念不忘必有回响 on 2018/8/28.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.frame = CGRectMake(0, 0, 21, 21);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+(UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action andTitleFont:(CGFloat)fontSize
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button setTitle:title forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    //设置按钮的尺寸
    button.frame = CGRectMake(0, 0, 50, 50);

    //监听按钮点击
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
+(UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:titleColor forState:0];
    [button setTitle:title forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    //设置按钮的尺寸
    button.frame = CGRectMake(0, 0, 34, 34);

    //监听按钮点击
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
