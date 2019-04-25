//
//  CXDepartmentListViewController.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDepartmentListViewController.h"
#import "CXCXDepartmentListModel.h"
#import "HttpTool.h"
#import "UIView+Category.h"
#import "CXDepartmentUserListViewController.h"

@interface CXDepartmentListViewController ()<UITableViewDataSource, UITableViewDelegate>

/// 导航条
@property (nonatomic, strong) SDRootTopView* rootTopView;
/// 内容视图
@property (nonatomic, strong) UITableView* tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray<CXCXDepartmentListModel *>* dataArray;

@end

@implementation CXDepartmentListViewController

- (NSMutableArray<CXCXDepartmentListModel *> *)dataArray{
    if(!_dataArray){
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self loadDataSource];
}

#pragma mark - 内部方法
- (void)setupView
{
    self.view.backgroundColor = SDBackGroudColor;
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"部门")];
    
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
    NSString *url = [NSString stringWithFormat:@"%@sysuser/dept/count", urlPrefix];
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    [HttpTool postWithPath:url params:nil success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            if(JSON[@"data"]){
                [self.dataArray removeAllObjects];
                NSArray * dataArray = [NSArray yy_modelArrayWithClass:CXCXDepartmentListModel.class json:JSON[@"data"]];
                [self.dataArray addObjectsFromArray:dataArray];
            }
            [self.tableView reloadData];
        }else if ([JSON[@"status"] intValue] == 400) {
            [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count] + 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return SDCellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellName = @"cellName";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }else{
        for(UIView * view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
    }
    if(indexPath.row < [self.dataArray count]){
        CXCXDepartmentListModel * model = self.dataArray[indexPath.row];
        UILabel * deptNameLabel = [[UILabel alloc] init];
        deptNameLabel.text = model.deptName;
        deptNameLabel.font = [UIFont systemFontOfSize:17.0];
        deptNameLabel.backgroundColor = [UIColor clearColor];
        deptNameLabel.textColor = [UIColor blackColor];
        [deptNameLabel sizeToFit];
        deptNameLabel.frame = CGRectMake(20, 0, deptNameLabel.size.width, SDCellHeight);
        [cell.contentView addSubview:deptNameLabel];
        
        UILabel * countLabel = [[UILabel alloc] init];
        countLabel.text = [NSString stringWithFormat:@"%@人",model.num.stringValue];
        countLabel.font = [UIFont systemFontOfSize:15.0];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textColor = RGBACOLOR(161.0, 161.0, 161.0, 1.0);
        [countLabel sizeToFit];
        countLabel.frame = CGRectMake(Screen_Width - 215, 0, 175, SDCellHeight);
        countLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:countLabel];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.row == [self.dataArray count]){
        static NSString * cellBottom = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellBottom];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBottom];
        }else{
            for(UIView * view in cell.contentView.subviews){
                [view removeFromSuperview];
            }
        }
        UILabel * numberOfDpLabel = [[UILabel alloc] init];
        numberOfDpLabel.frame = CGRectMake(0, 0, Screen_Width, SDCellHeight);
        numberOfDpLabel.backgroundColor = [UIColor clearColor];
        numberOfDpLabel.textColor = SDSectionTitleColor;
        numberOfDpLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:numberOfDpLabel];
        
        UIView * bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = SDBackGroudColor;
        bottomView.frame = CGRectMake(0, SDCellHeight - 2, Screen_Width, 6);
        [cell addSubview:bottomView];
        
        numberOfDpLabel.text = [NSString stringWithFormat:@"%zd个部门",[self.dataArray count]];
        cell.contentView.backgroundColor = SDBackGroudColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    CXDepartmentUserListViewController* departmentUserListViewController = [[CXDepartmentUserListViewController alloc] init];
    CXCXDepartmentListModel * model = self.dataArray[indexPath.row];
    departmentUserListViewController.deptId = model.deptId;
    departmentUserListViewController.deptName = model.deptName;
    [self.navigationController pushViewController:departmentUserListViewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

}

@end
