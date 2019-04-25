//
//  CXWorkOutsideListViewController.m
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXWorkOutsideListViewController.h"
#import "CXTopView.h"
#import "Masonry.h"
#import "CXWorkOutsideEditViewController.h"
#import "CXBaseRequest.h"
#import "CXListTableViewCell.h"
#import "MJRefresh.h"
#import "CXInputDialogView.h"
#import "UIView+CXCategory.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXWorkOutsideListViewController ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(strong, nonatomic) UITableView *listTableView;
@property(weak, nonatomic) CXTopView *topView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXOutWorkModel *outWorkModel;
@end

@implementation CXWorkOutsideListViewController

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
    [rootTopView setNavTitle:@"工作外出"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopView {
    CXTopView *topView = [[CXTopView alloc] initWithTitles:@[@"外出申请", @"查找外出"] style:imageWithBlueColor];
    topView.callBack = ^(NSString *title) {
        if ([@"外出申请" isEqualToString:title]) {
            CXWorkOutsideEditViewController *vc = [[CXWorkOutsideEditViewController alloc] init];
            @weakify(self);
            vc.callBack = ^{
                @strongify(self);
                [self.listTableView.header beginRefreshing];
            };
            vc.formType = CXFormTypeCreate;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([@"查找外出" isEqualToString:title]) {
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
    self.topView = topView;
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
    NSString *url = [NSString stringWithFormat:@"%@outWork/list/%d", urlPrefix, self.pageNumber];

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if ([self.searchText length]) {
        param[@"s_reason"] = self.searchText;

    }
    if (self.fromSuperSearch) {
        param[@"s_kind"] = @"super";
    }

    @weakify(self);
    HUD_SHOW(nil);
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                 @strongify(self);
                                 CXOutWorkModel *model = [CXOutWorkModel yy_modelWithDictionary:responseObj];
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
                                 [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                HUD_HIDE;
                @strongify(self);
                [self.listTableView.header endRefreshing];
                [self.listTableView.footer endRefreshing];
                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];

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
        if (self.pageNumber > self.outWorkModel.totalPage) {
            self.pageNumber = self.outWorkModel.totalPage;
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

    CXWorkOutsideEditViewController *vc = [[CXWorkOutsideEditViewController alloc] init];
    vc.outWorkModel = self.dataSourceArr[indexPath.row];
    @weakify(self);
    vc.callBack = ^{
        @strongify(self);
        [self.listTableView.header beginRefreshing];
    };
    vc.formType = CXFormTypeModify;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

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

    CXOutWorkModel *model = self.dataSourceArr[indexPath.row];
    cell.leftTopLabel.text = [NSString stringWithFormat:@"外出：%@", model.reason];
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.ygName, model.ygDeptName];
    cell.rightTopLabel.text = model.statusName;
    cell.rightBottomLabel.text = model.createTime;

    return cell;
}

@end
