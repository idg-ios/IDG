//
//  SDIMSelectColleaguesViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/4.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "AppDelegate.h"
#import "CXIMHelper.h"
#import "PinYin4Objc.h"
#import "SDChatManager.h"
#import "SDDataBaseHelper.h"
#import "SDDeleteGroupMemberCell.h"
#import "SDIMSelectColleaguesViewController.h"
#import "SDIMSelectDepartmentCell.h"

#define kSelectBtnHeight 40

@interface SDIMSelectColleaguesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

//导航栏
@property (nonatomic, strong) SDRootTopView* rootTopView;
//搜索栏
@property (nonatomic, strong) UISearchBar* searchBar;
//table
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* members;
//搜索到的群组成员数组
@property (nonatomic, strong) NSMutableArray* searchMembersArray;
//被选择的群组成员数组
@property (nonatomic, strong) NSMutableArray* selectedMembersArray;
//排序后的列表
@property (nonatomic, strong) NSMutableArray* sortedList;
//搜索控制器
@property (nonatomic, strong) UISearchDisplayController* sdc;
//同事数组
@property (nonatomic, strong) NSMutableArray* colleaguesArray;
//部门数组
@property (nonatomic, strong) NSMutableArray* departmentArray;
//客户数组
@property (nonatomic, strong) NSMutableArray* customerArray;
//选择类型
@property (nonatomic) SDIMSelectType selectType;

@property (nonatomic, strong) UIButton* selectWorkmateBtn;

@property (nonatomic, strong) UIButton* selectDepartmentBtn;

@property (nonatomic, strong) UIButton* selectClientBtn;
//选中的Btn下方有条线
@property (nonatomic, strong) UIView* lineView;

@end

@implementation SDIMSelectColleaguesViewController

#pragma mark - get & set

- (NSString*)navTitle
{
    if ([_navTitle length] == 0) {
        _navTitle = LocalString(@"发起群聊");
    }
    return _navTitle;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.colleaguesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.departmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.customerArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.searchMembersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedMembersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.members = [[NSMutableArray alloc] initWithCapacity:0];

    self.selectType = SDIMSelectColleaguesType;

    [self setUpUI];

    [self fetchDataSource];
}

#pragma mark - 内部方法
- (void)setUpUI
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:self.navTitle];

    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);

    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(determineBtnClick)];

    _selectWorkmateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectWorkmateBtn.frame = CGRectMake(0, navHigh, Screen_Width / 2, kSelectBtnHeight);
    _selectWorkmateBtn.selected = YES;
    [_selectWorkmateBtn setTitle:@"选同事" forState:UIControlStateNormal];
    [_selectWorkmateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_selectWorkmateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_selectWorkmateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _selectWorkmateBtn.backgroundColor = [UIColor whiteColor];
    _selectWorkmateBtn.tag = 101;
    [_selectWorkmateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_selectWorkmateBtn];

    _selectDepartmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectDepartmentBtn.frame = CGRectMake(Screen_Width / 2, navHigh, Screen_Width / 2, kSelectBtnHeight);
    _selectDepartmentBtn.selected = NO;
    [_selectDepartmentBtn setTitle:@"选部门" forState:UIControlStateNormal];
    [_selectDepartmentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_selectDepartmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_selectDepartmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _selectDepartmentBtn.backgroundColor = [UIColor whiteColor];
    _selectDepartmentBtn.tag = 102;
    [_selectDepartmentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_selectDepartmentBtn];

//    _selectClientBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _selectClientBtn.frame = CGRectMake(2 * Screen_Width / 3, navHigh, Screen_Width / 3, kSelectBtnHeight);
//    _selectClientBtn.selected = NO;
//    [_selectClientBtn setTitle:@"选客户" forState:UIControlStateNormal];
//    [_selectClientBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [_selectClientBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [_selectClientBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    _selectClientBtn.backgroundColor = [UIColor whiteColor];
//    _selectClientBtn.tag = 103;
//    [_selectClientBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:_selectClientBtn];

    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(0, navHigh + kSelectBtnHeight - 2, Screen_Width / 2, 2);
    _lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_lineView];

    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh + kSelectBtnHeight, Screen_Width, Screen_Height - navHigh - kSelectBtnHeight);

    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = SDCellHeight;
    //修改索引颜色
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];//修改右边索引的背景色
    _tableView.sectionIndexColor = kIDGSectionIndexColor;//修改右边索引字体的颜色
    _tableView.sectionIndexTrackingBackgroundColor = kIDGSectionIndexColor;//修改右边索引点击时候的背景色
    [self.view addSubview:_tableView];

    _tableView.backgroundColor = SDBackGroudColor;

    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    _tableView.tableFooterView = footerView;

    // 实例化搜索条
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, Screen_Width, 45);
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.placeholder = @"选同事";
    _tableView.tableHeaderView = _searchBar;

    // 搜索控制器
    _sdc = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _sdc.searchResultsDataSource = self;
    _sdc.searchResultsDelegate = self;
    _sdc.delegate = self;
}

- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)determineBtnClick
{
//    NSMutableArray* selectArray = [[NSMutableArray alloc] initWithCapacity:0];
//    if (self.selectType == SDIMSelectColleaguesType || self.selectType == SDIMSelectCustomerType) {
//        selectArray = [NSMutableArray arrayWithArray:[CXIMHelper imAccountArrayToModelArray:self.selectedMembersArray]];
//    }
//    else if (self.selectType == SDIMSelectDepartmentType) {
//        //从数据库拿回部门数组
//        NSMutableArray* allDepartmentArray = [[[SDChatManager sharedChatManager] deptArr] mutableCopy];
//
//        for (NSString* departmentName in self.selectedMembersArray) {
//            if ([departmentName isEqualToString:@"全公司"]) {
//                [selectArray removeAllObjects];
//                selectArray = [[[SDChatManager sharedChatManager] userContactAry] mutableCopy];
//                break;
//            }
//            else {
//                for (SDDepartmentModel* departmentModel in allDepartmentArray) {
//                    if ([departmentName isEqualToString:departmentModel.departmentName]) {
//                        [selectArray addObjectsFromArray:[[SDChatManager sharedChatManager] deptUserArr:[departmentModel.departmentId intValue]]];
//                    }
//                }
//            }
//        }
//    }
//    if (selectArray == nil || (selectArray != nil && [selectArray count] == 0)) {
//        TTAlert(@"请选择成员");
//    }
//    else {
//        if (self.filterUsersArray && [self.filterUsersArray count] > 0) {
//            for (SDCompanyUserModel* userModel in self.filterUsersArray) {
//                [selectArray removeObject:userModel];
//            }
//        }
//
//        __weak typeof(self) weakSelf = self;
//        [self dismissViewControllerAnimated:YES completion:^{
//            if (weakSelf.selectContactUserCallBack) {
//                weakSelf.selectContactUserCallBack([selectArray mutableCopy]);
//            }
//        }];
//    }
    
    
//    NSMutableArray* selectArray = [[NSMutableArray alloc] initWithCapacity:0];

    NSMutableArray* selectArray = [NSMutableArray arrayWithArray:[CXIMHelper imAccountArrayToModelArray:self.selectedMembersArray]];
    
    //从数据库拿回部门数组
    NSMutableArray* allDepartmentArray = [[[SDChatManager sharedChatManager] deptArr] mutableCopy];
    
    NSMutableArray * selectDpArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString* departmentName in self.selectedMembersArray) {
        if ([departmentName isEqualToString:@"全公司"]) {
            selectDpArray = [[[SDChatManager sharedChatManager] userContactAry] mutableCopy];
            break;
        }
        else {
            for (SDDepartmentModel* departmentModel in allDepartmentArray) {
                if ([departmentName isEqualToString:departmentModel.departmentName]) {
                    [selectDpArray addObjectsFromArray:[[SDChatManager sharedChatManager] deptUserArr:[departmentModel.departmentId intValue]]];
                }
            }
        }
    }
    [selectArray addObjectsFromArray:selectDpArray];
    
    if (selectArray == nil || (selectArray != nil && [selectArray count] == 0)) {
        TTAlert(@"请选择成员");
    }
    else {
        if (self.filterUsersArray && [self.filterUsersArray count] > 0) {
            for (SDCompanyUserModel* userModel in self.filterUsersArray) {
                [selectArray removeObject:userModel];
            }
        }
        
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.selectContactUserCallBack) {
                weakSelf.selectContactUserCallBack([selectArray mutableCopy]);
            }
        }];
    }
}

