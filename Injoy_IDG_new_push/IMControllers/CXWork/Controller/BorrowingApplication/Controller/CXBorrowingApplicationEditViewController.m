//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXBorrowingApplicationEditViewController.h"
#import "CXFormHeaderView.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "CXOAMoneyView.h"
#import "CXTextView.h"
#import "CXMoneyView.h"
#import "CXBaseRequest.h"
#import "CXApprovalPersonModel.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "NSString+TextHelper.h"

@interface CXBorrowingApplicationEditViewController ()
        <
        CXOAMoneyViewDelegate,
        CXTextViewDelegate
        >
@property(strong, nonatomic) CXFormHeaderView *topView;
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** < 发送 */
@property(strong, nonatomic) CXEditLabel *sendLabel;
/**< 事由 */
@property(strong, nonatomic) CXEditLabel *reasonLabel;
/**< 说明 */
@property(strong, nonatomic) CXEditLabel *remarkLabel;
@property(weak, nonatomic) CXERPAnnexView *cxerpAnnexView;
@property(weak, nonatomic) CXOAMoneyView *oaMoneyView;
@property(weak, nonatomic) CXMoneyView *moneyView;
@property(strong, nonatomic) CXApprovalListView *approvalListView;
@property(weak, nonatomic) CXApprovalBottomView *approvalBottomView;
@end

@implementation CXBorrowingApplicationEditViewController

#pragma mark - get & set

- (CXApprovalListView *)approvalListView {
    if (nil == _approvalListView) {
        _approvalListView = [[CXApprovalListView alloc] init];
    }
    return _approvalListView;
}

