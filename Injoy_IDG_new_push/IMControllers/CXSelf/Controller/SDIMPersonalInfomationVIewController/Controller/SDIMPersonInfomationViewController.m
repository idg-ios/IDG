//
//  SDIMPersonInfomationViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/6.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMPersonInfomationViewController.h"
#import "SDCompanyUserModel.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "IBActionSheet.h"
#import "SDUploadFileModel.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "SDIMChangePasswordViewController.h"
#import "SDIMChangeMyselfInfomatinViewController.h"
#import "SDIMImageViewerController.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"
#import "AliImageReshapeController.h"
#import "SDWebSocketManager.h"
#import "SDIMChatViewController.h"
#import "SDPermissionsDetectionUtils.h"
#import "SDIMVoiceAndVideoCallViewController.h"
#import "SDIMMySettingViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CXSendMsgAndTelView.h"
#import "CXIDGBackGroundViewUtil.h"
#import "CXIMChangeYXTBMSViewController.h"


#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <AddressBookUI/ABNewPersonViewController.h>

#define kImageLeftSpace 15.0
#define kImageWidth 20.0
#define kImageRightSpace 8.0
#define kHeightOfHeadCell 80
#define kMyselfTableViewFooterHeight ((self.canPopViewController?(Screen_Height - kHeightOfHeadCell - SDMeCellHeight*7 - 10.0 - navHigh) > 0:(Screen_Height - kTabbarHeight - kHeightOfHeadCell - SDMeCellHeight*7 - 10.0 - navHigh) > 0)?((self.canPopViewController?Screen_Height - kHeightOfHeadCell - SDMeCellHeight*7 - 10.0 - navHigh:Screen_Height - kTabbarHeight - kHeightOfHeadCell - SDMeCellHeight*7 - 10.0 - navHigh)):40.0)

#define kOtherTableViewFooterHeight (kSendMessageBtnTopSpace*2 + 48.0*2 + kSendVoiceBtnBottomSpace)
#define kSendMessageBtnTopSpace 20.0
#define kSendVoiceBtnTopSpace 20.0
#define kSendVoiceBtnBottomSpace ((Screen_Height - kHeightOfHeadCell - SDMeCellHeight*6 - kSendMessageBtnTopSpace*2 - 48.0*2 - 10.0 - navHigh)>0?(Screen_Height - kHeightOfHeadCell - SDMeCellHeight*6 - kSendMessageBtnTopSpace*2 - 48.0*2 - 10.0 - navHigh):40.0)
#define kBottomBtnViewHeight 65.0
#define kImageIconPath @"imageIconPath"

@interface SDIMPersonInfomationViewController()<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ALiImageReshapeDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,CNContactViewControllerDelegate,ABNewPersonViewControllerDelegate,CNContactPickerDelegate>

//导航栏
@property (nonatomic, strong) SDRootTopView* rootTopView;
//table
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic) SDIMPersonInfomationType personInfomationType;

@property (nonatomic,strong) SDCompanyUserModel * userModel;

@property (nonatomic, strong) IBActionSheet* standardIBAS;

@property (nonatomic) BOOL sexUp;

@property (nonatomic, strong) NSArray* pickerData; //性别选择器数据

@property (nonatomic, strong) UIView* sexSelectView; //选择性别

@property (nonatomic, strong) UIPickerView* pickerView;

@property (nonatomic, strong) UIImageView * headImageView;

@property (nonatomic, strong) NSMutableArray * annex;
//发送的附件数组
@property (nonatomic, strong) NSMutableArray * sendAnnexDataArray;

//联系人table列表的背景颜色
@property (nonatomic, strong) UIView * personalTableViewBackView;

@end

@implementation SDIMPersonInfomationViewController

