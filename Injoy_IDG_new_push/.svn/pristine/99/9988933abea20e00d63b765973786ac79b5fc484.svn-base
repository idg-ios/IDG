//
//  CXIDGBackGroundViewUtil.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/16.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGBackGroundViewUtil.h"

@implementation CXIDGBackGroundViewUtil

#define kSYTextColor RGBACOLOR(231.0, 231.0, 231.0, 1.0)
#define kSYTextFontSize 22.0
#define kSYTextRotation (-M_PI/4.0)
#define kSYTextWidth (Screen_Width/4.6)
#define kSYTextHeight (90.0)
#define kSYTextTag (77777)

+ (UIImage *)imageWithText:(NSString *)text AndTextColor:(UIColor *)textColor{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSYTextWidth, kSYTextHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor?textColor:kSYTextColor;
    label.text = text;
    label.font = [UIFont systemFontOfSize:kSYTextFontSize];
    label.transform = CGAffineTransformMakeRotation(kSYTextRotation);
    [view addSubview:label];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kSYTextWidth, kSYTextHeight), NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)colorWithText:(NSString *)text AndTextColor:(UIColor *)textColor{
    return [[UIColor alloc] initWithPatternImage:[CXIDGBackGroundViewUtil imageWithText:text AndTextColor:textColor]];
}

+ (void)coverTextWithTagOnView:(UIView *)view Frame:(CGRect)rect Text:(NSString *)text AndTextColor:(UIColor *)textColor{
    [[view viewWithTag:kSYTextTag] removeFromSuperview];
    UIView * coverView = [[UIView alloc] init];
    coverView.frame = rect;
    coverView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:text AndTextColor:textColor];
    coverView.userInteractionEnabled = NO;
    coverView.tag = kSYTextTag;
    
    [view addSubview:coverView];
    [view sendSubviewToBack:coverView];
}

+ (void)coverTextWithNoTagOnView:(UIView *)view Frame:(CGRect)rect Text:(NSString *)text AndTextColor:(UIColor *)textColor{
    UIView * coverView = [[UIView alloc] init];
    coverView.frame = rect;
    coverView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:text AndTextColor:textColor];
    coverView.userInteractionEnabled = NO;
    
    [view addSubview:coverView];
    [view sendSubviewToBack:coverView];
}

+ (void)coverTextWithNoTagOnTopView:(UIView *)view Frame:(CGRect)rect Text:(NSString *)text AndTextColor:(UIColor *)textColor{
    UIView * coverView = [[UIView alloc] init];
    coverView.frame = rect;
    coverView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:text AndTextColor:textColor];
    coverView.userInteractionEnabled = NO;
    
    [view addSubview:coverView];
}

@end
