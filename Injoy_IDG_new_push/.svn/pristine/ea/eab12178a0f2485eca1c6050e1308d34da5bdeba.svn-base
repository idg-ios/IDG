//
//  CXAddPEPotentialProjectViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAddPEPotentialProjectViewController.h"
#import "Masonry.h"
#import "CXEditLabel.h"
#import "UIView+YYAdd.h"
#import "CXERPAnnexView.h"
#import "HttpTool.h"
#import "CXApprovalListView.h"
#import "CXApprovalBottomView.h"
#import "CXApprovalAlertView.h"
#import "CXApprovalPersonModel.h"
#import "CXTMTPotentialProjectDetailModel.h"
#import "UIView+CXCategory.h"
#import "CXLabelTextView.h"
#import "CXMetProjectDetailViewController.h"
#import "CXAddPEPotialProjectView.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXAddPEPotentialProjectViewController ()<CXLabelTextViewDelegate>

#define kLabelLeftSpace 10.0
#define kLabelTopSpace 10.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kBusinessLabelFontSize 16.0
#define kBusinessLabelTextColor RGBACOLOR(119.0, 119.0, 119.0, 1.0)

/** scrollContentView */
@property(strong, nonatomic) UIScrollView *scrollContentView;
/** jbzlTitleLabel */
@property (nonatomic, strong) UILabel * jbzlTitleLabel;
/** 项目名称 */
@property(strong, nonatomic) CXEditLabel *xmmcLabel;
/** 当前轮次 */
@property(strong, nonatomic) CXEditLabel *dqlcLabel;
/** 约见状态 */
@property(strong, nonatomic) CXEditLabel *yjztLabel;
/** 行业 */
@property(strong, nonatomic) CXEditLabel *hyLabel;
/** 投资机构 */
@property(strong, nonatomic) CXEditLabel *tzjgLabel;
/** 城市 */
@property(strong, nonatomic) CXEditLabel *csLabel;
/** 跟进状态 */
@property(strong, nonatomic) CXEditLabel *gjztLabel;
/** 接触时间 */
@property(strong, nonatomic) CXEditLabel *jcsjLabel;
/** 负责人 */
@property(strong, nonatomic) CXEditLabel *fzrLabel;
/** IDG投资情况 */
@property(strong, nonatomic) CXEditLabel *IDGtzqkLabel;
/** 重点项目 */
@property(strong, nonatomic) CXEditLabel *zdxmLabel;
/** ywjsTitleLabel */
@property (nonatomic, strong) UILabel * ywjsTitleLabel;
/** ywjsContentLabel */
@property (nonatomic, strong) UILabel * ywjsContentLabel;
/** 数据源：行业 */
@property (nonatomic, copy) NSMutableArray *industryList;
/** ywjsTitleButton */
@property (nonatomic, strong) UIButton * ywjsTitleButton;
/** ywjsContentButton */
@property (nonatomic, strong) UIButton * ywjsContentButton;

@property (nonatomic, strong) CXAddPEPotialProjectView *addView;

@end

@implementation CXAddPEPotentialProjectViewController


#define kTextColor [UIColor blackColor]

- (CXPEPotentialProjectModel *)model{
    if(!_model){
        _model = [[CXPEPotentialProjectModel alloc] init];
    }
    return _model;
}

- (CXAddPEPotialProjectView *)addView{
    if(nil == _addView){
        _addView = [[CXAddPEPotialProjectView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
        if(!(self.formType == CXFormTypeCreate))
            _addView.model = _model;
    }
    return _addView;
}
- (NSMutableArray *)industryList{
    if(!_industryList){
        _industryList = @[].mutableCopy;
    }
    return _industryList;
}

- (UIScrollView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIScrollView alloc] init];
        [_scrollContentView flashScrollIndicators];
        // 是否同时运动,lock
        _scrollContentView.directionalLockEnabled = YES;
        _scrollContentView.backgroundColor = SDBackGroudColor;
        [self.view addSubview:_scrollContentView];
    }
    return _scrollContentView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpNavBar];
//    [self findIndustryList];
    [self.view addSubview:self.addView];
}
- (void)viewWillAppear:(BOOL)animated{

    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUpUI
- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];//项目名称
    [rootTopView setNavTitle:self.model.projName ? self.model.projName : @"新建项目"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [rootTopView setUpRightBarItemTitle:@"提交" addTarget:self action:@selector(saveBtnClick)];
}

