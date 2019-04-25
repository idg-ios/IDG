//
//  CXYMDDFeeDetailViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/10.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMDDFeeDetailViewController.h"
#import "CXYMDDFee.h"
#import "HttpTool.h"
#import "CXReimbursementApprovalListModel.h"
#import "CXYMAppearanceManager.h"
#import "CXYMNormalListCell.h"
#import "UIView+Category.h"
#import "Masonry.h"
#import "CXYMDDFeeDetailModel.h"
#import "CXAnnexFileModel.h"
#import "CXAnnexDownLoadTableViewCell.h"
#import "CXReimbursementApprovalAlertView.h"
#import "MBProgressHUD+CXCategory.h"

static NSString *const DDFeeDeatilCellIdentity = @"DDFeeDeatilCellIdentity";
static NSString *const downLoadFileCellIdentity = @"downLoadFileCellIdentity";
@interface CXYMDDFeeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)CXYMDDFee *fee;
//@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *eid;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong)NSArray <CXAnnexFileModel *>*fileModelArray;

/** 审批按钮白色背景 */
@property(strong, nonatomic) UIView *spWhiteBackView;

@end

@implementation CXYMDDFeeDetailViewController

#define kSPBackWhiteViewHeight 65.0

#pragma mark -- setter&&getter
- (NSArray *)titleArray{
    if(_titleArray == nil){
        NSArray *array0 = @[@"申 请 人:",@"日    期:",@"项    目:"];
        NSArray *array1 = @[@"收款公司:",@"收款公司银行账号:"];
        NSArray *array2 = @[@"代垫管理公司:",@"付款境内管理公司:",@"付款境外管理公司:",@"最终承担主体:"];
        NSArray *array3 = @[@"支付金额:",@"付款基金:",@"预算审批人:"];
        NSArray *array4 = @[@"一级审批:",@"二级审批:",@"三级审批:",@"四级审批:"];
        NSArray *array5 = @[@"费用说明:",@"超预算说明:",@"推荐服务商:",@"可比服务商1:",@"可比服务商2:",@"选择理由:"];
        _titleArray = @[array0,array1,array2,array3,array4,array5];
    }
    return _titleArray;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            _tableView.estimatedRowHeight = 100;
            _tableView.rowHeight = UITableViewAutomaticDimension;
        }else{
            _tableView.rowHeight = 100;
        }
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[CXYMNormalListCell class] forCellReuseIdentifier:DDFeeDeatilCellIdentity];
        [_tableView registerClass:[CXAnnexDownLoadTableViewCell class] forCellReuseIdentifier:downLoadFileCellIdentity];

        _tableView.backgroundColor = [CXYMAppearanceManager textWhiteColor];
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
            _tableView.separatorColor = [ CXYMAppearanceManager appBackgroundColor];
        } else {//处理透明的线
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.RootTopView setNavTitle:self.model.itemTypeName ? : @""];

    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self setupSubview];
    [self loadData];
}
- (void)submitButtonClick{
    CXReimbursementApprovalAlertView *alertView = [[CXReimbursementApprovalAlertView alloc] initWithSubObjId:self.model.subObjectId affairId:(NSNumber *)self.model.objectId];
    //
    @weakify(self);
    alertView.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    //
    [alertView show];

}
- (void)setupSubview{
    if(self.isApprove){
        // spWhiteBackView
        _spWhiteBackView = [[UIView alloc] init];
        _spWhiteBackView.backgroundColor = [UIColor whiteColor];
        //删除审批按钮
        _spWhiteBackView.frame = CGRectMake(0.f, Screen_Height - kSPBackWhiteViewHeight, Screen_Width, kSPBackWhiteViewHeight);
        [self.view addSubview:_spWhiteBackView];
        
        [self setupBottomView];//需求更改,我的审批模块里需要审批,我的报销模块里不需要审批

        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.bottom.mas_equalTo(_spWhiteBackView.mas_top).mas_offset(0);
            make.left.right.mas_equalTo(0);
        }];
    }else{
        
        self.tableView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
        [self.view addSubview:self.tableView];
    }
    
}


//----------------------------------------
- (void)setupBottomView{
    
    UIButton *agreeButton = [self createButtonWithTitle:@"同意"];
    UIButton *unAgreeButton = [self createButtonWithTitle:@"不同意"];
    
    NSArray *buttonArray = @[agreeButton,unAgreeButton];
    [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10 - kTabbarSafeBottomMargin);
        make.height.mas_equalTo(40);
    }];
    
}
- (UIButton *)createButtonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:title forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}
- (void )buttonClick:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"不同意"]) {
        [self showActionController];
    }else if ([title isEqualToString:@"同意"]){
        [self submitWithReason:nil agree:YES];
    }
    
}
- (void)showActionController{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok, %@", [[alertVc textFields] objectAtIndex:0].text);
        NSString *reason = [[alertVc textFields] objectAtIndex:0].text;
        if ([reason isEqualToString:@""] || reason.length == 0) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"审批意见不能为空" duration:3];
            [self performSelector:@selector(showActionController) withObject:nil afterDelay:2];
            
        } else {
            [self submitWithReason:reason agree:NO];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action2];
    [alertVc addAction:action1];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)submitWithReason:(NSString *)reason agree:(BOOL)agree{
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    NSString *url = [NSString stringWithFormat:@"%@cost/approve",urlPrefix];
    NSDictionary *params = @{@"subObjId":self.model.subObjectId,
                             @"affairId":self.model.objectId,
                             @"kind":agree ? @(1) : @(2),//1同意,2退回
                             @"comments":reason ? : @""};
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
    }];
}

