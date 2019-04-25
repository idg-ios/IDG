//
//  CXYMAppearanceManager.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXYMAppearanceManager : NSObject

//app整体风格的颜色,主色系
+ (UIColor *)appBlueColor; ///<蓝色
+ (UIColor *)appOrangeColor; ///<橙色
+ (UIColor *)appGreenColor; ///<绿色
+ (UIColor *)appBackgroundColor; ///<背景色
+ (UIColor *)appSeparatorColor; ///<分割线颜色
+ (UIColor *)navigationBarColor;///<导航条背景色
//常用字体大小
+ (UIFont *)textSuperLagerFont;///<加粗18号字
+ (UIFont *)textLargeFont; ///<大字号,17
+ (UIFont *)textNormalFont; ///<正常字号,16
+ (UIFont *)textMediumFont; ///<中字号,14
+ (UIFont *)textSmallFont; ///<小字号,12
+ (UIFont *)textMiniFont;///<10号字

//常用字体颜色,辅色系
+ (UIColor *)textNormalColor; ///<一般常用字体颜色,333333
+ (UIColor *)textDeepGrayColor; ///<深灰色字体颜色,888888
+ (UIColor *)textLightGrayColor; ///<浅灰色字体颜色
+ (UIColor *)textWhiteColor;  ///<白色字体颜色
+ (UIColor *)textOrangeColor; ///<橙色字体颜色
+ (UIColor *)textBlueColor; ///<蓝色字体颜色
+ (UIColor *)textRedColor; ///<红色字体颜色

//app常用圆角大小
+ (CGFloat)appStyleCornerRadius;
//app常用按钮高度
+ (CGFloat)appStyleButtonHeight;
//app常用的边距
+ (CGFloat)appStyleMargin;
//网络错误提示语
+ (NSString *)reachableErrorMessage;

//设置app统一风格
+ (void)setupAppAppearance;


@end