- (void)setUpScrollView {
    if(self.formType == CXFormTypeCreate){
        CXWeakSelf(self)
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        /// 左边距
        CGFloat leftMargin = 5.f;
        /// 行高
        CGFloat viewHeight = 45.f;
        CGFloat lineHeight = 1.f;
        CGFloat lineBoldHeight = 10.f;
        CGFloat lineWidth = Screen_Width;
        /// 宽度
        CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;
        
        _jbzlTitleLabel = [[UILabel alloc] init];
        _jbzlTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _jbzlTitleLabel.textColor = [UIColor blackColor];
        _jbzlTitleLabel.numberOfLines = 0;
        _jbzlTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _jbzlTitleLabel.backgroundColor = [UIColor clearColor];
        _jbzlTitleLabel.textAlignment = NSTextAlignmentLeft;
        _jbzlTitleLabel.text = @"基本资料";
        CGSize jbzlTitleLabelSize = [_jbzlTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _jbzlTitleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, Screen_Width - kLabelLeftSpace, jbzlTitleLabelSize.height);
        [self.scrollContentView addSubview:_jbzlTitleLabel];
        
        //项目名称
        _xmmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, _jbzlTitleLabel.bottom, Screen_Width - leftMargin, viewHeight)];
        _xmmcLabel.title = @"项目名称：";
        _xmmcLabel.allowEditing = YES;
        _xmmcLabel.textColor = kTextColor;
        _xmmcLabel.inputType = CXEditLabelInputTypeText;
        _xmmcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            SDRootTopView *rootTopView = [self getRootTopView];
            [rootTopView setNavTitle:editLabel.content];
            self.model.projName = editLabel.content;
        };
        [self.scrollContentView addSubview:_xmmcLabel];
        
        // line_1
        UIView *line_1 = [self createFormSeperatorLine];
        line_1.frame = CGRectMake(0.f, _xmmcLabel.bottom, lineWidth, lineHeight);
        
        //当前轮次
        _dqlcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
        _dqlcLabel.title = @"当前轮次：";
        _dqlcLabel.textColor = kTextColor;
        _dqlcLabel.allowEditing = YES;
        _dqlcLabel.inputType = CXEditLabelInputTypeText;
        _dqlcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invRound = editLabel.content;
        };
        [self.scrollContentView addSubview:_dqlcLabel];
        
        // line_2
        UIView *line_2 = [self createFormSeperatorLine];
        line_2.frame = CGRectMake(0.f, _dqlcLabel.bottom, lineWidth, lineHeight);
        
        //约见状态
        _yjztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
        _yjztLabel.title = @"约见状态：";
        _yjztLabel.textColor = kTextColor;
        _yjztLabel.allowEditing = YES;
        _yjztLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _yjztLabel.pickerTextArray = @[@"未约见",@"已约见"];
        _yjztLabel.pickerValueArray = @[@"unDate",@"date"];
        _yjztLabel.content = _yjztLabel.pickerTextArray.firstObject;
        self.model.invContactStatus = _yjztLabel.pickerValueArray.firstObject;
        _yjztLabel.selectedPickerData = @{
                                        CXEditLabelCustomPickerTextKey : _yjztLabel.pickerTextArray.firstObject,
                                        CXEditLabelCustomPickerValueKey : _yjztLabel.pickerValueArray.firstObject
                                        };
        _yjztLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未约见"]){
                self.yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"未约见",
                                                  CXEditLabelCustomPickerValueKey : @"unDate"
                                                  };
                self.model.invContactStatus = @"unDate";
            }else if([editLabel.content isEqualToString:@"已约见"]){
                self.yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"已约见",
                                                  CXEditLabelCustomPickerValueKey : @"date"
                                                  };
                self.model.invContactStatus = @"date";
            }
        };
        [self.scrollContentView addSubview:_yjztLabel];
        
        // line_3
        UIView *line_3 = [self createFormSeperatorLine];
        line_3.frame = CGRectMake(0.f, _yjztLabel.bottom, lineWidth, lineHeight);
        
        //行业
        _hyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
        _hyLabel.title = @"行　　业：";
        _hyLabel.textColor = kTextColor;
        _hyLabel.allowEditing = YES;
        _hyLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _hyLabel.pickerTextArray = self.industryList;
        _hyLabel.pickerValueArray = self.industryList;
        _hyLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.hyLabel.selectedPickerData = @{
                                            CXEditLabelCustomPickerTextKey : editLabel.content,
                                            CXEditLabelCustomPickerValueKey : editLabel.content
                                            };
            self.model.comIndus = editLabel.content;
        };
        [self.scrollContentView addSubview:_hyLabel];
        
        // line_4
        UIView *line_4 = [self createFormSeperatorLine];
        line_4.frame = CGRectMake(0.f, _hyLabel.bottom, lineWidth, lineHeight);
        
        //投资机构
        _tzjgLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
        _tzjgLabel.title = @"投资机构：";
        _tzjgLabel.textColor = kTextColor;
        _tzjgLabel.allowEditing = YES;
        _tzjgLabel.inputType = CXEditLabelInputTypeText;
        _tzjgLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invGroup = editLabel.content;
        };
        [self.scrollContentView addSubview:_tzjgLabel];
        
        // line_5
        UIView *line_5 = [self createFormSeperatorLine];
        line_5.frame = CGRectMake(0.f, _tzjgLabel.bottom, lineWidth, lineHeight);
        
        //城市
        _csLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
        _csLabel.title = @"城　　市：";
        _csLabel.textColor = kTextColor;
        _csLabel.allowEditing = YES;
        _csLabel.inputType = CXEditLabelInputTypeText;
        _csLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.region = editLabel.content;
        };
        [self.scrollContentView addSubview:_csLabel];
        
        // line_6
        UIView *line_6 = [self createFormSeperatorLine];
        line_6.frame = CGRectMake(0.f, _csLabel.bottom, lineWidth, lineHeight);
        
        //接触时间
        _jcsjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
        _jcsjLabel.title = @"接触时间：";
        _jcsjLabel.textColor = kTextColor;
        _jcsjLabel.allowEditing = YES;
        _jcsjLabel.showDropdown = YES;
        _jcsjLabel.inputType = CXEditLabelInputTypeDate;
        _jcsjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invDate = editLabel.content;
        };
        [self.scrollContentView addSubview:_jcsjLabel];
        
        // line_7
        UIView *line_7 = [self createFormSeperatorLine];
        line_7.frame = CGRectMake(0.f, _jcsjLabel.bottom, lineWidth, lineHeight);
        
        //IDG投资情况
        _IDGtzqkLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_7.bottom, Screen_Width - leftMargin, viewHeight)];
        _IDGtzqkLabel.title = @"IDG投资情况：";
        _IDGtzqkLabel.textColor = kTextColor;
        _IDGtzqkLabel.allowEditing = YES;
        _IDGtzqkLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _IDGtzqkLabel.pickerTextArray = @[@"未投资", @"已投资"];
        _IDGtzqkLabel.pickerValueArray = @[@"unInv", @"inv"];
        _IDGtzqkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未投资"]){
                self.yjztLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"未投资",
                                                      CXEditLabelCustomPickerValueKey : @"unInv"
                                                      };
                self.model.invStatus = @"unInv";
            }else if([editLabel.content isEqualToString:@"已投资"]){
                self.yjztLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"已投资",
                                                      CXEditLabelCustomPickerValueKey : @"inv"
                                                      };
                self.model.invStatus = @"inv";
            }
        };
        [self.scrollContentView addSubview:_IDGtzqkLabel];
        
        // line_8
        UIView *line_8 = [self createFormSeperatorLine];
        line_8.frame = CGRectMake(0.f, _IDGtzqkLabel.bottom, lineWidth, lineHeight);
        
        //重点项目
        _zdxmLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - leftMargin, viewHeight)];
        _zdxmLabel.title = @"是否重点项目：";
        _zdxmLabel.textColor = kTextColor;
        _zdxmLabel.allowEditing = YES;
        _zdxmLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _zdxmLabel.pickerTextArray = @[@"是",@"是(新增)",@"否"];
        _zdxmLabel.pickerValueArray = @[@(1),@(2),@(3)];
        _zdxmLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"是"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"是",
                                                      CXEditLabelCustomPickerValueKey : @(1)
                                                      };
                self.model.importantStatus = @(1);
            }else if([editLabel.content isEqualToString:@"是(新增)"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                      CXEditLabelCustomPickerValueKey : @(2)
                                                      };
                self.model.importantStatus = @(2);
            }else if([editLabel.content isEqualToString:@"否"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"否",
                                                      CXEditLabelCustomPickerValueKey : @(3)
                                                      };
                self.model.importantStatus = @(3);
            }
        };
        [self.scrollContentView addSubview:_zdxmLabel];
        
        // line_9
        UIView *line_9 = [self createFormSeperatorLine];
        line_9.frame = CGRectMake(0.f, _zdxmLabel.bottom, lineWidth, lineBoldHeight);
        
        _ywjsTitleLabel = [[UILabel alloc] init];
        _ywjsTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _ywjsTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
        _ywjsTitleLabel.numberOfLines = 0;
        _ywjsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _ywjsTitleLabel.backgroundColor = [UIColor clearColor];
        _ywjsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _ywjsTitleLabel.text = @"业务介绍";
        CGSize ywjsTitleLabelSize = [_ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _ywjsTitleLabel.frame = CGRectMake(leftMargin, line_9.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, ywjsTitleLabelSize.height);
        [self.scrollContentView addSubview:_ywjsTitleLabel];
        
        if(_ywjsTitleButton){
            [_ywjsTitleButton removeFromSuperview];
            _ywjsTitleButton = nil;
        }
        _ywjsTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ywjsTitleButton.frame = CGRectMake(0, line_9.bottom + kLabelTopSpace, Screen_Width, ywjsTitleLabelSize.height);
        [_ywjsTitleButton addTarget:self action:@selector(ywjsClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollContentView addSubview:_ywjsTitleButton];
        
        if(_ywjsContentLabel){
            [_ywjsContentLabel removeFromSuperview];
        }
        _ywjsContentLabel = [[UILabel alloc] init];
        _ywjsContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
        _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
        _ywjsContentLabel.numberOfLines = 0;
        _ywjsContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _ywjsContentLabel.backgroundColor = [UIColor clearColor];
        _ywjsContentLabel.textAlignment = NSTextAlignmentLeft;
        if(!self.model.bizDesc || (self.model.bizDesc && [self.model.bizDesc length] <= 0)){
            _ywjsContentLabel.text = @"请输入业务介绍";
            _ywjsContentLabel.textColor = RGBACOLOR(142.0, 142.0, 147.0, 1.0);
        }else{
            _ywjsContentLabel.text = self.model.bizDesc;
            _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
        }
        CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
        _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
        [self.scrollContentView addSubview:_ywjsContentLabel];
        
        if(_ywjsContentButton){
            [_ywjsContentButton removeFromSuperview];
            _ywjsContentButton = nil;
        }
        _ywjsContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ywjsContentButton.frame = CGRectMake(0, _ywjsTitleLabel.bottom, Screen_Width, kLabelTopSpace + ywjsContentLabelSize.height);
        [_ywjsContentButton addTarget:self action:@selector(ywjsClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollContentView addSubview:_ywjsContentButton];
        
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _ywjsContentLabel.bottom + kLabelTopSpace);
    }else if(self.formType == CXFormTypeModify){
        CXWeakSelf(self)
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        /// 左边距
        CGFloat leftMargin = 5.f;
        /// 行高
        CGFloat viewHeight = 45.f;
        CGFloat lineHeight = 1.f;
        CGFloat lineBoldHeight = 10.f;
        CGFloat lineWidth = Screen_Width;
        /// 宽度
        CGFloat viewWidth = (Screen_Width - 2 * leftMargin) / 2.f;
        
        _jbzlTitleLabel = [[UILabel alloc] init];
        _jbzlTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _jbzlTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
        _jbzlTitleLabel.numberOfLines = 0;
        _jbzlTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _jbzlTitleLabel.backgroundColor = [UIColor clearColor];
        _jbzlTitleLabel.textAlignment = NSTextAlignmentLeft;
        _jbzlTitleLabel.text = @"基本资料";
        CGSize jbzlTitleLabelSize = [_jbzlTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _jbzlTitleLabel.frame = CGRectMake(leftMargin, kLabelTopSpace, Screen_Width - kLabelLeftSpace, jbzlTitleLabelSize.height);
        [self.scrollContentView addSubview:_jbzlTitleLabel];
        
        //项目名称
        _xmmcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, _jbzlTitleLabel.bottom, Screen_Width - leftMargin, viewHeight)];
        _xmmcLabel.title = @"项目名称：";
        _xmmcLabel.allowEditing = YES;
        _xmmcLabel.textColor = kTextColor;
        _xmmcLabel.inputType = CXEditLabelInputTypeText;
        _xmmcLabel.content = self.model.projName;
        _xmmcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            SDRootTopView *rootTopView = [self getRootTopView];
            [rootTopView setNavTitle:editLabel.content];
            self.model.projName = editLabel.content;
        };
        [self.scrollContentView addSubview:_xmmcLabel];
        
        // line_1
        UIView *line_1 = [self createFormSeperatorLine];
        line_1.frame = CGRectMake(0.f, _xmmcLabel.bottom, lineWidth, lineHeight);
        
        //当前轮次
        _dqlcLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_1.bottom, Screen_Width - leftMargin, viewHeight)];
        _dqlcLabel.title = @"当前轮次：";
        _dqlcLabel.textColor = kTextColor;
        _dqlcLabel.allowEditing = YES;
        _dqlcLabel.inputType = CXEditLabelInputTypeText;
        _dqlcLabel.content = self.model.invRound;
        _dqlcLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invRound = editLabel.content;
        };
        [self.scrollContentView addSubview:_dqlcLabel];
        
        // line_2
        UIView *line_2 = [self createFormSeperatorLine];
        line_2.frame = CGRectMake(0.f, _dqlcLabel.bottom, lineWidth, lineHeight);
        
        //约见状态
        _yjztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_2.bottom, Screen_Width - leftMargin, viewHeight)];
        _yjztLabel.title = @"约见状态：";
        _yjztLabel.textColor = kTextColor;
        _yjztLabel.allowEditing = YES;
        _yjztLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _yjztLabel.pickerTextArray = @[@"未约见",@"已约见"];
        _yjztLabel.pickerValueArray = @[@"unDate",@"date"];
        if (self.formType == CXFormTypeDetail || self.formType == CXFormTypeModify) {
            CXStrongSelf(self)
            if([self.model.invContactStatus isEqualToString:@"unDate"]){
                _yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"未约见",
                                                  CXEditLabelCustomPickerValueKey : @"unDate"
                                                  };
                _yjztLabel.content = @"未约见";
            }else if([self.model.invContactStatus isEqualToString:@"date"]){
                _yjztLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"已约见",
                                                  CXEditLabelCustomPickerValueKey : @"date"
                                                  };
                _yjztLabel.content = @"已约见";
            }
        }else{
            self.model.invContactStatus = _yjztLabel.pickerValueArray.firstObject;
            _yjztLabel.content = _yjztLabel.pickerTextArray.firstObject;
            _yjztLabel.selectedPickerData = @{
                                              CXEditLabelCustomPickerTextKey : _yjztLabel.pickerTextArray.firstObject,
                                              CXEditLabelCustomPickerValueKey : _yjztLabel.pickerValueArray.firstObject
                                              };
        }
        _yjztLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未约见"]){
                self.yjztLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"未约见",
                                                      CXEditLabelCustomPickerValueKey : @"unDate"
                                                      };
                self.model.invContactStatus = @"unDate";
            }else if([editLabel.content isEqualToString:@"已约见"]){
                self.yjztLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"已约见",
                                                      CXEditLabelCustomPickerValueKey : @"date"
                                                      };
                self.model.invContactStatus = @"date";
            }
        };
        [self.scrollContentView addSubview:_yjztLabel];
        
        // line_3
        UIView *line_3 = [self createFormSeperatorLine];
        line_3.frame = CGRectMake(0.f, _yjztLabel.bottom, lineWidth, lineHeight);
        
        //行业
        _hyLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_3.bottom, Screen_Width - leftMargin, viewHeight)];
        _hyLabel.title = @"行　　业：";
        _hyLabel.textColor = kTextColor;
        _hyLabel.allowEditing = YES;
        _hyLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _hyLabel.pickerTextArray = self.industryList;
        _hyLabel.pickerValueArray = self.industryList;
        if (self.formType == CXFormTypeDetail || self.formType == CXFormTypeModify) {
            if(self.model.comIndus){
                _hyLabel.content = self.model.comIndus;
                _hyLabel.selectedPickerData = @{
                                                CXEditLabelCustomPickerTextKey : self.model.comIndus,
                                                CXEditLabelCustomPickerValueKey : self.model.comIndus
                                                };
            }
        }else{
            self.model.comIndus = _hyLabel.pickerValueArray.firstObject;
            _hyLabel.content = _hyLabel.pickerTextArray.firstObject;
            _hyLabel.selectedPickerData = @{
                                            CXEditLabelCustomPickerTextKey : _hyLabel.pickerTextArray.firstObject,
                                            CXEditLabelCustomPickerValueKey : _hyLabel.pickerValueArray.firstObject
                                            };
        }
        _hyLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.hyLabel.selectedPickerData = @{
                                            CXEditLabelCustomPickerTextKey : editLabel.content,
                                            CXEditLabelCustomPickerValueKey : editLabel.content
                                            };
            self.model.comIndus = editLabel.content;
        };
        [self.scrollContentView addSubview:_hyLabel];
        
        // line_4
        UIView *line_4 = [self createFormSeperatorLine];
        line_4.frame = CGRectMake(0.f, _hyLabel.bottom, lineWidth, lineHeight);
        
        //投资机构
        _tzjgLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_4.bottom, Screen_Width - leftMargin, viewHeight)];
        _tzjgLabel.title = @"投资机构：";
        _tzjgLabel.textColor = kTextColor;
        _tzjgLabel.allowEditing = YES;
        _tzjgLabel.inputType = CXEditLabelInputTypeText;
        _tzjgLabel.content = self.model.invGroup;
        _tzjgLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invGroup = editLabel.content;
        };
        [self.scrollContentView addSubview:_tzjgLabel];
        
        // line_5
        UIView *line_5 = [self createFormSeperatorLine];
        line_5.frame = CGRectMake(0.f, _tzjgLabel.bottom, lineWidth, lineHeight);
        
        //城市
        _csLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_5.bottom, Screen_Width - leftMargin, viewHeight)];
        _csLabel.title = @"城　　市：";
        _csLabel.textColor = kTextColor;
        _csLabel.allowEditing = YES;
        _csLabel.inputType = CXEditLabelInputTypeText;
        _csLabel.content = self.model.region;
        _csLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.region = editLabel.content;
        };
        [self.scrollContentView addSubview:_csLabel];
        
        // line_6
        UIView *line_6 = [self createFormSeperatorLine];
        line_6.frame = CGRectMake(0.f, _csLabel.bottom, lineWidth, lineHeight);
        
        //跟进状态
        _gjztLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_6.bottom, Screen_Width - leftMargin, viewHeight)];
        _gjztLabel.title = @"跟进状态：";
        _gjztLabel.textColor = kTextColor;
        _gjztLabel.allowEditing = NO;
        _gjztLabel.inputType = CXEditLabelInputTypeText;
        
        if([self.model.invFlowUp isEqualToString:@"flowUp"]){
            _gjztLabel.content = @"继续跟进";
        }else if([self.model.invFlowUp isEqualToString:@"abandon"]){
            _gjztLabel.content = @"放弃";
        }else if([self.model.invFlowUp isEqualToString:@"WS"]){
            _gjztLabel.content = @"观望";
        }
        _gjztLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invFlowUp = editLabel.content;
        };
        [self.scrollContentView addSubview:_gjztLabel];
        
        // line_7
        UIView *line_7 = [self createFormSeperatorLine];
        line_7.frame = CGRectMake(0.f, _gjztLabel.bottom, lineWidth, lineHeight);
        
        //接触时间
        _jcsjLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_7.bottom, Screen_Width - leftMargin, viewHeight)];
        _jcsjLabel.title = @"接触时间：";
        _jcsjLabel.textColor = kTextColor;
        _jcsjLabel.allowEditing = YES;
        _jcsjLabel.showDropdown = YES;
        _jcsjLabel.inputType = CXEditLabelInputTypeDate;
        _jcsjLabel.content = self.model.invDate;
        _jcsjLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            self.model.invDate = editLabel.content;
        };
        [self.scrollContentView addSubview:_jcsjLabel];
        
        // line_8
        UIView *line_8 = [self createFormSeperatorLine];
        line_8.frame = CGRectMake(0.f, _jcsjLabel.bottom, lineWidth, lineHeight);
        
        //负责人
        _fzrLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_8.bottom, Screen_Width - leftMargin, viewHeight)];
        _fzrLabel.title = @"负责人：";
        _fzrLabel.textColor = kTextColor;
        _fzrLabel.allowEditing = NO;
        _fzrLabel.showDropdown = NO;
        _fzrLabel.inputType = CXEditLabelInputTypeDate;
        _fzrLabel.content = VAL_USERNAME;
        [self.scrollContentView addSubview:_fzrLabel];
        
        // line_9
        UIView *line_9 = [self createFormSeperatorLine];
        line_9.frame = CGRectMake(0.f, _fzrLabel.bottom, lineWidth, lineHeight);
        
        //IDG投资情况
        _IDGtzqkLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_9.bottom, Screen_Width - leftMargin, viewHeight)];
        _IDGtzqkLabel.title = @"IDG投资情况：";
        _IDGtzqkLabel.textColor = kTextColor;
        _IDGtzqkLabel.allowEditing = YES;
        _IDGtzqkLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _IDGtzqkLabel.pickerTextArray = @[@"未投资", @"已投资"];
        _IDGtzqkLabel.pickerValueArray = @[@"unInv", @"inv"];
        if (self.formType == CXFormTypeDetail || self.formType == CXFormTypeModify) {
            if([self.model.invStatus isEqualToString:@"unInv"]){
                _IDGtzqkLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"未投资",
                                                  CXEditLabelCustomPickerValueKey : @"unInv"
                                                  };
                _IDGtzqkLabel.content = @"未投资";
            }else if([self.model.invStatus isEqualToString:@"inv"]){
                _IDGtzqkLabel.selectedPickerData = @{
                                                  CXEditLabelCustomPickerTextKey : @"已投资",
                                                  CXEditLabelCustomPickerValueKey : @"inv"
                                                  };
                _IDGtzqkLabel.content = @"已投资";
            }
        }else{
            self.model.invStatus = _IDGtzqkLabel.pickerValueArray.firstObject;
            _IDGtzqkLabel.content = _IDGtzqkLabel.pickerTextArray.firstObject;
            _IDGtzqkLabel.selectedPickerData = @{
                                                 CXEditLabelCustomPickerTextKey : _IDGtzqkLabel.pickerTextArray.firstObject,
                                                 CXEditLabelCustomPickerValueKey : _IDGtzqkLabel.pickerValueArray.firstObject
                                                 };
        }
        _IDGtzqkLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"未投资"]){
                self.IDGtzqkLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"未投资",
                                                      CXEditLabelCustomPickerValueKey : @"unInv"
                                                      };
                self.model.invStatus = @"unInv";
            }else if([editLabel.content isEqualToString:@"已投资"]){
                self.IDGtzqkLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"已投资",
                                                      CXEditLabelCustomPickerValueKey : @"inv"
                                                      };
                self.model.invStatus = @"inv";
            }
        };
        [self.scrollContentView addSubview:_IDGtzqkLabel];
        
        // line_10
        UIView *line_10 = [self createFormSeperatorLine];
        line_10.frame = CGRectMake(0.f, _IDGtzqkLabel.bottom, lineWidth, lineHeight);
        
        //重点项目
        _zdxmLabel = [[CXEditLabel alloc] initWithFrame:CGRectMake(leftMargin, line_10.bottom, Screen_Width - leftMargin, viewHeight)];
        _zdxmLabel.title = @"是否重点项目：";
        _zdxmLabel.textColor = kTextColor;
        _zdxmLabel.allowEditing = YES;
        _zdxmLabel.inputType = CXEditLabelInputTypeCustomPicker;
        _zdxmLabel.pickerTextArray = @[@"是",@"是(新增)",@"否"];
        _zdxmLabel.pickerValueArray = @[@(1),@(2),@(3)];
        if(self.model.importantStatus && [self.model.importantStatus integerValue] == 1){
            _zdxmLabel.content = @"是";
            self.model.importantStatus = @(1);
            _zdxmLabel.selectedPickerData = @{
                                              CXEditLabelCustomPickerTextKey : @"是",
                                              CXEditLabelCustomPickerValueKey : @(1)
                                              };
        }else if(self.model.importantStatus && [self.model.importantStatus integerValue] == 2){
            _zdxmLabel.content = @"是(新增)";
            self.model.importantStatus = @(2);
            _zdxmLabel.selectedPickerData = @{
                                              CXEditLabelCustomPickerTextKey : @"是(新增)",
                                              CXEditLabelCustomPickerValueKey : @(2)
                                              };
        }else if(self.model.importantStatus && [self.model.importantStatus integerValue] == 3){
            _zdxmLabel.content = @"否";
            self.model.importantStatus = @(3);
            _zdxmLabel.selectedPickerData = @{
                                              CXEditLabelCustomPickerTextKey : @"否",
                                              CXEditLabelCustomPickerValueKey : @(3)
                                              };
        }
        _zdxmLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            CXStrongSelf(self)
            if([editLabel.content isEqualToString:@"是"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"是",
                                                      CXEditLabelCustomPickerValueKey : @(1)
                                                      };
                self.model.importantStatus = @(1);
            }else if([editLabel.content isEqualToString:@"是(新增)"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"是(新增)",
                                                      CXEditLabelCustomPickerValueKey : @(2)
                                                      };
                self.model.importantStatus = @(2);
            }else if([editLabel.content isEqualToString:@"否"]){
                self.zdxmLabel.selectedPickerData = @{
                                                      CXEditLabelCustomPickerTextKey : @"否",
                                                      CXEditLabelCustomPickerValueKey : @(3)
                                                      };
                self.model.importantStatus = @(3);
            }
        };
        [self.scrollContentView addSubview:_zdxmLabel];
        
        
        // line_11
        UIView *line_11 = [self createFormSeperatorLine];
        line_11.frame = CGRectMake(0.f, _zdxmLabel.bottom, lineWidth, lineBoldHeight);
        
        _ywjsTitleLabel = [[UILabel alloc] init];
        _ywjsTitleLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
        _ywjsTitleLabel.textColor = kOpinionTypeNameLabelTextColor;
        _ywjsTitleLabel.numberOfLines = 0;
        _ywjsTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _ywjsTitleLabel.backgroundColor = [UIColor clearColor];
        _ywjsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _ywjsTitleLabel.text = @"业务介绍";
        CGSize ywjsTitleLabelSize = [_ywjsTitleLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
        _ywjsTitleLabel.frame = CGRectMake(leftMargin, line_11.bottom + kLabelTopSpace, Screen_Width - kLabelLeftSpace, ywjsTitleLabelSize.height);
        [self.scrollContentView addSubview:_ywjsTitleLabel];
        
        if(_ywjsTitleButton){
            [_ywjsTitleButton removeFromSuperview];
            _ywjsTitleButton = nil;
        }
        _ywjsTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ywjsTitleButton.frame = CGRectMake(0, line_11.bottom + kLabelTopSpace, Screen_Width, ywjsTitleLabelSize.height);
        [_ywjsTitleButton addTarget:self action:@selector(ywjsClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollContentView addSubview:_ywjsTitleButton];
        
        if(_ywjsContentLabel){
            [_ywjsContentLabel removeFromSuperview];
        }
        _ywjsContentLabel = [[UILabel alloc] init];
        _ywjsContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
        _ywjsContentLabel.numberOfLines = 0;
        _ywjsContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _ywjsContentLabel.backgroundColor = [UIColor clearColor];
        _ywjsContentLabel.textAlignment = NSTextAlignmentLeft;
        if(!self.model.bizDesc || (self.model.bizDesc && [self.model.bizDesc length] <= 0)){
            _ywjsContentLabel.text = @"请输入业务介绍";
            _ywjsContentLabel.textColor = RGBACOLOR(142.0, 142.0, 147.0, 1.0);
        }else{
            _ywjsContentLabel.text = self.model.bizDesc;
            _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
        }
        CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
        _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
        [self.scrollContentView addSubview:_ywjsContentLabel];
        
        if(_ywjsContentButton){
            [_ywjsContentButton removeFromSuperview];
            _ywjsContentButton = nil;
        }
        _ywjsContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ywjsContentButton.frame = CGRectMake(0, _ywjsTitleLabel.bottom, Screen_Width, kLabelTopSpace + ywjsContentLabelSize.height);
        [_ywjsContentButton addTarget:self action:@selector(ywjsClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollContentView addSubview:_ywjsContentButton];
        
        self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _ywjsContentLabel.bottom + kLabelTopSpace);
    }
}