- (UIView *)personalTableViewBackView{
    if(!_personalTableViewBackView){
        _personalTableViewBackView = [[UIView alloc] init];
        _personalTableViewBackView.frame = self.tableView.frame;
        _personalTableViewBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_personalTableViewBackView];
    }
    return _personalTableViewBackView;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userModel = [CXIMHelper getUserByIMAccount:self.imAccount];
    [self.tableView reloadData];
    if(self.imAccount){
        NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,self.imAccount];
        __weak __typeof(self)weakSelf = self;
        [HttpTool getWithPath:url params:nil success:^(id JSON) {
            [weakSelf hideHud];
            NSDictionary *jsonDict = JSON;
            if ([jsonDict[@"status"] integerValue] == 200) {
                if(JSON[@"data"]){
                    self.userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                    self.userModel.hxAccount = self.userModel.imAccount;
                    self.userModel.realName = self.userModel.name;
                }
                
                [self.tableView reloadData];
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            CXAlert(KNetworkFailRemind);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if([self.imAccount isEqualToString:VAL_HXACCOUNT]){
        self.personInfomationType = SDIMMyselfType;
    }else{
        self.personInfomationType = SDIMOtherPersonType;
    }
    
    [self setUpUI];
    
    if(self.personInfomationType == SDIMMyselfType){
        UIView * footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, Screen_Width, kMyselfTableViewFooterHeight);
        footerView.backgroundColor = SDBackGroudColor;
        
        UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(0, 12.0, Screen_Width, SDMeCellHeight);
        logoutBtn.backgroundColor = [UIColor whiteColor];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
        [logoutBtn setTitleColor:RGBACOLOR(31.0, 34.0, 40.0, 1.0) forState:UIControlStateNormal];
        [logoutBtn setTitleColor:RGBACOLOR(31.0, 34.0, 40.0, 1.0) forState:UIControlStateHighlighted];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
        [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutBtn];
        
        [self.tableView setTableFooterView:footerView];
    }else{
        UIView * footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, Screen_Width, kOtherTableViewFooterHeight);
        footerView.backgroundColor = SDBackGroudColor;
        
        UIButton *onlineChat = [UIButton buttonWithType:UIButtonTypeCustom];
        onlineChat.tag = 1;
        onlineChat.frame = CGRectMake(15, kSendMessageBtnTopSpace, Screen_Width-30, 48.0);
        [onlineChat setTitle:@"发信息" forState:UIControlStateNormal];
        [onlineChat.layer setCornerRadius:5.0];
        [onlineChat setBackgroundColor:RGBACOLOR(170.0, 25.0, 48.0, 1.0)];
        [onlineChat addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:onlineChat];
        
        UIButton *voiceChat = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceChat.tag = 2;
        voiceChat.frame = CGRectMake(15, CGRectGetMaxY(onlineChat.frame) + kSendVoiceBtnTopSpace, Screen_Width-30, 48.0);
        [voiceChat setTitle:@"语音通话" forState:UIControlStateNormal];
        [voiceChat setTitleColor:RGBACOLOR(170.0, 25.0, 48.0, 1.0) forState:UIControlStateNormal];
        [voiceChat.layer setCornerRadius:5.0];
        voiceChat.layer.borderColor = RGBACOLOR(170.0, 25.0, 48.0, 1.0) .CGColor;
        voiceChat.layer.borderWidth = 0.5;
        [voiceChat setBackgroundColor:[UIColor whiteColor]];
        [voiceChat addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:voiceChat];
        
        [self.tableView setTableFooterView:footerView];
    }
}

#pragma mark - 内部方法
- (void)chatClick:(UIButton *)sender
{
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

- (void)logoutBtnClick
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = 2;
    [alertView show];
}

- (NSMutableArray *)annex{
    if(!_annex){
        _annex = @[].mutableCopy;
    }
    return _annex;
}

