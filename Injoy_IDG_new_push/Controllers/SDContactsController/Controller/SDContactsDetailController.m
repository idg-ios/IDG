//
//  SDContactsDetailController.m
//  SDMarketingManagement
//
//  Created by admin on 16/1/7.
//  Copyright (c) 2016年 slovelys. All rights reserved.
//

#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "SDMenuView.h"
#import "AppDelegate.h"
#import "SDIMChatViewController.h"
#import "SDPermissionsDetectionUtils.h"
#import "SDIMVoiceAndVideoCallViewController.h"
#import "CXIMHelper.h"
#import "HttpTool.h"


@interface SDContactsDetailController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,SDMenuViewDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (strong, nonatomic) SDDataBaseHelper* dataHelper;
@property (strong, nonatomic) NSMutableArray* contactUserArr;
@property (nonatomic, strong) NSMutableArray* groupAry;/// 群组
@property (copy, nonatomic) NSString* voiceConferenceTitle;/// 会议议题
@property (strong, nonatomic) NSString* chatter;  // 环信ID
/// 选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) UIButton* selectedButton;
@property (nonatomic, strong) NSString* searchText;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL clickFlag;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIImageView *sexImage;
@property (nonatomic, strong) UILabel *departLabel;
@property (nonatomic, strong) UIWebView *showImageWebView;
@property (nonatomic, strong) UIScrollView *mailScrollView;

@end

@implementation SDContactsDetailController

