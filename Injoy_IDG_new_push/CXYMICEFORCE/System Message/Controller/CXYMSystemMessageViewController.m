//
//  CXYMSystemMessageViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/24.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMSystemMessageViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "CXYMAppearanceManager.h"
#import "CXYMSystemMessage.h"
#import "CXYMSystemMessageCell.h"
#import "HttpTool.h"
#import "CXYMSystemMessageDetailViewController.h"
#import "CXBorrowingSubmissionViewController.h"
#import "CXVacationApplicationListViewController.h"
#import "CXWorkLogEditViewController.h"
#import "CXProjectCollaborationListViewController.h"
#import "CXXSTMeetingListViewController.h"
#import "CXNoticeController.h"
#import "CXDailyMeetingViewController.h"
#import "CXBussinessTripListViewController.h"
#import "CXInternalBulletinListViewController.h"

#import "CXVacationApplicationEditViewController.h"
#import "CXXJSPListViewController.h"
#import "CXBussinessTripListModel.h"
#import "CXBussinessTripEditViewController.h"
#import "CXLeaveApplicationEditViewController.h"
#import "CXCompanyNoticeModel.h"
#import "CXVacationApplicationModel.h"
#import "CXNoticeDetailViewController.h"
#import "CXIDGDailyMeetingDetailViewController.h"
#import "CXIDGCapitalExpressDetailViewController.h"
#import "CXIDGCapitalExpressListViewController.h"
#import "CXXJSPListApprovalAlertView.h"


@interface CXYMSystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<CXYMSystemMessage *> *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNumber;
@end

static NSString *const systemMessageCellIdentity = @"systemMessageCellIdentity";
@implementation CXYMSystemMessageViewController

#pragma mark-- setter&getter
- (NSMutableArray <CXYMSystemMessage *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            _tableView.estimatedRowHeight = 200;
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }else{
            _tableView.rowHeight = 200;
        }
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMSystemMessageCell class] forCellReuseIdentifier:systemMessageCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        _tableView.separatorColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return _tableView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清空系统消息
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:nil forKey:@"CX_SYSTEM_Push_Time"];
    [ud setObject:nil forKey:@"Receive_SYSTEM_Push_Message"];
    [ud synchronize];
    //新版,清空系统消息
    [ud setObject:nil forKey:IM_SystemMessage];
    [ud synchronize];
}
#pragma mark-- viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.RootTopView setNavTitle:@"系统消息"];
    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self setupTableView];
    self.pageNumber = 1;
    [self loadData];
}
- (void)setupTableView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.bottom.right.mas_equalTo(0);
    }];
}
- (void)reloadData{
    [self.dataArray removeAllObjects];
    self.pageNumber = 1;
    [self loadData];
}
- (void)loadMoreData{
    self.pageNumber ++;
    [self loadData];
}
-(void)endRefre{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}
- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"systemMessage/list/%ld",self.pageNumber];
    NSDictionary *params = @{@"pageNumber":@(self.pageNumber)};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray <CXYMSystemMessage *> *array =[NSArray yy_modelArrayWithClass:[CXYMSystemMessage class] json:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self endRefre];
            [self.tableView reloadData];
        }else if (status == 400){
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        } else {
            [self endRefre];
            self.pageNumber --;
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self endRefre];
        self.pageNumber --;
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
    
}
#pragma mark-- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    if(self.dataArray.count == 0 || self.dataArray == nil) return 0;
    CXYMSystemMessage *message = self.dataArray[indexPath.row];
    CGSize strSize = [message.content boundingRectWithSize:CGSizeMake(Screen_Width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if ([message.content containsString:@"完成"]) {
        return 40 + strSize.height + [CXYMAppearanceManager appStyleMargin] * 5;
    } else {
        return 40 + strSize.height + [CXYMAppearanceManager appStyleMargin] * 5 + 30 + 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:systemMessageCellIdentity forIndexPath:indexPath];
    if(self.dataArray.count == 0 || self.dataArray == nil) return cell;
    cell.message = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark -- 处理业务逻辑
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMSystemMessage *message = self.dataArray[indexPath.row];
    if(self.dataArray.count == 0 || self.dataArray == nil) return;
    if ([message.title containsString:@"完成"]) return;
    
    NSInteger type = [message.btype integerValue];
    if(type == 14){//销假申请
        CXXJSPListViewController *vc = [[CXXJSPListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(type == 15){//出差申请
        CXBussinessTripListModel *model = [[CXBussinessTripListModel alloc] init];
        CXBussinessTripEditViewController *vc = [[CXBussinessTripEditViewController alloc]init];
        model.businessId = [message.bid integerValue];
        vc.eid = model.businessId;
        vc.type = isApproval;
        vc.applyId = model.applyId;
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if(type == 2){//请假申请
        CXVacationApplicationEditViewController *vc = [CXVacationApplicationEditViewController new];
        vc.formType = CXEditModeDetail;
        CXVacationApplicationModel *model = [CXVacationApplicationModel new];
        model.signed_objc = -1;//-1为没有底部的按钮
        model.leaveId = [message.bid longValue];
        vc.vacationApplicationModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(type == 8){//公司通知
        CXNoticeDetailViewController *vc = [[CXNoticeDetailViewController alloc] init];
        vc.eid = [message.bid integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(type == 9){//月会安排
        CXIDGDailyMeetingDetailViewController *vc = [[CXIDGDailyMeetingDetailViewController alloc] init];
        vc.eid = [message.bid integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(type == 12){//资本快报
        CXIDGCapitalExpressDetailViewController *vc = [[CXIDGCapitalExpressDetailViewController alloc] init];
//        shareView.shareTitle = self.model.title;
//        shareView.shareContent = self.model.digest;
//        shareView.shareUrl = self.model.url;
        CXIDGCapitalExpressListModel *listModel = [[CXIDGCapitalExpressListModel alloc] init];
//        listModel.title = message.title;
//        listModel.digest = message.digest;
//        listModel.url = message.url;
        vc.model = listModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
