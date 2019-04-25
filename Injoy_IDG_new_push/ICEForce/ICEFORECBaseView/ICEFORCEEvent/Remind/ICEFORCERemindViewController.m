//
//  ICEFORCERemindViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCERemindViewController.h"

#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"

#import "ICEFORCERemindTableViewCell.h"

#import "ICEFORCEPotentialDetailViewController.h"
#import "ICEFORCEPotentialProjectmModel.h"

@interface ICEFORCERemindViewController ()<UITableViewDelegate,UITableViewDataSource,ICEFORCERemindDelegate>{
    float total;
    float pageCount;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,assign) NSInteger pageNumber;
@property (nonatomic ,strong) NSMutableArray *personalArray;


@end

@implementation ICEFORCERemindViewController

-(NSMutableArray *)personalArray{
    if (!_personalArray) {
        _personalArray = [[NSMutableArray alloc]init];
    }
    return _personalArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
    [self loadService];
}
-(void)loadSubView{
    
    self.pageNumber = 0;
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, Screen_Height-50-K_Height_NavBar)) style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setupTableView];
}

- (void)setupTableView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
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
    [self.personalArray removeAllObjects];
    self.pageNumber = 0;
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
    return [self.personalArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *perAndGupCell = @"RemindCell";
    
    ICEFORCERemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:perAndGupCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCERemindTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [self.personalArray objectAtIndex:indexPath.row];
    
    cell.dataDic = dic;
    cell.delegateCell = self;
    
    return cell;
}

#pragma mark - 跳转项目详情
-(void)selectRemindCell:(ICEFORCERemindTableViewCell *)cell selectDataSource:(NSDictionary *)dataSource{
    
    NSString *projType = [dataSource objectForKey:@"projType"];
    if ([projType isEqualToString:@"POTENTIAL"]) {
        
        ICEFORCEPotentialProjectmModel *detailModel = [[        ICEFORCEPotentialProjectmModel alloc]init];
        detailModel.projId = [dataSource objectForKey:@"busId"];
        detailModel.projName = [dataSource objectForKey:@"projName"];
        detailModel.zhDesc = [dataSource objectForKey:@"zhDesc"];
        ICEFORCEPotentialDetailViewController *pjDatail = [[ICEFORCEPotentialDetailViewController alloc]init];
        pjDatail.model = detailModel;
        
        [self.navigationController pushViewController:pjDatail animated:YES];
    }
    
}

-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(self.pageNumber) forKey:@"pageNo"];
    [dic setValue:@(10) forKey:@"pageSize"];
    [dic setValue:@"TIPS" forKey:@"matterType"];
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_MSG_List params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            total = [[[JSON objectForKey:@"data"] objectForKey:@"total"] floatValue];
            for (NSDictionary *dataDic in dataArray) {
                
                [self.personalArray addObject:dataDic];
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
