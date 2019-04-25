//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXWorkLogListViewController.h"
#import "CXTopView.h"
#import "Masonry.h"
#import "CXListTableViewCell.h"
#import "CXWorkLogEditViewController.h"
#import "CXBaseRequest.h"
#import "CXWorkLogModel.h"
#import "MJRefresh.h"
#import "CXInputDialogView.h"
#import "UIView+CXCategory.h"

@interface CXWorkLogListViewController ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(strong, nonatomic) UITableView *listTableView;
@property(weak, nonatomic) CXTopView *topView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(weak, nonatomic) CXWorkLogModel *workLogModel;
@end

@implementation CXWorkLogListViewController

#pragma mark - get & set

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [@[] mutableCopy];
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.rowHeight = SDCellHeight;
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"工作日志"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopView {
    CXTopView *topView = [[CXTopView alloc] initWithTitles:@[@"写日志", @"查日志"] style:titleWithBlueColor];
    self.topView = topView;
    topView.callBack = ^(NSString *title) {
        if ([@"写日志" isEqualToString:title]) {
            CXWorkLogEditViewController *vc = [[CXWorkLogEditViewController alloc] init];
            @weakify(self);
            vc.callBack = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                [self.listTableView.header beginRefreshing];
            };
            vc.formType = CXFormTypeCreate;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([@"查日志" isEqualToString:title]) {
            @weakify(self);
            CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
            dialogView.onApplyWithContent = ^(NSString *content) {
                @strongify(self);
                self.searchText = content;
                [self.listTableView.header beginRefreshing];
            };
            [dialogView show];
        }
    };
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self getRootTopView].mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CXTopViewHeight);
    }];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.topView.mas_bottom).offset(10.f);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)findListRequest {
    NSString *url = [NSString stringWithFormat:@"%@workLog/list/%d", urlPrefix, self.pageNumber];

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([self.searchText length]) {
        param[@"s_title"] = self.searchText;
    }
    if (self.fromSuperSearch) {
        param[@"s_kind"] = @"super";
    }

    @weakify(self);

    HUD_SHOW(nil);
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 @strongify(self);
                                 CXWorkLogModel *model = [CXWorkLogModel yy_modelWithDictionary:responseObj];
                                 self.workLogModel = model;
                                 if (HTTPSUCCESSOK == model.status) {
                                     [self.dataSourceArr addObjectsFromArray:model.data];
                                     [self.listTableView reloadData];
                                 }
                                 HUD_HIDE;
                                 self.listTableView.footer.hidden = self.pageNumber >= model.pageCount;
                                 [self.listTableView.header endRefreshing];
                                 [self.listTableView.footer endRefreshing];
                                 [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
                             } failure:^(NSError *error) {
                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
                @strongify(self);
                [self.listTableView.header endRefreshing];
                [self.listTableView.footer endRefreshing];
                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];

    self.pageNumber = 1;

    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber = 1;
        [self.dataSourceArr removeAllObjects];
        [self findListRequest];
    }];

    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber++;
        if (self.pageNumber > self.workLogModel.totalPage) {
            self.pageNumber = self.workLogModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CXWorkLogModel *model = self.dataSourceArr[indexPath.row];
    CXWorkLogEditViewController *vc = [[CXWorkLogEditViewController alloc] init];
    @weakify(self);
    vc.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self.listTableView.header beginRefreshing];
    };
    vc.workLogModel = model;
    vc.formType = CXFormTypeModify;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CXListTableViewCell *listCell = (CXListTableViewCell *) cell;

    [listCell.rightBottomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.right.equalTo(cell.contentView).offset(-5.f);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }

    CXWorkLogModel *model = self.dataSourceArr[indexPath.row];
    cell.leftTopLabel.text = [NSString stringWithFormat:@"日志：%@", model.title];
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.ygName, model.ygDeptName];
    cell.rightBottomLabel.text = model.createTime;
    return cell;
}

@end
