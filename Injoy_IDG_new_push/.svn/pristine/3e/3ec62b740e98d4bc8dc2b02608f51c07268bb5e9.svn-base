//
//  CXFocusSignMembersViewController.m
//  SDMarketingManagement
//
//  Created by lancely on 4/22/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXFocusSignMembersViewController.h"
#import "UIView+Category.h"
#import "CXFocusSignMemberCell.h"
#import "SDDataBaseHelper.h"
#import "PinYin4Objc.h"
#import "UIColor+Category.h"
#import "SDContactsDetailController.h"
#import "CXIMHelper.h"
#import "SDIMPersonInfomationViewController.h"

@interface CXFocusSignMembersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

// 控件
@property (nonatomic, strong) SDRootTopView *rootTopView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchDisplayController *displayController;

// 数据

@property (nonatomic, strong) NSArray<NSDictionary *> *sections;

/**
 *  索引标题
 */
@property (nonatomic, strong) NSMutableArray *indexTitles;

/**
 *  记录是否选择
 */
@property (nonatomic, strong) NSMutableDictionary<SDCompanyUserModel *, NSNumber *> *selections;

/**
 *  用户模型
 */
@property (nonatomic, strong) NSMutableArray<SDCompanyUserModel *> *userModels;

/**
 *  选中的用户（用户模型）
 */
@property (nonatomic, strong) NSMutableArray<SDCompanyUserModel *> *selectedUsers;

/**
 *  未选中的用户（用户模型）
 */
@property (nonatomic, strong) NSMutableArray<SDCompanyUserModel *> *unselectedUsers;

@property (nonatomic, copy) DidTapDeleteBtnCallback tapDeleteBtnCallback;

@end

@implementation CXFocusSignMembersViewController

static NSString *cellID = @"CXFocusSignMemberCell";

#pragma mark - Lazy-Load
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.y = CGRectGetMaxY(self.rootTopView.frame);
        _searchBar.width = Screen_Width;
        _searchBar.height = 44;
        _searchBar.x = 0;
        _searchBar.placeholder = @"搜索";
        _searchBar.showsCancelButton = YES;
        UISearchDisplayController *displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        [displayController.searchResultsTableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        displayController.searchResultsDelegate = self;
        displayController.searchResultsDataSource = self;
        displayController.delegate = self;
        self.displayController = displayController;
    }
    return _searchBar;
}

- (NSArray<NSDictionary *> *)sections {
    if (!_sections) {
        _sections = [NSArray array];
    }
    return _sections;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.x = 0;
        _tableView.y = CGRectGetMaxY(self.searchBar.frame);
        _tableView.width = Screen_Width;
        _tableView.height = Screen_Height - _tableView.y;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //修改索引颜色
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
        _tableView.sectionIndexColor = kIDGSectionIndexColor;//修改右边索引字体的颜色
        _tableView.sectionIndexTrackingBackgroundColor = kIDGSectionIndexColor;//修改右边索引点击时候的背景色
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        _tableView.rowHeight = SDCellHeight;
    }
    return _tableView;
}

- (NSMutableDictionary<SDCompanyUserModel *, NSNumber *> *)selections {
    if (!_selections) {
        _selections = [NSMutableDictionary dictionary];
    }
    return _selections;
}

- (NSMutableArray<SDCompanyUserModel *> *)userModels {
    if (!_userModels) {
        _userModels = [NSMutableArray array];
    }
    return _userModels;
}

- (NSMutableArray<SDCompanyUserModel *> *)selectedUsers {
    if (!_selectedUsers) {
        _selectedUsers = [NSMutableArray array];
    }
    return _selectedUsers;
}

- (NSMutableArray<SDCompanyUserModel *> *)unselectedUsers {
    if (!_unselectedUsers) {
        _unselectedUsers = [NSMutableArray array];
    }
    return _unselectedUsers;
}

#pragma mark - SET方法
- (void)setUsers:(NSArray<NSNumber *> *)users {
    self->_users = users;
    
    [self.userModels removeAllObjects];
    [self.selections removeAllObjects];
    for (NSNumber *userId in users) {
        SDCompanyUserModel *userModel = [[SDDataBaseHelper shareDB] getUserByUserID:userId.stringValue];
        if (userModel.userId) {
            [self.userModels addObject:userModel];
            self.selections[userModel] = @(NO);
        }
    }
    
    self.sections = [self getSectionsWithUserModels:self.userModels];
}

#pragma mark - 外部方法
- (void)setDidTapDeleteBtnCallback:(DidTapDeleteBtnCallback)callback {
    self.tapDeleteBtnCallback = callback;
}

#pragma mark - Life-Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopView];
    [self setupView];
}

