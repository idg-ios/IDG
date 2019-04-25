//
//  CXCommonTemplateViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXCommonTemplateViewController.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "CXYMAppearanceManager.h"
#import "CXCommonTemplateCell.h"
#import "CXCommonTemplateModel.h"
#import "MBProgressHUD+CXCategory.h"

@interface CXCommonTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SDRootTopView *topView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, copy) NSString *nav_title;
//@property (nonatomic, copy) NSString *eid;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
static NSString *const CommonTemplateCellIdentity = @"CommonTemplateCellIdentity";
@implementation CXCommonTemplateViewController

#pragma mark -- setter && getter
//-(instancetype)initWithTitle:(NSString *)title eid:(NSString *)eid{
//    self = [super init];
//    if(self){
//        _nav_title = [title copy];
//        _eid = [eid copy];
//    }
//    return self;
//
//}

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
        _tableView.rowHeight = 600;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXCommonTemplateCell class] forCellReuseIdentifier:CommonTemplateCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        _tableView.separatorColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNumber = 1;
    [self setupUI];
    [self loadData];
    [self setupTableView];
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
#pragma mark --setupUI
- (void)setupUI{
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"常用模板"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}
#pragma mark --loadData
- (void)loadData{
    //pageNumber,s_title,i_kind
    NSString *path = [NSString stringWithFormat:@"%@",urlPrefix];
    NSDictionary *parmas = @{@"pageNumber":@(self.pageNumber),
                             @"s_title":@"",
                             @"i_kind":@(3)};
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:path params:parmas success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        NSInteger status = [JSON[@"status"] integerValue];
        [self endRefre];
        if (status == 200) {
            NSArray *array = [CXCommonTemplateModel commonTemplateArrayWithArray:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            
        }else{
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];

        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self endRefre];
        self.pageNumber --;
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
    
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXCommonTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:CommonTemplateCellIdentity forIndexPath:indexPath];
    cell.commonTemplateModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXCommonTemplateModel *model = self.dataArray[indexPath.row];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
