//
//  SDSelectDeptViewController.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/5.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDSelectDeptViewController.h"
#import "ChineseToPinyin.h"
#import "SDChatManager.h"
#import "SDDepartmentModel.h"
#import "SDDataBaseHelper.h"
#import "SDSengRangeDeptCell.h"
#import "AppDelegate.h"

@interface SDSelectDeptViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary* dataSource;
/// 联系人
@property (nonatomic, strong) NSMutableArray* contactsSource;

@property (nonatomic, strong) NSArray* deptUserArr;

@property (nonatomic, strong) SDDataBaseHelper* helper;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation SDSelectDeptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopView];
    _dataSource = [[NSMutableDictionary alloc] init];
    _contactsSource = [[NSMutableArray alloc] init];
    
    _deptUserArr = [[SDChatManager sharedChatManager] deptArr];
    [self reloadTableSource:_deptUserArr];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

-(void)setupTopView
{
    SDRootTopView* rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"设置部门"];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
   
}

- (void)reloadTableSource:(NSArray*)sourceArr
{
    [self.contactsSource removeAllObjects];
    [self.dataSource removeAllObjects];
    [self setIndexSectionAry:nil];
    
    _helper = [SDDataBaseHelper shareDB];
    
    // 把部门加到数组中
    [self.contactsSource addObjectsFromArray:sourceArr];
    
    NSArray* indexTitleAry = self.indexSectionAry;
    
    __weak typeof(self) weakSelf = self;
    
    [indexTitleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [weakSelf.dataSource setValue:[NSMutableArray array] forKey:(NSString*)obj];
    }];
    
    for (NSString* firstLetter in indexTitleAry) {
        @autoreleasepool
        {
            // 字母对应的人员数组
            NSMutableArray* valAry = self.dataSource[firstLetter];
            for (SDDepartmentModel* buddy in self.contactsSource) {
                if ([firstLetter isEqualToString:[[[ChineseToPinyin pinyinFromChineseString:buddy.departmentName] lowercaseString] substringWithRange:NSMakeRange(0, 1)]]) {
                    if (![valAry containsObject:buddy]) {
                        [valAry addObject:buddy];
                    }
                }
                else if (0 == isalpha([[ChineseToPinyin pinyinFromChineseString:buddy.departmentName] UTF8String][0])) {
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


/// 获取索引数组
- (NSMutableArray*)getIndexSectionAry
{
    return self.indexSectionAry;
}

/// 索引数组
- (NSMutableArray*)indexSectionAry
{
    if (nil == _indexSectionAry) {
        _indexSectionAry = [[NSMutableArray alloc] init];
        for (SDDepartmentModel* buddy in _contactsSource) {
           
            NSString* firstLetter = [[[ChineseToPinyin pinyinFromChineseString:buddy.departmentName] lowercaseString] substringWithRange:NSMakeRange(0, 1)];
            
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
    NSString* cellName = @"personCell";
    
    SDSengRangeDeptCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (nil == cell) {
        cell = [[SDSengRangeDeptCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellName];
    }
    
    SDDepartmentModel* oneBuddy = [[self.dataSource valueForKey:self.indexSectionAry[indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = oneBuddy.departmentName;
    cell.detailTextLabel.text = @"";
    
    cell.deptId = [oneBuddy.departmentId intValue];
    
   
        if ([_deptId intValue] == cell.deptId) {
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 返回能编辑
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

static float heightForHeader = 14.f;

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return heightForHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20,0, Screen_Width, 14)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lable.text = [NSString stringWithFormat:@"  %@",[self.indexSectionAry[section] uppercaseString]];
    lable.font = [UIFont systemFontOfSize:12.0f];
    return lable;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    return [self.indexSectionAry valueForKey:@"uppercaseString"];
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    SDSengRangeDeptCell* cell = (SDSengRangeDeptCell*)[tableView cellForRowAtIndexPath:indexPath];
    _deptId =[NSNumber numberWithInt:cell.deptId];
    _selectDept([NSNumber numberWithInt:cell.deptId]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath
{
    _deptId = [NSNumber numberWithInt:-100];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