- (CXBorrowingApplicationModel *)borrowingApplicationModel {
    if (nil == _borrowingApplicationModel) {
        _borrowingApplicationModel = [[CXBorrowingApplicationModel alloc] init];
    }
    return _borrowingApplicationModel;
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

/// 提交
- (void)saveRequest {
    if (![self.sendLabel.content length]) {
        MAKE_TOAST_V(@"发送不能为空");
        return;
    }
    if (![self.reasonLabel.content length]) {
        MAKE_TOAST_V(@"借支事由不能为空");
        return;
    }
    if (![self.remarkLabel.content length]) {
        MAKE_TOAST_V(@"借支说明不能为空");
        return;
    }
    if (!self.oaMoneyView.monney) {
        MAKE_TOAST_V(@"金额(小写)不能为空");
        return;
    }
    if (![self.oaMoneyView.currency.content length]) {
        MAKE_TOAST_V(@"币种不能为空");
        return;
    }
    if (![self.moneyView.bigMoneyVal length]) {
        MAKE_TOAST_V(@"金额(大写)不能为空");
        return;
    }

    self.borrowingApplicationModel.ygId = [VAL_USERID longValue];
    self.borrowingApplicationModel.ygDeptId = [VAL_DpId longValue];
    self.borrowingApplicationModel.ygDeptName = VAL_DpName;
    self.borrowingApplicationModel.ygName = VAL_USERNAME;
    self.borrowingApplicationModel.ygJob = VAL_Job;

    self.borrowingApplicationModel.money = self.oaMoneyView.monney;
    self.borrowingApplicationModel.bigMoney = self.moneyView.bigMoneyVal;
    self.borrowingApplicationModel.currencyValue = self.oaMoneyView.currency.selectedPickerData[CXEditLabelCustomPickerValueKey];

    NSString *url = [NSString stringWithFormat:@"%@loan/save", urlPrefix];

    NSMutableDictionary *param = [self.borrowingApplicationModel yy_modelToJSONObject];
    if (self.formType == CXFormTypeCreate) {
        param[@"eid"] = nil;
    }

    @weakify(self);
    self.cxerpAnnexView.annexUploadCallBack = ^(NSString *annex) {
        param[@"annex"] = annex;
        HUD_SHOW(nil);
        
        [CXBaseRequest postResultWithUrl:url
                                   param:param
                                 success:^(id responseObj) {
                                     @strongify(self);
                                     CXBorrowingApplicationModel *model = [CXBorrowingApplicationModel yy_modelWithDictionary:responseObj];
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
    if (self.formType == CXFormTypeCreate) {
        [self saveRequest];
    } else if (self.formType == CXFormTypeModify) {
        [self saveRequest];
    }
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"借支申请"];

    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];

    if (self.formType == CXFormTypeCreate) {
        [rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    }
}

- (void)setUpScrollView {
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).mas_offset(navHigh);
        make.top.equalTo([self topView].mas_bottom).offset(5.f);
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
        self.borrowingApplicationModel.approvalPerson = tempArr;
    };

    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, _sendLabel.bottom, lineWidth, lineHeight};

    // 借支事由
    _reasonLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight}];
    _reasonLabel.title = @"借支事由：";
    [self.scrollContentView addSubview:_reasonLabel];
    _reasonLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.borrowingApplicationModel.title = editLabel.content;
    };

    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = (CGRect) {0.f, _reasonLabel.bottom, lineWidth, lineHeight};

    // 借支说明
    _remarkLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight}];
    _remarkLabel.title = @"借支说明：";
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.scale = YES;
    [self.scrollContentView addSubview:_remarkLabel];
    _remarkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.borrowingApplicationModel.remark = editLabel.content;
    };

    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _remarkLabel.bottom);
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
        make.top.equalTo(self.scrollContentView.mas_bottom);
        make.height.mas_equalTo(CXERPAnnexView_height);
    }];

    // 金钱视图
    CXOAMoneyView *oaMoneyView = [[CXOAMoneyView alloc] initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXERPAnnexView_height}];
    oaMoneyView.delegate = self;
    [self.view addSubview:oaMoneyView];
    self.oaMoneyView = oaMoneyView;
    oaMoneyView.currency.content = @"人民币";
    oaMoneyView.currency.selectedPickerData = @{CXEditLabelCustomPickerTextKey: @"人民币", CXEditLabelCustomPickerValueKey: @"CNY"};

    [oaMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.cxerpAnnexView.mas_bottom);
        make.height.mas_equalTo(CXERPAnnexView_height);
    }];

    // 大写金额视图
    CXMoneyView *moneyView = [[CXMoneyView alloc] init];
    self.moneyView = moneyView;
    [self.view addSubview:moneyView];
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.oaMoneyView.mas_bottom).offset(1.f);
        make.height.mas_equalTo(CXERPAnnexView_height);
    }];

    // 批阅视图
    [self.view addSubview:self.approvalListView];
    [self.approvalListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(moneyView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-CXApprovalBottomViewHeight - kTabbarSafeBottomMargin);
    }];
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

- (void)setUpApprovalBottomView {
    // 批阅底部
    CXApprovalBottomView *approvalBottomView = [[CXApprovalBottomView alloc] initWithType:@"loan" eid:self.borrowingApplicationModel.eid];
    self.approvalBottomView = approvalBottomView;
    [self.view addSubview:approvalBottomView];
    [approvalBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.height.mas_equalTo(CXApprovalBottomViewHeight);
    }];
}

