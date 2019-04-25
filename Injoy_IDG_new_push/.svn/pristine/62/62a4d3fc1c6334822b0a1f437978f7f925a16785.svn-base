//
//  CXHouseProjectDetailInfoViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectDetailInfoViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGConferenceInformationListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXIDGProjectManagementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXIDGConferenceInformationListTableViewCell.h"
#import "CXIDGConferenceInformationDetailViewController.h"
#import "CXIDGProjectStatusModel.h"
#import "CXExpandTableViewCell.h"
#import "CXHouseProjectDetialInfoModel.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXHouseProjectDetailInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXIDGProjectStatusTableViewCellModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@property(nonatomic, strong) CXHouseProjectDetialInfoModel *model;
@end

@implementation CXHouseProjectDetailInfoViewController

#pragma mark - get & set

- (CXHouseProjectDetialInfoModel *)model{
    if(!_model){
        _model = [[CXHouseProjectDetialInfoModel alloc] init];
    }
    return _model;
}

- (NSMutableArray<CXIDGProjectStatusTableViewCellModel *> *)dataSourceArr {
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
    CXIDGProjectStatusTableViewCellModel * model = [self.dataSourceArr objectAtIndex:indexPath.section];
    model.isExpand = !model.isExpand;
    self.dataSourceArr[indexPath.section] = model;
    [self.listTableView reloadData];
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
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXExpandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXExpandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }else{
        for(UIView * subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    CXIDGProjectStatusTableViewCellModel *model = self.dataSourceArr[indexPath.section];
    [cell setCXIDGProjectStatusTableViewCellModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXIDGProjectStatusTableViewCellModel *model = self.dataSourceArr[indexPath.section];
    return [CXExpandTableViewCell getCXIDGConferenceInformationListTableViewCellHeightWithCXIDGProjectStatusTableViewCellModel:model];
}

#pragma mark <---请求列表--->

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/house/detail/%zd/more.json", urlPrefix, self.projId];
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            [self.dataSourceArr removeAllObjects];
            self.model = [CXHouseProjectDetialInfoModel yy_modelWithDictionary:JSON[@"data"]];
            
            CXIDGProjectStatusTableViewCellModel * floorModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            floorModel.title = @"建筑面积相关";
            floorModel.content = self.model.floorSpace;
            floorModel.isExpand = YES;
            [self.dataSourceArr addObject:floorModel];
            
            CXIDGProjectStatusTableViewCellModel * landModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            landModel.title = @"土地指标";
            landModel.content = self.model.landIndicator;
            landModel.isExpand = YES;
            [self.dataSourceArr addObject:landModel];
            
            CXIDGProjectStatusTableViewCellModel * legalModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            legalModel.title = @"证照及法律手续";
            legalModel.content = self.model.legalFormalities;
            legalModel.isExpand = YES;
            [self.dataSourceArr addObject:legalModel];
            
            CXIDGProjectStatusTableViewCellModel * marketModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            marketModel.title = @"市场描述";
            marketModel.content = self.model.marketDesc;
            marketModel.isExpand = YES;
            [self.dataSourceArr addObject:marketModel];
            
            CXIDGProjectStatusTableViewCellModel * riskModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            riskModel.title = @"风险提示";
            riskModel.content = self.model.riskDesc;
            riskModel.isExpand = YES;
            [self.dataSourceArr addObject:riskModel];
            
            CXIDGProjectStatusTableViewCellModel * teamModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            teamModel.title = @"交易对手及合作伙伴";
            teamModel.content = self.model.teamDesc;
            teamModel.isExpand = YES;
            [self.dataSourceArr addObject:teamModel];
            
            CXIDGProjectStatusTableViewCellModel * timeModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            timeModel.title = @"时间节点";
            timeModel.content = self.model.timeNode;
            timeModel.isExpand = YES;
            [self.dataSourceArr addObject:timeModel];
            
            CXIDGProjectStatusTableViewCellModel * tradeModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            tradeModel.title = @"交易思路";
            tradeModel.content = self.model.tradeThinking;
            tradeModel.isExpand = YES;
            [self.dataSourceArr addObject:tradeModel];
            
            CXIDGProjectStatusTableViewCellModel * summaryModel = [[CXIDGProjectStatusTableViewCellModel alloc] init];
            summaryModel.title = @"退出总结";
            summaryModel.content = self.model.withdrawSummary;
            summaryModel.isExpand = YES;
            [self.dataSourceArr addObject:summaryModel];
            
            [self.listTableView reloadData];
        }else{
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);

        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}
#pragma mark - 业务逻辑处理

#pragma mark - 数据懒加载

@end
