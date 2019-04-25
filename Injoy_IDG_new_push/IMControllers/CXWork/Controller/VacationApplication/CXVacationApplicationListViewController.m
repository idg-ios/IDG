//
// Created by ^ on 2017/11/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

/** 审批状态 */
typedef NS_ENUM(NSInteger, CXApprovalType) {
    /** 批审中 */
            CXApprovalTypeStart = 1,
    /** 同意 */
            CXApprovalTypeAgree = 2,
    /** 拒绝 */
            CXApprovalTyperefuse = 3
};

#import "CXVacationApplicationListViewController.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXVacationApplicationListCell.h"
#import "CXVacationApplicationEditViewController.h"
#import "CXBaseRequest.h"
#import "CXVacationApplicationModel.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "CXTopSwitchView.h"
#import "CXVacationApplicationEditViewController.h"
#import "MBProgressHUD+CXCategory.h"
#import "QJSQEditViewController.h"

@interface CXVacationApplicationListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@property(weak, nonatomic) CXTopSwitchView *topSwitchView;
@property(assign, nonatomic) CXApprovalType approvalType;
@end

@implementation CXVacationApplicationListViewController

static NSString *const m_cellID = @"cellID_";

#pragma mark - get & set

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [@[] mutableCopy];
    }
    return _dataSourceArr;
}

- (CXVacationApplicationModel *)vacationApplicationModel {
    if (nil == _vacationApplicationModel) {
        _vacationApplicationModel = [[CXVacationApplicationModel alloc] init];
    }
    return _vacationApplicationModel;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.estimatedRowHeight = 200.f;
        [_listTableView registerClass:[CXVacationApplicationListCell class] forCellReuseIdentifier:m_cellID];
    }
    return _listTableView;
}

#pragma mark - instance function
- (void)addBtnEvent:(UIButton *)sender {
    CXVacationApplicationEditViewController *vc = [[CXVacationApplicationEditViewController alloc] init];
    vc.formType = CXFormTypeCreate;
    @weakify(self);
    vc.callBack = ^{
        @strongify(self);
        [self.listTableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)findListRequest:(int)type {
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];
    self.approvalType = type;
    NSString *url = [NSString stringWithFormat:@"%@holiday/queryList/%d", urlPrefix, type];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [self.dataSourceArr removeAllObjects];
    [CXBaseRequest getResultWithUrl:url
                              param:param
                            success:^(id responseObj) {
                                [MBProgressHUD hideHUDInMainQueueForView:self.view];
                                
                                CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
                                self.vacationApplicationModel = model;
                                if (HTTPSUCCESSOK == model.status) {
                                    
                                    [self.dataSourceArr addObjectsFromArray:model.data];

                                    [self.listTableView reloadData];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }
                                self.listTableView.footer.hidden = self.pageNumber >= model.pageCount;
                                [self.listTableView.header endRefreshing];
                                [self.listTableView.footer endRefreshing];
                                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
                            }
                            failure:^(NSError *error) {
                                [MBProgressHUD hideHUDInMainQueueForView:self.view];

                CXAlert(KNetworkFailRemind);
                [self.listTableView.header endRefreshing];
                [self.listTableView.footer endRefreshing];
                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            }];
}
////新增
- (void)addBtnClick{
    QJSQEditViewController *vc = [QJSQEditViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - UI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"我的请假"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(addBtnClick)];
}
- (void)setUpTopView {
    CXTopSwitchView *topSwitchView = [[CXTopSwitchView alloc] init];
    @weakify(self);
    topSwitchView.callBack = ^(NSString *string) {
        
        @strongify(self);
        
        [self.dataSourceArr removeAllObjects];
        [self.listTableView reloadData];
        if ([@"审批中" isEqualToString:string]) {
            
            [self findListRequest:CXApprovalTypeStart];
        }
        if ([@"同意" isEqualToString:string]) {
            [self findListRequest:CXApprovalTypeAgree];
        }
        if ([@"驳回" isEqualToString:string]) {
            [self findListRequest:CXApprovalTyperefuse];
        }
    };
    self.topSwitchView = topSwitchView;
    [self.view addSubview:topSwitchView];
    [topSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CXTopSwitchView_height);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.topSwitchView.mas_bottom);
    }];

    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    /*
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXVacationApplicationListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    if (height < SDCellHeight) {
        height = SDCellHeight;
    }
    return height;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CXVacationApplicationEditViewController *vc = [[CXVacationApplicationEditViewController alloc] init];
    vc.formType = CXFormTypeDetail;
    vc.vacationApplicationModel = self.dataSourceArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.row < self.dataSourceArr.count) {
        CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID];
        if (nil == cell) {
            cell = [[CXVacationApplicationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAction:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    return [[CXVacationApplicationListCell alloc] init];
     */
    if (indexPath.row < self.dataSourceArr.count) {
        CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataSourceArr[indexPath.row];
        return cell;
    }
    return [CXVacationApplicationListCell new];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];
    self.approvalType = CXApprovalTypeStart;
    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber = 1;
        [self.dataSourceArr removeAllObjects];
        [self findListRequest:self.approvalType];
    }];
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber++;
        if (self.pageNumber > self.vacationApplicationModel.totalPage) {
            self.pageNumber = self.vacationApplicationModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest:self.approvalType];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.listTableView.header beginRefreshing];//返回该页面重新刷新
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
