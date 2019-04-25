//
//  SDIMConversationViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AppDelegate.h"
#import "SDConversationCell.h"
#import "SDIMChatViewController.h"
#import "SDIMConversationViewController.h"
#import "CXIMLib.h"
#import "SDMenuView.h"
#import "SDIMSearchVIewController.h"
#import "CXIMHelper.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "CXLoaclDataManager.h"
#import "HttpTool.h"
#import "CXNoticeController.h"
#import "UIView+CXCategory.h"
#import "CXIDGBackGroundViewUtil.h"
#import "CXIDGCapitalExpressListViewController.h"
#import "CXNewIDGSearchViewController.h"
#import "CXIDGCapitalExpressListModel.h"
#import "CXCompanyNoticeModel.h"
#import "CXIDGNewTZGGListViewController.h"
#import "CXYMSystemMessageViewController.h"
#import "CXYMSystemMessage.h"
#import "CXYMNewsLetter.h"
#import "CXYMNewsLetterViewController.h"
#import "NSString+CXYMCategory.h"
#import "CXGSXWListModel.h"
#import "CXGSXWListViewControlller.h"

@interface SDIMConversationViewController () <UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate, CXIMChatDelegate, CXIMGroupDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) NSMutableArray* conversations;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) SDMenuView* selectMemu;
@property (nonatomic, strong) NSArray* chatContactsArray;
@property (nonatomic, strong) UIAlertView* alertView;
@property (nonatomic, strong) NSMutableArray<CXIDGCapitalExpressListModel *> * capitalExpressListModelArray;
@property (nonatomic, strong) NSMutableArray<CXCompanyNoticeModel *> * noticeListArray;
@property (nonatomic, strong) NSMutableArray<CXYMSystemMessage *> * systemMessageListArray;
@property (nonatomic, strong) NSMutableArray<CXYMNewsLetter *> *newsLetterArray;
@property (nonatomic, strong) NSMutableArray<CXGSXWListModel *> * gsxwListModelArray;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;
//会话table列表的背景颜色
@property (nonatomic, strong) UIView * conversationTableViewBackView;

@end

@implementation SDIMConversationViewController

- (NSMutableArray<CXIDGCapitalExpressListModel *> *)capitalExpressListModelArray{
    if(!_capitalExpressListModelArray){
        _capitalExpressListModelArray = @[].mutableCopy;
    }
    return _capitalExpressListModelArray;
}

- (NSMutableArray<CXCompanyNoticeModel *> *)noticeListArray{
    if(!_noticeListArray){
        _noticeListArray = @[].mutableCopy;
    }
    return _noticeListArray;
}

- (NSMutableArray<CXYMSystemMessage *> *)systemMessageListArray{
    if(!_systemMessageListArray){
        _systemMessageListArray = @[].mutableCopy;
    }
    return _systemMessageListArray;
}

-(NSMutableArray <CXYMNewsLetter *>*)newsLetterArray{
    if(_newsLetterArray == nil){
        _newsLetterArray = [NSMutableArray array];
    }
    return _newsLetterArray;
}