- (void)setUpUI
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    if(self.personInfomationType == SDIMMyselfType){
        [self.rootTopView setNavTitle:LocalString(@"我")];
    }else if(self.personInfomationType == SDIMOtherPersonType){
        [self.rootTopView setNavTitle:@"个人信息"];
    }
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    if(self.canPopViewController){
        [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    }
    
    _tableView = [[UITableView alloc] init];
    if(self.personInfomationType == SDIMOtherPersonType){
        _tableView.frame = CGRectMake( 0,navHigh, Screen_Width, Screen_Height - navHigh);
    }else{
        if(self.canPopViewController){
            _tableView.frame = CGRectMake( 0,navHigh, Screen_Width, Screen_Height - navHigh);
        }else{
            _tableView.frame = CGRectMake( 0,navHigh, Screen_Width, Screen_Height - navHigh - kTabbarViewHeight);
        }
    }
    
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = SDCellHeight;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    self.tableView.bounces = NO;
    self.personalTableViewBackView.frame = self.tableView.frame;
    _tableView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:VAL_USERNAME AndTextColor:nil];
    [self.view bringSubviewToFront:self.tableView];
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    _tableView.tableFooterView = footerView;
}
- (void)saveToAddressBook{
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    CNContactViewController *vc = [CNContactViewController viewControllerForContact:contact];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
#pragma mark --保存到通讯录
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    [newPersonView dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    [picker dismissViewControllerAnimated:YES completion:nil];

    CNMutableContact *mutablecontact = [contact mutableCopy];
    // 请求授权
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功!");
            //手机号
            if (mutablecontact.phoneNumbers.count > 0) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:mutablecontact.phoneNumbers];
                CNLabeledValue *telValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:self.userModel.telephone ? : @""]];
                [array addObject:telValue];
                mutablecontact.phoneNumbers = [array mutableCopy];//手机号
            } else {
                CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:self.userModel.telephone ? : @""]];
                mutablecontact.phoneNumbers = @[labelValue];//手机号
            }
            //邮箱
            if (mutablecontact.emailAddresses.count > 0) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:mutablecontact.emailAddresses];
                CNLabeledValue *emailValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.userModel.email ? : @""];
                [array addObject:emailValue];
                mutablecontact.emailAddresses = [array mutableCopy];//eamil
            } else {
                CNLabeledValue *emailValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.userModel.email ? : @""];
                mutablecontact.emailAddresses = @[emailValue];
            }
            mutablecontact.organizationName = @"idgcapital";
            CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:mutablecontact];
            contactController.delegate = self ;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
            [self presentViewController:nav animated:YES completion:^{
                NSLog(@"presentViewController");
            }];
        } else {
            NSLog(@"授权失败,error:%@",error);
        }
    }];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{//选择某个联系人的某个属性,调用
    
}

- (void)saveExistContact:(CNContact *)con{
    CNMutableContact *contact = [con mutableCopy];
    // 请求授权
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功!");
           //手机号
            if (con.phoneNumbers.count > 0) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:con.phoneNumbers];
                CNLabeledValue *telValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:self.userModel.telephone ? : @""]];
                [array addObject:telValue];
                contact.phoneNumbers = [array mutableCopy];//手机号
            } else {
                CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:self.userModel.telephone ? : @""]];
                contact.phoneNumbers = @[labelValue];//手机号
            }
            //email
            if (con.emailAddresses.count > 0) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:con.emailAddresses];
                CNLabeledValue *emailValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.userModel.email ? : @""];
                [array addObject:emailValue];
                contact.emailAddresses = [array mutableCopy];//eamil
                
            } else {
                CNLabeledValue *emailValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:self.userModel.email ? : @""];
                contact.emailAddresses = @[emailValue];
            }
            //公司
            contact.organizationName = @"idgcapital";
          
        } else {
            NSLog(@"授权失败,error:%@",error);
        }
    }];
    
}
#pragma mark --
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpsexSelectView
{
    _sexUp = NO;
    if(_sexSelectView){
        [_sexSelectView removeFromSuperview];
        _sexSelectView = nil;
    }
    _sexSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 178)];
    [_sexSelectView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_sexSelectView];
    UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 28)];
    btnView.backgroundColor = kColorWithRGB(9, 54, 30);
    [_sexSelectView addSubview:btnView];
    UIButton* cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(8, 0, 46, 28);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(sexSelectCancleClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cancleBtn];
    
    UIButton* confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(Screen_Width - 54, 0, 46, 28);
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(sexSelectConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:confirm];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 28, Screen_Width, 150)];
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    [_sexSelectView addSubview:_pickerView];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerData = @[ @"男", @"女" ];
}

#pragma mark--选择性别
- (void)sexSelectCancleClick:(id)sender
{
    _sexUp = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = _sexSelectView.frame;
                         frame.origin.y = Screen_Height;
                         _sexSelectView.frame = frame;
                         
                     }];
}

- (void)sexSelectConfirmClick:(id)sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString* selected = [self.pickerData objectAtIndex:row];
    NSNumber* sex;
    if ([selected isEqualToString:@"男"]) {
        sex = [NSNumber numberWithInteger:1];
    }
    else if ([selected isEqualToString:@"女"]) {
        sex = [NSNumber numberWithInteger:2];
    }
    [self requestDataFromNetWorkWithUrlString:[NSString stringWithFormat:@"%@sysuser/update", urlPrefix] withparameter:@"sex" withValue:[NSString stringWithFormat:@"%zd",[sex integerValue]]];
    _sexUp = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect frame = _sexSelectView.frame;
                         frame.origin.y = Screen_Height;
                         _sexSelectView.frame = frame;
                     }];
}

