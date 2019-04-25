//
//  SDRegisterPhoneController.m
//  SDMarketingManagement
//
//  Created by admin on 15/10/12.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  ［忘记密码｜注册账号 的图形验证码和短信验证码控制器］
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>yaogai buyongai 体验账号已经干掉了

#import "SDRegisterPhoneController.h"
#import "NSString+TextHelper.h"
#import "HttpTool.h"
#import "SDLoginViewController.h"
#import "CXRegisterCompanyController.h"
#import "CXResetPasswordController.h"
#import "UIView+YYAdd.h"
#import "SDDataBaseHelper.h"
#import "CXStaticDataHelper.h"
#import "SDWebSocketManager.h"
#import "CXSelectIndustryView.h"
#import "CXLoaclDataManager.h"

#define kLeftSpaceMargin 35.f //控件距离两边的距离
#define kTextHeight 40.f      //控件的高度
#define kTextLineHeight 1.f       //线的高度
#define kTextViewMargin 10.f     //控件之间的间距
#define kTextDistanceLabel 2.5   //label距离输入框的距离
//按钮颜色
#define kRegister_Button_Color kColorWithRGB(33, 172, 107)


@interface SDRegisterPhoneController ()<UITextFieldDelegate,CXSelectIndustryViewDelegate>

@property (strong, nonatomic) SDRootTopView* topView;

//手机号码输入
@property (weak, nonatomic) UITextField *phoneNumberText;

//输入右侧图形码文本框
@property (weak, nonatomic) UITextField *graphicCodeText;

//显示图形验证码
@property (weak, nonatomic) UILabel *graphicLabel;

//输入手机验证码
@property (weak, nonatomic) UITextField *inputPhoneCode;

//获取验证吗
@property (weak, nonatomic) UILabel *getCodeLabel;

@property (weak, nonatomic) UILabel *sendLabel;

//网络请求提示
//@property (strong,nonatomic) UIAlertView *alertView;

//获取图形验证码的唯一标识
@property (strong,nonatomic) NSString *onlyNum;

@property (strong,nonatomic) NSString *userPhoneNumber;

//允许下一步点击
@property (assign,nonatomic) BOOL allowNextTap;

//定时器记录验证码时效
@property (nonatomic, strong) NSTimer *myTimer;

//验证码时效
@property (nonatomic, assign) NSInteger totalTime;

//验证码
@property (nonatomic, weak) UITextField *grapicPhoneCode;

//显示图形验证码
@property (nonatomic, weak) UILabel *grapicCodeLabel;
/** 已有账号 */
@property(nonatomic, strong) UIButton *loginBtn;
/** 进入体验 */
@property(nonatomic, strong) UIButton *experissBtn;
/** 间隔线 */
@property(nonatomic, weak) UIView *sepLabel;

@property(nonatomic, weak) SDRegisterPhoneController *registVC;

@property (nonatomic, weak) CXSelectIndustryView *industryView;

@property (nonatomic, assign) NSInteger versionNum;

@end

