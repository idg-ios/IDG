//
//  ICEFORCEPotentialPersonalViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPotentialPersonalViewController.h"

#import "ICEFORCEPerAndGupTableViewCell.h"
#import "ICEFORCEPotentialProjectmModel.h"

#import "ICEFORCEPotentialDetailViewController.h"

#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"
#import "YCXMenu.h"




@interface ICEFORCEPotentialPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,ICEFORCEPotentialProjectDelegate>{
    float total;
    float pageCount;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,assign) NSInteger pageNumber;

@property (nonatomic ,strong) NSMutableArray *personalArray;


/** 项目子阶段ID */
@property (nonatomic ,strong) NSString *subStsId;



@end

@implementation ICEFORCEPotentialPersonalViewController

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
    
    static NSString *perAndGupCell = @"perAndGupCell";
    
    ICEFORCEPerAndGupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:perAndGupCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEPerAndGupTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ICEFORCEPotentialProjectmModel *model = [self.personalArray objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegateCell = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ICEFORCEPotentialProjectmModel *model = [self.personalArray objectAtIndex:indexPath.row];
    ICEFORCEPotentialDetailViewController *detail = [[ICEFORCEPotentialDetailViewController alloc]init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}


-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(self.pageNumber) forKey:@"pageNo"];
    [dic setValue:@(10) forKey:@"pageSize"];
    [dic setValue:@"POTENTIAL" forKey:@"projType"];
    [dic setValue:self.subStsId forKey:@"stsId"];
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_PROJ_Query_Myproj params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            total = [[[JSON objectForKey:@"data"] objectForKey:@"total"] floatValue];
            for (NSDictionary *dataDic in dataArray) {
                ICEFORCEPotentialProjectmModel *model = [ICEFORCEPotentialProjectmModel modelWithDict:dataDic];
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

-(void)showStateCell:(ICEFORCEPerAndGupTableViewCell *)cell selectModel:(ICEFORCEPotentialProjectmModel *)model selectButton:(UIButton *)selecButton{
    switch (selecButton.tag) {
        case 101:{
            self.subStsId = model.stsId;
            [self reloadData];
        }
            break;
        case 102:{
            NSArray *array;
            if (model.followUpStatus.integerValue == 0) {
               
                array = @[[YCXMenuItem menuItem:@"跟踪" image:[UIImage imageNamed:@"half_star"] tag:101 userInfo:@{@"title":@"gz"}],
                          [YCXMenuItem menuItem:@"重点跟踪" image:[UIImage imageNamed:@"full_star"] tag:102 userInfo:@{@"title":@"zd"}]
                          ];
                
            }else if (model.followUpStatus.integerValue == 1){
              
                array = @[[YCXMenuItem menuItem:@"跟踪" image:[UIImage imageNamed:@"half_star"] tag:101 userInfo:@{@"title":@"gz"}],
                          [YCXMenuItem menuItem:@"取消跟踪" image:[UIImage imageNamed:@"blank_star"] tag:102 userInfo:@{@"title":@"zd"}]
                          ];
                
            }else{
                array = @[[YCXMenuItem menuItem:@"重点跟踪" image:[UIImage imageNamed:@"full_star"] tag:101 userInfo:@{@"title":@"gz"}],
                          [YCXMenuItem menuItem:@"取消跟踪" image:[UIImage imageNamed:@"blank_star"] tag:102 userInfo:@{@"title":@"zd"}]
                          ];
            }
            
           
//            CXWeakSelf(self);
            [YCXMenu showMenuInView:self.view fromRect:CGRectMake(selecButton.frame.origin.x+15, cell.frame.origin.y+30, 10, 20) menuItems:array selected:^(NSInteger index, YCXMenuItem *item) {
                
                
                
            }];
            [YCXMenu setTitleFont:[UIFont systemFontOfSize:14]];
            
            
        }
            break;
        default:
            break;
    }
  
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
