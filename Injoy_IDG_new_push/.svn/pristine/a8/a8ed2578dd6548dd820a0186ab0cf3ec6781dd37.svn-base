//
//  CXIDGBasicInformationViewController.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGBasicInformationViewController.h"
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
#import "CXIDGBasicInformationModel.h"
#import "UIView+CXCategory.h"
#import "CXIDGBasicInfoView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXIDGBasicInformationViewController ()

#define kLabelLeftSpace 16.0
#define kLabelTopSpace 16.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kBusinessLabelFontSize 14.0
#define kBusinessLabelTextColor RGBACOLOR(119.0, 119.0, 119.0, 1.0)


/** topView */
@property(strong, nonatomic) CXFormHeaderView *topView;
/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** basicInformationModel */
@property(strong, nonatomic) CXIDGBasicInformationModel * basicInformationModel;
/** 立项日期 */
@property(strong, nonatomic) CXEditLabel *lxrqLabel;
/** 投资阶段 */
@property(strong, nonatomic) CXEditLabel *tzjdLabel;
/** 城市 */
@property(strong, nonatomic) CXEditLabel *csLabel;
/** 项目负责人 */
@property(strong, nonatomic) CXEditLabel *xmfzrLabel;
/** 行业 */
@property(strong, nonatomic) CXEditLabel *hyLabel;
/** 小组成员 */
@property(strong, nonatomic) CXEditLabel *xzcyLabel;
/** 行业小组 */
@property(strong, nonatomic) CXEditLabel *hyxzLabel;
/** 企业阶段 */
@property(strong, nonatomic) CXEditLabel *qyjdLabel;
/** 项目律师 */
@property(strong, nonatomic) CXEditLabel *xmlsLabel;
/** 融资轮次 */
@property(strong, nonatomic) CXEditLabel *rzlcLabel;
/** 尽调负责人 */
@property(strong, nonatomic) CXEditLabel *jdfzrLabel;
/** 来源渠道 */
@property(strong, nonatomic) CXEditLabel *lyqdLabel;
/** 来源人 */
@property(strong, nonatomic) CXEditLabel *lyrLabel;
/** contributor */
@property(strong, nonatomic) CXEditLabel *contributorsLabel;
/** redView */
@property (nonatomic, strong) UIView * redView;
/** opinionTypeNameLabel */
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
/** businessLabel */
@property (nonatomic, strong) UILabel * businessLabel;

@property (nonatomic, strong) CXIDGBasicInfoView *infoView;
@end

@implementation CXIDGBasicInformationViewController

#pragma mark - get & set

#define kTextColor [UIColor blackColor]

- (CXIDGBasicInformationModel *)basicInformationModel{
    if(!_basicInformationModel){
        _basicInformationModel = [[CXIDGBasicInformationModel alloc] init];
    }
    return _basicInformationModel;
}

- (CXIDGProjectManagementListModel *)model {
    if (!_model) {
        _model = [[CXIDGProjectManagementListModel alloc] init];
    }
    return _model;
}
- (CXIDGBasicInfoView *)infoView{
    if(nil == _infoView){
        _infoView = [[CXIDGBasicInfoView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, CGRectGetHeight(self.view.frame))];
    }
    return _infoView;
}
- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = RGBACOLOR(240.0, 239.0, 244.0, 1.0);
        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollContentView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height - navHigh - 50.f - 10.0);
    //[self setUpScrollView];
    [self findDetailRequest];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUpUI
