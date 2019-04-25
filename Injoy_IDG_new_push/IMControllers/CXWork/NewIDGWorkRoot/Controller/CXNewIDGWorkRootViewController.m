//
//  CXNewIDGWorkRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/23.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewIDGWorkRootViewController.h"
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
#import "CXItemManagementListViewController.h"
#import "CXNewWDCLRootViewController.h"
#import "CXReimbursementListViewController.h"
#import "CXNewListWDCLRootViewController.h"
#import "CXNewListHRRootViewController.h"
#import "CXNewYGZNRootViewController.h"
#import "CXNewListWDSPRootViewController.h"
#import "CXIDGSmallBusinessAssistantViewController.h"
#import "CXIDGAnnualLuckyDrawViewController.h"

#import "SingaporeTabBarViewController.h"


@interface CXNewIDGWorkRootViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

//导航条
@property(nonatomic, strong) SDRootTopView *rootTopView;
@property(nonatomic, strong) NSMutableArray *imageArrM;
@property(nonatomic, strong) NSArray *arr1;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CXNewIDGWorkRootViewController

#define headPicHeight (IS_iPhoneX?(Screen_Width*554.0/750.0):(Screen_Width*475.0/750.0))
#define kItemLeftSpace (Screen_Width - 240)/4.0
#define kItemTopSpace 20.0
#define kCollectionViewTopSpace IS_iPhoneX?55.0:14.0


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        if([CXIMService sharedInstance].socketManager.state == CXIMSocketState_OPEN){
            NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/has/approve", urlPrefix];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] intValue] == 200) {
                    [[NSUserDefaults standardUserDefaults] setBool:[JSON[@"data"] boolValue] forKey:HAS_RIGHT_XJPS];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    // 创建瀑布流对象,设置cell的尺寸和位置
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    // 设置滚动的方向
                    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
                    // 设置cell的尺寸
                    layout.itemSize = CGSizeMake(80, 80);
                    // 设置cell之间的间距
                    layout.minimumInteritemSpacing = kItemLeftSpace;
                    // 设置行距
                    layout.minimumLineSpacing = kItemTopSpace;
                    
                    layout.sectionInset = UIEdgeInsetsMake(0, kItemLeftSpace, 0, kItemLeftSpace);
                    layout.headerReferenceSize = CGSizeMake(Screen_Width, kCollectionViewTopSpace);
                    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headPicHeight, Screen_Width, Screen_Height - kTabbarViewHeight - (headPicHeight)) collectionViewLayout:layout];
                    _collectionView.delegate = self;
                    _collectionView.dataSource = self;
                    _collectionView.backgroundColor = [UIColor whiteColor];
                    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
                    _collectionView.showsVerticalScrollIndicator = NO;
                    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
                    _collectionView.bounces = NO;
                    
                    if (VAL_IS_AnnualTem && !VAL_ISSHOW_ANNUALMEETING) {//临时人员,没有开启年会权限
                        self.imageArrM = [NSMutableArray array];
                        self.arr1 = @[];
                        self.dataArr = [NSMutableArray array];
                    }else
                        
                        if(VAL_IS_AnnualTem){
                            //如果是年会临时人员
                            self.imageArrM = [NSMutableArray arrayWithObjects:
                                              [NSMutableArray arrayWithObjects:@"annual meeting_icon", nil], nil];
                            self.arr1 = [NSArray arrayWithObjects:@"年会", nil];
                            self.dataArr = [NSMutableArray arrayWithObjects:_arr1, nil].mutableCopy;
                        }else if(!VAL_HAS_RIGHT_XJPS && !VAL_HAS_RIGHT_QJPS && !VAL_HAS_RIGHT_BXPS && !VAL_HAS_RIGHT_CCPS && !VAL_ISSHOW_ANNUALMEETING){
                            //不是临时人员,我的审批没有,如果未开启年会权限
                            self.imageArrM = [NSMutableArray arrayWithObjects:
                                              [NSMutableArray arrayWithObjects:@"icon_iceforce",@"icon_yhap", @"icon_clyd",@"icon_wdbx", @"icon_ydhr", @"icon_fpxx", @"icon_ygzn", nil], nil];
                            self.arr1 = [NSArray arrayWithObjects:@"ICEFORCE",@"月会安排", @"我的差旅",@"我的报销", @"移动HR", @"发票信息" ,@"员工指南", nil];
                            self.dataArr = [NSMutableArray arrayWithObjects:_arr1, nil].mutableCopy;
                        }else if(!VAL_HAS_RIGHT_XJPS && !VAL_HAS_RIGHT_QJPS && !VAL_HAS_RIGHT_BXPS && !VAL_HAS_RIGHT_CCPS && VAL_ISSHOW_ANNUALMEETING){
                            //不是临时人员,我的审批没有,如果开启年会权限
                            self.imageArrM = [NSMutableArray arrayWithObjects:
                                              [NSMutableArray arrayWithObjects:@"icon_iceforce",@"icon_yhap", @"icon_clyd",@"icon_wdbx", @"icon_ydhr", @"icon_fpxx", @"icon_ygzn",@"annual meeting_icon", nil], nil];
                            self.arr1 = [NSArray arrayWithObjects:@"ICEFORCE",@"月会安排", @"我的差旅",@"我的报销", @"移动HR", @"发票信息" ,@"员工指南", @"年会", nil];
                            self.dataArr = [NSMutableArray arrayWithObjects:_arr1, nil].mutableCopy;
                        }
                        else{
                            //有我的审批
                            if(!VAL_ISSHOW_ANNUALMEETING){
                                //如果未开启年会权限
                                self.imageArrM = [NSMutableArray arrayWithObjects:
                                                  [NSMutableArray arrayWithObjects:@"icon_iceforce",@"icon_yhap", @"icon_clyd",@"icon_wdbx", @"icon_ydhr", @"icon_fpxx", @"icon_ygzn",@"icon_wdsp", nil], nil];
                                self.arr1 = [NSArray arrayWithObjects:@"ICEFORCE",@"月会安排", @"我的差旅",@"我的报销", @"移动HR", @"发票信息" ,@"员工指南", @"我的审批", nil];
                                self.dataArr = [NSMutableArray arrayWithObjects:_arr1, nil].mutableCopy;
                            }else{
                                //如果开启年会权限
                                self.imageArrM = [NSMutableArray arrayWithObjects:
                                                  [NSMutableArray arrayWithObjects:@"icon_iceforce",@"icon_yhap", @"icon_clyd",@"icon_wdbx", @"icon_ydhr", @"icon_fpxx", @"icon_ygzn",@"icon_wdsp",@"annual meeting_icon", nil], nil];
                                self.arr1 = [NSArray arrayWithObjects:@"ICEFORCE",@"月会安排", @"我的差旅",@"我的报销", @"移动HR", @"发票信息" ,@"员工指南", @"我的审批",@"年会", nil];
                                self.dataArr = [NSMutableArray arrayWithObjects:_arr1, nil].mutableCopy;
                            }
                        }
                    [self.view addSubview:_collectionView];
                } else {
                    CXAlert(JSON[@"msg"]);
                }
            }failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
        }
    }
    return _collectionView;
}

