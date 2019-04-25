//
//  SDSubLoginView.m
//  SDMarketingManagement
//
//  Created by 郭航 on 15/6/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDSubLoginView.h"

#define MainGreenColor kColorWithRGB(0, 140, 93)

@interface SDSubLoginView()<UITextFieldDelegate>

@end

@implementation SDSubLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];

    // 记住密码
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"remember"];
    
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myAccount.leftViewMode = UITextFieldViewModeAlways;
    self.myAccount.keyboardType = UIKeyboardTypeDefault;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17]; // 设置font
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor]; // 设置颜色
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:@"请输入账号" attributes:attrs]; // 初始化富文本占位字符串
    self.myAccount.attributedPlaceholder = attStr1;
    self.myAccount.clearsOnBeginEditing = NO;
    self.myAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.myAccount.delegate = self;

    self.password.leftViewMode = UITextFieldViewModeAlways;
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attrs]; // 初始化富文本占位字符串
    self.password.attributedPlaceholder = attStr2;
    self.password.clearsOnBeginEditing = NO;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.password setSecureTextEntry:YES];
}

#pragma mark -- 文本输入框的代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.myAccount) {
        self.password.text = nil;
        if (textField.text.length >= 50&&string.length)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 登录界面文本输入框空开一个字的宽
- (UIView*)spaceInputTextByTextField:(UITextField*)textField imageName:(NSString*)imageName
{
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, textField.frame.size.height)];
    UIImage* image = [UIImage imageNamed:imageName];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (textField.frame.size.height - image.size.height) / 2.0, image.size.width, image.size.height)];
    imageView.image = image;
    [leftView addSubview:imageView];

    return leftView;
}

- (IBAction)switchAction:(id)sender
{
//    if (_switchCallBack) {
//        UISwitch* switchBtn = sender;
//        if (switchBtn.on) {
//            [_switchButton setThumbTintColor:kColorWithRGB(99, 99, 99)];
//        }
//        else
//        {
//            [_switchButton setThumbTintColor:kColorWithRGB(99, 99, 99)];
//        }
//        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setBool:switchBtn.on forKey:@"remember"];
//        _switchCallBack(sender);
//    }
}

@end