//选择各种列表的按钮点击事件
- (void)buttonClick:(id)sender
{
    _sdc.active = NO;
//    [_selectedMembersArray removeAllObjects];
    [_searchMembersArray removeAllObjects];

    [self showHudInView:self.view hint:@"正在加载数据"];
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 101) {
        _selectType = SDIMSelectColleaguesType;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(0, navHigh + kSelectBtnHeight - 2, Screen_Width / 2, 2);
        }];
        _selectWorkmateBtn.selected = YES;
        _selectDepartmentBtn.selected = NO;
        _selectClientBtn.selected = NO;
    }
    else if (btn.tag == 102) {
        _selectType = SDIMSelectDepartmentType;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(Screen_Width / 2, navHigh + kSelectBtnHeight - 2, Screen_Width / 2, 2);
        }];
        _selectWorkmateBtn.selected = NO;
        _selectDepartmentBtn.selected = YES;
        _selectClientBtn.selected = NO;
    }
    else if (btn.tag == 103) {
        _selectType = SDIMSelectCustomerType;
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = CGRectMake(2 * Screen_Width / 3, navHigh + kSelectBtnHeight - 2, Screen_Width / 3, 2);
        }];
        _selectWorkmateBtn.selected = NO;
        _selectDepartmentBtn.selected = NO;
        _selectClientBtn.selected = YES;
    }
    if (self.selectType == SDIMSelectColleaguesType) {
        _searchBar.placeholder = @"选同事";
    }
    else if (self.selectType == SDIMSelectDepartmentType) {
        _searchBar.placeholder = @"选部门";
    }
    else if (self.selectType == SDIMSelectCustomerType) {
        _searchBar.placeholder = @"选客户";
    }
    [self fetchDataSource];
    [self hideHud];
}

#pragma mark - 获取数据源
//从数据库获取各个列表的数据
- (void)fetchDataSource
{
    [self.members removeAllObjects];
    [self.sortedList removeAllObjects];
    [self.colleaguesArray removeAllObjects];
    [self.departmentArray removeAllObjects];
    if (self.selectType == SDIMSelectColleaguesType) {
        //从数据库获取本公司的所有用户(不包扩客服)
        NSMutableArray* allColleaguesArray = [[SDDataBaseHelper shareDB] getUserData];
        if (self.filterUsersArray && [self.filterUsersArray count] > 0) {
            for (SDCompanyUserModel* userModel in self.filterUsersArray) {
                [allColleaguesArray removeObject:userModel];
            }
        }
        for (SDCompanyUserModel* userModel in allColleaguesArray) {
            [self.colleaguesArray addObject:userModel.imAccount];
        }
        self.members = [NSMutableArray arrayWithArray:self.colleaguesArray];
    }
    else if (self.selectType == SDIMSelectDepartmentType) {
        //从数据库拿回部门数组
        NSMutableArray* allDepartmentArray = [[[SDChatManager sharedChatManager] deptArr] mutableCopy];
        for (SDDepartmentModel* departmentModel in allDepartmentArray) {
            [self.departmentArray addObject:departmentModel.departmentName];
        }
        self.members = [NSMutableArray arrayWithArray:self.departmentArray];
    }
    else if (self.selectType == SDIMSelectCustomerType) {
        //从数据库拿回客户数组
        NSMutableArray* allCustomerArray = [[SDDataBaseHelper shareDB] getExternalEmployeeAuthorityData];
        //把客户数组的环信ID加到一个数组里
        if (self.filterUsersArray && [self.filterUsersArray count] > 0) {
            for (SDCompanyUserModel* userModel in self.filterUsersArray) {
                [allCustomerArray removeObject:userModel];
            }
        }
        for (SDCompanyUserModel* userModel in allCustomerArray) {
            BOOL isIn = NO;
            for (NSString* user in self.customerArray) {
                if ([user isEqualToString:userModel.hxAccount]) {
                    isIn = YES;
                    break;
                }
            }
            if (!isIn) {
                [self.customerArray addObject:userModel.imAccount];
            }
        }
        self.members = [NSMutableArray arrayWithArray:self.customerArray];
    }
    //获得排序数据源
    [self initData];
    //排序
    [self sortArray];
}

