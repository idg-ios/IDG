//
//  CXReimbursementDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXReimbursementDetailViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "HttpTool.h"
#import "UIView+CXCategory.h"
#import "CXPEPotentialProjectModel.h"
#import "MJRefresh.h"
#import "CXPotentialFollowListModel.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXFeeTableViewCell.h"
#import "CXReimbursementDetailModel.h"
#import "CXReimbursementApprovalAlertView.h"
#import "CXAnnexFileModel.h"
#import "CXAnnexDownLoadTableViewCell.h"
#import "CXInternalBulletinDetailViewController.h"
#import "YWFilePreviewView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXReimbursementDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CXAnnexDownloadDelegate>

@property(strong, nonatomic) UITableView *tableView;

@property(nonatomic, strong) CXReimbursementDetailModel * model;
/** 数据源 */
@property(strong, nonatomic) NSMutableArray<CXFeeModel *> *dataSourceArr;
/** 申请人 */
@property(strong, nonatomic) CXEditLabel *sqrLabel;
/** 日期 */
@property(strong, nonatomic) CXEditLabel *rqLabel;
/** 公司 */
@property(strong, nonatomic) CXEditLabel *gsLabel;

/** 发票费用合计 */
@property(strong, nonatomic) CXEditLabel *fpfyhjLabel;
/** RMB费用合计 */
@property(strong, nonatomic) CXEditLabel *rmbfyhjLabel;

/** 专项名称 */
@property(strong, nonatomic) CXEditLabel *zxmcLabel;
/** 费用描述 */
@property(strong, nonatomic) CXEditLabel *fymsLabel;


/** 一级审批 */
@property(strong, nonatomic) CXEditLabel *yjspLabel;
/** 二级审批 */
@property(strong, nonatomic) CXEditLabel *ejspLabel;
/** 会计 */
@property(strong, nonatomic) CXEditLabel *kjLabel;
/** 出纳 */
@property(strong, nonatomic) CXEditLabel *cnLabel;
/** 备注 */
@property(strong, nonatomic) CXEditLabel *bzLabel;

@property(strong, nonatomic) CXEditLabel *opinionLabel;///<审批意见

/** 审批按钮白色背景 */
@property(strong, nonatomic) UIView *spWhiteBackView;
/** 审批按钮 */
@property(strong, nonatomic) UIButton *spButton;

@property (nonatomic, strong) UIView * topScrollContentView;

@property (nonatomic, strong) UIView * bottomScrollContentView;

/** fjBackView */
@property(strong, nonatomic) UIView *fjBackView;
/** 附件Label */
@property(strong, nonatomic) UILabel *fjLabel;
/** 附件fjListTableView */
@property (nonatomic, strong) UITableView * fjListTableView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation CXReimbursementDetailViewController

#define kLabelLeftSpace 10.0
#define kLabelTopSpace 10.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kTextColor [UIColor blackColor]
#define kContentLabelFontSize 16.0

#define kSPBackWhiteViewHeight 65.0
#define kSPBtnHeight 40.0
#define kSPBtnLeftSpace 20.0
#define kSPBtnTopSpace 10.0
#define kSPBtnCornerRadius 5.0

#define kHKZPDWXXLabelFontSize 14.0
#define kHKZPDWXXLabelTopSpace 15.0
#define kHKZPDWXXLabelBottomSpace 10.0
#define kHKZPDWXXLabelTextColor RGBACOLOR(151.0, 152.0, 152.0, 1.0)

#define kFileListCellHeight (80.0*(Screen_Width/375.0))
- (NSMutableArray *)cellArray{
    if(nil == _cellArray){
        _cellArray = @[].mutableCopy;
    }
    return _cellArray;
}
- (CXReimbursementDetailModel *)model {
    if(!_model){
        _model = [[CXReimbursementDetailModel alloc] init];
    }
    return _model;
}

