//
//  CXYMBadAssetsProgressViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

//
//// ////////新建页
//// //////////// ////////单输入框搜索
////列表页>>>>>>搜索
//// //////////// ////////多条件筛选搜索
//// //////////// //////单列详情
//// ////////详情页>>
////// //////////// ////多列详情
//
//

#import "CXYMBadAssetsProgressViewController.h"
#import "CXYMProjectModel.h"
#import "CXYMBadAssetsDetailModel.h"
#import "Masonry.h"
#import "CXYMNormalListCell.h"
#import "HttpTool.h"
#import "CXYMAppearanceManager.h"
#import "MJRefresh.h"
#import "CXYMBadAssetsProgress.h"

@interface CXYMBadAssetsProgressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CXYMBadAssetsModel *badAssets;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <CXYMBadAssetsProgress *>*dataArray;
@property (nonatomic, assign) NSInteger pageNumber;

@end

static NSString *const badAssetsProgressCellIdentity = @"badAssetsProgressCellIdentity";

@implementation CXYMBadAssetsProgressViewController

- (instancetype)initWithBadAssets:(CXYMBadAssetsModel *)badAssets{
    self = [super init];
    if(self) {
        self.badAssets = badAssets;
    }
    return self;
}

#pragma mark -- setter&getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            _tableView.rowHeight = 60;
        }else{
            _tableView.rowHeight = UITableViewAutomaticDimension;
            _tableView.estimatedRowHeight = 60;
        }
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMNormalListCell class] forCellReuseIdentifier:badAssetsProgressCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        _tableView.separatorColor = [CXYMAppearanceManager appSeparatorColor];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNumber = 1;
    [self.RootTopView setNavTitle:self.badAssets.ename ? : @"" ];
    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    [self setupTableView];
    [self loadData];
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
        make.left.bottom.right.mas_equalTo(0);
    }];
}
#pragma mark -- loadData
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
- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"badAssets/progress/list/%ld/%zd",(long)[self.badAssets.projId integerValue],self.pageNumber];
    NSDictionary *params = @{@"projId":self.badAssets.projId,@"pageNumber":@(self.pageNumber)};
    [HttpTool getWithPath:path params:params success:^(id JSON) {
        NSInteger statue = [JSON[@"status"] integerValue];
        if(statue == 200){
            NSArray <CXYMBadAssetsProgress *>*array = [NSArray yy_modelArrayWithClass:[CXYMBadAssetsProgress class] json:JSON[@"data"]];
            if(array.count == 0){
                [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] ? : @"暂无数据" AndPictureName:@"pic_kzt_wsj"];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }else{
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        [self endRefre];
        self.pageNumber --;
        [self.tableView setNeedShowEmptyTipByCount:self.dataArray.count];
        CXAlert(KNetworkFailRemind);
    }];
}
#pragma mark--  UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 10;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMNormalListCell *cell = [tableView dequeueReusableCellWithIdentifier:badAssetsProgressCellIdentity forIndexPath:indexPath];
    CXYMBadAssetsProgress *badAssetsProgress = self.dataArray[indexPath.row];
    cell.titleLabel.text = badAssetsProgress.editDate;
    cell.contentLabel.numberOfLines = 0;
    cell.contentLabel.text = badAssetsProgress.actionContent;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
