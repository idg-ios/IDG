//
//  CXShareSelectContactViewController.m
//  InjoyERP
//
//  Created by wtz on 16/12/1.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXShareSelectContactViewController.h"
#import "CXIMHelper.h"
#import "ChineseToPinyin.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "SDChatManager.h"
#import "SDContactsDetailController.h"
#import "SDDataBaseHelper.h"
#import "SDIMChatViewController.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "YYModel.h"
#import "CXSendShareView.h"
#import "CXSuperSearchGroupListViewController.h"

#define kBadgeImageWidth 10.0

@interface CXShareSelectContactViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate>

//导航栏
@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UISearchBar* mySearchBar;
//数据源
@property (nonatomic, strong) NSMutableDictionary* dataSource;
//是否是搜索的
@property (nonatomic) BOOL isFromSearch;
//联系人数据源
@property (nonatomic, strong) NSMutableArray* contactsSource;
//右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
//第一个section数组
@property (nonatomic, strong) NSMutableArray* firstSectionAry;
//第一个section图片数组
@property (nonatomic, strong) NSMutableArray* firstSectionImageAry;
//sectionTitle数组
@property (nonatomic, strong) NSMutableArray* sectionIndexTitlesArr;
//搜索的数据源
@property (nonatomic, strong) NSMutableArray* searchArray;

@property (nonatomic, strong) CXSendShareView * sendShareView;

@end

@implementation CXShareSelectContactViewController

#pragma mark - 懒加载
//索引数组
- (NSMutableArray*)indexSectionAry
{
    _indexSectionAry = [[NSMutableArray alloc] init];
    for (SDCompanyUserModel* buddy in _contactsSource) {
        NSString* firstLetter = [[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)];
        if([buddy.realName length] > 0){
            if (0 == isalpha([firstLetter UTF8String][0])) {
                // 如果不是字母
                firstLetter = @"#";
            }
            
            if (![_indexSectionAry containsObject:firstLetter]) {
                [_indexSectionAry addObject:firstLetter];
            }
        }
    }
    // 按照字母升序
    [_indexSectionAry sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    
    if ([_indexSectionAry containsObject:@"#"]) {
        [_indexSectionAry removeObject:@"#"];
        [_indexSectionAry addObject:@"#"];
    }
    [_indexSectionAry insertObject:@"↑" atIndex:0];
    
    return _indexSectionAry;
}

- (NSMutableArray*)firstSectionImageAry
{
    _firstSectionImageAry = [[NSMutableArray alloc] initWithObjects:@"CXGroupChat", nil];
    return _firstSectionImageAry;
}

/// 第一个section数组
- (NSMutableArray*)firstSectionAry
{
    _firstSectionAry = [[NSMutableArray alloc] initWithObjects:@"工作群聊", nil];
    return _firstSectionAry;
}

- (NSArray*)sectionIndexTitlesArr
{
    NSMutableArray* retArr = [[NSMutableArray alloc] init];
    [retArr addObject:@"↑"];
    for (int i = 65; i < 65 + 26; i++) {
        [retArr addObject:[NSString stringWithFormat:@"%C", (unichar)i]];
    }
    [retArr addObject:@"#"];
    _sectionIndexTitlesArr = [retArr copy];
    return _sectionIndexTitlesArr;
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mySearchBar.text == nil || (self.mySearchBar.text != nil && [self.mySearchBar.text length] <= 0)) {
        [self.mySearchBar setShowsCancelButton:NO];
    }
    RDVTabBarController* vc = [AppDelegate get_RDVTabBarController];
    if (VAL_SHOW_ADD_FRIENDS) {
        [vc.tabBar.items[1] setBadgeValue:@" "];
    }
    else {
        [vc.tabBar.items[1] setBadgeValue:@""];
    }
    [self refreshTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadContact) name:receiveNewAddFriendApplicationApplyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadContact) name:receiveEmployeeTurnoverNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:receiveHadAddFriendNotification object:nil];
    
    _dataSource = [[NSMutableDictionary alloc] init];
    _contactsSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setUpView];
    
    [self downloadContact];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 内部方法