//-------------------------

- (void)loadData{
    NSString *path = [NSString stringWithFormat:@"%@/cost/detail/df.json",urlPrefix];
    NSDictionary *params = @{@"eid":self.model.objectId ? : nil};
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
        CXYMDDFeeDetailModel *feeDetailModel = [CXYMDDFeeDetailModel yy_modelWithJSON:JSON[@"data"]];
        self.fileModelArray = [NSArray yy_modelArrayWithClass:[CXAnnexFileModel class] json:JSON[@"data"][@"fileList"]];
        [self setupDataArrayWithFee:feeDetailModel];
        [self.tableView reloadData];
        }else if (status == 400){
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }else{
            CXAlert(JSON[@"msg"] ? : @"请求状态错误");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        CXAlert(KNetworkFailRemind);
        [self.tableView setNeedShowAttentionAndEmptyPictureText:nil AndPictureName:@"pic_kzt_wsj"];
    }];
}
- (void)setupDataArrayWithFee:(CXYMDDFeeDetailModel *)fee{
    NSMutableArray *array0 = [NSMutableArray array];
    [array0 addObject:fee.apply ? : @" "];
    [array0 addObject:fee.startDate ? : @" "];
    [array0 addObject:fee.projName ? : @" "];
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:fee.receiveBank ? : @" "];
    [array1 addObject:fee.receiveBankNo ? : @" "];
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:fee.payForEntity ? : @" "];
    [array2 addObject:fee.payEntityMainland ? : @" "];
    [array2 addObject:fee.payEntityOversea ? : @" "];
    [array2 addObject:fee.payForLast ? : @" "];
    NSMutableArray *array3 = [NSMutableArray array];
    [array3 addObject:fee.payAmt ? : @" "];
    [array3 addObject:fee.payFund ? : @" "];
    [array3 addObject:fee.budgetApprove ? : @" "];
    NSMutableArray *array4 = [NSMutableArray array];
    [array4 addObject:fee.approve1 ? : @" "];
    [array4 addObject:fee.approve2 ? : @" "];
    [array4 addObject:fee.approve3 ? : @" "];
    [array4 addObject:fee.approve4 ? : @" "];
    NSMutableArray *array5 = [NSMutableArray array];
    [array5 addObject:fee.feeDesc ? : @" "];
    [array5 addObject:fee.overBudgetDesc ? : @" "];
    [array5 addObject:[NSString stringWithFormat:@"%@\n%@ %@",fee.recommendVendor ? : @"",fee.recommendAmount ? : @"",fee.recommendCurrency ? : @""]];
     [array5 addObject:[NSString stringWithFormat:@"%@\n%@ %@",fee.comparable1Vendor ? : @"",fee.comparable1Amount ? : @"",fee.comparable1Currency ? : @""]];
    [array5 addObject:[NSString stringWithFormat:@"%@\n%@ %@",fee.comparable2Vendor ? : @"",fee.comparable2Amount ? : @"",fee.comparable2Currency ? : @""]];
    [array5 addObject:fee.chooseReason ? : @" "];
    self.dataArray = @[array0,array1,array2,array3,array4,array5];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == self.titleArray.count){
        return 30;
    }else{
        return self.fileModelArray.count > 0 ? 10 : 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    if(section == self.titleArray.count){
        UILabel *fjLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        fjLabel.text = self.fileModelArray.count ? @"附件" : @" ";
        [header addSubview:fjLabel];
        [fjLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
    }else{
        header.backgroundColor = [CXYMAppearanceManager appBackgroundColor];
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.titleArray.count){
        return 80;
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == self.titleArray.count){
        return self.fileModelArray.count;
    }else{
        NSArray *titleArray = self.dataArray[section];
        return titleArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.titleArray.count){
        CXAnnexDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downLoadFileCellIdentity forIndexPath:indexPath];
        cell.model = self.fileModelArray[indexPath.row];
        return cell;
    }else{
        CXYMNormalListCell *cell = [tableView dequeueReusableCellWithIdentifier:DDFeeDeatilCellIdentity  forIndexPath:indexPath];
        NSArray *titleArray = self.titleArray[indexPath.section];
        NSArray *dataArray = self.dataArray[indexPath.section];
        cell.titleLabel.text = titleArray[indexPath.row];
        cell.titleLabel.font = [UIFont systemFontOfSize:15];
        cell.contentLabel.text = dataArray[indexPath.row];
        cell.contentLabel.numberOfLines = 0;
        cell.contentLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
