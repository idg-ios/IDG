//
//  CXIDGMessageListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGMessageListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGConferenceInformationListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "UIView+CXCategory.h"
#import "CXIDGMessageListTableViewCell.h"
#import "CXIDGConferenceInformationDetailViewController.h"
#import "CXIDGMessageListModel.h"
#import "CXVacationApplicationModel.h"
#import "CXVacationApplicationEditViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXIDGMessageListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXIDGMessageListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXIDGMessageListViewController

#pragma mark - get & set
- (NSMutableArray<CXIDGMessageListModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = RGBACOLOR(235.0, 235.0, 235.0, 1.0);
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}
#pragma mark - instance function
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    if(self.type == RSType){
        [rootTopView setNavTitle:@"消息"];
    }else if(self.type == WDLCType){
        [rootTopView setNavTitle:@"流程消息"];
    }
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}
#pragma mark -- setUpTableView
- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(navHigh);
    }];
    __weak typeof(self) weakSelf = self;
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.pageNumber ++;
        [weakSelf getListWithPage:weakSelf.pageNumber];
    }];
    
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.pageNumber = 1;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTableView];
    [self getListWithPage:self.pageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.type == RSType){//人事
        CXVacationApplicationEditViewController *vc = [[CXVacationApplicationEditViewController alloc] init];
        vc.formType = CXFormTypeApproval;
//        vc.formType = CXFormTypeDetail;
        CXIDGMessageListModel *model = self.dataSourceArr[indexPath.section];
        CXVacationApplicationModel *vacationApplicationModel = [[CXVacationApplicationModel alloc] init];
        vacationApplicationModel.approveId = [model.contentModel.approveId integerValue];
        if (vacationApplicationModel.approveId ==  0) {
            return;//处理详情不能被点击
            vacationApplicationModel.approveId = [model.contentModel.applyId integerValue];
        }
        vc.vacationApplicationModel = vacationApplicationModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
    return YES;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CXIDGMessageListModel *model = self.dataSourceArr[indexPath.section];
        [self deleteMessageWithEid:model.eid];
        NSString *url = [NSString stringWithFormat:@"%@push/message/remove", urlPrefix];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:model.eid forKey:@"eid"];
        
        [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
        [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
            [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

            if ([JSON[@"status"] intValue] == 200) {
                [self.dataSourceArr removeObjectAtIndex:indexPath.section];
                [self.listTableView reloadData];
            } else {
                CXAlert(JSON[@"msg"]);
            }
        }failure:^(NSError *error) {
            [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

            CXAlert(KNetworkFailRemind);
        }];
    }
}
//侧滑删除
-(void)deleteMessageWithEid:(NSNumber *)eid{
    
}
#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0){
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = RGBACOLOR(242.0, 241.0, 249.0, 1.0);
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXIDGMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXIDGMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.type = self.type;
    CXIDGMessageListModel *model = self.dataSourceArr[indexPath.section];
    [cell setCXIDGMessageListModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXIDGMessageListModel *model = self.dataSourceArr[indexPath.section];
    return [CXIDGMessageListTableViewCell getCXIDGMessageListTableViewCellHeightWithCXIDGMessageListModel:model];
}
#pragma mark <---请求列表--->
- (void)getListWithPage:(NSInteger)page {
    NSString *url;
    if(self.type == RSType){
        url = [NSString stringWithFormat:@"%@push/message/holiday/list/%ld", urlPrefix, (long) self.pageNumber];
    }else if(self.type == WDLCType){
        url = [NSString stringWithFormat:@"%@push/message/progress/list/%ld", urlPrefix, (long) self.pageNumber];
    }
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.footer setHidden:!hasNextPage];
            NSArray<CXIDGMessageListModel *> *data = [NSArray yy_modelArrayWithClass:[CXIDGMessageListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            for(NSInteger i = 0;i<[self.dataSourceArr count];i++){
                CXIDGMessageListModel * model = self.dataSourceArr[i];
                model.contentModel = [CXIDGMessageListContentModel yy_modelWithJSON:model.content];
                self.dataSourceArr[i] = model;
            }
            [self.listTableView reloadData];
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

@end
