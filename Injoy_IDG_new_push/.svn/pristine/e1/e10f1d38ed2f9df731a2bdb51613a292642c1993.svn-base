//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXWorkOutsideEditViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "CXBaseRequest.h"
#import "CXFormHeaderView.h"
#import "CXApprovalPersonModel.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "NSDate+YYAdd.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXWorkOutsideEditViewController ()
@property(strong, nonatomic) CXFormHeaderView *topView;
@property(strong, nonatomic) UIScrollView *scrollContentView;
/**< 发送 */
@property(strong, nonatomic) CXEditLabel *sendLabel;
/**< 目的地 */
@property(strong, nonatomic) CXEditLabel *placeLabel;
/**< 交通工具 */
@property(strong, nonatomic) CXEditLabel *vehicleLabel;
/**< 外出时间 */
@property(strong, nonatomic) CXEditLabel *timeLabel;
/**< 外出时间结束 */
@property(strong, nonatomic) CXEditLabel *endTimeLabel;
/**< 外出事由 */
@property(strong, nonatomic) CXEditLabel *reasonLabel;
/**< 外出说明 */
@property(strong, nonatomic) CXEditLabel *remarkLabel;
@property(weak, nonatomic) CXERPAnnexView *cxerpAnnexView;
@property(strong, nonatomic) CXApprovalListView *approvalListView;
@property(weak, nonatomic) CXApprovalBottomView *approvalBottomView;
@end

@implementation CXWorkOutsideEditViewController

#pragma mark - get & set

- (CXApprovalListView *)approvalListView {
    if (nil == _approvalListView) {
        _approvalListView = [[CXApprovalListView alloc] init];
    }
    return _approvalListView;
}

- (CXOutWorkModel *)outWorkModel {
    if (nil == _outWorkModel) {
        _outWorkModel = [[CXOutWorkModel alloc] init];
    }
    return _outWorkModel;
}

