//
//  CXIDGGroupAddUsersTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGGroupAddUsersTableViewCell.h"
#import "UIView+Category.h"
#import "CXIDGAnnualLuckyDrawViewController.h"
#import "CXAnnualItemListTableViewCell.h"
#import "UIImageView+EMWebCache.h"

@interface CXIDGGroupAddUsersTableViewCell()

@property (nonatomic, strong) SDCompanyUserModel * model;
@property (nonatomic, strong) UIImageView * selectedImageView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic) NSInteger isSelected;

@end

@implementation CXIDGGroupAddUsersTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_selectedImageView){
        [_selectedImageView removeFromSuperview];
        _selectedImageView = nil;
    }
    _selectedImageView = [[UIImageView alloc] init];
    
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc] init];
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:AnnualItemListCellLabelFontSize];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
}

//1默认 2未选中 3选中
- (void)setUserModel:(SDCompanyUserModel *)model AndSelected:(NSInteger)selected
{
    _model = model;
    self.isSelected = selected;
    [self layoutUI];
}

- (void)layoutUI
{
    if(self.isSelected == 1){
        _selectedImageView.image = [UIImage imageNamed:@"AddUsers1"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"AddUsers1"];
    }else if(self.isSelected == 2){
        _selectedImageView.image = [UIImage imageNamed:@"AddUsers2"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"AddUsers2"];
    }else if(self.isSelected == 3){
        _selectedImageView.image = [UIImage imageNamed:@"AddUsers3"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"AddUsers3"];
    }
    _selectedImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont)/2, SDMainMessageFont, SDMainMessageFont);
    [self.contentView addSubview:_selectedImageView];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:(_model.icon && ![_model.icon isKindOfClass:[NSNull class]])?_model.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing + SDMainMessageFont + SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    [self.contentView addSubview:_headImageView];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.name];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDMainMessageFont) / 2, Screen_Width - CGRectGetMaxX(_headImageView.frame), SDMainMessageFont);
    [self.contentView addSubview:_titleLabel];
}

@end
