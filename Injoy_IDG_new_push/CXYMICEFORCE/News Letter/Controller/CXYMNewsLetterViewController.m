//
//  CXYMNewsLetterViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNewsLetterViewController.h"
#import "CXYMNewsLetter.h"
#import "CXYMNewsLetterListCell.h"
#import "CXYMAppearanceManager.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "UIImageView+WebCache.h"
#import "CXYMNewsLetterDetailViewController.h"
#import "CXSearchView.h"
#import "CXYMSearchView.h"
#import "CXYMIndustryGroup.h"
#import "CXSearchView.h"
#import "MBProgressHUD+CXCategory.h"

@interface CXYMNewsLetterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray <CXYMNewsLetter *> *dataArray;
@property (nonatomic, strong) NSNumber *groupID;
@property (nonatomic, copy) NSString *docName;
//@property (nonatomic, strong) CXSearchView *searchView;
@property (nonatomic, strong) CXYMItemSearchView *ymSearchView;
@property (nonatomic, strong) NSArray *industryGroupArray;

/** searchView */
@property(nonatomic, strong) CXSearchView * searchView;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *groudId;


@end

static NSString *const newsLetterCellIdentity = @"newsLetterCellIdentity";
@implementation CXYMNewsLetterViewController

#pragma mark -- setter && getter
- (NSMutableArray <CXYMNewsLetter *> *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            _tableView.estimatedRowHeight = 250;
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }else{
            _tableView.rowHeight = 250;
        }
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMNewsLetterListCell class] forCellReuseIdentifier:newsLetterCellIdentity];
        _tableView.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
        _tableView.separatorColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return _tableView;
}
//-(CXSearchView *)searchView{
//    if(_searchView == nil){
//        _searchView = [[CXSearchView alloc] init];
//        _searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
//        _searchView.backgroundColor = [UIColor whiteColor];
//        _searchView.cxSearchType = CXSearchMeet;
//        [_searchView.fzrTextField removeFromSuperview];
//        [_searchView.fzrTitleLable  removeFromSuperview];
//
//        [_searchView setExpandIndustry:YES];
//    }
//    return _searchView;
//}
-(void)scrollViewToBottom{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.RootTopView setNavTitle:@"Newsletter"];
    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backAction)];
    [self.RootTopView setUpRightBarItemImage:Image(@"msgSearch") addTarget:self action:@selector(searchBtnClick)];
    [self setupTableView];
    self.pageNumber = 1;
    [self loadData];
    [self loadGroupData];
    
}

-(void)backAction{
    if(self.searchText || self.groudId){
        self.searchText = nil;
        self.groudId = nil;
        
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchBtnClick{
//    __weak typeof(self) weakSelf = self;
//
//    [self.dataArray removeAllObjects];
//    self.pageNumber = 1;
//
//    self.ymSearchView = [[CXYMItemSearchView alloc] initWithSearchPlaceholder:@"请输入关键字"];
////    self.ymSearchView.ItemArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
//    self.ymSearchView.ItemArray = [self.industryGroupArray valueForKeyPath:@"deptName"];
//    [self.ymSearchView showWithView:self.view];
//
//    self.ymSearchView.itemBlock = ^(NSInteger index,NSString *itemTitle,NSString *searchText) {
//        CXYMIndustryGroup *industryGroup = weakSelf.industryGroupArray[index];
//        weakSelf.groupID = industryGroup.deptId;
//        weakSelf.docName = searchText;
//        [weakSelf loadData];
//    };
//    self.ymSearchView.block = ^(NSString *searchResult){
//        weakSelf.docName = searchResult;
//        [weakSelf loadData];
//    };
    
    if(self.searchView){
        [self.searchView hide];
        self.searchView = nil;
    }
    self.searchText = nil;
    self.groudId = nil;

    self.searchView = [[CXSearchView alloc] init];
    self.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, self.view.frame.size.width, 300);
    self.searchView.backgroundColor = [UIColor whiteColor];
    self.searchView.cxSearchType = CXSearchNewsLetter;
    CXWeakSelf(self);
    self.searchView.searchNewsLetter = ^(NSString *searchText, NSString *s_projManager) {
        CXStrongSelf(self)
        if(searchText && [searchText length] > 0){
            self.searchText = searchText;
        }
        //        if (industries.count > 0) {
        self.groudId = s_projManager;
        //        }
        
        self.pageNumber = 1;
        [self getListWithPage:self.pageNumber];
    };
    


    [self.searchView showInView:self.view];
    
}

- (void)getListWithPage:(NSInteger)page {
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    NSString *url = [NSString stringWithFormat:@"%@/news/letter/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"docName"] = self.searchText;
    }
    if (self.groudId != nil) {
        params[@"groupId"] = self.groudId;
    }
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            [self endRefre];
            
            NSArray <CXYMNewsLetter *> *array =[NSArray yy_modelArrayWithClass:[CXYMNewsLetter class] json:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            
            //按照时间顺序重新排
            NSSortDescriptor *ageSD = [NSSortDescriptor sortDescriptorWithKey:@"newsDate" ascending:YES];//时间升序1970-2018
            NSSortDescriptor *nameSD = [NSSortDescriptor sortDescriptorWithKey:@"docName" ascending:YES];//文档名称升序a-z
            
            self.dataArray = [[self.dataArray sortedArrayUsingDescriptors:@[ageSD,nameSD]] mutableCopy];
            //            [self.dataArray addObjectsFromArray:[[array reverseObjectEnumerator] allObjects]];///每一页的数据都倒序
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            
            [self.tableView reloadData];
            if(self.pageNumber == 1 && self.dataArray.count > 0){//
                [self scrollViewToBottom];
            }
            
        }else if (status == 400){
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        } else {
            [self endRefre];
            self.pageNumber --;
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    }              failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self endRefre];
        self.pageNumber --;
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

-(void)setupTableView{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
//        [weakSelf reloadData];
        [weakSelf loadMoreData];
    }];
