//
//  CXNewListWDCLRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewListWDCLRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXBussinessTripEditViewController.h"
#import "CXTravalController.h"
#import "CXBussinessTripListViewController.h"

@interface CXNewListWDCLRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(nonatomic, strong) UITableView * tableView;

@end

@implementation CXNewListWDCLRootViewController

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"差旅申请", @"我的出差", nil];
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

#pragma mark - UI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"我的差旅"];
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
    if ([@"我的出差" isEqualToString:title]) {
        count = [self.view countNumBadge:IM_PUSH_CLSP,nil];
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
    
    if ([@"差旅申请" isEqualToString:title]) {
        CXBussinessTripEditViewController *vc = [[CXBussinessTripEditViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"差旅预定" isEqualToString:title]) {
        CXTravalController *vc = [CXTravalController new];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if ([@"我的出差" isEqualToString:title]){
        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CLSP);
        
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)receivePushNotification{
    [self.tableView reloadData];
}


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 红点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification) name:kReceivePushNotificationKey object:nil];//我的审批,收到推送
    
    [self setUpNavBar];
    self.tableView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
