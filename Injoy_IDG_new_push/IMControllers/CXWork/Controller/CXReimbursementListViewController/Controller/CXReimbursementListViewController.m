//
//  CXReimbursementListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/2.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXReimbursementListViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "CXMetProjectListModel.h"
#import "CXReimbursementDetailViewController.h"
#import "UIView+CXCategory.h"
#import "CXReimbursementApprovalListTableViewCell.h"
#import "CXReimbursementApprovalListModel.h"
#import "CXReimbursementPaymentDetailViewController.h"
#import "CXLoanDetailViewController.h"
#import "CXPaymentDetailViewController.h"
#import "CXYMDDFeeDetailViewController.h"
#import "MBProgressHUD+CXCategory.h"

@interface CXReimbursementListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXReimbursementApprovalListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXReimbursementListViewController

#define kTitleSpace 10.0
#define kTitleLeftSpace 10.0
#define kTextFontSize 16.0
#define kTextFieldHeight 40.0

- (NSMutableArray<CXReimbursementApprovalListModel *> *)dataSourceArr {
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
        _listTableView.tableFooterView = [[UIView alloc] init];
    }
    return _listTableView;
}

#pragma mark - instance function

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"我的报销"];
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
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTableView];
    [self getListWithPage:self.pageNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //个人费用报销单,公共费用报销单>>>同以前的报销单
    //员工借款单>>>同以前的借款单
    //付款单>>>同以前的付款单
    //SpecialVoucher=专项费用报销单,按报销按处理
    //AssetsVoucher=资产采购单,按报销单处理
    //所有的单都需要加审批意见(栏),位置在备注下面
    CXReimbursementApprovalListModel *listModel = self.dataSourceArr[indexPath.section];
    NSString *itemType = self.dataSourceArr[indexPath.section].itemType;
    UIViewController *pushViewController;
    if ([itemType isEqualToString:@"Reimbursement"]) {//报销单,已加审批意见,已取消
        CXReimbursementDetailViewController *vc = [[CXReimbursementDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"Reim2Pay"]) {//报销付款单,已加审批意见,已取消
        CXReimbursementPaymentDetailViewController *vc = [[CXReimbursementPaymentDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"Loan"]) {//借款单,已加审批意见,amanda_zhang账号
        CXLoanDetailViewController *vc = [[CXLoanDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"Payment"]) {//付款单,已加审批意见,amanda_zhang账号
        CXPaymentDetailViewController *vc = [[CXPaymentDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"DDFee"]) {//尽调费用,已加审批意见amanda,已取消
        CXYMDDFeeDetailViewController *vc = [[CXYMDDFeeDetailViewController alloc] init];
        vc.isApprove = NO;
        vc.model = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"GeneralVoucher"] || [itemType isEqualToString:@"EmployeeVoucher"] || [itemType isEqualToString:@"SpecialVoucher"] || [itemType isEqualToString:@"AssetsVoucher"]) {//公共费用报销单,个人费用报销单
        CXReimbursementDetailViewController *vc = [[CXReimbursementDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"PaymentVoucher"]) {//付款单
        CXPaymentDetailViewController *vc = [[CXPaymentDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"EmployeeLoan"]) {//员工借款单
        CXLoanDetailViewController *vc = [[CXLoanDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"SpecialVoucher"]) {//SpecialVoucher=专项费用报销单,按报销按处理
        CXReimbursementDetailViewController *vc = [[CXReimbursementDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }else if ([itemType isEqualToString:@"AssetsVoucher"]) {//AssetsVoucher=资产采购单,按报销单处理
        CXReimbursementDetailViewController *vc = [[CXReimbursementDetailViewController alloc] init];
        vc.listModel = listModel;
        pushViewController = vc;
    }
    [self.navigationController pushViewController:pushViewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CXReimbursementApprovalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[CXReimbursementApprovalListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CXReimbursementApprovalListModel *model = self.dataSourceArr[indexPath.section];
    [cell setCXReimbursementApprovalListModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLabelTopSpace*5 + kTitleLabelFontSize + kDetailLabelFontSize*3;
}

#pragma mark <---请求列表--->
- (void)addBtnClick{
    
}

- (void)getListWithPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@cost/list/%ld", urlPrefix, (long) page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchText.length) {
        params[@"s_title"] = self.searchText;
    }
    if (self.isSuperSearch) {
        params[@"s_kind"] = @"super";
    }
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            NSInteger pageCount = [JSON[@"pageCount"] integerValue];
            BOOL notHaveNextPage = pageCount < page;
            [self.listTableView.footer setHidden:notHaveNextPage];
            if(notHaveNextPage){
                UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
                [mainWindow makeToast:@"没有更多数据了!" duration:3.0 position:@"center"];
            }
            NSArray<CXReimbursementApprovalListModel *> *data = [NSArray yy_modelArrayWithClass:[CXReimbursementApprovalListModel class] json:JSON[@"data"]];
            if (page == 1) {
                [self.dataSourceArr removeAllObjects];
            }
            self.pageNumber = page;
            [self.dataSourceArr addObjectsFromArray:data];
            [self.listTableView reloadData];
        } else {
            CXAlert(JSON[@"msg"]);
        }
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }              failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
        [self.listTableView.header endRefreshing];
        [self.listTableView.footer endRefreshing];
        [self.listTableView setNeedShowEmptyTipAndEmptyPictureByCount:self.dataSourceArr.count AndPictureName:@"pic_kzt_wsj" AndAttentionText:nil];
    }];
}

@end
