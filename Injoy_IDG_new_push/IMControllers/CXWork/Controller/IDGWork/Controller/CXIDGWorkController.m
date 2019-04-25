//
//  CXIDGWorkController.m
//  InjoyIDG
//
//  Created by admin on 2017/11/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGWorkController.h"
#import "CXNoticeController.h"
#import "CXDDXVoiceMeetingListViewController.h"
#import "CXDailyMeetingViewController.h"
#import "CXSuperUserListViewController.h"
#import "CXSuperRightsListViewController.h"
#import "CXSUSearchViewController.h"
#import "CXNoteCollectionListViewController.h"
#import "UIButton+LXMImagePosition.h"
#import "CXIDGSmallBusinessAssistantViewController.h"
#import "CXHrListViewController.h"
#import "CXMyApprovalListViewController.h"
#import "UIView+CXCategory.h"
#import "SDMenuView.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "CXIMHelper.h"
#import "SDIMChatViewController.h"
#import "HttpTool.h"
#import "CXMailListController.h"
#import "CXProjectListViewController.h"
#import "CXTravalController.h"
#import "CXIDGProjectManagementListViewController.h"
#import "CXIDGCapitalExpressListViewController.h"
#import "CXIDGAnnualLuckyDrawViewController.h"
#import "CXInternalBulletinListViewController.h"
#import "CXItemManagementListViewController.h"
#import "CXIDGLCSXViewController.h"

#define headPicHeight (navHigh*2+45)
@interface CXIDGWorkController ()
        <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDMenuViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

//导航条
@property(nonatomic, strong) SDRootTopView *rootTopView;
@property(nonatomic, strong) NSMutableArray *imageArrM;
@property(nonatomic, strong) NSArray *arr1;
@property(nonatomic, strong) NSArray *arr2;
@property(nonatomic, strong) NSArray *arr3;
@property(nonatomic, strong) NSArray *arr4;
@property(nonatomic, strong) NSArray *arr5;
@property(nonatomic, strong) NSArray *haderArr;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) UICollectionView *collectionView;
//选择菜单
@property(nonatomic, strong) SDMenuView *selectMemu;
@property(nonatomic, strong) NSArray *chatContactsArray;
@property(strong, nonatomic) NSMutableArray *contactUserArr;
//用来判断右上角的菜单是否显示
@property(nonatomic) BOOL isSelectMenuSelected;
@property(nonatomic, strong) UIAlertView *alertView;

@end

