//
//  CXReimbursementPaymentDetailViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/3/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXReimbursementPaymentDetailViewController.h"
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
#import "YWFilePreviewView.h"
#import "CXAnnexDownLoadTableViewCell.h"
#import "CXInternalBulletinDetailViewController.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXReimbursementPaymentDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

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

/** hkzpdwxxBackView */
@property(strong, nonatomic) UIView *hkzpdwxxBackView;
/** 汇款/支票单位信息Label */
@property(strong, nonatomic) UILabel *hkzpdwxxLabel;
/** 收款单位名称 */
@property(strong, nonatomic) CXEditLabel *skdwmcLabel;
/** 收款单位开户行 */
@property(strong, nonatomic) CXEditLabel *skdwkhhLabel;
/** 收款单位账号 */
@property(strong, nonatomic) CXEditLabel *skdwzhLabel;
/** 审批按钮白色背景 */
@property(strong, nonatomic) UIView *spWhiteBackView;
/** 审批按钮 */
@property(strong, nonatomic) UIButton *spButton;
/** topScrollContentView */
@property (nonatomic, strong) UIView * topScrollContentView;
/** bottomScrollContentView */
@property (nonatomic, strong) UIView * bottomScrollContentView;

/** fjBackView */
@property(strong, nonatomic) UIView *fjBackView;
/** 附件Label */
@property(strong, nonatomic) UILabel *fjLabel;
/** 附件fjListTableView */
@property (nonatomic, strong) UITableView * fjListTableView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@end

