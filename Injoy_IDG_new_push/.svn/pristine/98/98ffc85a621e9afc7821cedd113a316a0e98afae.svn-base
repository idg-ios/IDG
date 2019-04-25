//
//  CXIDGInvestmentProgramListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGInvestmentProgramListTableViewCell.h"
#import "UIView+Category.h"
#import "HttpTool.h"

#define kLabelLeftSpace 16.0
#define kLabelTopSpace 16.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kTitleLabelFontSize 14.0
#define kTitleLabelTextColor RGBACOLOR(132.0, 142.0, 153.0, 1.0)
#define kOpinionDateLabelFontSize 14.0
#define kOpinionDateLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kConclusionLabelFontSize 14.0
#define kConclusionLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kApprovedByNameLabelFontSize 14.0
#define kApprovedByNameLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kUnitLabelFontSize 12.0
#define kUnitLabelTextColor RGBACOLOR(132.0, 142.0, 153.0, 1.0)

#define kRmbCostLabelLeftSpace (kLabelLeftSpace + kTitleLabelFontSize*4.0)

@interface CXIDGInvestmentProgramListTableViewCell()<UIAlertViewDelegate>

@property (nonatomic, strong) CXIDGInvestmentProgramListModel * model;
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
@property (nonatomic, strong) UILabel * opinionDateTitleLabel;
@property (nonatomic, strong) UILabel * opinionDateLabel;
@property (nonatomic, strong) UILabel * planDateTitleLabel;
@property (nonatomic, strong) UILabel * planDateLabel;
@property (nonatomic, strong) UILabel * conclusionTitleLabel;
@property (nonatomic, strong) UILabel * conclusionLabel;
@property (nonatomic, strong) UILabel * jeTitleLabel;
@property (nonatomic, strong) UILabel * jeLabel;
@property (nonatomic, strong) UILabel * unitLabel;
@property (nonatomic, strong) UILabel * approvedFlagTitleLabel;
@property (nonatomic, strong) UILabel * approvedFlagLabel;
@property (nonatomic, strong) UILabel * editByNameTitleLabel;
@property (nonatomic, strong) UILabel * editByNameLabel;
@property (nonatomic, strong) UILabel * approvedbByNameTitleLabel;
@property (nonatomic, strong) UILabel * approvedbByNameLabel;
@property (nonatomic, strong) UILabel * sprTitleLabel;
@property (nonatomic, strong) UIButton * wyspBtn;

@end

@implementation CXIDGInvestmentProgramListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_opinionTypeNameLabel){
        [_opinionTypeNameLabel removeFromSuperview];
        _opinionTypeNameLabel = nil;
    }
    _opinionTypeNameLabel = [[UILabel alloc] init];
    _opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    _opinionTypeNameLabel.textColor = kOpinionTypeNameLabelTextColor;
    _opinionTypeNameLabel.numberOfLines = 0;
    _opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _opinionTypeNameLabel.backgroundColor = [UIColor clearColor];
    _opinionTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_planDateTitleLabel){
        [_planDateTitleLabel removeFromSuperview];
        _planDateTitleLabel = nil;
    }
    _planDateTitleLabel = [[UILabel alloc] init];
    _planDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _planDateTitleLabel.textColor = kTitleLabelTextColor;
    _planDateTitleLabel.backgroundColor = [UIColor clearColor];
    _planDateTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_planDateLabel){
        [_planDateLabel removeFromSuperview];
        _planDateLabel = nil;
    }
    _planDateLabel = [[UILabel alloc] init];
    _planDateLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _planDateLabel.textColor = kOpinionDateLabelTextColor;
    _planDateLabel.numberOfLines = 0;
    _planDateLabel.backgroundColor = [UIColor clearColor];
    _planDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _planDateLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionDateTitleLabel){
        [_opinionDateTitleLabel removeFromSuperview];
        _opinionDateTitleLabel = nil;
    }
    _opinionDateTitleLabel = [[UILabel alloc] init];
    _opinionDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _opinionDateTitleLabel.textColor = kTitleLabelTextColor;
    _opinionDateTitleLabel.backgroundColor = [UIColor clearColor];
    _opinionDateTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionDateLabel){
        [_opinionDateLabel removeFromSuperview];
        _opinionDateLabel = nil;
    }
    _opinionDateLabel = [[UILabel alloc] init];
    _opinionDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    _opinionDateLabel.textColor = kOpinionDateLabelTextColor;
    _opinionDateLabel.numberOfLines = 0;
    _opinionDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _opinionDateLabel.backgroundColor = [UIColor clearColor];
    _opinionDateLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_conclusionTitleLabel){
        [_conclusionTitleLabel removeFromSuperview];
        _conclusionTitleLabel = nil;
    }
    _conclusionTitleLabel = [[UILabel alloc] init];
    _conclusionTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _conclusionTitleLabel.textColor = kTitleLabelTextColor;
    _conclusionTitleLabel.numberOfLines = 0;
    _conclusionTitleLabel.backgroundColor = [UIColor clearColor];
    _conclusionTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_conclusionLabel){
        [_conclusionLabel removeFromSuperview];
        _conclusionLabel = nil;
    }
    _conclusionLabel = [[UILabel alloc] init];
    _conclusionLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _conclusionLabel.textColor = kConclusionLabelTextColor;
    _conclusionLabel.numberOfLines = 0;
    _conclusionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _conclusionLabel.backgroundColor = [UIColor clearColor];
    _conclusionLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_jeTitleLabel){
        [_jeTitleLabel removeFromSuperview];
        _jeTitleLabel = nil;
    }
    _jeTitleLabel = [[UILabel alloc] init];
    _jeTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _jeTitleLabel.textColor = kTitleLabelTextColor;
    _jeTitleLabel.numberOfLines = 0;
    _jeTitleLabel.backgroundColor = [UIColor clearColor];
    _jeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_jeLabel){
        [_jeLabel removeFromSuperview];
        _jeLabel = nil;
    }
    _jeLabel = [[UILabel alloc] init];
    _jeLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    _jeLabel.textColor = kApprovedByNameLabelTextColor;
    _jeLabel.numberOfLines = 0;
    _jeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _jeLabel.backgroundColor = [UIColor clearColor];
    _jeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_unitLabel){
        [_unitLabel removeFromSuperview];
        _unitLabel = nil;
    }
    _unitLabel = [[UILabel alloc] init];
    _unitLabel.font = [UIFont systemFontOfSize:kUnitLabelFontSize];
    _unitLabel.textColor = kUnitLabelTextColor;
    _unitLabel.backgroundColor = [UIColor clearColor];
    _unitLabel.textAlignment = NSTextAlignmentRight;
    
    if(_approvedFlagTitleLabel){
        [_approvedFlagTitleLabel removeFromSuperview];
        _approvedFlagTitleLabel = nil;
    }
    _approvedFlagTitleLabel = [[UILabel alloc] init];
    _approvedFlagTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _approvedFlagTitleLabel.textColor = kTitleLabelTextColor;
    _approvedFlagTitleLabel.numberOfLines = 0;
    _approvedFlagTitleLabel.backgroundColor = [UIColor clearColor];
    _approvedFlagTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedFlagLabel){
        [_approvedFlagLabel removeFromSuperview];
        _approvedFlagLabel = nil;
    }
    _approvedFlagLabel = [[UILabel alloc] init];
    _approvedFlagLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _approvedFlagLabel.textColor = kConclusionLabelTextColor;
    _approvedFlagLabel.numberOfLines = 0;
    _approvedFlagLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _approvedFlagLabel.backgroundColor = [UIColor clearColor];
    _approvedFlagLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_editByNameTitleLabel){
        [_editByNameTitleLabel removeFromSuperview];
        _editByNameTitleLabel = nil;
    }
    _editByNameTitleLabel = [[UILabel alloc] init];
    _editByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _editByNameTitleLabel.textColor = kTitleLabelTextColor;
    _editByNameTitleLabel.numberOfLines = 0;
    _editByNameTitleLabel.backgroundColor = [UIColor clearColor];
    _editByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_editByNameLabel){
        [_editByNameLabel removeFromSuperview];
        _editByNameLabel = nil;
    }
    _editByNameLabel = [[UILabel alloc] init];
    _editByNameLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _editByNameLabel.textColor = kConclusionLabelTextColor;
    _editByNameLabel.numberOfLines = 0;
    _editByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _editByNameLabel.backgroundColor = [UIColor clearColor];
    _editByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedbByNameTitleLabel){
        [_approvedbByNameTitleLabel removeFromSuperview];
        _approvedbByNameTitleLabel = nil;
    }
    _approvedbByNameTitleLabel = [[UILabel alloc] init];
    _approvedbByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _approvedbByNameTitleLabel.textColor = kTitleLabelTextColor;
    _approvedbByNameTitleLabel.numberOfLines = 0;
    _approvedbByNameTitleLabel.backgroundColor = [UIColor clearColor];
    _approvedbByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedbByNameLabel){
        [_approvedbByNameLabel removeFromSuperview];
        _approvedbByNameLabel = nil;
    }
    _approvedbByNameLabel = [[UILabel alloc] init];
    _approvedbByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    _approvedbByNameLabel.textColor = kApprovedByNameLabelTextColor;
    _approvedbByNameLabel.numberOfLines = 0;
    _approvedbByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _approvedbByNameLabel.backgroundColor = [UIColor clearColor];
    _approvedbByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_wyspBtn){
        [_wyspBtn removeFromSuperview];
        _wyspBtn = nil;
    }
    _wyspBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wyspBtn setTitle:@"我要审批" forState:UIControlStateNormal];
    [_wyspBtn setTitle:@"我要审批" forState:UIControlStateHighlighted];
    [_wyspBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_wyspBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_wyspBtn addTarget:self action:@selector(wyspBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCXIDGInvestmentProgramListModel:(CXIDGInvestmentProgramListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _opinionTypeNameLabel.text = [NSString stringWithFormat:@"方案类型：%@",_model.status?_model.status:@""];
    _opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace, kOpinionTypeNameLabelFontSize);
    [self.contentView addSubview:_opinionTypeNameLabel];
    
    _planDateTitleLabel.text = @"日 期";
    [_planDateTitleLabel sizeToFit];
    _planDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, _planDateTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_planDateTitleLabel];
    
    _planDateLabel.text = !_model.planDate||[_model.planDate length] <= 0?@" ":_model.planDate;
    CGSize planDateLabelSize = [_planDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _planDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, planDateLabelSize.height);
    [self.contentView addSubview:_planDateLabel];
    
    _opinionDateTitleLabel.text = @"内 容";
    [_opinionDateTitleLabel sizeToFit];
    _opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_planDateLabel.frame) + kLabelTopSpace, _opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_opinionDateTitleLabel];
    
    _opinionDateLabel.text = !_model.planDesc||[_model.planDesc length] <= 0?@" ":_model.planDesc;
    CGSize opinionDateLabelSize = [_opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _opinionDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_planDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, opinionDateLabelSize.height);
    [self.contentView addSubview:_opinionDateLabel];
    
    _conclusionTitleLabel.text = @"币 种";
    [_conclusionTitleLabel sizeToFit];
    _conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, _conclusionTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_conclusionTitleLabel];
    
    _conclusionLabel.text = !_model.currency||[_model.currency length] <= 0?@" ":_model.currency;
    CGSize conclusionLabelSize = [_conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _conclusionLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, conclusionLabelSize.height);
    [self.contentView addSubview:_conclusionLabel];
    
    _jeTitleLabel.text = @"金 额";
    [_jeTitleLabel sizeToFit];
    _jeTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace, _jeTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_jeTitleLabel];
    
    _unitLabel.text = @"(￥万元/$ M)";
    [_unitLabel sizeToFit];
    _unitLabel.frame = CGRectMake(Screen_Width - kLabelLeftSpace - _unitLabel.size.width, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace + 1, _unitLabel.size.width, kUnitLabelFontSize);
    [self.contentView addSubview:_unitLabel];
    
    _jeLabel.text = !_model.amt||[_model.amt length] <= 0?@" ":_model.amt;
    _jeLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, kApprovedByNameLabelFontSize);
    [self.contentView addSubview:_jeLabel];
    
    _approvedFlagTitleLabel.text = @"通 过";
    [_approvedFlagTitleLabel sizeToFit];
    _approvedFlagTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_jeLabel.frame) + kLabelTopSpace, _approvedFlagTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_approvedFlagTitleLabel];
    
    _approvedFlagLabel.text = !_model.approvedFlag||[_model.approvedFlag length] <= 0?@" ":_model.approvedFlag;
    CGSize approvedFlagLabelSize = [_approvedFlagLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _approvedFlagLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_jeLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedFlagLabelSize.height);
    [self.contentView addSubview:_approvedFlagLabel];
    
    _editByNameTitleLabel.text = @"维护人";
    [_editByNameTitleLabel sizeToFit];
    _editByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_approvedFlagLabel.frame) + kLabelTopSpace, _editByNameTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_editByNameTitleLabel];
    
    _editByNameLabel.text = !_model.editByName||[_model.editByName length] <= 0?@" ":_model.editByName;
    CGSize editByNameLabelSize = [_editByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _editByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_approvedFlagLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, editByNameLabelSize.height);
    [self.contentView addSubview:_editByNameLabel];
    
    _approvedbByNameTitleLabel.text = @"审批人";
    [_approvedbByNameTitleLabel sizeToFit];
    _approvedbByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace, _approvedbByNameTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_approvedbByNameTitleLabel];
    
    _approvedbByNameLabel.text = !_model.approvedByName||[_model.approvedByName length] <= 0?@" ":_model.approvedByName;
    CGSize approvedbByNameLabelSize = [_approvedbByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _approvedbByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedbByNameLabelSize.height);
    [self.contentView addSubview:_approvedbByNameLabel];
    
    if(_model.teamName && [_model.teamName count] > 0 && [_model.teamName containsObject:VAL_Account] && (!_model.approvedByName || (_model.approvedByName && [_model.approvedByName length] <= 0))){
        _wyspBtn.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_editByNameLabel.frame) + kLabelTopSpace - 20, 60, kTitleLabelFontSize + 40);
        _wyspBtn.titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        [self.contentView addSubview:_wyspBtn];
    }else{
        _wyspBtn.frame = CGRectZero;
    }
}