- (void)ywjsClick
{
    if([self.ywjsContentLabel.text isEqualToString:@"请输入业务介绍"]){
        self.ywjsContentLabel.text = @"";
    }
    CXLabelTextView *keyboard = [[CXLabelTextView alloc] initWithKeyboardType:UIKeyboardTypeDefault AndLabel:self.ywjsContentLabel];
    keyboard.delegate = self;
    keyboard.maxLengthOfString = 200;//pe业务介绍,最多200字
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    if(!mainWindow){
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    [mainWindow addSubview:keyboard];
}

///用户输入的文本 按发送调用
-(void)textView:(CXLabelTextView *)textView textWhenTextViewFinishingEdit:(NSString *)text
{
    self.model.bizDesc = text;
    
    /// 左边距
    CGFloat leftMargin = 5.f;
    if(_ywjsContentLabel){
        [_ywjsContentLabel removeFromSuperview];
    }
    _ywjsContentLabel = [[UILabel alloc] init];
    _ywjsContentLabel.font = [UIFont systemFontOfSize:kBusinessLabelFontSize];
    _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
    if(!self.model.bizDesc || (self.model.bizDesc && [self.model.bizDesc length] <= 0)){
        _ywjsContentLabel.text = @"请输入业务介绍";
        _ywjsContentLabel.textColor = RGBACOLOR(142.0, 142.0, 147.0, 1.0);
    }else{
        _ywjsContentLabel.text = self.model.bizDesc;
        _ywjsContentLabel.textColor = kOpinionTypeNameLabelTextColor;
    }
    _ywjsContentLabel.numberOfLines = 0;
    _ywjsContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _ywjsContentLabel.backgroundColor = [UIColor clearColor];
    _ywjsContentLabel.textAlignment = NSTextAlignmentLeft;
    CGSize ywjsContentLabelSize = [_ywjsContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*leftMargin, MAXFLOAT)];
    _ywjsContentLabel.frame = CGRectMake(leftMargin, _ywjsTitleLabel.bottom + kLabelTopSpace, Screen_Width - 2*leftMargin, ywjsContentLabelSize.height);
    [self.scrollContentView addSubview:_ywjsContentLabel];
    
    if(_ywjsContentButton){
        [_ywjsContentButton removeFromSuperview];
        _ywjsContentButton = nil;
    }
    _ywjsContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ywjsContentButton.frame = CGRectMake(0, _ywjsTitleLabel.bottom, Screen_Width, kLabelTopSpace + ywjsContentLabelSize.height);
    [_ywjsContentButton addTarget:self action:@selector(ywjsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContentView addSubview:_ywjsContentButton];
    
    self.scrollContentView.contentSize = CGSizeMake(Screen_Width, _ywjsContentLabel.bottom + kLabelTopSpace);
}



/// 表单的分割线
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBACOLOR(242.f, 241.f, 247.f, 1.f);
    [self.scrollContentView addSubview:line];
    return line;
}