#pragma mark--网络请求
- (void)requestDataFromNetWorkWithUrlString:(NSString*)urlString withparameter:(NSString*)str withValue:(NSString*)value
{
    [self showHudInView:self.view hint:@"更改中..."];
    NSDictionary* dic = @{str : value};
    [HttpTool postWithPath:urlString params:dic success:^(id JSON) {
        [self hideHud];
        if ([JSON[@"status"] intValue] == 200) {
            BOOL success = [[SDDataBaseHelper shareDB]updateUserSex:[[AppDelegate getUserID] integerValue] withSex:value];
            [[CXLoaclDataManager sharedInstance]updateSexWithSex:value AndIMAccount:VAL_HXACCOUNT];
            [[NSUserDefaults standardUserDefaults] setValue:value forKey:kSex];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(success){
                TTAlert(@"修改成功");
                self.userModel.sex = [value isEqualToString:@"1"] ? @1 : @2;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                TTAlert(@"保存本地不成功，请刷新通讯录");
            }
        }
        else {
            TTAlert(JSON[@"msg"]);
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        TTAlert(@"您的网络不太稳定哦");
    }];
}

- (void)setCellWithLeftLabelName:(NSString *)leftLabelName RightLabelName:(NSString *)rightLabelName AndCell:(UITableViewCell *)cell AndImageName:(NSString *)imageName AndCanEdit:(BOOL)canEdit AndAddBottomLineView:(BOOL)addBottomLineView
{
    if(addBottomLineView){
        UIView * bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = RGBACOLOR(242, 242, 242, 1.0);
        bottomLineView.frame = CGRectMake(0, SDMeCellHeight - 1, Screen_Width, 1);
        [cell.contentView addSubview:bottomLineView];
    }
    
    UILabel * leftLabel = [[UILabel alloc] init];
    leftLabel.text = leftLabelName;
    leftLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    leftLabel.textColor = [UIColor blackColor];
    leftLabel.backgroundColor = [UIColor clearColor];
    [leftLabel sizeToFit];
    leftLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDMeCellHeight - SDMainMessageFont)/2, leftLabel.size.width, SDMainMessageFont);
    [cell.contentView addSubview:leftLabel];
    
    UILabel * rightLabel = [[UILabel alloc] init];
    rightLabel.text = rightLabelName;
    rightLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    rightLabel.textColor = RGBACOLOR(132.0, 142.0, 153.0, 1.0);
    rightLabel.backgroundColor = [UIColor clearColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    if(self.personInfomationType == SDIMMyselfType && canEdit){
        UIImageView * leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:imageName];
        leftImageView.highlightedImage = [UIImage imageNamed:imageName];
        leftImageView.frame = CGRectMake(kImageLeftSpace, (SDMeCellHeight - kImageWidth)/2, kImageWidth, kImageWidth);
        [cell.contentView addSubview:leftImageView];
        
        leftLabel.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame) + kImageRightSpace, (SDMeCellHeight - SDMainMessageFont)/2, leftLabel.size.width, SDMainMessageFont);
        
        rightLabel.frame = CGRectMake(CGRectGetMaxX(leftLabel.frame) + kImageRightSpace, 0, Screen_Width - 20 - SDHeadImageViewLeftSpacing - (CGRectGetMaxX(leftLabel.frame) + kImageRightSpace), SDMeCellHeight);
    }else if(self.personInfomationType == SDIMOtherPersonType || !canEdit){
        UIImageView * leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:imageName];
        leftImageView.highlightedImage = [UIImage imageNamed:imageName];
        leftImageView.frame = CGRectMake(kImageLeftSpace, (SDMeCellHeight - kImageWidth)/2, kImageWidth, kImageWidth);
        [cell.contentView addSubview:leftImageView];
        
        leftLabel.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame) + kImageRightSpace, (SDMeCellHeight - SDMainMessageFont)/2, leftLabel.size.width, SDMainMessageFont);
        
        rightLabel.frame = CGRectMake(CGRectGetMaxX(leftLabel.frame) + kImageRightSpace, 0, Screen_Width - SDHeadImageViewLeftSpacing - (CGRectGetMaxX(leftLabel.frame) + kImageRightSpace), SDMeCellHeight);
    }
    [cell.contentView addSubview:rightLabel];
}

