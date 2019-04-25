//
//  CXTMTPotentialProjectListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/27.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXTMTPotentialProjectListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXTMTPotentialProjectDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXTMTPotentialProjectListTableViewCell.h"
#import "CXTMTProjectSearchView.h"
#import "CXTMTPotentialProjectListModel.h"
#import "CXHouseProjectListTableViewCell.h"
#import "CXSearchView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXTMTPotentialProjectListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXTMTPotentialProjectListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;
/** searchView */
@property(nonatomic, strong) CXSearchView * searchView;
/** 关键词 */
@property (nonatomic, strong) NSString * s_projName;
/** 行业ID */
@property (nonatomic, strong) NSString * s_induIds;
/** 阶段ID */
@property (nonatomic, strong) NSString * s_stageIds;

@property (nonatomic, strong) NSMutableArray *frameArray;

@end

@implementation CXTMTPotentialProjectListViewController

#define kTitleSpace 10.0
#define kTitleLeftSpace 10.0
#define kTextFontSize 16.0
#define kTextFieldHeight 40.0

#pragma mark - get & set

- (NSMutableArray<CXTMTPotentialProjectListModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
- (NSMutableArray *)frameArray{
    if(nil == _frameArray){
        _frameArray = @[].mutableCopy;
    }
    return _frameArray;
}
- (UITableView *)listTableView {
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.separatorColor = [UIColor clearColor];
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.showsVerticalScrollIndicator = NO;
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.titleName];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popBtnClick)];
    [rootTopView setUpRightBarItemImage:Image(@"msgSearch") addTarget:self action:@selector(searchBtnClick)];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.left.mas_equalTo(self.view).mas_offset(15*uinitpx);
        make.right.mas_equalTo(self.view).mas_offset(-15*uinitpx);
        make.top.mas_equalTo(navHigh);
    }];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    @weakify(self)
    [self.listTableView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self)
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }];
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        @strongify(self)
        [self getListWithPage:self.pageNumber + 1];
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    self.pageNumber = 1;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    [self setUpTableView];
    [self getListWithPage:self.pageNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXTMTPotentialProjectDetailViewController *vc = [[CXTMTPotentialProjectDetailViewController alloc] init];
    CXTMTPotentialProjectListModel *listModel = self.dataSourceArr[indexPath.section];
    vc.model = listModel;
    [self.navigationController pushViewController:vc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXHouseProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(nil == cell){
        cell = [[CXHouseProjectListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //    cell.dataFrame = self.frameArrays[indexPath.section];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5.f, 5.f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = cell.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.layer.mask = maskLayer;
    
    if([cell isKindOfClass:[CXHouseProjectListTableViewCell class]]){
        [cell setValue:self.frameArray[indexPath.section] forKey:@"dataFrame"];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CXHouseProjectModelFrame *frame = self.frameArray[indexPath.section];
    return frame.cellHeight;
}

#pragma mark <---请求列表--->
- (void)getFrameArray:(NSArray *)addArray{
    if(!self.dataSourceArr.count){
        [self.listTableView reloadData];
        return;
    }
    [addArray enumerateObjectsUsingBlock:^(CXTMTPotentialProjectListModel *model , NSUInteger idx, BOOL *stop){
        CXHouseProjectModelFrame *frame = [[CXHouseProjectModelFrame alloc]init];
        frame.TMTModel = model;
        [self.frameArray addObject:frame];
    }];
    if(self.frameArray.count){
        [self.listTableView reloadData];
    }
}
- (void)searchBtnClick{
    if(self.searchView){
        [self.searchView hide];
        self.searchView = nil;
    }
    self.s_projName = nil;
    self.s_induIds = nil;
    self.s_stageIds = nil;
    
    
    self.searchView = [[CXSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.cxSearchType = CXSearchTMT;
    CXWeakSelf(self)
    self.searchView.searchTMTBlock = ^(NSString *keyword) {
        CXStrongSelf(self)
        if(keyword && [keyword length] > 0){
            self.s_projName = keyword;
        }
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    };
    [self.searchView showInView:self.view];
    
//    self.searchView = [[CXTMTProjectSearchView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, 51.0 + 5*kTitleSpace + 2*kTextFontSize + 2*kTextFieldHeight + 1.0 + 50)];
//    CXWeakSelf(self)
//    self.searchView.onSearchCallback = ^(NSString *keyword) {
//        CXStrongSelf(self)
//        if(keyword && [keyword length] > 0){
//            self.s_projName = keyword;
//        }
//        self.pageNumber = 1;
//        [self getListWithPage:self.pageNumber];
//    };
//    [self.searchView showInView:self.view];
}

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/tmt/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    [params setValue:self.s_projName forKey:@"s_projName"];
    
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.listTableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXTMTPotentialProjectListModel *> *data = [NSArray yy_modelArrayWithClass:[CXTMTPotentialProjectListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.frameArray removeAllObjects];
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            [self getFrameArray:data];
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

- (void)popBtnClick{
    if(self.s_projName){
        self.s_projName = nil;
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
