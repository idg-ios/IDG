//
//  CXMineViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMineViewController.h"
#import "SDIMMyselfViewController.h"
#import "SDMenuView.h"
#import "CXScanViewController.h"
#import "UIView+YYAdd.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "SDIMPersonInfomationViewController.h"
#import "CXMyAttendanceViewController.h"
#import "CXSUSearchViewController.h"
#import "CXSuperUserListViewController.h"
#import "CXNoteCollectionViewController.h"
#import "CXSuperRightsListViewController.h"
#import "CXLogisticsViewController.h"
#import "UIView+CXCategory.h"
#import "SDInvitePictureViewController.h"
#import "CXSuperConfigViewController.h"

#define kHeaderViewHeight 65.0
#define kNormalCellId @"cell"
#define kHeaderCellId @"headercell"

#define kCellInsets UIEdgeInsetsMake(0, 8, 0, 8)

@interface CXMineViewController () <UITableViewDataSource, UITableViewDelegate, SDMenuViewDelegate, UIGestureRecognizerDelegate>

/** 弹出菜单 */
@property (nonatomic, strong) SDMenuView *selectMemu;
/** 用来判断右上角的菜单是否显示 */
@property (nonatomic) BOOL isSelectMenuSelected;
/** 表格视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, copy) NSArray<NSArray<NSDictionary *> *> *list;

@end

@implementation CXMineViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 当isSuper=1和superStatus=1时，超级用户、超级权限、超级搜索才显示
    if (VAL_IsSuper == 1 && VAL_SuperStatus == 1) {
        self.list = @[
                      @[@{ @"icon": @"", @"title": @"头像" }],
                      @[@{ @"icon": @"mine_attendance", @"title": @"考勤" }],
                      @[@{ @"icon": @"mine_collect", @"title": @"备忘收藏" }, @{ @"icon": @"mine_logistics", @"title": @"物流查询" }],
                      @[@{ @"icon": @"mine_superuser", @"title": @"超级用户" }, @{ @"icon": @"mine_superrights", @"title": @"超级权限" }, @{ @"icon": @"mine_search", @"title": @"超级搜索" }, @{ @"icon": @"mine_config", @"title": @"超级配置" }],
                      @[@{ @"icon": @"mine_setting", @"title": @"设置" }],
                      ];
    }
    else {
        self.list = @[
                      @[@{ @"icon": @"", @"title": @"头像" }],
                      @[@{ @"icon": @"mine_attendance", @"title": @"考勤" }],
                      @[@{ @"icon": @"mine_collect", @"title": @"备忘收藏" }, @{ @"icon": @"mine_logistics", @"title": @"物流查询" }],
                      @[@{ @"icon": @"mine_setting", @"title": @"设置" }],
                      ];
    }
    [self setup];
}

- (void)setup {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewOnTap:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.RootTopView setNavTitle:@"我"];
    [self.RootTopView setUpRightBarItemImage:Image(@"add") addTarget:self action:@selector(addBtnOnTap:)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView disableTouchesDelay];
        tableView.backgroundColor = kColorWithRGB(241, 238, 245);
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kNormalCellId];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHeaderCellId];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:kCellInsets];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:kCellInsets];
        }
        [self.view addSubview:tableView];
        tableView;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, GET_MAX_Y(self.RootTopView), GET_WIDTH(self.view), GET_HEIGHT(self.view) - GET_MAX_Y(self.RootTopView));
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<NSDictionary *> *sections = self.list[section];
    return sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kHeaderViewHeight;
    }
    else {
        return SDCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [cell.contentView viewWithTag:1001];
        UILabel *nameLabel = [cell.contentView viewWithTag:1002];
        UILabel *jobLabel = [cell.contentView viewWithTag:1003];
        UIImageView *qrCodeImageView = [cell.contentView viewWithTag:1004];
        UIView *qrTouchView = [cell.contentView viewWithTag:1005];
        if (imageView == nil) {
            imageView = ({
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, kHeaderViewHeight - SDHeadImageViewLeftSpacing * 2, kHeaderViewHeight - SDHeadImageViewLeftSpacing * 2)];
                imageView.tag = 1001;
                [cell.contentView addSubview:imageView];
                imageView;
            });
            nameLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:SDMainMessageFont];
                label.textColor = [UIColor blackColor];
                label.left = GET_MAX_X(imageView) + SDHeadImageViewLeftSpacing;
                label.tag = 1002;
                [cell.contentView addSubview:label];
                label;
            });
            jobLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:SDMainMessageFont];
                label.textColor = kColorWithRGB(155, 155, 155);
                label.left = GET_MIN_X(nameLabel);
                label.tag = 1003;
                [cell.contentView addSubview:label];
                label;
            });
            qrCodeImageView = ({
                UIImageView *imageView = [[UIImageView alloc] initWithImage:Image(@"qrcode")];
                imageView.right = Screen_Width - 30;
                imageView.tag = 1004;
                [cell.contentView addSubview:imageView];
                imageView;
            });
            qrTouchView = ({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width - 70, 0, 70, kHeaderViewHeight)];
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrTouchViewTapped)]];
                view.tag = 1005;
                [cell.contentView addSubview:view];
                view;
            });
        }
        SDCompanyUserModel *userModel = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[userModel.icon isKindOfClass:[NSNull class]]?@"":userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        nameLabel.text = userModel.realName;
        [nameLabel sizeToFit];
        nameLabel.bottom = kHeaderViewHeight / 2 - 2;
        jobLabel.text = userModel.job;
        [jobLabel sizeToFit];
        jobLabel.top = kHeaderViewHeight / 2 + 2;
        qrCodeImageView.centerY = kHeaderViewHeight / 2;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        NSDictionary *item = self.list[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:item[@"icon"]];
        cell.textLabel.text = item[@"title"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *item = self.list[indexPath.section][indexPath.row];
    NSString *title = item[@"title"];
    if ([title isEqualToString:@"头像"]) {
        SDIMPersonInfomationViewController *vc = [[SDIMPersonInfomationViewController alloc] init];
        vc.canPopViewController = YES;
        SDCompanyUserModel *userModel = [CXIMHelper getUserByIMAccount:VAL_HXACCOUNT];
        vc.imAccount = userModel.imAccount;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"考勤"]) {
        CXMyAttendanceViewController *vc = [[CXMyAttendanceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"备忘收藏"]) {
        CXNoteCollectionViewController *vc = [[CXNoteCollectionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"物流查询"]) {
        CXLogisticsViewController *vc = [[CXLogisticsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"超级用户"]) {
        CXSuperUserListViewController *vc = [[CXSuperUserListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"超级权限"]) {
        CXSuperRightsListViewController *vc = [[CXSuperRightsListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"超级搜索"]) {
        CXSUSearchViewController *vc = [[CXSUSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"超级配置"]) {
        CXSuperConfigViewController *vc = [[CXSuperConfigViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"设置"]) {
        SDIMMyselfViewController *vc = [[SDIMMyselfViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:kCellInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:kCellInsets];
    }
}

#pragma mark - Private
- (void)viewOnTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)addBtnOnTap:(UIButton*)sender {
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray* dataArray = @[@"扫一扫"];
        NSArray* imageArray = @[@"saoma"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [self selectMenuViewDisappear];
    }
}

- (void)selectMenuViewDisappear {
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)qrTouchViewTapped {
    SDInvitePictureViewController *vc = [[SDInvitePictureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        CXScanViewController * scanViewController = [[CXScanViewController alloc] init];
        [self.navigationController pushViewController:scanViewController animated:YES];
    }
}

@end
