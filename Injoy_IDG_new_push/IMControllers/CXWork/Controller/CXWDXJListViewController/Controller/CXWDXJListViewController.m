//
//  CXWDXJListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXWDXJListViewController.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CXWDXJListCell.h"
#import "CXVacationApplicationEditViewController.h"
#import "CXBaseRequest.h"
#import "MJRefresh.h"
#import "UIView+CXCategory.h"
#import "CXTopSwitchView.h"
#import "CXWDXJListModel.h"
#import "HttpTool.h"
#import "IDGXJListViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXWDXJListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
@property(assign, nonatomic) int pageNumber;
@property(strong, nonatomic) CXVacationApplicationModel *vacationApplicationModel;
@property(weak, nonatomic) CXTopSwitchView *topSwitchView;
@property(assign, nonatomic) CXApprovalType approvalType;

@end

@implementation CXWDXJListViewController

static NSString * const m_cellID = @"cellID";

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
        [_listTableView registerClass:[CXWDXJListCell class] forCellReuseIdentifier:m_cellID];
    }
    return _listTableView;
}

#pragma mark - instance function
- (void)findListRequest:(int)type {
    self.topSwitchView.userInteractionEnabled = NO;//不能点击
    
    if (self.pageNumber == 1) {
        [self.dataSourceArr removeAllObjects];
    }

    self.approvalType = type;
    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/self/list", urlPrefix];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(type) forKey:@"signed"];
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        self.topSwitchView.userInteractionEnabled = YES;
        
        if ([JSON[@"status"] intValue] == 200) {
            if (self.pageNumber == 1) {
                [self.dataSourceArr removeAllObjects];//快速下滑,崩溃
            }
            [self.listTableView.footer setHidden:YES];
            NSArray<CXWDXJListModel *> *data = [NSArray yy_modelArrayWithClass:[CXWDXJListModel class] json:JSON[@"data"]];
            [self.dataSourceArr addObjectsFromArray:data];
            if (self.dataSourceArr.count != 0) {
                [self.listTableView reloadData];
            }
//            [self.listTableView reloadData];
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        self.topSwitchView.userInteractionEnabled = YES;

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

- (void)addBtnClick{
    IDGXJListViewController *vc = [IDGXJListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
#pragma mark - UI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"我的销假"];
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
    return  UITableViewAutomaticDimension;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:m_cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [((CXWDXJListCell *) cell) setAction:self.dataSourceArr[indexPath.row]];
    }];
    if (height < SDCellHeight) {
        height = SDCellHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger) [self.dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < self.dataSourceArr.count) {
//        CXWDXJListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID];
//        if (nil == cell) {
//            cell = [[CXWDXJListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cellID];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setAction:self.dataSourceArr[indexPath.row]];
//        return cell;
//    }
//    return [[CXWDXJListCell alloc] init];
 
    if (indexPath.row < self.dataSourceArr.count) {
        CXWDXJListCell *cell = [tableView dequeueReusableCellWithIdentifier:m_cellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataSourceArr[indexPath.row];
        return  cell;
    }
    return [CXWDXJListCell new];
}
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageNumber = 1;
    [self findListRequest:self.approvalType];
}
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
//        [self.dataSourceArr removeAllObjects];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
