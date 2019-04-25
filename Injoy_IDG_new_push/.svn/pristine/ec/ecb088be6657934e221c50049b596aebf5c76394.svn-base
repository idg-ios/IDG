//
//  SDDeleteGroupMembersViewController.m
//  SDIMApp
//
//  Created by wtz on 16/3/14.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import "SDIMDeleteGroupMembersViewController.h"
#import "PinYin4Objc.h"
#import "SDDeleteGroupMemberCell.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface SDIMDeleteGroupMembersViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
//搜索栏
@property (nonatomic,strong) UISearchBar * searchBar;
//table
@property (nonatomic,strong) UITableView * tableView;
//群组成员
@property (nonatomic,strong) NSMutableArray * members;
//搜索到的群组成员数组
@property (nonatomic,strong) NSMutableArray * searchMembersArray;
//被选择的群组成员数组
@property (nonatomic,strong) NSMutableArray * selectedMembersArray;
// 排序后的列表
@property (nonatomic,strong) NSMutableArray *sortedList;
//搜索控制器
@property (nonatomic,strong) UISearchDisplayController *sdc;

@property (nonatomic,strong) SDRootTopView *rootTopView;

@property (nonatomic,strong) CXGroupInfo * group;

@end

@implementation SDIMDeleteGroupMembersViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchGroupDetailInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"删除群成员")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backViewController)];
    
    [self.rootTopView setUpRightBarItemTitle:@"删除" addTarget:self action:@selector(deleteGroupMembersBtnClick)];
    
    self.searchMembersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedMembersArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake( 0,navHigh, Screen_Width, Screen_Height - navHigh);
    
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
    
    UIView * footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    _tableView.tableFooterView = footerView;
    
    // 实例化搜索条
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.frame = CGRectMake(0, 0, Screen_Width, 45);
    _searchBar.backgroundColor = [UIColor clearColor];
    
    _tableView.tableHeaderView = _searchBar;
    
    // 搜索控制器
    _sdc = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _sdc.searchResultsDataSource = self;
    _sdc.searchResultsDelegate = self;
    _sdc.delegate = self;

}

-(void)fetchGroupDetailInfo{
    [self showHudInView:self.view hint:@"正在获取群组信息"];
    [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:self.groupId completion:^(CXGroupInfo *group, NSError *error) {
        [self hideHud];
        if (!error) {
            self.group = group;
            NSMutableArray * groupUserIDArray = [[NSMutableArray alloc] initWithCapacity:0];
            for(CXGroupMember * member in self.group.members){
                [groupUserIDArray addObject:member.userId];
            }
            self.members = [NSMutableArray arrayWithArray:groupUserIDArray];
            [self sortArray];
            
            [_tableView reloadData];
        }
        else{
            TTAlert(@"获取失败");
        }
    }];
}


- (void)backViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteGroupMembersBtnClick
{
    
    if(_selectedMembersArray != nil && [_selectedMembersArray count] > 0){
        [self showHudInView:self.view hint:@"正在删除成员"];
        [[CXIMService sharedInstance].groupManager removeGroupMembersWithGroupId:self.groupId members:_selectedMembersArray completion:^(NSArray<CXGroupMember *>* removedMembers, NSError *error) {
            [self hideHud];
            if (!error) {
                NSMutableArray * removeMembersIMAccountArray = [[NSMutableArray alloc] initWithCapacity:0];
                for(NSString * groupMember in removedMembers){
                    [removeMembersIMAccountArray addObject:groupMember];
                }
                
                [self.members removeObjectsInArray:removeMembersIMAccountArray];
                [self sortArray];
                [self.searchMembersArray removeAllObjects];
                [self.selectedMembersArray removeAllObjects];
                [_tableView reloadData];
                _searchBar.text = @"";
                _sdc.active = NO;
            }
            else{
                TTAlert(@"删除失败");
            }
        }];
    }
    else{
        TTAlert(@"请您先选择要删除的群成员");
    }
}

#pragma mark 排序数组
-(void)initData{
    _sortedList = [NSMutableArray array];
    [_sortedList addObject:@{
                             @"groupName":@"#",
                             @"list":[NSMutableArray array]
                             }];
    // 生成字母表
    for (NSInteger i = 65; i < 65 + 26; i++) {
        NSString *letter = [NSString stringWithFormat:@"%c",(char)i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                      @"groupName":letter,
                                                                                      @"list":[NSMutableArray array]
                                                                                      }];
        [_sortedList addObject:dict];
    }
}