@implementation CXReimbursementPaymentDetailViewController

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
    [rootTopView setNavTitle:@"报销付款单"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh) style:UITableViewStylePlain];
    self.tableView.backgroundColor = SDBackGroudColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        self.tableView.separatorColor = SDBackGroudColor;
    } else {//处理透明的线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _fpfyhjLabel.title = @"发票费用合计：";
    _fpfyhjLabel.allowEditing = NO;
    _fpfyhjLabel.textColor = kTextColor;
    _fpfyhjLabel.inputType = CXEditLabelInputTypeText;
    _fpfyhjLabel.content = self.model.total;
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
    _rmbfyhjLabel.title = @"RMB费用合计：";
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
    
    //一级审批
    _yjspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, viewWidth, viewHeight)];
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
    
    //二级审批
    _ejspLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(_yjspLabel.right, line_6.bottom, viewWidth, viewHeight)];
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
    /*
    UIView *line_opinionLabel = [self createBottomFormSeperatorLine];
    line_opinionLabel.frame = CGRectMake(0.f, _bzLabel.bottom, lineWidth, lineHeight);
    //审批意见
    _opinionLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - 2*leftMargin, viewHeight)];
    _opinionLabel.title = @"审批意见：";
    _opinionLabel.textColor = kTextColor;
    _opinionLabel.numberOfLines = 0;
    _opinionLabel.allowEditing = NO;
    _opinionLabel.content = self.model.remark;
    _opinionLabel.inputType = CXEditLabelInputTypeText;
    _opinionLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
//        CXStrongSelf(self)
//        self.model.remark = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_opinionLabel];
    self.opinionLabel.frame = CGRectMake(leftMargin, self.bzLabel.bottom + 1, Screen_Width - 2*leftMargin, self.opinionLabel.textHeight + self.opinionLabel.paddingTopBottom);
    if (GET_HEIGHT(self.opinionLabel) < kCellHeight) {
        self.opinionLabel.height = kCellHeight;
    }
    */
    
    // _hkzpdwxxBackView
    _hkzpdwxxBackView = [self createBottomFormSeperatorLine];
    _hkzpdwxxBackView.frame = CGRectMake(0.f, _bzLabel.bottom, lineWidth, kHKZPDWXXLabelTopSpace + kHKZPDWXXLabelFontSize + kHKZPDWXXLabelBottomSpace);
    
    // _hkzpdwxxLabel
    _hkzpdwxxLabel = [[UILabel alloc] init];
    _hkzpdwxxLabel.font = [UIFont systemFontOfSize:kHKZPDWXXLabelFontSize];
    _hkzpdwxxLabel.textColor = kHKZPDWXXLabelTextColor;
    _hkzpdwxxLabel.textAlignment = NSTextAlignmentLeft;
    _hkzpdwxxLabel.text = @"汇款/支票单位信息";
    [_hkzpdwxxLabel sizeToFit];
    _hkzpdwxxLabel.frame = CGRectMake(leftMargin, kHKZPDWXXLabelTopSpace, _hkzpdwxxLabel.size.width, kHKZPDWXXLabelFontSize);
    [self.hkzpdwxxBackView addSubview:_hkzpdwxxLabel];
    
    //收款单位名称
    _skdwmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, _hkzpdwxxBackView.bottom, Screen_Width - leftMargin, viewHeight)];
    _skdwmcLabel.title = @"收款单位名称：";
    _skdwmcLabel.textColor = kTextColor;
    _skdwmcLabel.allowEditing = NO;
    _skdwmcLabel.content = self.model.receiveCompany;
    _skdwmcLabel.inputType = CXEditLabelInputTypeText;
    _skdwmcLabel.numberOfLines = 0;
    _skdwmcLabel.scale = YES;
    _skdwmcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.receiveCompany = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_skdwmcLabel];
    
    // line_9
    UIView *line_9 = [self createBottomFormSeperatorLine];
    line_9.frame = CGRectMake(0.f, _skdwmcLabel.bottom, lineWidth, lineHeight);
    
    //收款单位开户行
    _skdwkhhLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_9.bottom, Screen_Width - leftMargin, viewHeight)];
    _skdwkhhLabel.title = @"收款单位开户行：";
    _skdwkhhLabel.textColor = kTextColor;
    _skdwkhhLabel.allowEditing = NO;
    _skdwkhhLabel.content = self.model.receiveBank;
    _skdwkhhLabel.inputType = CXEditLabelInputTypeText;
    _skdwkhhLabel.numberOfLines = 0;
    _skdwkhhLabel.scale = YES;
    _skdwkhhLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.receiveBank = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_skdwkhhLabel];
    
    // line_10
    UIView *line_10 = [self createBottomFormSeperatorLine];
    line_10.frame = CGRectMake(0.f, _skdwkhhLabel.bottom, lineWidth, lineHeight);
    
    //收款单位账号
    _skdwzhLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_10.bottom, Screen_Width - leftMargin, viewHeight)];
    _skdwzhLabel.title = @"收款单位账号：";
    _skdwzhLabel.textColor = kTextColor;
    _skdwzhLabel.allowEditing = NO;
    _skdwzhLabel.content = self.model.receiveAccount;
    _skdwzhLabel.inputType = CXEditLabelInputTypeText;
    _skdwzhLabel.numberOfLines = 0;
    _skdwzhLabel.scale = YES;
    _skdwzhLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        CXStrongSelf(self)
        self.model.receiveAccount = editLabel.content;
    };
    [self.bottomScrollContentView addSubview:_skdwzhLabel];
    
    //如果有附件
    if(self.model.fileList && [self.model.fileList count] > 0){
        // _fjBackView
        _fjBackView = [self createBottomFormSeperatorLine];
        _fjBackView.frame = CGRectMake(0.f, _skdwzhLabel.bottom, lineWidth, kHKZPDWXXLabelTopSpace + kHKZPDWXXLabelFontSize + kHKZPDWXXLabelBottomSpace);
        
        // _fjLabel
        _fjLabel = [[UILabel alloc] init];
        _fjLabel.font = [UIFont systemFontOfSize:kHKZPDWXXLabelFontSize];
        _fjLabel.textColor = kHKZPDWXXLabelTextColor;
        _fjLabel.textAlignment = NSTextAlignmentLeft;
        _fjLabel.text = @"附件";
        [_fjLabel sizeToFit];
        _fjLabel.frame = CGRectMake(leftMargin, kHKZPDWXXLabelTopSpace, _hkzpdwxxLabel.size.width, kHKZPDWXXLabelFontSize);
        [self.fjBackView addSubview:_fjLabel];
        
        [self.bottomScrollContentView addSubview:self.fjListTableView];
    }
    
    if(self.isApproval){
        // line_11
        UIView *line_11 = [self createBottomFormSeperatorLine];
        
        // spWhiteBackView
        _spWhiteBackView = [[UIView alloc] init];
        
        //如果有附件
        if(self.model.fileList && [self.model.fileList count] > 0){
            line_11.frame = CGRectMake(0.f, self.fjListTableView.bottom, lineWidth, lineHeight);
            _spWhiteBackView.frame = CGRectMake(0.f, self.fjListTableView.bottom, lineWidth, kSPBackWhiteViewHeight);
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, self.fjListTableView.bottom);
        }else{
            line_11.frame = CGRectMake(0.f, _skdwzhLabel.bottom, lineWidth, lineHeight);
            _spWhiteBackView.frame = CGRectMake(0.f, line_11.bottom, lineWidth, kSPBackWhiteViewHeight);
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, line_11.bottom);
        }
        
        _spWhiteBackView.backgroundColor = [UIColor whiteColor];
