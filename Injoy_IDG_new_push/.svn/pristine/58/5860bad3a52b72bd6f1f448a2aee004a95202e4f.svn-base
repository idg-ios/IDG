//
//  CXFocusSignEditViewController.m
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXFocusSignEditViewController.h"
#import "CXFocusSignModel.h"
#import "UIView+Category.h"
#import "HttpTool.h"
#import "YYModel.h"
#import "CXFocusSignDetail.h"
#import "SDDataBaseHelper.h"
#import "CXIDGGroupAddUsersViewController.h"
#import "CXFocusSignMembersViewController.h"
#import "CXIMMembersView.h"
#import "SDContactsDetailController.h"
#import "CXIMHelper.h"
#import "SDIMPersonInfomationViewController.h"


#define kSectionHeaderHeight 40

@interface CXFocusSignEditViewController () <UITableViewDelegate, UITableViewDataSource, CXIMMembersViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *sections;
@property (nonatomic, strong) UITextField *nameTxf;
@property (nonatomic, strong) CXFocusSignDetail *focusSignDetail;
@property (nonatomic, strong) CXIMMembersView *membersView;
/** 标签名称 */
@property (nonatomic, copy) NSString *signName;

// 编辑的数据
@property (nonatomic, strong) NSMutableArray<NSNumber *> *currentMembers; // 当前的用户id

@end

@implementation CXFocusSignEditViewController

#pragma mark - Lazy-Load 
- (NSArray<NSString *> *)sections {
    if (_sections == nil) {
        _sections = @[@"标签名字", @"成员"];
    }
    return _sections;
}

- (NSMutableArray<NSNumber *> *)currentMembers {
    if (_currentMembers == nil) {
        _currentMembers = [NSMutableArray array];
    }
    return _currentMembers;
}

