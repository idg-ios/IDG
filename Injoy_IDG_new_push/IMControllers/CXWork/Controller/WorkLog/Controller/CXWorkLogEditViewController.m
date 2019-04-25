//
// Created by ^ on 2017/10/20.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXWorkLogEditViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "CXBottomShareView.h"
#import "CXFormHeaderView.h"
#import "CXBaseRequest.h"
#import "YYCategories.h"

@interface CXWorkLogEditViewController ()
@property(strong, nonatomic) UIScrollView *scrollContentView;
@property(strong, nonatomic) CXFormHeaderView *topView;
/**<日志标题 */
@property(strong, nonatomic) CXEditLabel *titleLabel;
/**<日志内容 */
@property(strong, nonatomic) CXEditLabel *contentLabel;
@property(weak, nonatomic) CXBottomShareView *bottomShareView;
@property(weak, nonatomic) CXERPAnnexView *annexView;
@end

@implementation CXWorkLogEditViewController

#pragma mark - get & set

- (CXWorkLogModel *)workLogModel {
    if (nil == _workLogModel) {
        _workLogModel = [[CXWorkLogModel alloc] init];
    }
    return _workLogModel;
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

- (void)saveWorkLogRequest {
    if (![self.titleLabel.content length]) {
        MAKE_TOAST_V(@"日志标题不能为空");
        return;
    }
    if (![self.contentLabel.content length]) {
        MAKE_TOAST_V(@"日志内容不能为空");
        return;
    }

    self.workLogModel.ygId = [VAL_USERID longValue];
    self.workLogModel.ygDeptId = [VAL_DpId longValue];
    self.workLogModel.ygDeptName = VAL_DpName;
    self.workLogModel.ygName = VAL_USERNAME;
    self.workLogModel.ygJob = VAL_Job;

    NSString *url = [NSString stringWithFormat:@"%@workLog/save", urlPrefix];
    NSMutableDictionary *param = [self.workLogModel yy_modelToJSONObject];
    param[@"cc"] = [self.bottomShareView getValue];

    if (self.formType == CXFormTypeCreate) {
        param[@"eid"] = nil;
    }

    self.annexView.annexUploadCallBack = ^(NSString *annex) {
        param[@"annex"] = annex;
        HUD_SHOW(nil);
        [CXBaseRequest postResultWithUrl:url
                                   param:param
                                 success:^(id responseObj) {
                                     CXWorkLogModel *model = [CXWorkLogModel yy_modelWithDictionary:responseObj];
                                     if (HTTPSUCCESSOK == model.status) {
                                         CXAlertExt(@"提交成功", ^{
                                             if (self.callBack) {
                                                 self.callBack();
                                             }
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

    [self.annexView annexUpLoad];
}

- (void)rightItemEvent {
    if (self.formType == CXFormTypeCreate) {
        [self saveWorkLogRequest];
    } else if (self.formType == CXFormTypeModify) {
        [self saveWorkLogRequest];
    }
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"我的日志"];

    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    [rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
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
        make.bottom.equalTo(self.view.mas_centerY).offset(navHigh);
    }];

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

    // 日志标题
    _titleLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, 0.f, Screen_Width - leftMargin, viewHeight}];
    _titleLabel.title = @"日志标题：";
    [self.scrollContentView addSubview:_titleLabel];
    _titleLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.workLogModel.title = editLabel.content;
    };

    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = (CGRect) {0.f, _titleLabel.bottom, lineWidth, lineHeight};

    // 日志内容
    _contentLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight}];
    _contentLabel.title = @"日志内容：";
    _contentLabel.scale = YES;
    [self.scrollContentView addSubview:_contentLabel];
    _contentLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
        @strongify(self);
        self.workLogModel.remark = editLabel.content;
    };

    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _contentLabel.bottom);
}

/**
 * 设置附件 分享
 */
- (void)setUpOtherView {
    // 附件
    CXERPAnnexView *annexView = [[CXERPAnnexView alloc] initWithFrame:CGRectMake(0.f, self.view.centerY + navHigh, Screen_Width, CXERPAnnexView_height) type:CXERPAnnexViewTypePictureAndVoice];
    annexView.backgroundColor = [UIColor whiteColor];
    annexView.vc = self.navigationController;
    [self.view addSubview:annexView];
    self.annexView = annexView;

    CGFloat space = 20.f;

    CXBottomShareView *bottomShareView = [[CXBottomShareView alloc] init];
    [self.view addSubview:bottomShareView];
    self.bottomShareView = bottomShareView;
    [bottomShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(annexView.mas_bottom).offset(space);
        make.height.mas_equalTo(CXBottomShareViewHeight);
    }];
}

/**表单的分割线*/
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kTableViewLineColor;
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)setUpDetail {
    self.titleLabel.content = self.workLogModel.title;
    self.contentLabel.content = self.workLogModel.remark;

    self.topView.avatar = self.workLogModel.icon;
    self.topView.name = self.workLogModel.ygName;
    self.topView.dept = [NSString stringWithFormat:@"%@ %@", self.workLogModel.ygDeptName, self.workLogModel.ygJob];
    self.topView.date = self.workLogModel.createTime;
    self.topView.number = self.workLogModel.serNo;

    self.annexView.detailAnnexDataArray = [self.workLogModel.annexList mutableCopy];

    if ([self.workLogModel.cc count]) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:self.workLogModel.cc.count];
        CXUserModel *userModel = nil;
        for (CXUserModel *model in self.workLogModel.cc) {
            userModel = [[CXUserModel alloc] init];
            userModel.eid = model.userId;
            userModel.name = model.userName;
            [tempArr addObject:userModel];
        }
        [self.bottomShareView setCC:tempArr];
    }

    if (self.workLogModel.ygId == [VAL_USERID longValue]) {
        [[self getRootTopView] setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(rightItemEvent)];
    } else {
        [[self getRootTopView] removeRightBarItem];
    }
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@workLog/detail/%ld", urlPrefix, self.workLogModel.eid];

    @weakify(self);

    HUD_SHOW(nil);
    [CXBaseRequest getResultWithUrl:url
                              param:nil
                            success:^(id responseObj) {
                                @strongify(self);
                                CXWorkLogModel *model = [CXWorkLogModel yy_modelWithDictionary:responseObj];
                                if (HTTPSUCCESSOK == model.status) {
                                    self.workLogModel = [CXWorkLogModel yy_modelWithDictionary:[responseObj valueForKeyPath:@"data.workLog"]];
                                    self.workLogModel.annexList = [responseObj valueForKeyPath:@"data.annexList"];
                                    self.workLogModel.cc = [NSArray yy_modelArrayWithClass:[CXUserModel class] json:[responseObj valueForKeyPath:@"data.ccList"]];

                                    [self setUpDetail];
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