- (void)setUpView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"通讯录")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66, Screen_Width, Screen_Height - 66) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60.0;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 索引背景透明
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_tableView];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downloadContact)];
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10.f, Screen_Width, 44)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.placeholder = @"请输入您要搜索的人名";
    self.tableView.tableHeaderView = self.mySearchBar;
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取通讯录数据源
- (void)downloadContact
{
    SDDataBaseHelper* helper = [SDDataBaseHelper shareDB];
    
    if ([helper deleteAllTable]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString* url = [NSString stringWithFormat:@"%@/main/allUsers", urlPrefix];
        __weak typeof(self) wself = self;
        [self showHudInView:self.view hint:@"正在加载数据"];
        [HttpTool postWithPath:url
                        params:nil
                       success:^(id JSON) {
                           [wself hideHud];
                           NSDictionary* dic = JSON;
                           NSNumber* status = dic[@"status"];
                           if ([status intValue] == 200) {
                               // 保存到本地
                               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                   NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                                   NSMutableArray *data = @[].mutableCopy;
                                   for (NSDictionary *u in JSON[@"data"]) {
                                       NSMutableDictionary *mutableU = u.mutableCopy;
                                       if ([mutableU[@"icon"] isKindOfClass:NSNull.class]) {
                                           mutableU[@"icon"] = @"";
                                       }
                                       [data addObject:mutableU];
                                   }
                                   [[CXLoaclDataManager sharedInstance] saveLocalFriendsDataWithFriends:JSON[@"data"]];
                                   
                                   for (NSDictionary* userDic in JSON[@"data"]) {
                                       SDCompanyUserModel* userModel = [SDCompanyUserModel yy_modelWithDictionary:userDic];
                                       userModel.userId = @([userDic[@"userId"] integerValue]);
                                       [helper insertCompanyUser:userModel];
                                   }
                                   
                                   [userDefaults synchronize];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       wself.isFromSearch = NO;
                                       [wself.mySearchBar resignFirstResponder];
                                       wself.mySearchBar.text = @"";
                                       [wself refreshTable];
                                   });
                               });
                               
                           }
                           else{
                               [wself hideHud];
                               [wself.view makeToast:JSON[@"msg"] duration:2.0 position:@"center"];
                           }
                           [_tableView.legendHeader endRefreshing];
                       }
                       failure:^(NSError* error) {
                           [wself hideHud];
                           [_tableView.legendHeader endRefreshing];
                           TTAlertNoTitle(KNetworkFailRemind);
                       }];
        
    }
}

