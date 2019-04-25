//
//  CXExampleBillView.m
//  InjoyERP
//
//  Created by cheng on 17/1/4.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXConfirmView.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"

/** 头尾颜色 */
#define kHeaderFooterViewBackgroundColor UIColorFromHex(0xcfcdcdcd)

@interface CXConfirmView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIView *seperatorView;

/** 交互回调 */
@property (nonatomic, copy) void(^didConfirmCallback)(BOOL yes);

@end

@implementation CXConfirmView

+ (void)showWithTitle:(NSString *)title message:(NSString *)message callback:(void (^)(BOOL))callback {
    CXConfirmView *view = [[CXConfirmView alloc] init];
    view.title = title;
    view.message = message;
    view.didConfirmCallback = callback;
    [view show];
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.contentLabel.text = message;
}

#pragma mark - Set up
- (void)setup {
    self.backgroundColor = kDialogCoverBackgroundColor;
    
    self.containerView = ({
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(kDialogWidth);
        }];
        view;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"提示";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kDialogHeaderBackgroundColor;
        label.font = kDialogTitleFont;
        [self.containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.containerView);
            make.height.mas_equalTo(kDialogHeaderHeight);
        }];
        label;
    });
    
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = kFontOfSize(16);
        label.text = @"内容";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kDialogContentBackgroundColor;
        [self.containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.leading.trailing.equalTo(self.containerView);
            make.height.mas_equalTo(kDialogContentHeight);
        }];
        label;
    });
    
    self.footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kDialogHeaderBackgroundColor;
        [self.containerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom);
            make.leading.trailing.bottom.equalTo(self.containerView);
            make.height.mas_equalTo(kDialogHeaderHeight);
        }];
        view;
    });
    
    self.yesButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"是" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(50, 50, 50)] forState:UIControlStateNormal];
        button.titleLabel.font = kDialogButtonFont;
        [button addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:Image(@"common_save") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = kDialogButtonImageInsets;
        button.titleEdgeInsets = kDialogButtonTitleInsets;
        [self.footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(kDialogButtonMargin);
            make.centerY.equalTo(self.footerView);
            make.size.mas_equalTo(CGSizeMake(kDialogButtonWidth, kDialogButtonHeight));
        }];
        button;
    });
    
    self.noButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"否" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(50, 50, 50)] forState:UIControlStateNormal];
        button.titleLabel.font = kDialogButtonFont;
        [button addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:Image(@"common_delete") forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = kDialogButtonImageInsets;
        button.titleEdgeInsets = kDialogButtonTitleInsets;
        [self.footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-kDialogButtonMargin);
            make.centerY.equalTo(self.footerView);
            make.size.equalTo(self.yesButton);
        }];
        button;
    });
    
    // 分割线
    self.seperatorView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromHex(0xf0f0f0);
        [self.footerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(self.footerView);
            make.width.mas_equalTo(1);
        }];
        view;
    });
    
    self.seperatorView.hidden = YES;
}

#pragma mark - Public
- (void)show {
    [KEY_WINDOW addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(KEY_WINDOW);
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - Private
- (void)confirmButtonTapped:(UIButton *)sender {
    [self dismiss];
    if (self.didConfirmCallback) {
        self.didConfirmCallback(sender == self.yesButton);
    }
}

DEALLOC_ADDITION

@end
