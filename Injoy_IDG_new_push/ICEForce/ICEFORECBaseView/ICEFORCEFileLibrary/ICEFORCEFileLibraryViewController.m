//
//  ICEFORCEFileLibraryViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEFileLibraryViewController.h"

#import "ICEFORCEFileLibraryTableViewCell.h"
#import "ICEFORCEFileLibraryModel.h"

#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"

@interface ICEFORCEFileLibraryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    float total;
    float pageCount;
}
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,assign) NSInteger pageNumber;

@property (nonatomic ,strong) NSMutableArray *personalArray;

@end

@implementation ICEFORCEFileLibraryViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"项目库"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(searchData:)];
    
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
    
    static NSString *LibraryCell = @"LibraryCell";
    
    ICEFORCEFileLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LibraryCell];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ICEFORCEFileLibraryTableViewCell" owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ICEFORCEFileLibraryModel *model = [self.personalArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(self.pageNumber) forKey:@"pageNo"];
    [dic setValue:@(10) forKey:@"pageSize"];
    [dic setValue:@"INVESTED" forKey:@"projType"];
//    [dic setValue:self.comIndu forKey:@"comIndu"];
//    [dic setValue:self.projInvestedStatus forKey:@"projInvestedStatus"];
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:POST_PROJ_Query_AllProj params:dic success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            total = [[[JSON objectForKey:@"data"] objectForKey:@"total"] floatValue];
            for (NSDictionary *dataDic in dataArray) {
                ICEFORCEFileLibraryModel *model = [ICEFORCEFileLibraryModel modelWithDict:dataDic];
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
#pragma mark - 搜索按钮
-(void)searchData:(UIButton *)sedner{
    
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