#pragma mark 刷新通讯录数据table
- (void)refreshTable
{
    NSArray* sourceAry = [NSArray arrayWithArray:[[CXLoaclDataManager sharedInstance] getContacts]];
    [self.indexSectionAry removeAllObjects];
    self.indexSectionAry = nil;
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    self.contactsSource = [NSMutableArray arrayWithArray:sourceAry];
    for (SDCompanyUserModel* model in sourceAry) {
        if ([model.imAccount isEqualToString:VAL_HXACCOUNT]) {
            // 去掉登录用户
            [self.contactsSource removeObject:model];
        }
    }
    NSMutableArray* indexTitleAry = [self indexSectionAry];
    __weak typeof(self) weakSelf = self;
    [indexTitleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [weakSelf.dataSource setValue:[NSMutableArray array] forKey:(NSString*)obj];
    }];
    [self.dataSource setValue:self.firstSectionAry forKey:@"↑"];
    
    for (NSString* firstLetter in indexTitleAry) {
        @autoreleasepool {
            // 字母对应的人员数组
            NSMutableArray* valAry = self.dataSource[firstLetter];
            for (SDCompanyUserModel* buddy in self.contactsSource) {
                if ([firstLetter isEqualToString:[[[ChineseToPinyin pinyinFromChineseString:buddy.realName] lowercaseString] substringWithRange:NSMakeRange(0, 1)]]) {
                    if (![valAry containsObject:buddy]) {
                        [valAry addObject:buddy];
                    }
                }
                else if ([buddy.realName length] > 0 && 0 == isalpha([[ChineseToPinyin pinyinFromChineseString:buddy.realName] UTF8String][0])) {
                    // 如果是#
                    NSMutableArray* tempAry = self.dataSource[@"#"];
                    if (NO == [tempAry containsObject:buddy]) {
                        [tempAry addObject:buddy];
                    }
                }
            }
        }
    }

    [self sectionIndexTitlesArr];
    [self indexSectionAry];
    [self firstSectionAry];
    [self firstSectionImageAry];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return (NSInteger)[[self.dataSource allKeys] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isFromSearch) {
        return (NSInteger)[[self.dataSource valueForKey:self.indexSectionAry[section]] count];
    }
    else {
        return self.searchArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellName = @"CellName";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        for (UIView* subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    //头像
    UIImageView* headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    [cell.contentView addSubview:headImageView];
    
    //部门
    UILabel* departmentLabel = [[UILabel alloc] init];
    departmentLabel.font = [UIFont systemFontOfSize:13.0];
    departmentLabel.textColor = [UIColor blackColor];
    departmentLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:departmentLabel];
    
    //名字
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:nameLabel];
    
    if (!self.isFromSearch) {
        if (indexPath.section == 0) {
            headImageView.image = [UIImage imageNamed:self.firstSectionImageAry[indexPath.row]];
            headImageView.highlightedImage = [UIImage imageNamed:self.dataSource[self.indexSectionAry[indexPath.section]][indexPath.row]];
            
            nameLabel.text = self.dataSource[self.indexSectionAry[indexPath.section]][indexPath.row];
            nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, 300, SDMainMessageFont);
        }
        else {
            SDCompanyUserModel* userModel = self.dataSource[self.indexSectionAry[indexPath.section]][indexPath.row];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
            [departmentLabel sizeToFit];
            departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
            departmentLabel.y = (SDCellHeight - 13) / 2;
            
            nameLabel.text = userModel.realName;
            nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, SDMainMessageFont);
        }
    }
    else {
        SDCompanyUserModel* userModel = self.searchArray[indexPath.row];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [departmentLabel sizeToFit];
        departmentLabel.x = Screen_Width - 15 - SDHeadImageViewLeftSpacing - departmentLabel.frame.size.width;
        departmentLabel.y = (SDCellHeight - 13) / 2;
        
        nameLabel.text = userModel.realName;
        nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, departmentLabel.x - CGRectGetMaxX(headImageView.frame) - SDHeadImageViewLeftSpacing - SDHeadImageViewLeftSpacing, 13);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 14;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 14)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (!self.isFromSearch) {
        NSString* title = [self.indexSectionAry[section] uppercaseString];
        lable.text = [NSString stringWithFormat:@"  %@", title];
        lable.font = [UIFont systemFontOfSize:12.0f];
        if ([title isEqualToString:@"↑"]) {
            lable.text = @"";
        }
    }
    else {
        lable.text = nil;
    }
    return lable;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    if (!self.isFromSearch) {
        return [self sectionIndexTitlesArr];
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [[self.indexSectionAry valueForKey:@"uppercaseString"] indexOfObject:title];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isFromSearch) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                CXSuperSearchGroupListViewController* groupChatVC = [[CXSuperSearchGroupListViewController alloc] init];
                groupChatVC.shareTitle = self.shareTitle;
                groupChatVC.shareContent = self.shareContent;
                groupChatVC.shareUrl = self.shareUrl;
                [self.navigationController pushViewController:groupChatVC animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
        }
        else {
            SDCompanyUserModel* userModel = self.dataSource[self.indexSectionAry[indexPath.section]][indexPath.row];
            userModel.name = userModel.realName;
            self.sendShareView = [[CXSendShareView alloc] initWithShareTitle:_shareTitle AndShareUser:userModel AndCXGroupInfo:nil AndShareContent:_shareContent AndShareUrl:_shareUrl AndController:self];
        }
    }
    else {
        SDCompanyUserModel* userModel = self.dataSource[self.indexSectionAry[indexPath.section]][indexPath.row];
        userModel.name = userModel.realName;
        self.sendShareView = [[CXSendShareView alloc] initWithShareTitle:_shareTitle AndShareUser:userModel AndCXGroupInfo:nil AndShareContent:_shareContent AndShareUrl:_shareUrl AndController:self];
    }
}

- (NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.mySearchBar resignFirstResponder];
    return indexPath;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar setShowsCancelButton:YES];
    return YES;
}

//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:NO];
    self.mySearchBar.text = nil;
    self.isFromSearch = NO;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    //搜索内容随着输入及时地显示出来
    if ([searchText length] == 0) {
        [self.mySearchBar setShowsCancelButton:NO];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = NO;
        [self.tableView reloadData];
        return;
    }
    else {
        [self.mySearchBar setShowsCancelButton:YES];
        UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
        _mySearchBar.tintColor = [UIColor blackColor];
        self.isFromSearch = YES;
        [self handleSearchBarContent:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    UIButton* btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(3, 4, 0, -4)];
    _mySearchBar.tintColor = [UIColor blackColor];
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:YES];
    [self handleSearchBarContent:searchBar.text];
}

#pragma mark 重新加载搜索到数据
- (void)handleSearchBarContent:(NSString*)searchStr
{
    NSMutableArray* searchDataSource = [NSMutableArray array];
    for (SDCompanyUserModel* userModel in self.contactsSource) {
        if ([NSString containWithSelectedStr:userModel.realName contain:searchStr]) {
            [searchDataSource addObject:userModel];
        }
    }
    self.searchArray = searchDataSource;
    [self.tableView reloadData];
}

@end
