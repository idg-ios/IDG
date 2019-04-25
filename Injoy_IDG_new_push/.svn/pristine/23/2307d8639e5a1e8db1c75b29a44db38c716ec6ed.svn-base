//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXLeaveApplicationEditViewController.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "Masonry.h"
#import "CXERPAnnexView.h"
#import "CXFormHeaderView.h"
#import "CXBaseRequest.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "CXApprovalPersonModel.h"
#import "NSDate+YYAdd.h"

@interface CXLeaveApplicationEditViewController ()
@property(strong, nonatomic) CXFormHeaderView *topView;
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** < 发送*/
@property(strong, nonatomic) CXEditLabel *sendLabel;
/** < 抄送*/
@property(strong, nonatomic) CXEditLabel *ccLabel;
/** < 开始时间*/
@property(strong, nonatomic) CXEditLabel *startTimeLabel;
/** < 结束时间*/
@property(strong, nonatomic) CXEditLabel *endTimeLabel;
/**< 事由 */
@property(strong, nonatomic) CXEditLabel *reasonLabel;
/**< 说明 */
@property(strong, nonatomic) CXEditLabel *remarkLabel;
@property(weak, nonatomic) CXERPAnnexView *cxerpAnnexView;
@property(strong, nonatomic) CXApprovalListView *approvalListView;
@property(weak, nonatomic) CXApprovalBottomView *approvalBottomView;
@end

@implementation CXLeaveApplicationEditViewController

#pragma mark - get & set

- (CXApprovalListView *)approvalListView {
    if (nil == _approvalListView) {
        _approvalListView = [[CXApprovalListView alloc] init];
    }
    return _approvalListView;
}

- (CXLeaveApplicationModel *)leaveApplicationModel {
    if (nil == _leaveApplicationModel) {
        _leaveApplicationModel = [[CXLeaveApplicationModel alloc] init];
    }
    return _leaveApplicationModel;
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

- (void)approvalEvent {
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc] initWithBid:[NSString stringWithFormat:@"%ld", self.leaveApplicationModel.eid] btype:BusinessType_QJ];
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

