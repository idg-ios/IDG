//
//  ICEFORCEProjectViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEProjectViewController.h"

#import "ICEFORCEIndustryCollectView.h"
#import "ICEFORCEAddlyPorjecViewController.h"

#import "ICEFORCEPorjecDetailTextTableViewCell.h"
#import "ICEFORCEWorkProjectModel.h"


#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"
#import "YCXMenu.h"

@interface ICEFORCEProjectViewController ()<UITableViewDelegate,UITableViewDataSource>{
    float total;
    float pageCount;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *projectArray;
@property (nonatomic ,assign) NSInteger pageNumber;

@property (nonatomic ,assign) BOOL isDisplayMore;

@property (nonatomic ,strong) NSMutableDictionary *loadData;

@property (nonatomic ,strong) SDRootTopView *rootTopView;
@property (nonatomic ,strong) ICEFORCEIndustryCollectView *industView;

@end

@implementation ICEFORCEProjectViewController

#pragma mark - 懒加载
-(NSMutableDictionary *)loadData{
    if (!_loadData) {
        _loadData = [[NSMutableDictionary alloc]init];
    }
    return _loadData;
}

-(NSMutableArray *)projectArray{
    if (!_projectArray) {
        _projectArray = [[NSMutableArray alloc]init];
    }
    return _projectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    [self loadService];
}
-(void)loadSubView{
    
    self.view.backgroundColor = [UIColor whiteColor];
  
        self.pageNumber = 1;

    
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    UIButton *titleButton = [[UIButton alloc]initWithFrame:(CGRectMake((self.view.frame.size.width-60)/2, CGRectGetHeight(self.rootTopView.frame)-31, 80, 20))];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(2, -34, 4, 0);
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(2, 58, 4, 0);
    [titleButton setTitle:@"工作圈" forState:(UIControlStateNormal)];
    [titleButton setImage:[UIImage imageNamed:@"arrow_spread"] forState:(UIControlStateNormal)];
    [titleButton setImage:[UIImage imageNamed:@"arrow_retract"] forState:(UIControlStateSelected)];
    [titleButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.rootTopView addSubview:titleButton];
    [titleButton addTarget:self action:@selector(showIndustry:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIButton *add_Circular = [[UIButton alloc]initWithFrame:(CGRectMake(self.view.frame.size.width-40, CGRectGetHeight(self.rootTopView.frame)-40, 40, 40))];
    [add_Circular setImage:[UIImage imageNamed:@"add_Circular"] forState:(UIControlStateNormal)];
    [add_Circular addTarget:self action:@selector(addRight:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.rootTopView addSubview:add_Circular];
    
    UIButton *time_Refresh = [[UIButton alloc]initWithFrame:(CGRectMake(self.view.frame.size.width-80, CGRectGetHeight(self.rootTopView.frame)-40, 40, 40))];
    [time_Refresh addTarget:self action:@selector(timeRefresh:) forControlEvents:(UIControlEventTouchUpInside)];
    [time_Refresh setImage:[UIImage imageNamed:@"mine_setting"] forState:(UIControlStateNormal)];
    [self.rootTopView addSubview:time_Refresh];
    
  
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(self.rootTopView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(self.rootTopView.frame)-K_Height_TabBar)) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setupTableView];
}

- (void)setupTableView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.loadData setValue:nil forKey:@"comIndu"];
        [weakSelf.loadData setValue:nil forKey:@"followUpStatus"];
        [weakSelf.loadData setValue:nil forKey:@"isMyFollow"];
        [weakSelf.loadData setValue:nil forKey:@"dateRange"];

        [weakSelf reloadData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        pageCount = ceil(total/10);
        if (self.pageNumber == pageCount) {
            [weakSelf endRefre];
            return;
        }
        [weakSelf loadMoreData];
    }];
    
}

