//
//  CXFundInvestmentListContractTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXFundInvestmentListContractTableViewCell.h"
#import "UIView+Category.h"

#define kLabelLeftSpace 16.0
#define kLabelTopSpace 16.0
#define kRedViewWidth 4.0
#define kRedViewRightSpace 5.0
#define kOpinionTypeNameLabelFontSize 18.0
#define kOpinionTypeNameLabelTextColor [UIColor blackColor]
#define kTitleLabelFontSize 14.0
#define kTitleLabelTextColor RGBACOLOR(119.0, 119.0, 119.0, 1.0)
#define kOpinionDateLabelFontSize 14.0
#define kOpinionDateLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kConclusionLabelFontSize 14.0
#define kConclusionLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kApprovedByNameLabelFontSize 14.0
#define kApprovedByNameLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kMultiplyLabelFontSize 14.0
#define kMultiplyLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)

#define kRmbCostLabelLeftSpace (kLabelLeftSpace + kTitleLabelFontSize*8.0)

@interface CXFundInvestmentListContractTableViewCell()

@property (nonatomic, strong) CXFundInvestmentListContractModel * model;
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
@property (nonatomic, strong) UILabel * opinionDateTitleLabel;
@property (nonatomic, strong) UILabel * opinionDateLabel;
@property (nonatomic, strong) UILabel * conclusionTitleLabel;
@property (nonatomic, strong) UILabel * conclusionLabel;
@property (nonatomic, strong) UILabel * approvedByNameTitleLabel;
@property (nonatomic, strong) UILabel * approvedByNameLabel;
@property (nonatomic, strong) UILabel * multiplyTitleLabel;
@property (nonatomic, strong) UILabel * multiplyLabel;

@end

@implementation CXFundInvestmentListContractTableViewCell

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
    
    if(_approvedByNameTitleLabel){
        [_approvedByNameTitleLabel removeFromSuperview];
        _approvedByNameTitleLabel = nil;
    }
    _approvedByNameTitleLabel = [[UILabel alloc] init];
    _approvedByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _approvedByNameTitleLabel.textColor = kTitleLabelTextColor;
    _approvedByNameTitleLabel.numberOfLines = 0;
    _approvedByNameTitleLabel.backgroundColor = [UIColor clearColor];
    _approvedByNameTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_approvedByNameLabel){
        [_approvedByNameLabel removeFromSuperview];
        _approvedByNameLabel = nil;
    }
    _approvedByNameLabel = [[UILabel alloc] init];
    _approvedByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    _approvedByNameLabel.textColor = kApprovedByNameLabelTextColor;
    _approvedByNameLabel.numberOfLines = 0;
    _approvedByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _approvedByNameLabel.backgroundColor = [UIColor clearColor];
    _approvedByNameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_multiplyTitleLabel){
        [_multiplyTitleLabel removeFromSuperview];
        _multiplyTitleLabel = nil;
    }
    _multiplyTitleLabel = [[UILabel alloc] init];
    _multiplyTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _multiplyTitleLabel.textColor = kTitleLabelTextColor;
    _multiplyTitleLabel.numberOfLines = 0;
    _multiplyTitleLabel.backgroundColor = [UIColor clearColor];
    _multiplyTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_multiplyLabel){
        [_multiplyLabel removeFromSuperview];
        _multiplyLabel = nil;
    }
    _multiplyLabel = [[UILabel alloc] init];
    _multiplyLabel.font = [UIFont systemFontOfSize:kMultiplyLabelFontSize];
    _multiplyLabel.textColor = kMultiplyLabelTextColor;
    _multiplyLabel.numberOfLines = 0;
    _multiplyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _multiplyLabel.backgroundColor = [UIColor clearColor];
    _multiplyLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXFundInvestmentListContractModel:(CXFundInvestmentListContractModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _opinionTypeNameLabel.text = !_model.fund||[_model.fund length] <= 0?@" ":_model.fund;
    CGSize opinionTypeNameLabelSize = [_opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace, opinionTypeNameLabelSize.height);
    [self.contentView addSubview:_opinionTypeNameLabel];
    
    _opinionDateTitleLabel.text = @"币 种";
    [_opinionDateTitleLabel sizeToFit];
    _opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, _opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_opinionDateTitleLabel];
    
    _opinionDateLabel.text = !_model.currency||[_model.currency length] <= 0?@" ":_model.currency;
    CGSize opinionDateLabelSize = [_opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _opinionDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, opinionDateLabelSize.height);
    [self.contentView addSubview:_opinionDateLabel];
    
    _conclusionTitleLabel.text = @"投资金额";
    [_conclusionTitleLabel sizeToFit];
    _conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, _conclusionTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_conclusionTitleLabel];
    
    _conclusionLabel.text = !_model.cost||[_model.cost length] <= 0?@" ":_model.cost;
    CGSize conclusionLabelSize = [_conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _conclusionLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, conclusionLabelSize.height);
    [self.contentView addSubview:_conclusionLabel];
    
    _approvedByNameTitleLabel.text = @"基金所占比股";
    [_approvedByNameTitleLabel sizeToFit];
    _approvedByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace, _approvedByNameTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_approvedByNameTitleLabel];
    
    _approvedByNameLabel.text = !_model.ownership||[_model.ownership length] <= 0?@" ":_model.ownership;
    CGSize approvedByNameLabelSize = [_approvedByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _approvedByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_conclusionLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedByNameLabelSize.height);
    [self.contentView addSubview:_approvedByNameLabel];
    
    _multiplyTitleLabel.text = @"倍 数";
    [_multiplyTitleLabel sizeToFit];
    _multiplyTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_approvedByNameLabel.frame) + kLabelTopSpace, _multiplyTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_multiplyTitleLabel];
    
    _multiplyLabel.text = !_model.multiply||[_model.multiply length] <= 0?@" ":_model.multiply;
    CGSize multiplyLabelSize = [_multiplyLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    _multiplyLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_approvedByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, multiplyLabelSize.height);
    [self.contentView addSubview:_multiplyLabel];
}