#define kHeadImageViewWidth 110.0
#define kUserNameLabelTopSpace 15.0
#define kUserNameLabelFontSize 18.0
#define kSendMessageBtnTopSpace 20.0
#define kSendVoiceBtnTopSpace 15.0
#define kBottomBtnViewHeight 85.0

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpNavBar
{
    _rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"详细资料"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUI
{
    UIScrollView * backScrollView = [[UIScrollView alloc] init];
    backScrollView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - kBottomBtnViewHeight);
    backScrollView.backgroundColor = RGBACOLOR(232.0, 232.0, 232.0, 1.0);
    backScrollView.bounces = NO;
    [self.view addSubview:backScrollView];
    
    UIImageView * contactsDetailImageView = [[UIImageView alloc] init];
    contactsDetailImageView.frame = CGRectMake(0, 0, Screen_Width, 370.0*Screen_Width/676.0);
    contactsDetailImageView.image = [UIImage imageNamed:@"contactsDetailImage"];
    contactsDetailImageView.highlightedImage = [UIImage imageNamed:@"contactsDetailImage"];
    [backScrollView addSubview:contactsDetailImageView];
    
    UIView * whiteBackView = [[UIView alloc] init];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:whiteBackView];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake((Screen_Width - kHeadImageViewWidth)/2, CGRectGetMaxY(contactsDetailImageView.frame) - kHeadImageViewWidth*3/4, kHeadImageViewWidth, kHeadImageViewWidth)];
    _headImage.layer.cornerRadius = 4;
    _headImage.clipsToBounds = YES;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _userModel.icon]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_headImage addGestureRecognizer:tapGesture];
    [backScrollView addSubview:_headImage];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImage.frame) + kUserNameLabelTopSpace, Screen_Width, kUserNameLabelFontSize)];
    _userName.font = [UIFont systemFontOfSize:kUserNameLabelFontSize];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor blackColor];
    _userName.text = _userModel.realName;
    [backScrollView addSubview:_userName];
    
    whiteBackView.frame = CGRectMake(0, CGRectGetMaxY(contactsDetailImageView.frame), Screen_Width, kHeadImageViewWidth*1/4 + kUserNameLabelTopSpace + kUserNameLabelFontSize + kUserNameLabelTopSpace);
    
    UIButton *onlineChat = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineChat.tag = 1;
    onlineChat.frame = CGRectMake(7, CGRectGetMaxY(whiteBackView.frame) + kSendMessageBtnTopSpace, Screen_Width-14, 55);
    [onlineChat setTitle:@"发信息" forState:UIControlStateNormal];
    [onlineChat.layer setCornerRadius:5.0];
    [onlineChat setBackgroundColor:kColorWithRGB(68, 195, 24)];
    [onlineChat addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:onlineChat];
    
    UIButton *voiceChat = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceChat.tag = 2;
    voiceChat.frame = CGRectMake(7, CGRectGetMaxY(onlineChat.frame) + kSendVoiceBtnTopSpace, Screen_Width-14, 55);
    [voiceChat setTitle:@"语音通话" forState:UIControlStateNormal];
    [voiceChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [voiceChat.layer setCornerRadius:5.0];
    [voiceChat setBackgroundColor:[UIColor whiteColor]];
    [voiceChat addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:voiceChat];
    
    [backScrollView setContentSize:CGSizeMake(Screen_Width, CGRectGetMaxY(voiceChat.frame) + kSendMessageBtnTopSpace)];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - kBottomBtnViewHeight, Screen_Width, kBottomBtnViewHeight)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.tag = 3;
    phoneBtn.frame = CGRectMake(7, 15, Screen_Width/2 - 14, 55);
    [phoneBtn setTitle:@"打电话" forState:UIControlStateNormal];
    [phoneBtn.layer setCornerRadius:5.0];
    [phoneBtn setBackgroundColor:kColorWithRGB(255, 95, 95)];
    [phoneBtn addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:phoneBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.tag = 4;
    messageBtn.frame = CGRectMake(Screen_Width/2 + 7, 15, Screen_Width/2 - 14, 55);
    [messageBtn setTitle:@"发短信" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageBtn.layer setCornerRadius:5.0];
    [messageBtn setBackgroundColor:[UIColor whiteColor]];
    [messageBtn addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.layer.borderColor = RGBACOLOR(214.0, 214.0, 214.0, 214.0).CGColor;
    messageBtn.layer.borderWidth = 1.0;
    [btnView addSubview:messageBtn];
}

- (void)tapAction:(id)sender
{
    SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
    pivc.canPopViewController = YES;
    pivc.imAccount = _userModel.imAccount;
    [self.navigationController pushViewController:pivc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)chatClick:(UIButton *)sender
{
    if (_selectedButton.selected == YES) {
        _selectedButton.selected = NO;
        [_selectMemu removeFromSuperview];
    }
    
    switch (sender.tag) {
        case 1: {
            SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
            chatVC.isGroupChat = NO;
            chatVC.chatter = _userModel.hxAccount;
            chatVC.chatterDisplayName = _userModel.realName;
            [self.navigationController pushViewController:chatVC animated:YES];
        } break;
        case 2: {
            if (![SDPermissionsDetectionUtils checkCanRecordFree]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"此应用没有语音权限" message:@"您可以在“隐私设置”中开启语音权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else{
                SDIMVoiceAndVideoCallViewController * videoCallController = [[SDIMVoiceAndVideoCallViewController alloc] initWithInitiateOrAcceptCallType:SDIMCallInitiateType];
                videoCallController.audioOrVideoType= CXIMMediaCallTypeAudio;
                videoCallController.chatter = _userModel.hxAccount;
                videoCallController.chatterDisplayName = [CXIMHelper getRealNameByAccount:_userModel.hxAccount];
                [self presentViewController:videoCallController animated:YES completion:nil];
            }
            
        } break;
        case 3: {
            NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,_userModel.imAccount];
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:nil];
            
            [HttpTool getWithPath:url params:nil success:^(id JSON) {
                [weakSelf hideHud];
                NSDictionary *jsonDict = JSON;
                if ([jsonDict[@"status"] integerValue] == 200) {
                    if(JSON[@"data"]){
                        self.userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                        self.userModel.hxAccount = self.userModel.imAccount;
                        self.userModel.realName = self.userModel.name;
                    }
                    if (_userModel.telephone.length <= 0)
                    {
                        TTAlert(@"此人未录入电话");
                        return;
                    }
                    UIWebView* callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _userModel.telephone]];
                    [callWebView loadRequest:[NSURLRequest requestWithURL:url]];
                    [self.view addSubview:callWebView];
                    
                }else{
                    TTAlert(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        } break;
        case 4: {
            NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,_userModel.imAccount];
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:nil];
            
            [HttpTool getWithPath:url params:nil success:^(id JSON) {
                [weakSelf hideHud];
                NSDictionary *jsonDict = JSON;
                if ([jsonDict[@"status"] integerValue] == 200) {
                    if(JSON[@"data"]){
                        self.userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                        self.userModel.hxAccount = self.userModel.imAccount;
                        self.userModel.realName = self.userModel.name;
                    }
                    /// 发短信
                    if (_userModel.telephone.length <= 0)
                    {
                        TTAlert(@"此人未录入电话");
                        return;
                    }
                    [self sendMailWithTelephone:_userModel.telephone];
                }else{
                    TTAlert(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        } break;
        default:
            break;
    }
}

#pragma mark 发短信功能
- (void)sendMailWithTelephone:(NSString*)telephone
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = [NSArray arrayWithObject:telephone];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[controller.viewControllers lastObject] navigationItem] setTitle:@"发短信"];
    }
    else {
        [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            [self alertWithTitle:@"提示信息" msg:@"短信取消"];
            break;
            
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"短信已发送"];
            break;
            
        case MessageComposeResultFailed:
            [self alertWithTitle:@"提示信息" msg:@"短信发送失败"];
            break;
        default:
            break;
    }
}

- (void)alertWithTitle:(NSString*)title msg:(NSString*)msg
{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];
}

@end
