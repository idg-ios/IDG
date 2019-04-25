//
//  CXIDGProjectStatusTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGProjectStatusTableViewCell.h"
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
#define kExpendImageWidth 18.0

@interface CXIDGProjectStatusTableViewCell()

@property (nonatomic, strong) CXIDGProjectStatusTableViewCellModel * model;
@property (nonatomic, strong) UILabel * opinionTypeNameLabel;
@property (nonatomic, strong) UIImageView * expandImageView;
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation CXIDGProjectStatusTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_expandImageView){
        [_expandImageView removeFromSuperview];
        _expandImageView = nil;
    }
    _expandImageView = [[UIImageView alloc] init];
    
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
    
    if(_contentLabel){
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    _contentLabel.textColor = kConclusionLabelTextColor;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXIDGProjectStatusTableViewCellModel:(CXIDGProjectStatusTableViewCellModel *)model;
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _expandImageView.frame = CGRectMake(Screen_Width - kLabelLeftSpace - kExpendImageWidth, (2*kLabelTopSpace + kOpinionTypeNameLabelFontSize - kExpendImageWidth)/2, kExpendImageWidth, kExpendImageWidth);
    if(_model.isExpand && _model.content && [_model.content length] > 0){
        _expandImageView.image = [UIImage imageNamed:@"arrow_retract"];
        _expandImageView.highlightedImage = [UIImage imageNamed:@"arrow_retract"];
        [self.contentView addSubview:_expandImageView];
    }else if(!_model.content || (_model.content && [_model.content length] <= 0)){
        _expandImageView.image = [UIImage imageNamed:@""];
        _expandImageView.highlightedImage = [UIImage imageNamed:@""];
    }else{
        _expandImageView.image = [UIImage imageNamed:@"arrow_spread"];
        _expandImageView.highlightedImage = [UIImage imageNamed:@"arrow_spread"];
        [self.contentView addSubview:_expandImageView];
    }

    _opinionTypeNameLabel.text = !_model.title||[_model.title length] <= 0?@" ":_model.title;
    [_opinionTypeNameLabel sizeToFit];
    _opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace - 20 - kLabelLeftSpace, kOpinionTypeNameLabelFontSize);
    [self.contentView addSubview:_opinionTypeNameLabel];
    
    if(_model.isExpand && _model.content && [_model.content length] > 0){
        _contentLabel.text = !_model.content||[_model.content length] <= 0?@" ":_model.content;
        CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kLabelLeftSpace, MAXFLOAT)];
        _contentLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(_opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kLabelLeftSpace, contentLabelSize.height);
        [self.contentView addSubview:_contentLabel];
    }
}

+ (CGFloat)getCXIDGConferenceInformationListTableViewCellHeightWithCXIDGProjectStatusTableViewCellModel:(CXIDGProjectStatusTableViewCellModel *)model
{
    UIImageView * expandImageView = [[UIImageView alloc] init];
    
    UILabel * opinionTypeNameLabel = [[UILabel alloc] init];
    opinionTypeNameLabel.font = [UIFont systemFontOfSize:kOpinionTypeNameLabelFontSize];
    opinionTypeNameLabel.textColor = kOpinionTypeNameLabelTextColor;
    opinionTypeNameLabel.numberOfLines = 0;
    opinionTypeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    opinionTypeNameLabel.backgroundColor = [UIColor clearColor];
    opinionTypeNameLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kConclusionLabelFontSize];
    contentLabel.textColor = kConclusionLabelTextColor;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    expandImageView.frame = CGRectMake(Screen_Width - kLabelLeftSpace - 20, kLabelTopSpace, 20, 10);

    opinionTypeNameLabel.text = !model.title||[model.title length] <= 0?@" ":model.title;
    [opinionTypeNameLabel sizeToFit];
    opinionTypeNameLabel.frame = CGRectMake(kLabelLeftSpace, kLabelTopSpace, Screen_Width - kLabelLeftSpace - 20 - kLabelLeftSpace, kOpinionTypeNameLabelFontSize);
    
    if(model.isExpand && model.content && [model.content length] > 0){
        contentLabel.text = !model.content||[model.content length] <= 0?@" ":model.content;
        CGSize contentLabelSize = [contentLabel sizeThatFits:CGSizeMake(Screen_Width - kLabelLeftSpace - kLabelLeftSpace, MAXFLOAT)];
        contentLabel.frame = CGRectMake(kLabelLeftSpace, CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace, Screen_Width - kLabelLeftSpace - kLabelLeftSpace, contentLabelSize.height);
        return CGRectGetMaxY(contentLabel.frame) + kLabelTopSpace;
    }
    return CGRectGetMaxY(opinionTypeNameLabel.frame) + kLabelTopSpace;
}

@end