- (NSMutableArray<CXGSXWListModel *> *)gsxwListModelArray{
    if(!_gsxwListModelArray){
        _gsxwListModelArray = @[].mutableCopy;
    }
    return _gsxwListModelArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = NO;
        _tableView.separatorColor = RGBACOLOR(200.0, 200.0, 200.0, 1.0);
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)conversationTableViewBackView{
    if(!_conversationTableViewBackView){
        _conversationTableViewBackView = [[UIView alloc] init];
        _conversationTableViewBackView.frame = self.tableView.frame;
        _conversationTableViewBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_conversationTableViewBackView];
    }
    return _conversationTableViewBackView;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self reloadGZHAndTZGGMsg];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isSelectMenuSelected = NO;
    [[CXIMService sharedInstance].chatManager addDelegate:self];
    [[CXIMService sharedInstance].groupManager addDelegate:self];
    
    [self setupView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    // 红点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

#pragma mark -- 这里要队列请求所有的类型——消息推送列表,公众号,通知公告,系统消息,公司新闻
- (void)reloadGZHAndTZGGMsg{
    dispatch_queue_t conversionQueue = dispatch_queue_create("conversionQueue",DISPATCH_QUEUE_SERIAL);
    dispatch_async(conversionQueue, ^{
            [self loadCapitalExpressData];
    });
    dispatch_async(conversionQueue, ^{
            [self loadNoticeData];
    });
    dispatch_async(conversionQueue, ^{
            [self loadNewsLetterData];

    });
    dispatch_async(conversionQueue, ^{
            [self loadSystemMessageData];
    });
//    dispatch_async(conversionQueue, ^{
//            [self loadGSXWListData];
//    });
}

#pragma mark -- 获取公众号数据
- (void)loadCapitalExpressData{
    NSString *url = [NSString stringWithFormat:@"%@wx/bulletin/list/1", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSArray<CXIDGCapitalExpressListModel *> *data = [NSArray yy_modelArrayWithClass:[CXIDGCapitalExpressListModel class] json:JSON[@"data"]];
            [self.capitalExpressListModelArray addObjectsFromArray:data];
            [self sortDataSourceArr];
            [self loadConversations];
            [self.tableView reloadData];
        }else{
            CXAlert(JSON[@"msg"]);
            [self loadConversations];
            [self.tableView reloadData];
        }
    }
    failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self loadConversations];
        [self.tableView reloadData];
    }];
}

#pragma mark -- 获取通知公告数据
- (void)loadNoticeData{
    NSString *url = [NSString stringWithFormat:@"/comNotice/list/1.json"];
    NSMutableDictionary *params = @{}.mutableCopy;
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSArray<CXCompanyNoticeModel *> *data = [NSArray yy_modelArrayWithClass:[CXCompanyNoticeModel class] json:JSON[@"data"]];
            [self.noticeListArray addObjectsFromArray:data];
            [self sortNoticeListArray];
            [self loadConversations];
            [self.tableView reloadData];
        }else{
            CXAlert(JSON[@"msg"]);
            [self loadConversations];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self loadConversations];
        [self.tableView reloadData];
    }];
}

#pragma mark -- 获取系统消息数据
- (void)loadSystemMessageData{
    NSString *url = [NSString stringWithFormat:@"/systemMessage/list/1.json"];
    [HttpTool postWithPath:url params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if(status == 200){
            NSArray<CXYMSystemMessage *> *data = [NSArray yy_modelArrayWithClass:[CXYMSystemMessage class] json:JSON[@"data"]];
            [self.systemMessageListArray addObjectsFromArray:data];
            [self sortSystemMessageListArray];
            [self loadConversations];
            [self.tableView reloadData];
        }else{
            CXAlert(JSON[@"msg"] ? : @"状态错误");
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self loadConversations];
        [self.tableView reloadData];
    }];
}

#pragma mark -- 获取newsletter数据
- (void)loadNewsLetterData{
    
    NSString *path = [NSString stringWithFormat:@"%@news/letter/list/1.json",urlPrefix];
    NSDictionary *params = @{@"pageNumber":@(1)};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSArray<CXYMNewsLetter *> *data = [NSArray yy_modelArrayWithClass:[CXYMNewsLetter class] json:JSON[@"data"]];
            [self.newsLetterArray addObjectsFromArray:data];
            [self sortNewsLetterArray];
            [self loadConversations];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
            [self loadConversations];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self loadConversations];
        [self.tableView reloadData];
    }];
}

#pragma mark -- 获取公司新闻数据
- (void)loadGSXWListData{
    NSString *url = [NSString stringWithFormat:@"%@comNews/list/1", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSArray<CXGSXWListModel *> *data = [NSArray yy_modelArrayWithClass:[CXGSXWListModel class] json:JSON[@"data"]];
            [self.gsxwListModelArray addObjectsFromArray:data];
            [self sortGSXWDataSourceArr];
            [self loadConversations];
            [self.tableView reloadData];
        }else{
            CXAlert(JSON[@"msg"]);
            [self loadConversations];
            [self.tableView reloadData];
        }
    }
                   failure:^(NSError *error) {
                       CXAlert(KNetworkFailRemind);
                       [self loadConversations];
                       [self.tableView reloadData];
                   }];
}

