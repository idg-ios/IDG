//
//  CXSendMsgAndTelView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2018/6/4.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDCompanyUserModel;

typedef NS_OPTIONS(NSUInteger,  ShowAnimationOptions) {
    ShowAnimationOptionNome                 = 0,
    ShowAnimationOptionTop                  = 1 << 0,
    ShowAnimationOptionBottom               = 1 << 1,
    ShowAnimationOptionGradient      = 1 << 2,
    
};

typedef NS_OPTIONS(NSUInteger,  DisMissAnimationOptions) {
    DisMissAnimationOptionNome              = 0,
    DisMissAnimationOptionTop               = 1 << 0,
    DisMissAnimationOptionBottom            = 1 << 1,
    DisMissAnimationOptionGradient          = 1 << 2,
    
};


@interface CXSendMsgAndTelView : UIView

/*实例
CXSendMsgAndTelView *send = [[CXSendMsgAndTelView alloc]initWithFrame:(CGRectMake(0, 0, Screen_Width, Screen_Height))andTelPhone:self.userModel.telephone showAnimationOption:(ShowAnimationOptionBottom) disMissAnimationOption:(DisMissAnimationOptionGradient)];
[[UIApplication sharedApplication].keyWindow addSubview:send];
*/

/**
 拨打电话和短信 (建议添加于window上)
 @param frame 当前设备尺寸
 @param phone 电话号码
 @param showOption 界面显示动画
 @param disMissOption 界面消失动画
 @return CXSendMsgAndTelView
 */
-(instancetype)initWithFrame:(CGRect)frame andTelPhone:(NSString *)phone showAnimationOption:(ShowAnimationOptions)showOption disMissAnimationOption:(DisMissAnimationOptions)disMissOption;

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) SDCompanyUserModel *companyUser;

@end
