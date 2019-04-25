//
// Created by ^ on 2017/12/14.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXInvestmentPlanListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXInvestmentPlanListCell.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "CXBaseRequest.h"
#import "CXInvestmentPlanModel.h"

@interface CXInvestmentPlanListViewController ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(strong, nonatomic) CXInvestmentPlanModel *investmentPlanModel;
@end

@implementation CXInvestmentPlanListViewController

const NSString *const m_IP_cellID = @"cellID_1_0";

#pragma mark - HTTP

- (void)findListRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/detail/invest/%d", urlPrefix, self.eid];

    [CXBaseRequest postResultWithUrl:url
                               param:nil
                             success:^(id responseObj) {
                                 CXInvestmentPlanModel *model = [CXInvestmentPlanModel yy_modelWithDictionary:responseObj];
                                 self.investmentPlanModel = model;
                                 if (HTTPSUCCESSOK == model.status) {
                                     [self.dataSourceArr addObjectsFromArray:model.data];
                                 } else {
                                     MAKE_TOAST(model.msg);
                                 }
                                 [self.listTableView reloadData];
                                 [self.listTableView.header endRefreshing];
                             } failure:^(NSError *error) {
                [self.listTableView.header endRefreshing];
                CXAlert(KNetworkFailRemind);
            }];
}

#pragma mark - get & set

- (CXInvestmentPlanModel *)investmentPlanModel {
    if (nil == _investmentPlanModel) {
        _investmentPlanModel = [[CXInvestmentPlanModel alloc] init];
    }
    return _investmentPlanModel;
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = kBackgroundColor;
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = kBackgroundColor;
        _listTableView.estimatedRowHeight = 0;
        [_listTableView registerClass:[CXInvestmentPlanListCell class] forCellReuseIdentifier:m_IP_cellID];
    }
    return _listTableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_IP_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXInvestmentPlanListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArr.count) {
        CXInvestmentPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_IP_cellID];
        if (!cell) {
            cell = [[CXInvestmentPlanListCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:m_IP_cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAction:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    return [[CXInvestmentPlanListCell alloc] init];
}

#pragma mark - UI

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];

    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }

    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self.dataSourceArr removeAllObjects];
        [self findListRequest];
    }];

    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;

    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
