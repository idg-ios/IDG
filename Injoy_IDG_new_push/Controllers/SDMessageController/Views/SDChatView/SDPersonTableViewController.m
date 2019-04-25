//
//  SDPersonTableViewController.m
//  SDMarketingManagement
//
//  Created by Rao on 15-4-27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDPersonTableViewController.h"
#import "ChineseToPinyin.h"
#import "SDChatManager.h"
#import "SDPersonCell.h"
#import "UIImageView+EMWebCache.h"
#import "AppDelegate.h"
#import "SDDataBaseHelper.h"

@interface SDPersonTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableDictionary* dataSource;
/// 联系人
@property (nonatomic, strong) NSMutableArray* contactsSource;
/// 右边索引数组
@property (nonatomic, strong) NSMutableArray* indexSectionAry;
@end

@implementation SDPersonTableViewController

- (void)reloadTableSource:(NSArray*)sourceArr
{
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self setIndexSectionAry:nil];

    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contactsSource = [NSMutableArray arrayWithArray:sourceArr];
    NSString* loginUserName = VAL_HXACCOUNT;

    // 把好友加到数组中
    for (SDCompanyUserModel* model in sourceArr) {
        if (YES == [model.hxAccount isEqualToString:loginUserName]) {
            // 去掉登录用户
            [self.contactsSource removeObject:model];
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
            if ([buddy.realName length] == 0) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [[NSMutableDictionary alloc] init];
    _contactsSource = [[NSMutableArray alloc] init];
    NSArray* userContactAry = [[SDChatManager sharedChatManager] userContactAry];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.editing = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self reloadTableSource:userContactAry];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[self.dataSource allKeys] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource valueForKey:self.indexSectionAry[section]] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDPersonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[SDPersonCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"cell"];
    }

    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    
    NSString* headIconUrl = [[SDDataBaseHelper shareDB] getHeadIconURL:[NSString stringWithFormat:@"%@", oneBuddy.userId]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headIconUrl] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];

    cell.textLabel.text = oneBuddy.realName;
    cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    cell.telephone = oneBuddy.telephone;
    cell.hxId = oneBuddy.hxAccount;
    cell.userID = [oneBuddy.userId intValue];
    if ([self.groupHasSelectPersonAry containsObject:oneBuddy]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    if (self.sharePerson.count > 0) {
        for (SDCompanyUserModel* model in self.sharePerson) {
            if ([model.userId integerValue] == cell.userID) {
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    [self.sharePerson addObject:oneBuddy];
}

- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    SDCompanyUserModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    NSMutableArray* deletaAry = [NSMutableArray arrayWithArray:self.sharePerson];
    for (SDCompanyUserModel* model in deletaAry) {
        if ([oneBuddy.userId intValue] == [model.userId intValue]) {
            [self.sharePerson removeObject:oneBuddy];
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

float heightForHeader = 14.f;

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return heightForHeader;
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
    return [self.indexSectionAry valueForKey:@"uppercaseString"];
}

@end
