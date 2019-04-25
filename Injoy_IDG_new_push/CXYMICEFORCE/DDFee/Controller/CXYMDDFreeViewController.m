//
//  CXYMDDFreeViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/10.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMDDFreeViewController.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "CXYMDDFee.h"
#import "CXSearchView.h"
#import "CXYMAppearanceManager.h"
#import "CXYMProjectListCell.h"
#import "CXYMDDFeeDetailViewController.h"

@interface CXYMDDFreeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CXSearchView *searchView;
@property (nonatomic, strong) NSMutableArray <CXYMDDFee *>*dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *docName;

@end

static NSString *const DDFeeCellIdentity = @"DDFeeCellIdentity";

@implementation CXYMDDFreeViewController

#pragma mark -- setter&&getter
- (CXSearchView *)searchView{
    if(_searchView == nil){
        
    }
    return _searchView;
}
- (NSMutableArray <CXYMDDFee *> *)dataArray{
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
//        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
//            _tableView.estimatedRowHeight = 108;
//            _tableView.rowHeight = UITableViewAutomaticDimension;
//        }else{
//            _tableView.rowHeight = 108;
//        }
        _tableView.rowHeight = 108;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMProjectListCell class] forCellReuseIdentifier:DDFeeCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        _tableView.separatorColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.RootTopView setNavTitle:@"DDFee"];
    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.RootTopView setUpRightBarItemImage:Image(@"msgSearch") addTarget:self action:@selector(searchBtnClick)];
    self.pageNumber = 1;
    [self setupTableView];
    [self loadData];
}
#pragma mark -- searchBtnClick
- (void)searchBtnClick{
    self.searchView = [[CXSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.cxSearchType = CXSearchPM;
    [self.searchView showInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    self.searchView.searchTMTBlock = ^(NSString *keyword) {
        [weakSelf.dataArray removeAllObjects];
//groupId,

//        [weakSelf loadData];
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
        make.left.bottom.right.mas_equalTo(0);
    }];
}
- (void)reloadData{
    [self.dataArray removeAllObjects];
    self.pageNumber = 1;
    [self loadData];
}
- (void)loadMoreData{
    self.pageNumber ++;
    [self loadData];
}
-(void)endRefre{
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}
- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"news/letter/list/%ld",(long)self.pageNumber];
    NSDictionary *params = @{@"pageNumber":@(self.pageNumber),
                             @"groupId":self.groupId ? : @"",
                             @"docName":self.docName ? : @""};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            NSArray <CXYMDDFee *> *array =[NSArray yy_modelArrayWithClass:[CXYMDDFee class] json:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            [self endRefre];
            [self.tableView reloadData];
        }else if (status == 400){
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        } else {
            [self endRefre];
            self.pageNumber --;
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
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
    CXYMProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:DDFeeCellIdentity forIndexPath:indexPath];
    cell.selectionStyle = 0;
    CXYMDDFee *fee = self.dataArray[indexPath.row];
    cell.projectTypeImageView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
    cell.projectTypeImageView.clipsToBounds = YES;
    cell.projectTypeImageView.layer.cornerRadius = 23;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"DDFee";
    label.font = [CXYMAppearanceManager textNormalFont];
    label.textColor = [UIColor yy_colorWithHexString:@"#848E99"];
    [cell.projectTypeImageView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    cell.peojectNameLabel.text = fee.docName;
    cell.projectTypeLabel.text = fee.indusGroupName;
//    cell.projectMajorLabel.text = fee.newsDate;
    cell.projectDescribeLabel.text = fee.summary;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMDDFee *fee = self.dataArray[indexPath.row];
//    CXYMDDFeeDetailViewController *feeDetailViewController = [[CXYMDDFeeDetailViewController alloc] initWithDDFee:fee];
//    [self.navigationController pushViewController:feeDetailViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
