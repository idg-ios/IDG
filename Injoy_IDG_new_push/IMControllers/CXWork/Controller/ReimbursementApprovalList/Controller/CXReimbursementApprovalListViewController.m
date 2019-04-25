//
//  CXReimbursementApprovalListViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXReimbursementApprovalListViewController.h"
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

@interface CXReimbursementApprovalListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *listTableView;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXReimbursementApprovalListModel *> *dataSourceArr;
/** 页码 */
@property(nonatomic, assign) NSInteger pageNumber;

@end

@implementation CXReimbursementApprovalListViewController

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
    [rootTopView setNavTitle:@"报销审批"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    //    [rootTopView setUpRightBarItemImage:Image(@"msgSearch") addTarget:self action:@selector(addBtnClick)];
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
    [super viewDidLoad];//报销审批,样式修改
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //页面返回,重新请求数据
    self.pageNumber = 1;
    [self getListWithPage:self.pageNumber];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //个人费用报销单,公共费用报销单>>>同以前的报销单
    //员工借款单>>>同以前的借款单
    //付款单>>>同以前的付款单
    //SpecialVoucher=专项费用报销单,按报销单处理
    //AssetsVoucher=资产采购单,按报销单处理
    CXReimbursementApprovalListModel *listModel = self.dataSourceArr[indexPath.section];
    if([listModel.itemType isEqualToString:@"Reimbursement"] ||//报销单
       [listModel.itemType isEqualToString:@"EmployeeVoucher"] ||//个人费用报销单
       [listModel.itemType isEqualToString:@"GeneralVoucher"] ||//公共费用报销单
       [listModel.itemType isEqualToString:@"SpecialVoucher"] ||//专项费用报销单
       [listModel.itemType isEqualToString:@"AssetsVoucher"] //AssetsVoucher
       ){
        CXReimbursementDetailViewController *vc = [[CXReimbursementDetailViewController alloc] init];
        vc.isApproval = YES;
        vc.listModel = listModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([listModel.itemType isEqualToString:@"Reim2Pay"]){//报销付款单
        CXReimbursementPaymentDetailViewController *vc = [[CXReimbursementPaymentDetailViewController alloc] init];
        vc.isApproval = YES;
        vc.listModel = listModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([listModel.itemType isEqualToString:@"Loan"] ||
             [listModel.itemType isEqualToString:@"EmployeeLoan"]
             ){//借款单,员工借款单
        CXLoanDetailViewController *vc = [[CXLoanDetailViewController alloc] init];
        vc.isApproval = YES;
        vc.listModel = listModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([listModel.itemType isEqualToString:@"Payment"] ||
             [listModel.itemType isEqualToString:@"PaymentVoucher"] 
             ){//付款单
        CXPaymentDetailViewController *vc = [[CXPaymentDetailViewController alloc] init];
        vc.isApproval = YES;
        vc.listModel = listModel;
        [self.navigationController pushViewController:vc animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if([listModel.itemType isEqualToString:@"DDFee"]){
        CXYMDDFeeDetailViewController *feeDetailViewController = [[CXYMDDFeeDetailViewController alloc] init];
        feeDetailViewController.isApprove = YES;
        feeDetailViewController.model = listModel;
        [self.navigationController pushViewController:feeDetailViewController animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
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
    if(model.state && [model.state integerValue] == 0){
        model.state = @"未审批";
        model.stateInt = @(0);
    }else if(model.state && [model.state integerValue] == 1){
        model.state = @"审批中";
        model.stateInt = @(1);
    }else if(model.state && [model.state integerValue] == 3){
        model.state = @"审批完成";
        model.stateInt = @(3);
    }
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
    NSString *url = [NSString stringWithFormat:@"%@cost/approve/list/%ld", urlPrefix, (long) page];
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
//            for (CXReimbursementApprovalListModel *model in self.dataSourceArr) {
//                if ([model.stateInt integerValue] == 3) {
//                    [self.dataSourceArr removeObject:model];//审批完成的不显示
//                }
//            }
            [self.listTableView reloadData];
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

@end
