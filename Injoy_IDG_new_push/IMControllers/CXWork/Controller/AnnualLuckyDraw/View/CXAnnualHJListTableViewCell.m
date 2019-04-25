//
//  CXAnnualHJListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/10.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnualHJListTableViewCell.h"
#import "UIView+Category.h"
#import "CXIDGAnnualLuckyDrawViewController.h"
#import "UIImageView+EMWebCache.h"

@interface CXAnnualHJListTableViewCell()

@property (nonatomic, strong) CXPrizeOwnerListModel * model;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * accountLabel;

@end

@implementation CXAnnualHJListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_lineView){
        [_lineView removeFromSuperview];
        _lineView = nil;
    }
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor whiteColor];
    
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc] init];
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:AnnualItemListCellLabelFontSize];
    _nameLabel.textColor = kLabelTextColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_accountLabel){
        [_accountLabel removeFromSuperview];
        _accountLabel = nil;
    }
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.font = [UIFont systemFontOfSize:AnnualItemListCellLabelFontSize];
    _accountLabel.textColor = kLabelTextColor;
    _accountLabel.backgroundColor = [UIColor clearColor];
    _accountLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXPrizeOwnerListModel:(CXPrizeOwnerListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _lineView.frame = CGRectMake(AnnualItemListCellLabelLeftSpace, 0, Screen_Width - 2*kTableViewLeftSpace - 2*AnnualItemListCellLabelLeftSpace, kTableViewJMLBHeaderLineHeight);
    [self.contentView addSubview:_lineView];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:(_model.icon && ![_model.icon isKindOfClass:[NSNull class]])?_model.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _headImageView.frame = CGRectMake(AnnualItemListCellLabelLeftSpace + kIconLeftSpace, AnnualItemListCellLabelTopSpace - kHeadImageViewTopSpace, AnnualItemListCellLabelFontSize + 2*kHeadImageViewTopSpace, AnnualItemListCellLabelFontSize + 2*kHeadImageViewTopSpace);
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = _model.name;
    _nameLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace + kIconLeftSpace + kIconWidth, AnnualItemListCellLabelTopSpace, kNameWidth + kAccountWidth, AnnualItemListCellLabelFontSize);
    [self.contentView addSubview:_nameLabel];
}

@end