#pragma newsLetter 排序
- (void)sortNewsLetterArray{
    if(self.newsLetterArray && [self.newsLetterArray count] > 0){
        NSComparator cmptr = ^(CXYMNewsLetter * model1, CXYMNewsLetter * model2){
         
            if([model1.newsDate longLongValue] > [model2.newsDate longLongValue]){
                return (NSComparisonResult)NSOrderedDescending;
            }else if([model1.newsDate longLongValue] > [model2.newsDate longLongValue]){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.newsLetterArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.newsLetterArray] sortedArrayUsingComparator:cmptr]];
        if(self.newsLetterArray && [self.newsLetterArray count]> 0){
            NSLog(@"newsDate%@",self.newsLetterArray.firstObject.newsDate);
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:self.newsLetterArray.lastObject.newsDate forKey:@"CX_NEWSLETTER_Push_Time"];
            [ud synchronize];
        }
    }
}

- (void)sortDataSourceArr
{
    if(self.capitalExpressListModelArray && [self.capitalExpressListModelArray count] > 0){
        NSComparator cmptr = ^(CXIDGCapitalExpressListModel * model1, CXIDGCapitalExpressListModel * model2){
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] > [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] < [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.capitalExpressListModelArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.capitalExpressListModelArray] sortedArrayUsingComparator:cmptr]];
        if(self.capitalExpressListModelArray && [self.capitalExpressListModelArray count]> 0){
            NSString * timeStamp = [NSString stringWithFormat:@"%ld",[self timeSwitchTimestamp:self.capitalExpressListModelArray.lastObject.createTime]];
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:timeStamp forKey:@"IM_PUSH_ZBKB_Time"];
            [ud synchronize];
        }
    }
}

- (void)sortNoticeListArray{
    
    if(self.noticeListArray && [self.noticeListArray count] > 0){
        NSComparator cmptr = ^(CXCompanyNoticeModel * model1, CXCompanyNoticeModel * model2){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1= [dateFormatter dateFromString:model1.createTime];
            NSDate *date2= [dateFormatter dateFromString:model2.createTime];
            if (date1 == [date1 earlierDate: date2]) { //
                return NSOrderedDescending;//降序
            }else if (date1 == [date1 laterDate: date2]) {
                return NSOrderedAscending;//升序
            }else{
                return NSOrderedSame;//相等
            }
        };
        
        self.noticeListArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.noticeListArray] sortedArrayUsingComparator:cmptr]];
        if(self.noticeListArray && [self.noticeListArray count]> 0){
            NSLog(@"createTime==%@",self.noticeListArray.firstObject.createTime);
            NSString * timeStamp = [NSString stringWithFormat:@"%ld",[self timeSwitchTimestamp:self.noticeListArray.firstObject.createTime]];
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:timeStamp forKey:@"IM_PUSH_GT_Time"];
            [ud synchronize];
        }
    }
}

//系统消息
- (void)sortSystemMessageListArray{
    if(self.systemMessageListArray && [self.systemMessageListArray count] > 0){
        NSComparator cmptr = ^(CXYMSystemMessage * model1, CXYMSystemMessage * model2){
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] > [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] < [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.systemMessageListArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.systemMessageListArray] sortedArrayUsingComparator:cmptr]];
        if(self.systemMessageListArray && [self.systemMessageListArray count]> 0){
            NSString * timeStamp = [NSString stringWithFormat:@"%ld",[self timeSwitchTimestamp:self.systemMessageListArray.lastObject.createTime]];
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:timeStamp forKey:@"CX_SYSTEM_Push_Time"];
            [ud synchronize];
        }
    }
}

- (void)sortGSXWDataSourceArr
{
    if(self.gsxwListModelArray && [self.gsxwListModelArray count] > 0){
        NSComparator cmptr = ^(CXGSXWListModel * model1, CXGSXWListModel * model2){
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] > [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] < [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.gsxwListModelArray = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.gsxwListModelArray] sortedArrayUsingComparator:cmptr]];
        if(self.gsxwListModelArray && [self.gsxwListModelArray count]> 0){
            NSString * timeStamp = [NSString stringWithFormat:@"%ld",[self timeSwitchTimestamp:self.gsxwListModelArray.lastObject.createTime]];
            NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:timeStamp forKey:@"IM_PUSH_GSXW_Time"];
            [ud synchronize];
        }
    }
}