- (void)setupTopView {
    SDRootTopView *topView = [self getRootTopView];
    [topView setUpLeftBarItemImage:[UIImage imageNamed:@"back"] addTarget:self action:@selector(backBtnTapped)];
    if (self.presentMode == CXFocusSignMembersPresentModeDisplay) {
        [topView setNavTitle:@"全部成员"];
    }
    else {
        [topView setNavTitle:@"编辑标签"];
        [topView setUpRightBarItemTitle:@"删除" addTarget:self action:@selector(deleteBtnTapped)];
    }
    self.rootTopView = topView;
}

- (void)setupView {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - Action

// rootTopView左边按钮
- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

// rootTopView右边按钮
- (void)deleteBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
    [self.selectedUsers removeAllObjects];
    [self.unselectedUsers removeAllObjects];
    
    [self.selections enumerateKeysAndObjectsUsingBlock:^(SDCompanyUserModel * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        // 选中的
        if (obj.boolValue) {
            [self.selectedUsers addObject:key];
        }
        // 没选中的
        else {
            [self.unselectedUsers addObject:key];
        }
    }];
    
    if (self.tapDeleteBtnCallback) {
        self.tapDeleteBtnCallback(self.selectedUsers, self.unselectedUsers);
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<SDCompanyUserModel *> *userModels = self.sections[section][@"list"];
    return userModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXFocusSignMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.allowChecked = self.presentMode == !CXFocusSignMembersPresentModeDisplay;
    NSArray<SDCompanyUserModel *> *userModels = self.sections[indexPath.section][@"list"];
    cell.userModel = userModels[indexPath.row];
    cell.checked = self.selections[cell.userModel].boolValue;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    for (NSDictionary *dict in self.sections) {
        [titles addObject:dict[@"title"]];
    }
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.presentMode == CXFocusSignMembersPresentModeDelete){
        SDCompanyUserModel *key = self.sections[indexPath.section][@"list"][indexPath.row];
        self.selections[key] = @(!self.selections[key].boolValue);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        SDCompanyUserModel *key = self.sections[indexPath.section][@"list"][indexPath.row];
        
        if([key.imAccount isEqualToString:VAL_HXACCOUNT]){
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.canPopViewController = YES;
            pivc.imAccount = key.imAccount;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }else{
            SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
            pivc.imAccount = [[CXIMHelper userIdArrayToModelArray:@[key.userId]] lastObject].imAccount;
            pivc.canPopViewController = YES;
            [self.navigationController pushViewController:pivc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.sections = [self getSectionsWithUserModels:self.userModels];
    [self.tableView reloadData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.realName CONTAINS[cd] %@", searchString];
    NSArray<SDCompanyUserModel *> *filteredUserModels = [self.userModels filteredArrayUsingPredicate:predicate];
    self.sections = [self getSectionsWithUserModels:filteredUserModels];
    return YES;
}

#pragma mark - 数据处理
- (NSArray<NSDictionary *> *)getSectionsWithUserModels:(NSArray<SDCompanyUserModel *> *)userModels {
    NSMutableArray<NSDictionary *> *sections = [NSMutableArray array];
    for (char i = 'A'; i <= 'Z'; i++) {
        NSString *ch = [NSString stringWithFormat:@"%c", i];
        [sections addObject:@{
           @"title":ch,
           @"list":[NSMutableArray array]
        }];
    }
    [sections addObject:@{
        @"title":@"#",
        @"list":[NSMutableArray array]
    }];
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    for(SDCompanyUserModel *userModel in userModels){
        NSString *firstLetter = [userModel.realName substringToIndex:1];
        NSString *regex = @"^[A-Za-z\u4e00-\u9fa5]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        // 是字母或汉字
        BOOL isChineseOrLetter = [pred evaluateWithObject:firstLetter];
        NSInteger dictIndex = sections.count - 1; // 默认在"#"组
        if (isChineseOrLetter) {
            NSString *letter = [[[PinyinHelper toHanyuPinyinStringWithNSString:firstLetter withHanyuPinyinOutputFormat:outputFormat withNSString:@" "] substringToIndex:1] uppercaseString];
            dictIndex = [letter characterAtIndex:0] - 'A';
        }
        NSDictionary *dict = sections[dictIndex];
        NSMutableArray *array = [dict objectForKey:@"list"];
        [array addObject:userModel];
    }
    // 去除空的组
    for (NSInteger i = sections.count - 1; i >= 0; i--) {
        NSDictionary *dict = sections[i];
        NSArray *array = [dict objectForKey:@"list"];
        if (!array.count) {
            [sections removeObjectAtIndex:i];
        }
    }
    
    return sections;
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.backgroundColor = SDBackGroudColor;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    tableView.tableFooterView = footerView;
    
    //修复UITableView的分割线偏移的BUG
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
