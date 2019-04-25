//
//  CXRegisterCompanyController.m
//  SDMarketingManagement
//
//  Created by huashao on 16/6/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//  [提交注册控制器]

#import "CXRegisterCompanyController.h"
#import "HttpTool.h"
#import "NSString+TextHelper.h"
#import "CXSelectIndustryView.h"

#define kLeftSpaceMargin 32.f //控件距离两边的距离
#define kTextHeight 40.f      //控件的高度
#define kTextLineHeight 1.f       //线的高度
#define kTextViewMargin 10.f     //控件之间的间距
#define kTextDistanceLabel 2.5   //label距离输入框的距离
#define kRegisterLabelWidth 95.f //注册label的宽度
//按钮颜色
#define kRegister_Button_Color kColorWithRGB(33, 172, 107)

@interface CXRegisterCompanyController()<UITextFieldDelegate,CXSelectIndustryViewDelegate>
@property (strong, nonatomic) SDRootTopView* topView;

//手机号码输入
@property (weak, nonatomic) UITextField *companyNameText;

//输入右侧图形码文本框
@property (weak, nonatomic) UITextField *registerNameText;

//密码
@property (weak, nonatomic) UITextField *passwordText;

//确认密码
@property (weak, nonatomic) UITextField *checkPasswordText;

@property (weak, nonatomic) UILabel *sendLabel;

//注册的label
@property (weak, nonatomic) UILabel *registerLabel;

//网络请求提示
@property (strong,nonatomic) UIAlertView *alertView;

@property (nonatomic, assign) NSInteger versionNum;

@property (nonatomic, weak) CXSelectIndustryView *industryView;

@end

@implementation CXRegisterCompanyController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self creatUI];
    
    //添加键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEnditAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark -- 结束编辑点击
