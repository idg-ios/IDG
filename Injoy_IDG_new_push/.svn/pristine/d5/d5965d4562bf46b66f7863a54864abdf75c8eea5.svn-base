//
//  SDPersonCell.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/13.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDPersonCell.h"

@implementation SDPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.deptLabel = [[UILabel alloc] init];
    self.deptLabel.font = [UIFont systemFontOfSize:13];
    self.deptLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.deptLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(10, 5, 35, 35);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 10, 200, 30);

    CGPoint imageViewCenter = self.imageView.center;
    imageViewCenter.y = self.contentView.center.y;
    self.imageView.center = imageViewCenter;

    CGPoint textLabelCenter = self.textLabel.center;
    textLabelCenter.y = self.contentView.center.y;
    self.textLabel.center = textLabelCenter;
    
    self.deptLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 190, 10, 70, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
