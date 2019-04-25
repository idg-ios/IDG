//
//  CXXSTMeetingListViewController.m
//  InjoyDDXXST
//
//  Created by wtz on 2017/12/5.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXXSTMeetingListViewController.h"
#import "Masonry.h"
#import "UIView+CXCategory.h"
#import "CXListView.h"
#import "HttpTool.h"
#import "CXSUSearchViewController.h"
#import "UIView+CXCategory.h"
#import "CXDDXVoiceMeetingListModel.h"
#import "CXSUSearchViewController.h"
#import "CXGroupSelectContactViewController.h"
#import "CXDDXVoiceMeetingDetailViewController.h"
#import "CXInputDialogView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXXSTMeetingListViewController ()<CXListViewDataSource, CXListViewDelegate>

@property(strong, nonatomic) CXListView *listView;
/** 数据源 */
@property(nonatomic, copy) NSMutableArray<CXDDXVoiceMeetingListModel *> *dataArray;
@property(nonatomic, strong) NSMutableArray<NSString *> * titleArray;
@property(nonatomic, strong) NSMutableArray<NSString *> * createTimeArray;
@property(nonatomic, strong) NSMutableArray<NSNumber *> * eidArray;
@property(nonatomic)NSInteger pageNumber;

/** 已选用户 */
@property(copy, nonatomic) NSArray *selectUserArr;

@end

@implementation CXXSTMeetingListViewController

#pragma mark - LazyLoad
- (NSMutableArray<CXDDXVoiceMeetingListModel *> *)dataArray{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSMutableArray<NSString *> *)titleArray{
    if(!_titleArray){
        _titleArray = @[].mutableCopy;
    }
    return _titleArray;
}

- (NSMutableArray<NSString *> *)createTimeArray{
    if(!_createTimeArray){
        _createTimeArray = @[].mutableCopy;
    }
    return _createTimeArray;
}

- (NSMutableArray<NSNumber *> *)eidArray{
    if(!_eidArray){
        _eidArray = @[].mutableCopy;
    }
    return _eidArray;
}

#pragma mark - CXListViewDataSource

/**
 列表视图数据行数
 
 @param listView 列表视图实例
 
 @return 返回行数
 */
- (NSInteger)numberOfRowsInListView:(CXListView *)listView; {
    return [self.dataArray count];
}

/**
 列表视图某行的各列内容
 
 @param listView 列表视图实例
 @param rowIndex 行号
 
 @return 内容数组(对应列数，支持NSString、UIImage、__kindof UIView)
 */
- (NSArray<id> *)listView:(CXListView *)listView contentsForRow:(NSInteger)rowIndex{
    
    return @[self.titleArray[rowIndex], self.createTimeArray[rowIndex], [UIImage imageNamed:@"playXSTVoiceMeeting"]];
}

#pragma mark - CXERPListViewDelegate
- (void)listView:(CXListView *)listView didSelectRowAtIndex:(NSInteger)rowIndex atColumnIndex:(int)columnIndex {
    CXDDXVoiceMeetingListModel * model = self.dataArray[rowIndex];
    //跳转到语音会议界面
    CXDDXVoiceMeetingDetailViewController *voiceMeetingDetailViewController = [[CXDDXVoiceMeetingDetailViewController alloc] initWithCXDDXVoiceMeetingListModel:model];
    [self.navigationController pushViewController:voiceMeetingDetailViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/**
 下拉刷新
 */
- (void)listView:(CXListView *)listView beginRefreshing:(void *)_
{
    [self loadDataSource];
}

/**
 上拉加载
 */
- (void)listView:(CXListView *)listView beginLoadMore:(void *)_
{
    [self loadMoreDataSource];
}

#pragma mark - Navigation
- (void)rightItemEvent {
    [self showHudInView:self.view hint:nil];
    //发起会议
    __weak typeof(self) weakSelf = self;
    CXGroupSelectContactViewController *selectColleaguesViewController = [[CXGroupSelectContactViewController alloc] init];
    selectColleaguesViewController.navTitle = @"发起会议";
    selectColleaguesViewController.filterUsersArray = @[[[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:[AppDelegate getUserHXAccount]]];
    selectColleaguesViewController.selectContactUserCallBack = ^(NSArray *selectContactUserArr) {
        weakSelf.selectUserArr = [selectContactUserArr copy];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置会议名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 1001;
        [alertView show];
    };
    [self presentViewController:selectColleaguesViewController animated:YES completion:^{
        
    }];
    [self hideHud];
}

- (void)onSearchTap {
    CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
    dialogView.onApplyWithContent = ^(NSString *content) {
        self.searchText = content;
        [self.listView beginRefreshing];
    };
    [dialogView show];
}

- (void)setUpRootView {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"语音会议"];
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(rightItemEvent)];
    [rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(onSearchTap)];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self
                                action:@selector(popBtnClick)];
}