-(void)endEnditAction:(UITapGestureRecognizer *)tap
{
    [self.industryView removeFromSuperview];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - navigationbar
- (void)setupNavigationBar
{
    self.topView = [self getRootTopView];
    [self.topView setNavTitle:@"请设置您的信息"];
    
    [self.topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(leftBtnClick)];
    
    //self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = kColorWithRGB(248, 250, 255);
}

- (void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 创建UI界面
-(void)creatUI
{
    //公司名
    UILabel *companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, navHigh +20, kRegisterLabelWidth, kTextHeight)];
    companyNameLabel.text = @"公司名称：";
    companyNameLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:companyNameLabel];
    
    CGFloat textFieldWidth = Screen_Width - 2*kLeftSpaceMargin - kRegisterLabelWidth;
    CGFloat textFieldX = kLeftSpaceMargin+kRegisterLabelWidth -10.f;
    UITextField *companyNameText = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, navHigh +20 +2, textFieldWidth, kTextHeight)];
    companyNameText.placeholder = @"请填写公司名称";
    [self changeTextFieldPlaceholderShow:companyNameText];
    companyNameText.borderStyle = UITextBorderStyleNone;
    companyNameText.keyboardType = UIKeyboardTypeDefault;
    companyNameText.delegate = self;
    [self.view addSubview:companyNameText];
    self.companyNameText = companyNameText;
    
    //第一条线
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin/2, CGRectGetMaxY(companyNameText.frame), Screen_Width - kLeftSpaceMargin, kTextLineHeight)];
    firstLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:firstLineView];
    
    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpaceMargin/2, navHigh*2, Screen_Width - kLeftSpaceMargin, 30)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:21.0];
    titleLabel.text = @"请设置登录密码";
    //[self.view addSubview:titleLabel];
    
    //姓名
    UILabel *registerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstLineView.frame)+kTextViewMargin, kRegisterLabelWidth, kTextHeight)];
    registerNameLabel.text = @"姓       名：";
    registerNameLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:registerNameLabel];
    
    UITextField *registerNameText = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, CGRectGetMaxY(firstLineView.frame)+kTextViewMargin+2, textFieldWidth, kTextHeight)];
    registerNameText.placeholder = @"请输入姓名";
    [self changeTextFieldPlaceholderShow:registerNameText];
    registerNameText.borderStyle = UITextBorderStyleNone;
    registerNameText.keyboardType = UIKeyboardTypeDefault;
    registerNameText.delegate = self;
    [self.view addSubview:registerNameText];
    self.registerNameText = registerNameText;
    
    //第二条线
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin/2, CGRectGetMaxY(registerNameText.frame), Screen_Width - kLeftSpaceMargin, kTextLineHeight)];
    secondLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:secondLineView];
    
    //密码
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(secondLineView.frame)+kTextViewMargin, kRegisterLabelWidth, kTextHeight)];
    passwordLabel.text = @"登录密码：";
    passwordLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:passwordLabel];
    
    UITextField *passwordText = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, CGRectGetMaxY(secondLineView.frame)+kTextViewMargin+2, textFieldWidth, kTextHeight)];
    passwordText.placeholder = @"请设置登录密码(6~16位)";
    [self changeTextFieldPlaceholderShow:passwordText];
    passwordText.secureTextEntry = YES;
    passwordText.borderStyle = UITextBorderStyleNone;
    passwordText.keyboardType = UIKeyboardTypeDefault;
    passwordText.delegate = self;
    [self.view addSubview:passwordText];
    self.passwordText = passwordText;
    
    //第三条线
    UIView *thirdLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin/2, CGRectGetMaxY(passwordText.frame), Screen_Width - kLeftSpaceMargin, kTextLineHeight)];
    thirdLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];

    [self.view addSubview:thirdLineView];
    
    //确认密码
    UILabel *checkPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(thirdLineView.frame)+kTextViewMargin, kRegisterLabelWidth, kTextHeight)];
    checkPasswordLabel.text = @"确认密码：";
    checkPasswordLabel.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:checkPasswordLabel];
    
    UITextField *checkPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, CGRectGetMaxY(thirdLineView.frame)+kTextViewMargin+2, textFieldWidth, kTextHeight)];
    checkPasswordText.placeholder = @"请再次填入";
    [self changeTextFieldPlaceholderShow:checkPasswordText];
    checkPasswordText.secureTextEntry = YES;
    checkPasswordText.borderStyle = UITextBorderStyleNone;
    checkPasswordText.keyboardType = UIKeyboardTypeDefault;
    checkPasswordText.delegate = self;
    [self.view addSubview:checkPasswordText];
    self.checkPasswordText = checkPasswordText;
    
    //第四条线
    UIView *fourLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin/2, CGRectGetMaxY(checkPasswordText.frame), Screen_Width - kLeftSpaceMargin, kTextLineHeight)];
    fourLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:fourLineView];
    
    //注册
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(fourLineView.frame)+30.f, Screen_Width - 2*kLeftSpaceMargin, 44.f)];
    registerLabel.backgroundColor =  kIconBlueColor;//kMainGreenColor;//kColorWithRGB(43, 171,109);
    registerLabel.layer.masksToBounds = YES;
    registerLabel.userInteractionEnabled = YES;
    registerLabel.text = @"完\t成";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerLabel];
    self.registerLabel = registerLabel;
    
    //注册添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerUser:)];
    [registerLabel addGestureRecognizer:tapGesture];
    
}

#pragma mark -- 改变隐藏视图的颜色和字体
-(void)changeTextFieldPlaceholderShow:(UITextField *)textField
{
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.f green:153/255.f  blue:153/255.f  alpha:1]}];
}


#pragma mark -- 注册用户事件
-(void)registerUser:(UITapGestureRecognizer *)tapGesture
{
    //弹出选择行业视图
    [self.view endEditing:YES];
    
    if (!self.passwordText.text.length) {
        TTAlert(@"密码不能为空");
        return;
    }
    
    if (![self.passwordText.text isEqualToString:self.checkPasswordText.text])
    {
        TTAlert(@"两次密码输入不一致");
        return;
    }
    [self registerCompany];
    
    //CXSelectIndustryView *industryView = [[CXSelectIndustryView alloc] init];
    //industryView.delegate = self;
    //[industryView showInView:self.view];
    //self.industryView = industryView;
}

