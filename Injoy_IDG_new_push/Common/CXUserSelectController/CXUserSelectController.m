//
//  CXUserSelectController.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXUserSelectController.h"
#import "CXUserSelectCell.h"
#import "HttpTool.h"
#import "YYModel.h"
#import "CXSubordinateUserModel.h"
#import "UIView+CXCategory.h"
#import "CXIDGBackGroundViewUtil.h"
#import "CXIMHelper.h"

@interface CXUserSelectController ()
        <
        UITableViewDelegate,
        UITableViewDataSource,
        UISearchDisplayDelegate
        >

/** 视图 */
@property(nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property(nonatomic, strong) NSArray<CXUserModel *> *users;
/** 已选中的索引 */
@property(nonatomic, strong) NSMutableArray<CXUserModel *> *internalSelectedUsers;
/// 搜索栏
@property(nonatomic, strong) UISearchBar *searchBar;
/// 搜索控制器
@property(nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property(copy, nonatomic) NSMutableArray *searchMembersArray;
@property(weak, nonatomic) SDRootTopView *rootTopView;
@end

@implementation CXUserSelectController

static NSString *const ID = @"cell";

#pragma mark - get & set

- (NSMutableArray *)searchMembersArray {
    if (nil == _searchMembersArray) {
        _searchMembersArray = [[NSMutableArray alloc] init];
    }
    return _searchMembersArray;
}

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.multiSelect = YES;
        self.displayOnly = NO;
        self.internalSelectedUsers = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setup];
    if (self.displayOnly) {
        self.users = self.selectedUsers;
        [self.tableView reloadData];
    } else {
        if (self.selectedUsers.count) {
            self.internalSelectedUsers = [self.selectedUsers mutableCopy];
        }
        [self getUsers];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, navHigh, GET_WIDTH(self.view), GET_HEIGHT(self.view) - navHigh);
}

- (void)setupNavView {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:self.title ?: @"用户选择"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    if (!self.displayOnly) {
        [rootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(applyOnTap)];
    }
}

- (void)setup {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 50;
        [tableView registerClass:[CXUserSelectCell class] forCellReuseIdentifier:ID];
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        tableView;
    });

    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    // 实例化搜索条
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, Screen_Width, 45);
    _searchBar.backgroundColor = [UIColor clearColor];

    _tableView.tableHeaderView = _searchBar;

    // 搜索控制器
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [_searchDisplayController.searchResultsTableView registerClass:[CXUserSelectCell class] forCellReuseIdentifier:ID];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
}

#pragma mark - Private

- (void)getUsers {
    HUD_SHOW(nil);
    NSString *url;
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.selectType == SubordinateType) {
        url = @"/sysUser/getUserByLevel.json";
    } else if (self.selectType == AllMembersType) {
        url = @"/sysuser/list.json";
    } else if (self.selectType == SuperiorType) {
        url = @"/sysuser/getUsersByCode.json";
        if (self.selectSuperior_eid != 0) {
            params[@"userId"] = @(self.selectSuperior_eid);
        }
    }
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] integerValue] == 200) {
            if (self.selectType == SubordinateType) {
                self.users = [NSArray yy_modelArrayWithClass:[CXSubordinateUserModel class] json:JSON[@"data"]];
            } else if (self.selectType == AllMembersType) {
                self.users = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:JSON[@"data"]];
            } else if (self.selectType == SuperiorType) {
                NSArray<NSDictionary *> *dataArray = JSON[@"data"];
                NSMutableArray<NSDictionary *> *dataArrayCopy = [NSMutableArray array];
                // 返回的字段是 userId/userName ，复制到 eid/name
                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
                    dict[@"eid"] = dict[@"userId"];
                    dict[@"name"] = dict[@"userName"];
                    // 过滤
                    if ([dict[@"eid"] integerValue] != self.selectSuperior_eid) {
                        [dataArrayCopy addObject:dict];
                    }
                }];
                self.users = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:dataArrayCopy];
            }
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.users.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self.tableView reloadData];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            CXAlert(JSON[@"msg"]);
        }
    }              failure:^(NSError *error) {
        HUD_HIDE;
        [self.navigationController popViewControllerAnimated:YES];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)applyOnTap {
    self.selectedUsers = self.internalSelectedUsers;
    !self.didSelectedCallback ?: self.didSelectedCallback(self.selectedUsers);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return self.users.count;
    }

    [_searchMembersArray removeAllObjects];
    NSInteger i = 0;
    for (CXUserModel *userModel in self.users) {
        NSRange range = [userModel.name rangeOfString:_searchBar.text];
        if (range.location != NSNotFound) {
            [_searchMembersArray addObject:userModel];
        }
        i++;
    }

    return self.searchMembersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXUserSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    CXUserModel *user = nil;
    if (tableView == _tableView) {
        user = self.users[indexPath.row];
        NSInteger selectedIndex = [self.internalSelectedUsers indexOfObjectPassingTest:^BOOL(CXUserModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return obj.eid == user.eid;
        }];
        cell.userSelected = selectedIndex != NSNotFound;
        cell.showSelect = !self.displayOnly;
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = self.searchMembersArray[indexPath.row];
        NSInteger selectedIndex = [self.internalSelectedUsers indexOfObjectPassingTest:^BOOL(CXUserModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            return obj.eid == user.eid;
        }];
        cell.userSelected = selectedIndex != NSNotFound;
        cell.showSelect = !self.displayOnly;
    }
    cell.userModel = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.displayOnly) {
        return;
    }

    CXUserModel *user = nil;

    if (tableView == _tableView) {
        user = self.users[indexPath.row];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = self.searchMembersArray[indexPath.row];
    }
    if (!self.multiSelect) {
        [self.internalSelectedUsers removeAllObjects];
    }
    NSInteger selectedIndex = [self.internalSelectedUsers indexOfObjectPassingTest:^BOOL(CXUserModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        return obj.eid == user.eid;
    }];
    BOOL hasSelected = selectedIndex != NSNotFound;
    if (hasSelected) {
        [self.internalSelectedUsers removeObjectAtIndex:selectedIndex];
    } else {
        [self.internalSelectedUsers addObject:user];
    }
    [tableView reloadData];

}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [self.view bringSubviewToFront:self.rootTopView];
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 45, tableView.frame.size.width, tableView.frame.size.height - 45);
    tableView.backgroundColor = SDBackGroudColor;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, CGFLOAT_MIN)];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 45, tableView.frame.size.width, tableView.frame.size.height + 45);
}

@end
