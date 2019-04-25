//
//  CXYMNormalItemCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNormalItemCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@implementation CXYMNormalItemCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    self.itemNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.itemNameLabel.textColor = [ CXYMAppearanceManager textNormalColor];
    self.itemNameLabel.font = [CXYMAppearanceManager textMediumFont];
    self.itemNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.itemNameLabel];
    [self.itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
    }];
    self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.width.height.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.itemNameLabel.mas_top).mas_offset(-5);
    }];
}
@end
