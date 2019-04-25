//
//  CXNoticeController.m
//  InjoyDDXWBG
//
//  Created by admin on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoticeController.h"
#import "CXTopView.h"
#import "Masonry.h"
#import "CXCellOne.h"
#import "HttpTool.h"
#import "UIView+CXCategory.h"
#import "NSObject+YYModel.h"
#import "MJRefresh.h"
#import "CXCompanyNoticeModel.h"
#import "CXNoticeEditController.h"
#import "CXInputDialogView.h"
#import "CXNoticeDetailViewController.h"
#import "CXNoticeCell.h"

@interface CXNoticeController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(weak, nonatomic) CXTopView *topView;
@property(strong, nonatomic) UITableView *listTableView;
@property(strong, nonatomic) NSMutableArray *dataSourceArr;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *noticeList;

@end

@implementation CXNoticeController

- (UITableView *)listTableView {
    @weakify(self);
    if (nil == _listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = SDBackGroudColor;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
//        _listTableView.separatorColor = [UIColor lightGrayColor];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.tableFooterView = [[UIView alloc] init];
        _listTableView.rowHeight = SDCellHeight;
        [_listTableView addLegendHeaderWithRefreshingBlock:^{
            @strongify(self)
            [self getListWithPage:1];
        }];
        [_listTableView addLegendFooterWithRefreshingBlock:^{
            @strongify(self)
            [self getListWithPage:self.page + 1];
        }];
//        [_listTableView.footer setHidden:YES];
    }
    return _listTableView;
}

- (NSMutableArray *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = [@[@"", @"", @""] mutableCopy];
    }
    return _dataSourceArr;
}

- (NSMutableArray *)noticeList {
    if (!_noticeList) {
        _noticeList = @[].mutableCopy;
    }
    return _noticeList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpTableView];
    [self.listTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"通知公告"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
//    if (VAL_IsSuper && VAL_SuperStatus) {
//        [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(editNotice)];
//    }
//    UIButton *queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [queryButton setFrame:CGRectMake(Screen_Width-10-40-40, ((navHigh-20)-40)/2+20+1, 40, 40)];
//    [queryButton setImage:Image(@"msgSearch") forState:UIControlStateNormal];
//    [queryButton addTarget:self action:@selector(superSearch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:queryButton];
    
    [rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"msgSearch"] addTarget:self action:@selector(superSearch)];
}

- (void)superSearch {
    CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
    dialogView.onApplyWithContent = ^(NSString *content) {
        self.searchText = content;
        [self getListWithPage:1];
    };
    [dialogView show];
}

- (void)editNotice {
    CXNoticeEditController *formVc = [[CXNoticeEditController alloc] init];
    formVc.onPostSuccess = ^{
        [self.listTableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:formVc animated:YES];
}

- (void)setUpTopView {
    CXTopView *topView = [[CXTopView alloc] initWithTitles:@[@"公告通知", @"查找通知"]];
    topView.callBack = ^(NSString *title) {
        if ([@"公司通知" isEqualToString:title]) {

        }
        if ([@"查找通知" isEqualToString:title]) {
            CXInputDialogView *dialogView = [[CXInputDialogView alloc] init];
            dialogView.onApplyWithContent = ^(NSString *content) {
                self.searchText = content;
                [self getListWithPage:1];
            };
            [dialogView show];
        }
    };
    self.topView = topView;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self getRootTopView].mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(CXTopViewHeight);
    }];
}

- (void)setUpTableView {
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo([self getRootTopView].mas_bottom).offset(0);
    }];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noticeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
//    CXCellOne *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[CXCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    CXCompanyNoticeModel *notice = self.noticeList[indexPath.row];
//    cell.firstLabel.text = notice.title;
//    cell.secondLabel.text = notice.createTime;
    
    CXNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CXNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    CXCompanyNoticeModel *notice = self.noticeList[indexPath.row];
    cell.title = notice.title;
    cell.remark = notice.remark;
    cell.createTime = notice.createTime;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CXCompanyNoticeModel *notice = self.noticeList[indexPath.row];
    CXNoticeDetailViewController *vc = [[CXNoticeDetailViewController alloc] init];
    vc.eid = notice.eid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)getListWithPage:(NSInteger)page {
    page = MAX(page, 1);
    NSString *url = [NSString stringWithFormat:@"/comNotice/list/%zd.json", page];
    NSMutableDictionary *params = @{}.mutableCopy;
 
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.listTableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXCompanyNoticeModel *> *data = [NSArray yy_modelArrayWithClass:[CXCompanyNoticeModel class] json:JSON[@"data"]];
            //NSString *shareUrl = [NSString stringWithFormat:@"%@/comNotice/share/list/api/%@/%@/%zd.htm?s_remark=%@", shareUrlPrefix, VAL_companyId, VAL_USERID, page, self.searchText ?: @""];
            //[self.view setShareButtonWithTitle:@"云境超级CRM-公司公告" content:@"公司公告列表" url:shareUrl dataCount:data.count];
            if (page == 1) {
                [self.noticeList removeAllObjects];
            }
            self.page = page;
            [self.noticeList addObjectsFromArray:data];
            [self.listTableView reloadData];
        }
        else if ([JSON[@"status"] intValue] == 400) {
            [self.listTableView.header endRefreshing];
            [self.listTableView.footer endRefreshing];
            [self.listTableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    } failure:^(NSError *error) {
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
        CXAlert(KNetworkFailRemind);
    }];
}




@end
