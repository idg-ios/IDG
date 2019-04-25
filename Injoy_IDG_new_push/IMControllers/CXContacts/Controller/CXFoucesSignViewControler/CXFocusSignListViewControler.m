//
//  CXFoucSignListViewControler.m
//  SDMarketingManagement
//
//  Created by fanzhong on 16/4/13.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXFocusSignListViewControler.h"
#import "SDRootTopView.h"
#import "CXFocusSignListCell.h"
#import "MJRefresh.h"
#import "CXFocusSignModel.h"
#import "HttpTool.h"
#import "YYModel.h"
#import "CXFocusSignEditViewController.h"

@interface CXFocusSignListViewControler ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<CXFocusSignModel *> *list;

@end

@implementation CXFocusSignListViewControler

#pragma mark - Lazy-Load
- (NSMutableArray<CXFocusSignModel *> *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

#pragma mark - Life-Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviView];
    [self setupView];
}

- (void)setNaviView {
    SDRootTopView *topView = [self getRootTopView];
    [topView setNavTitle:@"关注标签"];
    [topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [topView setUpRightBarItemTitle:@"新建" addTarget:self action:@selector(rightBtnClick)];
    [self.view addSubview:topView];
}

- (void)setupView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    self.tableView.tableFooterView = footerView;
    
    [self.tableView.legendHeader beginRefreshing];
}

#pragma makr - Action
- (void)rightBtnClick {
    CXFocusSignEditViewController *editVC = [[CXFocusSignEditViewController alloc] init];
    editVC.editMode = CXFocusSignEditModeCreate;
    editVC.didSaveSuccessBlock = ^{
        [self.tableView.legendHeader beginRefreshing];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - 获取数据
- (void)refresh {
    self.page = 1;
    NSString *path = [NSString stringWithFormat:@"%@/contact/concern/%@/%@/%zd",urlPrefix, VAL_companyId, VAL_USERID, self.page];
    [self showHudInView:self.view hint:@"正在获取数据"];
    [HttpTool getWithPath:path params:nil success:^(NSDictionary *JSON) {
        self.list = [[NSArray yy_modelArrayWithClass:[CXFocusSignModel class] json:JSON[@"datas"]] mutableCopy];
        if (self.list.count > 0) {
            self.page++;
        }
        [self.tableView.legendHeader endRefreshing];
        [self.tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self.tableView.legendHeader endRefreshing];
//        TTAlert(@"获取关注标签失败");
        CXAlert(KNetworkFailRemind);
        [self hideHud];
    }];
}

- (void)loadMore {
    NSString *path = [NSString stringWithFormat:@"%@/contact/concern/%@/%@/%zd",urlPrefix, VAL_companyId, VAL_USERID, self.page];
    [self showHudInView:self.view hint:@"正在获取数据"];
    [HttpTool getWithPath:path params:nil success:^(NSDictionary *JSON) {
        NSArray<CXFocusSignModel *> *datas = [NSArray yy_modelArrayWithClass:[CXFocusSignModel class] json:JSON[@"datas"]];
        if (datas.count) {
            self.page++;
            [self.list addObjectsFromArray:datas];
            [self.tableView reloadData];
        }
        [self.tableView.legendFooter endRefreshing];
        [self hideHud];
    } failure:^(NSError *error) {
        [self.tableView.legendFooter endRefreshing];
//        TTAlert(@"获取关注标签失败");
        CXAlert(KNetworkFailRemind);
        [self hideHud];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SDMeCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"CXFocusSignCell";
    CXFocusSignListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXFocusSignListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell setFocusSignModel:self.list[indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CXFocusSignEditViewController *editVC = [[CXFocusSignEditViewController alloc] init];
    editVC.editMode = CXFocusSignEditModeModify;
    editVC.focusSignModel = self.list[indexPath.row];
    editVC.didSaveSuccessBlock = ^{
        [self.tableView.legendHeader beginRefreshing];
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

@end
