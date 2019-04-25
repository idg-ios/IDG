//
//  CXWorkCircleNewCommentListViewController.m
//  InjoyERP
//
//  Created by wtz on 16/12/6.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXWorkCircleNewCommentListViewController.h"
#import "SDDataBaseHelper.h"
#import "CXWorkCircleNewCommentListTableViewCell.h"
#import "YunJingWorkCircleDetailViewController.h"
#import "CXAllPeoplleWorkCircleModel.h"

@interface CXWorkCircleNewCommentListViewController ()<UITableViewDataSource, UITableViewDelegate>

/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 内容视图
@property (nonatomic, strong) UITableView* tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation CXWorkCircleNewCommentListViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSource) name:receiveNewWorkCircleCommentNotification object:nil];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self setupView];
}

#pragma mark - 内部方法
- (void)setupView
{
    self.view.backgroundColor = SDBackGroudColor;
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"消息")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    [self.rootTopView setUpRightBarItemTitle:@"清空" addTarget:self action:@selector(rightBtnClick)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.bounces = YES;
    
    //修复UITableView的分割线偏移的BUG
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableView];
    
    [self getDataSource];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
{
    [[SDDataBaseHelper shareDB] deleteWorkCircleCommentListTable];
    [self getDataSource];
}

- (void)getDataSource
{
    NSArray * comments = [[SDDataBaseHelper shareDB] getWorkCircleCommentPushModelArray];
    self.dataArray = [NSMutableArray arrayWithArray:comments];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [CXWorkCircleNewCommentListTableViewCell getWorkCircleCommentCellHeightWithWorkCircleCommentModel:(CXWorkCircleCommentPushModel *)self.dataArray[indexPath.row]];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellName = @"CXWorkCircleNewCommentListTableViewCell";
    CXWorkCircleNewCommentListTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[CXWorkCircleNewCommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    CXWorkCircleCommentPushModel * model = (CXWorkCircleCommentPushModel *)self.dataArray[indexPath.row];
    [cell setWorkCircleCommentPushModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXWorkCircleCommentPushModel * model = (CXWorkCircleCommentPushModel *)self.dataArray[indexPath.row];
    YunJingWorkCircleDetailViewController * workCircleDetailViewController = [[YunJingWorkCircleDetailViewController alloc] init];
    
    CXAllPeoplleWorkCircleModel * detailModel = [[CXAllPeoplleWorkCircleModel alloc] init];
    detailModel.btype = model.btype;
    detailModel.eid = @([model.eid integerValue]);
    workCircleDetailViewController.model = detailModel;
    [self.navigationController pushViewController:workCircleDetailViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL success = [[SDDataBaseHelper shareDB] deleteNewCommentNotificationWith:(CXWorkCircleCommentPushModel *)self.dataArray[indexPath.row]];
        if(success){
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else{
            TTAlert(@"删除失败");
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
