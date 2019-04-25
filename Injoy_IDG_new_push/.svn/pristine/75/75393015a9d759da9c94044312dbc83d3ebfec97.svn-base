//
//  SDLoginViewController.h
//  SDMarketingManagement
//
//  Created by Mac on 15-4-30.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
#import "SDSubLoginView.h"

@interface SDLoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *userName;
@property(weak, nonatomic) IBOutlet UITextField *pwd;
@property(weak, nonatomic) IBOutlet UISwitch *rememberPwd;
@property(weak, nonatomic) IBOutlet UITextField *companyAccount;
@property(weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic, assign) BOOL isRemember;
@property(nonatomic, strong) SDSubLoginView *subLoginView;
@property(nonatomic, strong) UIButton *forgetPassWord;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, strong) UIButton *experissBtn;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, weak) UIView *sepLabel;
@property(nonatomic, weak) UIView *sepLabel1;
@property(nonatomic, assign) BOOL registerForgetButtonHidden;

- (IBAction)login:(id)sender;
- (IBAction)registerUser:(id)sender;
@end
