//
//  CXMineDialogView.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXMineDialogView.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"

#define kCoverViewTag self.hash

@interface CXMineDialogView ()

/** 头部视图 */
@property (nonatomic, strong) UIView *headerView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容的容器视图 */
@property (nonatomic, strong) UIView *containerView;
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;

@end

@implementation CXMineDialogView

- (UIView *)contentView {
    if (self.containerView.subviews.count) {
        return self.containerView.subviews.firstObject;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _headerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(236, 236, 236);
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(kDialogHeaderHeight);
        }];
        view;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:17];
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headerView);
        }];
        label;
    });
    
    _containerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.equalTo(self);
        }];
        view;
    });
    
    _footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(236, 236, 236);
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_containerView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kDialogFooterHeight);
            make.bottom.equalTo(self);
        }];
        view;
    });
    
    _primaryButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(80, 126, 204)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"新增" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onPrimaryButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 32));
            make.right.equalTo(_footerView.mas_centerX).offset(-15);
            make.centerY.equalTo(_footerView);
        }];
        btn;
    });
    
    _secondaryButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(217, 217, 217)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onSecondaryButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 32));
            make.left.equalTo(_footerView.mas_centerX).offset(15);
            make.centerY.equalTo(_footerView);
        }];
        btn;
    });
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    UIView *coverView = ({
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = kDialogCoverBackgroundColor;
        view.tag = kCoverViewTag;
        view;
    });
    [window addSubview:coverView];
    
    [self reload];
    [window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(view).multipliedBy(0.75);
        make.width.mas_equalTo(290);
        make.center.equalTo(window);
    }];
}

- (void)reload {
    self.titleLabel.text = self.title;
    UIView *contentView = [self.contentSource contentViewOfDialogView:self];
    CGFloat height = [self.contentSource heightForContentView:contentView ofDialogView:self];
    
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_containerView addSubview:contentView];
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.edges.equalTo(_containerView);
    }];
}

- (void)dismiss {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [[window viewWithTag:kCoverViewTag] removeFromSuperview];
    [self removeFromSuperview];
}

- (void)dealloc {
    kLogFunc;
}

#pragma mark - Event
- (void)onPrimaryButtonTap {
    if ([self.delegate respondsToSelector:@selector(dialogViewDidTapPrimaryButton:)]) {
        [self.delegate dialogViewDidTapPrimaryButton:self];
    }
}

- (void)onSecondaryButtonTap {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(dialogViewDidTapSecondaryButton:)]) {
        [self.delegate dialogViewDidTapSecondaryButton:self];
    }
}

@end
