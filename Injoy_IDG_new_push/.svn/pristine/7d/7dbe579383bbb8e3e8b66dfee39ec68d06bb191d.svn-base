//
//  CXInternalBulletinListViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXInternalBulletinListViewController.h"
#import "CXInternalBulletinModel.h"
#import "Masonry.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+CXCategory.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+YYAdd.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXInternalbulletinCellTableViewCell.h"
#import "CXInternalBulletinDetailViewController.h"
#import "CXInputDialogView.h"
#import "CXSearchTableView.h"


@interface CXInternalBulletinListViewController ()<UITableViewDelegate, UITableViewDataSource, CXSearchTableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSMutableArray <CXInternalBulletinModel *> *internalBulletinList;
@property(nonatomic, assign)type type;
@property(nonatomic, strong) CXSearchTableView *Searchview;
@end

@implementation CXInternalBulletinListViewController

#pragma mark -getter&setter
-(id)initWithType:(type)type{
    if(self = [super init]){
        self.type = type;
    }
    return self;
}

-(NSMutableArray <CXInternalBulletinModel *>*)internalBulletinList{
    if(!_internalBulletinList){
        _internalBulletinList = @[].mutableCopy;
    }
    return  _internalBulletinList;
}

- (CXSearchTableView *)Searchview{
    _Searchview = [[CXSearchTableView alloc]init];
    _Searchview.delegate = self;
    return _Searchview;
}
#pragma mark -life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavView];
    [self setUp];
    [self.tableView.header beginRefreshing];
    
}

#pragma  mark -private method
-(void)setupNavView{
    SDRootTopView *rootTopView = [self getRootTopView];
    if(self.type == isInternalButin){
        [rootTopView setNavTitle:@"内刊"];
    }else if(self.type == isTool){
        if(self.i_kind == GZZD){
            [rootTopView setNavTitle:@"规章制度"];
        }else if(self.i_kind == XZBG){
            [rootTopView setNavTitle:@"行政办公"];
        }else if(self.i_kind == CYMB){
            [rootTopView setNavTitle:@"常用模板"];
        }
    }
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(popBtnTap)];
//    [rootTopView setUpRightBarItemImage2:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(onSearchTap)];
}
-(void)setUp{
    @weakify(self)
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = SDBackGroudColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView addLegendHeaderWithRefreshingBlock:^{
            @strongify(self)
            [self getListWithPage:1];
        }];
        [tableView addLegendFooterWithRefreshingBlock:^{
            @strongify(self)
            [self getListWithPage:self.page + 1];
        }];
//        [tableView.footer setHidden:YES];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        }];
        tableView;
    });
}
- (void)popBtnTap{
    [_Searchview hide];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getListWithPage:(NSInteger)page{
    page = MAX(page, 1);
    NSString *url = (self.type == isInternalButin)?[NSString stringWithFormat:@"/magazine/list/%zd.json", page]:[NSString stringWithFormat:@"/tool/list/%zd.json", page];
    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if(self.type == isTool){
        [params setValue:[NSString stringWithFormat:@"%zd", self.i_kind] forKey:@"i_kind"];
        
    }
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.tableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXInternalBulletinModel *> *data = [NSArray yy_modelArrayWithClass:[CXInternalBulletinModel class] json:JSON[@"data"]];
           // NSString *shareUrl = [NSString stringWithFormat:@"%@/comNotice/share/list/api/%@/%@/%zd.htm?s_remark=%@", shareUrlPrefix, VAL_companyId, VAL_USERID, page, self.searchText ?: @""];
           // [self.view setShareButtonWithTitle:@"云境OA-公司公告" content:@"公司公告列表" url:shareUrl dataCount:data.count];
            if (page == 1) {
                [self.internalBulletinList removeAllObjects];
            }
            self.page = page;
            [self.internalBulletinList addObjectsFromArray:data];
            [self.tableView reloadData];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.internalBulletinList.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView setNeedShowEmptyTipAndEmptyPictureByCount:self.internalBulletinList.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        CXAlert(KNetworkFailRemind);
    }];
    
}
-(void)onSearchTap{
//    CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
//    dialogView.onApplyWithContent = ^(NSString *content) {
//        self.searchText = content;
//        [self getListWithPage:1];
//    };
//    [dialogView show];

    [self.Searchview show];
    
}
#pragma mark -CXSearchTableViewDelegate
- (void)CXSearchTableView:(CXSearchTableView *)tableView text:(NSString *)text andPageNumber:(NSInteger)pageNumber block:(void (^)(NSArray *))arrayBlock{
    //这里是CXSearchTableView的代理方法，返回接口的数组，因为接口数组接受在block中这里也用block接受返回的数组
    arrayBlock(@[@"1",@"2",@"3"]);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.internalBulletinList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KCXCellInternalbulletinCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    CXInternalbulletinCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CXInternalbulletinCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    CXInternalBulletinModel *notice = self.internalBulletinList[indexPath.row];
    cell.firstLabel.text = notice.title;
    cell.secondLabel.text = notice.publishTime;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CXInternalBulletinModel *notice = self.internalBulletinList[indexPath.row];
    CXInternalBulletinDetailViewController *formVc = [[CXInternalBulletinDetailViewController alloc] initWithEid:notice.eid type:self.type andTitle:notice.title];
    [self.navigationController pushViewController:formVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