//获得排序数据源
- (void)initData
{
    _sortedList = [NSMutableArray array];
    [_sortedList addObject:@{
        @"groupName" : @"#",
        @"list" : [NSMutableArray array]
    }];
    // 生成字母表
    for (NSInteger i = 65; i < 65 + 26; i++) {
        NSString* letter = [NSString stringWithFormat:@"%c", (char)i];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"groupName" : letter,
            @"list" : [NSMutableArray array]
        }];
        [_sortedList addObject:dict];
    }
}

- (void)sortArray
{
    //排序
    HanyuPinyinOutputFormat* outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];

    for (NSString* userName in _members) {
        NSString* realName = [CXIMHelper getRealNameByAccount:userName];
        if (self.selectType == SDIMSelectDepartmentType) {
            realName = [NSString stringWithFormat:@"%@", userName];
        }
        NSString* username = [realName substringToIndex:1];
        NSString* regex = @"^[A-Za-z\u4e00-\u9fa5]+$";
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        // 是字母或汉字
        BOOL isChineseOrLetter = [pred evaluateWithObject:username];
        NSInteger dictIndex = 0;
        if (isChineseOrLetter) {
            NSString* letter = [[[PinyinHelper toHanyuPinyinStringWithNSString:username withHanyuPinyinOutputFormat:outputFormat withNSString:@" "] substringToIndex:1] uppercaseString];
            dictIndex = [letter characterAtIndex:0] - 65 + 1;
        }
        NSMutableDictionary* dict = _sortedList[dictIndex];
        NSMutableArray* array = [dict objectForKey:@"list"];
        [array addObject:userName];
    }
    // 去空
    for (NSInteger i = _sortedList.count - 1; i >= 0; i--) {
        NSMutableDictionary* dict = _sortedList[i];
        NSArray* array = [dict objectForKey:@"list"];
        if (!array.count) {
            [_sortedList removeObjectAtIndex:i];
        }
    }

    //如果是部门列表要加上全公司
    if (self.selectType == SDIMSelectDepartmentType) {
        NSMutableDictionary* allCompanyMembersDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [allCompanyMembersDic setObject:@"★" forKey:@"groupName"];
        [allCompanyMembersDic setObject:@[ @"全公司" ] forKey:@"list"];
        [_sortedList insertObject:allCompanyMembersDic atIndex:0];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView != _tableView) {
        return 1;
    }
    return [_sortedList count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != _tableView) {
        [_searchMembersArray removeAllObjects];
        for (NSDictionary* listDic in _sortedList) {
            NSArray* nameArray = [listDic objectForKey:@"list"];
            for (NSString* nameString in nameArray) {
                NSString* realNameString = [CXIMHelper getRealNameByAccount:nameString];
                if (self.selectType == SDIMSelectDepartmentType) {
                    realNameString = [NSString stringWithFormat:@"%@", nameString];
                }
                NSRange range = [realNameString rangeOfString:_searchBar.text];
                if (range.location != NSNotFound) {
                    [_searchMembersArray addObject:nameString];
                }
            }
        }
        return [_searchMembersArray count];
    }
    return [[[_sortedList objectAtIndex:section] objectForKey:@"list"] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, Screen_Width, 14);
    backView.backgroundColor = SDBackGroudColor;
    UILabel* titleLable = [[UILabel alloc] init];
    titleLable.font = [UIFont systemFontOfSize:12];
    titleLable.frame = CGRectMake(0, 1, 200, 12);
    if (tableView != _tableView) {
        titleLable.text = @"  搜索结果";
    }
    else {
        titleLable.text = [NSString stringWithFormat:@"  %@", [[_sortedList objectAtIndex:section] objectForKey:@"groupName"]];
    }
    [backView addSubview:titleLable];
    return backView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.selectType == SDIMSelectDepartmentType) {
        static NSString* cellName = @"SDIMSelectDepartmentCell";
        SDIMSelectDepartmentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[SDIMSelectDepartmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        NSString* departmentName;
        BOOL isIn;
        if (tableView != _tableView) {
            departmentName = [_searchMembersArray objectAtIndex:indexPath.row];
            isIn = [_selectedMembersArray containsObject:departmentName];
        }
        else {
            departmentName = [[[_sortedList objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
            isIn = [_selectedMembersArray containsObject:departmentName];
        }
        [cell setDepartmentName:departmentName AndSelected:isIn];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else {
        static NSString* cellName = @"SDDeleteGroupMemberCell";
        SDDeleteGroupMemberCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[SDDeleteGroupMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        NSString* member;
        BOOL isIn;
        if (tableView != _tableView) {
            member = [_searchMembersArray objectAtIndex:indexPath.row];
            isIn = [_selectedMembersArray containsObject:member];
        }
        else {
            member = [[[_sortedList objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
            isIn = [_selectedMembersArray containsObject:member];
        }
        [cell setMember:member AndSelected:isIn];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* member = nil;
    if (tableView != _tableView) {
        member = [_searchMembersArray objectAtIndex:indexPath.row];
    }
    else {
        member = [[[_sortedList objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    }
    BOOL isIn = [_selectedMembersArray containsObject:member];
    if (isIn) {
        [_selectedMembersArray removeObject:member];
    }
    else {
        [_selectedMembersArray addObject:member];
    }
    if (tableView != _tableView) {
        [_tableView reloadData];
    }
    [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 添加索引条
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* indexArray = [[NSMutableArray alloc] init];

    // 加入搜索放大镜索引图标
    [indexArray addObject:UITableViewIndexSearch];

    for (NSDictionary* listDic in _sortedList) {
        [indexArray addObject:[listDic objectForKey:@"groupName"]];
    }
    return indexArray;
}

// 修改索引条和section对应关系
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    if (index == 0) {
        // 滚动到一个方块的位置
        [tableView scrollRectToVisible:_searchBar.frame animated:YES];
    }
    return index - 1;
}

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController*)controller willShowSearchResultsTableView:(UITableView*)tableView
{
    [self.view bringSubviewToFront:self.rootTopView];
    [self.view bringSubviewToFront:self.selectWorkmateBtn];
    [self.view bringSubviewToFront:self.selectDepartmentBtn];
    [self.view bringSubviewToFront:self.selectClientBtn];
    [self.view bringSubviewToFront:self.lineView];
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 45 + kSelectBtnHeight, tableView.frame.size.width, tableView.frame.size.height - 45 - kSelectBtnHeight);
    tableView.backgroundColor = SDBackGroudColor;

    UIView* footerView = [[UIView alloc] init];
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

- (void)searchDisplayController:(UISearchDisplayController*)controller willHideSearchResultsTableView:(UITableView*)tableView
{
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 45 - kSelectBtnHeight, tableView.frame.size.width, tableView.frame.size.height + 45 + kSelectBtnHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