@implementation CXIDGWorkController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 创建瀑布流对象,设置cell的尺寸和位置
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动的方向
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        // 设置cell的尺寸
        layout.itemSize = CGSizeMake(80, 80);
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = 0.0;
        // 设置行距
        layout.minimumLineSpacing = 10.0;

        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.headerReferenceSize = CGSizeMake(Screen_Width, 35);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headPicHeight+navHigh, Screen_Width, Screen_Height - navHigh - 55 - (headPicHeight)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (void)dealloc {
    //移除消息通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];

    if(VAL_ISSHOW_ANNUALMEETING){
        self.imageArrM = [NSMutableArray arrayWithObjects:
                          //[NSMutableArray arrayWithObjects:@"work_comNotice",@"work_quickNews",@"work_news",@"work_daliyMeeting", nil],
                          [NSMutableArray arrayWithObjects:@"work_comNotice",@"work_quickNews",@"work_daliyMeeting", nil],
                          [NSMutableArray arrayWithObjects:@"work_pm",@"work_hr", @"work_traval",@"work_asisstent", @"work_approval", @"work_neikan", @"work_tool",@"NIANICON", nil],
                          [NSMutableArray arrayWithObjects:@"work_supperuser", @"work_power", @"work_paper", nil], nil];
    }else{
        self.imageArrM = [NSMutableArray arrayWithObjects:
                          //[NSMutableArray arrayWithObjects:@"work_comNotice",@"work_quickNews",@"work_news",@"work_daliyMeeting", nil],
                          [NSMutableArray arrayWithObjects:@"work_comNotice",@"work_quickNews",@"work_daliyMeeting", nil],
                          [NSMutableArray arrayWithObjects:@"work_pm",@"work_hr", @"work_traval",@"work_asisstent", @"work_approval",  @"work_neikan", @"work_tool",nil],
                          [NSMutableArray arrayWithObjects:@"work_supperuser", @"work_power", @"work_paper", nil], nil];
    }
    
    //self.arr1 = [NSArray arrayWithObjects:@"公告通知", @"资本快报",@"新闻资讯",@"会议", nil];
    self.arr1 = [NSArray arrayWithObjects:@"公告通知", @"资本快报",@"会议", nil];
    if(VAL_ISSHOW_ANNUALMEETING){
        self.arr2 = [NSArray arrayWithObjects:@"项目管理",@"人事", @"差旅",@"企业小助手", @"我的流程", @"内刊" ,@"工具", @"年会", nil];
    }else{
       self.arr2 = [NSArray arrayWithObjects:@"项目管理",@"人事", @"差旅",@"企业小助手", @"我的流程", @"内刊", @"工具", nil];
    }
    self.arr3 = [NSArray arrayWithObjects:@"超级用户", @"超级权限", @"发票信息", nil];
    if(VAL_ISSHOW_ANNUALMEETING){
        self.arr4 = [NSArray arrayWithObjects:@"年会", nil];
    }else{
        self.arr4 = @[].copy;
    }
    if (VAL_IS_AnnualTem){
        self.haderArr = [NSArray arrayWithObjects:@"   常用应用", nil];
        self.dataArr = [NSMutableArray arrayWithObjects:_arr4, nil].mutableCopy;
        self.collectionView.bounces = NO;
    }
    else if (VAL_IsSuper && VAL_SuperStatus) {
        self.haderArr = [NSArray arrayWithObjects:@"   资讯 • 公告", @"   常用应用", @"   管理员应用", nil];
        self.dataArr = [NSMutableArray arrayWithObjects:_arr1, _arr2, _arr3, nil].mutableCopy;
        self.collectionView.bounces = NO;
    } else {
        self.haderArr = [NSArray arrayWithObjects:@"   资讯 • 公告", @"   常用应用", nil];
        self.dataArr = [NSMutableArray arrayWithObjects:_arr1, _arr2, nil].mutableCopy;
        self.collectionView.bounces = NO;
    }
    
    [self setupView];
    [self.view addSubview:self.collectionView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addBXSPBadgeNumber];
    [self addZBKBBadgeNumber];
}

