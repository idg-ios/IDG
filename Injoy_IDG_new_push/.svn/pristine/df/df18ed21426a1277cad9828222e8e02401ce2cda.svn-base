//
// Created by ^ on 2017/11/27.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXApprovalStateView.h"
#import "Masonry.h"

@interface CXApprovalStateView ()
@property(copy, nonatomic) NSString *title;
@property(weak, nonatomic) UIView *bottomLineView;
@property(weak, nonatomic) UIButton *btn;
@end

@implementation CXApprovalStateView

- (void)btnEvent:(UIButton *)sender {
    if (self.callBack) {
        self.callBack(self.title);
    }
}

- (void)setUpSubviews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn = btn;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:self.title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    self.bottomLineView = bottomLineView;
    [btn addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(btn);
        make.height.mas_equalTo(2.f);
    }];
}

- (void)setSelected:(BOOL)bl {
    self.btn.selected = bl;
    if (bl) {
        self.bottomLineView.backgroundColor = [UIColor redColor];
    } else {
        self.bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        self.title = title;
        [self setUpSubviews];
    }
    return self;
}

@end