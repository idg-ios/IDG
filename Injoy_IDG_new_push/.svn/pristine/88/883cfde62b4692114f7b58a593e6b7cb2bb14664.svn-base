 //
//  SDSelectContactViewController.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  选择联系人

#import "SDSelectContactViewController.h"
#import "ChineseToPinyin.h"
#import "SDChatManager.h"
#import "SDPersonCell.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "SDCompanyUserModel.h"

@interface SDSelectContactViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate>
{
    NSString *jobRole;
    NSString *dpId;
}

@property (nonatomic, strong) SDRootTopView* rootTopView;
// 搜索条
@property (nonatomic, strong) UISearchBar* searchBar;
// 表格
@property (nonatomic, strong) UITableView* tableView;
// 数据源
@property (nonatomic, strong) NSMutableDictionary* dataSource;
// 联系人
@property (nonatomic, strong) NSMutableArray* contactsSource;
// 右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
@property (nonatomic, strong) SDDataBaseHelper* helper;
// 用户数据数组
@property (nonatomic, strong) NSArray* userContactAry;

@property (nonatomic, strong) NSMutableArray* approveUserDataAry;

/**
 *  使用条件是 选择审批人时，需要传入的条件1(1、只获取上级 2、获取管理层＋领导层＋业务层)
 */
@property (nonatomic, assign) int selectType;

@end

@implementation SDSelectContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [[NSMutableDictionary alloc] init];
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self setUpNavigationBar];
    [self setupTableView];
    
    jobRole = VAL_JobRole;
    if ([jobRole isEqualToString:@"normal_user"])
    {
//        if ([VAL_CurrentMenu isEqualToString:home_finance] && self.isCrossDept)
//        {
//            // 财务 可以选择：财务 1=上级
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
//            _selectType = 1;
//        }else if ([VAL_CurrentMenu isEqualToString:home_warehouse] && self.isPurchaseCrossDept)
//        {
//            // 仓库 可以选择：仓库 1=上级
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_ck"];
//            _selectType = 1;
//        }
//        else {
//            // 1=只获取上级,
//            _selectType = 1;
//        }
    }
//    else if ([jobRole isEqualToString:@"management_layer"] || [jobRole isEqualToString:@"secretary"])
//    {
//        NSLog(@"%@:%@",VAL_CurrentMenu,jobRole);
//        if (([VAL_CurrentMenu isEqualToString:home_sale] || [VAL_CurrentMenu isEqualToString:home_esale])&& self.isPurchaseCrossDept)
//        {   //销售工作或电商工作的退货先走仓库
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_ck"];
//            _selectType = 7;
//        }else if ([VAL_CurrentMenu isEqualToString:home_esale] || [VAL_CurrentMenu isEqualToString:home_market] || [VAL_CurrentMenu isEqualToString:home_sale])
//        {
//            // 销售、电商、采购、市场 可以选择：3=查询领导+财务业务+财务管理
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
//            _selectType = 3;
//        }else if ([VAL_CurrentMenu isEqualToString:home_sale])
//        {
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
//            _selectType = 3;
//        }
//        // 采购退货
//        else if ([VAL_CurrentMenu isEqualToString:home_purchase] && self.isCrossDept)
//        {
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
//            _selectType = 3;
//        }
//        // 采购业务
//        else if ([VAL_CurrentMenu isEqualToString:home_purchase] && self.isPurchaseCrossDept)
//        {
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_ck"];
//            _selectType = 7;
//        }
//        else if ([VAL_CurrentMenu isEqualToString:home_finance] && [VAL_CurrentYeWuMenu isEqualToString:@"市场业务"])
//        {
//            // 2=只获取领导 (财务工作里面的市场业务，走到财务管理之后，直接选领导)
//            _selectType = 2;
//        }
//        else if ([VAL_CurrentMenu isEqualToString:home_finance] && self.isCrossDept)
//        {
//            // 财务 可以选择：4=仓库业务/管理 + 财务管理
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_ck"];
//            _selectType = 4;
//        }else if ([VAL_CurrentMenu isEqualToString:home_warehouse] && self.isPurchaseCrossDept)
//        {
//            // 采购 可以选择：4=仓库业务/管理 + 财务管理
//            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
//            _selectType = 3;
//        }
//        else {
//            // 2=只获取领导
//            _selectType = 2;
//        }
//    }
    else if ([jobRole isEqualToString:@"company_manager"])
    {
        if ( self.isPurchaseCrossDept)
        {
            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_ck"];
            _selectType = 4;
        }
        // 采购退货
        else if ( self.isCrossDept)
        {
            dpId = [[SDDataBaseHelper shareDB] getUserDeptId:@"dp_cw"];
            _selectType = 3;
        }
        else
        {
            // 2=只获取领导
            _selectType = 2;
        }
    }
    
    // 审批人（所有管理层）
    self.userContactAry = [[SDDataBaseHelper shareDB] getUserDataWithJobRole:@"management_layer"];
    [self reloadTableSource:_userContactAry];
    
    // 我的任务执行人(所有人）
    if (_useCondition == isAllCompanyType) {
        // 选择人来自全公司
        self.userContactAry = [[SDDataBaseHelper shareDB] getUserData];
        [self reloadTableSource:_userContactAry];
    }
    