- (void)reloadData{
    [self.projectArray removeAllObjects];
    self.pageNumber = 1;
    [self loadService];
}
- (void)loadMoreData{
    self.pageNumber ++;
    [self loadService];
}
-(void)endRefre{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.projectArray.count;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ICEFORCEWorkProjectModel *model = [self.projectArray objectAtIndex:indexPath.row];
    if (model.isShowMore == YES) {
        
        return 45+24+20+11+model.dscHeight;
        
    }else{
        
        return 150;
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *detailTextCell = @"DetailTextCell";
    
    ICEFORCEPorjecDetailTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailTextCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPorjecDetailTextTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    ICEFORCEWorkProjectModel *model = [self.projectArray objectAtIndex:indexPath.row];
    cell.detailModel = model;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ICEFORCEWorkProjectModel *model = [self.projectArray objectAtIndex:indexPath.row];
    
    CGRect rect = [MyPublicClass stringHeightByWidth:ScreenWidth-100 title:model.showDesc font:[UIFont systemFontOfSize:15]];
    if (rect.size.height > 50) {
        model.isShowMore = YES;
        
    }else{
        model.isShowMore = NO;
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - 行业界面展示
-(void)showIndustry:(UIButton *)sender{
  
    if ((sender.selected =! sender.selected)) {
        self.industView = [[ICEFORCEIndustryCollectView alloc]init];
        self.industView.frame = CGRectMake(0, CGRectGetMaxY(self.rootTopView.frame), self.view.frame.size.width, ScreenHeight-CGRectGetMaxY(self.rootTopView.frame)-K_Height_TabBar);
        [self.view addSubview:self.industView];
        CXWeakSelf(self);
        self.industView.IndustryBlock = ^(ICEFORCEIndustryModel * _Nonnull model) {
            [weakself.loadData setValue:model.codeKey forKey:@"comIndu"];
           
            [weakself.loadData setValue:nil forKey:@"followUpStatus"];
            [weakself.loadData setValue:nil forKey:@"isMyFollow"];
            [weakself.loadData setValue:nil forKey:@"dateRange"];
            [weakself reloadData];
            sender.selected = NO;
        };
        
    }else{
        [self.industView removeFromSuperview];
    }
}
#pragma mark - 最右侧点击按钮
-(void)addRight:(UIButton *)sender{
    
    NSArray *array = @[[YCXMenuItem menuItem:@"工作进展" image:[UIImage imageNamed:@"mine_config"] tag:100 userInfo:@{@"title":@"work"}],
                       [YCXMenuItem menuItem:@"我的工作圈" image:[UIImage imageNamed:@"mine_superuser"] tag:100 userInfo:@{@"title":@"myCircle"}]
                       ,[YCXMenuItem menuItem:@"重点跟踪" image:[UIImage imageNamed:@"mine_setting"] tag:100 userInfo:@{@"title":@"keyNote"}]
                       
                       ];
      CXWeakSelf(self);
    [YCXMenu showMenuInView:self.view fromRect:sender.frame menuItems:array selected:^(NSInteger index, YCXMenuItem *item) {
        
        if ([item.title isEqualToString:@"工作进展"]) {
            ICEFORCEAddlyPorjecViewController *addlyPj = [[ICEFORCEAddlyPorjecViewController alloc]init];
          
            addlyPj.AddlPJRefreshBlock = ^(NSString * _Nonnull messgae) {
                [weakself reloadData];
            };
            [self.navigationController pushViewController:addlyPj animated:YES];
        }else if ([item.title isEqualToString:@"我的工作圈"]){
            
            [weakself.loadData setValue:nil forKey:@"comIndu"];
            [weakself.loadData setValue:nil forKey:@"isMyFollow"];
            [weakself.loadData setValue:nil forKey:@"dateRange"];
            
            [self.loadData setValue:@"2" forKey:@"followUpStatus"];
            [weakself reloadData];
        }else{
            [weakself.loadData setValue:nil forKey:@"comIndu"];            
            [weakself.loadData setValue:nil forKey:@"followUpStatus"];
            [weakself.loadData setValue:nil forKey:@"dateRange"];
            
            [weakself.loadData setValue:@"1" forKey:@"isMyFollow"];
            [weakself reloadData];
        }
        
    }];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:14]];

}
#pragma mark - 按时间刷新
-(void)timeRefresh:(UIButton *)sneder{
    
    NSArray *array = @[[YCXMenuItem menuItem:@"全部" image:[UIImage imageNamed:@"mine_config"] tag:100 userInfo:@{@"title":@"all"}],
                       [YCXMenuItem menuItem:@"最新一周" image:[UIImage imageNamed:@"mine_superuser"] tag:100 userInfo:@{@"title":@"oneWeek"}]
                       ,[YCXMenuItem menuItem:@"最新一月" image:[UIImage imageNamed:@"mine_setting"] tag:100 userInfo:@{@"title":@"oneMonth"}]
                       ,[YCXMenuItem menuItem:@"最新三月" image:[UIImage imageNamed:@"mine_setting"] tag:100 userInfo:@{@"title":@"threeMonth"}]
                       
                       ];
    CXWeakSelf(self);
    [YCXMenu showMenuInView:self.view fromRect:sneder.frame menuItems:array selected:^(NSInteger index, YCXMenuItem *item) {
        
        [weakself.loadData setValue:nil forKey:@"comIndu"];
        [weakself.loadData setValue:nil forKey:@"followUpStatus"];
        [weakself.loadData setValue:nil forKey:@"isMyFollow"];
        
        if ([item.title isEqualToString:@"全部"]) {
            [self.loadData setValue:@"All" forKey:@"dateRange"];
            [weakself reloadData];
        }else if ([item.title isEqualToString:@"最新一周"]){
            [self.loadData setValue:@"1Week" forKey:@"dateRange"];
            [weakself reloadData];
        }else if ([item.title isEqualToString:@"最新一月"]){
            [self.loadData setValue:@"1Month" forKey:@"dateRange"];
            [weakself reloadData];
        }else{
            [self.loadData setValue:@"3Month" forKey:@"dateRange"];
            [weakself reloadData];
        }
        
    }];
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:14]];
    
}

#pragma mark - 工作圈网络请求
-(void)loadService{
    
    [self.loadData setValue:VAL_Account forKey:@"username"];
    [self.loadData setValue:@(self.pageNumber) forKey:@"pageNo"];
    [self.loadData setValue:@(10) forKey:@"pageSize"];
    
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_SNS_Follow params:self.loadData success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            total = [[[JSON objectForKey:@"data"] objectForKey:@"total"] floatValue];
            
            for (NSDictionary *dataDic in dataArray) {
                
                ICEFORCEWorkProjectModel *model = [ICEFORCEWorkProjectModel modelWithDict:dataDic];
                [self.projectArray addObject:model];
                
            }
            [self endRefre];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self endRefre];
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
        
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
