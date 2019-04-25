//
//  SDIMChangePasswordViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/9.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMChangePasswordViewController.h"
#import "UIView+Category.h"
#import "AppDelegate.h"
#import "HttpTool.h"

#define kBackViewY 30
#define kLeftSpaceMargin 20.f //控件距离两边的距离
#define SDIMLabelFont 40
//键盘出现时向上移动的距离
#define kMoveHeight 30

@interface SDIMChangePasswordViewController()<UITextFieldDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (nonatomic, strong) UITextField * oldPasswordTextField;
@property (nonatomic, strong) UITextField * firstNewPasswordTextField;
@property (nonatomic, strong) UITextField * secondNewPasswordTextField;
//把子控件都加在backView上，如果弹出键盘挡住了输入框，则上移backView，否则要移动太多东西
@property (nonatomic, strong) UIView * backView;
//键盘高度
@property (nonatomic) CGFloat kbHeight;

@end

@implementation SDIMChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 监听键盘的即将显示事件. UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 监听键盘即将消失的事件. UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setUpView];
}

- (void)setUpView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"修改密码")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    if(VAL_IS_Update_Pwd){
        [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    }
    
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, navHigh + kBackViewY, Screen_Width, Screen_Height - navHigh - kBackViewY);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    UILabel * firstNewPasswordLabel = [[UILabel alloc] init];
    firstNewPasswordLabel.font = [UIFont systemFontOfSize:16.f];
    firstNewPasswordLabel.textColor = [UIColor blackColor];
    firstNewPasswordLabel.textAlignment = NSTextAlignmentLeft;
    firstNewPasswordLabel.text = @"新  密  码：";
    [firstNewPasswordLabel sizeToFit];
    firstNewPasswordLabel.frame = CGRectMake(kLeftSpaceMargin, 0, firstNewPasswordLabel.size.width, SDIMLabelFont);
    firstNewPasswordLabel.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:firstNewPasswordLabel];
    
    self.firstNewPasswordTextField = [[UITextField alloc] init];
    self.firstNewPasswordTextField.frame = CGRectMake(CGRectGetMaxX(firstNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing, CGRectGetMinY(firstNewPasswordLabel.frame), Screen_Width - (CGRectGetMaxX(firstNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing) - kLeftSpaceMargin, SDIMLabelFont);
    self.firstNewPasswordTextField.backgroundColor = [UIColor clearColor];
    self.firstNewPasswordTextField.font = [UIFont systemFontOfSize:16.f];
    self.firstNewPasswordTextField.secureTextEntry = YES;
    self.firstNewPasswordTextField.textColor = [UIColor blackColor];
    self.firstNewPasswordTextField.textAlignment = NSTextAlignmentLeft;
    self.firstNewPasswordTextField.delegate = self;
    [self.backView addSubview:self.firstNewPasswordTextField];
    
    UIView * firstNewPasswordBottomLineView = [[UIView alloc] init];
    firstNewPasswordBottomLineView.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing, Screen_Width - 2*kLeftSpaceMargin, 1);
    firstNewPasswordBottomLineView.backgroundColor = [UIColor grayColor];
    firstNewPasswordBottomLineView.alpha = 0.6;
    [self.backView addSubview:firstNewPasswordBottomLineView];
    
    UILabel * secondNewPasswordLabel = [[UILabel alloc] init];
    secondNewPasswordLabel.font = [UIFont systemFontOfSize:16.f];
    secondNewPasswordLabel.textColor = [UIColor blackColor];
    secondNewPasswordLabel.textAlignment = NSTextAlignmentLeft;
    secondNewPasswordLabel.text = @"确认密码：";
    [secondNewPasswordLabel sizeToFit];
    secondNewPasswordLabel.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstNewPasswordBottomLineView.frame) + SDHeadImageViewLeftSpacing, secondNewPasswordLabel.size.width, SDIMLabelFont);
    secondNewPasswordLabel.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:secondNewPasswordLabel];
    
    self.secondNewPasswordTextField = [[UITextField alloc] init];
    self.secondNewPasswordTextField.frame = CGRectMake(CGRectGetMaxX(secondNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing, CGRectGetMinY(secondNewPasswordLabel.frame), Screen_Width - (CGRectGetMaxX(secondNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing) - kLeftSpaceMargin, SDIMLabelFont);
    self.secondNewPasswordTextField.secureTextEntry = YES;
    self.secondNewPasswordTextField.backgroundColor = [UIColor clearColor];
    self.secondNewPasswordTextField.font = [UIFont systemFontOfSize:16.f];
    self.secondNewPasswordTextField.textColor = [UIColor blackColor];
    self.secondNewPasswordTextField.textAlignment = NSTextAlignmentLeft;
    self.secondNewPasswordTextField.delegate = self;
    [self.backView addSubview:self.secondNewPasswordTextField];
    
    UIView * secondNewPasswordBottomLineView = [[UIView alloc] init];
    secondNewPasswordBottomLineView.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(secondNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing, Screen_Width - 2*kLeftSpaceMargin, 1);
    secondNewPasswordBottomLineView.backgroundColor = [UIColor grayColor];
    secondNewPasswordBottomLineView.alpha = 0.6;
    [self.backView addSubview:secondNewPasswordBottomLineView];
    
    // 解散群组
    UIButton * changePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePasswordBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [changePasswordBtn setTitle:@"确   定" forState:UIControlStateHighlighted];
    [changePasswordBtn setBackgroundColor:RGBACOLOR(43.0, 43.0, 46.0, 1.0)];
    changePasswordBtn.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(secondNewPasswordLabel.frame) + kBackViewY, Screen_Width - 2*kLeftSpaceMargin, SDMeCellHeight);
    changePasswordBtn.layer.cornerRadius = 5;
    changePasswordBtn.layer.masksToBounds = YES;
    [changePasswordBtn addTarget:self action:@selector(changePasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:changePasswordBtn];
}

- (void)changePasswordBtnClick
{
    [_firstNewPasswordTextField resignFirstResponder];
    [_secondNewPasswordTextField resignFirstResponder];
    if(_firstNewPasswordTextField.text.length == 0)
    {
        [self.view makeToast:@"新密码不能为空" duration:2 position:@"center"];
    }else if(_secondNewPasswordTextField.text.length == 0){
        
        [self.view makeToast:@"确认密码不能为空" duration:2 position:@"center"];
    }
    else if (![_secondNewPasswordTextField.text isEqualToString:_firstNewPasswordTextField.text]) {
        
        [self.view makeToast:@"两次输入的密码不一致" duration:2 position:@"center"];
    }
    else if (![_secondNewPasswordTextField.text checkPwd:_secondNewPasswordTextField.text]) {
        [self.view makeToast:@"密码为6到19位字符" duration:2 position:@"center"];
    }
    else {
        [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@sysuser/password", urlPrefix]];
    }
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification*)notify
{
    //获取键盘高度
    CGFloat kbHeight = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.kbHeight = kbHeight;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.backView.frame = CGRectMake(0, navHigh + kBackViewY - kMoveHeight, Screen_Width, Screen_Height - (navHigh + kBackViewY + kMoveHeight));
                     }];
}

