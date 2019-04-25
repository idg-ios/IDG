//
//  CXYMAppearanceManager.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMAppearanceManager.h"
#import "UIColor+CXYMCategory.h"

@implementation CXYMAppearanceManager

//app整体风格颜色
+ (UIColor *)appBlueColor {
    return  [UIColor colorFromHexString:@"#579EF5"];
}

+ (UIColor *)appOrangeColor {
    return [UIColor colorFromHexString:@"#ff9900"];
}

+ (UIColor *)appGreenColor {
    return [UIColor colorFromHexString:@"#a8c269"];
}

+ (UIColor *)appBackgroundColor {
    return [UIColor colorFromHexString:@"#F2F2F5"];
}

+ (UIColor *)appSeparatorColor {
    return [UIColor colorFromHexString:@"#e5e5e5"];
}
+ (UIColor *)navigationBarColor{
    return [UIColor colorFromHexString:@"#272D3C"];
}
//常用字体大小
+ (UIFont *)textSuperLagerFont{
    return [UIFont boldSystemFontOfSize:18];
}
+ (UIFont *)textLargeFont {
    return [UIFont systemFontOfSize:17];
}

+ (UIFont *)textNormalFont {
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)textMediumFont {
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)textSmallFont {
    return [UIFont systemFontOfSize:12];
}
+ (UIFont *)textMiniFont{
    return [UIFont systemFontOfSize:10];
}

//常用字体颜色
+ (UIColor *)textNormalColor {
    return [UIColor colorFromHexString:@"#333333"];
}

+ (UIColor *)textDeepGrayColor {
    return [UIColor colorFromHexString:@"#888888"];
}

+ (UIColor *)textLightGrayColor {
    return [UIColor colorFromHexString:@"#bbbbbb"];
}

+ (UIColor *)textWhiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)textOrangeColor {
    return [UIColor colorFromHexString:@"#ff9900"];
}

+ (UIColor *)textBlueColor {
    return [UIColor colorFromHexString:@"#169bd5"];
}
+ (UIColor *)textRedColor{
    return [UIColor colorFromHexString:@"#FF3333"];
}

+ (CGFloat)appStyleCornerRadius {
    return 8.0;
}

+ (CGFloat)appStyleButtonHeight{
    return 44.0;
}
+ (CGFloat)appStyleMargin {
    return 15;
}
//网络错误提示语
+ (NSString *)reachableErrorMessage{
    return @"网络连接失败，请检查网络设置";
}

+ (void)setupAppAppearance {
    
    return;
    //1.StatusBar
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //2.UINavigationBar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UIColor *whiteColor = [UIColor whiteColor];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: whiteColor}];
    [navigationBar setBarTintColor:[self navigationBarColor]];
    [navigationBar setTranslucent:NO];
    navigationBar.tintColor = [UIColor whiteColor];
    
    //2.UIBarButtonItem
    //    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //    [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: whiteColor} forState: UIControlStateNormal];
    //    UIImage *backIndicatorImage = [UIImage imageNamed:@"cn_arrow_left_icon"];
    //    [navigationBar setBackIndicatorImage:backIndicatorImage];
    //    [navigationBar setBackIndicatorTransitionMaskImage:backIndicatorImage];
    //
    //    UIOffset offset = UIOffsetMake(0, -100);
    //    [barButtonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
    //    [barButtonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsCompact];
    //3.UITabBarItem
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [self navigationBarColor]} forState:UIControlStateSelected];
}

@end