- (CXFormHeaderView *)topView {
    if (nil == _topView) {
        _topView = [[CXFormHeaderView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIScrollView *)scrollContentView {
    if (nil == _scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        [self.view addSubview:_scrollContentView];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContentView;
}

#pragma mark - instance function

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)saveOutWorkRequest {
    if (![self.sendLabel.content length]) {
        MAKE_TOAST_V(@"发送人不能为空");
        return;
    }
    if (![self.placeLabel.content length]) {
        MAKE_TOAST_V(@"外出地不能为空");
        return;
    }
    if (![self.vehicleLabel.content length]) {
        MAKE_TOAST_V(@"交通工具不能为空");
        return;
    }
    if (![self.timeLabel.content length]) {
        MAKE_TOAST_V(@"出发时间不能为空");
        return;
    }
    if (![self.endTimeLabel.content length]) {
        MAKE_TOAST_V(@"返回时间不能为空");
        return;
    }

    NSTimeInterval startTimeInterval = [[NSDate dateWithString:self.timeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];

    NSTimeInterval endTimeInterval = [[NSDate dateWithString:self.endTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];

    if (startTimeInterval > endTimeInterval + 1.f) {
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }

    if (![self.reasonLabel.content length]) {
        MAKE_TOAST_V(@"外出事由不能为空");
        return;
    }
    if (![self.remarkLabel.content length]) {
        MAKE_TOAST_V(@"外出说明不能为空");
        return;
    }

    NSString *url = [NSString stringWithFormat:@"%@outWork/save", urlPrefix];

    self.outWorkModel.ygDeptId = [VAL_DpId longValue];
    self.outWorkModel.ygId = [VAL_USERID longValue];
    self.outWorkModel.ygName = VAL_USERNAME;
    self.outWorkModel.ygDeptName = VAL_DpName;
    self.outWorkModel.ygJob = VAL_Job;

    @weakify(self);

    NSMutableDictionary *param = [self.outWorkModel yy_modelToJSONObject];
    if (self.formType == CXFormTypeCreate) {
        param[@"eid"] = nil;
    }

    self.cxerpAnnexView.annexUploadCallBack = ^(NSString *annex) {
        param[@"annex"] = annex;
        HUD_SHOW(nil);
        [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
        [CXBaseRequest postResultWithUrl:url
                                   param:param
                                 success:^(id responseObj) {
                                     [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                                     @strongify(self);
                                     CXOutWorkModel *model = [CXOutWorkModel yy_modelWithDictionary:responseObj];
                                     if (HTTPSUCCESSOK == model.status) {
                                         CXAlertExt(@"提交成功", ^{
                                             if (self.callBack) {
                                                 self.callBack();
                                             }
                                             [self.navigationController popViewControllerAnimated:YES];
                                         });
                                     } else {
                                         MAKE_TOAST(model.msg);
                                     }
                                     HUD_HIDE;
                                 } failure:^(NSError *error) {
                                     [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                    HUD_HIDE;
                    CXAlert(KNetworkFailRemind);
                }];
    };
    [self.cxerpAnnexView annexUpLoad];
}

- (void)rightItemEvent {
    [self saveOutWorkRequest];
}

- (void)approvalEvent {
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc] initWithBid:[NSString stringWithFormat:@"%ld", self.outWorkModel.eid] btype:BusinessType_OW];
    @weakify(self);
    approvalAlertView.callBack = ^{
        @strongify(self);
        [self findDetailRequest];
        if (self.callBack) {
            self.callBack();
        }
    };
    [approvalAlertView show];
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"工作外出"];

    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];

    if (self.formType == CXFormTypeCreate) {
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

    CGFloat topMargin = 10.f;
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
    _sendLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, 0.f, Screen_Width - leftMargin, viewHeight}];
    _sendLabel.title = @"      发  送：";
    _sendLabel.inputType = CXEditLabelInputTypeFS;
    [self.scrollContentView addSubview:_sendLabel];
    _sendLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:editLabel.selectedCCUsers.count];
        CXApprovalPersonModel *approvalPersonModel = nil;
        int idx = 1;
        for (CXUserModel *aModel in editLabel.selectedCCUsers) {
            approvalPersonModel = [[CXApprovalPersonModel alloc] init];
            approvalPersonModel.job = aModel.job;
            approvalPersonModel.name = aModel.name;
            approvalPersonModel.userId = @(aModel.eid);
            approvalPersonModel.no = [NSString stringWithFormat:@"%d", idx];
            [tempArr addObject:approvalPersonModel];
            ++idx;
        }
        self.outWorkModel.approvalPerson = tempArr;
    };

    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, _sendLabel.bottom, lineWidth, lineBoldHeight};

    // 外出地
    _placeLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, viewWidth, viewHeight)];
    [self.scrollContentView addSubview:_placeLabel];
    _placeLabel.title = @"外  出  地：";
    _placeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.targetAddress = editLabel.content;
    };

    // 交通工具
    _vehicleLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {_placeLabel.right, _placeLabel.top, viewWidth, viewHeight}];
    _vehicleLabel.title = @"交通工具：";
    [self.scrollContentView addSubview:_vehicleLabel];
    _vehicleLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.vehicles = editLabel.content;
    };

    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = (CGRect) {0.f, _vehicleLabel.bottom, lineWidth, lineHeight};

    // 外出时间
    _timeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight}];
    _timeLabel.title = @"外出时间：";
    _timeLabel.inputType = CXEditLabelInputTypeDateAndTime;
    [self.scrollContentView addSubview:_timeLabel];
    _timeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.startTime = editLabel.content;
    };

    // line_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = (CGRect) {0.f, _timeLabel.bottom, lineWidth, lineHeight};

    // 外出时间结束
    _endTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight}];
    _endTimeLabel.title = @"            至：";
    _endTimeLabel.inputType = CXEditLabelInputTypeDateAndTime;
    [self.scrollContentView addSubview:_endTimeLabel];
    _endTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.endTime = editLabel.content;
    };


    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = (CGRect) {0.f, _endTimeLabel.bottom, lineWidth, lineHeight};

    // 外出事由
    _reasonLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_3.bottom, viewWidth * 2, viewHeight}];
    _reasonLabel.title = @"外出事由：";
    [self.scrollContentView addSubview:_reasonLabel];
    _reasonLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.reason = editLabel.content;
    };

    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = (CGRect) {0.f, _reasonLabel.bottom, lineWidth, lineBoldHeight};

    // 外出说明
    _remarkLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight}];
    _remarkLabel.title = @"外出说明：";
    _remarkLabel.scale = YES;
    _remarkLabel.numberOfLines = 0;
    [self.scrollContentView addSubview:_remarkLabel];
    _remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.outWorkModel.remark = editLabel.content;
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, self.remarkLabel.bottom);
    };
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _remarkLabel.bottom);
}

- (void)setUpApprovalBottomView {
    // 批阅底部
    CXApprovalBottomView *approvalBottomView = [[CXApprovalBottomView alloc] initWithType:@"outWork" eid:self.outWorkModel.eid];
    self.approvalBottomView = approvalBottomView;
    [self.view addSubview:approvalBottomView];
    [approvalBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXApprovalBottomViewHeight);
    }];
}

