//
//  CXIDGCapitalExpressListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGCapitalExpressListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGCapitalExpressListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXIDGProjectManagementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXIDGNewCapitalExpressTableViewCell.h"
#import "CXProjectSearchView.h"
#import "CXIDGCapitalExpressDetailViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXIDGCapitalExpressListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXIDGCapitalExpressListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXIDGCapitalExpressListViewController

#pragma mark - get & set

- (NSMutableArray<CXIDGCapitalExpressListModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = [UIColor clearColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"公众号"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.mas_equalTo(navHigh);
    }];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    @weakify(self)
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self)
        [self getListWithPage:self.pageNumber + 1];
    }];
    [self.listTableView.footer setHidden:YES];
}

- (void)sortDataSourceArr
{
    if(self.dataSourceArr && [self.dataSourceArr count] > 0){
        NSComparator cmptr = ^(CXIDGCapitalExpressListModel * model1, CXIDGCapitalExpressListModel * model2){
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] > [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([[self getTimeStringWithCreateTime:model1.createTime] longLongValue] < [[self getTimeStringWithCreateTime:model2.createTime] longLongValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        self.dataSourceArr = [NSMutableArray arrayWithArray:[[NSArray arrayWithArray:self.dataSourceArr] sortedArrayUsingComparator:cmptr]];
    }
}

- (NSString *)getTimeStringWithCreateTime:(NSString *)createTime{
    NSArray * strArray1 = [createTime componentsSeparatedByString:@" "];
    NSArray * strArray2 = [strArray1[0] componentsSeparatedByString:@"-"];
    NSArray * strArray3 = [strArray1[1] componentsSeparatedByString:@":"];
    NSString * timeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",strArray2[0],strArray2[1],strArray2[2],strArray3[0],strArray3[1],strArray3[2]];
    return timeStr;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpNavBar];
    [self setUpTableView];
    [self getListWithPage:self.pageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self getLastFiveIdsString]){
        NSString * LastFiveIdsString = [NSString stringWithFormat:@"LastFiveIdsString_%@",VAL_HXACCOUNT];
        [[NSUserDefaults standardUserDefaults] setValue:[self getLastFiveIdsString] forKey:LastFiveIdsString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([self getLastFiveIdsString]){
        NSString * LastFiveIdsString = [NSString stringWithFormat:@"LastFiveIdsString_%@",VAL_HXACCOUNT];
        [[NSUserDefaults standardUserDefaults] setValue:[self getLastFiveIdsString] forKey:LastFiveIdsString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXIDGCapitalExpressDetailViewController *vc = [[CXIDGCapitalExpressDetailViewController alloc] init];
    CXIDGCapitalExpressListModel *listModel = self.dataSourceArr[indexPath.section];
    vc.model = listModel;
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CXIDGNewCapitalExpressTableViewCell";
    CXIDGNewCapitalExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXIDGNewCapitalExpressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CXIDGCapitalExpressListModel *model = self.dataSourceArr[indexPath.section];
    [cell setCXIDGCapitalExpressListModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXIDGCapitalExpressListModel *model = self.dataSourceArr[indexPath.section];
    return [CXIDGNewCapitalExpressTableViewCell getCXIDGCapitalExpressListTableViewCellHeightWithCXIDGCapitalExpressListModel:model];
}

#pragma mark <---请求列表--->
- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@wx/bulletin/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL hasNextPage = pageCount > page;
            [self.listTableView.header setHidden:!hasNextPage];
            NSArray<CXIDGCapitalExpressListModel *> *data = [NSArray yy_modelArrayWithClass:[CXIDGCapitalExpressListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            [self sortDataSourceArr];
            [self.listTableView reloadData];
            if(page == 1){
                [self scrollToBottom];
            }
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

- (void)scrollToBottom
{
    NSInteger section = [self.listTableView numberOfSections];
    if (section > 0) {
        [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.dataSourceArr count]-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSString *)getLastFiveIdsString{
    if(self.dataSourceArr && [self.dataSourceArr count] > 0){
        NSMutableString * lastFiveIds = [[NSMutableString alloc] init];
        if([self.dataSourceArr count] == 1){
            [lastFiveIds appendString:self.dataSourceArr.firstObject.mid];
        }else{
            for(NSInteger i = 0;i<[self.dataSourceArr count];i++){
                CXIDGCapitalExpressListModel * listModel = self.dataSourceArr[i];
                [lastFiveIds appendString:[NSString stringWithFormat:@",%@",listModel.mid]];
            }
            [lastFiveIds substringFromIndex:1];
        }
        return lastFiveIds;
    }
    return nil;
}

@end