#pragma mark - 将某个时间转化成时间戳
- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* date = [formatter dateFromString:formatTime];
    NSInteger timeSp = [[NSNumber numberWithDouble:([date timeIntervalSince1970] * 1000)] integerValue];
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

- (NSString *)getTimeStringWithCreateTime:(NSString *)createTime{
    NSArray * strArray1 = [createTime componentsSeparatedByString:@" "];
    NSArray * strArray2 = [strArray1[0] componentsSeparatedByString:@"-"];
    NSArray * strArray3 = [strArray1[1] componentsSeparatedByString:@":"];
    NSString * timeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",strArray2[0],strArray2[1],strArray2[2],strArray3[0],strArray3[1],strArray3[2]];
    return timeStr;
}

- (void)receivePushNotification:(NSNotification *)noti {
    [self reloadGZHAndTZGGMsg];
}

#pragma mark - 内部方法
- (void)loadConversations
{
    NSArray* arr = [[CXIMService sharedInstance].chatManager loadConversations];
    NSMutableArray * allConversationsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(CXIMConversation * conversation in arr){
        if(!conversation.isVoiceConference){
            [allConversationsArray addObject:conversation];
        }
    }
    NSInteger unread = 0;
    if (VAL_IS_AnnualTem) {
        for (CXIMConversation * conversation in allConversationsArray) {
            unread += conversation.unreadNumber;
        }
    } else {
        for (CXIMConversation * conversation in allConversationsArray) {
            unread += conversation.unreadNumber;
        }
        NSInteger I_ChatCount = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_GSXW,IM_PUSH_NEWSLETTER,nil];
        unread += I_ChatCount;
        NSInteger sysUnreadCount = 0;
        
        sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];
        unread = unread + sysUnreadCount;
    }
    NSString * bage = unread > 0 ? @(unread).stringValue : nil;
    RDVTabBarController *vc = [AppDelegate get_RDVTabBarController];
    [vc.tabBar.items[1] setBadgeValue:bage];
    //tab1的未读数量
    
    self.conversations = [allConversationsArray mutableCopy];
    
    //添加四条假的会话到会话列表，分别是：通知公告，公众号，系统消息,newsletter，需要根据LastMessage.sendTime重新排序
    NSNumber * longLongAgoStamp;
    CXIMConversation * tzgg = [[CXIMConversation alloc] init];
    tzgg.ID = 100000000000;
    tzgg.chatter = @"通知公告";
    tzgg.type = CXIMProtocolTypeSingleChat;
    NSInteger tzggcount = [self.view countNumBadge:IM_PUSH_GT,nil];///<通知公告
    tzgg.unreadNumber = tzggcount;
    CXIMTextMessageBody * tzggBody = [CXIMTextMessageBody bodyWithTextContent:self.noticeListArray && [self.noticeListArray count] > 0?self.noticeListArray[0].title:@""];
    CXIMMessage * tzggLastMessage = [[CXIMMessage alloc] initWithChatter:@"点击通知公告" body:tzggBody];
    tzggLastMessage.sendTime = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] length] > 0)?@([[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] longLongValue]):longLongAgoStamp;
    tzgg.latestMessage = tzggLastMessage;
    tzgg.isVoiceConference = NO;
    if (!VAL_IS_AnnualTem) {
        [self.conversations addObject:tzgg];
    }
    
    CXIMConversation * gzh = [[CXIMConversation alloc] init];
    gzh.ID = 100000000001;
    gzh.chatter = @"公众号";
    gzh.type = CXIMProtocolTypeSingleChat;
    NSInteger gzhcount = [self.view countNumBadge:IM_PUSH_ZBKB,nil];
    gzh.unreadNumber = gzhcount;
    CXIMTextMessageBody * gzhBody = [CXIMTextMessageBody bodyWithTextContent:self.capitalExpressListModelArray && [self.capitalExpressListModelArray count] > 0?self.capitalExpressListModelArray.lastObject.title:@""];
    CXIMMessage * gzhLastMessage = [[CXIMMessage alloc] initWithChatter:@"公众号" body:gzhBody];
    gzhLastMessage.sendTime = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] length] > 0)?@([[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] longLongValue]):longLongAgoStamp;
    gzh.latestMessage = gzhLastMessage;
    gzh.isVoiceConference = NO;
    if (!VAL_IS_AnnualTem) {
        [self.conversations addObject:gzh];
    }
    
    //系统消息
    CXIMConversation * systemMessage = [[CXIMConversation alloc] init];
    systemMessage.ID = 100000000003;
    systemMessage.chatter = @"系统消息";
    systemMessage.type = CXIMProtocolTypeSingleChat;
    systemMessage.unreadNumber = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1
    CXIMTextMessageBody * systemMessageBody = [CXIMTextMessageBody bodyWithTextContent:self.systemMessageListArray && [self.systemMessageListArray count] > 0?self.systemMessageListArray.lastObject.title:@""];
    CXIMMessage * systemMessageLastMessage = [[CXIMMessage alloc] initWithChatter:@"系统消息" body:systemMessageBody];
    systemMessageLastMessage.sendTime = ([[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] length] > 0)?@([[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] longLongValue]):longLongAgoStamp;
    systemMessage.latestMessage = systemMessageLastMessage;
    systemMessage.isVoiceConference = NO;
    if (!VAL_IS_AnnualTem) {
        [self.conversations addObject:systemMessage];
    }
    
    //newsletter,所有的类型对应的key都是大写全拼,NEWSLETTER
    CXIMConversation * newsletter = [[CXIMConversation alloc] init];
    newsletter.ID = 100000000004;
    newsletter.chatter = @"Newsletter";
    newsletter.type = CXIMProtocolTypeSingleChat;
    newsletter.unreadNumber = [self.view countNumBadge:IM_PUSH_NEWSLETTER,nil];
    CXIMTextMessageBody * newsletterBody = [CXIMTextMessageBody bodyWithTextContent:self.newsLetterArray && [self.newsLetterArray count] > 0?self.newsLetterArray.lastObject.docName:@""];
    CXIMMessage * newsletterLastMessage = [[CXIMMessage alloc] initWithChatter:@"Newsletter" body:newsletterBody];
    newsletterLastMessage.sendTime = ([[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] length] > 0)?@([[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] longLongValue]):longLongAgoStamp;
    newsletter.latestMessage = newsletterLastMessage;
    newsletter.isVoiceConference = NO;
    if (!VAL_IS_AnnualTem) {
        [self.conversations addObject:newsletter];
    }
    
