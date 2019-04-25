//
//  CXListTableViewCell.m
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXListTableViewCell.h"
#import "Masonry.h"

@interface CXListTableViewCell ()

@end

@implementation CXListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _leftTopLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_leftTopLabel];

        _leftBottomLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_leftBottomLabel];

        _rightTopLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_rightTopLabel];

        _rightBottomLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_rightBottomLabel];

        CGFloat topBottomMargin = 1.f;
        CGFloat leftRightMargin = 10.f;
        CGFloat space = 2.f;

        [_leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY).offset(space);
            make.left.mas_equalTo(leftRightMargin);
            make.top.mas_equalTo(topBottomMargin);
        }];

        [_leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftRightMargin);
            make.top.equalTo(self.contentView.mas_centerY).offset(-space);
            make.bottom.equalTo(self.contentView).offset(topBottomMargin);
        }];

        [_rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY).offset(space);
            make.right.equalTo(self.contentView).offset(-leftRightMargin);
            make.top.mas_equalTo(topBottomMargin);
        }];

        [_rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(-space);
            make.right.equalTo(self.contentView).offset(-leftRightMargin);
            make.bottom.equalTo(self.contentView).offset(topBottomMargin);
        }];

        _leftBottomLabel.textColor = [UIColor lightGrayColor];
        _rightBottomLabel.textColor = [UIColor lightGrayColor];
        _rightTopLabel.textColor = [UIColor orangeColor];

        _leftTopLabel.font = kFontSizeForForm;
        _leftBottomLabel.font = kFontSizeForForm;
        _rightTopLabel.font = kFontSizeForForm;
        _rightBottomLabel.font = kFontSizeForForm;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
