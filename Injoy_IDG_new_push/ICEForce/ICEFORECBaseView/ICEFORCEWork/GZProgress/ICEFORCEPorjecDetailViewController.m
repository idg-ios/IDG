//
//  ICEFORCEPorjecDetailViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/11.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPorjecDetailViewController.h"

#import "ICEFORCEAddlyPorjecViewController.h"

#import "ICEFORCEPorjecDetailTextTableViewCell.h"
#import "ICEFORCEWorkProjectModel.h"


#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD+CXCategory.h"


@interface ICEFORCEPorjecDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    float total;
    float pageCount;
}

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *projectArray;
@property (nonatomic ,assign) NSInteger pageNumber;

@property (nonatomic ,assign) BOOL isDisplayMore;

@end

@implementation ICEFORCEPorjecDetailViewController

#pragma mark - 懒加载

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
    if (![MyPublicClass stringIsNull:self.pjId]) {
        self.pageNumber = 0;
    }else{
        self.pageNumber = 1;
    }
    
    SDRootTopView *rootTopView = [self getRootTopView];
    
    [rootTopView setNavTitle:self.navString];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
        [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"ICEFORCENewlyAdd"] addTarget:self action:@selector(newlyAddObject:)];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(rootTopView.frame))) style:(UITableViewStylePlain)];
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
        model.pjId = self.pjId;
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

#pragma mark - 新增跟踪进展
-(void)newlyAddObject:(UIButton *)sneder{
    ICEFORCEAddlyPorjecViewController *addlyPj = [[ICEFORCEAddlyPorjecViewController alloc]init];
    CXWeakSelf(self);
    addlyPj.AddlPJRefreshBlock = ^(NSString * _Nonnull messgae) {
        [weakself reloadData];
    };
    [self.navigationController pushViewController:addlyPj animated:YES];
}

-(void)loadService{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *url;
    if (![MyPublicClass stringIsNull:self.pjId]) {
        [dic setValue:self.pjId forKey:@"projId"];
        url = POST_PROJ_Notes;
    }else{
        url = POST_SNS_Follow;
    }
    
    [dic setValue:VAL_Account forKey:@"username"];
    [dic setValue:@(self.pageNumber) forKey:@"pageNo"];
    [dic setValue:@(10) forKey:@"pageSize"];
   
    
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    [HttpTool postWithPath:url params:dic success:^(id JSON) {
        
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
