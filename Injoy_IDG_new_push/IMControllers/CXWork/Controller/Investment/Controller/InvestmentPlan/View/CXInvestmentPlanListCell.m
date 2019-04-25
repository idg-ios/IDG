//
// Created by ^ on 2017/12/15.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXInvestmentPlanListCell.h"
#import "Masonry.h"
#import "CXInvestmentPlanModel.h"
#import "YYText.h"

@interface CXInvestmentPlanListCell ()
/// 红色背景
@property(strong, nonatomic) UIView *redView;
/// 方案类型
@property(strong, nonatomic) UILabel *typeLabel;
/// 日期
@property(strong, nonatomic) UILabel *timeLabel;
/// 内容
@property(strong, nonatomic) UILabel *contentLabel;
/// 币种
@property(strong, nonatomic) UILabel *currencyLabel;
/// 金额
@property(strong, nonatomic) UILabel *moneyLabel;
/// 金额单位
@property(strong, nonatomic) UILabel *unitLabel;
/// 通过
@property(strong, nonatomic) UILabel *approvedFlag;
/// 底部背景
@property(strong, nonatomic) UIView *bottomView;
@end

@implementation CXInvestmentPlanListCell

- (NSMutableAttributedString *)getAttrText:(NSString *)tempStr prefix:(NSString *)prefix {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempStr];
    attributedString.yy_font = kFontSizeForForm;
    [attributedString yy_setFont:kFontSizeForForm range:NSMakeRange(0, prefix.length)];
    [attributedString yy_setColor:kColorWithRGB(158.f, 158.f, 158.f) range:NSMakeRange(0, prefix.length)];
    return attributedString;
}

- (void)setAction:(id)obj {
    CXInvestmentPlanModel *model = obj;

    _typeLabel.text = [NSString stringWithFormat:@"方案类型：%zd", model.status];
    _timeLabel.text = [NSString stringWithFormat:@"%@", model.planDate];
    _contentLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"内 容：%@", model.currency] prefix:@"内 容："];
    _currencyLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"币 种："] prefix:@"币 种："];
    _moneyLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"金 额："] prefix:@"金 额："];
    _unitLabel.text = @"（万元/年）";
    _approvedFlag.attributedText = [self getAttrText:[NSString stringWithFormat:@"通 过：%@", model.approvedFlagVal] prefix:@"通 过："];
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

    /// 方案类型
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_right).offset(5.f);
        make.centerY.equalTo(_redView.mas_centerY);
        make.width.lessThanOrEqualTo(@200.f);
    }];

    /// 时间
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-leftMargin);
        make.centerY.equalTo(_redView.mas_centerY);
    }];

    /// 内容
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_left);
        make.top.equalTo(_redView.mas_bottom).offset(space);
        make.right.equalTo(self.contentView).offset(-leftMargin);
    }];

    /// 币种
    [self.currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(space);
    }];

    /// 金额
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_left);
        make.top.equalTo(_currencyLabel.mas_bottom).offset(space);
        make.width.lessThanOrEqualTo(@200.f);
    }];

    /// 单位
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-leftMargin);
        make.centerY.equalTo(_moneyLabel.mas_centerY);
    }];

    /// 通过
    [self.approvedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_left);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(space);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_approvedFlag.mas_bottom).offset(space);
        make.height.mas_equalTo(10.f);
        make.bottom.equalTo(self.contentView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_redView];

        /// 方案类型
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:18.f];
        [self.contentView addSubview:_typeLabel];

        /// 时间
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];

        /// 内容
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_contentLabel];

        /// 币种
        _currencyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_currencyLabel];

        /// 金额
        _moneyLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_moneyLabel];

        /// 金额单位
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = kColorWithRGB(158.f, 158.f, 158.f);
        _unitLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_unitLabel];

        /// 通过
        _approvedFlag = [[UILabel alloc] init];
        [self.contentView addSubview:_approvedFlag];

        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_bottomView];

        [self setViewAtuoLayout];
    }
    return self;
}

@end