- (NSMutableArray<CXFeeModel *> *)dataSourceArr {
    if (nil == _dataSourceArr) {
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

- (UITableView *)fjListTableView{
    if(!_fjListTableView){
        _fjListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _fjBackView.bottom, Screen_Width, [self.model.fileList count]*kFileListCellHeight) style:UITableViewStylePlain];
        _fjListTableView.backgroundColor = SDBackGroudColor;
        _fjListTableView.dataSource = self;
        _fjListTableView.delegate = self;
        if ([_fjListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_fjListTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_fjListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_fjListTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
            _fjListTableView.separatorColor = SDBackGroudColor;
        } else {//处理透明的线
            _fjListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        _fjListTableView.tableFooterView = [[UIView alloc] init];
    }
    return _fjListTableView;
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    NSString *type;
    if ([self.listModel.itemType isEqualToString:@"EmployeeVoucher"]) {
        type = @"个人费用报销单";
    } else if ([self.listModel.itemType isEqualToString:@"GeneralVoucher"]) {
        type = @"公共费用报销单";
    }else if ([self.listModel.itemType isEqualToString:@"SpecialVoucher"]) {
        type = @"专项费用报销单";
    }else if ([self.listModel.itemType isEqualToString:@"AssetsVoucher"]) {
        type = @"资产采购单";
    }else if ([self.listModel.itemType isEqualToString:@"Reimbursement"]) {
        type = @"报销单";
    }
    [rootTopView setNavTitle:[NSString stringWithFormat:@"%@",type]];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTableView {
    
    if(self.isApproval){
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh - kSPBackWhiteViewHeight) style:UITableViewStylePlain];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    }
    
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.topScrollContentView = [[UIView alloc] init];
    CXWeakSelf(self)
    self.topScrollContentView.backgroundColor = [UIColor whiteColor];
    /// 左边距
    CGFloat leftMargin = 10.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 10.f;
    CGFloat lineSPBoldHeight = 15.f;
    CGFloat lineWidth = Screen_Width;
    /// 宽度
    CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;

    //申请人
    _sqrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, 0, Screen_Width - leftMargin, viewHeight)];
    _sqrLabel.title = @"申  请  人：";
    _sqrLabel.allowEditing = NO;
    _sqrLabel.textColor = kTextColor;
    _sqrLabel.inputType = CXEditLabelInputTypeText;
    _sqrLabel.content = self.model.apply;
    _sqrLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.apply = editLabel.content;
    };
    [self.topScrollContentView addSubview:_sqrLabel];

    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _sqrLabel.bottom, lineWidth, lineHeight);

    //日期
    _rqLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _rqLabel.title = @"日　　期：";
    _rqLabel.textColor = kTextColor;
    _rqLabel.allowEditing = NO;
    _rqLabel.content = self.model.startDate;
    _rqLabel.inputType = CXEditLabelInputTypeDate;
    _rqLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.startDate = editLabel.content;
    };
    [self.topScrollContentView addSubview:_rqLabel];
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _rqLabel.bottom, lineWidth, lineHeight);
    
    //公司
    _gsLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _gsLabel.title = @"公　　司：";
    _gsLabel.textColor = kTextColor;
    _gsLabel.allowEditing = NO;
    _gsLabel.content = self.model.company;
    _gsLabel.inputType = CXEditLabelInputTypeText;
    _gsLabel.numberOfLines = 0;
    _gsLabel.scale = YES;
    _gsLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.company = editLabel.content;
    };
    [self.topScrollContentView addSubview:_gsLabel];
    
    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _gsLabel.bottom, lineWidth, lineBoldHeight);

    self.topScrollContentView.frame = CGRectMake(0, 0, Screen_Width, line_3.bottom);
    [self.tableView setTableHeaderView:self.topScrollContentView];
    
    
    self.bottomScrollContentView = [[UIView alloc] init];
    self.bottomScrollContentView.backgroundColor = [UIColor whiteColor];
    
    // line_4
    UIView *line_4 = [self createBottomFormSeperatorLine];
    line_4.frame = CGRectMake(0.f, 0, lineWidth, lineBoldHeight);
    
    //发票费用合计
    _fpfyhjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
    if ([self.listModel.itemType isEqualToString:@"AssetsVoucher"]) {
        _fpfyhjLabel.title = @"本次支付金额：";
    }else{
        _fpfyhjLabel.title = @"发票费用合计：";
    }
    _fpfyhjLabel.allowEditing = NO;
    _fpfyhjLabel.textColor = kTextColor;
    _fpfyhjLabel.inputType = CXEditLabelInputTypeText;
    NSString *total;
    if ([self.model.total containsString:@"E"]) {
        total = self.listModel.amount;
    } else {
        total = self.model.total;
    }
    _fpfyhjLabel.content = total;