//    if (_useCondition == isApproveType) {
//        if (dpId.length == 0) {
//            dpId = VAL_DpId;
//        }
//        // 选择人是审批人
//        [self requestDataFromServer:dpId];
//    }
//    else if (_useCondition == isOwnDeptType)
//    {
//        // 选择人是本部门员工
//        self.userContactAry = [[SDDataBaseHelper shareDB] getUserDataByDpid:[VAL_DpId integerValue]];
//        [self reloadTableSource:_userContactAry];
//    }
//    else//if (_useCondition == allCompanyType)
//    {
//        // 选择人来自全公司
//        self.userContactAry = [[SDDataBaseHelper shareDB] getSendRangeUserData];
//        [self reloadTableSource:_userContactAry];
//    }
}
- (void)viewWillAppear:(BOOL)animated
{
    //    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    //    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    //    [tabBarVC setTabBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    [self reloadTableSource:_userContactAry];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
    //    RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
    //    [tabBarVC setTabBarHidden:NO animated:NO];
}

#pragma mark - UI
- (void)setUpNavigationBar
{
    _rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"请选择"];
    if (self.titleName)
    {
        [self.rootTopView setNavTitle:self.titleName];
    }
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];

    if (_isNeedSureBtn == YES) {
        [self.rootTopView setUpRightBarItemTitle:@"确定" addTarget:self action:@selector(rightBtnClick)];
    }
}