- (void)saveBtnClick
{
    _model = [self.addView rollBackData];
    if(_model == nil){
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@project/potential/save",urlPrefix];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.model.projName forKey:@"projName"];
    if (![self.model.invDate isEqualToString:@""]) {
        [params setValue:self.model.invDate forKey:@"invDate"];//此处不支持空的字符串,时间
    }
    [params setValue:self.model.invRound forKey:@"invRound"];
    [params setValue:self.model.invContactStatus forKey:@"invContactStatus"];
    [params setValue:self.model.comIndus forKey:@"comIndus"];
    [params setValue:self.model.bizDesc forKey:@"bizDesc"];
    [params setValue:self.model.invGroup forKey:@"invGroup"];
    [params setValue:self.model.invFlowUp forKey:@"invFlowUp"];
    [params setValue:self.model.region forKey:@"region"];
    [params setValue:self.model.invStatus forKey:@"invStatus"];
    [params setValue:self.model.importantStatus forKey:@"importantStatus"];
    if(self.formType == CXFormTypeModify){
        [params setValue:self.model.projId forKey:@"eid"];
    }
    __weak __typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    [HttpTool postWithPath:url params:params success:^(id JSON) {
        [weakSelf hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            CXMetProjectDetailViewController *vc = [[CXMetProjectDetailViewController alloc] init];
            CXMetProjectListModel *listModel = [[CXMetProjectListModel alloc] init];
            listModel.projId = @([JSON[@"data"] integerValue]);
            listModel.projName = self.model.projName;
            vc.listModel = listModel;
            [self.navigationController pushViewController:vc animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
            
            UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
            [mainWindow makeToast:@"提交成功!" duration:3.0 position:@"center"];
        }
//        else if ([JSON[@"status"] intValue] == 400) {
//            [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//        }
        else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [weakSelf hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)findIndustryList {
    if (self.industryList.count) {
        return;
    }
    [HttpTool getWithPath:@"/project/potential/indus/list.json" params:nil success:^(NSDictionary *JSON) {
        if ([JSON[@"status"] intValue] == 200) {
            NSMutableArray * data = [NSMutableArray arrayWithArray:JSON[@"data"]];
            for(NSObject * object in data){
                if(![object isKindOfClass:[NSNull class]]){
                    [self.industryList addObject:object];
                }
            }
            self.scrollContentView.frame = CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh);
           // [self setUpScrollView];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        CXAlert(KNetworkFailRemind);
    }];
}

@end