- (void)saveLeaveApplicationRequest {
    if (![self.sendLabel.content length]) {
        MAKE_TOAST_V(@"发送人不能为空");
        return;
    }
    if (![self.startTimeLabel.content length]) {
        MAKE_TOAST_V(@"开始时间不能为空");
        return;
    }
    if (![self.endTimeLabel.content length]) {
        MAKE_TOAST_V(@"结束时间不能为空");
        return;
    }

    NSTimeInterval startTimeInterval = [[NSDate dateWithString:self.startTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];

    NSTimeInterval endTimeInterval = [[NSDate dateWithString:self.endTimeLabel.content format:@"yyyy-MM-dd"] timeIntervalSinceNow];

    if (startTimeInterval > endTimeInterval + 1.f) {
        MAKE_TOAST_V(@"开始时间不能大于结束时间");
        return;
    }

    if (![self.reasonLabel.content length]) {
        MAKE_TOAST_V(@"请假事由不能为空");
        return;
    }
    if (![self.remarkLabel.content length]) {
        MAKE_TOAST_V(@"请假说明不能为空");
        return;
    }

    self.leaveApplicationModel.ygId = [VAL_USERID longValue];
    self.leaveApplicationModel.ygDeptId = [VAL_DpId longValue];
    self.leaveApplicationModel.ygDeptName = VAL_DpName;
    self.leaveApplicationModel.ygName = VAL_USERNAME;
    self.leaveApplicationModel.ygJob = VAL_Job;

    NSString *url = [NSString stringWithFormat:@"%@holiday/save", urlPrefix];
    NSMutableDictionary *param = [self.leaveApplicationModel yy_modelToJSONObject];
    if (self.formType == CXFormTypeCreate) {
        param[@"eid"] = nil;
    }

    @weakify(self);
    self.cxerpAnnexView.annexUploadCallBack = ^(NSString *annex) {
        HUD_SHOW(nil);
        
        param[@"annex"] = annex;
        [CXBaseRequest postResultWithUrl:url
                                   param:param
                                 success:^(id responseObj) {
                                     @strongify(self);
                                     CXLeaveApplicationModel *model = [CXLeaveApplicationModel yy_modelWithDictionary:responseObj];
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
                    HUD_HIDE;
                    CXAlert(KNetworkFailRemind);
                }];
    };
    [self.cxerpAnnexView annexUpLoad];
}

- (void)rightItemEvent {
    [self saveLeaveApplicationRequest];
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"请假申请"];

    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];

    if (self.formType == CXFormTypeCreate) {
        [rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
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
        make.top.equalTo([self topView].mas_bottom).offset(5.f);
        make.bottom.equalTo(self.view.mas_centerY).mas_offset(navHigh);
    }];

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
    _sendLabel.title = @"       发 送：";
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
        self.leaveApplicationModel.approvalPerson = tempArr;
    };

    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, _sendLabel.bottom, lineWidth, lineHeight};

    // 抄送
    _ccLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _ccLabel.title = @"       抄 送：";
    _ccLabel.inputType = CXEditLabelInputTypeCC;
    [self.scrollContentView addSubview:_ccLabel];
    _ccLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:editLabel.selectedCCUsers.count];
        CXApprovalPersonModel *approvalPersonModel = nil;
        int idx = 1;
        for (CXUserModel *aModel in editLabel.selectedCCUsers) {
            approvalPersonModel = [[CXApprovalPersonModel alloc] init];
            approvalPersonModel.name = aModel.name;
            approvalPersonModel.eid = aModel.eid;
            approvalPersonModel.imAccount = aModel.imAccount;
            [tempArr addObject:approvalPersonModel];
            ++idx;
        }
        self.leaveApplicationModel.cc = tempArr;
    };

    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = (CGRect) {0.f, _ccLabel.bottom, lineWidth, lineHeight};

    // 请假时间
    _startTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight}];
    _startTimeLabel.title = @"请假时间：";
    _startTimeLabel.inputType = CXEditLabelInputTypeDateAndTime;
    [self.scrollContentView addSubview:_startTimeLabel];
    _startTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.leaveApplicationModel.startTime = editLabel.content;
    };

    // line_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = (CGRect) {0.f, _startTimeLabel.bottom, lineWidth, lineHeight};

    // 时间结束
    _endTimeLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight}];
    _endTimeLabel.title = @"            至：";
    _endTimeLabel.inputType = CXEditLabelInputTypeDateAndTime;
    [self.scrollContentView addSubview:_endTimeLabel];
    _endTimeLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.leaveApplicationModel.endTime = editLabel.content;
    };

    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = (CGRect) {0.f, _endTimeLabel.bottom, lineWidth, lineHeight};

    // 请假事由
    _reasonLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight}];
    _reasonLabel.title = @"请假事由：";
    [self.scrollContentView addSubview:_reasonLabel];
    _reasonLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.leaveApplicationModel.title = editLabel.content;
    };

    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = (CGRect) {0.f, _reasonLabel.bottom, lineWidth, lineHeight};

    // 请假说明
    _remarkLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight}];
    _remarkLabel.title = @"请假说明：";
    _remarkLabel.scale = YES;
    _remarkLabel.numberOfLines = 0;
    [self.scrollContentView addSubview:_remarkLabel];
    _remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.leaveApplicationModel.remark = editLabel.content;
    };

    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _remarkLabel.bottom);
}

- (void)setUpOtherView {
    CXERPAnnexView *erpAnnexView = [[CXERPAnnexView alloc]
            initWithFrame:CGRectMake(0.f, 0.f, Screen_Width, CXERPAnnexView_height)
                     type:CXERPAnnexViewTypePictureAndVoice];
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

- (void)setUpApprovalBottomView {
    // 批阅底部
    CXApprovalBottomView *approvalBottomView = [[CXApprovalBottomView alloc] initWithType:@"holiday" eid:self.leaveApplicationModel.eid];
    self.approvalBottomView = approvalBottomView;
    [self.view addSubview:approvalBottomView];
    [approvalBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXApprovalBottomViewHeight);
    }];
}