- (void)setUpOtherView {
    // 附件
    CXERPAnnexView *erpAnnexView = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0.f, 0.f, Screen_Width, CXERPAnnexView_height) type:CXERPAnnexViewTypePictureAndVoice];
    erpAnnexView.backgroundColor = [UIColor whiteColor];
    erpAnnexView.vc = self.navigationController;
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

- (void)setUpDetail {
    self.topView.avatar = self.outWorkModel.icon;
    self.topView.name = self.outWorkModel.ygName;
    self.topView.date = self.outWorkModel.createTime;
    self.topView.number = self.outWorkModel.serNo;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@", self.outWorkModel.ygDeptName, self.outWorkModel.ygJob];

    self.sendLabel.allowEditing = NO;
    self.sendLabel.showDropdown = NO;

    self.placeLabel.content = self.outWorkModel.targetAddress;
    self.vehicleLabel.content = self.outWorkModel.vehicles;
    self.timeLabel.content = self.outWorkModel.startTime;
    self.endTimeLabel.content = self.outWorkModel.endTime;
    self.reasonLabel.content = self.outWorkModel.reason;
    self.remarkLabel.content = self.outWorkModel.remark;

    self.cxerpAnnexView.detailAnnexDataArray = self.outWorkModel.annexList;

    if ([self.outWorkModel.approvalPerson count] == 1) {
        self.sendLabel.content = [[self.outWorkModel.approvalPerson firstObject] name];
    } else if ((int) [self.outWorkModel.approvalPerson count] > 1) {
        NSMutableString *content = [[NSMutableString alloc] init];
        for (CXApprovalPersonModel *approvalPersonModel in self.outWorkModel.approvalPerson) {
            [content appendString:[NSString stringWithFormat:@"、%@", approvalPersonModel.name]];
        }
        self.sendLabel.content = [content substringFromIndex:1];
    }

    if (CXApprovalStatusInInvalid == self.outWorkModel.approvalSta &&
            self.outWorkModel.ygId == [VAL_USERID longValue]) {
        [[self getRootTopView] setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    } else {
        self.placeLabel.allowEditing = NO;
        self.vehicleLabel.allowEditing = NO;
        self.vehicleLabel.showDropdown = NO;
        self.timeLabel.allowEditing = NO;
        self.endTimeLabel.allowEditing = NO;
        self.reasonLabel.allowEditing = NO;
        self.remarkLabel.allowEditing = NO;
    }

    if (self.outWorkModel.approvalUserId == [VAL_USERID longValue]) {
        if (self.outWorkModel.approvalSta != CXApprovalStatusFinished) {
            [[self getRootTopView] setUpRightBarItemTitle:@"批阅" addTarget:self action:@selector(approvalEvent)];
            self.placeLabel.allowEditing = NO;
            self.vehicleLabel.allowEditing = NO;
            self.vehicleLabel.showDropdown = NO;
            self.timeLabel.allowEditing = NO;
            self.endTimeLabel.allowEditing = NO;
            self.reasonLabel.allowEditing = NO;
            self.remarkLabel.allowEditing = NO;
        } else {
            if (self.outWorkModel.ygId != [VAL_USERID longValue]) {
                [[self getRootTopView] removeRightBarItem];
            }
        }
    } else {
        if (self.outWorkModel.ygId != [VAL_USERID longValue]) {
            [[self getRootTopView] removeRightBarItem];
        }
    }

    if (self.outWorkModel.ygId == [VAL_USERID longValue] &&
            self.outWorkModel.approvalSta != CXApprovalStatusFinished) {
        /**
         * 满足以下条件，“提醒批阅”会一直显示：
        1、申请人账号；
        2、有批审流程的详情页；
        3、批审流程未完成。
        点击之后弹出提示是否发送，确认发送会发送短信到当前批审人手机上
         */
        [self setUpApprovalBottomView];
    } else {
        [self.approvalBottomView removeFromSuperview];
        [self.approvalListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }

    [self.approvalListView setBid:[NSString stringWithFormat:@"%ld", self.outWorkModel.eid] bType:BusinessType_OW];
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@outWork/detail/%ld", urlPrefix, self.outWorkModel.eid];

    @weakify(self);

    HUD_SHOW(nil);
    
    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading

    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading
                                
                                @strongify(self);
                                CXOutWorkModel *model = [CXOutWorkModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    self.outWorkModel = [CXOutWorkModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.outWork"]];
                                    self.outWorkModel.annexList = [responseObj valueForKeyPath:@"data.annexList"];

                                    [self setUpDetail];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }
                                HUD_HIDE;
                            } failure:^(NSError *error) {
                                [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
            }];
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

@end
