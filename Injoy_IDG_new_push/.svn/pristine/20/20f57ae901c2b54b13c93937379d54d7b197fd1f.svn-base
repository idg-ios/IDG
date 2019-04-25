//
// Created by ^ on 2017/12/14.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXConferenceInformationListCell.h"
#import "Masonry.h"
#import "CXConferenceInformationModel.h"
#import "YYText.h"

@interface CXConferenceInformationListCell ()
/// 红色背景
@property(strong, nonatomic) UIView *redView;
/// 日期
@property(strong, nonatomic) UILabel *timeLabel;
/// 结论
@property(strong, nonatomic) UILabel *contentLabel;
/// 审批人
@property(strong, nonatomic) UILabel *personLabel;
/// 会议类型
@property(strong, nonatomic) UILabel *typeLabel;
/// 底部背景
@property(strong, nonatomic) UIView *bottomView;
@end

@implementation CXConferenceInformationListCell

#pragma mark - function

- (NSMutableAttributedString *)getAttrText:(NSString *)tempStr prefix:(NSString *)prefix {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempStr];
    attributedString.yy_font = kFontSizeForForm;
    [attributedString yy_setFont:kFontSizeForForm range:NSMakeRange(0, prefix.length)];
    [attributedString yy_setColor:kColorWithRGB(158.f, 158.f, 158.f) range:NSMakeRange(0, prefix.length)];
    return attributedString;
}

- (void)setAction:(id)obj {
    CXConferenceInformationModel *model = obj;
    self.timeLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"日 期：%@", model.opinionDate] prefix:@"日 期："];
    self.contentLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"结 论：%@", model.conclusion] prefix:@"结 论："];
    self.personLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"审批人：%@", model.approvedByName] prefix:@"审批人："];
    self.typeLabel.text = [NSString stringWithFormat:@"%@", model.opinionTypeName];
}

- (void)setViewAtuoLayout {
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 15.f;
    CGFloat space = 10.f;

    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(leftMargin);
        make.top.equalTo(self.contentView).offset(topMargin);
        make.size.mas_equalTo(CGSizeMake(5.f, 30.f));
    }];

    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_right).offset(5.f);
        make.centerY.equalTo(_redView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-leftMargin);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_left);
        make.top.equalTo(_typeLabel.mas_bottom).offset(space);
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-leftMargin);
        make.top.equalTo(_timeLabel.mas_bottom).offset(space);
    }];

    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(space);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_personLabel.mas_bottom).offset(space);
        make.height.mas_equalTo(10.f);
        make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /// 红色背景
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_redView];

        /// 日期
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFontSizeForForm;
        [self.contentView addSubview:_timeLabel];

        /// 结论
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.font = kFontSizeForForm;
        [self.contentView addSubview:_contentLabel];

        /// 审批人
        _personLabel = [[UILabel alloc] init];
        _personLabel.font = kFontSizeForForm;
        [self.contentView addSubview:_personLabel];

        /// 会议类型
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _typeLabel.numberOfLines = 0;
        _typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_typeLabel];

        /// 底部背景色
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_bottomView];

        [self setViewAtuoLayout];
    }
    return self;
}

@end