- (void)addBXSPBadgeNumber{
    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/has/approve", urlPrefix];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setBool:[JSON[@"data"] boolValue] forKey:HAS_RIGHT_XJPS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *url = [NSString stringWithFormat:@"%@cost/approve/list/count", urlPrefix];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_BSPS);
                    if([JSON[@"data"] integerValue] > 0){
                        NSDictionary * textMsg = @{@"报销审批推送":@"报销审批推送"};
                        NSMutableDictionary *pushes = [VAL_PUSHES mutableCopy];
                        if (!pushes) {
                            pushes = [NSMutableDictionary dictionary];
                            VAL_PUSHES_RESET(pushes);
                        }
                        NSMutableArray *textMsgs;
                        textMsgs = [VAL_PUSHES_MSGS(IM_PUSH_BSPS) mutableCopy];
                        if (!textMsgs) {
                            textMsgs = [NSMutableArray array];
                        }
                        for(NSInteger i = 0; i < [JSON[@"data"] integerValue]; i++){
                            [textMsgs addObject:textMsg];
                        }
                        pushes[IM_PUSH_BSPS] = textMsgs;
                        VAL_PUSHES_RESET(pushes);
                    }else if([JSON[@"data"] integerValue] == 0){
                        NSMutableDictionary * psh = [VAL_PUSHES mutableCopy];
                        [psh removeObjectForKey:IM_PUSH_BSPS];
                        VAL_PUSHES_RESET(psh);
                    }
                    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
                    //工作模块显示红点,新增我的销假推送
                    NSInteger count = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_CK,IM_PUSH_DM,IM_PUSH_GT,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_BSPS,IM_PUSH_PROGRESS,IM_PUSH_XIAO,IM_PUSH_CLSP/*,CX_NK_Push*/,nil];
                
                    NSInteger num = [CXPushHelper getMyApprove];
                    if (num != 0) {
                        count += num;
                    }
                    
                    [vc setReadOrUnRead:count andTypeNum:0];
                    [self.collectionView reloadData];
                } else {
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        } else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)addZBKBBadgeNumber{
    NSString * LastFiveIdsString = [NSString stringWithFormat:@"LastFiveIdsString_%@",VAL_HXACCOUNT];
    NSString * ids = [[NSUserDefaults standardUserDefaults] objectForKey:LastFiveIdsString];
    if(ids && [ids isKindOfClass:[NSString class]] && [ids length] > 0){
        NSString *url = [NSString stringWithFormat:@"%@wx/bulletin/new/count", urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:ids forKey:@"ids"];
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            if ([JSON[@"status"] intValue] == 200) {
                VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_ZBKB);
                if([JSON[@"data"] integerValue] > 0){
                    NSDictionary * textMsg = @{@"资本快报推送":@"资本快报推送"};
                    NSMutableDictionary *pushes = [VAL_PUSHES mutableCopy];
                    if (!pushes) {
                        pushes = [NSMutableDictionary dictionary];
                        VAL_PUSHES_RESET(pushes);
                    }
                    NSMutableArray *textMsgs;
                    textMsgs = [VAL_PUSHES_MSGS(IM_PUSH_ZBKB) mutableCopy];
                    if (!textMsgs) {
                        textMsgs = [NSMutableArray array];
                    }
                    for(NSInteger i = 0; i < [JSON[@"data"] integerValue]; i++){
                        [textMsgs addObject:textMsg];
                    }
                    pushes[IM_PUSH_ZBKB] = textMsgs;
                    VAL_PUSHES_RESET(pushes);
                }
                RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
                //工作模块显示红点,新增我的销假推送
                NSInteger count = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_CK,IM_PUSH_DM,IM_PUSH_QJ,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_BSPS,IM_PUSH_PROGRESS,IM_PUSH_XIAO/*,CX_NK_Push*/,nil];
                
                NSInteger num = [CXPushHelper getMyApprove];
                if (num != 0) {
                    count += num;
                }
                
                [vc setReadOrUnRead:count andTypeNum:0];
                [self.collectionView reloadData];
            } else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }else{
        NSMutableDictionary * psh = [VAL_PUSHES mutableCopy];
        [psh removeObjectForKey:IM_PUSH_ZBKB];
        VAL_PUSHES_RESET(psh);
        RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
        //工作模块显示红点,新增我的销假
        NSInteger count = [self.view countNumBadge:IM_PUSH_GT,IM_PUSH_ZBKB,IM_PUSH_CK,IM_PUSH_DM,IM_PUSH_QJ,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_BSPS,IM_PUSH_PROGRESS,IM_PUSH_XIAO,IM_PUSH_CLSP/*,CX_NK_Push*/,nil];
        
        NSInteger num = [CXPushHelper getMyApprove];
        if (num != 0) {
            count += num;
        }
        
        [vc setReadOrUnRead:count andTypeNum:0];
        [self.collectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

- (void)receivePushNotification:(NSNotification *)nsnotifi {
    [self.collectionView reloadData];
}

- (void)tapGestureEvent:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)setupView {
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"工作")];

    UILabel *navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(Screen_Width - 90, 20, 50, 50);
    [searchBtn setTitle:@"D" forState:UIControlStateNormal];
    [searchBtn setTitle:@"D" forState:UIControlStateHighlighted];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:24.0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.rootTopView addSubview:searchBtn];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, headPicHeight)];
    [pic setImage:Image(@"banner")];
    [self.view addSubview:pic];
}

