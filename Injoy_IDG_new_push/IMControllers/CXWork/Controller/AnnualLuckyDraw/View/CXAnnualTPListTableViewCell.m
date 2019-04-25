//
//  CXAnnualTPListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnualTPListTableViewCell.h"
#import "UIView+Category.h"
#import "CXIDGAnnualLuckyDrawViewController.h"
#import "CXAnnualItemListTableViewCell.h"

@interface CXAnnualTPListTableViewCell()

@property (nonatomic, strong) CXIDGCurrentAnnualItemListModel * model;
@property (nonatomic, strong) UIImageView * selectedImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic) BOOL isSelected;

@end

@implementation CXAnnualTPListTableViewCell

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
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:AnnualItemListCellLabelFontSize];
    _titleLabel.textColor = kLabelTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXIDGCurrentAnnualItemListModel:(CXIDGCurrentAnnualItemListModel *)model AndSelected:(BOOL)selected
{
    _model = model;
    _isSelected = selected;
    [self layoutUI];
}

- (void)layoutUI
{
    if(_isSelected){
        _selectedImageView.image = [UIImage imageNamed:@"nhselected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"nhselected"];
    }else{
        _selectedImageView.image = [UIImage imageNamed:@"nhunselect"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"nhunselect"];
    }
    _selectedImageView.frame = CGRectMake(AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelFontSize, AnnualItemListCellLabelFontSize);
    [self.contentView addSubview:_selectedImageView];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.name];
    _titleLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace + AnnualItemListCellLabelFontSize + AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace - AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelFontSize);
    [self.contentView addSubview:_titleLabel];
}
@end
