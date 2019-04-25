//
//  SDIMSearchTelephoneCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/6/3.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMSearchTelephoneCell.h"
#import "UIImageView+EMWebCache.h"

@interface SDIMSearchTelephoneCell()

@property (nonatomic, strong) SDCompanyUserModel * model;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * groupLabel;

@end

@implementation SDIMSearchTelephoneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_groupLabel){
        [_groupLabel removeFromSuperview];
        _groupLabel = nil;
    }
    _groupLabel = [[UILabel alloc] init];
    _groupLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, Screen_Width - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth) - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
    _groupLabel.textAlignment = NSTextAlignmentLeft;
    _groupLabel.backgroundColor = [UIColor clearColor];
    _groupLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
}

- (void)setUserModel:(SDCompanyUserModel *)model;
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon]  placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    _groupLabel.text = _model.realName;
    [self.contentView addSubview:_groupLabel];
}


@end
