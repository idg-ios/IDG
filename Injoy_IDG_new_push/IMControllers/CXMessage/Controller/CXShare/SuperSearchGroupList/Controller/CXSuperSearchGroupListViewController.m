//
//  CXSuperSearchGroupListViewController.m
//  InjoySTD
//
//  Created by wtz on 16/8/13.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXSuperSearchGroupListViewController.h"
#import "SDIMChatViewController.h"
#import "CXIMHelper.h"
#import "SDIMGroupListCell.h"
#import "CXSendShareView.h"

@interface CXSuperSearchGroupListViewController()<UITableViewDataSource, UITableViewDelegate>

/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 内容视图
@property (nonatomic, strong) UITableView* tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray* sourceAry;

@property (nonatomic, strong) CXSendShareView * sendShareView;

@end

@implementation CXSuperSearchGroupListViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDataSource];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sourceAry = [[NSMutableArray alloc] initWithCapacity:0];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //修复群组头像不显示
    [self.tableView reloadData];
}

#pragma mark - 内部方法
- (void)setupView
{
    self.view.backgroundColor = SDBackGroudColor;
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"工作群聊")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
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
}

//数据源
- (void)loadDataSource
{
    [self showHudInView:self.view hint:@"正在加载数据"];
    __weak typeof(self) wself = self;
    [[CXIMService sharedInstance].groupManager getJoinedGroups:^(NSArray<CXGroupInfo *> *groups, NSError *error) {
        [wself hideHud];
        if (!error) {
            [_sourceAry removeAllObjects];
            for(CXGroupInfo * group in groups){
                if(group.groupType == CXGroupTypeNormal){
                    [_sourceAry addObject:group];
                }
            }
            [wself.tableView reloadData];
        }
        else{
            TTAlert(@"获取群组列表失败");
        }
    }];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceAry count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row <[self.sourceAry count]){
        static NSString * cellName = @"SDIMGroupListCell";
        SDIMGroupListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell){
            cell = [[SDIMGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        [cell setGroup:self.sourceAry[indexPath.row]];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    return nil;
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
    if(indexPath.row <[self.sourceAry count]){
        self.sendShareView = [[CXSendShareView alloc] initWithShareTitle:_shareTitle AndShareUser:nil AndCXGroupInfo:self.sourceAry[indexPath.row] AndShareContent:_shareContent AndShareUrl:_shareUrl AndController:self];
        
    }
}

@end