- (void)setUpScrollView {
    _scrollContentView.backgroundColor = [UIColor whiteColor];
    /// 左边距
    CGFloat leftMargin = 16.f;
    /// 行高
    CGFloat viewHeight = 45.f;
    CGFloat lineHeight = 1.f;
    CGFloat lineBoldHeight = 10.f;
    CGFloat lineWidth = Screen_Width;
    /// 宽度
    CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;
    
    
    //立项日期
    _lxrqLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, 0.f, Screen_Width - leftMargin, viewHeight)];
    _lxrqLabel.title = @"立项日期：";
    _lxrqLabel.allowEditing = NO;
    _lxrqLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _lxrqLabel.textColor = kTextColor;
    _lxrqLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_lxrqLabel];
    
    // line_1
    UIView *line_1 = [self createFormSeperatorLine];
    line_1.frame = CGRectMake(0.f, _lxrqLabel.bottom, lineWidth, lineHeight);
    
    //投资阶段
    _tzjdLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
    _tzjdLabel.title = @"投资阶段：";
    _tzjdLabel.textColor = kTextColor;
    _tzjdLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _tzjdLabel.allowEditing = NO;
    _tzjdLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_tzjdLabel];
    
    // line_2
    UIView *line_2 = [self createFormSeperatorLine];
    line_2.frame = CGRectMake(0.f, _tzjdLabel.bottom, lineWidth, lineHeight);
    
    //城市
    _csLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
    _csLabel.title = @"城 市：";
    _csLabel.textColor = kTextColor;
    _csLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _csLabel.allowEditing = NO;
    _csLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_csLabel];
    
    // line_3
    UIView *line_3 = [self createFormSeperatorLine];
    line_3.frame = CGRectMake(0.f, _csLabel.bottom, lineWidth, lineHeight);
    
    //项目负责人
    _xmfzrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
    _xmfzrLabel.title = @"项目负责人：";
    _xmfzrLabel.textColor = kTextColor;
    _xmfzrLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _xmfzrLabel.allowEditing = NO;
    _xmfzrLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_xmfzrLabel];
    
    // line_4
    UIView *line_4 = [self createFormSeperatorLine];
    line_4.frame = CGRectMake(0.f, _xmfzrLabel.bottom, lineWidth, lineHeight);
    
    //行业
    _hyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
    _hyLabel.title = @"行 业：";
    _hyLabel.textColor = kTextColor;
    _hyLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _hyLabel.allowEditing = NO;
    _hyLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_hyLabel];
    
    // line_5
    UIView *line_5 = [self createFormSeperatorLine];
    line_5.frame = CGRectMake(0.f, _hyLabel.bottom, lineWidth, lineHeight);
    
    //小组成员
    _xzcyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
    _xzcyLabel.title = @"小组成员：";
    _xzcyLabel.textColor = kTextColor;
    _xzcyLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _xzcyLabel.allowEditing = NO;
    _xzcyLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_xzcyLabel];
    
    // line_6
    UIView *line_6 = [self createFormSeperatorLine];
    line_6.frame = CGRectMake(0.f, _xzcyLabel.bottom, lineWidth, lineHeight);
    
    //行业小组
    _hyxzLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
    _hyxzLabel.title = @"行业小组：";
    _hyxzLabel.textColor = kTextColor;
    _hyxzLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _hyxzLabel.allowEditing = NO;
    _hyxzLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_hyxzLabel];
    
    // line_7
    UIView *line_7 = [self createFormSeperatorLine];
    line_7.frame = CGRectMake(0.f, _hyxzLabel.bottom, lineWidth, lineHeight);
    
    //企业阶段
    _qyjdLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_7.bottom, Screen_Width - leftMargin, viewHeight)];
    _qyjdLabel.title = @"企业阶段：";
    _qyjdLabel.textColor = kTextColor;
    _qyjdLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _qyjdLabel.allowEditing = NO;
    _qyjdLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_qyjdLabel];
    
    // line_8
    UIView *line_8 = [self createFormSeperatorLine];
    line_8.frame = CGRectMake(0.f, _qyjdLabel.bottom, lineWidth, lineHeight);
    
    //项目律师
    _xmlsLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - leftMargin, viewHeight)];
    _xmlsLabel.title = @"项目律师：";
    _xmlsLabel.textColor = kTextColor;
    _xmlsLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _xmlsLabel.allowEditing = NO;
    _xmlsLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_xmlsLabel];
    
    // line_9
    UIView *line_9 = [self createFormSeperatorLine];
    line_9.frame = CGRectMake(0.f, _xmlsLabel.bottom, lineWidth, lineHeight);
    
    //融资轮次
    _rzlcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_9.bottom, Screen_Width - leftMargin, viewHeight)];
    _rzlcLabel.title = @"融资轮次：";
    _rzlcLabel.textColor = kTextColor;
    _rzlcLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _rzlcLabel.allowEditing = NO;
    _rzlcLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_rzlcLabel];
    
    // line_10
    UIView *line_10 = [self createFormSeperatorLine];
    line_10.frame = CGRectMake(0.f, _rzlcLabel.bottom, lineWidth, lineHeight);
    
    //尽调负责人
    _jdfzrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_10.bottom, Screen_Width - leftMargin, viewHeight)];
    _jdfzrLabel.title = @"尽调负责人：";
    _jdfzrLabel.textColor = kTextColor;
    _jdfzrLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _jdfzrLabel.allowEditing = NO;
    _jdfzrLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_jdfzrLabel];
    
    // line_11
    UIView *line_11 = [self createFormSeperatorLine];
    line_11.frame = CGRectMake(0.f, _jdfzrLabel.bottom, lineWidth, lineHeight);
    
    //来源渠道
    _lyqdLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_11.bottom, Screen_Width - leftMargin, viewHeight)];
    _lyqdLabel.title = @"来源渠道：";
    _lyqdLabel.textColor = kTextColor;
    _lyqdLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _lyqdLabel.allowEditing = NO;
    _lyqdLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_lyqdLabel];
    
    // line_12
    UIView *line_12 = [self createFormSeperatorLine];
    line_12.frame = CGRectMake(0.f, _lyqdLabel.bottom, lineWidth, lineHeight);
    
    //来源人
    _lyrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_12.bottom, Screen_Width - leftMargin, viewHeight)];
    _lyrLabel.title = @"来源人：";
    _lyrLabel.textColor = kTextColor;
    _lyrLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _lyrLabel.allowEditing = NO;
    _lyrLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_lyrLabel];
    
    // line_13
    UIView *line_13 = [self createFormSeperatorLine];
    line_13.frame = CGRectMake(0.f, _lyrLabel.bottom, lineWidth, lineHeight);
    
    //contributorsLabel
    _contributorsLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_13.bottom, Screen_Width - leftMargin, viewHeight)];
    _contributorsLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _contributorsLabel.title = @"contributer：";
    _contributorsLabel.textColor = kTextColor;
    _contributorsLabel.allowEditing = NO;
    _contributorsLabel.inputType = CXEditLabelInputTypeText;
    [self.scrollContentView addSubview:_contributorsLabel];
    
    // line_14
    UIView *line_14 = [self createFormSeperatorLine];
    line_14.frame = CGRectMake(0.f, _contributorsLabel.bottom, lineWidth, lineBoldHeight);
    
    _opinionTypeNameLabel = [[UILabel alloc] init];
    _opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    _opinionTypeNameLabel.textColor = kOpinionTypeNameLabelTextColor;
    _opinionTypeNameLabel.numberOfLines = 0;
    _opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _opinionTypeNameLabel.backgroundColor = [UIColor clearColor];
    _opinionTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    _opinionTypeNameLabel.text = @"业务介绍";
    CGSize opinionTypeNameLabelSize = [_opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _opinionTypeNameLabel.frame = CGRectMake(leftMargin, line_14.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, opinionTypeNameLabelSize.height);
    [self.scrollContentView addSubview:_opinionTypeNameLabel];
    
    _businessLabel = [[UILabel alloc] init];
    _businessLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _businessLabel.textColor = kOpinionTypeNameLabelTextColor;
    _businessLabel.numberOfLines = 0;
    _businessLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _businessLabel.backgroundColor = [UIColor clearColor];
    _businessLabel.textAlignment = NSTextAlignmentLeft;
    CGSize businessLabelSize = [_businessLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _businessLabel.frame = CGRectMake(leftMargin, _opinionTypeNameLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, businessLabelSize.height);
    [self.scrollContentView addSubview:_businessLabel];
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _businessLabel.bottom + kLabelTopSpace);
}

