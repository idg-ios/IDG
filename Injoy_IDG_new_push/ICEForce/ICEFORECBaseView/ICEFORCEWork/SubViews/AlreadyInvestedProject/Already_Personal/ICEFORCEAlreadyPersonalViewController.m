//
//  ICEFORCEAlreadyPersonalViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEAlreadyPersonalViewController.h"

#import "ICEFORCEAlreadyRootTableViewCell.h"
#import "ICEFORCEAlreadyRootModel.h"

#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"


@interface ICEFORCEAlreadyPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,ICEFORCEAlreadyRootDelegate>{
    float total;
    float pageCount;
}
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,assign) NSInteger pageNumber;

@property (nonatomic ,strong) NSMutableArray *personalArray;


/** 行业id - 用于刷新 */
@property (nonatomic ,strong) NSString *comIndu;
@property (nonatomic ,strong) NSString *projInvestedStatus;

@end

@implementation ICEFORCEAlreadyPersonalViewController


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
    
    self.pageNumber = 1;
    
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
    return self.personalArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *AlreadyRootCell = @"AlreadyRootCell";
    
    ICEFORCEAlreadyRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlreadyRootCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEAlreadyRootTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ICEFORCEAlreadyRootModel *model = [self.personalArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegateCell = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

-(void)showAlreadyRootCell:(ICEFORCEAlreadyRootTableViewCell *)cell selectModel:(ICEFORCEAlreadyRootModel *)model selectButton:(UIButton *)sender{
    switch (sender.tag) {
        case 101:{
            self.comIndu = model.comIndu;
             [self reloadData];
        }
            break;
        case 102:{
            self.projInvestedStatus = model.projInvestedStatus;
             [self reloadData];
        }
             break;
        default:
            break;
    }
    NSLog(@"-----------%@",sender.currentTitle);
}

-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(self.pageNumber) forKey:@"pageNo"];
    [dic setValue:@(10) forKey:@"pageSize"];
    [dic setValue:@"INVESTED" forKey:@"projType"];
    [dic setValue:self.comIndu forKey:@"comIndu"];
    [dic setValue:self.projInvestedStatus forKey:@"projInvestedStatus"];
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_PROJ_Query_Myproj params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            total = [[[JSON objectForKey:@"data"] objectForKey:@"total"] floatValue];
            for (NSDictionary *dataDic in dataArray) {
                ICEFORCEAlreadyRootModel *model = [ICEFORCEAlreadyRootModel modelWithDict:dataDic];
                [self.personalArray addObject:model];
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
