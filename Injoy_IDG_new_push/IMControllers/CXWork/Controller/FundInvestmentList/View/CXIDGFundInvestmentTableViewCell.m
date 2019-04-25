//
//  CXIDGFundInvestmentTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGFundInvestmentTableViewCell.h"
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

#define kRmbCostLabelLeftSpace (kLabelLeftSpace + kTitleLabelFontSize*8.0)

#define kGrowthLabelWidth 100.0

@interface CXIDGFundInvestmentTableViewCell()

@property (nonatomic, strong) CXFundInvestmentListModel * model;
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
@property (nonatomic, strong) UILabel * CNYTitleLabel;
@property (nonatomic, strong) UILabel * rmbCostLabel;
@property (nonatomic, strong) UILabel * rmbGrowthLabel;
@property (nonatomic, strong) UILabel * USDTitleLabel;
@property (nonatomic, strong) UILabel * usdCostLabel;
@property (nonatomic, strong) UILabel * usdGrowthLabel;

@end

@implementation CXIDGFundInvestmentTableViewCell

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
    
    if(_CNYTitleLabel){
        [_CNYTitleLabel removeFromSuperview];
        _CNYTitleLabel = nil;
    }
    _CNYTitleLabel = [[UILabel alloc] init];
    _CNYTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _CNYTitleLabel.textColor = kTitleLabelTextColor;
    _CNYTitleLabel.backgroundColor = [UIColor clearColor];
    _CNYTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_rmbCostLabel){
        [_rmbCostLabel removeFromSuperview];
        _rmbCostLabel = nil;
    }
    _rmbCostLabel = [[UILabel alloc] init];
    _rmbCostLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    _rmbCostLabel.textColor = kOpinionDateLabelTextColor;
    _rmbCostLabel.backgroundColor = [UIColor clearColor];
    _rmbCostLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_rmbGrowthLabel){
        [_rmbGrowthLabel removeFromSuperview];
        _rmbGrowthLabel = nil;
    }
    _rmbGrowthLabel = [[UILabel alloc] init];
    _rmbGrowthLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    _rmbGrowthLabel.textColor = kOpinionDateLabelTextColor;
    _rmbGrowthLabel.backgroundColor = [UIColor clearColor];
    _rmbGrowthLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_USDTitleLabel){
        [_USDTitleLabel removeFromSuperview];
        _USDTitleLabel = nil;
    }
    _USDTitleLabel = [[UILabel alloc] init];
    _USDTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _USDTitleLabel.textColor = kTitleLabelTextColor;
    _USDTitleLabel.backgroundColor = [UIColor clearColor];
    _USDTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_usdCostLabel){
        [_usdCostLabel removeFromSuperview];
        _usdCostLabel = nil;
    }
    _usdCostLabel = [[UILabel alloc] init];
    _usdCostLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _usdCostLabel.textColor = kConclusionLabelTextColor;
    _usdCostLabel.backgroundColor = [UIColor clearColor];
    _usdCostLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_usdGrowthLabel){
        [_usdGrowthLabel removeFromSuperview];
        _usdGrowthLabel = nil;
    }
    _usdGrowthLabel = [[UILabel alloc] init];
    _usdGrowthLabel.font = [UIFont systemFontOfSize:kOpinionDateLabelFontSize];
    _usdGrowthLabel.textColor = kOpinionDateLabelTextColor;
    _usdGrowthLabel.backgroundColor = [UIColor clearColor];
    _usdGrowthLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXFundInvestmentListModel:(CXFundInvestmentListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _opinionTypeNameLabel.text = @"累计投资及估值增长";
    CGSize opinionTypeNameLabelSize = [_opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    _opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace, opinionTypeNameLabelSize.height);
    [self.contentView addSubview:_opinionTypeNameLabel];
    
    _CNYTitleLabel.text = @"CNY  ";
    [_CNYTitleLabel sizeToFit];
    _CNYTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, _CNYTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_CNYTitleLabel];
    
    _rmbCostLabel.text = !_model.rmbCost||[_model.rmbCost length] <= 0?@" ":_model.rmbCost;
    _rmbCostLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kGrowthLabelWidth - kRmbCostLabelLeftSpace, kTitleLabelFontSize);
    [self.contentView addSubview:_rmbCostLabel];
    
    _rmbGrowthLabel.text = !_model.rmbGrowth||[_model.rmbGrowth length] <= 0?@" ":_model.rmbGrowth;
    _rmbGrowthLabel.frame = CGRectMake(Screen_Width - kGrowthLabelWidth, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, kGrowthLabelWidth, kTitleLabelFontSize);
    [self.contentView addSubview:_rmbGrowthLabel];
    
    _USDTitleLabel.text = @"USD  ";
    [_USDTitleLabel sizeToFit];
    _USDTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_CNYTitleLabel.frame) + kLabelTopSpace, _USDTitleLabel.size.width, kTitleLabelFontSize);
    [self.contentView addSubview:_USDTitleLabel];
    
    _usdCostLabel.text = !_model.usdCost||[_model.usdCost length] <= 0?@" ":_model.usdCost;
    _usdCostLabel.frame = CGRectMake(kRmbCostLabelLeftSpace, CGRectGetMaxY(_CNYTitleLabel.frame) + kLabelTopSpace, Screen_Width - kGrowthLabelWidth - kRmbCostLabelLeftSpace, kTitleLabelFontSize);
    [self.contentView addSubview:_usdCostLabel];
    
    _usdGrowthLabel.text = !_model.usdGrowth||[_model.usdGrowth length] <= 0?@" ":_model.usdGrowth;
    _usdGrowthLabel.frame = CGRectMake(Screen_Width - kGrowthLabelWidth, CGRectGetMaxY(_CNYTitleLabel.frame) + kLabelTopSpace, kGrowthLabelWidth, kTitleLabelFontSize);
    [self.contentView addSubview:_usdGrowthLabel];
}

+ (CGFloat)getCXIDGFundInvestmentTableViewCellHeightWithCXFundInvestmentListModel:(CXFundInvestmentListModel *)model
{
    UILabel * opinionTypeNameLabel = [[UILabel alloc] init];
    opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    opinionTypeNameLabel.numberOfLines = 0;
    opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionTypeNameLabel.text = @"累计投资及估值增长";
    CGSize opinionTypeNameLabelSize = [opinionTypeNameLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace, MAXFLOAT)];
    opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace, opinionTypeNameLabelSize.height);
    
    UILabel * CNYTitleLabel = [[UILabel alloc] init];
    CNYTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    CNYTitleLabel.text = @"CNY  ";
    [CNYTitleLabel sizeToFit];
    CNYTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, CNYTitleLabel.size.width, kTitleLabelFontSize);
    
    UILabel * USDTitleLabel = [[UILabel alloc] init];
    USDTitleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    USDTitleLabel.text = @"USD  ";
    [USDTitleLabel sizeToFit];
    USDTitleLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(CNYTitleLabel.frame) + kLabelTopSpace, USDTitleLabel.size.width, kTitleLabelFontSize);
    
    return CGRectGetMaxY(USDTitleLabel.frame) + kLabelTopSpace;
}

@end
