//
//  CXResetPasswordController.m
//  SDMarketingManagement
//
//  Created by huashao on 16/6/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//  ［忘记密码控制器］

#import "CXResetPasswordController.h"
#import "NSString+TextHelper.h"
#import "HttpTool.h"

#define kLeftSpaceMargin 35.f //控件距离两边的距离
#define kTextHeight 40.f      //控件的高度
#define kTextLineHeight 1.f       //线的高度
#define kTextViewMargin 10.f     //控件之间的间距
#define kTextDistanceLabel 2.5   //label距离输入框的距离

@interface CXResetPasswordController()<UITextFieldDelegate>

@property (strong, nonatomic) SDRootTopView* topView;

//输入新的密码文本框
@property (weak, nonatomic) UITextField *passwordText;
//再次输入密码
@property (weak, nonatomic) UITextField *checkPasswordText;
//完成
@property (weak, nonatomic) UILabel *finishLabel;

@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation CXResetPasswordController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //头部导航栏
    [self setupNavigationBar];
    
    //创建视图
    [self creatUI];
}

#pragma mark - navigationbar
- (void)setupNavigationBar
{
    self.topView = [self getRootTopView];
    [self.topView setNavTitle:@"忘记密码"];
    [self.topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(leftBtnClick)];
    
    //self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = kColorWithRGB(248, 250, 255);
}

- (void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}

#pragma mark -- 创建UI界面
-(void)creatUI
{
    //输入手机号码
    UITextField *passwordText = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, 86.f, Screen_Width - 2*kLeftSpaceMargin, kTextHeight)];
    passwordText.placeholder = @"请输入新的密码";
    passwordText.borderStyle = UITextBorderStyleNone;
    passwordText.secureTextEntry = YES;
    passwordText.keyboardType = UIKeyboardTypeDefault;
    passwordText.delegate = self;
    [self.view addSubview:passwordText];
    self.passwordText = passwordText;
    
    //第一条线
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(passwordText.frame), passwordText.frame.size.width, kTextLineHeight)];
    firstLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:firstLineView];
    
    //输入右侧图形验证码
    UITextField *checkPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstLineView.frame)+kTextViewMargin, passwordText.frame.size.width, kTextHeight)];
    checkPasswordText.placeholder = @"再次输入密码";
    checkPasswordText.borderStyle = UITextBorderStyleNone;
    checkPasswordText.secureTextEntry = YES;
    checkPasswordText.delegate = self;
    checkPasswordText.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:checkPasswordText];
    self.checkPasswordText = checkPasswordText;
    
    //第二条线
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(checkPasswordText.frame), checkPasswordText.frame.size.width, kTextLineHeight)];
    secondLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:secondLineView];
    
    //发送
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(secondLineView.frame)+30.f, Screen_Width - 2*kLeftSpaceMargin, 44.f)];
    sendLabel.backgroundColor =  kIconBlueColor;//kMainGreenColor; //kColorWithRGB(43, 171,109);
    sendLabel.userInteractionEnabled = YES;
    sendLabel.text = @"完\t 成";
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sendLabel];
    self.finishLabel = sendLabel;
    
    //点击下一步发送按钮
    UITapGestureRecognizer *finishTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishTap:)];
    [self.finishLabel addGestureRecognizer:finishTap];
    
    //添加键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEnditAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark -- 结束编辑点击
-(void)endEnditAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark -- 网络请求提示
-(UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    
    return _alertView;
}

#pragma mark -- 点击完成的事件
-(void)finishTap:(UITapGestureRecognizer *)tapGesture
{
    __weak typeof(self)  weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@sysuser/forgetPass",urlPrefix];
    NSMutableDictionary *requstDict = [NSMutableDictionary dictionary];
    
    //手机号码
    if (self.userPhoneNumber.length) {
        [requstDict setObject:self.userPhoneNumber forKey:@"account"];
    }else{
        self.alertView.message = @"手机号码不存在";
        [self.alertView show];
        return;
    }
    
    //判断两次的密码是否一致
    if (!self.passwordText.text.length && !self.checkPasswordText.text.length) {
        self.alertView.message = @"密码不能为空";
        [self.alertView show];
        return;
    }
    
    if (![self.passwordText.text isEqualToString:self.checkPasswordText.text]) {
        self.alertView.message = @"两次输入密码不一致";
        [self.alertView show];
        return;
    }
    
    //密码长度为6-16位
    if (self.passwordText.text.length < 6 || self.passwordText.text.length > 16) {
        self.alertView.message = @"密码长度为6-16位，请重新设置";
        [self.alertView show];
        return;
    }
    
    //密码
    NSString *passWord = [NSString md5:[NSString md5:self.passwordText.text]];
    [requstDict setObject:passWord forKey:@"password"];
    //[requstDict setObject:@"2" forKey:@"versionCode"];
    
    [requstDict setObject:@"1" forKey:@"version"];
    [self showHudInView:self.view hint:nil];
    self.finishLabel.userInteractionEnabled = NO;
    
    [HttpTool postWithPath:url params:requstDict success:^(id JSON) {
        [weakSelf hideHud];
        weakSelf.finishLabel.userInteractionEnabled = YES;
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            weakSelf.alertView.message = @"密码重置成功";
            [weakSelf.alertView show];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"successEnterIntoLoginView" object:nil];
        }else{
            weakSelf.alertView.message = @"服务器错误";
            [weakSelf.alertView show];
        }
    } failure:^(NSError *error) {
        
        [weakSelf hideHud];
        weakSelf.finishLabel.userInteractionEnabled = YES;
        weakSelf.alertView.message = @"连接服务器失败";
        [weakSelf.alertView show];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