+ (CGFloat)getCXFundInvestmentListContractTableViewCellHeightWithCXFundInvestmentListContractModel:(CXFundInvestmentListContractModel *)model
{
    UIView * redView = [[UIView alloc] init];
    redView.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, kRedViewWidth, kOpinionTypeNameLabelFontSize);
    
    UILabel * opinionTypeNameLabel = [[UILabel alloc] init];
    opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    opinionTypeNameLabel.numberOfLines = 0;
    opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionTypeNameLabel.text = !model.fund||[model.fund length] <= 0?@"111 ":model.fund;
    CGSize opinionTypeNameLabelSize = [opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - (kLabelLeftSpace + kRedViewWidth + kRedViewRightSpace), MAXFLOAT)];
    opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace + kRedViewWidth + kRedViewRightSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace - (kLabelLeftSpace + kRedViewWidth + kRedViewRightSpace), opinionTypeNameLabelSize.height);
    
    UILabel * opinionDateTitleLabel = [[UILabel alloc] init];
    opinionDateTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    opinionDateTitleLabel.text = @"币 种";
    [opinionDateTitleLabel sizeToFit];
    opinionDateTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, opinionDateTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * opinionDateLabel = [[UILabel alloc] init];
    opinionDateLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    opinionDateLabel.numberOfLines = 0;
    opinionDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionDateLabel.text = !model.currency||[model.currency length] <= 0?@"111 ":model.currency;
    CGSize opinionDateLabelSize = [opinionDateLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    opinionDateLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, opinionDateLabelSize.height);
    
    UILabel * conclusionTitleLabel = [[UILabel alloc] init];
    conclusionTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    conclusionTitleLabel.text = @"投资金额";
    [conclusionTitleLabel sizeToFit];
    conclusionTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, conclusionTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * conclusionLabel = [[UILabel alloc] init];
    conclusionLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    conclusionLabel.numberOfLines = 0;
    conclusionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    conclusionLabel.text = !model.cost||[model.cost length] <= 0?@"111 ":model.cost;
    CGSize conclusionLabelSize = [conclusionLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    conclusionLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(opinionDateLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, conclusionLabelSize.height);
    
    UILabel * approvedByNameTitleLabel = [[UILabel alloc] init];
    approvedByNameTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    approvedByNameTitleLabel.text = @"基金所占比股";
    [approvedByNameTitleLabel sizeToFit];
    approvedByNameTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace, approvedByNameTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * approvedByNameLabel = [[UILabel alloc] init];
    approvedByNameLabel.font = [UIFont systemFontOfSize:kApprovedByNameLabelFontSize];
    approvedByNameLabel.numberOfLines = 0;
    approvedByNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    approvedByNameLabel.text = !model.ownership||[model.ownership length] <= 0?@"111 ":model.ownership;
    CGSize approvedByNameLabelSize = [approvedByNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    approvedByNameLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(conclusionLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, approvedByNameLabelSize.height);
    
    UILabel * multiplyTitleLabel = [[UILabel alloc] init];
    multiplyTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    multiplyTitleLabel.text = @"倍 数";
    [multiplyTitleLabel sizeToFit];
    multiplyTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(approvedByNameLabel.frame) + kLabelTopSpace, multiplyTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * multiplyLabel = [[UILabel alloc] init];
    multiplyLabel.font = [UIFont systemFontOfSize:kMultiplyLabelFontSize];
    multiplyLabel.numberOfLines = 0;
    multiplyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    multiplyLabel.text = !model.multiply||[model.multiply length] <= 0?@"111 ":model.multiply;
    CGSize multiplyLabelSize = [multiplyLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, MAXFLOAT)];
    multiplyLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(approvedByNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kRmbCostLabelLeftSpace, multiplyLabelSize.height);
    
    return CGRectGetMaxY(multiplyLabel.frame) + kLabelTopSpace;
}

@end
