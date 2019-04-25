//
//  CXMailCell.m
//  InjoyYJ1
//
//  Created by admin on 17/7/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMailCell.h"
#import "Masonry.h"

@implementation CXMailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    self.iconImageView = [[UIImageView alloc] initWithImage:Image(@"mail_unread")];
    [self.contentView addSubview:self.iconImageView];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.font = KCXCellOneTitleFontSize;
    self.firstLabel.textColor = [UIColor blackColor];
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.font = KCXCellOneTimeFontSize;
    [self.secondLabel setTextAlignment:NSTextAlignmentRight];
    self.secondLabel.textColor = [UIColor lightGrayColor];
    //self.timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.secondLabel];
    
    self.thirdLabel = [[UILabel alloc] init];
    self.thirdLabel.font = KCXCellOneTimeFontSize;
    self.thirdLabel.textColor = [UIColor lightGrayColor];
    //self.timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.thirdLabel];
    
    self.fourthLabel = [[UILabel alloc] init];
    self.fourthLabel.font = KCXCellOneTimeFontSize;
    self.fourthLabel.textColor = [UIColor lightGrayColor];
    [self.fourthLabel setTextAlignment:NSTextAlignmentRight];
    //self.timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.fourthLabel];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineLabel];
  
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(13);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_left).offset(10+20);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(Screen_Width-85);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_left).offset(10+20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(Screen_Width-85);
    }];
    [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(20);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(Screen_Width);
    }];
}

@end
