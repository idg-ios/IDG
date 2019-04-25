//
//  MBProgressHUD+CXCategory.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/10/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "MBProgressHUD.h"

#define HUDMessage @"加载中"

@interface MBProgressHUD (CXCategory)

// show
+ (MBProgressHUD *)showHUDForView:(UIView *)view
                             mode:(MBProgressHUDMode)mode
                         animated:(BOOL)animated
                       customView:(UIView *)customView
                             text:(NSString *)text
                       detailText:(NSString *)detailText;

+ (MBProgressHUD *)showHUDForView:(UIView *)view
                             text:(NSString *)text
                       detailText:(NSString *)detailText;

+ (MBProgressHUD *)showHUDForView:(UIView *)view
                             text:(NSString *)text;

+ (MBProgressHUD *)showHUDForView:(UIView *)view
                       customView:(UIView *)customView;


+ (void)showHUDForView:(UIView *)view
                  mode:(MBProgressHUDMode)mode
              animated:(BOOL)animated
            customView:(UIView *)customView
                  text:(NSString *)text
            detailText:(NSString *)detailText
              duration:(CGFloat)duration;

+ (void)showHUDForView:(UIView *)view
                  text:(NSString *)text
            detailText:(NSString *)detailText
              duration:(CGFloat)duration;

+ (void)showHUDForView:(UIView *)view
                  text:(NSString *)text
              duration:(CGFloat)duration;

+ (void)showHUDForView:(UIView *)view
            customView:(UIView *)customView
              duration:(CGFloat)duration;

//hide
+ (void)hideHUDInMainQueueForView:(UIView *)view;

- (void)hideInMainQueue:(BOOL)animated afterDalay:(CGFloat)delay;

- (void)hideInMainQueue;


// toast
+ (void)toastAtBottomForView:(UIView *)view
                        text:(NSString *)text
                  detailText:(NSString *)detailText
                    duration:(CGFloat)duraton;

+ (void)toastAtBottomForView:(UIView *)view
                        text:(NSString *)text
                    duration:(CGFloat)duraton;

+ (void)toastAtCenterForView:(UIView *)view
                        text:(NSString *)text
                  detailText:(NSString *)detailText
                    duration:(CGFloat)duraton;

+ (void)toastAtCenterForView:(UIView *)view
                        text:(NSString *)text
                    duration:(CGFloat)duraton;

@end
