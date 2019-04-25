//
//  CXNewListWDSPRootViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/5/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXNewListWDSPRootViewController.h"
#import "Masonry.h"
#import "UIButton+LXMImagePosition.h"
#import "UIView+CXCategory.h"
#import "CXBussinessTripListViewController.h"
#import "CXVacationApprovalListViewController.h"
#import "CXReimbursementApprovalListViewController.h"
#import "CXXJSPListViewController.h"
#import "IDGXJListViewController.h"
#import "UIView+YYAdd.h"
#import "CXEditLabel.h"
#import "CXMiddleActionSheetSelectView.h"
#import "HttpTool.h"

@interface CXNewListWDSPRootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(copy, nonatomic) NSMutableArray *dataSourceArr;
@property(nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger traveCount;//出差审批数量
@property (nonatomic, assign) NSInteger holidayCount;//请假审批数量
@property (nonatomic, assign) NSInteger resumptionCount;//销假审批数量
@property (nonatomic, assign) NSInteger costCount;//报销审批数量

@end

@implementation CXNewListWDSPRootViewController

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        NSMutableArray * data = @[].mutableCopy;
        if(VAL_HAS_RIGHT_CCPS){
            [data addObject:@"差旅审批"];
        }
        if(VAL_HAS_RIGHT_QJPS){
            [data addObject:@"请假审批"];
        }
        if(VAL_HAS_RIGHT_XJPS){
            [data addObject:@"销假审批"];
        }
        if(VAL_HAS_RIGHT_BXPS){
            [data addObject:@"报销审批"];
        }
        
        
        _dataSourceArr = [[NSMutableArray alloc] initWithArray:data];
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
    self.rootTopView = rootTopView;//我的审批
    [rootTopView setNavTitle:@"我的审批"];
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
    
    NSInteger trave = [[NSUserDefaults standardUserDefaults] integerForKey:CX_trave];
//    NSInteger trave = [NSUserDefaults searchJPushTypeWithtype:@"1118" btype:@"15"].count;
    NSInteger holiday = [[NSUserDefaults standardUserDefaults] integerForKey:CX_holiday];
//    NSInteger holiday = [NSUserDefaults searchJPushTypeWithtype:@"1118" btype:@"2"].count;
    NSInteger resumption = [[NSUserDefaults standardUserDefaults] integerForKey:CX_resumption];
//    NSInteger resumption = [NSUserDefaults searchJPushTypeWithtype:@"1118" btype:@"14"].count;
    NSInteger cost = [[NSUserDefaults standardUserDefaults] integerForKey:CX_cost];
//    NSInteger cost = [NSUserDefaults searchJPushTypeWithtype:@"1118" btype:@"17"].count;
    if ([@"差旅审批" isEqualToString:title]) {
        count = trave;
//        count = self.traveCount;
    }else if ([@"请假审批" isEqualToString:title]) {
        count = holiday;
//        count = self.holidayCount;
    }else if ([@"销假审批" isEqualToString:title]) {
        count = resumption;
//        count = self.resumptionCount;
    }else if ([@"报销审批" isEqualToString:title]) {
        count = cost;
//        count = self.costCount;
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
    
    if ([@"差旅审批" isEqualToString:title]) {
//        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CLSP2);
        CXBussinessTripListViewController *vc = [[CXBussinessTripListViewController alloc]init];
        vc.lbType = CXBusinessTripPS;
        [self.navigationController pushViewController:vc animated:YES];
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"请假审批" isEqualToString:title]) {
//        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
        CXVacationApprovalListViewController *vc = [[CXVacationApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    if ([@"报销审批" isEqualToString:title]) {
//        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_BS);//新增报销审批
        CXReimbursementApprovalListViewController *vc = [[CXReimbursementApprovalListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    else if([@"销假审批" isEqualToString:title]){
        CXXJSPListViewController *vc = [[CXXJSPListViewController alloc] init];//销假审批
//        VAL_PUSHES_HAVEREAD_NEW(IM_PUSH_CK);
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
    
//    return;//
//    if(VAL_HAS_RIGHT_CCPS){
////        [self loadTraveCount];
//        [self loadApproveNumberWithType:@"trave"];
//    }
//    if(VAL_HAS_RIGHT_QJPS){
////        [self loadHolidayCount];
//        [self loadApproveNumberWithType:@"holiday"];
//    }
//    if(VAL_HAS_RIGHT_XJPS){
////        [self loadResumptionCount];
//        [self loadApproveNumberWithType:@"resumption"];
//    }
//    if(VAL_HAS_RIGHT_BXPS){
////        [self loadCostCount];
//        [self loadApproveNumberWithType:@"cost"];
//    }
    
}
#pragma mark -- 获取带审批类型的数量
- (void)loadApproveNumberWithType:(NSString *)type{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/%@",urlPrefix,type];
    NSDictionary *parmars = @{@"type":type};
    [HttpTool getWithPath:path params:parmars success:^(id JSON) {
        NSLog(@"获取带审批类型的数量%@",JSON);
        NSInteger status = [JSON[@"status"] integerValue];
        NSInteger data = [JSON[@"data"] integerValue];
        if (status == 200) {
            if ([type isEqualToString:@"trave"]) {
                self.traveCount = data;
            } else if([type isEqualToString:@"holiday"]){
                self.holidayCount = data;
            }else if([type isEqualToString:@"resumption"]){
                self.resumptionCount = data;
            }else if([type isEqualToString:@"cost"]){
                self.costCount = data;
            }
            //
            [self.tableView reloadData];
            //发出通知,内容为这4种类型的数量
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:@"" object:nil userInfo:@{@"trave":@(self.traveCount),@"holiday":@(self.holidayCount),@"resumption":@(self.resumptionCount),@"cost":@(self.costCount)}];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 出差审批,loadTraveCount
- (void)loadTraveCount{
    
}
#pragma mark -- 请假审批,loadHolidayCount
- (void)loadHolidayCount{
    
}
#pragma mark -- 销假审批,loadResumptionCount
- (void)loadResumptionCount{
    
}
#pragma mark --报销审批,loadCostCount
- (void)loadCostCount{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSumNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 获取我的审批总数量
-(void)getSumNumber{
    if([CXIMService sharedInstance].socketManager.state == CXIMSocketState_OPEN){
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_group_async(group, queue, ^{
            [self getTraveService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getHolidayService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getResumptionService:semaphore];
            
        });
        dispatch_group_async(group, queue, ^{
            [self getCostService:semaphore];
            
        });
       
        dispatch_group_notify(group, queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceivePushNotificationKey object:nil userInfo:nil];
            });
        });
    }
    
}

#pragma 获取出差数量
-(void)getTraveService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/trave",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_trave];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_semaphore_signal(semaphore);

        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取请假数量
-(void)getHolidayService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/holiday",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_holiday];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);

        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取销假数量
-(void)getResumptionService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/resumption",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_resumption];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);

        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma 获取报销数量
-(void)getCostService:(dispatch_semaphore_t)semaphore{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/approveNum/cost",urlPrefix];
    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSInteger data = [JSON[@"data"] integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:data forKey:CX_cost];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_semaphore_signal(semaphore);
        }
    } failure:^(NSError *error) {
        
    }];
}


@end