- (void)keyboardWillHidden:(NSNotification*)notify
{
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.backView.frame = CGRectMake(0, navHigh + kBackViewY, Screen_Width, Screen_Height - navHigh - kBackViewY);
                     }];
}

/// 当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark--网络请求
- (void)requestDataFromNetWorkWithUrlString:(NSString*)urlString
{
    
    [self showHudInView:self.view hint:@"更改中..."];
    
    NSMutableDictionary *requstDict = [NSMutableDictionary dictionary];
    
    [requstDict setObject:VAL_Account forKey:@"account"];
    NSString *newPassWordString = [NSString md5:[NSString md5:_firstNewPasswordTextField.text]];
    [requstDict setObject:newPassWordString forKey:@"password"];
    [requstDict setObject:@"1" forKey:@"version"];
    [HttpTool postWithPath:urlString params:requstDict success:^(id JSON){
        [self hideHud];
        if ([JSON[@"status"] intValue] == 200)
        {
            __weak typeof(self) weakSelf = self;
            [weakSelf.view makeToast:@"密码修改成功，稍后请重新登录" duration:2 position:@"center"];
            NSUserDefaults *standardUserDefaults =[NSUserDefaults standardUserDefaults];
            [standardUserDefaults removeObjectForKey:@"pwd"];
            [standardUserDefaults synchronize];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                [[CXIMService sharedInstance] logout];
            });
        }
        else {
            
            [self.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self.view makeToast:[error description] duration:2 position:@"center"];
    }];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
