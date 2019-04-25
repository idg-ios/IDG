//
//  ICEFORCEWorkViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEWorkViewController.h"
#import "ICEFORCEWorkShowTextCell.h"

#import "ICEFORCEWorkHeadView.h"
#import "ICEFORCEWorkOtherHeadView.h"

#import "HttpTool.h"
#import "MBProgressHUD+CXCategory.h"

#import "ICEFORCEWorkProjectModel.h"

#import "ICEFORCEPorjecDetailViewController.h"

#import "ICEFORCEWorkPotentialProjectViewController.h"
#import "ICEFORCENewlyAddPotentialProjectViewController.h"

#import "ICEFORCEAlreadyInvestedRootViewController.h"
#import "ICEFORCEFollowOnViewController.h"

#import "ICEFORCEPotentialDetailViewController.h"
#import "ICEFORCEPotentialProjectmModel.h"

@interface ICEFORCEWorkViewController ()<UITableViewDelegate,UITableViewDataSource,ICEFORCEWorkShowTextDelegate,ICEFORCEWorkHeadViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) ICEFORCEWorkHeadView *topHeadView;
@property (nonatomic ,strong) ICEFORCEWorkOtherHeadView *middleHeadView;
@property (nonatomic ,strong) ICEFORCEWorkOtherHeadView *bottomHeadView;

@property (nonatomic ,strong) NSMutableArray *projectArray;
@property (nonatomic ,strong) NSArray *eventArray;


@end

@implementation ICEFORCEWorkViewController

#pragma mark - 懒加载

-(NSMutableArray *)projectArray{
    if (!_projectArray) {
        _projectArray = [[NSMutableArray alloc]init];
    }
    return _projectArray;
}

