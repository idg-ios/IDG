//
//  CXYMBadAssetsViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMBadAssetsViewController.h"
#import "CXYMBadAssetsDetailViewController.h"
#import "HttpTool.h"
#import "CXYMAppearanceManager.h"
#import "CXYMProjectListCell.h"
#import "CXYMProjectModel.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIColor+CXYMCategory.h"
#import "UIView+CXCategory.h"
#import "CXSearchView.h"

@interface CXYMBadAssetsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CXYMBadAssetsModel *> * dataArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) CXSearchView *searchView;
@property (nonatomic, copy) NSString *keyword;///<搜索关键字
@end

static NSString *const badAssetsListCellIdentiy = @"badAssetsListCellIdentiy";

@implementation CXYMBadAssetsViewController

#pragma mark -- setter&getter
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100 - 8;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMProjectListCell class] forCellReuseIdentifier:badAssetsListCellIdentiy];
        _tableView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        _tableView.separatorColor = [UIColor clearColor];
//        _tableView.tableHeaderView = self.searchBar;
    }
    return _tableView;
}
- (UISearchBar *)searchBar{
    if(_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.bounds = CGRectMake(0, 0, 0, 40);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入名称";
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopView];
    self.pageNumber = 1;
    [self setupTableView];
    [self loadData];

}
- (void)setupTopView{
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.navTitle ? : @"不良资产"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [rootTopView setUpRightBarItemImage:Image(@"msgSearch") addTarget:self action:@selector(searchBtnClick)];

}

#pragma mark -- searchBtnClick
- (void)searchBtnClick{
    self.searchView = [[CXSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.cxSearchType = CXSearchTMT;
    [self.searchView showInView:self.view];

    __weak typeof(self) weakSelf = self;
    self.searchView.searchTMTBlock = ^(NSString *keyword) {
        [weakSelf.dataArray removeAllObjects];
        weakSelf.keyword = keyword;
        [weakSelf loadData];
    };
}
- (void)setupTableView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navHigh);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabbarSafeBottomMargin);
    }];
}
#pragma mark -- MJRefre
- (void)reloadData{
    [self.dataArray removeAllObjects];
    self.pageNumber = 1;
    [self loadData];
}
- (void)loadMoreData{
    self.pageNumber ++;
    [self loadData];
    
}
- (void)endRefre{
    if ([self.tableView.header isRefreshing]){
        [self.tableView.header endRefreshing];
    }
    if([self.tableView.footer isRefreshing]){
        [self.tableView.footer endRefreshing];
    }
}
#pragma mark-- loadData
- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"badAssets/list/%ld",(long)self.pageNumber];
    NSDictionary *params = @{@"pageNumber":@(self.pageNumber),@"s_projName": self.keyword ? : @""};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        if(![JSON isKindOfClass:[NSDictionary class]]) return ;
        NSInteger code = [JSON[@"status"] integerValue];
        NSInteger pageCount = [JSON[@"pageCount"] integerValue];
        if(code == 200){
            [self endRefre];
            if (self.pageNumber > pageCount) {//没有更多数据了
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }else{
                
            }
//            NSArray *array = [CXYMBadAssetsModel badAssetsArrayWithArray:JSON[@"data"]];
            NSArray<CXYMBadAssetsModel *> *array = [NSArray yy_modelArrayWithClass:[CXYMBadAssetsModel class] json:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }else if (code == 400){
            [self endRefre];

        }else{
            [self endRefre];
            self.pageNumber --;
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];

    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self endRefre];
        self.pageNumber --;
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

#pragma mark-- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:badAssetsListCellIdentiy forIndexPath:indexPath];
    if(self.dataArray == nil || self.dataArray.count == 0) return cell;//
    CXYMBadAssetsModel *badAssets = self.dataArray[indexPath.row];
    cell.projectTypeImageView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    cell.projectTypeImageView.clipsToBounds = YES;
    cell.projectTypeImageView.layer.cornerRadius = 23;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"不良";//label.text = badAssets.indusName;
    label.font = [CXYMAppearanceManager textNormalFont];
    label.textColor = [UIColor colorFromHexString:@"#848E99"];
    [cell.projectTypeImageView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    cell.peojectNameLabel.text = badAssets.ename;
    cell.projectTypeLabel.text = badAssets.indusName;
    cell.projectMajorLabel.text = badAssets.dealLeadName;
    cell.projectDescribeLabel.text = badAssets.grade;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray == nil || self.dataArray.count == 0) return;
    CXYMBadAssetsModel *badAssets =  self.dataArray[indexPath.row];
    CXYMBadAssetsDetailViewController *badAssetsDetailViewController = [[CXYMBadAssetsDetailViewController alloc] initWithBadAssets:badAssets];
    [self.navigationController pushViewController:badAssetsDetailViewController animated:YES];
}
#pragma mark --UISearchBarDelagate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar.text stringByReplacingOccurrencesOfString:@"" withString:@" "];
    if([searchBar.text isEqualToString:@""] || [searchBar.text isEqualToString:@"/n"]) return;
    [self loadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
