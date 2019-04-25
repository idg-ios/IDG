//
//  SDMailAccountSettingController.m
//  SDMarketingManagement
//
//  Created by admin on 15/11/5.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDMailAccountSettingController.h"
#import "NSString+TextHelper.h"
#import "STMCOIMAPSession.h"
#import "STMCOPOPSession.h"
#import "AppDelegate.h"
#import "SDMenuView.h"
#import "Masonry.h"

@interface SDMailAccountSettingController () <UIScrollViewDelegate,SDMenuViewDelegate,UITextFieldDelegate>
{
    int keyboardY;
}
@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (strong, nonatomic) NSString *emailReceiveProtocol;
@property (strong, nonatomic) NSString *emailSendProtocol;

/// 选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL clickFlag;

@end

@implementation SDMailAccountSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _emailAccount.delegate = self;
    _emailPassword.delegate = self;
    
    [self setUpTopView];
    [self setUpEmailAccount];
    [self setBottomViewPosition];
}

-(void)setBottomViewPosition{
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(Screen_Height-50);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@5.);
        
    }];
    
    [self.nextStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(Screen_Height-40);
        make.height.equalTo(@30);
        make.width.equalTo(@80.);
        make.left.equalTo(self.view).mas_offset(@10);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(Screen_Height-5);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@5.);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///// 设置顶部视图
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"设置邮箱账号"];
    
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(customLeftBtnClick)];
    // +
    //[self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(rightBtnClick:)];

    // 下一步按钮
    [_btnPOP addTarget:self action:@selector(setButtonState:) forControlEvents:UIControlEventTouchUpInside];
    [_btnIMAP addTarget:self action:@selector(setButtonState:) forControlEvents:UIControlEventTouchUpInside];
    [_nextStep addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)rightBtnClick:(UIButton *)sender
{
    _selectedButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSArray *dataArray = @[@"叮当享团队"];
        NSArray *imageArray = @[@"menu_service"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        _selectMemu.isPresentview = YES;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [_selectMemu removeFromSuperview];
    }
}
#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString *)cardName
{
    _selectedButton.selected = NO;
    [_selectMemu removeFromSuperview];
}
///// 设置按钮状态
- (void)setButtonState:(UIButton *)sender
{
    if (sender.tag == 0) {
        [_btnPOP setSelected:YES];
        [_btnIMAP setSelected:NO];
    } else {
        [_btnPOP setSelected:NO];
        [_btnIMAP setSelected:YES];
    }
}
///// 返回按钮
- (void)customLeftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
///// 完成按钮
- (void)nextStepAction:(UIButton *)sender
{
    if (_emailAccount.text.length == 0)
    {
        TTAlertNoTitle(@"请输入邮箱账户");
        return;
    }
    if (_emailPassword.text.length == 0)
    {
        TTAlertNoTitle(@"请输入邮箱密码");
        return;
    }
    
    if ([NSString isEmail:_emailAccount.text])
    {
        // 验证账号和密码
        [self showHudInView:self.view hint:@"正在验证账号和密码，请稍候"];
        
        NSLog(@"邮件配置－－－－－－－－－－－－－－－－－");
        NSLog(@"账号：%@",_emailAccount.text);
        NSLog(@"密码：%@",_emailPassword.text);
        
        NSRange range = [_emailAccount.text rangeOfString:@"@"];
        NSString *subString = [_emailAccount.text substringFromIndex:range.location + 1];
        NSString *sendSubString;
        if([subString isEqualToString:@"idgcapital.com"]) {
            subString = @"pop-mail.outlook.com";
            sendSubString = @"smtp-mail.outlook.com";
        }
        
        if (_btnPOP.selected == YES)
        {
            [[STMCOPOPSession getSessionInstanct] clearSesstionInstance];
            _emailReceiveProtocol = subString;//[NSString stringWithFormat:@"pop.%@",subString];
            _emailSendProtocol = sendSubString;//[NSString stringWithFormat:@"smtp.%@",subString];
            
            NSLog(@"收件服务器地址：%@",_emailReceiveProtocol);
            NSLog(@"发件服务器地址：%@",_emailSendProtocol);
            
            /// POP协议
            [[STMCOPOPSession getSessionInstanct] loadAccountWithUsername:_emailAccount.text password:_emailPassword.text hostname:_emailReceiveProtocol port:995 loadUserResultBlock:^(BOOL isSuccess)
            {
                if (isSuccess)
                {
                    [self hideHud];
                    [[STMCOPOPSession getSessionInstanct] clearSesstionInstance];
                    // 归档账户信息
                    [self setArchiver];
                    
                    // 控制器切换
                    if (_fromWhere != nil) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMailList" object:nil];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMailList" object:nil];
                        }];
                    }
                }
                else {
                    [self hideHud];
                    [[STMCOPOPSession getSessionInstanct] clearSesstionInstance];
                    
                    TTAlertNoTitle(@"帐号或密码或服务器地址错误,请重新输入");
                    return;
                }
            }];
        }
        else if (_btnIMAP.selected == YES)
        {
            [[STMCOIMAPSession getSessionInstanct] clearSesstionInstance];
            _emailReceiveProtocol = [NSString stringWithFormat:@"imap.%@",subString];
            _emailSendProtocol = [NSString stringWithFormat:@"smtp.%@",subString];
            
            NSLog(@"收件服务器地址：%@",_emailReceiveProtocol);
            NSLog(@"发件服务器地址：%@",_emailSendProtocol);
            
            /// IMAP协议
            [[STMCOIMAPSession getSessionInstanct] loadAccountWithUsername:_emailAccount.text password:_emailPassword.text hostname:_emailReceiveProtocol port:993 oauth2Token:nil loadUserResultBlock:^(BOOL isSuccess)
            {
                if (isSuccess)
                {
                    [self hideHud];
                    [[STMCOIMAPSession getSessionInstanct] clearSesstionInstance];
                    // 归档账户信息
                    [self setArchiver];

                    // 控制器切换
                    if (_fromWhere != nil) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMailList" object:nil];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMailList" object:nil];
                        }];
                    }
                }
                else {
                    [self hideHud];
                    [[STMCOIMAPSession getSessionInstanct] clearSesstionInstance];
                    TTAlertNoTitle(@"帐号或密码错误或类型不支持,请重新输入");
                    return;
                }
            }];
        }
    }
    else {
        TTAlertNoTitle(@"请输入正确的邮箱账号");
        return;
    }
}

