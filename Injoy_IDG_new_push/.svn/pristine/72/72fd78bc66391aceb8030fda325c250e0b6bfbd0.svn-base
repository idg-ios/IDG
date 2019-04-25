//
//  CXSuperUserSelectViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperUserSelectViewController.h"
#import "HttpTool.h"
#import "NSObject+YYModel.h"
#import "CXSuperUserSelectCell.h"
#import "UIView+CXCategory.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "CXIDGBackGroundViewUtil.h"

@interface CXSuperUserSelectViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

/** <#comment#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#comment#> */
@property (nonatomic, strong) UISearchBar *searchBar;
/** <#comment#> */
@property (nonatomic, copy) NSArray<CXSuperUserModel *> *users;
/** 搜索结果 */
@property (nonatomic, copy) NSArray<CXSuperUserModel *> *filteredUsers;
/** <#comment#> */
@property (nonatomic, strong) CXSuperUserModel *selectedUser;

@end

static NSString *const kCellId = @"CXSuperUserSelectCell";

@implementation CXSuperUserSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.tableView.header beginRefreshing];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"超级用户"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(leftBarItemOnTap)];
    [self.RootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(rightBarItemOnTap)];
    
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView disableTouchesDelay];
        [tableView registerClass:CXSuperUserSelectCell.class forCellReuseIdentifier:kCellId];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = self.searchBar;
        tableView.tableFooterView = [[UIView alloc] init];
        [tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getUserList)];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        }];
        tableView;
    });
}

- (void)getUserList {
    [HttpTool getWithPath:@"/sysuser/notsuper/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.selectedUser = nil;
            self.users = [NSArray yy_modelArrayWithClass:CXSuperUserModel.class json:JSON[@"data"]];
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
    CXSuperUserSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
//    [CXIDGBackGroundViewUtil coverSmallTextOnView:cell.contentView Frame:CGRectMake(arc4random()%80, 0, Screen_Width, 60) Text:VAL_USERNAME];
    
    if (self.searchBar.text.length) {
        cell.userModel = self.filteredUsers[indexPath.row];
    }
    else {
        cell.userModel = self.users[indexPath.row];
    }
//    cell.contentView.backgroundColor = [CXIDGBackGroundViewUtil colorWithSmallText:VAL_USERNAME];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar endEditing:YES];
    
    CXSuperUserModel *user;
    if (self.searchBar.text.length) {
         user = self.filteredUsers[indexPath.row];
    }
    else {
        user = self.users[indexPath.row];
    }
    if (self.selectedUser == user) {
        return;
    }
    self.selectedUser.selected = NO;
    user.selected = YES;
    self.selectedUser = user;
    [tableView reloadData];
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

#pragma mark - Event
- (void)leftBarItemOnTap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarItemOnTap {
    if (self.selectedUser == nil) {
        CXAlert(@"请选择一个用户");
        return;
    }
    !self.didSelectedUser ?: self.didSelectedUser(self.selectedUser);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
