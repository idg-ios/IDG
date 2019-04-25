//
//  SDRootTopView.m
//  SDMarketingManagement
//
//  Created by fanzhong on 15/4/25.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootTopView.h"
#import "NSString+TextHelper.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"

#define kLeftButtonTag 10001
#define kRightButtonTag 20001
#define kRightButton2Tag 20002

@implementation SDRootTopView

- (void)setTopLogoImageViewShowOrHidden:(BOOL)bl {
    self.topLogoImageView.hidden = bl;
}

- (void)setNavTitle:(NSString *)title {
    _navTitleLabel.text = title;
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navTitleLabel.font = [UIFont systemFontOfSize:SDNavgationBarTitleFont];
    _navTitleLabel.textColor = SDNavgationBarTitleColor;
    _navTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setAttributeNavTitle:(NSString *)title withInteger:(int)length {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName: SDNavgationBarTitleColor,
                    NSFontAttributeName: [UIFont fontWithName:@"Arial" size:SDNavgationBarTitleFont]}
                          range:NSMakeRange(0, title.length - length)];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName: SDNavgationBarTitleColor,
                    NSFontAttributeName: [UIFont fontWithName:@"Arial" size:10.f]}
                          range:NSMakeRange(title.length - length, length)];
    _navTitleLabel.attributedText = attributeStr;
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

/// 设置导航左边按钮.使用图片
- (void)setUpLeftBarItemImage:(UIImage *)leftImage addTarget:(id)target action:(SEL)action {
    if (NO == [target respondsToSelector:action]) {
        return;
    }
    [[self viewWithTag:kLeftButtonTag] removeFromSuperview];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:leftImage forState:UIControlStateNormal];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(leftBtn);
    leftBtn.tag = kLeftButtonTag;
    [self addSubview:leftBtn];

    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        make.centerY.equalTo(self.mas_bottom).mas_offset(-(44.f / 2));
        make.left.equalTo(self).mas_offset(10.f);
    }];
}

/// 设置导航右边按钮.使用文字
- (void)setUpRightBarItemTitle:(NSString *)rightTitle addTarget:(id)target action:(SEL)action {
    if (NO == [target respondsToSelector:action]) {
        return;
    }
    [self removeRightBarItem];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(rightBtn);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:SDNavigationBarButtonTitleLabelFont];
    rightBtn.tag = kRightButtonTag;
    [self addSubview:rightBtn];

    float ht = 40.f;

    CGSize size = [rightTitle sizeWithFont:rightBtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, ht)];

    NSDictionary *rightVal = @{
            @"wd": [NSNumber numberWithFloat:size.width + 10.f],
            @"ht": [NSNumber numberWithFloat:ht]
    };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightBtn(wd)]-15-|" options:0 metrics:rightVal views:NSDictionaryOfVariableBindings(rightBtn)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightBtn(ht)]-0-|" options:0 metrics:rightVal views:NSDictionaryOfVariableBindings(rightBtn)]];
}

/// 设置导航左边按钮.使用文字
- (void)setUpLeftBarItemTitle:(NSString *)leftTitle addTarget:(id)target action:(SEL)action {
    if (NO == [target respondsToSelector:action]) {
        return;
    }
    [[self viewWithTag:kLeftButtonTag] removeFromSuperview];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
    [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(leftBtn);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:SDNavigationBarButtonTitleLabelFont];
    leftBtn.tag = kLeftButtonTag;
    [self addSubview:leftBtn];

    float ht = 40.f;

    CGSize size = [leftTitle sizeWithFont:leftBtn.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, ht)];
    NSDictionary *leftVal = @{
            @"wd": [NSNumber numberWithFloat:size.width + 10.f],
            @"ht": [NSNumber numberWithFloat:ht]
    };

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[leftBtn(wd)]" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(leftBtn)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftBtn(ht)]-0-|" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(leftBtn)]];
}

/// 设置导航右边按钮.使用图片
- (void)setUpRightBarItemImage:(UIImage *)rightImage addTarget:(id)target action:(SEL)action {
    if (NO == [target respondsToSelector:action]) {
        return;
    }
    [self removeRightBarItem];

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage forState:UIControlStateNormal];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(rightBtn);
    rightBtn.tag = kRightButtonTag;
    [self addSubview:rightBtn];

    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        make.centerY.equalTo(self.mas_bottom).mas_offset(-(44.f / 2));
        make.right.equalTo(self).mas_offset(-10.f);
    }];
}

- (void)setUpRightBarItemImage2:(UIImage *)rightImage2 addTarget:(id)target action:(SEL)action {
    if (NO == [target respondsToSelector:action]) {
        return;
    }
    [[self viewWithTag:kRightButton2Tag] removeFromSuperview];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:rightImage2 forState:UIControlStateNormal];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(rightBtn);
    rightBtn.tag = kRightButton2Tag;
    [self addSubview:rightBtn];
    
    UIView *prevView = [self viewWithTag:kRightButtonTag];
    if (prevView) {
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(rightImage2.size);
            make.centerY.equalTo(self.mas_bottom).mas_offset(-(44.f / 2));
            make.right.equalTo(prevView.mas_left).mas_offset(-10.f);
        }];
    }
    else {
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(rightImage2.size);
            make.centerY.equalTo(self.mas_bottom).mas_offset(-(44.f / 2));
            make.right.equalTo(self).mas_offset(-10.f);
        }];
    }
}

- (void)setUpLeftBarItemGoBack {
    [self setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
}

- (void)removeRightBarItem {
    [[self viewWithTag:kRightButtonTag] removeFromSuperview];
}

- (void)removeRightBarItem2 {
    [[self viewWithTag:kRightButton2Tag] removeFromSuperview];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, Screen_Width, navHigh);
    self.backgroundColor = kMainGreenColor;
}

- (void)goBack {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
