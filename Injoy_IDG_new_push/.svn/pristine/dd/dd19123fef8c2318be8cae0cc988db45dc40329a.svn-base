//
//  CXMailListController.m
//  InjoyYJ1
//
//  Created by admin on 17/7/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMailListController.h"
#import "CXMailCell.h"
#import "CXMailEditController.h"

#import "STMCOPOPSession.h"
#import "STMCOIMAPSession.h"
#import "SDMailAccountSettingController.h"
#import "CXMailDetailController.h"

@interface CXMailListController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
// 列表图片名称数组
@property(nonatomic, strong) NSMutableDictionary *imageDict;
// 列表标题名称数组
@property(nonatomic, strong) NSMutableArray *funcNameArray;
// 列表副标题名称数组
@property(nonatomic, strong) NSArray *funcEnNameArray;
// 主表格
@property(nonatomic, strong) UITableView *theTableView;
// 表格数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 邮箱
@property (nonatomic, strong) NSString *emailAccount;
@property (nonatomic, strong) NSString *emailPassword;
@property (nonatomic, strong) NSString *emailReceiveProtocol;
@property (nonatomic, strong) NSString *emailProtocolType;
// 是否已读
@property (nonatomic, strong) NSMutableArray* isReadArray;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation CXMailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupTableView];
    
    // 判断设置帐号了没有
    [self isHaveAccount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RefreshSDMailRemindViewController:)
                                                 name:@"refreshMailList"
                                               object:nil];
}
- (void)setupUI {
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"邮件管理"];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(customLeftBtnClick)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add"] addTarget:self action:@selector(onAddTap)];
}
- (void)setupTableView {
    if (nil == _isReadArray) {
        _isReadArray = [NSMutableArray array];
    }
    if (self.dataSource == nil){
        self.dataSource = [NSMutableArray array];
    }
    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh)];
        _mainView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainView];
    }
    if (self.theTableView == nil) {
        self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        self.theTableView.delegate = self;
        self.theTableView.dataSource = self;
        self.theTableView.rowHeight = KCXCellTwoHeight;
        self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainView addSubview:self.theTableView];
    }
}

