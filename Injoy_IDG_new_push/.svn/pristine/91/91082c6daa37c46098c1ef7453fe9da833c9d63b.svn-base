//
// Created by ^ on 2017/10/26.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXMoneyView.h"
#import "CXEditLabel.h"
#import "Masonry.h"
#import "YYText.h"

@interface CXMoneyView ()
@property(strong, nonatomic) CXEditLabel *moneyLabel;
@end

@implementation CXMoneyView

- (void)setViewEditOrNot:(BOOL)bl {
    self.moneyLabel.allowEditing = bl;
    self.moneyLabel.showDropdown = bl;
}

- (NSString *)bigMoneyVal {
    return self.moneyLabel.content;
}

- (void)setMoney:(NSString *)money {
    self.moneyLabel.content = money;
}

- (void)setUpSubViews {
    CGFloat lineHeight = 2.f;

    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];

    NSRange range = NSMakeRange(2, 5);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"金额 (大写)："];
    attributedString.yy_font = kFontSizeForDetail;
    attributedString.yy_alignment = NSTextAlignmentLeft;
    [attributedString yy_setColor:[UIColor lightGrayColor] range:range];
    [attributedString yy_setFont:[UIFont systemFontOfSize:12.f] range:range];
    titleLabel.attributedText = attributedString;

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, kLineHeight) text:attributedString];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(5.f);
        make.bottom.equalTo(self).offset(-lineHeight);
        make.width.mas_equalTo(textLayout.textBoundingSize.width);
    }];

    self.moneyLabel = [[CXEditLabel alloc] initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, kLineHeight}];
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.top.right.equalTo(self);
        make.bottom.equalTo(self).offset(-lineHeight);
    }];

    // 底部线条
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(lineHeight);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, kLineHeight}]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubViews];
        [self setViewEditOrNot:NO];
    }
    return self;
}

@end