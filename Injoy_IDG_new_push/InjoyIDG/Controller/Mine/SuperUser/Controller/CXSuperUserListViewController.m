//
//  CXSuperUserListViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperUserListViewController.h"
#import "CXUserStateCell.h"
#import "UIView+CXCategory.h"
#import "CXSuperUserSelectViewController.h"
#import "MJRefresh.h"
#import "HttpTool.h"

@interface CXSuperUserListViewController () <UITableViewDataSource, UITableViewDelegate, CXUserStateCellDelegate, UISearchBarDelegate>

/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;
/** <#comment#> */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 数据源 */
@property (nonatomic, copy) NSArray<CXSuperUserModel *> *users;
/** 搜索结果 */
@property (nonatomic, copy) NSArray<CXSuperUserModel *> *filteredUsers;

@end

static NSString *const kCellId = @"CXUserStateCell";

@implementation CXSuperUserListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.tableView.header beginRefreshing];
}

- (void)setup {
    [self.RootTopView setNavTitle: self.title ?: @"超级用户"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(onLeftBarItemTap)];
    [self.RootTopView setUpRightBarItemImage:Image(@"add") addTarget:self action:@selector(onRightBarItemTap)];
    
    self.searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.placeholder = @"搜索";
        searchBar.tintColor = [UIColor blackColor];
        searchBar.delegate = self;
        [searchBar sizeToFit];
        //        [self.view addSubview:searchBar];
        searchBar;
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        [tableView disableTouchesDelay];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[CXUserStateCell class] forCellReuseIdentifier:kCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = self.searchBar;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getUserList)];
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBar.text.length) {
        return self.filteredUsers.count;
    }
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXUserStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    CXSuperUserModel *user;
    if (self.searchBar.text.length) {
        user = self.filteredUsers[indexPath.row];
    }
    else {
        user = self.users[indexPath.row];
    }
    cell.avatarUrl = user.icon;
    cell.name = user.name;
    cell.dept = user.deptName;
    cell.job = user.job;
    cell.enable = user.superStatus == 1;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", searchText];
    self.filteredUsers = [self.users filteredArrayUsingPredicate:pred];
    [self.tableView reloadData];
}

#pragma mark - CXUserStateCellDelegate
- (void)userStateCell:(CXUserStateCell *)cell willChangeEnableState:(BOOL)enable atIndexPath:(NSIndexPath *)indexPath {
    CXSuperUserModel *userModel;
    if (self.searchBar.text.length) {
        userModel = self.filteredUsers[indexPath.row];
    }
    else {
        userModel = self.users[indexPath.row];
    }
    if (userModel.eid == [VAL_USERID integerValue] && [VAL_UserType integerValue] == 1) {
        CXAlert(@"不能对自己进行操作");
        return;
    }
    HUD_SHOW(nil);
    NSDictionary *params = @{
                             @"status": enable ? @1 : @0
                             };
    NSString *url = [NSString stringWithFormat:@"/sysuser/set/super/status/%zd.json", userModel.eid];
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            userModel.superStatus = enable ? 1 : 0;
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - Event
- (void)onLeftBarItemTap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightBarItemTap {
    CXSuperUserSelectViewController *vc = [[CXSuperUserSelectViewController alloc] init];
    vc.didSelectedUser = ^(CXSuperUserModel *user) {
        [self setSuperUser:user.eid];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getUserList {
    [HttpTool getWithPath:@"/sysuser/super/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.users = [NSArray yy_modelArrayWithClass:[CXSuperUserModel class] json:JSON[@"data"]];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.users.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.tableView.header endRefreshing];
    }];
}

- (void)setSuperUser:(NSInteger)userId {
    HUD_SHOW(nil);
    NSString *url = [NSString stringWithFormat:@"/sysuser/set/super/%zd.json", userId];
    [HttpTool postWithPath:url params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            [self.tableView.header beginRefreshing];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