//    _fpfyhjLabel.content = self.model.total;
    _fpfyhjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.total = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_fpfyhjLabel];
    
    // line_5
    UIView *line_5 = [self createBottomFormSeperatorLine];
    line_5.frame = CGRectMake(0.f, _fpfyhjLabel.bottom, lineWidth, lineHeight);
    
    //RMB费用合计
    _rmbfyhjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
    if ([self.listModel.itemType isEqualToString:@"AssetsVoucher"]) {
        _rmbfyhjLabel.title = @"累计支付金额：";
    }else{
        _rmbfyhjLabel.title = @"RMB费用合计：";
    }
    _rmbfyhjLabel.textColor = kTextColor;
    _rmbfyhjLabel.allowEditing = NO;
    _rmbfyhjLabel.content = self.model.totalRmb;
    _rmbfyhjLabel.inputType = CXEditLabelInputTypeText;
    _rmbfyhjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.totalRmb = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_rmbfyhjLabel];
    
    // line_6
    UIView *line_6 = [self createBottomFormSeperatorLine];
    line_6.frame = CGRectMake(0.f, _rmbfyhjLabel.bottom, lineWidth, lineBoldHeight);
    
    
    if ([self.listModel.itemType isEqualToString:@"SpecialVoucher"]) {
        //专项名称
        _zxmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
        _zxmcLabel.title = @"专项费用名称：";
        _zxmcLabel.allowEditing = NO;
        _zxmcLabel.textColor = kTextColor;
        _zxmcLabel.inputType = CXEditLabelInputTypeText;
        _zxmcLabel.content = self.model.specialName?self.model.specialName:@" ";
        [self.bottomScrollContentView addSubview:_zxmcLabel];
        
        // line_zx
        UIView *line_zx = [self createBottomFormSeperatorLine];
        line_zx.frame = CGRectMake(0.f, _zxmcLabel.bottom, lineWidth, lineHeight);
        
        //费用描述
        _fymsLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_zx.bottom, Screen_Width - leftMargin, viewHeight)];
        _fymsLabel.title = @"专项费用描述：";
        _fymsLabel.textColor = kTextColor;
        _fymsLabel.allowEditing = NO;
        _fymsLabel.content = self.model.specialDesc?self.model.specialDesc:@" ";
        _fymsLabel.inputType = CXEditLabelInputTypeText;
        [self.bottomScrollContentView addSubview:_fymsLabel];
        
        // line_fyms
        UIView *line_fyms = [self createBottomFormSeperatorLine];
        line_fyms.frame = CGRectMake(0.f, _fymsLabel.bottom, lineWidth, lineBoldHeight);
        
        //一级审批
        _yjspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_fyms.bottom, viewWidth, viewHeight)];
        
        //二级审批
        _ejspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(_yjspLabel.right, line_fyms.bottom, viewWidth, viewHeight)];
    }
    
    if (![self.listModel.itemType isEqualToString:@"SpecialVoucher"]) {
        //一级审批
        _yjspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, viewWidth, viewHeight)];
    }
    _yjspLabel.title = @"一级审批：";
    _yjspLabel.textColor = kTextColor;
    _yjspLabel.allowEditing = NO;
    _yjspLabel.content = self.model.firstApprove;
    _yjspLabel.inputType = CXEditLabelInputTypeText;
    _yjspLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.firstApprove = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_yjspLabel];
    
    if (![self.listModel.itemType isEqualToString:@"SpecialVoucher"]) {
        //二级审批
        _ejspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(_yjspLabel.right, line_6.bottom, viewWidth, viewHeight)];
    }
    _ejspLabel.title = @"二级审批：";
    _ejspLabel.textColor = kTextColor;
    _ejspLabel.allowEditing = NO;
    _ejspLabel.content = self.model.secondApprove;
    _ejspLabel.inputType = CXEditLabelInputTypeText;
    _ejspLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.secondApprove = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_ejspLabel];
    
    // line_7
    UIView *line_7 = [self createBottomFormSeperatorLine];
    line_7.frame = CGRectMake(0.f, _yjspLabel.bottom, lineWidth, lineHeight);
    
    //会计
    _kjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_7.bottom, viewWidth, viewHeight)];
    _kjLabel.title = @"会　　计：";
    _kjLabel.textColor = kTextColor;
    _kjLabel.allowEditing = NO;
    _kjLabel.content = self.model.accounting;
    _kjLabel.inputType = CXEditLabelInputTypeText;
    _kjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.accounting = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_kjLabel];
    
    //出纳
    _cnLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(_kjLabel.right, line_7.bottom, viewWidth, viewHeight)];
    _cnLabel.title = @"出　　纳：";
    _cnLabel.textColor = kTextColor;
    _cnLabel.allowEditing = NO;
    _cnLabel.content = self.model.cashier;
    _cnLabel.inputType = CXEditLabelInputTypeText;
    _cnLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.cashier = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_cnLabel];
    
    // line_8
    UIView *line_8 = [self createBottomFormSeperatorLine];
    line_8.frame = CGRectMake(0.f, _kjLabel.bottom, lineWidth, lineHeight);
    
    //备注
    _bzLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - 2*leftMargin, viewHeight)];
    _bzLabel.title = @"备　　注：";
    _bzLabel.textColor = kTextColor;
    _bzLabel.numberOfLines = 0;
    _bzLabel.allowEditing = NO;
    _bzLabel.content = self.model.remark;
    _bzLabel.inputType = CXEditLabelInputTypeText;
    _bzLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.remark = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_bzLabel];
    self.bzLabel.frame = CGRectMake(leftMargin, line_8.bottom, Screen_Width - 2*leftMargin, self.bzLabel.textHeight + self.bzLabel.paddingTopBottom);
    if (GET_HEIGHT(self.bzLabel) < kCellHeight) {
        self.bzLabel.height = kCellHeight;
    }
    

    //如果有附件
    if(self.model.fileList && [self.model.fileList count] > 0){
        // _fjBackView
        _fjBackView = [self createBottomFormSeperatorLine];
        _fjBackView.frame = CGRectMake(0.f, _bzLabel.bottom, lineWidth, kHKZPDWXXLabelTopSpace + kHKZPDWXXLabelFontSize + kHKZPDWXXLabelBottomSpace);
        
        // _fjLabel
        _fjLabel = [[UILabel alloc] init];
        _fjLabel.font = [UIFont systemFontOfSize:kHKZPDWXXLabelFontSize];
        _fjLabel.textColor = kHKZPDWXXLabelTextColor;
        _fjLabel.textAlignment = NSTextAlignmentLeft;
        _fjLabel.text = @"附件";
        [_fjLabel sizeToFit];
        _fjLabel.frame = CGRectMake(leftMargin, kHKZPDWXXLabelTopSpace, _fjLabel.size.width, kHKZPDWXXLabelFontSize);
        [self.fjBackView addSubview:_fjLabel];
        
        [self.bottomScrollContentView addSubview:self.fjListTableView];
    }
    
    if(self.isApproval){
        // line_10
        UIView *line_10 = [self createBottomFormSeperatorLine];
        
        // spWhiteBackView
        _spWhiteBackView = [[UIView alloc] init];
        
        //如果有附件
        if(self.model.fileList && [self.model.fileList count] > 0){
            line_10.frame = CGRectMake(0.f, self.fjListTableView.bottom, lineWidth, lineHeight);
//            _spWhiteBackView.frame = CGRectMake(0.f, self.fjListTableView.bottom, lineWidth, kSPBackWhiteViewHeight);
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, self.fjListTableView.bottom);
        }else{
            line_10.frame = CGRectMake(0.f, self.bzLabel.bottom, lineWidth, lineHeight);
//            _spWhiteBackView.frame = CGRectMake(0.f, line_10.bottom, lineWidth, kSPBackWhiteViewHeight);
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, line_10.bottom);
        }
        
        
        
        _spWhiteBackView.backgroundColor = [UIColor whiteColor];
        //删除审批按钮
        _spWhiteBackView.frame = CGRectMake(0.f, Screen_Height - kSPBackWhiteViewHeight, lineWidth, kSPBackWhiteViewHeight);
        [self.view addSubview:_spWhiteBackView];
        
        [self setupBottomView];//需求更改,我的审批模块里需要审批,我的报销模块里不需要审批
        
    }else{
        //如果有附件
        if(self.model.fileList && [self.model.fileList count] > 0){
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, self.fjListTableView.bottom);
        }else{
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, _opinionLabel.bottom);
        }
    }
    [self.tableView setTableFooterView:self.bottomScrollContentView];

    [self.view addSubview:self.tableView];
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self.topScrollContentView addSubview:line];
    return line;
}

