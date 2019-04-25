//
//  CXStatementOfAffairsFormViewController.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXStatementOfAffairsFormViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "HttpTool.h"
#import "CXFormHeaderView.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "CXApprovalPersonModel.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXStatementOfAffairsFormViewController ()

/** topView */
@property(strong, nonatomic) CXFormHeaderView *topView;
/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** 发送 */
@property(strong, nonatomic) CXEditLabel *fsLabel;
/** 抄送 */
@property(strong, nonatomic) CXEditLabel *csLabel;
/** 报告标题 */
@property(strong, nonatomic) CXEditLabel *bgbtLabel;
/** 报告内容 */
@property(strong, nonatomic) CXEditLabel *bgnrLabel;
/** cxerpAnnexView */
@property(weak, nonatomic) CXERPAnnexView *cxerpAnnexView;
/** 审批列表视图 */
@property(strong, nonatomic) CXApprovalListView *approvalListView;
/** 提醒批阅视图 */
@property(weak, nonatomic) CXApprovalBottomView *approvalBottomView;

@end

@implementation CXStatementOfAffairsFormViewController

#pragma mark - get & set
- (CXApprovalListView *)approvalListView {
    if (nil == _approvalListView) {
        _approvalListView = [[CXApprovalListView alloc] init];
    }
    return _approvalListView;
}

- (CXStatementOfAffairsFormModel *)model {
    if (!_model) {
        _model = [[CXStatementOfAffairsFormModel alloc] init];
    }
    return _model;
}

- (CXFormHeaderView *)topView {
    if (!_topView) {
        _topView = [[CXFormHeaderView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    [self setUpNavBar];
    [self setUpTopView];
    [self setUpScrollView];
    [self setUpOtherView];
    
    if (self.formType == CXFormTypeModify) {
        [self findDetailRequest];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"事务报告"];
    
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    if(self.formType == CXFormTypeCreate){
        [rootTopView setUpRightBarItemTitle:@"提交"
                                  addTarget:self
                                     action:@selector(rightItemEvent)];
    }
}

- (void)setUpTopView {
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo([self getRootTopView].mas_bottom);
        make.height.mas_equalTo(CXFormHeaderViewHeight);
    }];
    if (self.formType == CXFormTypeCreate) {
        self.topView.displayNumber = NO;
    }
}

- (void)setUpScrollView {
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).mas_offset(navHigh);
        make.top.equalTo([self topView].mas_bottom).offset(5.f);
    }];
    
    BOOL isDetail = self.formType == CXFormTypeDetail;
    /// 左边距
    CGFloat leftMargin = 5.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 2.f;
    CGFloat lineWidth = Screen_Width;
    /// 宽度
    CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;
    
    @weakify(self);
    
    // 发送
    _fsLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, 0.f, Screen_Width, viewHeight)];
    _fsLabel.title = @"　　发送：";
    _fsLabel.allowEditing = !isDetail;
    _fsLabel.inputType = CXEditLabelInputTypeFS;
    [self.scrollContentView addSubview:_fsLabel];
    _fsLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSInteger i = 1;
        for(CXUserModel * selectMember in editLabel.selectedCCUsers){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:selectMember.job forKey:@"job"];
            [dic setValue:selectMember.name forKey:@"name"];
            [dic setValue:[NSString stringWithFormat:@"%zd",i] forKey:@"no"];
            [dic setValue:@(selectMember.eid) forKey:@"userId"];
            [dataArray addObject:dic];
            i++;
        }
        NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
        self.model.approvalPerson = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    };
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _fsLabel.bottom, lineWidth, lineHeight);
    
    // 抄送
    _csLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width, viewHeight)];
    _csLabel.title = @"　　抄送：";
    _csLabel.allowEditing = !isDetail;
    _csLabel.inputType = CXEditLabelInputTypeCC;
    [self.scrollContentView addSubview:_csLabel];
    _csLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(CXUserModel * selectMember in editLabel.selectedCCUsers){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:@(selectMember.eid) forKey:@"eid"];
            [dic setValue:selectMember.name forKey:@"name"];
            [dic setValue:selectMember.imAccount forKey:@"imAccount"];
            [dataArray addObject:dic];
        }
        NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
        self.model.cc = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
    };
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _csLabel.bottom, lineWidth, lineBoldHeight);
    
    // 报告标题
    _bgbtLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, viewWidth * 2, viewHeight)];
    _bgbtLabel.allowEditing = !isDetail;
    _bgbtLabel.title = @"报告标题：";
    _bgbtLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_bgbtLabel];
    _bgbtLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.model.title = editLabel.content;
    };
    
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _bgbtLabel.bottom, lineWidth, lineHeight);
    
    
    // 报告内容
    _bgnrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
    _bgnrLabel.allowEditing = !isDetail;
    _bgnrLabel.title = @"报告内容：";
    _bgnrLabel.scale = YES;
    _bgnrLabel.numberOfLines = 0;
    [self.scrollContentView addSubview:_bgnrLabel];
    _bgnrLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.model.remark = editLabel.content;
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.bgnrLabel.bottom);
    };
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _bgnrLabel.bottom);
}