- (void)searchBtnClick {
    [self selectMenuViewDisappear];
    [self showHudInView:self.view hint:@"加载中"];
    CXIDGGroupAddUsersViewController *selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
    selectColleaguesViewController.navTitle = @"发送短信";
    selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
    selectColleaguesViewController.selectContactUserCallBack = ^(NSArray *selectContactUserArr) {
        NSLog(@"发送短信给%@", selectContactUserArr);
        NSMutableString *telephoneStr = @"".mutableCopy;
        for (SDCompanyUserModel *user in selectContactUserArr) {
            if (user.telephone) {
                [telephoneStr appendFormat:@",%@", user.telephone];
            }
        }
        if (telephoneStr && [telephoneStr length] > 0) {
            NSString *moblies = [telephoneStr substringFromIndex:1];
            NSString *url = [NSString stringWithFormat:@"%@system/batchSendMessage", urlPrefix];
            NSMutableDictionary *params = @{}.mutableCopy;
            [params setValue:moblies forKey:@"moblies"];
            [HttpTool postWithPath:url params:params success:^(id JSON) {
                if ([JSON[@"status"] integerValue] == 200) {
                    TTAlert(@"发送成功");
                } else {
                    TTAlert(JSON[@"msg"]);
                }
            }              failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        } else {
            TTAlert(@"发送成功");
        }
    };
    [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
    [self hideHud];
}

- (void)selectMenuViewDisappear {
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)sendMsgBtnEvent:(UIButton *)sender {
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray *dataArray = @[@"发起群聊"];
        NSArray *imageArray = @[@"addGroupMessage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    } else {
        [self selectMenuViewDisappear];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SDMenuViewDelegate

- (void)returnCardID:(NSInteger)cardID withCardName:(NSString *)cardName {
    [self selectMenuViewDisappear];

    if (cardID == 0) {
        [self showHudInView:self.view hint:@"加载中"];
        __weak typeof(self) weakSelf = self;
        CXIDGGroupAddUsersViewController *selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
        selectColleaguesViewController.navTitle = @"发起群聊";
        selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:@[[CXIMHelper getUserByIMAccount:[AppDelegate getUserHXAccount]]]];
        selectColleaguesViewController.selectContactUserCallBack = ^(NSArray *selectContactUserArr) {
            if (selectContactUserArr.count == 1) {
                //单聊
                NSMutableArray *hxAccount = [[selectContactUserArr valueForKey:@"hxAccount"] mutableCopy];

                SDIMChatViewController *chat = [[SDIMChatViewController alloc] init];
                chat.chatter = hxAccount[0];
                NSString *name = [CXIMHelper getRealNameByAccount:hxAccount[0]];
                chat.chatterDisplayName = name;
                chat.isGroupChat = NO;
                [weakSelf.navigationController pushViewController:chat animated:YES];
            } else {
                //群聊
                weakSelf.chatContactsArray = [selectContactUserArr mutableCopy];

                _alertView = [[UIAlertView alloc] initWithTitle:@"设置群聊名称" message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _alertView.tag = 10088;
                _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [_alertView show];
            }

        };
        [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
        [self hideHud];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cellButton.frame = cell.bounds;
    [cellButton setTitle:self.dataArr[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    if (VAL_IS_AnnualTem){
        [cellButton setImage:Image(@"NIANICON") forState:UIControlStateNormal];
    }else{
        [cellButton setImage:Image(self.imageArrM[indexPath.section][indexPath.row]) forState:UIControlStateNormal];
    }
    
    [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:2 spacing:5];

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];

    if (VAL_PUSHES_MSGS(IM_PUSH_GT) && (indexPath.section == 0 && indexPath.row == 0)) {//系统消息
        VAL_AddNumBadge(IM_PUSH_GT, nil);
    }
    if (VAL_PUSHES_MSGS(IM_PUSH_ZBKB) && (indexPath.section == 0 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_ZBKB, nil);
    }

    if (VAL_PUSHES_MSGS(IM_PUSH_DM) && (indexPath.section == 0 && indexPath.row == 2)) {
        VAL_AddNumBadge(IM_PUSH_DM, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_PUSH_HOLIDAY) && (indexPath.section == 1 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_PUSH_HOLIDAY, nil);
    }
    //待办???
    if ((VAL_PUSHES_MSGS(IM_PUSH_CK) || VAL_PUSHES_MSGS(IM_PUSH_QJ) || VAL_PUSHES_MSGS(IM_PUSH_BSPS) || VAL_PUSHES_MSGS(IM_PUSH_PROGRESS) ||
         VAL_PUSHES_MSGS(IM_PUSH_XIAO) ||
         VAL_PUSHES_MSGS(IM_PUSH_CLSP2)) && (indexPath.section == 1 && indexPath.row == 4)) {
        VAL_AddNumBadge(IM_PUSH_CK,IM_PUSH_QJ,IM_PUSH_BSPS,IM_PUSH_PROGRESS,IM_PUSH_XIAO,IM_PUSH_CLSP2, nil);
    }
    /*
    if (VAL_PUSHES_MSGS(CX_NK_Push) && (indexPath.section == 1 && indexPath.row == 5)) {
        VAL_AddNumBadge(CX_NK_Push, nil);
    }*/
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc] init];
        label.frame = header.bounds;
        label.text = self.haderArr[indexPath.section];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = kColorWithRGB(247, 247, 247);
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        [header addSubview:label];
//        if (indexPath.section != 0) {
//            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, Screen_Width - 30, 0.5)];
//            lineLabel.backgroundColor = [UIColor lightGrayColor];
//            [header addSubview:lineLabel];
//        }
        return header;
    } else {
        return nil;
    }
}


//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section:%zd---row:%zd", indexPath.section, indexPath.row);

    NSString *title = self.dataArr[indexPath.section][indexPath.row];

    NSLog(@"section = %zd,row = %zd",indexPath.section,indexPath.row);
    
    if ([@"公告通知" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_GT);
        CXNoticeController *vc = [[CXNoticeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    } else if ([@"邮箱提醒" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXMailListController *emailvc = [[CXMailListController alloc] init];
        [self.navigationController pushViewController:emailvc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"年会" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXWeakSelf(self)
        NSString *url = [NSString stringWithFormat:@"%@annual/meeting/current/detail/sign", urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [HttpTool getWithPath:url params:params success:^(NSDictionary *JSON) {
            CXStrongSelf(self)
            if ([JSON[@"status"] intValue] == 200) {
                CXIDGAnnualLuckyDrawViewController *annualLuckyDrawViewController = [[CXIDGAnnualLuckyDrawViewController alloc] init];
                [self.navigationController pushViewController:annualLuckyDrawViewController animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            } else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    } else if ([@"语音会议" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
//        VAL_PUSHES_HAVEREAD_NEW(CX_YYHY_Push);
        CXDDXVoiceMeetingListViewController *voiceMeetingListViewController = [[CXDDXVoiceMeetingListViewController alloc] init];
        voiceMeetingListViewController.isSuperSearch = NO;
        [self.navigationController pushViewController:voiceMeetingListViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    } else if ([@"会议" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_DM);
        CXDailyMeetingViewController *vc = [[CXDailyMeetingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([@"项目管理" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXItemManagementListViewController *vc = [[CXItemManagementListViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"资本快报" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXIDGCapitalExpressListViewController *vc = [[CXIDGCapitalExpressListViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
        // 企业小助手
    else if ([@"企业小助手" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXIDGSmallBusinessAssistantViewController *smallBusinessAssistantViewController = [[CXIDGSmallBusinessAssistantViewController alloc] init];
        [self.navigationController pushViewController:smallBusinessAssistantViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else if ([@"超级用户" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXSuperUserListViewController *vc = [[CXSuperUserListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"超级权限" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXSuperRightsListViewController *vc = [[CXSuperRightsListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"发票信息" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXNoteCollectionListViewController *vc = [[CXNoteCollectionListViewController alloc] init];
        vc.listType = CXNoteCollectionListTypeBilling;
        vc.title = @"发票信息";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([@"人事" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXHrListViewController *vc = [CXHrListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    } else if ([@"差旅" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXTravalController *vc = [CXTravalController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    } else if ([@"我的流程" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXIDGLCSXViewController *vc = [[CXIDGLCSXViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    } else if ([@"内刊" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]||[@"工具" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]){
//        VAL_PUSHES_HAVEREAD_NEW(CX_NK_Push);
        CXInternalBulletinListViewController *vc = [[CXInternalBulletinListViewController alloc]initWithType:[@"内刊" isEqualToString:self.dataArr[indexPath.section][indexPath.row]] ? isInternalButin:isTool];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isSelectMenuSelected == YES) {
        [self selectMenuViewDisappear];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textField = [_alertView textFieldAtIndex:0];
        NSString *groupName = trim(textField.text);
        if (groupName.length <= 0) {
            TTAlert(@"群组名称不能为空");
            return;
        }
        if ([_chatContactsArray count] > 49) {
            [self.view makeToast:@"群聊人数最多50人，请重新选择！" duration:2 position:@"center"];
            return;
        }
        NSMutableArray *hxAccount = [[_chatContactsArray valueForKey:@"hxAccount"] mutableCopy];

        if (hxAccount.count) {
            NSMutableArray *members = [NSMutableArray array];
            [hxAccount enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                [members addObject:obj];
            }];
            [self showHudInView:self.view hint:@"正在创建群组"];
            __weak typeof(self) weakSelf = self;
            [[CXIMService sharedInstance].groupManager erpCreateGroupWithName:groupName type:CXGroupTypeNormal owner:[[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:VAL_HXACCOUNT] members:[[CXLoaclDataManager sharedInstance] getGroupUsersFromLocalContactsDicWithIMAccountArray:members] completion:^(CXGroupInfo *group, NSError *error) {
                [weakSelf hideHud];
                if (!error) {
                    SDIMChatViewController *chat = [[SDIMChatViewController alloc] init];
                    chat.chatter = group.groupId;
                    chat.chatterDisplayName = groupName;
                    chat.isGroupChat = YES;
                    [weakSelf.navigationController pushViewController:chat animated:YES];
                } else {
                    TTAlert(@"创建失败");
                }

            }];
        }
    } else {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

@end

