//
//  SDIMChangeMyselfInfomatinViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/6.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMChangeMyselfInfomatinViewController.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "SDDataBaseHelper.h"
#import "NSString+TextHelper.h"
#import "CXLoaclDataManager.h"

@interface SDIMChangeMyselfInfomatinViewController()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) SDRootTopView* rootTopView;

@end

@implementation SDIMChangeMyselfInfomatinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(self.topTitle)];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popViewController)];
    [self.rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(saveInfo)];
    
    self.view.backgroundColor = SDBackGroudColor;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 5.0;
    self.textField.layer.borderWidth = 1.0;
    self.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_topTitle];
    self.textField.text = _contentText;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:self.textField];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)popViewController
{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//判断正确的电话
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 虚拟运营商：17[0-9]
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     虚拟运营商
     */
    NSString * COther = @"^1[7]\\d{9}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestcother = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", COther];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestPHS evaluateWithObject:mobileNum] == YES)
        || ([regextestcother evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//检测字节数
- (int)LengthOfNSString:(NSString*)str
{
    int nIndex=0;
    for(int i=0;i<[str length];i++){
        if ([str characterAtIndex:i]<256) {
            nIndex=nIndex+1;
        }
        else
            nIndex=nIndex+2;
    }
    return nIndex;
}

- (void)saveInfo
{
    [_textField resignFirstResponder];
    if([self.topTitle isEqualToString:@"修改姓名"]){
        if (_textField.text.length <=0 || [NSString containBlankSpaceWithSelectedStr:_textField.text])
        {
            [self.view makeToast:@"姓名不能为空" duration:2 position:@"center"];
            return;
        }else if([self LengthOfNSString:_textField.text] > 16){
            [self.view makeToast:@"姓名最大长度为16个字节，您输入的姓名超出长度限制，请重新输入" duration:2 position:@"center"];
            return;
        }else{
            [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@sysuser/update", urlPrefix] withparameter:@"name" withValue:_textField.text];
        }
    }else if([self.topTitle isEqualToString:@"修改邮箱"]){
        if ([_textField.text checkEmail:_textField.text]) {
            [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@sysuser/update", urlPrefix] withparameter:@"email" withValue:_textField.text];
        }
        else {
            [self.view makeToast:@"请输入有效邮箱地址" duration:2 position:@"center"];
            return;
        }
    }else if([self.topTitle isEqualToString:@"修改电话"]){
        if ([_textField.text checkMobilePhone:_textField.text]) {
            [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@sysuser/update", urlPrefix] withparameter:@"telephone" withValue:_textField.text];
        }
        else {
            [self.view makeToast:@"请输入有效电话或手机号码" duration:2 position:@"center"];
            return;
        }
    }
}

#pragma mark--网络请求
- (void)requestDataFromNetWorkWithUrlString:(NSString*)urlString withparameter:(NSString*)str withValue:(NSString*)value
{
    [self showHudInView:self.view hint:@"更改中..."];
    NSDictionary* dic = @{str : value};
    [HttpTool postWithPath:urlString params:dic success:^(id JSON) {
        [self hideHud];
        if ([JSON[@"status"] intValue] == 200) {
            BOOL success = NO;
            if([self.topTitle isEqualToString:@"修改姓名"]){
                success = [[SDDataBaseHelper shareDB]updateUserRealName:[[AppDelegate getUserID] integerValue] withRealName:value];
                [[CXLoaclDataManager sharedInstance] updateRealNameWithRealName:value AndIMAccount:VAL_HXACCOUNT];
            }else if([self.topTitle isEqualToString:@"修改邮箱"]){
                success = [[SDDataBaseHelper shareDB]updateUserEamil:[[AppDelegate getUserID] integerValue] withEail:value];
                [[CXLoaclDataManager sharedInstance] updateEamilWithEamil:value AndIMAccount:VAL_HXACCOUNT];
                [[NSUserDefaults standardUserDefaults] setValue:value forKey:kEmail];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else if([self.topTitle isEqualToString:@"修改电话"]){
                success = [[SDDataBaseHelper shareDB]updateUserPhone:[[AppDelegate getUserID] integerValue] withPhone:value];
                [[CXLoaclDataManager sharedInstance]updatePhoneWithPhone:value AndIMAccount:VAL_HXACCOUNT];
                [[NSUserDefaults standardUserDefaults] setValue:value forKey:kTelephone];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if(success){
                TTAlert(@"修改成功");
            }else{
                TTAlert(@"保存本地不成功，请刷新通讯录");
            }
            [self popViewController];
        }
        else {
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [self hideHud];
        TTAlert(@"您的网络不太稳定哦");
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