@implementation SDRegisterPhoneController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //不允许点击下一步
    self.allowNextTap = NO;
    self.totalTime = 60;
    
    //接收注册成功跳回登陆界面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterIntoLoginView) name:@"successEnterIntoLoginView" object:nil];
    /** 退出按钮点击 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterIntoLoginView)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [self setupNavigationBar];
    
//    if (_isForgetPassword) {
        [self creatForgetPWDUI];
//    } else {
//        [self creatUI];
//    }
    
    //添加键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEnditAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.view.backgroundColor = kColorWithRGB(248, 250, 255);
}

#pragma mark -- 结束编辑点击
-(void)endEnditAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark -- 销毁通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 注册成功，或者重置密码跳回登陆界面
-(void)enterIntoLoginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    self.totalTime = 60;
    self.getCodeLabel.text = @"获取验证码";
}

#pragma mark - navigationbar
- (void)setupNavigationBar
{
    self.topView = [self getRootTopView];
    if (self.type == forgetPassWordType) {
       [self.topView setNavTitle:@"忘记密码"];
       [[SDCommonDefine sharedInstance] systemUse];
    }else if (self.type == registerType){
       [self.topView setNavTitle:@"注   册"];
       [[SDCommonDefine sharedInstance] systemUse];
    }else if (self.type == expressType){
        [self.topView setNavTitle:@"手机体验"];
        [[SDCommonDefine sharedInstance] experienceAccount];
    }

    [self.topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(leftBtnClick)];

    self.view.backgroundColor = kColorWithRGB(241, 255, 250);
}

- (void)leftBtnClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.registVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 创建UI界面
-(void)creatForgetPWDUI
{
    //输入手机号码
    UITextField *phoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, 100.f, Screen_Width - 2*kLeftSpaceMargin, kTextHeight)];
    phoneNumberText.placeholder = @"请输入手机号码";
    phoneNumberText.borderStyle = UITextBorderStyleNone;
    phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberText.delegate = self;
    [self.view addSubview:phoneNumberText];
    self.phoneNumberText = phoneNumberText;
    
    //添加事件
    [self.phoneNumberText addTarget:self action:@selector(checkPhoneNumberSuccess:) forControlEvents:UIControlEventEditingChanged];
    
    //第一条线
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(phoneNumberText.frame), phoneNumberText.frame.size.width, kTextLineHeight)];
    firstLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:firstLineView];
    
    //输入右侧图形验证码
    UITextField *graphicCodeText = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstLineView.frame)+kTextViewMargin, 150.f, kTextHeight)];
    graphicCodeText.placeholder = @"请输入右侧图形码";
    graphicCodeText.borderStyle = UITextBorderStyleNone;
    graphicCodeText.keyboardType = UIKeyboardTypeDefault;
    graphicCodeText.delegate = self;
    [self.view addSubview:graphicCodeText];
    self.graphicCodeText = graphicCodeText;
    
    //显示后台返回的图形验证码
    UILabel *graphicLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 100.f - kLeftSpaceMargin, graphicCodeText.frame.origin.y+kTextDistanceLabel - kTextViewMargin/2, 100.f, kTextHeight - 2*kTextDistanceLabel)];
    graphicLabel.backgroundColor = [UIColor clearColor];
    graphicLabel.textColor = kColorWithRGB(162, 67, 28);
    graphicLabel.textAlignment = NSTextAlignmentCenter;
    graphicLabel.font = [UIFont systemFontOfSize:15.f];
    graphicLabel.hidden = YES;
    graphicLabel.userInteractionEnabled = YES;
    [self.view addSubview:graphicLabel];
    self.graphicLabel = graphicLabel;
    
    //第二条线
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(graphicCodeText.frame), phoneNumberText.frame.size.width, kTextLineHeight)];
    secondLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:secondLineView];
    
    //输入右侧图形验证码
    UITextField *inputPhoneCode = [[UITextField alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(secondLineView.frame)+kTextViewMargin, 150.f, kTextHeight)];
    inputPhoneCode.placeholder = @"请输入验证码";
    inputPhoneCode.keyboardType = UIKeyboardTypeDefault;
    inputPhoneCode.borderStyle = UITextBorderStyleNone;
    inputPhoneCode.delegate = self;
    [self.view addSubview:inputPhoneCode];
    self.inputPhoneCode = inputPhoneCode;
    
    //显示后台返回的图形验证码
    UILabel *getCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 100.f - kLeftSpaceMargin, inputPhoneCode.frame.origin.y + kTextDistanceLabel - kTextViewMargin/2, 100.f, kTextHeight - 2*kTextDistanceLabel)];
    getCodeLabel.backgroundColor =  kIconBlueColor;//kMainGreenColor;//kColorWithRGB(43, 171,109);
    getCodeLabel.textColor = [UIColor whiteColor];
    getCodeLabel.userInteractionEnabled = YES;
    getCodeLabel.font = [UIFont systemFontOfSize:15.f];
    getCodeLabel.textAlignment = NSTextAlignmentCenter;
    getCodeLabel.text = @"获取验证码";
    [self.view addSubview:getCodeLabel];
    self.getCodeLabel = getCodeLabel;
    
    //第三条线
    UIView *thirdLineView = [[UIView alloc] initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(inputPhoneCode.frame), phoneNumberText.frame.size.width, kTextLineHeight)];
    thirdLineView.backgroundColor = [UIColor colorWithRed:196/256.f green:196/256.f blue:204/256.f alpha:1];
    [self.view addSubview:thirdLineView];
    
    //发送
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(thirdLineView.frame)+30.f, Screen_Width - 2*kLeftSpaceMargin, 44.f)];
    sendLabel.backgroundColor =  kIconBlueColor;
    sendLabel.userInteractionEnabled = YES;
    if (self.type == forgetPassWordType) {
        sendLabel.text = @"下一步";
    }else if (self.type == registerType){
        sendLabel.text = @"注\t 册";
    }else if (self.type == expressType){
        sendLabel.text = @"体\t 验";
    }
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sendLabel];
    self.sendLabel = sendLabel;
    
//    if (self.type == registerType) {
//        UILabel *sepLabel = [[UILabel alloc] init];
//        sepLabel.textColor = [UIColor darkGrayColor];
//        sepLabel.text = @"|";
//        sepLabel.font = [UIFont systemFontOfSize:14];
//        [sepLabel sizeToFit];
//        sepLabel.centerX = Screen_Width * .5;
//        sepLabel.top = Screen_Height - 35;
//        [self.view addSubview:sepLabel];
//        self.sepLabel = sepLabel;
//        
//        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_loginBtn setTitle:LocalString(@"已有账号") forState:UIControlStateNormal];
//        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_loginBtn setBackgroundColor:[UIColor clearColor]];
//        [_loginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//        [_loginBtn sizeToFit];
//        _loginBtn.left = sepLabel.left - 10 - GET_WIDTH(_loginBtn);
//        _loginBtn.centerY = sepLabel.centerY;
//        [self.view addSubview:_loginBtn];
//        
//        _experissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_experissBtn setTitle:LocalString(@"进入体验") forState:UIControlStateNormal];
//        _experissBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_experissBtn setBackgroundColor:[UIColor clearColor]];
//        [_experissBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [_experissBtn addTarget:self action:@selector(experiessAction) forControlEvents:UIControlEventTouchUpInside];
//        [_experissBtn sizeToFit];
//        _experissBtn.left = sepLabel.right + 10;
//        _experissBtn.centerY = sepLabel.centerY;
//        [self.view addSubview:_experissBtn];
//    }
    
    //获取验证码
    UITapGestureRecognizer *getCodeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCodeTap:)];
    [self.getCodeLabel addGestureRecognizer:getCodeTap];
    
    //点击下一步发送按钮
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTap:)];
    [self.sendLabel addGestureRecognizer:nextTap];
    
    //允许用户重新获取验证码
    UITapGestureRecognizer *getCodeGraphicsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeGraphicsTap:)];
    [self.graphicLabel addGestureRecognizer:getCodeGraphicsTap];
}
#pragma mark - 已有账号按钮点击事件
- (void)loginAction
{
    [self enterIntoLoginView];
}
#pragma mark - 进入体验按钮点击事件
- (void)experiessAction
{
//    [self enterIntoLoginView];
    SDRegisterPhoneController *registerVC = [[SDRegisterPhoneController alloc] init];
    registerVC.registVC = self;
    registerVC.type = expressType;
    [self presentViewController:registerVC animated:YES completion:nil];
}
#pragma mark -- 重新获取图形验证码
-(void)getCodeGraphicsTap:(UITapGestureRecognizer *)tap
{
    //销毁定时器
    [self.myTimer invalidate];
    self.myTimer = nil;
    self.totalTime = 60;
    
    [self requestImageCode];
}


#pragma mark -- 判断是否输入了正确手机号码
-(void)checkPhoneNumberSuccess:(UITextField *)textField
{
    if (textField.text.length >= 12) {
        NSString *text = [textField.text substringWithRange:NSMakeRange(0, 11)];
        textField.text = text;
        return;
    }
    
    if (self.phoneNumberText.text.length == 11) {
        if ([textField.text checkMobilePhone:textField.text]) {
            //如果输入正确的手机号码，就显示验证码图片
            self.userPhoneNumber = [NSString stringWithFormat:@"%@",textField.text];
//            if (self.isForgetPassword) {
//                // 忘记密码
//                [self checkTelephoneNumberRegister];
//                [self judgePhoneNumberRegister];
//            }else{
//                [self judgePhoneNumberRegister];
//            }
            if (self.isForgetPassword) {
                [self checkTelephoneNumberRegister];
            }else{
                [self judgePhoneNumberRegister];
            }
        }else{
//            self.alertView.message = @"输入手机号码有误";
//            [self.alertView show];
            TTAlert(@"输入手机号码有误");
        }
    }else{
        self.graphicLabel.text = nil;
        self.graphicLabel.hidden = YES;
    }
}

#pragma mark -- 文本输入框的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- 获取验证码点击事件
-(void)getCodeTap:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
//    if (self.isForgetPassword) {
//       //检验公司是否有注册，如果有注册，就请求验证码
//    }else{
//        //检验发送的图形验证码
//    }
    
    [self checkImageCode];
}

#pragma mark -- 下一步按钮点击事件
-(void)nextTap:(UITapGestureRecognizer *)tapGesture
{
    if (self.type == expressType) {
        //弹出选择行业视图
        [self.view endEditing:YES];
        CXSelectIndustryView *industryView = [[CXSelectIndustryView alloc] init];
        industryView.delegate = self;
        [industryView showInView:self.view];
        self.industryView = industryView;
    }else{
        [self requestCheckPhoneMessageCode];
    }
}

-(void)industryView:(CXSelectIndustryView *)industryView clickItem:(NSInteger)clickItem
{
    self.versionNum = clickItem;
    [self requestCheckPhoneMessageCode];
}

#pragma mark -- 判断手机号码是否注册
-(void)judgePhoneNumberRegister
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/isHavaPhone",urlPrefix];
    NSDictionary *requestDict = nil;
    if (self.phoneNumberText.text.length) {
        requestDict = @{@"telephone":self.phoneNumberText.text};
    }
    //请求接口
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        NSDictionary *jsonDict = JSON;
        NSInteger status = [jsonDict[@"status"] integerValue];
        if (status == 501) {
            //请求下一接口获取图形码
            [weakSelf requestImageCode];
        }else if(status == 500){
            TTAlert(KNetworkFailRemind);
        }else if (status == 502){
            TTAlert(@"该手机号已经注册");
        }
        else if(status == 502){
            if (weakSelf.isForgetPassword) {
                [weakSelf requestImageCode];
            }else{
                TTAlert(@"该手机号已经注册");
            }
        }
    } failure:^(NSError *error) {
        
        //[weakSelf hideHud];
        //weakSelf.alertView.message = @"连接服务器失败";
        //[weakSelf.alertView show];
        TTAlert(@"连接服务器失败");
    }];
}

#pragma mark -- 获取右边的图形码
-(void)requestImageCode
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/getCode",urlPrefix];
    
    [HttpTool getWithPath:url params:nil success:^(id JSON)
    {
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200)
        {
            if ([jsonDict[@"data"][@"code"] isKindOfClass:[NSNull class]])
            {
                weakSelf.graphicLabel.text = @"重新获取";
                weakSelf.graphicLabel.hidden = NO;
                TTAlert(@"获取验证码失败");
            }else{
                weakSelf.graphicLabel.text = jsonDict[@"data"][@"code"];
                weakSelf.graphicLabel.hidden = NO;
                weakSelf.onlyNum = jsonDict[@"data"][@"codeKey"];
            }
            
        }else if ([jsonDict[@"status"] integerValue] == 500){
            weakSelf.graphicLabel.text = @"重新获取";
            weakSelf.graphicLabel.hidden = NO;
            TTAlert(@"获取验证码失败");
        }else{
            TTAlert(KNetworkFailRemind);
        }
    } failure:^(NSError *error) {
        TTAlert(KNetworkFailRemind);
    }];
}

#pragma mark -- 验证获取的验证码
-(void)checkImageCode
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/checkCode",urlPrefix];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:2];

    
    if (self.onlyNum) {
        [requestDict setObject:self.onlyNum forKey:@"codeKey"];
    }

    
        if (self.graphicCodeText.text.length) {
            [requestDict setObject:self.graphicCodeText.text forKey:@"code"];

        }else{
             [self.view makeToast:@"请输入右侧图形码" duration:1.f position:@"center"];
            return;
        }

    [self showHudInView:self.view hint:@""];
    
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        NSString *message = jsonDict[@"msg"];
        NSInteger status = [jsonDict[@"status"]integerValue];
        if (status == 200) {
            //请求发送4位纯数字短信验证码
            [weakSelf requestSendPhoneMessageCode];
        }else if (status == 508){

            TTAlert(@"图形码错误");
            
        }else{

            TTAlert(@"图形码不匹配");
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(KNetworkFailRemind);
    }];;
}

#pragma mark -- 请求发送4位纯数字短信验证码
-(void)requestSendPhoneMessageCode
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/sendMessage",urlPrefix];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    if (self.userPhoneNumber.length) {
        [requestDict setObject:self.userPhoneNumber forKey:@"phone"];
        [requestDict setObject:@(1) forKey:@"type"];
//        [requestDict setObject:@"2" forKey:@"versionCode"];
    }
    
    [self showHudInView:self.view hint:@""];
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        NSString *message = jsonDict[@"msg"];
        if ([jsonDict[@"status"] integerValue] == 500) {
            TTAlert(@"服务器错误");
        }else if ([jsonDict[@"status"] integerValue] == 502){
            TTAlert(@"10分钟内不能重复发短信验证码");
        }else if ([jsonDict[@"status"] integerValue] == 200){
            //验证码已发出
#ifdef DEBUG
            TTAlert(jsonDict[@"data"][@"messageCode"]);
#endif
            weakSelf.totalTime = 60;
            weakSelf.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakSelf selector:@selector(recordMessageValidity) userInfo:nil repeats:YES];
        }else if ([jsonDict[@"status"] integerValue] == 506){
            TTAlert(message);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        TTAlert(@"连接服务器失败");
    }];
}

#pragma mark -- 记录验证码时效
-(void)recordMessageValidity
{
    if (self.totalTime <= 0) {
        //销毁定时器
        self.getCodeLabel.text = @"获取验证码";
        [self.myTimer invalidate];
        self.myTimer = nil;
    }else{
        self.getCodeLabel.text = [NSString stringWithFormat:@"%ld秒",self.totalTime--];
    }
}

#pragma mark -- 校验4位纯数字短信验证码
-(void)requestCheckPhoneMessageCode
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/checkMessage",urlPrefix];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    if (self.phoneNumberText.text.length) {
        [requestDict setObject:self.phoneNumberText.text forKey:@"phone"];
    }else{
        [self.view makeToast:@"手机号码不能为空" duration:1.f position:@"center"];
        return;
    }
    
    
    if (self.inputPhoneCode.text.length) {
        [requestDict setObject:self.inputPhoneCode.text forKey:@"messageCode"];
    }else{
        [self.view makeToast:@"验证码不能为空" duration:1.f position:@"center"];
        return;
    }
    
    if (self.versionNum) {
        [requestDict setObject:[NSString stringWithFormat:@"%ld",self.versionNum] forKey:@"versionNum"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[NSString stringWithFormat:@"%ld",self.versionNum] forKey:@"versionNum"];
        [ud synchronize];
    }
    
    
    [self showHudInView:self.view hint:@""];
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            //允许用户进入下一界面操作
            [weakSelf enterIntoNextInterface];
            //销毁定时器
            [weakSelf.myTimer invalidate];
            weakSelf.myTimer = nil;
            
        }else if ([jsonDict[@"status"] integerValue] == 500){
//            weakSelf.alertView.message = @"验证码错误";
//            [weakSelf.alertView show];
            TTAlert(@"验证码错误");
        }else{
//            weakSelf.alertView.message = @"验证码过期";
//            [weakSelf.alertView show];
            TTAlert(@"验证码过期");
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
//        weakSelf.alertView.message = @"连接服务器失败";
//        [weakSelf.alertView show];
        TTAlert(@"连接服务器失败");
    }];
}

#pragma mark -- 忘记密码的接口
-(void)checkTelephoneNumberRegister
{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@system/isHavaPhone",urlPrefix];
    NSDictionary *requestDict = nil;
    if (self.phoneNumberText.text.length) {
        requestDict = @{@"telephone":self.phoneNumberText.text};
    }
    //请求接口
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        NSDictionary *jsonDict = JSON;
        NSInteger status = [jsonDict[@"status"] integerValue];
        if (status == 501) {
            TTAlert(@"该手机号未注册");
        }else if(status == 500){
            TTAlert(KNetworkFailRemind);
        }
        else if(status == 502){
            if (weakSelf.isForgetPassword) {
                [weakSelf requestImageCode];
            }else{
                TTAlert(@"该手机号已经注册");
            }
        }
    } failure:^(NSError *error) {
        TTAlert(KNetworkFailRemind);
    }];
}

#pragma mark -- 操作完成，允许用户进入下一个界面操作
-(void)enterIntoNextInterface
{
    if (self.type == forgetPassWordType) {
        //忘记密码界面
        CXResetPasswordController *resetPasswordVC = [[CXResetPasswordController alloc]init];
        resetPasswordVC.userPhoneNumber = self.userPhoneNumber;
        [self presentViewController:resetPasswordVC animated:NO completion:nil];
    }else if(self.type == registerType){
        //注册新公司界面
        CXRegisterCompanyController *registerCompanyVC = [[CXRegisterCompanyController alloc] init];
        registerCompanyVC.userPhoneNumber = self.userPhoneNumber;
        [self presentViewController:registerCompanyVC animated:NO completion:nil];
    }else if(self.type == expressType){
        [self checkExperiess];
    }
}
/** 体验登录接口 */
- (void)checkExperiess
{
    __weak typeof(self) weakSelf = self;
//    [[SDCommonDefine sharedInstance] experienceAccount];
    NSString *url = [NSString stringWithFormat:@"%@register/checkMessageExperience",urlPrefix];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    if (self.phoneNumberText.text.length) {
        [requestDict setObject:self.phoneNumberText.text forKey:@"phone"];
    }
    if (self.inputPhoneCode.text.length) {
        [requestDict setObject:self.inputPhoneCode.text forKey:@"messageCode"];
    }
    
    if (self.versionNum) {
        [requestDict setObject:[NSString stringWithFormat:@"%ld",self.versionNum] forKey:@"versionNum"];
    }
    
    [self showHudInView:self.view hint:@""];
    
    //请求接口
    [HttpTool postWithPath:url params:requestDict success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        NSDictionary *dataDict = JSON[@"data"][@"loginUser"];
        NSString *message = dataDict[@"msg"];
        [weakSelf hideHud];
        if (status == 200) {
            //进入主界面
//            weakSelf.alertView.message = @"体验账号新建成功";
//            [weakSelf.view endEditing:YES];
            TTAlert(@"体验账号新建成功");
            
//            CXHomeController *homevc = [[CXHomeController alloc] init];
//            SDRootNavigationController* navi = [[SDRootNavigationController alloc] initWithRootViewController:homevc];
//            [KEY_WINDOW setRootViewController:navi];
            
            [weakSelf rememberUser];
            
            [[NSUserDefaults standardUserDefaults] setValue:@(-1) forKey:COMPANYID];
            
            NSString *account = [dataDict valueForKey:@"account"];
            if ([account length] > 0) {
                [[NSUserDefaults standardUserDefaults] setValue:account forKey:kAccount];
            }
            
//            NSString *createTime = [dataDict valueForKey:@"createTime"];
//            if ([createTime length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:createTime forKey:kCreateTime];
//            }
            
//            NSNumber *userID = [dataDict valueForKey:@"eid"];// 用户ID
//            if ([userID.stringValue length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:userID forKey:KUserID];
//            }
            
//            NSString *email = [dataDict valueForKey:@"email"];
//            if ([email length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:email forKey:kEmail];
//            }
            
//            NSString *icon = [dataDict valueForKey:@"icon"];
//            if ([icon length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:icon forKey:kIcon];
//            }
            
            NSString *hUser = [dataDict objectForKey:@"imAccount"];
            if ([hUser length] > 0) {
                // 将IM用户名保存在本地
                [[NSUserDefaults standardUserDefaults] setValue:hUser forKey:HXACCOUNT];
            }
            
            //如果未保存权限设置则需要保存权限设置
            if (VAL_HAD_SAVE_RedViewShow == nil) {
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                [ud setValue:[NSString stringWithFormat:@"已经保存%@红点开关",VAL_HXACCOUNT] forKey:HAD_SAVE_RedViewShow];
                [ud setBool:NO forKey:SHOW_ADD_FRIENDS];
                [ud setBool:NO forKey:HAVE_UNREAD_WORKCIRCLE_MESSAGE];
                [ud synchronize];
            }
            
            
//            NSString *sex = [dataDict valueForKey:@"sex"];
//            if ([sex length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:sex forKey:kSex];
//            }
            
//            NSString *telephone = [dataDict objectForKey:@"telephone"];
//            if ([telephone length] > 0) {
//                [[NSUserDefaults standardUserDefaults] setValue:telephone forKey:kTelephone];
//            }
            
            [[NSUserDefaults standardUserDefaults] setValue:[dataDict valueForKey:@"token"] forKey:key_token];
            
//            NSString *updateTime = [dataDict objectForKey:@"updateTime"];
//            if ([updateTime length] > 0) {
//                // 将环信用户名保存在本地
//                [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:kUpdateTime];
//            }
            
            SDDataBaseHelper *helper = [SDDataBaseHelper shareDB];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([helper deleteAllTable]) {
                NSString *url = [NSString stringWithFormat:@"%@friend/findContacts", urlPrefix];
                [HttpTool postWithPath:url
                                params:nil
                               success:^(id JSON) {
                                   NSDictionary *dic = JSON;
                                   NSNumber *status = dic[@"status"];
                                   if ([status intValue] == 200) {
                                       // 保存到本地
                                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                                           [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:JSON[@"data"]];

                                           for (NSDictionary *userDic in JSON[@"data"]) {
                                               SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
                                               userModel.userId = @([userDic[@"userId"] integerValue]);
                                               [helper insertCompanyUser:userModel];
                                           }
                                           
                                           [userDefaults synchronize];
                                           
                                           // 获取物流数据
                                           [[CXStaticDataHelper sharedInstance] getStaticDataWithType:CXStaticDataTypeLogistics completion:^(NSError *error, NSArray<CXStaticDataModel *> *datas) {
                                               if (!error) {
                                                   NSArray<NSDictionary *> *logisticsData =  [datas yy_modelToJSONObject];
                                                   [userDefaults setObject:logisticsData forKey:KLogisticsCompanyDataKey];
                                                   [userDefaults synchronize];
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [weakSelf imLoginWithUsername:hUser password:@"123456"];
                                                       /// 获取静态数据
                                                       [weakSelf getStaticData];
                                                   });
                                               }
                                               else {
                                                   [weakSelf hideHud];
                                                   TTAlertNoTitle(@"获取物流公司信息失败");
                                               }
                                           }];
                                           
                                           
                                       });
                                   }
                                   else{
                                       [weakSelf hideHud];
                                       TTAlertNoTitle(@"获取通讯录失败");
                                   }
                               }
                               failure:^(NSError *error) {
                                   [weakSelf hideHud];
                                   TTAlertNoTitle(@"获取通讯录失败");
                               }];
            }
            
        }else{
//            weakSelf.alertView.message = message;
            TTAlert(message);
        }
    } failure:^(NSError *error) {
        
        [weakSelf hideHud];
        NSLog(@"error = %@",error);
//        weakSelf.alertView.message = KNetworkFailRemind;
//        [weakSelf.alertView show];
        
        TTAlert(KNetworkFailRemind);
    }];
}
- (void)imLoginWithUsername:(NSString *)username password:(NSString *)password {
    //    // 屏蔽im登录
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    //    [SDDataBaseHelper shareDB];
    //    return;
    
    [SDWebSocketManager shareWebSocketManager]; // 初始化SDWebSocketManager添加代理
    [[CXIMService sharedInstance] loginWithAccount:username password:password completion:^(NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            [SDDataBaseHelper shareDB];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self hideHud];
            NSLog(@"cxim login error:%@", error.localizedDescription);
        }
    }];
}
/// 获取静态数据
- (void)getStaticData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取静态数据，保存到本地
        [[CXStaticDataHelper sharedInstance] getStaticDataFromServer];
    });
}
/// 记住帐号
- (void)rememberUser {
//    NSUserDefaults *loginDefaults = [NSUserDefaults standardUserDefaults];
//    [loginDefaults setObject:_subLoginView.password.text forKey:@"pwd"];
//    [loginDefaults setObject:_subLoginView.myAccount.text forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
