//
//  CXShareAlertView.m
//  InjoyERP
//
//  Created by Longfei on 17/1/16.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXShareAlertView.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"

/** 文字内容高度 */
#define kContentLabelHeight kDialogContentHeight

@interface CXShareAlertView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation CXShareAlertView

#pragma mark - Life Cycle
- (instancetype)initWithMessage:(NSString *)message {
    if (self = [super init]) {
        [self setupWithMessage:message];
    }
    return self;
}

#pragma mark - Set up
- (void)setupWithMessage:(NSString *)message {
    self.backgroundColor = kDialogCoverBackgroundColor;
    
    self.containerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kDialogHeaderBackgroundColor;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(kDialogWidth);
        }];
        view;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"提 示";
        label.textAlignment = NSTextAlignmentCenter;
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
        label.text = [message isKindOfClass:[NSNull class]]?@"":message;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = kDialogContentBackgroundColor;
        [self.containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.leading.trailing.equalTo(self.containerView);
            make.height.mas_equalTo(kContentLabelHeight);
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
            make.height.mas_equalTo(kDialogFooterHeight);
        }];
        view;
    });
    
    self.confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"关 闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"common_delete"] forState:UIControlStateNormal];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [button setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFontOfSize(15);
        [button addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70 * (Screen_Width / 360.0), 30 * (Screen_Width / 360.0)));
            make.center.equalTo(self.footerView);
        }];
        button;
    });
}

#pragma mark - Public
+(instancetype)showViewWithMessage:(NSString *)message{
    CXShareAlertView *shareAlertView = [[self alloc] initWithMessage:message];
    [KEY_WINDOW addSubview:shareAlertView];
    [shareAlertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(KEY_WINDOW);
    }];
    return shareAlertView;
}

#pragma mark - Private
- (void)confirmButtonTapped:(UIButton *)sender {
    if (self.didConfirmCallback) {
        self.didConfirmCallback();
    }
    [self removeFromSuperview];
}

@end