- (void)approvalEvent {
    CXApprovalAlertView *approvalAlertView = [[CXApprovalAlertView alloc] initWithBid:[NSString stringWithFormat:@"%ld", self.borrowingApplicationModel.eid] btype:BusinessType_JK];
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

- (void)setUpDetail {
    self.sendLabel.allowEditing = NO;
    self.sendLabel.showDropdown = NO;
    self.reasonLabel.content = self.borrowingApplicationModel.title;
    self.remarkLabel.content = self.borrowingApplicationModel.remark;
    self.oaMoneyView.monney = self.borrowingApplicationModel.money;
    self.oaMoneyView.currency.content = self.borrowingApplicationModel.currencyValue;

    self.cxerpAnnexView.detailAnnexDataArray = [self.borrowingApplicationModel.annexList mutableCopy];
    [self.moneyView setMoney:self.borrowingApplicationModel.bigMoney];

    self.topView.avatar = self.borrowingApplicationModel.icon;
    self.topView.name = self.borrowingApplicationModel.ygName;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@", self.borrowingApplicationModel.ygDeptName, self.borrowingApplicationModel.ygJob];
    self.topView.date = self.borrowingApplicationModel.createTime;
    self.topView.number = self.borrowingApplicationModel.serNo;

    if ([self.borrowingApplicationModel.approvalPerson count] == 1) {
        self.sendLabel.content = [[self.borrowingApplicationModel.approvalPerson firstObject] name];
    } else if ((int) [self.borrowingApplicationModel.approvalPerson count] > 1) {
        NSMutableString *content = [[NSMutableString alloc] init];
        for (CXApprovalPersonModel *approvalPersonModel in self.borrowingApplicationModel.approvalPerson) {
            [content appendString:[NSString stringWithFormat:@"、%@", approvalPersonModel.name]];
        }
        self.sendLabel.content = [content substringFromIndex:1];
    }

    if (CXApprovalStatusInInvalid == self.borrowingApplicationModel.approvalSta &&
            self.borrowingApplicationModel.ygId == [VAL_USERID longValue]) {
        [[self getRootTopView] setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    } else {
        self.reasonLabel.allowEditing = NO;
        self.remarkLabel.allowEditing = NO;
        [self.oaMoneyView setViewEditOrNot:NO];
    }

    if (self.borrowingApplicationModel.approvalUserId == [VAL_USERID longValue]) {
        if (self.borrowingApplicationModel.approvalSta != CXApprovalStatusFinished) {
            [[self getRootTopView] setUpRightBarItemTitle:@"批阅" addTarget:self action:@selector(approvalEvent)];
            self.reasonLabel.allowEditing = NO;
            self.remarkLabel.allowEditing = NO;
            [self.oaMoneyView setViewEditOrNot:NO];
        } else {
            if (self.borrowingApplicationModel.ygId != [VAL_USERID longValue]) {
                [[self getRootTopView] removeRightBarItem];
            }
        }
    } else {
        if (self.borrowingApplicationModel.ygId != [VAL_USERID longValue]) {
            [[self getRootTopView] removeRightBarItem];
        }
    }


    if (self.borrowingApplicationModel.ygId == [VAL_USERID longValue] &&
            self.borrowingApplicationModel.approvalSta != CXApprovalStatusFinished) {
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

    [self.approvalListView setBid:[NSString stringWithFormat:@"%ld", self.borrowingApplicationModel.eid] bType:BusinessType_JK];
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@loan/detail/%ld", urlPrefix, self.borrowingApplicationModel.eid];

    @weakify(self);

    HUD_SHOW(nil);
    
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                @strongify(self);
                                CXBorrowingApplicationModel *model = [CXBorrowingApplicationModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    self.borrowingApplicationModel = [CXBorrowingApplicationModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.loan"]];
                                    self.borrowingApplicationModel.annexList = [responseObj valueForKeyPath:@"data.annexList"];
                                    [self setUpDetail];
                                }
                                HUD_HIDE;
                            } failure:^(NSError *error) {
                HUD_HIDE;
                CXAlert(KNetworkFailRemind);
            }];
}

#pragma mark - CXTextViewDelegate

///用户输入的文本 按发送调用
- (void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text {
    self.oaMoneyView.monney = [text doubleValue];
    self.borrowingApplicationModel.money = self.oaMoneyView.monney;
    [self.moneyView setMoney:[NSString digitUppercaseWithMoney:text]];
}

#pragma mark - CXOAMoneyViewDelegate

- (void)selectedMoneyView:(CXOAMoneyView *)moneyView {
    CXTextView *textView = [[CXTextView alloc] initWithKeyboardType:UIKeyboardTypeDecimalPad];//需要文本输入的创建(默认键盘)
    textView.delegate = (id) self; //设置代理
    textView.isMoneyView = YES;
    if (moneyView.monney) {
        textView.textString = [NSString stringWithFormat:@"%.2f", moneyView.monney];
    }

    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:textView]; // 添加
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