-(ICEFORCEWorkHeadView *)topHeadView{
    if (!_topHeadView) {
        _topHeadView = [ICEFORCEWorkHeadView viewFromXIB];
        _topHeadView.delegateCell = self;
    }
    return _topHeadView;
}
-(ICEFORCEWorkOtherHeadView *)middleHeadView{
    if (!_middleHeadView) {
        _middleHeadView = [ICEFORCEWorkOtherHeadView viewFromXIB];
        _middleHeadView.porjectName.text = @"工作圈";
        [_middleHeadView.jumpDetail addTarget:self action:@selector(projectProgress:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _middleHeadView;
}
-(ICEFORCEWorkOtherHeadView *)bottomHeadView{
    if (!_bottomHeadView) {
        _bottomHeadView = [ICEFORCEWorkOtherHeadView viewFromXIB];
        _bottomHeadView.porjectName.text = @"待办事项";
        [_bottomHeadView.jumpDetail addTarget:self action:@selector(event:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _bottomHeadView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadSubView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadService];
    
}
-(void)loadSubView{
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"IceForce"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"ICEFORCENewlyAdd"] addTarget:self action:@selector(newlyAddObject:)];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(rootTopView.frame)-K_Height_TabBar)) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return self.projectArray.count;
    }else{
        
        return self.eventArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200;
        
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 0.01;
    }else{
        return 6;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.topHeadView;
        
    }else if (section == 1){
        return self.middleHeadView;
    }else{
        return self.bottomHeadView;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *workCell = @"workCell";
    
    ICEFORCEWorkShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:workCell];
    if (cell == nil) {
        
        cell = [[ICEFORCEWorkShowTextCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:workCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegateCell = self;
    cell.indexPath = indexPath;
    if (indexPath.section == 1) {
        cell.isLongPress = YES;
        
        ICEFORCEWorkProjectModel *model = [self.projectArray objectAtIndex:indexPath.row];
        
        NSString *contentType = model.contentType;
        
        NSString *followType = model.followType;
        
        
        if ([contentType isEqualToString:@"TEXT"] ) {
            
            if (![followType isEqualToString: @"UPDATE_STATE"]) {
                cell.options = ICEFORCEWorkShowOptionAttText;
                
                cell.attString = model.showDesc;
                cell.selectString = model.projName;
                
            }else{
                cell.options = ICEFORCEWorkShowOptionText;
                cell.attString = model.showDesc;
                cell.selectString = model.projName;
                cell.stateString = model.projState;
            }
            
        }else{
            cell.options = ICEFORCEWorkShowOptionGif;
            cell.selectString = model.projName;
            cell.voiceUrl = model.url;
            cell.voiceTime = model.audioTime.integerValue;
            
        }
    }
    
    if (indexPath.section == 2) {
        cell.isLongPress = NO;
        
        NSDictionary *porDic = [self.eventArray objectAtIndex:indexPath.row];
        cell.options = ICEFORCEWorkShowOptionAttText;
        
        cell.attString = [porDic objectForKey:@"showDesc"];
        cell.selectString = [porDic objectForKey:@"projName"];
        //        cell.stateString = [porDic objectForKey:@"busType"];
        
    }
    
    return cell;
    
}

#pragma mark - 新增潜在项目
-(void)newlyAddObject:(UIButton *)sneder{
    
    CXWeakSelf(self);
    ICEFORCENewlyAddPotentialProjectViewController *newlyAdd = [[ICEFORCENewlyAddPotentialProjectViewController alloc]init];
    newlyAdd.newlyAddBlock = ^(BOOL refreshView) {
        
        [weakself loadService];
        
    };
    [self.navigationController pushViewController:newlyAdd animated:YES];
    
}
#pragma mark - 跳转项目详情
-(void)showTextCell:(ICEFORCEWorkShowTextCell *)cell selectIndex:(NSIndexPath *)path{
    if (path.section == 1) {
        ICEFORCEWorkProjectModel *model =  [self.projectArray objectAtIndex:path.row];
        if ([model.projType isEqualToString:@"POTENTIAL"]) {
            
            ICEFORCEPotentialProjectmModel *detailModel = [[        ICEFORCEPotentialProjectmModel alloc]init];
            detailModel.projId = model.projId;
            detailModel.projName = model.projName;
            detailModel.zhDesc = model.zhDesc;
            ICEFORCEPotentialDetailViewController *pjDatail = [[ICEFORCEPotentialDetailViewController alloc]init];
            pjDatail.model = detailModel;
            
            [self.navigationController pushViewController:pjDatail animated:YES];
        }
    }
    if (path.section == 2) {
        
        NSDictionary *porDic = [self.eventArray objectAtIndex:path.row];
        NSString *projType = [porDic objectForKey:@"projType"];
        if ([projType isEqualToString:@"POTENTIAL"]) {
            
            ICEFORCEPotentialProjectmModel *detailModel = [[        ICEFORCEPotentialProjectmModel alloc]init];
            detailModel.projId = [porDic objectForKey:@"busId"];
            detailModel.projName = [porDic objectForKey:@"projName"];
            detailModel.zhDesc = [porDic objectForKey:@"zhDesc"];
            ICEFORCEPotentialDetailViewController *pjDatail = [[ICEFORCEPotentialDetailViewController alloc]init];
            pjDatail.model = detailModel;
            
            [self.navigationController pushViewController:pjDatail animated:YES];
        }
        
    }
}
-(void)showTextCell:(ICEFORCEWorkShowTextCell *)cell jumpDescDetail:(NSString *)detail{
    NSLog(@"卧槽，拿到了详情数据 正确吗？------- %@",detail);
}

#pragma mark - topHeadView代理
-(void)selectButton:(UIButton *)sender buttonTag:(NSInteger)tag{
    switch (tag) {
        case 101:{
            ICEFORCEAlreadyInvestedRootViewController *already = [[ICEFORCEAlreadyInvestedRootViewController alloc]init];
            [self.navigationController pushViewController:already animated:YES];
        }
            break;
        case 102:{
            
            ICEFORCEFollowOnViewController *followOn = [[ICEFORCEFollowOnViewController alloc]init];
            [self.navigationController pushViewController:followOn animated:YES];
        }
            break;
        case 103:{
            ICEFORCEWorkPotentialProjectViewController *potential = [[ICEFORCEWorkPotentialProjectViewController alloc]init];
            [self.navigationController pushViewController:potential animated:YES];
        }
            break;
        case 104:{
            
        }
            break;
        case 105:{
            
        }
            break;
        case 106:{
            
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - 跳转项目进展详情界面
-(void)projectProgress:(UIButton *)sender{
    
    
     self.tabBarController.selectedIndex = 1;
//    ICEFORCEPorjecDetailViewController *detail = [[ICEFORCEPorjecDetailViewController alloc]init];
//    detail.navString = @"跟踪进展";
//    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 跳转待办事项详情界面
-(void)event:(UIButton *)sneder{
    
    self.tabBarController.selectedIndex = 2;
}


#pragma mark - 网络请求
-(void)loadService{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        [self loadSNSFloowService:semaphore];
    });
    dispatch_group_async(group, queue, ^{
        [self loadMSGListService:semaphore];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    });
    
}
#pragma mark - 跟踪项目进展网络请求
-(void)loadSNSFloowService:(dispatch_semaphore_t)semaphore{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(1) forKey:@"pageNo"];
    [dic setValue:@(5) forKey:@"pageSize"];
    
    
    [HttpTool postWithPath:POST_SNS_Follow params:dic success:^(id JSON) {
        
        [self.projectArray removeAllObjects];
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            for (NSDictionary *dataDic in dataArray) {
                ICEFORCEWorkProjectModel *model = [ICEFORCEWorkProjectModel modelWithDict:dataDic];
                [self.projectArray addObject:model];
                
            }
            
            dispatch_semaphore_signal(semaphore);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
#pragma mark - 待办事项网络请求
-(void)loadMSGListService:(dispatch_semaphore_t)semaphore{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(0) forKey:@"pageNo"];
    [dic setValue:@(3) forKey:@"pageSize"];
    [dic setValue:@"TODO" forKey:@"matterType"];
    
    [HttpTool postWithPath:POST_MSG_List params:dic success:^(id JSON) {
        
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            self.eventArray = dataArray;
            dispatch_semaphore_signal(semaphore);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
