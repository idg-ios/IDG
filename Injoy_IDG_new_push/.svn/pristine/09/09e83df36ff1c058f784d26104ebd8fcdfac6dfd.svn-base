//
//  CXYJNewColleaguesVIewControllerViewController.m
//  InjoyYJ1
//
//  Created by wtz on 2017/9/5.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYJNewColleaguesVIewControllerViewController.h"
#import "SDIMAddFriendsViewController.h"
#import "SDDataBaseHelper.h"
#import "CXYJNewColleaguesTableViewCell.h"
#import "HttpTool.h"
#import "SDCompanyUserModel.h"
#import "SDContactsDetailController.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "SDIMPersonInfomationViewController.h"

@interface CXYJNewColleaguesVIewControllerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
//搜索栏
@property (nonatomic,strong) UISearchBar * searchBar;

@property (nonatomic,strong) UIView *footerView;
//好友请求数组
@property (nonatomic ,strong) NSMutableArray *friendApplicationListArray;

@end

@implementation CXYJNewColleaguesVIewControllerViewController

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
    [self reloadTable];
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
    [self.rootTopView setNavTitle:LocalString(@"新同事")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
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

- (void)reloadTable
{
    self.friendApplicationListArray = [[NSMutableArray alloc] initWithArray:[[SDDataBaseHelper shareDB]getYJNewColleaguesApplicationArray]];
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
    static NSString * cellName = @"CXYJNewColleaguesTableViewCell";
    CXYJNewColleaguesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXYJNewColleaguesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    [cell setYJNewColleaguesApplication:self.friendApplicationListArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CXYJNewColleaguesModel * userModel = self.friendApplicationListArray[indexPath.row];
    __block SDCompanyUserModel * comModel = [[SDCompanyUserModel alloc]init];
    comModel.imAccount = userModel.imAccount;
    comModel.hxAccount = comModel.imAccount;
    comModel.name = userModel.name;
    comModel.realName = userModel.name;
    comModel.icon = userModel.icon;
    if(![[CXLoaclDataManager sharedInstance] checkIsFriendWithUserModel:comModel]){
        //搜索人
        NSString *url = [NSString stringWithFormat:@"%@sysuser/getSysUser/%@", urlPrefix,userModel.imAccount];
        __weak __typeof(self)weakSelf = self;
        [self showHudInView:self.view hint:nil];
        [HttpTool getWithPath:url params:nil success:^(id JSON) {
            [weakSelf hideHud];
            NSDictionary *jsonDict = JSON;
            if ([jsonDict[@"status"] integerValue] == 200) {
                if(JSON[@"data"]){
                    comModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                    comModel.hxAccount = comModel.imAccount;
                    comModel.realName = comModel.name;
                }
                SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                addFriendsDetailsViewController.userModel = comModel;
                [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            CXAlert(KNetworkFailRemind);
        }];
    }else{
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = userModel.imAccount;
        pivc.canPopViewController = YES;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    
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
        [[SDDataBaseHelper shareDB]deleteYJNewColleaguesApplicationWith:self.friendApplicationListArray[indexPath.row]];
        
        [self reloadTable];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
