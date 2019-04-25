//
//  IDGXJListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/19.
//  Copyright © 2018年 Injoy. All rights reserved.
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

#import "IDGXJListViewController.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXVacationApplicationListCell.h"
#import "CXVacationApplicationEditViewController.h"
#import "CXBaseRequest.h"
#import "CXVacationApplicationModel.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "CXTopSwitchView.h"

#import "MBProgressHUD+CXCategory.h"

@interface IDGXJListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@property(weak, nonatomic) CXTopSwitchView *topSwitchView;
@property(assign, nonatomic) CXApprovalType approvalType;

@end

@implementation IDGXJListViewController

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
    self.approvalType = CXApprovalTypeAgree;
    
    NSString *url = [NSString stringWithFormat:@"%@holiday/queryList/%d", urlPrefix, type];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [self.dataSourceArr removeAllObjects];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [CXBaseRequest getResultWithUrl:url
                              param:param
                            success:^(id responseObj) {
//                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                CXVacationApplicationModel *model = [CXVacationApplicationModel yy_modelWithDictionary:responseObj];
                                self.vacationApplicationModel = model;
                                if (HTTPSUCCESSOK == model.status) {
                                    if (self.pageNumber == 1) {
                                        [self.dataSourceArr removeAllObjects];
                                    }
                                    [self.dataSourceArr addObjectsFromArray:model.data];
                                    [self.listTableView reloadData];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }
                                self.listTableView.footer.hidden = self.pageNumber >= model.pageCount;
                                [self.listTableView.header endRefreshing];
                                [self.listTableView.footer endRefreshing];
                                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
                            } failure:^(NSError *error) {
//                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                CXAlert(KNetworkFailRemind);
                                [self.listTableView.header endRefreshing];
                                [self.listTableView.footer endRefreshing];
                                [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
                            }];
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"销假申请"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTopView {
    CXTopSwitchView *topSwitchView = [[CXTopSwitchView alloc] init];
    @weakify(self);
    topSwitchView.callBack = ^(NSString *string) {
        @strongify(self);
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
    if (indexPath.row < self.dataSourceArr.count) {
        CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataSourceArr[indexPath.row];
        return cell;
    }
    return nil;
    /*
    if (indexPath.row < self.dataSourceArr.count) {
        CXVacationApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID];
        if (nil == cell) {
            cell = [[CXVacationApplicationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cellID];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSourceArr.count > 0) {
               [cell setAction:self.dataSourceArr[indexPath.row]];
        }
//        [cell setAction:self.dataSourceArr[indexPath.row]];
        return cell;
    }
    return [[CXVacationApplicationListCell alloc] init];
     */
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
//    [self setUpTopView];
    [self setUpTableView];
    
    self.approvalType = CXApprovalTypeStart;
    
    @weakify(self);
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber = 1;
        [self.dataSourceArr removeAllObjects];
        [self.listTableView reloadData];//滑动崩溃
        [self findListRequest:CXApprovalTypeAgree];
    }];
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        self.pageNumber++;
        if (self.pageNumber > self.vacationApplicationModel.totalPage) {
            self.pageNumber = self.vacationApplicationModel.totalPage;
            [self.listTableView.footer endRefreshing];
            return;
        }
        [self findListRequest:CXApprovalTypeAgree];
    }];
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
