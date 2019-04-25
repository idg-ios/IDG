//
//  CXMiddleActionSheetSelectViewCell.m
//  InjoyERP
//
//  Created by wtz on 17/1/17.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMiddleActionSheetSelectViewCell.h"

#define kDataLeftSpace 10.0

#define kDataLabelFontSize 15.0

#define kSelectedImageRightSpace 10.0

#define kSelectedImageWidth 22.0

#define kWhiteBackViewLeftSpace ((Screen_Width - kDialogWidth)/2)

#define kCXMiddleActionSheetSelectCellWidth (Screen_Width - 2*kWhiteBackViewLeftSpace)

@interface CXMiddleActionSheetSelectViewCell()

@property (nonatomic, strong) NSString * data;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, strong) UILabel * dataLabel;
@property (nonatomic, strong) UIImageView * selectStateImageView;

@end

@implementation CXMiddleActionSheetSelectViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_selectStateImageView){
        [_selectStateImageView removeFromSuperview];
        _selectStateImageView = nil;
    }
    _selectStateImageView = [[UIImageView alloc] init];
    _selectStateImageView.frame = CGRectMake(kCXMiddleActionSheetSelectCellWidth - (kSelectedImageRightSpace + kSelectedImageWidth), (kCellHeight - kSelectedImageWidth)/2, kSelectedImageWidth, kSelectedImageWidth);
    
    
    if(_dataLabel){
        [_dataLabel removeFromSuperview];
        _dataLabel = nil;
    }
    _dataLabel = [[UILabel alloc] init];
    _dataLabel.frame = CGRectMake(kDataLeftSpace, (kCellHeight - kDataLabelFontSize)/2, kCXMiddleActionSheetSelectCellWidth - (kSelectedImageRightSpace*2 + kSelectedImageWidth) - kDataLeftSpace, kDataLabelFontSize);
    _dataLabel.textAlignment = NSTextAlignmentLeft;
    _dataLabel.backgroundColor = [UIColor clearColor];
    _dataLabel.font = [UIFont systemFontOfSize:kDataLabelFontSize];
}

- (void)setData:(NSString *)data AndIsSelected:(BOOL)isSelected
{
    self.data = data;
    self.isSelected = isSelected;
    [self layoutUI];
}

- (void)layoutUI
{
    _dataLabel.text = _data;
    [self.contentView addSubview:_dataLabel];
    
    if(self.isSelected){
        _selectStateImageView.image = [UIImage imageNamed:@"onSelected"];
        _selectStateImageView.highlightedImage = [UIImage imageNamed:@"onSelected"];
    }else{
        _selectStateImageView.image = [UIImage imageNamed:@"outSelected"];
        _selectStateImageView.highlightedImage = [UIImage imageNamed:@"outSelected"];
    }
    [self.contentView addSubview:_selectStateImageView];
}

@end