/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)setUpDetail {
    _lxrqLabel.content = self.basicInformationModel.inDate;
    _tzjdLabel.content = self.basicInformationModel.projStageName;
    _csLabel.content = self.basicInformationModel.city;
    _xmfzrLabel.content = self.basicInformationModel.projManagerName;
    _hyLabel.content = self.basicInformationModel.induName;
    NSMutableString *content = [[NSMutableString alloc] init];
    if (self.basicInformationModel.teamNameArray.count == 1) {
        [content appendString:self.basicInformationModel.teamNameArray.firstObject];
        self.xzcyLabel.content = content;
    } else if (self.basicInformationModel.teamNameArray.count > 1) {
        for(NSString * name in self.basicInformationModel.teamNameArray){
            [content appendString:[NSString stringWithFormat:@"、%@",name]];
        }
        self.xzcyLabel.content = [content substringFromIndex:1];
    }
    _hyxzLabel.content = self.basicInformationModel.projGroupName;
    _qyjdLabel.content = self.basicInformationModel.comPhaseName;
    _xmlsLabel.content = self.basicInformationModel.projLawyerName;
    _rzlcLabel.content = self.basicInformationModel.invRoundName;
    _jdfzrLabel.content = self.basicInformationModel.projDDManagerName;
    _lyqdLabel.content = self.basicInformationModel.projSourName;
    _lyrLabel.content = self.basicInformationModel.projSourPer;
    NSMutableString *contributors = [[NSMutableString alloc] init];
    if (self.basicInformationModel.contributorsArray && [self.basicInformationModel.contributorsArray isKindOfClass:[NSArray class]] && self.basicInformationModel.contributorsArray.count == 1) {
        [contributors appendString:self.basicInformationModel.contributorsArray.firstObject];
        self.contributorsLabel.content = contributors;
    } else if (self.basicInformationModel.contributorsArray && [self.basicInformationModel.contributorsArray isKindOfClass:[NSArray class]] && self.basicInformationModel.contributorsArray.count > 1) {
        for(NSString * name in self.basicInformationModel.contributorsArray){
            [contributors appendString:[NSString stringWithFormat:@"、%@",name]];
        }
        self.contributorsLabel.content = [contributors substringFromIndex:1];
    }
    _businessLabel.text = self.basicInformationModel.business;
    
    /// 左边距
    CGFloat leftMargin = 16.f;
    CGSize businessLabelSize = [_businessLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _businessLabel.frame = CGRectMake(leftMargin, _opinionTypeNameLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, businessLabelSize.height);
    [self.scrollContentView addSubview:_businessLabel];
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _businessLabel.bottom + kLabelTopSpace);
}

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/detail/base/%zd", urlPrefix,[self.model.projId integerValue]];
    HUD_SHOW(nil);
    
//    [MBProgressHUD showHUDForView:self.view text:HUDMessage];//添加loading
    
    [HttpTool postWithPath:url params:nil success:^(id JSON) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            self.basicInformationModel = [CXIDGBasicInformationModel yy_modelWithDictionary:JSON[@"data"]];
            self.basicInformationModel.teamNameArray = JSON[@"data"][@"teamName"];
            self.basicInformationModel.contributorsArray = JSON[@"data"][@"contributors"];
           // [self setUpDetail];
            
            self.infoView.model = self.basicInformationModel;
            [self.view addSubview:self.infoView];
        }
        else if ([JSON[@"status"] intValue] == 400) {//
            [self.scrollContentView setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];//隐藏loading

        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
