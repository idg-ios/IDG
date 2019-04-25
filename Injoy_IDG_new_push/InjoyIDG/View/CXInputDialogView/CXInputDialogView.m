//
//  CXInputDialogView.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXInputDialogView.h"
#import "CXEditLabel.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"

#define kCoverViewTag self.hash

@interface CXInputDialogView ()
/** 头部视图 */
@property (nonatomic, strong) UIView *headerView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 输入框 */
@property (nonatomic, strong) CXEditLabel *editLabel;
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *applyButton;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation CXInputDialogView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.title = @"搜索";
        self.editLabel.title = @"查找：";
        self.content = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.editLabel.content = content;
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
    
    _editLabel = ({
        CXEditLabel *label = [[CXEditLabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.equalTo(self).mas_offset(kFormViewMargin);
            make.right.equalTo(self).mas_offset(-kFormViewMargin);
            make.height.mas_equalTo(kCellHeight);
        }];
        label;
    });
    
    _footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(236, 236, 236);
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_editLabel.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(kDialogFooterHeight);
            make.bottom.equalTo(self);
        }];
        view;
    });
    
    _applyButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(217, 217, 217)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onApplyButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 32));
            make.right.equalTo(_footerView.mas_centerX).offset(-15);
            make.centerY.equalTo(_footerView);
        }];
        btn;
    });
    
    _cancelButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(217, 217, 217)] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onCancelButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(85, 32));
            make.left.equalTo(_footerView.mas_centerX).offset(15);
            make.centerY.equalTo(_footerView);
        }];
        btn;
    });
    
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
}

- (void)onApplyButtonTap {
    self.content = trim(self.editLabel.content);
    !self.onApplyWithContent ?: self.onApplyWithContent(self.content);
    [self dismiss];
}

- (void)onCancelButtonTap {
    [self dismiss];
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
    
    [window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.width.equalTo(view).multipliedBy(0.75);
        make.width.mas_equalTo(290);
        make.center.equalTo(window);
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

@end