- (UITextField *)nameTxf {
    if (_nameTxf == nil) {
        _nameTxf = [[UITextField alloc] init];
        _nameTxf.borderStyle = UITextBorderStyleNone;
        _nameTxf.placeholder = @"请输入标签名字";
        _nameTxf.clearButtonMode = UITextFieldViewModeAlways;
        [_nameTxf addTarget:self action:@selector(nameTxfEditingChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTxf;
}

- (CXIMMembersView *)membersView {
    if (!_membersView) {
        _membersView = [[CXIMMembersView alloc] init];
        _membersView.delegate = self;
        _membersView.deleteButtonEnable = YES;
    }
    return _membersView;
}

#pragma mark - Lify-Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopView];
    [self setupView];
    if (self.editMode == CXFocusSignEditModeModify) {
        [self getFocusSignDetailInfo];
    }
    else {
        self.membersView.members = @[];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

- (void)setTopView {
    SDRootTopView *topView = [self getRootTopView];
    [topView setNavTitle:@"编辑标签"];
    [topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [topView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveBtnTapped)];
    [self.view addSubview:topView];
}

- (void)setupView {
    // FooterView
    UIView *footerView = [[UIView alloc] init];
    if (self.editMode == CXFocusSignEditModeModify) {
        footerView.height = 80;
        footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:@"删除关注标签" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.backgroundColor = SDQuitOrDeleteBtnColor;
        deleteBtn.x = 10;
        deleteBtn.layer.cornerRadius = 3;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.height = 50;
        deleteBtn.centerY = 40;
        deleteBtn.width = Screen_Width - deleteBtn.x * 2;
        [footerView addSubview:deleteBtn];
    }
    
    // TableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
    self.tableView.tableFooterView = footerView;
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
}

#pragma mark - 获取数据
- (void)getFocusSignDetailInfo {
    [self showHudInView:self.view hint:@"正在获取数据"];
    NSString *path = [NSString stringWithFormat:@"%@/contact/concern/detail/%@", urlPrefix, self.focusSignModel.ID];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        self.focusSignDetail = (CXFocusSignDetail *)[CXFocusSignDetail yy_modelWithJSON:JSON[@"datas"]];
        self.currentMembers = [self.focusSignDetail.userIds mutableCopy];
        self.signName = self.focusSignDetail.userConcern.name;
        if(self.currentMembers && [self.currentMembers count] > 10){
            NSMutableArray * membersArray = [[NSMutableArray alloc] initWithArray:self.currentMembers];
            NSArray * memberArray = [membersArray subarrayWithRange:NSMakeRange(0, 10)];
            self.membersView.members = [self getUserModelsByIds:memberArray];
        }else{
            self.membersView.members = [self getUserModelsByIds:self.currentMembers];
        }
        [self.tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
//        TTAlert(@"获取关注标签详情失败");
        CXAlert(KNetworkFailRemind);
        [self hideHud];
    }];
}

#pragma mark - Action
- (void)saveBtnTapped {
    if(self.nameTxf.text == nil || [self.nameTxf.text length] <= 0){
        TTAlert(@"请填写标签名字");
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/contact/concern", urlPrefix];
    // 修改
    if (self.editMode == CXFocusSignEditModeModify) {
        if([self.currentMembers count] > 0){
            NSDictionary *params = @{
                                     @"id":self.focusSignModel.ID,
                                     @"userId":VAL_USERID, // 提交关注的用户ID
                                     @"name":self.nameTxf.text, // 关注标签名称
                                     @"userList":[self.currentMembers componentsJoinedByString:@","] // 标签成员列表string "1,2,3,4"
                                     };
            [self showHudInView:self.view hint:@"正在保存"];
            [HttpTool putWithPath:path params:params success:^(NSDictionary *JSON) {
                [self hideHud];
                if ([JSON[@"status"] integerValue] == 200) {
                    if (self.didSaveSuccessBlock) {
                        self.didSaveSuccessBlock();
                    }
                    TTAlert(@"保存成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    TTAlert(JSON[@"msg"]);
                }
            } failure:^(NSError *error) {
//                TTAlert(error.localizedDescription);
                CXAlert(KNetworkFailRemind);
                [self hideHud];
            }];
        }else{
            [self deleteBtnTapped];
        }
    }
    else { // 添加
        if(self.currentMembers == nil || (self.currentMembers != nil && [self.currentMembers count] == 0)){
            TTAlert(@"关注标签至少含有一个成员");
            return;
        }
        NSDictionary *params = @{
                                 @"name":self.nameTxf.text,
                                 @"userList":[self.currentMembers componentsJoinedByString:@","]
                                 };
        [self showHudInView:self.view hint:@"正在保存"];
        [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
            [self hideHud];
            if ([JSON[@"status"] integerValue] == 200) {
                if (self.didSaveSuccessBlock) {
                    self.didSaveSuccessBlock();
                }
                TTAlert(@"保存成功");
                [self.navigationController popViewControllerAnimated:YES];
            }
//            else if ([JSON[@"status"] intValue] == 400) {
//                [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//            }
            else {
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
//            TTAlert(error.localizedDescription);
            CXAlert(KNetworkFailRemind);
            [self hideHud];
        }];
    }
}

// 删除关注标签
- (void)deleteBtnTapped {
    NSString *path = [NSString stringWithFormat:@"%@/contact/concern/%@", urlPrefix, self.focusSignModel.ID];
    [self showHudInView:self.view hint:@"正在删除"];
    [HttpTool deleteWithPath:path params:nil success:^(NSDictionary *JSON) {
        [self hideHud];
        if ([JSON[@"status"] integerValue] == 200) {
            if (self.didSaveSuccessBlock) {
                self.didSaveSuccessBlock();
            }
            TTAlert(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [self hideHud];
//        TTAlert(error.localizedDescription);
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)nameTxfEditingChanged {
    self.signName = self.nameTxf.text;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    else {
        if (indexPath.row == 0) {
            return self.membersView.viewHeight;
        }
        else {
            return 44;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = SDBackGroudColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.sections[section];
    titleLabel.font = [UIFont systemFontOfSize:SDSectionTitleFont];
    titleLabel.textColor = SDSectionTitleColor;
    titleLabel.x = SDHeadImageViewLeftSpacing;
    [titleLabel sizeToFit];
    titleLabel.centerY = [self tableView:tableView heightForHeaderInSection:section] / 2.0;
    [view addSubview:titleLabel];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"cell%zd", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 标签名字
    if (indexPath.section == 0) {
        self.nameTxf.x = SDHeadImageViewLeftSpacing;
        self.nameTxf.width = Screen_Width - 2 * self.nameTxf.x;
        self.nameTxf.height = 30;
        self.nameTxf.centerY = [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2;
        self.nameTxf.text = self.signName;
        [cell.contentView addSubview:self.nameTxf];
    }
    // 成员
    else {
        if (indexPath.row == 0) {
            self.membersView.frame = CGRectMake(0, 0, Screen_Width, 0);
            [cell.contentView addSubview:self.membersView];
        }
        else {
            UILabel *label = [[UILabel alloc] init];
            label.x = SDHeadImageViewLeftSpacing;
            label.text = [NSString stringWithFormat:@"全部成员(%zd)", self.currentMembers.count];
            [label sizeToFit];
            label.centerY = [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2;
            [cell.contentView addSubview:label];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        // 全部成员
        if (indexPath.row == 1) {
            CXFocusSignMembersViewController *membersVC = [[CXFocusSignMembersViewController alloc] init];
            membersVC.presentMode = CXFocusSignMembersPresentModeDisplay;
            membersVC.users = self.currentMembers;
            [self.navigationController pushViewController:membersVC animated:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.nameTxf resignFirstResponder];
}

// 去掉UItableview headerview黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - CXIMMembersViewDelegate
- (void)imMembersView:(CXIMMembersView *)membersView didTappedMemberItem:(CXIMMemberItem *)memberItem {
    if([memberItem.userModel.hxAccount isEqualToString:VAL_HXACCOUNT]){
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
        pivc.imAccount = memberItem.userModel.imAccount;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = [[CXIMHelper userIdArrayToModelArray:@[memberItem.userModel.userId]] lastObject].imAccount;
        pivc.canPopViewController = YES;
        [self.navigationController pushViewController:pivc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)imMembersView:(CXIMMembersView *)membersView didTappedAddButton:(void *)none {
    [self showHudInView:self.view hint:@"加载中"];
    __weak typeof(self) wself = self;
    CXIDGGroupAddUsersViewController * selectColleaguesViewController = [[CXIDGGroupAddUsersViewController alloc] init];
    selectColleaguesViewController.navTitle = @"添加成员";
    NSMutableArray * fiterArray = [NSMutableArray arrayWithArray:self.currentMembers];
    [fiterArray addObject:[NSNumber numberWithInteger:[VAL_USERID integerValue]]];
    selectColleaguesViewController.filterUsersArray = [NSMutableArray arrayWithArray:[wself
                                                                                      getUserModelsByIds:fiterArray]];
    selectColleaguesViewController.navTitle = @"添加成员";
    selectColleaguesViewController.selectContactUserCallBack = ^(NSArray * selectContactUserArr){
        NSMutableArray<NSNumber *> *members = [NSMutableArray array];
        for (SDCompanyUserModel *user in selectContactUserArr) {
            [members addObject:user.userId];
        }
        for(NSNumber * user in wself.currentMembers){
            [members removeObject:user];
        }
        if (members.count) {
            [self.currentMembers addObjectsFromArray:members];
            self.membersView.members = [self getUserModelsByIds:self.currentMembers];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    };
    
    [self presentViewController:selectColleaguesViewController animated:YES completion:nil];
    [self hideHud];
}

- (void)imMembersView:(CXIMMembersView *)membersView didTappedDeleteButton:(void *)none {
    CXFocusSignMembersViewController *membersVC = [[CXFocusSignMembersViewController alloc] init];
    membersVC.presentMode = CXFocusSignMembersPresentModeDelete;
    membersVC.users = [self.currentMembers copy];
    [membersVC setDidTapDeleteBtnCallback:^(NSArray<SDCompanyUserModel *> *selectedUsers, NSArray<SDCompanyUserModel *> *unselectedUsers) {
        NSMutableArray<NSNumber *> *restedIds = [NSMutableArray array];
        for (SDCompanyUserModel *user in unselectedUsers) {
            [restedIds addObject:user.userId];
        }
        self.currentMembers = restedIds;
        self.membersView.members = [self getUserModelsByIds:self.currentMembers];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1], [NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [self.navigationController pushViewController:membersVC animated:YES];
}

#pragma mark - 数据处理
- (NSArray<NSString *> *)userIdArrayToIMAccountArray:(NSArray<NSNumber *> *)userIdArray {
    NSMutableArray *imAccounts = [NSMutableArray array];
    for (NSNumber *userId in userIdArray) {
        SDCompanyUserModel *user = [[SDDataBaseHelper shareDB] getUserByUserID:userId.stringValue];
        if (!user.hxAccount) {
            continue;
        }
        [imAccounts addObject:user.hxAccount];
    }
    return [imAccounts copy];
}

- (NSArray<NSNumber *> *)userModelArrayToIdArray:(NSArray<SDCompanyUserModel *> *)userModelArray {
    NSMutableArray<NSNumber *> *userIdArray = [NSMutableArray array];
    for (SDCompanyUserModel *userModel in userModelArray) {
        [userIdArray addObject:userModel.userId];
    }
    return [userIdArray copy];
}

- (NSArray<SDCompanyUserModel *> *)getUserModelsByIds:(NSArray<NSNumber *> *)ids {
    NSMutableArray<SDCompanyUserModel *> *userModels = [NSMutableArray array];
    for (NSNumber *userId in ids) {
        SDCompanyUserModel *user = [[SDDataBaseHelper shareDB] getUserByUserID:userId.stringValue];
        if (!user.userId) {
            continue;
        }
        [userModels addObject:user];
    }
    return [userModels copy];
}

@end