-(void)sortArray{
    [self initData];
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    for(NSString * userName in _members){
        NSString* realName = [[CXLoaclDataManager sharedInstance]getUserByGroupId:self.groupId AndIMAccount:userName].name;
        NSString *username = [realName substringToIndex:1];
        NSString * regex = @"^[A-Za-z\u4e00-\u9fa5]+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        // 是字母或汉字
        BOOL isChineseOrLetter = [pred evaluateWithObject:username];
        NSInteger dictIndex = 0;
        if (isChineseOrLetter) {
            NSString *letter = [[[PinyinHelper toHanyuPinyinStringWithNSString:username withHanyuPinyinOutputFormat:outputFormat withNSString:@" "] substringToIndex:1] uppercaseString];
            dictIndex = [letter characterAtIndex:0] - 65 + 1;
        }
        NSMutableDictionary *dict = _sortedList[dictIndex];
        NSMutableArray *array = [dict objectForKey:@"list"];
        [array addObject:userName];
    }
    // 去空
    for (NSInteger i = _sortedList.count - 1; i >= 0; i--) {
        NSMutableDictionary *dict = _sortedList[i];
        NSArray *array = [dict objectForKey:@"list"];
        if (!array.count) {
            [_sortedList removeObjectAtIndex:i];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView != _tableView)
    {
        return 1;
    }
    return [_sortedList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView != _tableView)
    {
        [_searchMembersArray removeAllObjects];
        for(NSDictionary * listDic in _sortedList)
        {
            NSArray * nameArray = [listDic objectForKey:@"list"];
            for(NSString * nameString in nameArray)
            {
//                NSString * realNameString = [CXIMHelper getRealNameByAccount:nameString];
                NSString* realNameString = [[CXLoaclDataManager sharedInstance]getUserByGroupId:self.groupId AndIMAccount:nameString].name;
                NSRange range = [realNameString rangeOfString:_searchBar.text];
                if(range.location != NSNotFound)
                {
                    [_searchMembersArray addObject:nameString];
                }
            }
        }
        return [_searchMembersArray count];
    }
    return [[[_sortedList objectAtIndex:section] objectForKey:@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    SDDeleteGroupMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[SDDeleteGroupMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    NSString * member;
    BOOL isIn;
    if(tableView != _tableView)
    {
        member = [_searchMembersArray objectAtIndex:indexPath.row];
        isIn = [_selectedMembersArray containsObject:member];
        
    }
    else
    {
        member = [[[_sortedList objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
        isIn = [_selectedMembersArray containsObject:member];
    }
    [cell setMember:member AndSelected:isIn];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, Screen_Width, 14);
    backView.backgroundColor = SDBackGroudColor;
    UILabel * titleLable = [[UILabel alloc] init];
    titleLable.font = [UIFont systemFontOfSize:12];
    titleLable.frame = CGRectMake(0, 1, 200, 12);
    if(tableView != _tableView)
    {
        titleLable.text = @"  搜索结果";
    }else{
        titleLable.text = [NSString stringWithFormat:@"  %@",[[_sortedList objectAtIndex:section] objectForKey:@"groupName"]];
    }
    [backView addSubview:titleLable];
    return backView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * member = nil;
    if(tableView != _tableView){
        member = [_searchMembersArray objectAtIndex:indexPath.row];
    }else{
        member = [[[_sortedList objectAtIndex:indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    }
    BOOL isIn = [_selectedMembersArray containsObject:member];
    if(isIn){
        [_selectedMembersArray removeObject:member];
    }else{
        [_selectedMembersArray addObject:member];
    }
    if(tableView != _tableView){
        [_tableView reloadData];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 添加索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    // 加入搜索放大镜索引图标
    [indexArray addObject:UITableViewIndexSearch];
    
    for(NSDictionary * listDic in _sortedList){
        [indexArray addObject:[listDic objectForKey:@"groupName"]];
    }
    return indexArray;
}

// 修改索引条和section对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0)
    {
        // 滚动到一个方块的位置
        [tableView scrollRectToVisible:_searchBar.frame animated:YES];
    }
    return index-1;
}

//此代理方法用来重置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self.view bringSubviewToFront:self.rootTopView];
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y + 45, tableView.frame.size.width, tableView.frame.size.height - 45);
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

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y - 45, tableView.frame.size.width, tableView.frame.size.height + 45);
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
