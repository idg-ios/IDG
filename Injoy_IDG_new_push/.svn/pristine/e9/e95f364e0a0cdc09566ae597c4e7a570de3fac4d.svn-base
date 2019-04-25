//
//  SDIMNewFriendsApplicationListViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMNewFriendsApplicationListViewController.h"
#import "SDIMAddFriendsViewController.h"
#import "SDDataBaseHelper.h"
#import "SDIMNewFriendsApplicationCell.h"

@interface SDIMNewFriendsApplicationListViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
//搜索栏
@property (nonatomic,strong) UISearchBar * searchBar;

@property (nonatomic,strong) UIView *footerView;
//好友请求数组
@property (nonatomic ,strong) NSMutableArray *friendApplicationListArray;

@end

@implementation SDIMNewFriendsApplicationListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHOW_ADD_FRIENDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendApplicationListArray = [[NSMutableArray alloc] initWithArray:[[SDDataBaseHelper shareDB]getAddFriendApplicationArray]];
    
    [self setUpView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHOW_ADD_FRIENDS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"新的朋友")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"添加朋友" addTarget:self action:@selector(rightBtnClick)];
    
    //tableView
    if(_tableView){
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height -navHigh);
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    //footerView
    if(_footerView){
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, 0, Screen_Width, 0);
    _tableView.tableFooterView = _footerView;
    
}

- (void)rightBtnClick
{
    [self confirmBtnClick];
}

- (void)confirmBtnClick
{
    SDIMAddFriendsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsViewController alloc] init];
    [self.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
}
- (void)reloadTable
{
    self.friendApplicationListArray = [[NSMutableArray alloc] initWithArray:[[SDDataBaseHelper shareDB]getAddFriendApplicationArray]];
    [self.tableView reloadData];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendApplicationListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"SDIMNewFriendsApplicationCell";
    SDIMNewFriendsApplicationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[SDIMNewFriendsApplicationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    [cell setNewFriendsApplication:self.friendApplicationListArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[SDDataBaseHelper shareDB]deleteAddNewFriendApplicationWith:self.friendApplicationListArray[indexPath.row]];
        
        [self reloadTable];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
