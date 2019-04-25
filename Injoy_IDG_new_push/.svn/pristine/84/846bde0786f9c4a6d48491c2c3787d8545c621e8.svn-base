//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXProjectListCell.h"
#import "Masonry.h"
#import "CXProjectManagerModel.h"

@interface CXProjectListCell ()
/// 标题
@property(strong, nonatomic) UILabel *titleLabel;
/// 负责人
@property(strong, nonatomic) UILabel *personLabel;
/// 企业阶段
@property(strong, nonatomic) UILabel *statusLabel;
/// 所属行业
@property(strong, nonatomic) UILabel *tradeLabel;
/// 时间
@property(strong, nonatomic) UILabel *timeLabel;
@end

@implementation CXProjectListCell

#pragma mark - instance function

- (void)setAction:(id)obj {
    CXProjectManagerModel *projectManagerModel = obj;
    _titleLabel.text = projectManagerModel.projName;
    _personLabel.text = projectManagerModel.projManagerName;
    _statusLabel.text = projectManagerModel.business;
    _tradeLabel.text = projectManagerModel.induName;
}

- (void)setViewAtuoLayout {
    CGFloat margin = 10.f;

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(margin);
        make.top.equalTo(self.contentView.mas_top).offset(margin);
    }];

    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(margin);
    }];

    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_personLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-margin);
        make.top.equalTo(_personLabel.mas_bottom).offset(margin);
    }];

    [_tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLabel.mas_left);
        make.top.equalTo(_statusLabel.mas_bottom).offset(margin);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-margin).priorityHigh();
    }];
}

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIColor *bgColor = kColorWithRGB(158.f, 158.f, 158.f);

        /// 标题
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFontSizeForDetail;
        [self.contentView addSubview:_titleLabel];

        /// 负责人
        _personLabel = [[UILabel alloc] init];
        _personLabel.textColor = bgColor;
        _personLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_personLabel];

        /// 企业阶段
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = bgColor;
        _statusLabel.numberOfLines = 0;
        _statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _statusLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_statusLabel];

        /// 所属行业
        _tradeLabel = [[UILabel alloc] init];
        _tradeLabel.textColor = bgColor;
        _tradeLabel.font = kFontTimeSizeForForm;
        [self.contentView addSubview:_tradeLabel];

        [self setViewAtuoLayout];
    }
    return self;
}

@end