/// 表单的分割线
- (UIView *)createBottomFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self.bottomScrollContentView addSubview:line];
    return line;
}

- (void)spBtnClick
{
    CXReimbursementApprovalAlertView *approvalAlertView = [[CXReimbursementApprovalAlertView alloc] initWithSubObjId:self.listModel.subObjectId affairId:self.model.eid];
    @weakify(self);
    approvalAlertView.callBack = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    [approvalAlertView show];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self setUpNavBar];
    [self loadData];
}
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
    NSDictionary *params = @{@"subObjId":self.listModel.subObjectId,
                              @"affairId":self.model.eid,
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.fjListTableView){
        CXAnnexFileModel *model = self.model.fileList[indexPath.row];
        if([[model.type lowercaseString] isEqualToString:@"pdf"]){
            CXInternalBulletinDetailViewController *vc = [[CXInternalBulletinDetailViewController alloc]initWithEid:model.id.integerValue type:isFJListH5 fileType:model.type URLString:@"cost/pdf/view" andTitle:model.fileName];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *fileName = [NSString stringWithFormat:@"%@.%@",model.id,model.type];
            NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
            BOOL fileIsExist = [[CXAnnexDownLoadManager sharedManager]fileIsExit:filePath andName:fileName];
            if(fileIsExist){
                NSString *filePath1 = [[CXAnnexDownLoadManager sharedManager]filePathOfDownloded:filePath andName:fileName];
                [YWFilePreviewView previewFileWithPaths:filePath1 andFileName:model.fileName];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tableView){
        return [self.dataSourceArr count];
    }else{
        //附件
        return [self.model.fileList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tableView){
        static NSString *cellID = @"cell";
        CXFeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (nil == cell) {
            cell = [[CXFeeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        CXFeeModel *model = self.dataSourceArr[indexPath.row];
        if ([model.amt containsString:@"E"]) {//
            model.amt = self.listModel.amount;
        }
        [cell setCXFeeModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *indentifer = @"downloadID";
        CXAnnexDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if(nil == cell){
            cell = [[CXAnnexDownLoadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
        }
       
        cell.model = self.model.fileList[indexPath.row];
        cell.hasRightDownload = YES;
        cell.vc = self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.fjListTableView){
        if(![self.cellArray containsObject:cell]){
            [self.cellArray addObject:cell];
        }
        [self selectCellStatus:(CXAnnexDownLoadTableViewCell *)cell];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tableView){
        CXFeeModel *model = self.dataSourceArr[indexPath.row];
        return [CXFeeTableViewCell getCellHeightWithCXFeeModel:model];
    }else{
        return kFileListCellHeight;
    }
}

- (void)loadData {
    NSString *type;
    if ([self.listModel.itemType isEqualToString:@"EmployeeVoucher"]) {
        type = @"ev";
    } else if ([self.listModel.itemType isEqualToString:@"GeneralVoucher"]) {
         type = @"gv";
    }else if ([self.listModel.itemType isEqualToString:@"SpecialVoucher"]) {
         type = @"sv";
    }else if ([self.listModel.itemType isEqualToString:@"AssetsVoucher"]) {
         type = @"av";
    }else if ([self.listModel.itemType isEqualToString:@"Reimbursement"]) {
        type = @"reim";
    }
    NSString *url = [NSString stringWithFormat:@"%@cost/detail/%@", urlPrefix,type];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.listModel.objectId forKey:@"eid"];
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool postWithPath:url params:params success:^(NSDictionary *JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        if ([JSON[@"status"] intValue] == 200) {
            self.model = [CXReimbursementDetailModel yy_modelWithJSON:JSON[@"data"]];
            self.model.feeArray = [NSArray yy_modelArrayWithClass:CXFeeModel.class json:JSON[@"data"][@"feeList"]];
            self.model.fileList = [NSArray yy_modelArrayWithClass:[CXAnnexFileModel class] json:JSON[@"data"][@"fileList"]];
            self.dataSourceArr = [NSMutableArray arrayWithArray:self.model.feeArray];
            [self setUpTableView];
        }
        else if ([JSON[@"status"] intValue] == 400) {
            [self.tableView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }else {
            CXAlert(JSON[@"msg"]);
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        CXAlert(KNetworkFailRemind);
    }];
}
- (void)selectCellStatus:(CXAnnexDownLoadTableViewCell *)cell{
    if([cell.model isKindOfClass:[CXAnnexFileModel class]]){
        CXAnnexFileModel *cellModel = cell.model;
        CXAnnexDownloadModel *dataModel = [[CXAnnexDownloadModel alloc]init];
        dataModel.resourceURLString = cellModel.id;
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"costOf%@", VAL_USERID]];
        dataModel.fileDirectory = [filePath stringByAppendingPathComponent:cellModel.id];
        dataModel.filePath = [dataModel.fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", cellModel.id, cellModel.type]];
        cell.status = [[CXAnnexDownLoadManager sharedManager]fileDownloadSatus:dataModel];
    }
}
#pragma mark - CXAnnexDownloadDelegate
- (void)downloadModel:(CXAnnexDownloadModel *)downloadModel dowloadStatus:(downloadStatus)status{
    [self.cellArray enumerateObjectsUsingBlock:^(CXAnnexDownLoadTableViewCell *cell, NSUInteger idx, BOOL *stop){
        if([cell.model isKindOfClass:[CXAnnexFileModel class]]){
            CXAnnexFileModel *cellModel = cell.model;
            if([cellModel.id isEqualToString:downloadModel.resourceURLString]){
                cell.status = status;
            }
            
        }
    }];
}
@end