- (void)setUpSubViews {
    self.listView = [[CXListView alloc] init];
    [self.view addSubview:self.listView];
    self.listView.backgroundColor = kTableViewBackgroundColor;
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-kTabbarSafeBottomMargin);
    }];
    
    // 设置冻结列数(不需要可以不设置)
    self.listView.frozenColumns = 0;
    // 设置各列标题
    self.listView.titles = @[@"会议议题", @"时 间", @"播放"];
    // 设置各列宽(pt)
    self.listView.widths = @[@140, @140, @140];
    // 设置数据源
    self.listView.dataSource = self;
    // 设置代理
    self.listView.delegate = self;
    self.listView.showSummaryView = NO;
    // 设置启用刷新
    self.listView.refreshComponentEnabled = YES;
    // 加载数据
    [self.listView reloadData];
}

- (void)loadDataSource{
    self.pageNumber = 1;
    NSString * url;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@(self.pageNumber) forKey:@"pageNumber"];
    if([self.searchText length] > 0){
        params[@"s_title"] = self.searchText;
    }
    if(self.fromSuperSearch){
        params[@"s_kind"] = @"super";
    }
    url = [NSString stringWithFormat:@"%@vedioMeet/list/%zd",urlPrefix,self.pageNumber];
    CXWeakSelf(self);
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            [weakself.dataArray removeAllObjects];
            [weakself.titleArray removeAllObjects];
            [weakself.createTimeArray removeAllObjects];
            [weakself.eidArray removeAllObjects];
            NSArray * dataArray = [NSArray yy_modelArrayWithClass:CXDDXVoiceMeetingListModel.class json:JSON[@"data"]];
            [weakself.dataArray addObjectsFromArray:dataArray];
            for(CXDDXVoiceMeetingListModel * model in weakself.dataArray){
                [weakself addNotNilObjectToMutableArray:weakself.titleArray WithObject:model.title AndDefault:@""];
                [weakself addNotNilObjectToMutableArray:weakself.createTimeArray WithObject:model.createTime AndDefault:@""];
                [weakself addNotNilObjectToMutableArray:weakself.eidArray WithObject:model.eid AndDefault:@(1)];
            }
            
            weakself.pageNumber = [JSON[@"page"] integerValue];
            [weakself setShareUrlWithTotal:[JSON[@"total"] integerValue]];
            weakself.pageNumber += 1;
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            if(weakself.pageNumber > pageCount){
                [weakself.listView setHasMoreData:NO];
            }else{
                [weakself.listView setHasMoreData:YES];
            }
            [weakself.listView reloadData];
            [weakself.listView headerEndRefreshing];
        }else if ([JSON[@"status"] intValue] == 400) {
            [weakself.listView headerEndRefreshing];
            [self.listView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            [weakself.listView headerEndRefreshing];
            CXAlert(JSON[@"msg"]);
        }
        [self.listView setNeedShowEmptyTipByCount:[self.dataArray count]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        [weakself.listView headerEndRefreshing];
        CXAlert(KNetworkFailRemind);
        [self.listView setNeedShowEmptyTipByCount:[self.dataArray count]];
    }];
}

