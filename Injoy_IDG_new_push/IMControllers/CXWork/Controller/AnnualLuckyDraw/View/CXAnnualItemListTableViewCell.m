//
//  CXAnnualItemListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnualItemListTableViewCell.h"
#import "UIView+Category.h"
#import "CXIDGAnnualLuckyDrawViewController.h"

@interface CXAnnualItemListTableViewCell()

@property (nonatomic, strong) CXIDGCurrentAnnualItemListModel * model;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation CXAnnualItemListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
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

- (void)setCXIDGCurrentAnnualItemListModel:(CXIDGCurrentAnnualItemListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _titleLabel.text = [NSString stringWithFormat:@"%zd.%@",[_model.itemIndex integerValue],_model.name];
    _titleLabel.frame = CGRectMake(AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelTopSpace, Screen_Width - 2*kTableViewLeftSpace - AnnualItemListCellLabelLeftSpace, AnnualItemListCellLabelFontSize);
    [self.contentView addSubview:_titleLabel];
}

@end