//    [self.tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
//        [weakSelf reloadData];
//    }];
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
-(void)loadData{
    NSString *path = [NSString stringWithFormat:@"news/letter/list/%ld",self.pageNumber];
    NSDictionary *params = @{@"pageNumber":@(self.pageNumber),
                             @"groupId":self.groupID ? : @"",
                             @"docName":self.docName ? : @""};
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            [self endRefre];

            NSArray <CXYMNewsLetter *> *array =[NSArray yy_modelArrayWithClass:[CXYMNewsLetter class] json:JSON[@"data"]];
            [self.dataArray addObjectsFromArray:array];
            
            //按照时间顺序重新排
            NSSortDescriptor *ageSD = [NSSortDescriptor sortDescriptorWithKey:@"newsDate" ascending:YES];//时间升序1970-2018
            NSSortDescriptor *nameSD = [NSSortDescriptor sortDescriptorWithKey:@"docName" ascending:YES];//文档名称升序a-z

            self.dataArray = [[self.dataArray sortedArrayUsingDescriptors:@[ageSD,nameSD]] mutableCopy];
//            [self.dataArray addObjectsFromArray:[[array reverseObjectEnumerator] allObjects]];///每一页的数据都倒序
            [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataArray.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
            
            [self.tableView reloadData];
            if(self.pageNumber == 1 && self.dataArray.count > 0){//
            [self scrollViewToBottom];
            }
            
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
- (void)loadGroupData{
    NSString *path = [NSString stringWithFormat:@"%@sysuser/getTeamAll",urlPrefix];
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [HttpTool getWithPath:path params:nil success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        NSInteger status = [JSON[@"status"] integerValue];
        if(status == 200){
            self.industryGroupArray = [NSArray yy_modelArrayWithClass:[CXYMIndustryGroup class] json:JSON[@"data"]];
            
        }else{
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
    }];
}
#pragma mark-- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    if(self.dataArray.count == 0 || self.dataArray == nil) return 0;
    CXYMNewsLetter *newsLetter = self.dataArray[indexPath.row];
    CGSize strSize = [newsLetter.summary boundingRectWithSize:CGSizeMake(Screen_Width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat height = strSize.height > 50 ? 50 : strSize.height;//最多3行
    return 40  +  30 + height + [CXYMAppearanceManager appStyleMargin] * 6 + 30 + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMNewsLetterListCell *cell = [tableView dequeueReusableCellWithIdentifier:newsLetterCellIdentity forIndexPath:indexPath];
    if(self.dataArray.count == 0 || self.dataArray == nil) return cell;
    cell.newsLetter = self.dataArray[indexPath.row];
//    cell.newsLetter = self.dataArray[self.dataArray.count - indexPath.row - 1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CXYMNewsLetter *newsLetter = self.dataArray[indexPath.row];
    CXYMNewsLetterDetailViewController *newsLetterDetailViewController = [[CXYMNewsLetterDetailViewController alloc ] initWithNewsLetter:newsLetter];
    [self.navigationController pushViewController:newsLetterDetailViewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
