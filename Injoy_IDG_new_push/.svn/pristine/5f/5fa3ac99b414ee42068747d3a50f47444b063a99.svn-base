//
//  CXVersionsAlertView.m
//  SDMarketingManagement
//
//  Created by lancely on 6/16/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXVersionsAlertView.h"
#import "Masonry.h"
#import "UIColor+Category.h"
#import "UIView+Category.h"

// 按钮间距
#define kButtonMargin 1

@interface CXVersionsAlertView ()

/** 遮盖view */
@property (nonatomic, weak) UIView *cover;
/** 提示的view */
@property (nonatomic, weak) UIView *alertView;
/** 忽略按钮 */
@property (nonatomic, weak) UIButton *ignoreButton;
/** 更新按钮 */
@property (nonatomic, weak) UIButton *updateButton;

@end

@implementation CXVersionsAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setupView {
    UIView *rootView = KEY_WINDOW;
    [rootView addSubview:self];
    
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = kDialogCoverBackgroundColor;
    [rootView addSubview:cover];
    cover.frame = CGRectMake(0, 0, Screen_Width, Screen_Height + kTabbarSafeBottomMargin);
    self.cover = cover;
    
    CGSize contentSize = [self.content boundingRectWithSize:CGSizeMake(kDialogWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
    
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = kColorWithRGB(246, 246, 246);
    [rootView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertView.superview);
        make.width.mas_equalTo(kDialogWidth);
    }];
    self.alertView = alertView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = kDialogHeaderBackgroundColor;
    titleLabel.font = kDialogTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(alertView);
        make.height.mas_equalTo(kDialogHeaderHeight);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    //    contentLabel.text = self.content;
    contentLabel.textColor = titleLabel.textColor;
    contentLabel.font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 5;
    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.content attributes:@{NSParagraphStyleAttributeName : style}];
    [alertView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(alertView).offset(15);
        make.trailing.equalTo(alertView).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(contentSize.height + 30.0);
    }];
    
    UIButton *ignoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ignoreButton addTarget:self action:@selector(ignoreButtonTapAction) forControlEvents:UIControlEventTouchUpInside];
    //    [ignoreButton setBackgroundImage:kColorWithRGB(190, 190, 190).image forState:UIControlStateNormal];
    [ignoreButton setBackgroundColor:UIColorFromHex(0x595959)];
    [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ignoreButton setTitle:@"以后再说" forState:UIControlStateNormal];
    ignoreButton.titleLabel.font = kDialogButtonFont;
    [alertView addSubview:ignoreButton];//强制更新
    ignoreButton.alpha = .0;
    ignoreButton.userInteractionEnabled = NO;
    self.ignoreButton = ignoreButton;
    [ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(15);
        make.leading.bottom.equalTo(alertView);
        make.width.equalTo(alertView).multipliedBy(.5).offset(-kButtonMargin * .5);
        make.height.equalTo(titleLabel);
    }];
    
    UIButton *updateButton = (UIButton *)[ignoreButton duplicate];
    [updateButton addTarget:self action:@selector(updateButtonTapAction) forControlEvents:UIControlEventTouchUpInside];
    updateButton.clipsToBounds = YES;
    updateButton.layer.cornerRadius = 5;
    updateButton.alpha = 1;
    updateButton.userInteractionEnabled = YES;
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [alertView addSubview:updateButton];
    self.updateButton = updateButton;
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(alertView.mas_bottom).mas_offset(-20);
        make.leading.mas_equalTo(alertView.mas_leading).mas_offset(40);
        make.trailing.mas_equalTo(alertView.mas_trailing).mas_offset(-40);
        make.height.mas_equalTo(40);
    }];
}


- (void)setup {
    UIView *rootView = KEY_WINDOW;
    [rootView addSubview:self];
    
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = kDialogCoverBackgroundColor;
    [rootView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cover.superview);
    }];
    self.cover = cover;
    
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = kColorWithRGB(246, 246, 246);
    [rootView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertView.superview);
        make.width.mas_equalTo(kDialogWidth);
    }];
    self.alertView = alertView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = kDialogHeaderBackgroundColor;
    titleLabel.font = kDialogTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(alertView);
        make.height.mas_equalTo(kDialogHeaderHeight);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    //    contentLabel.text = self.content;
    contentLabel.textColor = titleLabel.textColor;
    contentLabel.font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 5;
    contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.content attributes:@{NSParagraphStyleAttributeName : style}];
    [alertView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(alertView).offset(15);
        make.trailing.equalTo(alertView).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.mas_greaterThanOrEqualTo(kDialogContentHeight - 30);
    }];
    
    UIButton *ignoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ignoreButton addTarget:self action:@selector(ignoreButtonTapAction) forControlEvents:UIControlEventTouchUpInside];
    //    [ignoreButton setBackgroundImage:kColorWithRGB(190, 190, 190).image forState:UIControlStateNormal];
    [ignoreButton setBackgroundColor:UIColorFromHex(0x595959)];
    [ignoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ignoreButton setTitle:@"以后再说" forState:UIControlStateNormal];
    ignoreButton.titleLabel.font = kDialogButtonFont;
    [alertView addSubview:ignoreButton];//强制更新
    ignoreButton.alpha = .0;
    ignoreButton.userInteractionEnabled = NO;
    self.ignoreButton = ignoreButton;
    [ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(15);
        make.leading.bottom.equalTo(alertView);
        make.width.equalTo(alertView).multipliedBy(.5).offset(-kButtonMargin * .5);
        make.height.equalTo(titleLabel);
    }];
    
    UIButton *updateButton = (UIButton *)[ignoreButton duplicate];
    [updateButton addTarget:self action:@selector(updateButtonTapAction) forControlEvents:UIControlEventTouchUpInside];
    updateButton.clipsToBounds = YES;
    updateButton.layer.cornerRadius = 5;
    updateButton.alpha = 1;
    updateButton.userInteractionEnabled = YES;
    [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [alertView addSubview:updateButton];
    self.updateButton = updateButton;
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(alertView.mas_bottom).mas_offset(-20);
        make.leading.mas_equalTo(alertView.mas_leading).mas_offset(40);
        make.trailing.mas_equalTo(alertView.mas_trailing).mas_offset(-40);
        make.height.mas_equalTo(40);
    }];
}

- (void)ignoreButtonTapAction {
    if (self.ignoreButtonTapped) {
        self.ignoreButtonTapped(self);
    }
}

- (void)updateButtonTapAction {
    if (self.updateButtonTapped) {
        self.updateButtonTapped(self);
    }
}

- (void)show {
    [self setupView];
}

- (void)dismiss {
    [self.cover removeFromSuperview];
    [self.alertView removeFromSuperview];
    [self removeFromSuperview];
}

@end
