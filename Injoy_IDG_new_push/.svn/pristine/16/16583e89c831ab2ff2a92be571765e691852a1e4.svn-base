//
// Created by ^ on 2017/12/15.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXInvestmentAgreementListCell.h"
#import "Masonry.h"
#import "YYText.h"
#import "CXFundContractsModel.h"

@interface CXInvestmentAgreementListCell ()
/// 红色背景
@property(strong, nonatomic) UIView *redView;
/// 基金名称
@property(strong, nonatomic) UILabel *nameLabel;
/// 币种
@property(strong, nonatomic) UILabel *currencyLabel;
/// 投资金额
@property(strong, nonatomic) UILabel *moneyLabel;
/// 基金所占比股
@property(strong, nonatomic) UILabel *ratioLabel;
/// 倍数
@property(strong, nonatomic) UILabel *numberLabel;
/// 底部背景
@property(strong, nonatomic) UIView *bottomView;
@end

@implementation CXInvestmentAgreementListCell

#pragma mark - function

- (NSMutableAttributedString *)getAttrText:(NSString *)tempStr prefix:(NSString *)prefix {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempStr];
    attributedString.yy_font = kFontSizeForForm;
    [attributedString yy_setFont:kFontSizeForForm range:NSMakeRange(0, prefix.length)];
    [attributedString yy_setColor:kColorWithRGB(158.f, 158.f, 158.f) range:NSMakeRange(0, prefix.length)];
    return attributedString;
}

- (void)setAction:(id)obj {
    CXFundContractsModel *model = obj;

    self.nameLabel.text = @"和谐创新";
    self.currencyLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"币 种：%@", model.currency] prefix:@"币 种："];
    self.moneyLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"投资金额：%@", model.cost] prefix:@"投资金额："];
    self.ratioLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"基金所占比股：%@", model.ownership] prefix:@"基金所占比股："];
    self.numberLabel.attributedText = [self getAttrText:[NSString stringWithFormat:@"位 数：%@", model.multiply] prefix:@"位 数："];
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

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_redView.mas_right).offset(5.f);
        make.centerY.equalTo(_redView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-leftMargin);
    }];

    [_currencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset(space);
    }];

    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currencyLabel.mas_left);
        make.top.equalTo(_currencyLabel.mas_bottom).offset(space);
    }];

    [_ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyLabel.mas_left);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(space);
    }];

    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ratioLabel.mas_left);
        make.top.equalTo(_ratioLabel.mas_bottom).offset(space);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_numberLabel.mas_bottom).offset(space);
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

        /// 基金名称
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [self.contentView addSubview:_nameLabel];

        /// 币种
        _currencyLabel = [[UILabel alloc] init];
        _currencyLabel.font = kFontSizeForForm;
        _currencyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_currencyLabel];

        /// 投资金额
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = kFontSizeForForm;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_moneyLabel];

        /// 基金所占比股
        _ratioLabel = [[UILabel alloc] init];
        _ratioLabel.font = kFontSizeForForm;
        _ratioLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_ratioLabel];

        /// 倍数
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = kFontSizeForForm;
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_numberLabel];

        /// 底部背景色
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_bottomView];

        [self setViewAtuoLayout];
    }
    return self;
}

@end