- (void)headImageViewTap
{
    SDIMImageViewerController *vc = [[SDIMImageViewerController alloc] init];
    vc.image = _headImageView.image;
    vc.hignIcon = self.userModel.hignIcon;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark 压缩图片
- (UIImage*)compressImage:(UIImage*)compressImage
{
    const CGFloat compressRate = 1.0;
    CGFloat width = compressImage.size.width * compressRate;
    CGFloat height = compressImage.size.height * compressRate;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [compressImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)requestWithHeadImage:(UIImage *)headImage
{
    headImage = [self compressImage:headImage];
    NSData* imageData = UIImageJPEGRepresentation(headImage, 0.5);
    NSString* url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", url, kImageIconPath];
    //获取整个程序所在目录
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* imagePath = [NSString stringWithFormat:@"%@/myicon.jpg", filePath];
    
    if ([imageData writeToFile:imagePath atomically:YES])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        long fileNameNumber = [str longLongValue];
        NSString* fileName = [NSString stringWithFormat:@"%ld.jpg", fileNameNumber];
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        SDUploadFileModel *uploadFileModel = [[SDUploadFileModel alloc] init];
        uploadFileModel.fileData = data;
        uploadFileModel.fileName = fileName;
        uploadFileModel.mimeType = @"image/jpg";
        _sendAnnexDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_sendAnnexDataArray addObject:uploadFileModel];
        
        //将已有的数据取出  传给服务器删除
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSMutableString *names = [NSMutableString stringWithString:@""];
        for (SDUploadFileModel * model in self.sendAnnexDataArray)
        {
            [names appendString:model.fileName];
            [names appendString:@","];
        }
        names.length>=1?[names replaceCharactersInRange:NSMakeRange(names.length-1, 1) withString:@""]:[names appendString:@""];
        [params setValue:names forKey:@"names"];
        [self.annex removeAllObjects];
        __weak __typeof(self)weakSelf = self;
        [self showHudInView:self.view hint:nil];
        [HttpTool multipartPostFileDataWithPath:[NSString stringWithFormat:@"%@/annex/fileUpload",urlPrefix] params:params dataAry:self.sendAnnexDataArray success:^(id JSON){
            if ([JSON[@"status"] integerValue] == 200) {
                NSMutableDictionary * theParams = [[NSMutableDictionary alloc] init];
                NSLog(@"%@",JSON[@"data"]);
                [theParams setObject:JSON[@"data"][0][@"path"] forKey:@"icon"];
                
                [HttpTool postWithPath:[NSString stringWithFormat:@"%@sysuser/update", urlPrefix] params:theParams success:^(id newJSON) {
                    [self hideHud];
                    if ([newJSON[@"status"] intValue] == 200) {
                        [weakSelf hideHud];
                        SDDataBaseHelper *helper = [SDDataBaseHelper shareDB];
                        BOOL result =  [helper updateHeadIconUrl:[[AppDelegate getUserID] integerValue] withHeadIconUrl:JSON[@"data"][0][@"path"]];
                        [[NSUserDefaults standardUserDefaults] setObject:JSON[@"data"][0][@"path"] forKey:@"icon"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        self.userModel.icon = JSON[@"data"][0][@"path"];
                        [[CXLoaclDataManager sharedInstance]updateUserHeadWithIconUrl:JSON[@"data"][0][@"path"] AndIMAccount:VAL_HXACCOUNT];
                        if (result)
                        {
                            if (self.upDateIconCallBack) {
                                self.upDateIconCallBack(YES);
                            }
                            [self.view makeToast:@"修改成功" duration:2 position:@"center"];
                        }
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }
                    else {
                        [weakSelf hideHud];
                        TTAlert(newJSON[@"msg"]);
                    }
                } failure:^(NSError *error) {
                    [weakSelf hideHud];
                    TTAlert(@"您的网络不太稳定哦");
                }];
            }
            else{
                [weakSelf hideHud];
            }
        }failure:^(NSError *error){
            [weakSelf hideHud];
            TTAlert(KNetworkFailRemind);
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.personInfomationType == SDIMMyselfType){
        return 9;
    }
    return 8;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"SDIMPersonInfomationCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    
    if(self.personInfomationType == SDIMMyselfType){
        if (self.userModel == nil) {
            self.userModel = [CXIMHelper getUserByIMAccount:self.imAccount];
        }
        if(indexPath.row == 8){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
        }else{
            if(indexPath.row == 4 || indexPath.row == 9){
                cell.contentView.backgroundColor = SDBackGroudColor;
            }else{
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.backgroundColor = [UIColor clearColor];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else if(self.personInfomationType == SDIMOtherPersonType){
        if(indexPath.row == 4 || indexPath.row == 8){
            cell.contentView.backgroundColor = SDBackGroudColor;
        }else{
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    SDCompanyUserModel * mySelfUserModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
    mySelfUserModel = self.userModel;
    if(indexPath.row == 0){
        if(self.personInfomationType == SDIMMyselfType){
            UIImageView * leftImageView = [[UIImageView alloc] init];
            leftImageView.image = [UIImage imageNamed:@"icon_pic"];
            leftImageView.highlightedImage = [UIImage imageNamed:@"icon_pic"];
            leftImageView.frame = CGRectMake(kImageLeftSpace, (kHeightOfHeadCell - kImageWidth)/2, kImageWidth, kImageWidth);
            [cell.contentView addSubview:leftImageView];

            UILabel * headLabel = [[UILabel alloc] init];
            headLabel.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame) + kImageRightSpace, (kHeightOfHeadCell - SDMainMessageFont)/2 , 200, SDMainMessageFont);
            headLabel.text = @"头像";
            headLabel.textColor = [UIColor blackColor];
            headLabel.backgroundColor = [UIColor clearColor];
            headLabel.textAlignment = NSTextAlignmentLeft;
            headLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [cell.contentView addSubview:headLabel];
            
            _headImageView = [[UIImageView alloc] init];
            _headImageView.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - (kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing), SDHeadImageViewLeftSpacing, kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing, kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing);
            if([self.userModel.icon isKindOfClass:[NSNull class]] || self.userModel.icon == nil){
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            }else{
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            }
            
            [cell.contentView addSubview:_headImageView];
            
            UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            headBtn.frame = _headImageView.frame;
            [headBtn addTarget:self action:@selector(headImageViewTap) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:headBtn];
            
            UIView * bottomLineView = [[UIView alloc] init];
            bottomLineView.backgroundColor = RGBACOLOR(242, 242, 242, 1.0);
            bottomLineView.frame = CGRectMake(0, kHeightOfHeadCell - 1, Screen_Width, 1);
            [cell.contentView addSubview:bottomLineView];
        }else{
            UIImageView * leftImageView = [[UIImageView alloc] init];
            leftImageView.image = [UIImage imageNamed:@"icon_pic"];
            leftImageView.highlightedImage = [UIImage imageNamed:@"icon_pic"];
            leftImageView.frame = CGRectMake(kImageLeftSpace, (kHeightOfHeadCell - kImageWidth)/2, kImageWidth, kImageWidth);
            [cell.contentView addSubview:leftImageView];
            
            UILabel * headLabel = [[UILabel alloc] init];
            headLabel.frame = CGRectMake(CGRectGetMaxX(leftImageView.frame) + kImageRightSpace, (kHeightOfHeadCell - SDMainMessageFont)/2 , 200, SDMainMessageFont);
            headLabel.text = @"头像";
            headLabel.textColor = [UIColor blackColor];
            headLabel.backgroundColor = [UIColor clearColor];
            headLabel.textAlignment = NSTextAlignmentLeft;
            headLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
            [cell.contentView addSubview:headLabel];
            
            _headImageView = [[UIImageView alloc] init];
            _headImageView.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - (kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing), SDHeadImageViewLeftSpacing, kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing, kHeightOfHeadCell - 2*SDHeadImageViewLeftSpacing);
            if([self.userModel.icon isKindOfClass:[NSNull class]] || self.userModel.icon == nil){
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            }else{
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            }
            
            [cell.contentView addSubview:_headImageView];
            
            UIButton * headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            headBtn.frame = _headImageView.frame;
            [headBtn addTarget:self action:@selector(headImageViewTap) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:headBtn];
            
            UIView * bottomLineView = [[UIView alloc] init];
            bottomLineView.backgroundColor = RGBACOLOR(242, 242, 242, 1.0);
            bottomLineView.frame = CGRectMake(0, kHeightOfHeadCell - 1, Screen_Width, 1);
            [cell.contentView addSubview:bottomLineView];
        }
    }
    if(self.personInfomationType == SDIMMyselfType){
        if(indexPath.row == 1){
            if([self.userModel.name isKindOfClass:[NSNull class]] || self.userModel.name == nil){
                [self setCellWithLeftLabelName:@"姓名" RightLabelName:@"无" AndCell:cell AndImageName:@"icon_name" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"姓名" RightLabelName:self.userModel.name AndCell:cell AndImageName:@"icon_name" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        if(indexPath.row == 2){
            if([self.userModel.deptName isKindOfClass:[NSNull class]] || self.userModel.deptName == nil){
                [self setCellWithLeftLabelName:@"部门" RightLabelName:@"" AndCell:cell AndImageName:@"icon_department" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"部门" RightLabelName:self.userModel.deptName AndCell:cell AndImageName:@"icon_department" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 3){
            if([mySelfUserModel.job isKindOfClass:[NSNull class]] || mySelfUserModel.job == nil){
                [self setCellWithLeftLabelName:@"职位" RightLabelName:@"" AndCell:cell AndImageName:@"icon_position" AndCanEdit:NO AndAddBottomLineView:NO];
            }
            else {
                [self setCellWithLeftLabelName:@"职位" RightLabelName:self.userModel.job AndCell:cell AndImageName:@"icon_position" AndCanEdit:NO AndAddBottomLineView:NO];
            }
        }
        else if(indexPath.row == 5){
            if([mySelfUserModel.email isKindOfClass:[NSNull class]] || mySelfUserModel.email == nil){
                [self setCellWithLeftLabelName:@"邮箱" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_email" AndCanEdit:NO AndAddBottomLineView:YES];
            }
            else {
                [self setCellWithLeftLabelName:@"邮箱" RightLabelName:mySelfUserModel.email AndCell:cell AndImageName:@"icon_email" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 6){
            if([mySelfUserModel.telephone isKindOfClass:[NSNull class]] || mySelfUserModel.telephone  == nil){
                [self setCellWithLeftLabelName:@"手机" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_phone" AndCanEdit:NO AndAddBottomLineView:YES];
            }
            else {
                [self setCellWithLeftLabelName:@"手机" RightLabelName:mySelfUserModel.telephone AndCell:cell AndImageName:@"icon_phone" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 7){
            if([mySelfUserModel.phone isKindOfClass:[NSNull class]] || mySelfUserModel.phone  == nil){
                [self setCellWithLeftLabelName:@"座机" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_call" AndCanEdit:NO AndAddBottomLineView:YES];
            }
            else {
                [self setCellWithLeftLabelName:@"座机" RightLabelName:mySelfUserModel.phone AndCell:cell AndImageName:@"icon_call" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 8){
            [self setCellWithLeftLabelName:@"密码" RightLabelName:@"修改密码" AndCell:cell AndImageName:@"icon_password" AndCanEdit:YES AndAddBottomLineView:YES];
        }
    }else{
        if(indexPath.row == 1){
            if([self.userModel.name isKindOfClass:[NSNull class]] || self.userModel.name == nil){
                [self setCellWithLeftLabelName:@"姓名" RightLabelName:@"无" AndCell:cell AndImageName:@"icon_name" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"姓名" RightLabelName:self.userModel.name AndCell:cell AndImageName:@"icon_name" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 2){
            if ([self.userModel.deptName isKindOfClass:[NSNull class]] || self.userModel.deptName == nil){
                [self setCellWithLeftLabelName:@"部门" RightLabelName:@"" AndCell:cell AndImageName:@"icon_department" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"部门" RightLabelName:self.userModel.deptName AndCell:cell AndImageName:@"icon_department" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 3){
            if ([self.userModel.job isKindOfClass:[NSNull class]] || self.userModel.job == nil){
                [self setCellWithLeftLabelName:@"职位" RightLabelName:@"" AndCell:cell AndImageName:@"icon_position" AndCanEdit:NO AndAddBottomLineView:NO];
            }else{
                [self setCellWithLeftLabelName:@"职位" RightLabelName:self.userModel.job AndCell:cell AndImageName:@"icon_position" AndCanEdit:NO AndAddBottomLineView:NO];
            }
        }
        else if(indexPath.row == 5){
            if([self.userModel.email isKindOfClass:[NSNull class]] || self.userModel.email == nil){
                [self setCellWithLeftLabelName:@"邮箱" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_email" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"邮箱" RightLabelName:self.userModel.email AndCell:cell AndImageName:@"icon_email" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 6){
            if([self.userModel.telephone isKindOfClass:[NSNull class]] || self.userModel.telephone == nil){
                [self setCellWithLeftLabelName:@"手机" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_phone" AndCanEdit:NO AndAddBottomLineView:YES];
            }else{
                [self setCellWithLeftLabelName:@"手机" RightLabelName:self.userModel.telephone AndCell:cell AndImageName:@"icon_phone" AndCanEdit:NO AndAddBottomLineView:YES];
            }
        }
        else if(indexPath.row == 7){
            if([self.userModel.phone isKindOfClass:[NSNull class]] || self.userModel.phone == nil){
                [self setCellWithLeftLabelName:@"座机" RightLabelName:@"未知" AndCell:cell AndImageName:@"icon_call" AndCanEdit:NO AndAddBottomLineView:NO];
            }else{
                [self setCellWithLeftLabelName:@"座机" RightLabelName:self.userModel.phone AndCell:cell AndImageName:@"icon_call" AndCanEdit:NO AndAddBottomLineView:NO];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.personInfomationType == SDIMMyselfType){
        if(indexPath.row == 0){
            return kHeightOfHeadCell;
        }
        else if(indexPath.row == 4){
            return 10;
        }
        else{
            return SDMeCellHeight;
        }
    }else{
        if(indexPath.row == 0){
            return kHeightOfHeadCell;
        }
        else if(indexPath.row == 4 || indexPath.row == 8){
            return 10;
        }
        else{
            return SDMeCellHeight;
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.personInfomationType == SDIMMyselfType){
        //关闭性别选择
        if (_sexUp == YES) {
            _sexUp = NO;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGRect frame = _sexSelectView.frame;
                                 frame.origin.y = Screen_Height;
                                 _sexSelectView.frame = frame;
                                 
                             }];
        }
        
        if(indexPath.row == 0){
            self.standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"请选择操作方式" otherButtonTitles:@"照相", @"相册", nil];
            [self.standardIBAS setFont:[UIFont systemFontOfSize:17.f]];
            [self.standardIBAS setButtonTextColor:[UIColor blackColor]];
            [self.standardIBAS setButtonBackgroundColor:[UIColor redColor] forButtonAtIndex:3];
            [self.standardIBAS setButtonTextColor:[UIColor lightGrayColor] forButtonAtIndex:0];
            [self.standardIBAS showInView:[UIApplication sharedApplication].keyWindow];
        }
        else if(indexPath.row == 8){
            SDIMChangePasswordViewController* infoVC = [[SDIMChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:infoVC animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }else{
        if(indexPath.row == 5){
            if(self.userModel.email && [self.userModel.email length] > 0){
               [self showMailPicker];
            }else{
                 TTAlert(@"此人未录入邮箱");
            }
        }else if (indexPath.row == 6){
            CXSendMsgAndTelView *send = [[CXSendMsgAndTelView alloc]initWithFrame:(CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin))andTelPhone:self.userModel.telephone showAnimationOption:(ShowAnimationOptionBottom) disMissAnimationOption:(DisMissAnimationOptionGradient)];
            send.viewController = self;
            send.companyUser = self.userModel;
            [[UIApplication sharedApplication].keyWindow addSubview:send];
        }
    }
}

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(IBActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self takePhoto];
            }
            else {
                
                [self.view makeToast:@"模拟其中无法打开照相机,请在真机中使用" duration:2 position:@"center"];
            }
            
        } break;
        case 2: {
            //相册选取
            [self chooseImageFromLibary];
        } break;
        default:
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
    [self requestWithHeadImage:image];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 1./1.;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
}

#pragma mark 实现协议UIPickerViewDataSource方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

#pragma mark 实现协议UIPickerViewDelegate方法
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer invalidate];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).locateTimer = nil;
        [[CXIMService sharedInstance] logout];
        // 定位到企信
        RDVTabBarController* tabBarVC = [(AppDelegate*)[UIApplication sharedApplication].delegate getRDVTabBarController];
        tabBarVC.selectedIndex = 0;
        //隐藏状态栏
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        // 关闭socket
        [[SDWebSocketManager shareWebSocketManager] closeSocket];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        //退出极光
        [[NSNotificationCenter defaultCenter] postNotificationName:PMSDidLoginOutNotificationName object:nil];
    }
}

//邮件
-(void)showMailPicker {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)displayMailComposerSheet

{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
    picker.mailComposeDelegate =self;
    [picker setSubject:@"邮件"];
    NSArray *toRecipients = [NSArray arrayWithObject:self.userModel.email];
    [picker setToRecipients:toRecipients];
    NSString *emailBody =[NSString stringWithFormat:@""] ;
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