+ (CGFloat)getCXIDGInvestmentProgramListTableViewCellHeightWithCXIDGInvestmentProgramListModel:(CXIDGInvestmentProgramListModel *)model
{
    UIView * redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    
    UILabel * opinionTypeNameLabel = [[UILabel alloc] init];
    opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    opinionTypeNameLabel.textColor = kOpinionTypeNameLabelTextColor;
    opinionTypeNameLabel.numberOfLines = 0;
    opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionTypeNameLabel.backgroundColor = [UIColor clearColor];
    opinionTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * opinionDateTitleLabel = [[UILabel alloc] init];
    opinionDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    opinionDateTitleLabel.textColor = kTitleLabelTextColor;
    opinionDateTitleLabel.backgroundColor = [UIColor clearColor];
    opinionDateTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * opinionDateLabel = [[UILabel alloc] init];
    opinionDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    opinionDateLabel.textColor = kOpinionDateLabelTextColor;
    opinionDateLabel.numberOfLines = 0;
    opinionDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionDateLabel.backgroundColor = [UIColor clearColor];
    opinionDateLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * planDateTitleLabel = [[UILabel alloc] init];
    planDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    planDateTitleLabel.textColor = kTitleLabelTextColor;
    planDateTitleLabel.backgroundColor = [UIColor clearColor];
    planDateTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * planDateLabel = [[UILabel alloc] init];
    planDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    planDateLabel.textColor = kOpinionDateLabelTextColor;
    planDateLabel.numberOfLines = 0;
    planDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    planDateLabel.backgroundColor = [UIColor clearColor];
    planDateLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * conclusionTitleLabel = [[UILabel alloc] init];
    conclusionTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    conclusionTitleLabel.textColor = kTitleLabelTextColor;
    conclusionTitleLabel.numberOfLines = 0;
    conclusionTitleLabel.backgroundColor = [UIColor clearColor];
    conclusionTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * conclusionLabel = [[UILabel alloc] init];
    conclusionLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    conclusionLabel.textColor = kConclusionLabelTextColor;
    conclusionLabel.numberOfLines = 0;
    conclusionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    conclusionLabel.backgroundColor = [UIColor clearColor];
    conclusionLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * jeTitleLabel = [[UILabel alloc] init];
    jeTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    jeTitleLabel.textColor = kTitleLabelTextColor;
    jeTitleLabel.numberOfLines = 0;
    jeTitleLabel.backgroundColor = [UIColor clearColor];
    jeTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * jeLabel = [[UILabel alloc] init];
    jeLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    jeLabel.textColor = kApprovedByNameLabelTextColor;
    jeLabel.numberOfLines = 0;
    jeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    jeLabel.backgroundColor = [UIColor clearColor];
    jeLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * unitLabel = [[UILabel alloc] init];
    unitLabel.font = [UIFont systemFontOfSize:kUnitLabelFontSize];
    unitLabel.textColor = kUnitLabelTextColor;
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel * approvedFlagTitleLabel = [[UILabel alloc] init];
    approvedFlagTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    approvedFlagTitleLabel.textColor = kTitleLabelTextColor;
    approvedFlagTitleLabel.numberOfLines = 0;
    approvedFlagTitleLabel.backgroundColor = [UIColor clearColor];
    approvedFlagTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * approvedFlagLabel = [[UILabel alloc] init];
    approvedFlagLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    approvedFlagLabel.textColor = kConclusionLabelTextColor;
    approvedFlagLabel.numberOfLines = 0;
    approvedFlagLabel.lineBreakMode = NSLineBreakByWordWrapping;
    approvedFlagLabel.backgroundColor = [UIColor clearColor];
    approvedFlagLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * editByNameTitleLabel = [[UILabel alloc] init];
    editByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    editByNameTitleLabel.textColor = kTitleLabelTextColor;
    editByNameTitleLabel.numberOfLines = 0;
    editByNameTitleLabel.backgroundColor = [UIColor clearColor];
    editByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * editByNameLabel = [[UILabel alloc] init];
    editByNameLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    editByNameLabel.textColor = kConclusionLabelTextColor;
    editByNameLabel.numberOfLines = 0;
    editByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    editByNameLabel.backgroundColor = [UIColor clearColor];
    editByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * sprTitleLabel = [[UILabel alloc] init];
    sprTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    sprTitleLabel.textColor = kTitleLabelTextColor;
    sprTitleLabel.numberOfLines = 0;
    sprTitleLabel.backgroundColor = [UIColor clearColor];
    sprTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * approvedbByNameTitleLabel = [[UILabel alloc] init];
    approvedbByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    approvedbByNameTitleLabel.textColor = kTitleLabelTextColor;
    approvedbByNameTitleLabel.numberOfLines = 0;
    approvedbByNameTitleLabel.backgroundColor = [UIColor clearColor];
    approvedbByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * approvedbByNameLabel = [[UILabel alloc] init];
    approvedbByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    approvedbByNameLabel.textColor = kApprovedByNameLabelTextColor;
    approvedbByNameLabel.numberOfLines = 0;
    approvedbByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    approvedbByNameLabel.backgroundColor = [UIColor clearColor];
    approvedbByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    opinionTypeNameLabel.text = [NSString stringWithFormat:@"方案类型：%@",model.status];
    opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace, kOpinionTypeNameLabelFontSize);
    
    planDateTitleLabel.text = @"日 期";
    [planDateTitleLabel sizeToFit];
    planDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, planDateTitleLabel.size.width, kTitleLabelFontSize);
    
    planDateLabel.text = !model.planDate||[model.planDate length] <= 0?@" ":model.planDate;
    CGSize planDateLabelSize = [planDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    planDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, planDateLabelSize.height);
    
    opinionDateTitleLabel.text = @"内 容";
    [opinionDateTitleLabel sizeToFit];
    opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(planDateLabel.frame) + kLabelTopSpace, opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    
    opinionDateLabel.text = !model.planDesc||[model.planDesc length] <= 0?@" ":model.planDesc;
    CGSize opinionDateLabelSize = [opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    opinionDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(planDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, opinionDateLabelSize.height);
    
    conclusionTitleLabel.text = @"币 种";
    [conclusionTitleLabel sizeToFit];
    conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, conclusionTitleLabel.size.width, kTitleLabelFontSize);
    
    conclusionLabel.text = !model.currency||[model.currency length] <= 0?@" ":model.currency;
    CGSize conclusionLabelSize = [conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    conclusionLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, conclusionLabelSize.height);
    
    jeTitleLabel.text = @"金 额";
    [jeTitleLabel sizeToFit];
    jeTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace, jeTitleLabel.size.width, kTitleLabelFontSize);
    
    unitLabel.text = @"(￥万元/$ M)";
    [unitLabel sizeToFit];
    unitLabel.frame = CGRectMake(Screen_Width - kLabelLeftSpace - planDateLabel.size.width, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace + 1, unitLabel.size.width, kUnitLabelFontSize);
    
    jeLabel.text = !model.amt||[model.amt length] <= 0?@" ":model.amt;
    jeLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, kApprovedByNameLabelFontSize);
    
    approvedFlagTitleLabel.text = @"通 过";
    [approvedFlagTitleLabel sizeToFit];
    approvedFlagTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(jeLabel.frame) + kLabelTopSpace, approvedFlagTitleLabel.size.width, kTitleLabelFontSize);
    
    approvedFlagLabel.text = !model.approvedFlag||[model.approvedFlag length] <= 0?@" ":model.approvedFlag;
    CGSize approvedFlagLabelSize = [approvedFlagLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    approvedFlagLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(jeLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedFlagLabelSize.height);
    
    editByNameTitleLabel.text = @"维护人";
    [editByNameTitleLabel sizeToFit];
    editByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(approvedFlagLabel.frame) + kLabelTopSpace, editByNameTitleLabel.size.width, kTitleLabelFontSize);
    
    editByNameLabel.text = !model.editByName||[model.editByName length] <= 0?@" ":model.editByName;
    CGSize editByNameLabelSize = [editByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    editByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(approvedFlagLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, editByNameLabelSize.height);
    
    approvedbByNameTitleLabel.text = @"审批人";
    [approvedbByNameTitleLabel sizeToFit];
    approvedbByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(editByNameLabel.frame) + kLabelTopSpace, approvedbByNameTitleLabel.size.width, kTitleLabelFontSize);
    
    approvedbByNameLabel.text = !model.approvedByName||[model.approvedByName length] <= 0?@" ":model.approvedByName;
    CGSize approvedbByNameLabelSize = [approvedbByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    approvedbByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(editByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedbByNameLabelSize.height);
    
    return CGRectGetMaxY(approvedbByNameLabel.frame) + kLabelTopSpace;
}

- (void)wyspBtnClick{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确定本条信息的准确性！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat:@"%@/project/detail/approve/invest", urlPrefix];
        NSMutableDictionary * params = @{}.mutableCopy;
        [params setValue:self.model.planId forKey:@"planId"];
        [HttpTool postWithPath:url params:params success:^(id JSON) {
            if ([JSON[@"status"] integerValue] == 200) {
                if (self.spwcCallBack) {
                    self.spwcCallBack();
                }
            }else{
                TTAlert(JSON[@"msg"]);
            }
        } failure:^(NSError *error) {
            CXAlert(KNetworkFailRemind);
        }];
    }
}

@end