- (void)RefreshSDMailRemindViewController:(id)sender
{
    if ([self.emailProtocolType isEqualToString:@"pop"]) {
        [[STMCOPOPSession getSessionInstanct] clearSesstionInstance];
    }
    else {
        [[STMCOIMAPSession getSessionInstanct] clearSesstionInstance];
    }
    [self setupEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)customLeftBtnClick
{
    if ([self.emailProtocolType isEqualToString:@"pop"]) {
        [[STMCOPOPSession getSessionInstanct] clearSesstionInstance];
    }
    else {
        [[STMCOIMAPSession getSessionInstanct] clearSesstionInstance];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// 判断邮箱设置帐号与否
- (void)isHaveAccount
{
    NSString* userID = [AppDelegate getUserID];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data", kMailFilePath, userID];
    NSData* unarchiverData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unarchiverData];
    NSString* emailAccount = [unarchiver decodeObjectForKey:KMailAccount];
    [unarchiver finishDecoding];
    
    if (emailAccount != nil) {
        [self setupEmail];
    }
    else {
        /// 邮箱账号设置
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置邮箱账号,马上去设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)setupEmail
{
    /// 反归档
    NSString *userID = [AppDelegate getUserID];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@emailArchiver.data",kMailFilePath,userID];
    NSData *unarchiverData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:unarchiverData];
    _emailAccount = [unarchiver decodeObjectForKey:KMailAccount];
    _emailPassword = [unarchiver decodeObjectForKey:KMailPassword];
    _emailReceiveProtocol = [unarchiver decodeObjectForKey:kMailReceiveProtocol];
    [unarchiver finishDecoding];
    
    [self loadIsRead];
    
    NSRange range = [_emailReceiveProtocol rangeOfString:@"."];
    NSString *string = [_emailReceiveProtocol substringToIndex:range.location];
    
    NSLog(@"邮件列表－－－－－－－－－－－－－－－－－");
    //NSLog(@"账号：%@",_emailAccount);
    //NSLog(@"密码：%@",_emailPassword);
    //NSLog(@"收件服务器地址：%@",_emailReceiveProtocol);
    
    [self showHudInView:self.mainView hint:@"正在加载数据"];
    if ([string isEqualToString:@"pop"] || [string isEqualToString:@"pop3"] ||  [string isEqualToString:@"POP"] ||  [string isEqualToString:@"POP3"]  ||  [string isEqualToString:@"pop-mail"])
    {
        _emailProtocolType = @"pop";
        /// POP协议
        [[STMCOPOPSession getSessionInstanct] loadAccountWithUsername:_emailAccount password:_emailPassword hostname:_emailReceiveProtocol port:995 loadUserResultBlock:^(BOOL isSuccess) {
            if (isSuccess)
            {
                /// 读取邮件头
                [self popLoadEmailHeaderData];
            } else {
                [self hideHudWithView:_mainView];
                TTAlertNoTitle(@"邮箱服务器繁忙,请稍候再试");
            }
        }];
    }
    else if ([string isEqualToString:@"imap"] || [string isEqualToString:@"IMAP"] ||[string isEqualToString:@"imap4"] || [string isEqualToString:@"IMAP4"])
    {
        _emailProtocolType = @"imap";
        /// IMAP协议
        [[STMCOIMAPSession getSessionInstanct] loadAccountWithUsername:_emailAccount password:_emailPassword hostname:_emailReceiveProtocol port:993 oauth2Token:nil loadUserResultBlock:^(BOOL isSuccess) {
            if (isSuccess)
            {
                /// 读取邮件头
                [self imapLoadEmailHeaderData];
            } else {
                [self hideHudWithView:_mainView];
                TTAlertNoTitle(@"邮箱服务器繁忙,请稍候再试");
            }
        }];
    }
}
///// pop协议加载邮箱数据
- (void)popLoadEmailHeaderData
{
    [[STMCOPOPSession getSessionInstanct] loadLastNMessagesWithEmailHeaderDataBlock:^(NSArray *messageList)
     {
         if([messageList count] > 0 &&[[messageList firstObject]isKindOfClass:[NSString class]] && [[messageList firstObject] isEqualToString:@"没有头部"]){
             [self hideHudWithView:_mainView];
             [self.view makeToast:@"暂无数据" duration:1.0 position:@"center"];
         }
         else if (messageList.count > 0)
         {
             [_dataSource removeAllObjects];
             /// 解析
             NSInteger myI = 0;
             for (MCOPOPMessageInfo *messageInfo in messageList)
             {
                 myI++;
                 
                 /// 根据index获取邮件头
                 MCOPOPFetchHeaderOperation * op = [[STMCOPOPSession getSessionInstanct] fetchHeaderOperationWithIndex:messageInfo.index];
                 [op start:^(NSError * error, MCOMessageHeader * header)
                  {
                      
                      NSString *name = [header extraHeaderValueForName:@"Content-Type"];
                      NSDate *date = header.date;
                      NSString *title = header.subject;
                      int messageUid = messageInfo.index;
                      NSString *from = header.from.nonEncodedRFC822String;
                      
                      // 是否有附件
                      BOOL flg;
                      if ([name hasPrefix:@"multipart/mixed"] || [name hasPrefix:@"multipart/related"]) flg = 1;
                      else flg = 0;
                      
                      NSMutableDictionary *emailDic = [NSMutableDictionary dictionary];
                      [emailDic setValue:@(messageUid) forKey:@"emailMessageUid"];
                      [emailDic setValue:title forKey:@"emailTitle"];
                      [emailDic setValue:from forKey:@"emailFrom"];
                      [emailDic setValue:[NSString getLocalDateFormateUTCDate:date] forKey:@"emailDate"];
                      [emailDic setValue:@(flg) forKey:@"emailAttachment"];
                      [_dataSource addObject:emailDic];
                      
                      if (myI == messageList.count) {
                          [self hideHudWithView:_mainView];
                          [self.theTableView reloadData];
                      }
                  }];
             }
         }
         else {
             [self hideHudWithView:_mainView];
             [self.view makeToast:@"暂无数据" duration:1.0 position:@"center"];
         }
     }];
}
///// imap协议加载邮箱数据
- (void)imapLoadEmailHeaderData
{
    [[STMCOIMAPSession getSessionInstanct] loadLastNMessages:kMailNumber andEmailHeaderDataBlock:^(NSArray *messageList)
     {
         if (messageList.count > 0)
         {
             [_dataSource removeAllObjects];
             /// 解析
             NSInteger myI = 0;
             for (MCOIMAPMessage *message in messageList) {
                 myI++;
                 
                 NSString *title = message.header.subject;//主题
                 int messageUid = message.uid;
                 NSDate *date = message.header.date;
                 NSString *from = message.header.from.nonEncodedRFC822String;
                 BOOL flg = message.attachments.count > 0?1:0;//附件
                 
                 NSMutableDictionary *emailDic = [NSMutableDictionary dictionary];
                 [emailDic setValue:@(messageUid) forKey:@"emailMessageUid"];
                 [emailDic setValue:title forKey:@"emailTitle"];
                 [emailDic setValue:from forKey:@"emailFrom"];
                 [emailDic setValue:[NSString getLocalDateFormateUTCDate:date] forKey:@"emailDate"];
                 [emailDic setValue:@(flg) forKey:@"emailAttachment"];
                 [_dataSource addObject:emailDic];
                 
                 if (myI == messageList.count) {
                     [self hideHudWithView:_mainView];
                     [self.theTableView reloadData];
                 }
             }
         } else {
             [self hideHudWithView:_mainView];
             [self.view makeToast:@"暂无数据" duration:1.0 position:@"center"];
         }
     }];
}
///// 判断邮件是否已读
- (void)loadIsRead
{
    // 判断文件夹存不存在
    NSString *isReadfilePath = [NSString stringWithFormat:@"%@/%@emailIsRead.data",kMailFilePath,_emailAccount];
    NSData *unarchiverData = [[NSFileManager defaultManager] contentsAtPath:isReadfilePath];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:unarchiverData];
    NSMutableArray *isReadArray = [unarchiver decodeObjectForKey:@"isRead"];
    if (isReadArray != nil) {
        _isReadArray = isReadArray;
    }
    [unarchiver finishDecoding];
}
///// 归档
- (void)setArchiver
{
    // 判断文件夹存不存在
    if (![[NSFileManager defaultManager]fileExistsAtPath:kMailFilePath]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:kMailFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@emailIsRead.data",kMailFilePath,_emailAccount];
    NSLog(@"归档邮件已读状态路径：%@",filePath);
    NSMutableData *archiverData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:archiverData];
    [archiver encodeObject:_isReadArray forKey:@"isRead"];
    [archiver finishEncoding];
    [archiverData writeToFile:filePath atomically:NO];
}

#pragma mark - Event
///// 发邮件
- (void)onAddTap {
    CXMailEditController* detailVC = [[CXMailEditController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CXMailCell *cell = [[CXMailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];
    cell.firstLabel.text = [NSString substring:dict[@"emailTitle"] ToIndex:11];
    cell.secondLabel.text = [dict[@"emailDate"] componentsSeparatedByString:@" "][0];
    cell.thirdLabel.text = [NSString substring:dict[@"emailFrom"] ToIndex:15];
    //cell.fourthLabel.text = @"部门等";
    
    if ([_isReadArray indexOfObject:[dict valueForKey:@"emailTitle"]] != NSNotFound && _isReadArray != nil) {
        [cell.iconImageView setImage:[UIImage imageNamed:@"mail_read"]];
    } else {
        [cell.iconImageView setImage:[UIImage imageNamed:@"mail_unread"]];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    // 将邮件ID存储
    NSString *eId = [dic valueForKey:@"emailTitle"];
    [_isReadArray addObject:eId];
    
    CXMailDetailController* detailVC = [[CXMailDetailController alloc] init];
    detailVC.messageInfoIndex = [dic valueForKey:@"emailMessageUid"];
    detailVC.mailSubject = [dic valueForKey:@"emailTitle"];
    detailVC.messageProtocolType = _emailProtocolType;
    detailVC.operateSuccessReturnBlock = ^{
        // 归档阅读状态
        [self setArchiver];
        [self.theTableView reloadData];
    };
    
    [self.navigationController pushViewController:detailVC animated:NO];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        SDMailAccountSettingController* mailVC = [[SDMailAccountSettingController alloc] init];
        [self presentViewController:mailVC animated:YES completion:nil];
    }
}

@end
