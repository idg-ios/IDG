//
//  CXStatementOfAffairsViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXStatementOfAffairsViewController.h"
#import "CXTopView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXStatementOfAffairsListModel.h"
#import "CXListTableViewCell.h"
#import "CXStatementOfAffairsFormViewController.h"
#import "CXInputDialogView.h"
#import "UIView+CXCategory.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXStatementOfAffairsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;

@property(weak, nonatomic) CXTopView *topView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXStatementOfAffairsListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXStatementOfAffairsViewController

#pragma mark - get & set

- (NSMutableArray<CXStatementOfAffairsListModel *> *)dataSourceArr {
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
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"事务报告"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopView {
    CXTopView *topView = [[CXTopView alloc] initWithTitles:@[@"提交报告", @"查找报告"] style:withoutBlueColor];
    topView.callBack = ^(NSString *title) {
        if ([@"提交报告" isEqualToString:title]) {
            CXStatementOfAffairsFormViewController *vc = [[CXStatementOfAffairsFormViewController alloc] init];
            @weakify(self);
            vc.callBack = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                [self.listTableView.header beginRefreshing];
            };
            vc.formType = CXFormTypeCreate;
            [self.navigationController pushViewController:vc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
        if ([@"查找报告" isEqualToString:title]) {
            NSLog(@"查找报告");
            CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
            dialogView.onApplyWithContent = ^(NSString *content) {
                self.searchText = content;
                [self getListWithPage:1];
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
    @weakify(self)
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self)
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }];
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self)
        [self getListWithPage:self.pageNumber + 1];
    }];
    [self.listTableView.footer setHidden:YES];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getListWithPage:self.pageNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXStatementOfAffairsFormViewController *vc = [[CXStatementOfAffairsFormViewController alloc] init];
    CXStatementOfAffairsFormModel *model = [[CXStatementOfAffairsFormModel alloc] init];
    CXStatementOfAffairsListModel *listModel = self.dataSourceArr[indexPath.row];
    model.eid = listModel.eid;
    vc.model = model;
    @weakify(self);
    vc.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        [self.listTableView.header beginRefreshing];
    };
    vc.formType = CXFormTypeModify;
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
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

    CXStatementOfAffairsListModel *model = self.dataSourceArr[indexPath.row];
    cell.leftTopLabel.text = [NSString stringWithFormat:@"%@", model.title];
    cell.leftBottomLabel.text = [NSString stringWithFormat:@"%@ %@", model.ygName, model.ygDeptName];
    cell.rightTopLabel.text = model.statusName;
    cell.rightBottomLabel.text = model.createTime;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDCellHeight;
}

#pragma mark <---请求列表--->

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@affair/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.footer setHidden:!hasNextPage];
            NSArray<CXStatementOfAffairsListModel *> *data = [NSArray yy_modelArrayWithClass:[CXStatementOfAffairsListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
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
