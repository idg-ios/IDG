//
// Created by ^ on 2017/11/21.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXVacationApprovalListViewController.h"
#import "CXVacationApplicationListCell.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXBaseRequest.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "CXVacationApplicationModel.h"
#import "CXVacationApplicationEditViewController.h"

/// 休假批审
@interface CXVacationApprovalListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@end

@implementation CXVacationApprovalListViewController

NSString *m_cellID_1 = @"cellID";

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
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 200.f;
        [_listTableView registerClass:[CXVacationApplicationListCell class] forCellReuseIdentifier:m_cellID_1];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)findListRequest {
    NSString *url = [NSString stringWithFormat:@"%@holiday/getAllApproveDetail", urlPrefix];
    [CXBaseRequest getResultWithUrl:url param:nil success:^(id responseObj) {
        NSInteger status = [responseObj[@"status"] integerValue];
        CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
        if (status == 200) {
            self.dataSourceArr = [model.data mutableCopy];
            [self.listTableView reloadData];
        } else {
             MAKE_TOAST(model.msg);
        }
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];

    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
    
    /*
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    @weakify(self);
    [CXBaseRequest getResultWithUrl:url
                              param:param
                            success:^(id responseObj) {
                                CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
                                self.vacationApplicationModel = model;
                                if (HTTPSUCCESSOK == model.status) {
                                    
                                    [self.dataSourceArr addObjectsFromArray:model.data];
                                    [self.listTableView reloadData];
                                } else {
                                    MAKE_TOAST(model.msg);
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
     */
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"请假审批"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
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
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    /*
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_cellID_1 cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXVacationApplicationListCell *) cell) setApprovalAction:self.dataSourceArr[indexPath.row]];
    }];
    if (height < SDCellHeight) {
        height = SDCellHeight;
    }
    return height;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXVacationApplicationEditViewController *vc = [[CXVacationApplicationEditViewController alloc] init];
    @weakify(self);
    vc.callBack = ^{
        @strongify(self);
        [self.listTableView.header beginRefreshing];
    };
    vc.vacationApplicationModel = self.dataSourceArr[indexPath.row];
    vc.formType = CXFormTypeApproval;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID_1];
    if (nil == cell) {
        cell = [[CXVacationApplicationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cellID_1];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([self.dataSourceArr count] >indexPath.row){
        CXVacationApplicationModel *model = self.dataSourceArr[indexPath.row];
        [cell setApprovalAction:model];
    }
    return cell;
     */
    if([self.dataSourceArr count] >indexPath.row){
        CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID_1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CXVacationApplicationModel *model = self.dataSourceArr[indexPath.row];
        cell.model = model;
        return cell;
    }
    return nil;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //页面返回,重新刷新数据
//    [self.dataSourceArr removeAllObjects];
//    self.pageNumber = 1;
    [self findListRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
    [self setUpTableView];
/*
    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self.dataSourceArr removeAllObjects];
        [self.listTableView reloadData];
        self.pageNumber = 1;
        [self findListRequest];
    }];

    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber++;
        if (self.pageNumber > self.vacationApplicationModel.totalPage) {
            self.pageNumber = self.vacationApplicationModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
 */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
