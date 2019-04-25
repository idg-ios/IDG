//
//  SDSubLoginView.h
//  SDMarketingManagement
//
//  Created by 郭航 on 15/6/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^switchStateChange)(id sender);
@interface SDSubLoginView : UIView
@property (weak, nonatomic) IBOutlet UITextField *myAccount;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic,copy) switchStateChange switchCallBack;
@end