//        [self.bottomScrollContentView addSubview:_spWhiteBackView];
        
        // spButton
        /*
        _spButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _spButton.frame = CGRectMake(kSPBtnLeftSpace, kSPBtnTopSpace, Screen_Width - kSPBtnLeftSpace*2, kSPBackWhiteViewHeight - 2*kSPBtnTopSpace);
        _spButton.layer.cornerRadius = kSPBtnCornerRadius;
        _spButton.clipsToBounds = YES;
        [_spButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_spButton setTitle:@"审 批" forState:UIControlStateNormal];
        [_spButton.titleLabel setTextColor:[UIColor whiteColor]];
        _spButton.backgroundColor = [UIColor redColor];
        [_spButton addTarget:self
                      action:@selector(spBtnClick)
            forControlEvents:UIControlEventTouchUpInside];
        [self.spWhiteBackView addSubview:_spButton];//需求更改,我的审批模块需要审批,我的报销模块里不需要审批
         */
         UIButton *agreeButton = [self createButton];
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.spWhiteBackView addSubview:agreeButton];
        UIButton *unagreeButton = [self createButton];
        [unagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
        [self.spWhiteBackView addSubview:unagreeButton];
        NSArray *buttonArray = @[agreeButton,unagreeButton];
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:20 tailSpacing:20];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }else{
        //如果有附件
        if(self.model.fileList && [self.model.fileList count] > 0){
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, self.fjListTableView.bottom);
        }else{
            self.bottomScrollContentView.frame = CGRectMake(0, 0, Screen_Width, _skdwzhLabel.bottom);
        }
    }
    
    [self.tableView setTableFooterView:self.bottomScrollContentView];
    
    [self.view addSubview:self.tableView];
    //
    self.spWhiteBackView.frame = CGRectMake(0, Screen_Height - 50, Screen_Width, 50);
    [self.view addSubview:self.spWhiteBackView];
}
- (UIButton *)createButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.layer.cornerRadius = kSPBtnCornerRadius;
    button.clipsToBounds = YES;
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)buttonClick:(UIButton *)sender{
    NSLog(@"点击的是同意吗?===%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"同意"]) {
        [self submitWithRemark:nil agree:YES];
    } else {
        [self showActionController];
    }
}
- (void)showActionController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"批审" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入内容";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *remark = [[alertController textFields] objectAtIndex:0].text;
        NSLog(@"ok, %@", [[alertController textFields] objectAtIndex:0].text);
        if (remark.length == 0 || [remark isEqualToString:@""]) {
            [MBProgressHUD toastAtCenterForView:self.view text:@"批审意见不能为空" duration:2];
            [self performSelector:@selector(showActionController) withObject:nil afterDelay:3.0];
        }else{
            [self submitWithRemark:remark agree:NO];
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action2];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 提交
- (void)submitWithRemark:(NSString *)remark agree:(BOOL)agree{
    NSDictionary *params = @{@"subObjId":self.listModel.subObjectId,
                             @"affairId":self.model.eid,
                             @"kind":agree ? @(1) : @(2),//1同意,2退回
                             @"comments":remark ? : @""
                             };
    NSString *path = [NSString stringWithFormat:@"%@/cost/approve",urlPrefix];
    [HttpTool postWithPath:path params:params success:^(id JSON) {
        NSString *message = JSON[@"msg"];
        NSInteger status = [JSON[@"status"] integerValue];
        [MBProgressHUD toastAtCenterForView:self.view text:status == 200 ? @"请求成功,请重试" : @"请求成功" duration:2];
        if (status == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        CXAlert(@"请求失败,请重试")
    }];
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
        [cell setCXFeeModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //附件
        static NSString *indentifer = @"downloadID";
        CXAnnexDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if(nil == cell){
            cell = [[CXAnnexDownLoadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
        }
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        //附件
        return kFileListCellHeight;
    }
}

- (void)loadData {
    NSString *url = [NSString stringWithFormat:@"%@cost/detail/rp", urlPrefix];
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
            CXAlert(JSON[@"msg"]);
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
