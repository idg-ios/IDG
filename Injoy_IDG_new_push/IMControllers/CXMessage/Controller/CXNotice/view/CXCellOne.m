//
//  CXCellOne.m
//  InjoyYJ1
//
//  Created by admin on 17/7/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXCellOne.h"
#import "Masonry.h"

@implementation CXCellOne

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.backgroundColor = [UIColor blueColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    //[self setFrame:CGRectMake(0, 0, Screen_Width, CXCellOneHeight)];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.font = KCXCellOneTitleFontSize;
    self.firstLabel.textColor = [UIColor blackColor];
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.font = KCXCellOneTimeFontSize;
    self.secondLabel.textColor = [UIColor lightGrayColor];
    [self.secondLabel setTextAlignment:NSTextAlignmentRight];
    //self.timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.secondLabel];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineLabel];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(Screen_Width-85);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(150);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(Screen_Width);
    }];
}

@end