///// 初始化账号密码
- (void)setUpEmailAccount
{
    if (_fromWhere != nil) {
        /// 反归档
        NSString *userID = [AppDelegate getUserID];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data",kMailFilePath,userID];
        NSData *unarchiverData = [[NSFileManager defaultManager] contentsAtPath:filePath];

        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:unarchiverData];
        _emailAccount.text = [unarchiver decodeObjectForKey:KMailAccount];
        _emailPassword.text = [unarchiver decodeObjectForKey:KMailPassword];
        _emailReceiveProtocol = [unarchiver decodeObjectForKey:kMailReceiveProtocol];

        [unarchiver finishDecoding];
        
        if ([_emailReceiveProtocol rangeOfString:@"pop"].location !=NSNotFound)
        {
            [_btnPOP setSelected:YES];
            [_btnIMAP setSelected:NO];
        } else {
            [_btnPOP setSelected:NO];
            [_btnIMAP setSelected:YES];
        }
    } else {
        [_btnPOP setSelected:YES];
        [_btnIMAP setSelected:NO];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (_selectedButton.selected == YES) {
        _selectedButton.selected = NO;
        [_selectMemu removeFromSuperview];
    }
}

///// 归档
- (void)setArchiver{
    // 判断文件夹存不存在
    if (![[NSFileManager defaultManager]fileExistsAtPath:kMailFilePath]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:kMailFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *userID = [AppDelegate getUserID];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data",kMailFilePath,userID];
    
    NSMutableData *archiverData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:archiverData];
    [archiver encodeObject:_emailAccount.text forKey:KMailAccount];
    [archiver encodeObject:_emailPassword.text forKey:KMailPassword];
    [archiver encodeObject:_emailReceiveProtocol forKey:kMailReceiveProtocol];
    [archiver encodeObject:_emailSendProtocol forKey:kMailSendProtocol];
    [archiver finishEncoding];
    [archiverData writeToFile:filePath atomically:NO];
}

- (BOOL)textFieldShouldBeginEditing:( UITextField *)textField
{
    if (_selectedButton.selected == YES) {
        _selectedButton.selected = NO;
        [_selectMemu removeFromSuperview];
    }
    return YES;
}

@end
