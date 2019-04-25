//
//  SDIMSelectDepartmentCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/5.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMSelectDepartmentCell.h"

@interface SDIMSelectDepartmentCell()

@property (nonatomic, strong) NSString * departmentName;
@property (nonatomic) BOOL selct;
@property (nonatomic,strong) UILabel * departmentNameLabel;
@property (nonatomic,strong) UIImageView * selectedImageView;

@end

@implementation SDIMSelectDepartmentCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _departmentName = [NSString stringWithFormat:@""];
        _selct = NO;
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_departmentNameLabel){
        [_departmentNameLabel removeFromSuperview];
        _departmentNameLabel = nil;
    }
    _departmentNameLabel = [[UILabel alloc] init];
    _departmentNameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDCellHeight - SDChatterDisplayNameFont)/2, 300, SDChatterDisplayNameFont);
    _departmentNameLabel.textAlignment = NSTextAlignmentLeft;
    _departmentNameLabel.backgroundColor = [UIColor clearColor];
    _departmentNameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    
    if(_selectedImageView){
        [_selectedImageView removeFromSuperview];
        _selectedImageView = nil;
    }
    _selectedImageView = [[UIImageView alloc] init];
    _selectedImageView.frame = CGRectMake(Screen_Width - 15 - SDHeadImageViewLeftSpacing - 20, (SDCellHeight - 20)/2, 20, 20);
    if(_selct){
        _selectedImageView.image = [UIImage imageNamed:@"selected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"selected"];
    }else{
        _selectedImageView.image = [UIImage imageNamed:@"unSelected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"unSelected"];
    }
}

- (void)setDepartmentName:(NSString *)departmentName AndSelected:(BOOL)selected
{
    _departmentName = departmentName;
    _selct = selected;
    [self layoutUI];
}

- (void)layoutUI
{
    _departmentNameLabel.text = _departmentName;
    [self.contentView addSubview:_departmentNameLabel];
    
    if(_selct){
        _selectedImageView.image = [UIImage imageNamed:@"selected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"selected"];
    }else{
        _selectedImageView.image = [UIImage imageNamed:@"unSelected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"unSelected"];
    }
    [self.contentView addSubview:_selectedImageView];
}

@end
