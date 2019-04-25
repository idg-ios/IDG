//
//  MBProgressHUD+CXCategory.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/10/9.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "MBProgressHUD+CXCategory.h"

@implementation MBProgressHUD (CXCategory)

+(MBProgressHUD *)showHUDForView:(UIView *)view
                            mode:(MBProgressHUDMode)mode
                        animated:(BOOL)animated
                      customView:(UIView *)customView
                            text:(NSString *)text
                      detailText:(NSString *)detailText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    hud.customView = customView;
    hud.labelText = text;
    hud.detailsLabelText = detailText;
    return hud;
}

+(MBProgressHUD *)showHUDForView:(UIView *)view
                            text:(NSString *)text
                      detailText:(NSString *)detailText {
    
    return [self showHUDForView:view
                           mode:MBProgressHUDModeIndeterminate
                       animated:YES
                     customView:nil
                           text:text
                     detailText:detailText];
}


+(MBProgressHUD *)showHUDForView:(UIView *)view
                            text:(NSString *)text {
    return [self showHUDForView:view text:text detailText:nil];
}

+(MBProgressHUD *)showHUDForView:(UIView *)view
                      customView:(UIView *)customView {
    
    return [self showHUDForView:view
                           mode:MBProgressHUDModeCustomView
                       animated:YES
                     customView:view
                           text:nil
                     detailText:nil];
}

+ (void)showHUDForView:(UIView *)view
                  mode:(MBProgressHUDMode)mode
              animated:(BOOL)animated
            customView:(UIView *)customView
                  text:(NSString *)text
            detailText:(NSString *)detailText
              duration:(CGFloat)duration {
    if ([NSThread currentThread].isMainThread) {
        MBProgressHUD *hud = [self showHUDForView:view mode:mode animated:animated customView:customView text:text detailText:detailText];
        [hud hide:animated afterDelay:duration];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [self showHUDForView:view mode:mode animated:animated customView:customView text:text detailText:detailText];
            [hud hide:animated afterDelay:duration];
        });
    }
}

+ (void)showHUDForView:(UIView *)view
                  text:(NSString *)text
            detailText:(NSString *)detailText
              duration:(CGFloat)duration {
    return [self showHUDForView:view mode:MBProgressHUDModeIndeterminate animated:YES customView:nil text:text detailText:detailText duration:duration];
}

+ (void)showHUDForView:(UIView *)view
                  text:(NSString *)text
              duration:(CGFloat)duration {
    return [self showHUDForView:view text:text detailText:nil duration:duration];
}

+ (void)showHUDForView:(UIView *)view
            customView:(UIView *)customView
              duration:(CGFloat)duration {
    return [self showHUDForView:view mode:MBProgressHUDModeCustomView animated:YES customView:customView text:nil detailText:nil duration:duration];
}

+ (void)hideHUDInMainQueueForView:(UIView *)view {
    if ([NSThread isMainThread]) {
        [self hideHUDForView:view animated:YES];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHUDForView:view animated:YES];
        });
    }
}

- (void)hideInMainQueue:(BOOL)animated afterDalay:(CGFloat)delay {
    if ([NSThread isMainThread]) {
        [self hide:animated afterDelay:delay];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hide:animated afterDelay:delay];
        });
    }
}

- (void)hideInMainQueue {
    [self hideInMainQueue:YES afterDalay:0];
}


+ (void)toastAtBottomForView:(UIView *)view
                        text:(NSString *)text
                  detailText:(NSString *)detailText
                    duration:(CGFloat)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [self showHUDForView:view mode:MBProgressHUDModeText animated:YES customView:nil text:text detailText:detailText];
        hud.yOffset = view.center.y - 40;
        hud.margin = 10.0;
        [hud hideInMainQueue:YES afterDalay:duration];
    });
}

+ (void)toastAtBottomForView:(UIView *)view
                        text:(NSString *)text
                    duration:(CGFloat)duration {
    [self toastAtBottomForView:view text:text detailText:nil duration:duration];
}

+ (void)toastAtCenterForView:(UIView *)view
                        text:(NSString *)text
                  detailText:(NSString *)detailText
                    duration:(CGFloat)duration {
    MBProgressHUD *hud = [self showHUDForView:view mode:MBProgressHUDModeText animated:YES customView:nil text:text detailText:detailText];
    hud.margin = 10.0;
    [hud hideInMainQueue:YES afterDalay:duration];
}

+ (void)toastAtCenterForView:(UIView *)view
                        text:(NSString *)text
                    duration:(CGFloat)duration {
    [self toastAtCenterForView:view text:text detailText:nil duration:duration];
}



@end
