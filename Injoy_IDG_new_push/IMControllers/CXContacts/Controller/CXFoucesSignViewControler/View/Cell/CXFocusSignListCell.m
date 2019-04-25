//
//  CXFocusSignListCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXFocusSignListCell.h"

@interface CXFocusSignListCell()

@property (nonatomic, strong) UILabel * focusSignLabel;

@end

@implementation CXFocusSignListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    
    if(_focusSignLabel){
        [_focusSignLabel removeFromSuperview];
        _focusSignLabel = nil;
    }
    _focusSignLabel = [[UILabel alloc] init];
    _focusSignLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing, (SDMeCellHeight - SDChatterDisplayNameFont)/2, Screen_Width - SDHeadImageViewLeftSpacing*2, SDChatterDisplayNameFont);
    _focusSignLabel.textAlignment = NSTextAlignmentLeft;
    _focusSignLabel.backgroundColor = [UIColor clearColor];
    _focusSignLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _focusSignLabel.textColor = SDChatterDisplayNameColor;
    [self.contentView addSubview:_focusSignLabel];
    
}

- (void)setFocusSignModel:(CXFocusSignModel *)model
{
    self.focusSignLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.name,model.concernCount];
    [self.focusSignLabel sizeToFit];
}


@end
