//
// Created by ^ on 2017/12/14.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXInvestmentAgreementListViewController.h"
#import "CXInvestmentAgreementListCell.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIView+YYAdd.h"
#import "CXFundInvestmentModel.h"
#import "CXBaseRequest.h"

@interface CXInvestmentAgreementListViewController ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(strong, nonatomic) UIView *headView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(weak, nonatomic) UILabel *cnyLabel;
@property(weak, nonatomic) UILabel *cnyLabel_grow;
@property(weak, nonatomic) UILabel *usdLabel;
@property(weak, nonatomic) UILabel *usdLabel_grow;
@property(strong, nonatomic) CXFundInvestmentModel *fundInvestmentModel;
@end

@implementation CXInvestmentAgreementListViewController

const NSString *const m_IA_cellID = @"cellID_1_0";

#pragma mark - HTTP request

- (void)findListRequest {
    // self.eid = 5780;
    // http://192.168.101.236:8080/idg_api_yx/#g=1&p=%E5%B7%A5%E4%BD%9C&hi=1
    // http://192.168.101.236:8080/idg_api/#g=1&p=%E7%99%BB%E9%99%86
    NSString *url = [NSString stringWithFormat:@"%@project/detail/contract/%d", urlPrefix, self.eid];

    [CXBaseRequest postResultWithUrl:url
                               param:nil
                             success:^(id responseObj) {
                                 int status = [[responseObj valueForKey:@"status"] intValue];
                                 if (HTTPSUCCESSOK == status) {
                                     CXFundInvestmentModel *model = [CXFundInvestmentModel yy_modelWithDictionary:responseObj[@"data"]];
                                     self.fundInvestmentModel = model;
                                     [self.dataSourceArr addObjectsFromArray:model.contracts];
                                 } else {
                                     NSString *msg = responseObj[@"data"];
                                     MAKE_TOAST(msg);
                                 }
                                 [self setControlValue];
                                 [self.listTableView reloadData];
                                 [self.listTableView.header endRefreshing];
                             } failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
}

#pragma mark - get & set

- (UIView *)headView {
    if (nil == _headView) {
        _headView = [[UIView alloc] initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, 100.f}];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (CXFundInvestmentModel *)fundInvestmentModel {
    if (nil == _fundInvestmentModel) {
        _fundInvestmentModel = [[CXFundInvestmentModel alloc] init];
    }
    return _fundInvestmentModel;
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
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = kBackgroundColor;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 0;
        [_listTableView registerClass:[CXInvestmentAgreementListCell class] forCellReuseIdentifier:m_IA_cellID];
        _listTableView.tableHeaderView = self.headView;
    }
    return _listTableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_IA_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXInvestmentAgreementListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArr.count) {
        CXInvestmentAgreementListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_IA_cellID];
        if (!cell) {
            cell = [[CXInvestmentAgreementListCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:m_IA_cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAction:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    return [[CXInvestmentAgreementListCell alloc] init];
}

#pragma mark - value

- (void)setControlValue {
    self.cnyLabel.text = [NSString stringWithFormat:@"CNY：%@", self.fundInvestmentModel.rmbCost];
    self.cnyLabel_grow.text = self.fundInvestmentModel.rmbGrowth;
    self.usdLabel.text = [NSString stringWithFormat:@"USD：%@", self.fundInvestmentModel.usdCost];
    self.usdLabel_grow.text = self.fundInvestmentModel.usdGrowth;
}

#pragma mark - UI

- (void)setUpHeadView {
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 10.f;
    CGFloat space = 5.f;
    CGFloat height = 30.f;

    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.headView addSubview:redView];
    redView.frame = (CGRect) {leftMargin, topMargin, 5.f, height};

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"累计投资及价值增长";
    titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    [self.headView addSubview:titleLabel];
    titleLabel.frame = (CGRect) {redView.right + 5.f, redView.top, Screen_Width - redView.right + 5.f, height};

    /// CNY累计投资
    UILabel *cnyLabel = [[UILabel alloc] init];
    self.cnyLabel = cnyLabel;
    cnyLabel.text = [NSString stringWithFormat:@"CNY："];
    cnyLabel.textColor = kColorWithRGB(158.f, 158.f, 158.f);
    cnyLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:cnyLabel];
    cnyLabel.frame = (CGRect) {titleLabel.left, titleLabel.bottom + space, Screen_Width / 2.f, height};

    /// CNY估值增长
    UILabel *cnyLabel_grow = [[UILabel alloc] init];
    self.cnyLabel_grow = cnyLabel_grow;
    cnyLabel_grow.textColor = kColorWithRGB(158.f, 158.f, 158.f);
    cnyLabel_grow.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:cnyLabel_grow];
    cnyLabel_grow.frame = (CGRect) {cnyLabel.right, cnyLabel.top, Screen_Width / 2.f, height};

    /// USD累计投资
    UILabel *usdLabel = [[UILabel alloc] init];
    self.usdLabel = usdLabel;
    usdLabel.text = [NSString stringWithFormat:@"USD："];
    usdLabel.textColor = kColorWithRGB(158.f, 158.f, 158.f);
    usdLabel.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:usdLabel];
    usdLabel.frame = (CGRect) {cnyLabel.left, cnyLabel.bottom + space, Screen_Width / 2.f, height};

    /// USD估值增长
    UILabel *usdLabel_grow = [[UILabel alloc] init];
    self.usdLabel_grow = usdLabel_grow;
    usdLabel_grow.textColor = kColorWithRGB(158.f, 158.f, 158.f);
    usdLabel_grow.textAlignment = NSTextAlignmentLeft;
    [self.headView addSubview:usdLabel_grow];
    usdLabel_grow.frame = (CGRect) {usdLabel.right, usdLabel.top, Screen_Width / 2.f, height};
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];

    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }

    [self setUpHeadView];

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

    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