-(void)industryView:(CXSelectIndustryView *)industryView clickItem:(NSInteger)clickItem
{
    self.versionNum = clickItem;
    [self registerCompany];
}

#pragma mark -- 网络请求提示
-(UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    
    return _alertView;
}


#pragma mark -- 注册公司
-(void)registerCompany
{
    __weak typeof(self)  weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/register",urlPrefix];
    NSMutableDictionary *requstDict = [NSMutableDictionary dictionary];
    
    if (!self.passwordText.text.length) {
        TTAlert(@"密码不能为空");
        return;
    }
    
    if (![self.passwordText.text isEqualToString:self.checkPasswordText.text])
    {
        TTAlert(@"两次密码输入不一致");
        return;
    }
//    if (![self checkUserInformation]) {
//        return;
//    }
    //公司名
    [requstDict setObject:self.companyNameText.text forKey:@"name"];
    //手机号码
    [requstDict setObject:self.userPhoneNumber forKey:@"telephone"];
    //用户名
    [requstDict setObject:self.registerNameText.text forKey:@"userName"];
    //密码
    NSString *passWord = [NSString md5:[NSString md5:self.passwordText.text]];
    [requstDict setObject:passWord forKey:@"password"];
    [requstDict setObject:@(3) forKey:@"level"];
    //明文密码
//    [requstDict setObject:self.passwordText.text forKey:@"mingWenPass"];
    
    //if (self.versionNum) {
    //    [requstDict setObject:[NSString stringWithFormat:@"%ld",self.versionNum] forKey:@"versionNum"];
    //}
    [requstDict setObject:@"1" forKey:@"versionNum"];
    
    [self showHudInView:self.view hint:nil];
    
    [HttpTool multipartPostFileDataWithPath:url params:requstDict dataAry:nil success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            weakSelf.alertView.message = @"注册成功";
            //[weakSelf.alertView show];
            //注册成功跳到登陆界面
            
            //保存行业
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"1" forKey:@"versionNum"];
            [ud synchronize];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"successEnterIntoLoginView" object:nil];
            
            //账号密码保存到数据字典
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:weakSelf.passwordText.text forKey:@"pwd"];
            [userDefaults setObject:weakSelf.userPhoneNumber forKey:@"account"];
            [userDefaults synchronize];
            //发送消息  自动登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerFinishLogin" object:nil];
            
        }else{
            weakSelf.alertView.message = JSON[@"msg"];
            [weakSelf.alertView show];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        weakSelf.alertView.message = @"连接服务器失败";
        [weakSelf.alertView show];
    }];
//    [HttpTool postWithPath:url params:requstDict success:^(id JSON) {
//        
//        [weakSelf hideHud];
//        NSDictionary *jsonDict = JSON;
//        if ([jsonDict[@"status"] integerValue] == 200) {
//            weakSelf.alertView.message = @"注册成功";
//            [weakSelf.alertView show];
//            //注册成功跳到登陆界面
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"successEnterIntoLoginView" object:nil];
//            
//        }else{
//            weakSelf.alertView.message = JSON[@"msg"];
//            [weakSelf.alertView show];
//        }
//    } failure:^(NSError *error) {
//        
//        [weakSelf hideHud];
//        weakSelf.alertView.message = @"连接服务器失败";
//        [weakSelf.alertView show];
//    }];
}

#pragma mark -- 确认用户用户是否填写完整
-(BOOL)checkUserInformation
{
    //密码长度为6-16位
    NSInteger passWordLength = self.checkPasswordText.text.length;
    if (passWordLength < 6 || passWordLength > 16) {
        self.alertView.message = @"密码长度为6-16位，请重新设置";
        [self.alertView show];
        return NO;
    }
    
    if ([self.checkPasswordText.text isEqualToString:self.passwordText.text]) {
        if (self.companyNameText.text.length && self.registerNameText.text.length)
        {
            return YES;
        }else{
            self.alertView.message = @"信息填写不完整";
            [self.alertView show];
        }
    }else{
        self.alertView.message = @"两次密码输入不一致，请重新输入";
        [self.alertView show];
    }
    
    return NO;
}

#pragma mark -- 键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