- (void)setUpDetail {
    self.startTimeLabel.content = self.leaveApplicationModel.startTime;
    self.endTimeLabel.content = self.leaveApplicationModel.endTime;
    self.reasonLabel.content = self.leaveApplicationModel.title;
    self.remarkLabel.content = self.leaveApplicationModel.remark;
    self.cxerpAnnexView.detailAnnexDataArray = self.leaveApplicationModel.annexList;

    self.sendLabel.allowEditing = NO;
    self.sendLabel.showDropdown = NO;
    self.ccLabel.allowEditing = NO;
    self.ccLabel.allowEditing = NO;

    self.topView.avatar = self.leaveApplicationModel.icon;
    self.topView.name = self.leaveApplicationModel.ygName;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@", self.leaveApplicationModel.ygDeptName, self.leaveApplicationModel.ygJob];
    self.topView.date = self.leaveApplicationModel.createTime;
    self.topView.number = self.leaveApplicationModel.serNo;

    if ([self.leaveApplicationModel.approvalPerson count] == 1) {
        self.sendLabel.content = [[self.leaveApplicationModel.approvalPerson firstObject] name];
    } else if ((int) [self.leaveApplicationModel.approvalPerson count] > 1) {
        NSMutableString *content = [[NSMutableString alloc] init];
        for (CXApprovalPersonModel *approvalPersonModel in self.leaveApplicationModel.approvalPerson) {
            [content appendString:[NSString stringWithFormat:@"、%@", approvalPersonModel.name]];
        }
        self.sendLabel.content = [content substringFromIndex:1];
    }

    if ([self.leaveApplicationModel.cc count]) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:self.leaveApplicationModel.cc.count];
        CXUserModel *userModel = nil;
        for (CXUserModel *model in self.leaveApplicationModel.cc) {
            userModel = [[CXUserModel alloc] init];
            userModel.eid = model.userId;
            userModel.name = model.userName;
            [tempArr addObject:userModel];
        }
        self.ccLabel.detailCCData = tempArr;
    }

    if (CXApprovalStatusInInvalid == self.leaveApplicationModel.approvalSta &&
            self.leaveApplicationModel.ygId == [VAL_USERID longValue]) {
        [[self getRootTopView] setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    } else {
        self.startTimeLabel.allowEditing = NO;
        self.endTimeLabel.allowEditing = NO;
        self.reasonLabel.allowEditing = NO;
        self.remarkLabel.allowEditing = NO;
    }

    if (self.leaveApplicationModel.approvalUserId == [VAL_USERID longValue]) {
        if (self.leaveApplicationModel.approvalSta != CXApprovalStatusFinished) {
            [[self getRootTopView] setUpRightBarItemTitle:@"批阅" addTarget:self action:@selector(approvalEvent)];
            self.startTimeLabel.allowEditing = NO;
            self.endTimeLabel.allowEditing = NO;
            self.reasonLabel.allowEditing = NO;
            self.remarkLabel.allowEditing = NO;
        } else {
            if (self.leaveApplicationModel.ygId != [VAL_USERID longValue]) {
                [[self getRootTopView] removeRightBarItem];
            }
        }
    } else {
        if (self.leaveApplicationModel.ygId != [VAL_USERID longValue]) {
            [[self getRootTopView] removeRightBarItem];
        }
    }

    if (self.leaveApplicationModel.ygId == [VAL_USERID longValue] &&
            self.leaveApplicationModel.approvalSta != CXApprovalStatusFinished) {
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

    [self.approvalListView setBid:[NSString stringWithFormat:@"%ld", self.leaveApplicationModel.eid] bType:BusinessType_QJ];
}


- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@holiday/detail/%ld", urlPrefix, self.leaveApplicationModel.eid];

    HUD_SHOW(nil);
    
    @weakify(self);
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                @strongify(self);
                                CXLeaveApplicationModel *model = [CXLeaveApplicationModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    self.leaveApplicationModel = [CXLeaveApplicationModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.holiday"]];
                                    self.leaveApplicationModel.annexList = [responseObj valueForKeyPath:@"data.annexList"];
                                    self.leaveApplicationModel.cc = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:[responseObj valueForKeyPath:@"data.ccList"]];

                                    [self setUpDetail];
                                } else {
                                    MAKE_TOAST(model.msg);
                                }

                                HUD_HIDE;
                            } failure:^(NSError *error) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
