//
//  SDIMAddFriendsViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMAddFriendsViewController.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "HttpTool.h"
#import "SDIMSearchTelephoneCell.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import "SDDataBaseHelper.h"
#import "SDContactsDetailController.h"
#import "SDIMPersonInfomationViewController.h"

@interface SDIMAddFriendsViewController()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
//搜索栏
@property (nonatomic,strong) UISearchBar * searchBar;
//table
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) UIView *footerView;

@property (nonatomic, strong) NSMutableArray * searchArray;

@property (nonatomic, strong) UIView * mask;

//搜索的用户模型
@property (nonatomic, strong) SDCompanyUserModel * searchUserModel;

@end

@implementation SDIMAddFriendsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setUpView];
}

- (void)setUpView
{
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"添加朋友")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    //tableView
    if(_tableView){
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, navHigh + 45, Screen_Width, Screen_Height -navHigh - 45);
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
    
    //搜索条
    if(_searchBar){
        [_searchBar removeFromSuperview];
        _searchBar = nil;
    }
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, navHigh, Screen_Width - 60, 45);
    _searchBar.backgroundColor = [UIColor redColor];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchBackGroudColorImage"]];
    _searchBar.placeholder = @"手机号";
    [self.view addSubview:_searchBar];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame), navHigh, 60, 45);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"searchBackGroudColorImage"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"searchBackGroudColorImage"] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    
    //footerView
    if(_footerView){
        [_footerView removeFromSuperview];
        _footerView = nil;
    }
    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, navHigh + 45, Screen_Width, 0);
    _tableView.tableFooterView = _footerView;
}

- (void)detailBtnClick
{
    SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
    [self.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
}

- (void)confirmBtnClick
{
    for(UIView * searchView in [_searchBar subviews]){
        for(UIView * subView in [searchView subviews]){
            if([subView isKindOfClass:[UITextField class]]){
                UITextField * textField = (UITextField *)subView;
                if(textField.text == nil || textField.text.length <= 0){
                    TTAlert(@"请输入您要搜索的手机号");
                }else{
                    [self searchFriendWithText:textField.text];
                }
            }
        }
    }
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchFriendWithText:(NSString *)text
{
    [self.searchArray removeAllObjects];
    
    //搜索人
    NSString * path = [NSString stringWithFormat:@"%@friend/s/%@",urlPrefix,text];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"正在加载数据"];
    [HttpTool getWithPath:path params:@{@"type":@"0"} success:^(NSDictionary *JSON) {
        [weakSelf hideHud];
        if ([JSON[@"status"] integerValue] == 200) {
            self.searchUserModel = [[SDCompanyUserModel alloc] init];
            if(JSON[@"data"] && [JSON[@"data"] count] > 0 && JSON[@"data"][0][@"eid"] && ![JSON[@"data"][0][@"eid"] isKindOfClass:[NSNull class]]){
                self.searchUserModel.userId = @([JSON[@"data"][0][@"eid"] integerValue]);
            }
            if(JSON[@"data"] && [JSON[@"data"] count] > 0 &&JSON[@"data"][0][@"icon"] && ![JSON[@"data"][0][@"icon"] isKindOfClass:[NSNull class]]){
                self.searchUserModel.icon = JSON[@"data"][0][@"icon"];
            }
            if(JSON[@"data"] && [JSON[@"data"] count] > 0 &&JSON[@"data"][0][@"imAccount"] && ![JSON[@"imAccount"][0][@"imAccount"] isKindOfClass:[NSNull class]]){
                self.searchUserModel.imAccount = JSON[@"data"][0][@"imAccount"];
            }
            if(JSON[@"data"] && [JSON[@"data"] count] > 0 &&JSON[@"data"][0][@"name"] && ![JSON[@"data"][0][@"name"] isKindOfClass:[NSNull class]]){
                self.searchUserModel.realName = JSON[@"data"][0][@"name"];
            }
            if(JSON[@"data"] && [JSON[@"data"] count] > 0 &&JSON[@"data"][0][@"telephone"] && ![JSON[@"data"][0][@"telephone"] isKindOfClass:[NSNull class]]){
                self.searchUserModel.telephone = JSON[@"data"][0][@"telephone"];
            }
            
            
            [self.tableView reloadData];
            [self searchBarEnd];
        }else{
            [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SDCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchUserModel.userId != nil){
       return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"cellName";
    SDIMSearchTelephoneCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[SDIMSearchTelephoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell setUserModel:self.searchUserModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.searchUserModel.userId integerValue] == [[AppDelegate getUserID] integerValue]){
        TTAlert(@"不能加自己为好友");
        return;
    }
    
    NSString * path = [NSString stringWithFormat:@"%@friend/judge",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:@((long)[self.searchUserModel.userId integerValue]) forKey:@"friendId"];
    [params setValue:@"cx:injoy365.cn" forKey:@"cxid"];
    
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:@"正在加载数据"];
    [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
        [weakSelf hideHud];
        if ([JSON[@"status"] integerValue] == 200) {
            if([JSON[@"data"] integerValue] == 1){
                NSString * alertStr = [NSString stringWithFormat:@"您和%@已经是好友了",self.searchUserModel.realName];
                TTAlert(alertStr);
                SDCompanyUserModel * userModel = [[SDDataBaseHelper shareDB]getUserByUserID:[self.searchUserModel.userId stringValue]];
                SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
                pivc.imAccount = userModel.imAccount;
                pivc.canPopViewController = YES;
                [self.navigationController pushViewController:pivc animated:YES];
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
                return;

            }else if([JSON[@"msg"] integerValue] == 0){
                SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                addFriendsDetailsViewController.userModel = self.searchUserModel;
                [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                }
            }
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
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

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    for(UIView * searchView in [searchBar subviews]){
        for(UIView * subView in [searchView subviews]){
            if([subView isKindOfClass:[UITextField class]]){
                UITextField * textField = (UITextField *)subView;
                if(textField.text == nil || textField.text.length <= 0){
                    TTAlert(@"请输入您要搜索的手机号");
                }else{
                    [self searchFriendWithText:textField.text];
                }
            }
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.mask = [[UIView alloc] initWithFrame:CGRectMake(0, navHigh + 45, Screen_Width, Screen_Height - navHigh - 45)];
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleMaskTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.mask addGestureRecognizer:tap];
    self.mask.backgroundColor = [UIColor blackColor];
    self.mask.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    self.mask.alpha = .7;
    [UIView commitAnimations];
    [self.view addSubview:self.mask];
    [self.view bringSubviewToFront:self.mask];
    
    return YES;
}

-(void)handleMaskTap:(UIGestureRecognizer*)recognizer
{
    [self searchBarEnd];
}

-(void)searchBarEnd{
    [_searchBar resignFirstResponder];
    [self.mask removeFromSuperview];
    self.mask = nil;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self searchBarEnd];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self searchBarEnd];
}

@end
