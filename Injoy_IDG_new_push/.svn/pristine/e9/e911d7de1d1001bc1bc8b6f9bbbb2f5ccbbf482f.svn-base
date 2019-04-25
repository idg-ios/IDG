//
//  CXIDGProjectManagementListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGProjectManagementListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXIDGProjectManagementListModel.h"
#import "CXProjectCollaborationFormModel.h"
#import "CXIDGProjectManagementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXIDGProjectManagementListTableViewCell.h"
#import "CXProjectSearchView.h"
#import "CXHouseProjectModelFrame.h"
#import "CXHouseProjectListTableViewCell.h"
#import "CXSearchTableView.h"
#import "CXSearchView.h"

@interface CXIDGProjectManagementListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXIDGProjectManagementListModel *> *dataSourceArr;
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

//在searchView关键词searchbar中输入字后会调用searchTableView
@property (nonatomic, strong) CXSearchTableView *searchTableView;
@end

@implementation CXIDGProjectManagementListViewController

#pragma mark - get & set

- (NSMutableArray<CXIDGProjectManagementListModel *> *)dataSourceArr {
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
        make.left.equalTo(self.view).mas_offset(15*uinitpx);
        make.right.equalTo(self.view).mas_offset(-15*uinitpx);
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
    CXIDGProjectManagementDetailViewController *vc = [[CXIDGProjectManagementDetailViewController alloc] init];
    CXIDGProjectManagementListModel *listModel = self.dataSourceArr[indexPath.section];
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
    return [self.frameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXHouseProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXHouseProjectListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    CXHouseProjectModelFrame *model = self.frameArray[indexPath.section];
//    cell.dataFrame = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return frame.cellHeight;//kImageTopSpace*2 + kImageViewWidth;
}

- (void)popBtnClick{
    if(self.s_projName || self.s_induIds || self.s_stageIds){
        self.s_projName = nil;
        self.s_induIds = nil;
        self.s_stageIds = nil;
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }else{
        if(self.searchTableView){
            [_searchTableView hide];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark <---请求列表--->
- (void)searchBtnClick{
    if(self.searchView){
        [self.searchView hide];
        self.searchView = nil;
    }
    self.s_projName = nil;
    self.s_induIds = nil;
    self.s_stageIds = nil;
    
    CXSearchView *view = [[CXSearchView alloc] init];
    view.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
    view.backgroundColor = [UIColor whiteColor];
    view.cxSearchType = CXSearchPM;
    CXWeakSelf(self);
    view.searchPMBlock = ^(NSArray<NSNumber *> *selectedState, NSArray<NSNumber *> *selectedIndustry, NSString *keyword) {
        CXStrongSelf(self)
        if(keyword && [keyword length] > 0){
            self.s_projName = keyword;
        }
        
        NSMutableString *content = [[NSMutableString alloc] init];
        if (selectedIndustry.count == 1) {
            [content appendString:[NSString stringWithFormat:@"%zd",[selectedIndustry.firstObject integerValue]]];
            if(content && [content length] > 0){
                self.s_induIds = content;
            }
        } else if (selectedIndustry.count > 1) {
            for(NSNumber * industry in selectedIndustry){
                [content appendString:[NSString stringWithFormat:@",%zd",[industry integerValue]]];
            }
            if(content && [content length] > 0){
                self.s_induIds = [content substringFromIndex:1];
            }
        }
        
        content = [[NSMutableString alloc] init];
        if (selectedState.count == 1) {
            [content appendString:[NSString stringWithFormat:@"%zd",[selectedState.firstObject integerValue]]];
            if(content && [content length] > 0){
                self.s_stageIds = content;
            }
        } else if (selectedState.count > 1) {
            for(NSNumber * state in selectedState){
                [content appendString:[NSString stringWithFormat:@",%zd",[state integerValue]]];
            }
            if(content && [content length] > 0){
                self.s_stageIds = [content substringFromIndex:1];
            }
        }
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    };
    [view showInView:self.view];
    self.searchView = view;
    
//    self.searchView = [[CXProjectSearchView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, 380)];
//    CXWeakSelf(self)
//    self.searchView.onSearchCallback = ^(NSArray<NSNumber *> *selectedState, NSArray<NSNumber *> *selectedIndustry, NSString *keyword) {
//        CXStrongSelf(self)
//        if(keyword && [keyword length] > 0){
//            self.s_projName = keyword;
//        }
//
//        NSMutableString *content = [[NSMutableString alloc] init];
//        if (selectedIndustry.count == 1) {
//            [content appendString:[NSString stringWithFormat:@"%zd",[selectedIndustry.firstObject integerValue]]];
//            if(content && [content length] > 0){
//                self.s_induIds = content;
//            }
//        } else if (selectedIndustry.count > 1) {
//            for(NSNumber * industry in selectedIndustry){
//                [content appendString:[NSString stringWithFormat:@",%zd",[industry integerValue]]];
//            }
//            if(content && [content length] > 0){
//                self.s_induIds = [content substringFromIndex:1];
//            }
//        }
//
//        content = [[NSMutableString alloc] init];
//        if (selectedState.count == 1) {
//            [content appendString:[NSString stringWithFormat:@"%zd",[selectedState.firstObject integerValue]]];
//            if(content && [content length] > 0){
//                self.s_stageIds = content;
//            }
//        } else if (selectedState.count > 1) {
//            for(NSNumber * state in selectedState){
//                [content appendString:[NSString stringWithFormat:@",%zd",[state integerValue]]];
//            }
//            if(content && [content length] > 0){
//                self.s_stageIds = [content substringFromIndex:1];
//            }
//        }
//        self.pageNumber = 1;
//        [self getListWithPage:self.pageNumber];
//    };
//    self.searchView.onSearchStart = ^(NSString *text){
//        [weakself.searchView hidenAllView];
//        [weakself getListViewTap:text];
//    };
//    [self.searchView showInView:self.view];
    
}
//- (void) getListViewTap:(NSString *)text{
//    _searchTableView = [[CXSearchTableView alloc]init];
//    _searchTableView.text = text;
//    CXWeakSelf(self)
//    _searchTableView.searchInputCancel = ^{
//        [weakself.searchView showAllView];
//    };
//   _searchTableView.searchInputEnd = ^(NSString *text){
////       [weakself.searchView showAllView];
//       weakself.searchView.searchText = text;
//   };
//    [_searchTableView show];
//}

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@project/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    
    
    
    [params setValue:self.s_projName forKey:@"s_projName"];
    [params setValue:self.s_induIds forKey:@"s_induIds"];
    [params setValue:self.s_stageIds forKey:@"s_stageIds"];
    
    NSLog(@"%@",params[@"s_induIds"]);
    NSLog(@"%@",params[@"s_stageIds"]);
    
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.listTableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXIDGProjectManagementListModel *> *data = [NSArray yy_modelArrayWithClass:[CXIDGProjectManagementListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.frameArray removeAllObjects];
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            [self getFrameArray:data];
            [self.listTableView reloadData];
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}
- (void)getFrameArray:(NSArray *)addArray{
    if(!self.dataSourceArr.count){
        [self.listTableView reloadData];
        return;
    }
    [addArray enumerateObjectsUsingBlock:^(CXIDGProjectManagementListModel *model, NSUInteger idx, BOOL *stop){
        CXHouseProjectModelFrame *frame = [[CXHouseProjectModelFrame alloc]init];
        frame.managerModel = model;
        [self.frameArray addObject:frame];
    }];
    [self.listTableView reloadData];
}
- (void)dealloc{
    NSLog(@"%s", __func__);
}
@end