//    CXIMConversation * gsxw = [[CXIMConversation alloc] init];
//    gsxw.ID = 100000000005;
//    gsxw.chatter = @"公司新闻";
//    gsxw.type = CXIMProtocolTypeSingleChat;
//    NSInteger gsxwcount = [self.view countNumBadge:IM_PUSH_GSXW,nil];
//    gsxw.unreadNumber = gsxwcount;
//    CXIMTextMessageBody * gsxwBody = [CXIMTextMessageBody bodyWithTextContent:self.gsxwListModelArray && [self.gsxwListModelArray count] > 0?self.gsxwListModelArray.lastObject.title:@""];
//    CXIMMessage * gsxwLastMessage = [[CXIMMessage alloc] initWithChatter:@"公司新闻" body:gsxwBody];
//    gsxwLastMessage.sendTime = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] length] > 0)?@([[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] longLongValue]):longLongAgoStamp;
//    gsxw.latestMessage = gsxwLastMessage;
//    gsxw.isVoiceConference = NO;
//    if (!VAL_IS_AnnualTem) {
//        [self.conversations addObject:gsxw];
//    }
    
    //大排序
    [self.conversations sortUsingComparator:^NSComparisonResult(CXIMConversation *obj1, CXIMConversation *obj2) {
        if (obj1.latestMessage && obj2.latestMessage) {
            return obj1.latestMessage.sendTime.longLongValue > obj2.latestMessage.sendTime.longLongValue ? NSOrderedAscending : NSOrderedDescending;
        }
        return NSOrderedDescending;
    }];
    
    if(self.conversations.count*SDCellHeight < Screen_Height - navHigh - TabBar_Height){
        self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, self.conversations.count*SDCellHeight);
        self.tableView.bounces = NO;
    }else{
        self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - TabBar_Height);
        self.tableView.bounces = YES;
    }
    self.tableView.contentSize = CGSizeMake(Screen_Width, self.conversations.count*SDCellHeight);
    self.conversationTableViewBackView.frame = self.tableView.frame;
    self.tableView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:VAL_USERNAME AndTextColor:nil];
    [self.view bringSubviewToFront:self.tableView];
}

