//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXProjectListViewController.h"
#import "Masonry.h"
#import "CXProjectListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXProjectDetailViewController.h"
#import "CXBaseRequest.h"
#import "MJRefresh.h"

@interface CXProjectListViewController ()
        <
        UITableViewDelegate,
        UITableViewDataSource
        >
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXProjectManagerModel *projectManagerModel;
@end

@implementation CXProjectListViewController

const NSString *const m_p_cellID = @"cellID_";

#pragma mark - get & set

- (CXProjectManagerModel *)projectManagerModel {
    if (nil == _projectManagerModel) {
        _projectManagerModel = [[CXProjectManagerModel alloc] init];
    }
    return _projectManagerModel;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 0;
        [_listTableView registerClass:[CXProjectListCell class] forCellReuseIdentifier:m_p_cellID];
    }
    return _listTableView;
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [@[] mutableCopy];
    }
    return _dataSourceArr;
}

#pragma mark - HTTP request

- (void)findListRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/list/%d", urlPrefix, self.pageNumber];

    [CXBaseRequest postResultWithUrl:url
                               param:nil
                             success:^(id responseObj) {
                                 CXProjectManagerModel *model = [CXProjectManagerModel yy_modelWithDictionary:responseObj];
                                 self.projectManagerModel = model;
                                 if (HTTPSUCCESSOK == model.status) {
                                     [self.dataSourceArr addObjectsFromArray:model.data];
                                 } else {
                                     MAKE_TOAST(model.msg);
                                 }
                                 [self.listTableView reloadData];
                                 self.listTableView.footer.hidden = self.pageNumber >= model.pageCount;
                                 [self.listTableView.header endRefreshing];
                                 [self.listTableView.footer endRefreshing];
                             } failure:^(NSError *error) {
                [self.listTableView.header endRefreshing];
                [self.listTableView.footer endRefreshing];
                CXAlert(KNetworkFailRemind);
            }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXProjectDetailViewController *vc = [[CXProjectDetailViewController alloc] init];
    vc.projectManagerModel = self.dataSourceArr[indexPath.row];
    vc.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_p_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXProjectListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataSourceArr.count) {
        CXProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_p_cellID];
        if (nil == cell) {
            cell = [[CXProjectListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_p_cellID];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAction:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    return [[CXProjectListCell alloc] init];
}

#pragma mark - instance function

- (void)searchEvent {

}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:self.title];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];

    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"msgSearch"]
                              addTarget:self
                                 action:@selector(searchEvent)];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }

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
        if (self.pageNumber > self.projectManagerModel.totalPage) {
            self.pageNumber = self.projectManagerModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