- (void)dealloc {
    //移除消息通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:kReceivePushNotificationKey object:nil];//工作台收到推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:UserLoginSuccessNotification object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:KNOTIFICATION_LOGINCHANGE object:nil];//5452bug,解决切换账号时数量不更新
    // 导航栏
    self.rootTopView = [self getRootTopView];
    self.rootTopView.backgroundColor = [UIColor clearColor];
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, headPicHeight)];
    if(IS_iPhoneX){
        [pic setImage:Image(@"iphoneX_pic_bg")];
    }else{
        [pic setImage:Image(@"pic_bg")];
    }
    [self.view addSubview:pic];
    [self.view bringSubviewToFront:self.rootTopView];
    
    [self getSumNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self getSumNumber];
    [self.collectionView reloadData];
    
}

- (void)reloadView{
    [self getSumNumber];
}

- (void)receivePushNotification:(NSNotificationCenter *)notificationCenter{
    [self getSumNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [cellButton setImage:Image(@"annual meeting_icon") forState:UIControlStateNormal];
    }else{
        [cellButton setImage:Image(self.imageArrM[indexPath.section][indexPath.row]) forState:UIControlStateNormal];
    }
    
    [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    cellButton.userInteractionEnabled = NO;
    [cellButton setImagePosition:2 spacing:IS_iPhoneX?10:5];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:cellButton];
    

    if (VAL_PUSHES_MSGS(IM_PUSH_DM) && (indexPath.section == 0 && indexPath.row == 1)) {
        VAL_AddNumBadge(IM_PUSH_DM, nil);
    }
    
    if (VAL_PUSHES_MSGS(IM_PUSH_CLSP) && (indexPath.section == 0 && indexPath.row == 2)) {
        VAL_AddNumBadge(IM_PUSH_CLSP, nil);
    }

    if ((VAL_PUSHES_MSGS(IM_PUSH_QJ) || VAL_PUSHES_MSGS(IM_PUSH_PUSH_HOLIDAY) || VAL_PUSHES_MSGS(IM_PUSH_PROGRESS) ||
         VAL_PUSHES_MSGS(IM_PUSH_XIAO)) && (indexPath.section == 0 && indexPath.row == 4)) {
        VAL_AddNumBadge(IM_PUSH_QJ,IM_PUSH_PUSH_HOLIDAY,IM_PUSH_PROGRESS,IM_PUSH_XIAO, nil);
    }

    if (indexPath.section == 0 && indexPath.row == 7) {//我的审批
        NSInteger sum = [self getMyApprove];
        if (sum != 0) {
             [cell.contentView getNumBadge:sum];
        }
    }
    
    return cell;
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataArr[indexPath.section][indexPath.row];
    if ([@"ICEFORCE" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXItemManagementListViewController *vc = [[CXItemManagementListViewController alloc] init];
        vc.title = title;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
       
        
    }else if ([@"月会安排" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_DM);//推送
//        CXDailyMeetingViewController *vc = [[CXDailyMeetingViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        SingaporeTabBarViewController *base = [[SingaporeTabBarViewController alloc]init];
        base.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:base animated:YES];
        
        
    }else if ([@"我的差旅" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXNewListWDCLRootViewController *vc = [CXNewListWDCLRootViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"我的报销" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXReimbursementListViewController *vc = [[CXReimbursementListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"移动HR" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXNewListHRRootViewController *vc = [CXNewListHRRootViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"发票信息" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXIDGSmallBusinessAssistantViewController *smallBusinessAssistantViewController = [[CXIDGSmallBusinessAssistantViewController alloc] init];
        [self.navigationController pushViewController:smallBusinessAssistantViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"员工指南" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXNewYGZNRootViewController *vc = [CXNewYGZNRootViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if ([@"我的审批" isEqualToString:self.dataArr[indexPath.section][indexPath.row]]) {
        CXNewListWDSPRootViewController *vc = [CXNewListWDSPRootViewController new];
        [self.navigationController pushViewController:vc animated:YES];
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
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - 我的审批数量
-(NSInteger)getMyApprove{
    
    NSInteger trave = [[NSUserDefaults standardUserDefaults] integerForKey:CX_trave];
    NSInteger holiday = [[NSUserDefaults standardUserDefaults] integerForKey:CX_holiday];
    NSInteger resumption = [[NSUserDefaults standardUserDefaults] integerForKey:CX_resumption];
    NSInteger cost = [[NSUserDefaults standardUserDefaults] integerForKey:CX_cost];
    
    NSInteger sum = trave+holiday+resumption+cost;
    return sum;
}

#pragma mark - 获取我的审批总数量,这里改变了
-(void)getSumNumber{
//    [self  loadTXLData];
    if([CXIMService sharedInstance].socketManager.state == CXIMSocketState_OPEN){
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_group_async(group, queue, ^{
            [self getTraveService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getHolidayService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getResumptionService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getCostService:semaphore];
            
        });
       
        dispatch_group_notify(group, queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
    }
}

#pragma 获取出差数量
-(void)getTraveService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/trave",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_trave];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_semaphore_signal(semaphore);
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取请假数量
-(void)getHolidayService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/holiday",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_holiday];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取销假数量
-(void)getResumptionService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/resumption",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_resumption];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取报销数量
-(void)getCostService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/cost",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_cost];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadTXLData{
    
        NSString *url = [NSString stringWithFormat:@"%@/sysuser/new/list", urlPrefix];
        
        [HttpTool getWithPath:url params:nil success:^(id JSON) {
            NSNumber *status = JSON[@"status"];
            if ([status intValue] == 200) {
                
                [[CXLoaclDataManager sharedInstance].allDicContactsArray removeAllObjects];
                
                NSArray * allContactsArray = JSON[@"data"][@"allContacts"];
                for(NSDictionary * depDataDic in allContactsArray){
                    [[CXLoaclDataManager sharedInstance].depArray addObject:depDataDic.allKeys[0]];
                    NSArray * depDataArray = depDataDic.allValues[0];
                    //用来保存每一组的userModelArray
                    NSMutableArray * depUsersArray = @[].mutableCopy;
                    for(NSDictionary * contactDic in depDataArray){
                        NSMutableDictionary * mutableDic = contactDic.mutableCopy;
                        if([mutableDic[@"icon"] isKindOfClass:[NSNull class]]){
                            mutableDic[@"icon"] = @"";
                        }
                        [[CXLoaclDataManager sharedInstance].allDicContactsArray addObject:mutableDic];
                        
                        SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:contactDic];
                        userModel.userId = @([contactDic[@"userId"] integerValue]);
                        [depUsersArray addObject:userModel];
                    }
                    NSMutableDictionary * userDic = [NSMutableDictionary dictionary];
                    [userDic setValue:depUsersArray forKey:depDataDic.allKeys[0]];
                    [[CXLoaclDataManager sharedInstance].allDepDataArray addObject:userDic];
                   
                }
            }else{
            }
        } failure:^(NSError *error) {
        }];
}

@end