- (void)setUpOtherView {
    // 附件
    CXERPAnnexView *erpAnnexView = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0.f, 0.f, Screen_Width, CXERPAnnexView_height) type:CXERPAnnexViewTypePictureAndVoice];
    erpAnnexView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:erpAnnexView];
    self.cxerpAnnexView = erpAnnexView;
    
    [erpAnnexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.scrollContentView.mas_bottom).mas_offset(0.f);
        make.height.mas_equalTo(CXERPAnnexView_height);
    }];
    
    // 批阅视图
    [self.view addSubview:self.approvalListView];
    [self.approvalListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(erpAnnexView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-CXApprovalBottomViewHeight - kTabbarSafeBottomMargin);
    }];
}

- (void)setUpApprovalBottomView {
    // 批阅底部
    CXApprovalBottomView *approvalBottomView = [[CXApprovalBottomView alloc] initWithType:@"affair" eid:[self.model.eid intValue]];
    self.approvalBottomView = approvalBottomView;
    [self.view addSubview:approvalBottomView];
    [approvalBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXApprovalBottomViewHeight);
    }];
}

#pragma mark - instance function
- (void)approvalEvent {
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc] initWithBid:[NSString stringWithFormat:@"%zd", [self.model.eid integerValue]] btype:BusinessType_SW];
    @weakify(self);
    approvalAlertView.callBack = ^{
        @strongify(self);
        if (self.callBack) {
            self.callBack();
        }
        [self findDetailRequest];
    };
    [approvalAlertView show];
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)saveStatementOfAffairsRequest {
    if (!self.model.approvalPerson || ![self.model.approvalPerson length]) {
        MAKE_TOAST_V(@"审批人不能为空");
        return;
    }
    if (!self.model.title || ![self.model.title length]) {
        MAKE_TOAST_V(@"报告标题不能为空");
        return;
    }
    if (!self.model.remark || ![self.model.remark length]) {
        MAKE_TOAST_V(@"报告内容不能为空");
        return;
    }
    
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
    self.model.ygId = userModel.userId;
    self.model.ygName = userModel.name;
    self.model.ygDeptId = userModel.deptId;
    self.model.ygDeptName = userModel.deptName;
    self.model.ygJob = userModel.job;
    NSMutableDictionary *param = [self.model yy_modelToJSONObject];
    self.cxerpAnnexView.annexUploadCallBack = ^(NSString *annex) {
        param[@"annex"] = annex;
        NSString *url = [NSString stringWithFormat:@"%@affair/save", urlPrefix];
        HUD_SHOW(nil);
        
        [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
        [HttpTool postWithPath:url params:param success:^(id JSON) {
            [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

            HUD_HIDE;
            if ([JSON[@"status"] intValue] == 200) {
                if (self.callBack) {
                    self.callBack();
                }
                TTAlert(@"提交成功!");
            }
            else {
                CXAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

            HUD_HIDE;
            CXAlert(KNetworkFailRemind);
        }];
    };
    [self.cxerpAnnexView annexUpLoad];
}

- (void)rightItemEvent {
    [self saveStatementOfAffairsRequest];
}

- (void)setUpDetail {
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsContactsDicWithUserId:[self.model.ygId integerValue]];
    self.topView.avatar = userModel.icon;
    self.topView.name = userModel.name;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@",self.model.ygDeptName,self.model.ygJob];
    self.topView.date = self.model.createTime;
    self.topView.number = self.model.serNo;
    NSMutableString *content = [[NSMutableString alloc] init];
    if (self.model.approvalPersonArray.count == 1) {
        [content appendString:self.model.approvalPersonArray.firstObject.name];
        self.fsLabel.content = content;
    } else if (self.model.approvalPersonArray.count > 1) {
        for(CXApprovalPersonModel * approvalPersonModel in self.model.approvalPersonArray){
            [content appendString:[NSString stringWithFormat:@"、%@",approvalPersonModel.name]];
        }
        self.fsLabel.content = [content substringFromIndex:1];
    }
    self.fsLabel.allowEditing = NO;
    self.fsLabel.userInteractionEnabled = NO;
    self.fsLabel.showDropdown = NO;
    
    self.csLabel.allowEditing = NO;
    self.csLabel.showDropdown = NO;
    if(self.model.ccArray && [self.model.ccArray count] > 0){
        NSMutableArray * selectedCCUsers = [[NSMutableArray alloc] initWithCapacity:0];
        for(CXCCUserModel * user in self.model.ccArray){
            CXUserModel * userModel = [[CXUserModel alloc] init];
            userModel.eid = [user.userId integerValue];
            userModel.name = user.userName;
            userModel.imAccount = user.imAccount;
            [selectedCCUsers addObject:userModel];
        }
        self.csLabel.detailCCData = selectedCCUsers;
    }
    
    self.bgbtLabel.allowEditing = YES;
    self.bgbtLabel.content = self.model.title;
    
    self.bgnrLabel.allowEditing = YES;
    self.bgnrLabel.content = self.model.remark;
    
    self.cxerpAnnexView.detailAnnexDataArray = self.model.annexArray.mutableCopy;
    
    
    if (CXApprovalStatusInInvalid == [self.model.approvalSta integerValue] && [self.model.ygId integerValue] == [VAL_USERID integerValue]) {
        
    } else {
        self.fsLabel.allowEditing = NO;
        self.csLabel.allowEditing = NO;
        self.bgbtLabel.allowEditing = NO;
        self.bgnrLabel.allowEditing = NO;
    }
    
    if ([self.model.approvalUserId integerValue] == [VAL_USERID longValue] && ([self.model.approvalSta integerValue] == CXApprovalStatusInProgress || [self.model.approvalSta integerValue] == CXApprovalStatusInInvalid)) {
        [[self getRootTopView] setUpRightBarItemTitle:@"批阅" addTarget:self action:@selector(approvalEvent)];
    }else if (CXApprovalStatusInInvalid == [self.model.approvalSta integerValue] && [self.model.ygId integerValue] == [VAL_USERID integerValue]) {
        [[self getRootTopView] setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    }else {
        [[self getRootTopView] removeRightBarItem];
    }
    
    [self.approvalListView setBid:[NSString stringWithFormat:@"%zd", [self.model.eid integerValue]] bType:BusinessType_SW];
    
    if ([self.model.ygId integerValue] == [VAL_USERID longValue] &&
        ([self.model.approvalSta integerValue] == CXApprovalStatusInProgress || [self.model.approvalSta integerValue] == CXApprovalStatusInInvalid)) {
        /**
         * 满足以下条件，“提醒批阅”会一直显示：
         1、申请人账号；
         2、有批审流程的详情页；
         3、批审流程未完成。
         点击之后弹出提示是否发送，确认发送会发送短信到当前批审人手机上
         */
        [self setUpApprovalBottomView];
    } else {
        if (self.approvalBottomView) {
            [self.approvalBottomView removeFromSuperview];
        }
        [self.approvalListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@affair/detail/%zd", urlPrefix,[self.model.eid integerValue]];
    HUD_SHOW(nil);
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    [HttpTool getWithPath:url params:nil success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.model = [CXStatementOfAffairsFormModel yy_modelWithDictionary:JSON[@"data"][@"affair"]];
            self.model.approvalPersonArray = [NSArray yy_modelArrayWithClass:CXApprovalPersonModel.class json:JSON[@"data"][@"affair"][@"approvalPerson"]];
            self.model.ccArray = [NSArray yy_modelArrayWithClass:CXCCUserModel.class json:JSON[@"data"][@"ccList"]];
            self.model.annexArray = JSON[@"data"][@"annexList"];
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for(CXApprovalPersonModel * approvalPersonModel in self.model.approvalPersonArray){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:approvalPersonModel.job forKey:@"job"];
                [dic setValue:approvalPersonModel.name forKey:@"name"];
                [dic setValue:approvalPersonModel.no forKey:@"no"];
                [dic setValue:approvalPersonModel.userId forKey:@"userId"];
                [dataArray addObject:dic];
            }
            NSData *receiveData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:0];
            self.model.approvalPerson = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",self.model);
            [self setUpDetail];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
