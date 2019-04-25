//
//  CXYMPersonInfoCell.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/25.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMPersonInfoCell.h"
#import "Masonry.h"
#import "CXYMAppearanceManager.h"

@implementation CXYMPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.centerY.mas_equalTo(0);
    }];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.textColor = [CXYMAppearanceManager textDeepGrayColor];
    _contentLabel.font = [CXYMAppearanceManager textNormalFont];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
    }];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [CXYMAppearanceManager textNormalColor];
    _titleLabel.font = [CXYMAppearanceManager textNormalFont];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0); make.left.mas_equalTo(self.leftImageView.mas_right).mas_offset([CXYMAppearanceManager appStyleMargin]);
        make.right.mas_equalTo(self.contentLabel.mas_left).mas_offset(0);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation CXYMPersonInfoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([CXYMAppearanceManager appStyleMargin]);
        make.centerY.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [CXYMAppearanceManager textNormalColor];
    _titleLabel.font = [CXYMAppearanceManager textNormalFont];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0); make.left.mas_equalTo(self.leftImageView.mas_right).mas_offset([CXYMAppearanceManager appStyleMargin]);
    }];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
        make.right.mas_equalTo(-[CXYMAppearanceManager appStyleMargin]);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
