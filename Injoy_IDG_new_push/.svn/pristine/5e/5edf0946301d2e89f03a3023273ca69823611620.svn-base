//
//  CXIMChangeYXTBMSViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/11/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIMChangeYXTBMSViewController.h"
#import "UIView+Category.h"
#import "AppDelegate.h"
#import "HttpTool.h"

#define kBackViewY 30
#define kLeftSpaceMargin 20.f //控件距离两边的距离
#define SDIMLabelFont 40
//键盘出现时向上移动的距离
#define kMoveHeight 30

@interface CXIMChangeYXTBMSViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITextField * firstNewPasswordTextField;
//把子控件都加在backView上，如果弹出键盘挡住了输入框，则上移backView，否则要移动太多东西
@property (nonatomic, strong) UIView * backView;
//键盘高度
@property (nonatomic) CGFloat kbHeight;

@end

@implementation CXIMChangeYXTBMSViewController

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
    [self.rootTopView setNavTitle:LocalString(@"同步日历")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, navHigh + kBackViewY, Screen_Width, Screen_Height - navHigh - kBackViewY);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    UILabel * firstNewPasswordLabel = [[UILabel alloc] init];
    firstNewPasswordLabel.font = [UIFont systemFontOfSize:16.f];
    firstNewPasswordLabel.textColor = [UIColor blackColor];
    firstNewPasswordLabel.textAlignment = NSTextAlignmentLeft;
    firstNewPasswordLabel.text = @"邮箱密码：";
    [firstNewPasswordLabel sizeToFit];
    firstNewPasswordLabel.frame = CGRectMake(kLeftSpaceMargin, 0, firstNewPasswordLabel.size.width, SDIMLabelFont);
    firstNewPasswordLabel.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:firstNewPasswordLabel];
    
    self.firstNewPasswordTextField = [[UITextField alloc] init];
    self.firstNewPasswordTextField.frame = CGRectMake(CGRectGetMaxX(firstNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing, CGRectGetMinY(firstNewPasswordLabel.frame), Screen_Width - (CGRectGetMaxX(firstNewPasswordLabel.frame) + SDHeadImageViewLeftSpacing) - kLeftSpaceMargin, SDIMLabelFont);
    self.firstNewPasswordTextField.placeholder = @"请填写您的邮箱密码";
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
    
    NSString * text = @"设置您的IDGCapital邮箱密码后， 系统将自动将我的会议（月会）相关安排同步到个人Outlook日程安排中去";
    UIFont * font = [UIFont systemFontOfSize:13.0];
    UILabel * label = [[UILabel alloc] init];
    CGSize size = [text boundingRectWithSize:CGSizeMake(Screen_Width - 2*kLeftSpaceMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    label.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(firstNewPasswordLabel.frame) + kBackViewY + 10, Screen_Width - 2*kLeftSpaceMargin, size.height);
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBACOLOR(188.0, 188.0, 188.0, 1.0);
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    [self.backView addSubview:label];
    
    UIButton * changePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePasswordBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [changePasswordBtn setTitle:@"确   定" forState:UIControlStateHighlighted];
    [changePasswordBtn setBackgroundColor:RGBACOLOR(43.0, 43.0, 46.0, 1.0)];
    changePasswordBtn.frame = CGRectMake(kLeftSpaceMargin, CGRectGetMaxY(label.frame) + kBackViewY, Screen_Width - 2*kLeftSpaceMargin, SDMeCellHeight);
    changePasswordBtn.layer.cornerRadius = 5;
    changePasswordBtn.layer.masksToBounds = YES;
    [changePasswordBtn addTarget:self action:@selector(changePasswordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:changePasswordBtn];
}

- (void)changePasswordBtnClick
{
    [_firstNewPasswordTextField resignFirstResponder];
    if(_firstNewPasswordTextField.text.length == 0)
    {
        [self.view makeToast:@"邮箱密码不能为空" duration:2 position:@"center"];
        return;
    }
    [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@system/password", urlPrefix]];
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
    NSString *newPassWordString = _firstNewPasswordTextField.text;
    [requstDict setObject:newPassWordString forKey:@"password"];
    [HttpTool postWithPath:urlString params:requstDict success:^(id JSON){
        [self hideHud];
        if ([JSON[@"status"] intValue] == 200)
        {
            [[UIApplication sharedApplication].keyWindow makeToast:JSON[@"msg"] duration:2 position:@"center"];
//            VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_EXCHANGE_WAIT_CHANGE_BTYPE);
            [self.navigationController popViewControllerAnimated:YES];
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
