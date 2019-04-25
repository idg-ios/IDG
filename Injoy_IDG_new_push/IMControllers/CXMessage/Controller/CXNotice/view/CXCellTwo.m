//
//  CXCellTwo.m
//  InjoyYJ1
//
//  Created by admin on 17/7/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXCellTwo.h"
#import "Masonry.h"

@interface CXCellTwo()
{
    Boolean showFourthLabel;
}

@end

@implementation CXCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier showFourthLabel:(Boolean)isShow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        showFourthLabel = isShow;
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    
    
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
    if (showFourthLabel) {
        [self.contentView addSubview:self.fourthLabel];
    }
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineLabel];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
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
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(Screen_Width-85);
    }];
    if (showFourthLabel) {
        [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-5);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
        }];
    }
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(Screen_Width);
    }];
}

@end
