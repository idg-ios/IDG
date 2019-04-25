//
//  CXFundInvestmentListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXFundInvestmentListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGConferenceInformationListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXIDGProjectManagementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXIDGConferenceInformationListTableViewCell.h"
#import "CXIDGConferenceInformationDetailViewController.h"
#import "CXFundInvestmentListModel.h"
#import "CXIDGFundInvestmentTableViewCell.h"
#import "CXFundInvestmentListContractTableViewCell.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXFundInvestmentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXFundInvestmentListContractModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;
/** fundInvestmentListModel */
@property (nonatomic, strong) CXFundInvestmentListModel * fundInvestmentListModel;

@end

@implementation CXFundInvestmentListViewController

#pragma mark - get & set

- (CXFundInvestmentListModel *)fundInvestmentListModel{
    if(!_fundInvestmentListModel){
        _fundInvestmentListModel = [[CXFundInvestmentListModel alloc] init];
    }
    return _fundInvestmentListModel;
}

- (NSMutableArray<CXFundInvestmentListContractModel *> *)dataSourceArr {
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
        _listTableView.separatorColor = [UIColor clearColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function
- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(0);
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
    self.view.backgroundColor = SDBackGroudColor;
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
}

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0){
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = SDBackGroudColor;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section != 0){
        return 8.0;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.fundInvestmentListModel.rmbCost){
        return [self.dataSourceArr count] + 1;
    }
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        static NSString * cellName = @"CXIDGFundInvestmentTableViewCell";
        CXIDGFundInvestmentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[CXIDGFundInvestmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        [cell setCXFundInvestmentListModel:self.fundInvestmentListModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellID = @"cell";
    CXFundInvestmentListContractTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXFundInvestmentListContractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CXFundInvestmentListContractModel *model = self.dataSourceArr[indexPath.section - 1];
    [cell setCXFundInvestmentListContractModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [CXIDGFundInvestmentTableViewCell getCXIDGFundInvestmentTableViewCellHeightWithCXFundInvestmentListModel:self.fundInvestmentListModel];
    }
    CXFundInvestmentListContractModel *model = self.dataSourceArr[indexPath.section - 1];
    return [CXFundInvestmentListContractTableViewCell getCXFundInvestmentListContractTableViewCellHeightWithCXFundInvestmentListContractModel:model];
}

#pragma mark <---请求列表--->

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/detail/contract/%zd", urlPrefix, [self.model.projId integerValue]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"eid"] = self.model.projId;
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];
    
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.footer setHidden:!hasNextPage];
            self.fundInvestmentListModel = [CXFundInvestmentListModel yy_modelWithDictionary:JSON[@"data"]];
            self.fundInvestmentListModel.contractsArray = [NSArray yy_modelArrayWithClass:[CXFundInvestmentListContractModel class] json:JSON[@"data"][@"contracts"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:self.fundInvestmentListModel.contractsArray.mutableCopy];
            [self.listTableView reloadData];
        }else if([JSON[@"status"] intValue] == 400){
            
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        if ([JSON[@"status"] intValue] == 400) {
//            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:@"暂无数据" AndPictureName:@"pic_kzt_wsj"];
        }
    }
    failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

@end
