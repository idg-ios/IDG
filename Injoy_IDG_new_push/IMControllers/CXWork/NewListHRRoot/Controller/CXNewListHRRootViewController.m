//
//  CXNewListHRRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewListHRRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXVacationApplicationListViewController.h"
#import "CXWDXJListViewController.h"
#import "CXIDGMessageListViewController.h"
#import "CXVacationApplicationEditViewController.h"
#import "IDGXJListViewController.h"
#import "UIView+YYAdd.h"
#import "CXEditLabel.h"
#import "CXMiddleActionSheetSelectView.h"


@interface CXNewListHRRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) UIButton * addMenuBtn;
@property(nonatomic, strong) CXMiddleActionSheetSelectView * sheetSelectView;

@end

@implementation CXNewListHRRootViewController

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"我的请假", @"我的销假", @"消息", @"流程消息", nil];
    }
    return _dataSourceArr;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
        _tableView.backgroundColor = SDBackGroudColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = YES;
        
        //修复UITableView的分割线偏移的BUG
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)addMenuBtn{
    if(!_addMenuBtn){
        _addMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMenuBtn.contentMode = UIViewContentModeCenter;
        [_addMenuBtn setImage:[UIImage imageNamed:@"MenuAddBtnImage"] forState:UIControlStateNormal];
        CGFloat kOffset = Screen_Width / 375;
        [_addMenuBtn sizeToFit];
        _addMenuBtn.right = GET_WIDTH(self.view) - 30 * kOffset;
        _addMenuBtn.bottom = GET_HEIGHT(self.view) - 30 * kOffset;
        _addMenuBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [_addMenuBtn addTarget:self action:@selector(addMenuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addMenuBtn];
        [self.view bringSubviewToFront:_addMenuBtn];
    }
    return _addMenuBtn;
}

- (void)addMenuBtnClick{
    self.sheetSelectView= [[CXMiddleActionSheetSelectView alloc] initWithSelectArray:@[@"请假申请",@"销假申请"] Title:@"申请" AndSelectData:nil];
    CXWeakSelf(self)
    self.sheetSelectView.selectDataCallBack = ^(NSString *selectedData) {
        CXStrongSelf(self)
        if (selectedData == nil) {
            return;
        }else if([selectedData isEqualToString:@"请假申请"]){
            CXVacationApplicationEditViewController *vc = [CXVacationApplicationEditViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }else if([selectedData isEqualToString:@"销假申请"]){
            IDGXJListViewController *vc = [IDGXJListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    };
}

#pragma mark - UI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"移动HR"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArr count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDMenuCellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellName = @"cellName";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * subView in cell.contentView.subviews){
            [subView removeFromSuperview];
        }
    }
    
    NSString *title = self.dataSourceArr[indexPath.row];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:SDMenuCellTitleFontSize];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.frame = CGRectMake(SDMenuCellTitleLeftMargin, (SDMenuCellHeight - SDMenuCellTitleFontSize)/2, 200.0, SDMenuCellTitleFontSize);
    titleLabel.text = title;
    [cell.contentView addSubview:titleLabel];
    
    UILabel * countLabel = [[UILabel alloc] init];
    NSInteger count = 0;
    if ([@"我的请假" isEqualToString:title]) {
        count = [self.view countNumBadge:IM_PUSH_QJ,nil];
//        count = [NSUserDefaults searchJPushTypeWithtype:@"1117" btype:@"2"].count;
    }else if ([@"消息" isEqualToString:title]) {
        count = [self.view countNumBadge:IM_PUSH_PUSH_HOLIDAY,nil];
//        count = [NSUserDefaults searchJPushTypeWithtype:@"1203"].count;
    }else if ([@"流程消息" isEqualToString:title]) {
        count = [self.view countNumBadge:IM_PUSH_PROGRESS,nil];
//        count = [NSUserDefaults searchJPushTypeWithtype:@"1205"].count;
    }else if ([@"我的销假" isEqualToString:title]) {
        count = [self.view countNumBadge:IM_PUSH_XIAO,nil];
//        count = [NSUserDefaults searchJPushTypeWithtype:@"1205" btype:@"14"].count;
    }
    countLabel.text = count > 0?[NSString stringWithFormat:@"%zd",count]:@"";
    countLabel.textColor = RGBACOLOR(174.0, 17.0, 41.0, 1.0);
    countLabel.font = [UIFont systemFontOfSize:SDMenuCellTitleFontSize];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.frame = CGRectMake((Screen_Width - SDMenuCellTitleLeftMargin - 200.0), (SDMenuCellHeight - SDMenuCellTitleFontSize)/2, 200.0, SDMenuCellTitleFontSize);
    [cell.contentView addSubview:countLabel];

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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.dataSourceArr[indexPath.row];

    if ([@"我的请假" isEqualToString:title]) {
//        [NSUserDefaults deletePushTypeWithType:@"1117" btype:@"2"];
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_QJ);
        CXVacationApplicationListViewController *vc = [[CXVacationApplicationListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"消息" isEqualToString:title]) {
//        [NSUserDefaults deletePushTypeWithType:@"1203"];
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PUSH_HOLIDAY);
        CXIDGMessageListViewController *vc = [CXIDGMessageListViewController new];
        vc.type = RSType;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"我的销假" isEqualToString:title]) {
//        [NSUserDefaults deletePushTypeWithType:@"1117" btype:@"14"];
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_XIAO);
        CXWDXJListViewController *vc = [[CXWDXJListViewController alloc] init];
//        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PROGRESS);//这里和流程消息一样

        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"流程消息" isEqualToString:title]) {
//        [NSUserDefaults deletePushTypeWithType:@"1205" btype:@"14"];
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_PROGRESS);
        CXIDGMessageListViewController *vc = [CXIDGMessageListViewController new];
        vc.type = WDLCType;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.tableView.hidden = NO;
//    self.addMenuBtn.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
