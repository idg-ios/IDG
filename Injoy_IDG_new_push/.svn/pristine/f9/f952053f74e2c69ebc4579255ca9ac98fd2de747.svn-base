//
//  SDScopeTableViewController.m
//  SDMarketingManagement
//
//  Created by 宝嘉 on 15/6/6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDScopeTableViewController.h"
#import "SDScopeTableViewCell.h"
#import "SDDataBaseHelper.h"

#import "UIImageView+EMWebCache.h"
#import "ChineseToPinyin.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDContactsDetailController.h"
#import "SDContactsDetailController.h"
#import "AppDelegate.h"

@interface SDScopeTableViewController () <UITableViewDataSource,
    UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) SDDataBaseHelper* helper;
@property (nonatomic, strong) NSMutableDictionary* dataSource;
/// 联系人
@property (nonatomic, strong) NSMutableArray* contactsSource;
/// 右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
@property (nonatomic, strong) UITableView* tableView;
/// 搜索框
@property (nonatomic, strong) UISearchBar* searchBar;
/// 全部联系人
@property (nonatomic, strong) NSArray* userContactAry;

@property (nonatomic, strong) SDCompanyUserModel* oneBuddy;
/// 刷新数据源
- (void)reloadTableSource:(NSArray*)sourceArr;
- (void)setUpContentView;
@end

@implementation SDScopeTableViewController

- (NSMutableArray*)contactsSource
{
    if (nil == _contactsSource) {
        _contactsSource = [[NSMutableArray alloc] init];
    }
    return _contactsSource;
}

- (NSMutableDictionary*)dataSource
{
    if (nil == _dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    return _dataSource;
}

/// 搜索框
- (UISearchBar*)searchBar
{
    if (nil == _searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, 40)];
        _searchBar.placeholder = @"搜姓名";
        _searchBar.delegate = self;
        //UseAutoLayout(_searchBar);
    }
    return _searchBar;
}

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh + 40, Screen_Width, Screen_Height - navHigh - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //UseAutoLayout(_tableView);
    }
    return _tableView;
}

/// 刷新数据源
- (void)reloadTableSource:(NSArray*)sourceArr
{
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self setIndexSectionAry:nil];

    self.contactsSource = [NSMutableArray arrayWithArray:sourceArr];

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
            for (SDCompanyUserModel* buddy in self.contactsSource)
            {
                NSLog(@"buddy.realName:%@",buddy.realName);
                if ([buddy.realName isEqualToString:@""] || buddy.realName == nil)
                {
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initValue];
    [self setUpTopView];
    [self setUpContentView];
    if (_type == scopeId) {
        NSMutableArray* tempArr = [[NSMutableArray alloc] init];
        for (NSString* userId in self.dataArr) {
            SDCompanyUserModel* userModel = [[SDDataBaseHelper shareDB] getUserByUserID:userId];
            if (userModel.userId) {
                [tempArr addObject:userModel];
            }
        }
        [self reloadTableSource:tempArr];
        self.userContactAry = tempArr;
    }
    [self.tableView reloadData];
}

- (void)setUpContentView
{
    [self.view addSubview:self.searchBar];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_searchBar(_rootTopView)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rootTopView, _searchBar)]];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rootTopView][_searchBar(40)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rootTopView, _searchBar)]];

    [self.view addSubview:self.tableView];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_tableView(_searchBar)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_searchBar, _tableView)]];
    //    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_searchBar][_tableView(>=100)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_searchBar, _tableView)]];
}

- (void)initValue
{
    _helper = [SDDataBaseHelper shareDB];
}

- (void)setUpTopView
{
    _rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"同事列表"];

    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* backImage = [UIImage imageNamed:@"back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(backButton);
    [self.rootTopView addSubview:backButton];

    NSDictionary* backVal = @{ @"wd" : [NSNumber numberWithFloat:backImage.size.width],
        @"ht" : [NSNumber numberWithFloat:backImage.size.height]
    };

    // backButton宽度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backButton(wd)]" options:0 metrics:backVal views:NSDictionaryOfVariableBindings(backButton)]];
    // backButton高度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton(ht)]-5-|" options:0 metrics:backVal views:NSDictionaryOfVariableBindings(backButton)]];
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

#pragma mark--tableview代理

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[[self.dataSource valueForKey:self.indexSectionAry[section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSLog(@"self.dataSource allKeys：%@", [self.dataSource allKeys]);
    return (NSInteger)[[self.dataSource allKeys] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDScopeTableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[SDScopeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54.f, Screen_Width, 1.f)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell addSubview:lineView];
//        cell.imageView.userInteractionEnabled = YES;
    }
    
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    self.oneBuddy = oneBuddy;
    cell.userInfoDelegate = self;
    cell.userID = [oneBuddy.userId intValue];
    NSString* headIconUrl = [_helper getHeadIconURL:[oneBuddy.userId stringValue]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headIconUrl]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];

    cell.textLabel.text = oneBuddy.realName;
    cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",oneBuddy.userId];
    
    if ([userId isEqualToString:[AppDelegate getUserID]]) {
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
//        NSNumber* userNUM = [NSNumber numberWithInt:[userId intValue]];
//        pivc.userId = userNUM;
        [self.navigationController pushViewController:pivc animated:YES];
    }else{
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = oneBuddy.imAccount;
        pivc.canPopViewController = YES;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
}

#pragma mark - 进入个人信息页面
- (void)pushToSelfInformationWithUserId
{
    if (!self.oneBuddy) {
        return;
    }
    
    if ([[AppDelegate getUserID] isEqualToString:[NSString stringWithFormat:@"%@",self.oneBuddy.userId]])
    {
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
//        pivc.userId = self.oneBuddy.userId;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
    }else
    {
        
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = [[SDDataBaseHelper shareDB] getUserByUserID:[NSString stringWithFormat:@"%@",self.oneBuddy.userId]].imAccount;
        pivc.canPopViewController = YES;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}
//- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.indexSectionAry[section] uppercaseString];
//}
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
    return [self.indexSectionAry valueForKey:@"uppercaseString"];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 55.f;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText; // called when text changes (including clear)
{
    if (0 == [searchText length]) {
        if (_type == scopeId) {
            NSMutableArray* tempArr = [[NSMutableArray alloc] init];
            for (NSString* userId in self.dataArr) {
                SDCompanyUserModel* userModel = [[SDDataBaseHelper shareDB] getUserByUserID:userId];
                if (userModel.userId) {
                    [tempArr addObject:userModel];
                }
            }
            [self reloadTableSource:tempArr];
            [self.tableView reloadData];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    if (0 == [[searchBar text] length]) {
        return;
    }

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

@end