#pragma mark - Action
- (void)reloadTableSource:(NSArray*)sourceArr
{
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self setIndexSectionAry:nil];
    
    _helper = [SDDataBaseHelper shareDB];
    self.contactsSource = [NSMutableArray arrayWithArray:sourceArr];
    
    
    NSString* loginUserName = VAL_HXACCOUNT;
    
    if (!_isSelf)//不要包含自己
    {
        
        // 把好友加到数组中
        for (SDCompanyUserModel* model in sourceArr) {
            if (YES == [model.hxAccount isEqualToString:loginUserName]) {
                // 去掉登录用户
                [self.contactsSource removeObject:model];
            }
            // 如果不是超享公司，去掉叮当享团队
            if (![VAL_CompanyName isEqualToString:KOurCompanyAccount]) {
                if ([model.isKeFu  isEqual: @1])
                {
                    [self.contactsSource removeObject:model];
                }
            }
            
            if (self.applyUserID != nil) {
                if ([model.userId isEqualToNumber:self.applyUserID]) {
                    // 去掉发布申请用户
                    [self.contactsSource removeObject:model];
                }
            }
        }
    }
    
    NSMutableArray* indexTitleAry = [self indexSectionAry];
    
    __weak typeof(self) weakSelf = self;
    
    [indexTitleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [weakSelf.dataSource setValue:[NSMutableArray array] forKey:(NSString*)obj];
    }];
    
    for (NSString* firstLetter in indexTitleAry) {
        @autoreleasepool
        {
            // 字母对应的人员数组
            NSMutableArray* valAry = self.dataSource[firstLetter];
            for (SDCompanyUserModel* buddy in self.contactsSource) {
                if (![buddy.realName length]) {
                    continue;
                }
                if ([firstLetter isEqualToString:[[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)]]) {
                    if (![valAry containsObject:buddy]) {
                        [valAry addObject:buddy];
                    }
                }
                else if (0 == isalpha([[ChineseToPinyin pinyinFromChineseString:buddy.realName] UTF8String][0])) {
                    // 如果是#
                    NSMutableArray* tempAry = self.dataSource[@"#"];
                    if (NO == [tempAry containsObject:buddy]) {
                        [tempAry addObject:buddy];
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

/// 索引数组
- (NSMutableArray*)indexSectionAry
{
    if (nil == _indexSectionAry) {
        _indexSectionAry = [[NSMutableArray alloc] init];
        for (SDCompanyUserModel* buddy in _contactsSource) {
            if (![buddy.realName length]) {
                continue;
            }
            NSString* firstLetter = [[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)];
            
            if (0 == isalpha([firstLetter UTF8String][0])) {
                // 如果不是字母
                firstLetter = @"#";
            }
            
            if (NO == [_indexSectionAry containsObject:firstLetter]) {
                [_indexSectionAry addObject:firstLetter];
            }
        }
        // 按照字母升序
        [_indexSectionAry sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString*)obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        }];
    }
    
    return _indexSectionAry;
}

/// 增加的人员数组
- (NSArray*)hasAddPersonAry
{
    NSMutableArray* resultAry = [[NSMutableArray alloc] init];
    
    for (SDCompanyUserModel* userModel in [self hasSelectPersonAry]) {
        if (NO == [self.groupHasSelectPersonAry containsObject:userModel]) {
            [resultAry addObject:userModel];
        }
    }
    return resultAry;
}

/// 已选人员数组
- (NSMutableArray*)hasSelectPersonAry
{
    NSArray* hasSelectedIndexPath = self.tableView.indexPathsForSelectedRows;
    
    NSMutableArray* sourceAry = [[NSMutableArray alloc] initWithCapacity:[hasSelectedIndexPath count]];
    
    for (int i = 0; i < [hasSelectedIndexPath count]; i++) {
        NSIndexPath* currentIndexPath = hasSelectedIndexPath[i];
        SDCompanyUserModel* buddy = self.dataSource[self.indexSectionAry[currentIndexPath.section]][currentIndexPath.row];
        [sourceAry addObject:buddy];
    }
    
    return sourceAry;
}

#pragma mark - button点击事件
- (void)rightBtnClick
{
    if (_isSomeone) {
        if (self.selectContactArray) {
            self.selectContactArray(_selectArray);
        }
    }
    else {
        if (self.selectContactArray) {
            self.selectContactArray(_selectArray);
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView和变量
- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh + searchBar_Height, Screen_Width, Screen_Height - navHigh - searchBar_Height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.editing = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_tableView];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, searchBar_Height)];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return (NSInteger)[[self.dataSource allKeys] count];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[[self.dataSource valueForKey:self.indexSectionAry[section]] count];
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"cell";
    SDPersonCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[SDPersonCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:cellID];
        
        UIView *lineView = [[UIView alloc]  initWithFrame:CGRectMake(-20, 59, Screen_Width, 1.f)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        lineView.tag = 1000;
        [cell.contentView addSubview:lineView];
    }

    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    
    UIView *lineView = (UIView *)[cell.contentView viewWithTag:1000];
    if (indexPath.row + 1 == [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] count] && indexPath.section != [[self.dataSource allKeys] count])
    {
        lineView.hidden = YES;
    }else{
        lineView.hidden = NO;
    }

    cell.textLabel.text = oneBuddy.realName;
    cell.telephone = oneBuddy.telephone;
    cell.hxId = oneBuddy.hxAccount;
    cell.userID = [oneBuddy.userId intValue];
    cell.deptLabel.text = [[SDDataBaseHelper shareDB] getUserDept:[oneBuddy.userId integerValue]];

    NSString* headIconUrl = [_helper getHeadIconURL:[NSString stringWithFormat:@"%d", cell.userID]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", headIconUrl]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];

    if ([self.groupHasSelectPersonAry containsObject:oneBuddy]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    if (_selectArray) {
        for (SDCompanyUserModel* model in _selectArray) {
            if (cell.userID == [model.userId intValue]) {
                [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }

    if (self.model) {
        if (cell.userID == [self.model.userId intValue]) {
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }

    if (cell.userID == self.linkId) {
        [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}
- (NSIndexPath*)tableView:(UITableView*)tableView willDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    if (YES == [self.groupHasSelectPersonAry containsObject:oneBuddy]) {
        return nil;
    }
    else {
        return indexPath;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];

    if (_isNeedSureBtn == YES) {
        [_selectArray addObject:oneBuddy];
    }
    else {
        [self.sharePerson addObject:oneBuddy.userId];
        if (self.selectCallBackContactModel) {
            self.selectCallBackContactModel(oneBuddy);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    NSMutableArray* deletaAry = [NSMutableArray arrayWithArray:self.sharePerson];
    for (NSNumber* userID in deletaAry) {
        if ([oneBuddy.userId intValue] == [userID intValue]) {
            [self.sharePerson removeObject:userID];
        }
    }
    // [self.sharePerson removeObjectsInArray:deletaAry];

    NSMutableArray* arr = [NSMutableArray arrayWithArray:_selectArray];

    for (SDCompanyUserModel* model in arr) {
        if ([model.userId intValue] == [oneBuddy.userId intValue]) {
            [_selectArray removeObject:oneBuddy];
        }
    }
}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 返回可以编辑
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14.f;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_Width, 14)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lable.text = [NSString stringWithFormat:@"  %@", [self.indexSectionAry[section] uppercaseString]];
    lable.font = [UIFont systemFontOfSize:12.0f];
    return lable;
}
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    _sharePerson = [NSMutableArray array];
    //  [self reloadTableSource];
    return [self.indexSectionAry valueForKey:@"uppercaseString"];
}
//- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.indexSectionAry[section] uppercaseString];
//}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText; // called when text changes (including clear)
{
    if (0 == [searchText length]) {
        [self reloadTableSource:self.userContactAry];
        [self.tableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    NSMutableArray* resultArr = [[NSMutableArray alloc] init];

    for (SDCompanyUserModel* userModel in self.userContactAry) {
        if ([userModel.realName rangeOfString:[searchBar text] options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [resultArr addObject:userModel];
        }
    }
    [searchBar resignFirstResponder];
    [self reloadTableSource:resultArr];
    [self.tableView reloadData];
}

#pragma mark - 网络访问
- (void)requestDataFromServer:(NSString *)dpid
{
    NSString *url = [NSString stringWithFormat:@"%@contact/approval/%d/%@/",urlPrefix,_selectType,dpid];
    [_approveUserDataAry removeAllObjects];
    [HttpTool getWithPath:url
                   params:nil
                  success:^(id JSON)
     {
         _approveUserDataAry = [NSMutableArray array];
         NSDictionary* dic = JSON;
         NSNumber* status = dic[@"status"];
         id msg = dic[@"msg"];
         NSString *message = [NSString stringWithFormat:@"%@", msg];
         if ([message isEqualToString:@"<null>"]) {
             message = @"";
         }
         if ([status intValue] == 200)
         {
             for (NSDictionary *dict in dic[@"users"])
             {
                 SDCompanyUserModel* userModel = [[SDCompanyUserModel alloc] init];
                 userModel.userId = dict[@"userId"];
                 userModel.realName = dict[@"name"];
                 userModel.jobRole = dict[@"jobRole"];
                 userModel.dpName = dict[@"dpName"];
                 [_approveUserDataAry addObject:userModel];
             }
             _userContactAry = _approveUserDataAry;
             [self reloadTableSource:_userContactAry];
             [self.tableView reloadData];
         }
         else {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }
     }
    failure:^(NSError* error) {
      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
    }];
}

@end