- (void)loadMoreDataSource{
    NSString * url;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@(self.pageNumber) forKey:@"pageNumber"];
    if([self.searchText length] > 0){
        params[@"s_title"] = self.searchText;
    }
    if(self.fromSuperSearch){
        params[@"s_kind"] = @"super";
    }
    url = [NSString stringWithFormat:@"%@vedioMeet/list/%zd",urlPrefix,self.pageNumber];
    CXWeakSelf(self);
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSArray * dataArray = [NSArray yy_modelArrayWithClass:CXDDXVoiceMeetingListModel.class json:JSON[@"data"]];
            [weakself.dataArray addObjectsFromArray:dataArray];
            [weakself.titleArray removeAllObjects];
            [weakself.createTimeArray removeAllObjects];
            [weakself.eidArray removeAllObjects];
            for(CXDDXVoiceMeetingListModel * model in weakself.dataArray){
                [weakself addNotNilObjectToMutableArray:weakself.titleArray WithObject:model.title AndDefault:@""];
                [weakself addNotNilObjectToMutableArray:weakself.createTimeArray WithObject:model.createTime AndDefault:@""];
                [weakself addNotNilObjectToMutableArray:weakself.eidArray WithObject:model.eid AndDefault:@(1)];
            }
            
            weakself.pageNumber = [JSON[@"page"] integerValue];
            [weakself setShareUrlWithTotal:[JSON[@"total"] integerValue]];
            weakself.pageNumber += 1;
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            if(weakself.pageNumber > pageCount){
                [weakself.listView setHasMoreData:NO];
            }else{
                [weakself.listView setHasMoreData:YES];
            }
            [weakself.listView reloadData];
            [weakself.listView footerEndRefreshing];
        }else if ([JSON[@"status"] intValue] == 400) {
            [weakself.listView headerEndRefreshing];
            [self.listView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            [weakself.listView footerEndRefreshing];
            CXAlert(JSON[@"msg"]);
        }
        [self.listView setNeedShowEmptyTipByCount:[self.dataArray count]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        [weakself.listView footerEndRefreshing];
        CXAlert(KNetworkFailRemind);
        [self.listView setNeedShowEmptyTipByCount:[self.dataArray count]];
    }];
}

- (void)addNotNilObjectToMutableArray:(NSMutableArray *)array WithObject:(NSObject *)object AndDefault:(NSObject *)defaultValue
{
    [array addObject:object?object:defaultValue];
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kBackgroundColor];
    [self setUpRootView];
    [self setUpSubViews];
}

- (void)setShareUrlWithTotal:(NSInteger)totalNumber{
    NSString * shareUrl = [NSString stringWithFormat:@"%@/myCus/share/list/api/%zd/-1/%zd.htm",shareUrlPrefix,[VAL_USERID integerValue],self.pageNumber];
    [self.view setShareButtonWithTitle:@"云境商务OA-客户资料" content:@"客户关系的客户列表" url:shareUrl dataCount:totalNumber];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.listView beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        if(alertView.tag == 1001){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    } else {
        UITextField *textFd = [alertView textFieldAtIndex:0];
        if (!textFd.text.length) {
            [self.view makeToast:@"语音会议名称不能为空！" duration:2 position:@"center"];
            return;
        } else {
            if([self.selectUserArr count] > 39){
                [self.view makeToast:@"语音会议人数最多40人，请重新选择！" duration:2 position:@"center"];
                return;
            }
            [self showHudInView:self.view hint:@"正在创建语音会议"];
            __weak typeof(self) weakSelf = self;
            NSString *url = [NSString stringWithFormat:@"%@vedioMeet/save", urlPrefix];
            NSMutableDictionary *params = @{}.mutableCopy;
            if (self.selectUserArr && [self.selectUserArr count] > 0) {
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                for (SDCompanyUserModel *userModel in self.selectUserArr) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:[NSString stringWithFormat:@"%ld", (long) [userModel.eid integerValue]] forKey:@"eid"];
                    [dic setValue:userModel.name forKey:@"name"];
                    [dic setValue:userModel.imAccount forKey:@"imAccount"];
                    [dataArray addObject:dic];
                }
                NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
                [params setValue:[[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding] forKey:@"cc"];
            }
            SDCompanyUserModel *myUserModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
            [params setValue:myUserModel.userId forKey:@"ygId"];
            [params setValue:textFd.text forKey:@"title"];
            [HttpTool postWithPath:url params:params success:^(id JSON) {
                [weakSelf hideHud];
                NSDictionary *jsonDict = JSON;
                if ([jsonDict[@"status"] integerValue] == 200) {
                    //跳转到语音会议界面
                    CXDDXVoiceMeetingListModel *model = [[CXDDXVoiceMeetingListModel alloc] init];
                    model.eid = @([JSON[@"data"][@"eid"] integerValue]);
                    CXDDXVoiceMeetingDetailViewController *voiceMeetingDetailViewController = [[CXDDXVoiceMeetingDetailViewController alloc] initWithCXDDXVoiceMeetingListModel:model];
                    [self.navigationController pushViewController:voiceMeetingDetailViewController animated:YES];
                    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                    }
                }
//                else if ([JSON[@"status"] intValue] == 400) {
//                    [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//                }
                else {
                    [self.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
                }
            }              failure:^(NSError *error) {
                [weakSelf hideHud];
                [self.view makeToast:KNetworkFailRemind duration:2 position:@"center"];
            }];
        }
    }
}

- (void)popBtnClick{
    if(self.searchText && [self.searchText length] > 0){
        self.searchText = nil;
        self.pageNumber = 1;
        [self loadDataSource];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
