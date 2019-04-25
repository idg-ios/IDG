//
//  CXSuperRightsListViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperRightsListViewController.h"
#import "CXUserStateCell.h"
#import "UIView+CXCategory.h"
#import "CXColleagueFormViewController.h"
#import "HttpTool.h"
#import "CXSuperRightsUserModel.h"
#import "MJRefresh.h"
#import "CXNewColleagueListViewController.h"
#import "Masonry.h"

@interface CXSuperRightsListViewController () <UITableViewDataSource, UITableViewDelegate, CXUserStateCellDelegate, UISearchBarDelegate>

/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;
/** <#comment#> */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 用户数据 */
@property (nonatomic, copy) NSArray<CXSuperRightsUserModel *> *users;
/** 搜索结果 */
@property (nonatomic, copy) NSArray<CXSuperRightsUserModel *> *filteredUsers;
/** 新同事数量 */
@property (nonatomic, assign) NSInteger newCount;

@end

static NSString *const kNormalCellId = @"UITableViewCell";
static NSString *const kUserCellId = @"CXUserStateCell";

@implementation CXSuperRightsListViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self getNewColleaguesCount];
}

- (void)setup {
    [self.RootTopView setNavTitle: self.title ?: @"超级权限"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(onLeftBarItemTap)];
//    [self.RootTopView setUpRightBarItemImage:Image(@"add") addTarget:self action:@selector(onRightBarItemTap)];
    
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
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kNormalCellId];
        [tableView registerClass:[CXUserStateCell class] forCellReuseIdentifier:kUserCellId];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    if (self.searchBar.text.length) {
        return self.filteredUsers.count;
    }
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////    if (section == 0) {
////        return CGFLOAT_MIN;
////    }
//    return 15;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
//        cell.imageView.image = [UIImage imageNamed:@"new_colleagues"];
//        cell.textLabel.text = @"新同事";
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        static NSInteger kBadgeLabelTag = 100888;
//        UILabel *badgeLabel = [cell.contentView viewWithTag:kBadgeLabelTag];
//        if (badgeLabel == nil) {
//            badgeLabel = [[UILabel alloc] init];
//            badgeLabel.textAlignment = NSTextAlignmentCenter;
//            badgeLabel.adjustsFontSizeToFitWidth = YES;
//            badgeLabel.backgroundColor = [UIColor redColor];
//            badgeLabel.textColor = [UIColor whiteColor];
//            badgeLabel.tag = kBadgeLabelTag;
//            badgeLabel.layer.cornerRadius = 10;
//            badgeLabel.layer.masksToBounds = YES;
//            [cell.contentView addSubview:badgeLabel];
//            [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(20, 20));
//                make.centerX.equalTo(cell.imageView.mas_right);
//                make.centerY.equalTo(cell.imageView.mas_top);
//            }];
//        }
//        badgeLabel.text = @(self.newCount).stringValue;
//        badgeLabel.hidden = self.newCount == 0;
//        return cell;
//    }
//    else {
        CXUserStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserCellId];
        CXSuperRightsUserModel *userModel;
        if (self.searchBar.text.length) {
            userModel = self.filteredUsers[indexPath.row];
        }
        else {
            userModel = self.users[indexPath.row];
        }
        cell.avatarUrl = userModel.icon;
        cell.name = userModel.name;
        cell.dept = userModel.deptName;
        cell.job = userModel.job;
        cell.enable = userModel.status == 1;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
//    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.section == 0) {
//        // 新同事
//        CXNewColleagueListViewController *vc = [[CXNewColleagueListViewController alloc] init];
//        vc.onPostSuccess = ^{
//            [self.tableView.header beginRefreshing];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else {
//        CXSuperRightsUserModel *userModel = self.users[indexPath.row];
//        CXColleagueFormViewController *vc = [[CXColleagueFormViewController alloc] init];
//        vc.formType = CXFormTypeModify;
//        vc.eid = userModel.eid;
//        vc.didPostSuccess = ^{
//            [self.tableView.header beginRefreshing];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//    }
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
    CXSuperRightsUserModel *userModel;
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
    NSString *url = [NSString stringWithFormat:@"/sysuser/set/status/%zd.json", userModel.eid];
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            userModel.status = enable ? 1 : 0;
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
    CXColleagueFormViewController *vc = [[CXColleagueFormViewController alloc] init];
    vc.formType = CXFormTypeCreate;
    vc.didPostSuccess = ^{
        [self.tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (void)getUserList {
    [HttpTool getWithPath:@"/sysuser/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.users = [NSArray yy_modelArrayWithClass:[CXSuperRightsUserModel class] json:JSON[@"data"]];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.users.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"])
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.tableView.header endRefreshing];
    }];
}

/** 新同事数量 */
- (void)getNewColleaguesCount {
    [HttpTool postWithPath:@"/sysuser/new/num.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            self.newCount = [JSON[@"data"] integerValue];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
//            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
//        CXAlert(KNetworkFailRemind);
    }];
}

@end