- (void)tapGestureEvent:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![self.selectMemu pointInside:[self.selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)setupView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"I-Chat")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
    [self.rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"navbar-search"] addTarget:self action:@selector((searchBtnClick))];
    
    self.tableView.hidden = NO;
}

- (void)searchBtnClick{
    CXNewIDGSearchViewController * searchVIewController = [[CXNewIDGSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVIewController animated:YES];
}

- (void)selectMenuViewDisappear
{
    self.isSelectMenuSelected = NO;
    [self.selectMemu removeFromSuperview];
    self.selectMemu = nil;
}

- (void)sendMsgBtnEvent:(UIButton*)sender
{
    if (!self.isSelectMenuSelected) {
        self.isSelectMenuSelected = YES;
        NSArray* dataArray = @[ @"发起群聊"];
        NSArray* imageArray = @[ @"addGroupMessage"];
        self.selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        self.selectMemu.delegate = self;
        [self.view addSubview:self.selectMemu];
        [self.view bringSubviewToFront:self.selectMemu];
    }
    else {
        [self selectMenuViewDisappear];
    }
}

#pragma mark - CXIMServiceDelegate
- (void)CXIMService:(CXIMService*)service didReceiveChatMessage:(CXIMMessage*)message
{
    [self loadConversations];
    [self.tableView reloadData];
}

-(void)CXIMService:(CXIMService *)service didSendMessageSuccess:(CXIMMessage *)message
{
    [self loadConversations];
    [self.tableView reloadData];
}

-(void)CXIMService:(CXIMService *)service didReceiveMediaCallMessage:(CXIMMessage *)message
{
    [self loadConversations];
    [self.tableView reloadData];
}

-(void)CXIMService:(CXIMService *)service didReceiveMediaCallResponse:(NSDictionary *)response
{
    [self loadConversations];
    [self.tableView reloadData];
}

-(void)CXIMService:(CXIMService *)service didSelfExitGroupWithGroupId:(NSString *)groupId time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

-(void)CXIMService:(CXIMService *)service didSelfDismissGroupWithGroupId:(NSString *)groupId dismissTime:(NSNumber *)dismissTime
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didAddedIntoGroup:(NSString *)groupName groupId:(NSString *)groupId inviter:(NSString *)inviter time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didMembers:(NSArray<NSString *> *)members removedFromGroup:(NSString *)groupName groupId:(NSString *)groupId byOwner:(NSString *)owner time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didRemovedFromGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didChangedGroupName:(NSString *)groupName groupId:(NSString *)groupId byOwner:(NSString *)owner time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didSelfInviteMembers:(NSArray<NSString *> *)members intoGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

- (void)CXIMService:(CXIMService *)service didSomeone:(NSString *)inviter inviteMembers:(NSArray<NSString *> *)members intoGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time
{
    [self loadConversations];
    [self.tableView reloadData];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController * selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray * selectContactUserArr){
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray* hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];
                
                SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                NSString* name = [CXIMHelper getRealNameByAccount:hxAccount[0]];
                chat.chatterDisplayName = name;
                chat.isGroupChat = NO;
                [weakSelf.navigationController pushViewController:chat animated:YES];
            }
            else {
                //群聊
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];
                
                self.alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                self.alertView.tag = 10088;
                self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [self.alertView show];
            }
            
        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* ID = @"SDConversationCell";
    SDConversationCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SDConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.conversation = self.conversations[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    CXIMConversation * conversation;
    conversation = self.conversations[indexPath.row];
    
    if([conversation.chatter isEqualToString:@"通知公告"]){
        return NO;
    }else if([conversation.chatter isEqualToString:@"公众号"]){
        return NO;
    }else if([conversation.chatter isEqualToString:@"内刊"]){
        return NO;
    }else if([conversation.chatter isEqualToString:@"系统消息"]){
        return NO;
    }else if([conversation.chatter isEqualToString:@"Newsletter"]){
        return NO;
    }else if([conversation.chatter isEqualToString:@"公司新闻"]){
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXIMConversation * conversation;
    conversation = self.conversations[indexPath.row];
    if ([conversation.chatter isEqualToString:@"系统消息"]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_SystemMessage);
        CXYMSystemMessageViewController *systemMessageViewController = [[CXYMSystemMessageViewController alloc] init];
        [self.navigationController pushViewController:systemMessageViewController animated:YES];
    }else if ([conversation.chatter isEqualToString:@"Newsletter"]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_NEWSLETTER);
        CXYMNewsLetterViewController *newsLetterViewController = [[CXYMNewsLetterViewController alloc] init];
        [self.navigationController pushViewController:newsLetterViewController animated:YES];
    }else if([conversation.chatter isEqualToString:@"通知公告"]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_GT);
        CXIDGNewTZGGListViewController *vc = [[CXIDGNewTZGGListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([conversation.chatter isEqualToString:@"公众号"]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_ZBKB);
        CXIDGCapitalExpressListViewController *vc = [[CXIDGCapitalExpressListViewController alloc] init];
        vc.title = @"公众号";
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([conversation.chatter isEqualToString:@"公司新闻"]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_GSXW);
        CXGSXWListViewControlller *vc = [[CXGSXWListViewControlller alloc] init];
        vc.title = @"公司新闻";
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        SDIMChatViewController* chatViewController = [[SDIMChatViewController alloc] init];
        chatViewController.chatter = conversation.chatter;
        if (conversation.type == CXIMMessageTypeGroupChat) {
            chatViewController.chatterDisplayName = [[CXIMService sharedInstance].groupManager loadGroupForId:conversation.chatter].groupName;
        }
        else {
            chatViewController.chatterDisplayName = [CXIMHelper getRealNameByAccount:conversation.chatter];
        }
        chatViewController.isGroupChat = conversation.type;
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CXIMConversation * conversation;
        conversation = self.conversations[indexPath.row];
        
        [[CXIMService sharedInstance].chatManager removeConversationForId:@(conversation.ID).stringValue];
        [self loadConversations];
        [self.tableView reloadData];
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

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (self.isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField* textField = [self.alertView textFieldAtIndex:0];
        NSString* groupName = trim(textField.text);
        if (groupName.length <= 0) {
            TTAlert(@"群组名称不能为空");
            return;
        }
        if([self.chatContactsArray count] > 49){
            [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
            return;
        }
        NSMutableArray* hxAccount = [[self.chatContactsArray valueForKey:@"hxAccount"] mutableCopy];
        
        if (hxAccount.count) {
            NSMutableArray* members = [NSMutableArray array];
            [hxAccount enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL* stop) {
                [members addObject:obj];
            }];
            [self showHudInView:self.view hint:@"正在创建群组"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].groupManager erpCreateGroupWithName:groupName type:CXGroupTypeNormal owner:[[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:VAL_HXACCOUNT] members:[[CXLoaclDataManager sharedInstance]  getGroupUsersFromLocalContactsDicWithIMAccountArray:members] completion:^(CXGroupInfo *group, NSError *error) {
                [weakSelf hideHud];
                if (!error) {
                    SDIMChatViewController* chat = [[SDIMChatViewController alloc] init];
                    chat.chatter = group.groupId;
                    chat.chatterDisplayName = groupName;
                    chat.isGroupChat = YES;
                    [weakSelf.navigationController pushViewController:chat animated:YES];
                }
                else {
                    TTAlert(@"创建失败");
                }
                
            }];
        }
    }
    else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)dealloc
{
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [[CXIMService sharedInstance].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
