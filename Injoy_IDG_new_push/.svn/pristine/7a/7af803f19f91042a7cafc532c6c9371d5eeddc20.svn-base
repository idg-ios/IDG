//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXTopScrollSubView.h"
#import "Masonry.h"

@interface CXTopScrollSubView ()
@property(copy, nonatomic) NSString *title;
@property(weak, nonatomic) UIView *bottomLineView;
@property(weak, nonatomic) UIButton *btn;
@end

@implementation CXTopScrollSubView

#pragma mark - instance function

- (void)btnEvent:(UIButton *)sender {
    if (self.callBack) {
        self.callBack(self);
    }
}

- (void)setSelected:(BOOL)bl {
    self.btn.selected = bl;
    if (bl) {
        self.bottomLineView.backgroundColor =RGBACOLOR(174, 17, 41, 1);
    } else {
        self.bottomLineView.backgroundColor = self.btn.backgroundColor;
    }
}

- (void)setUpSubviews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn = btn;
    btn.backgroundColor = RGBACOLOR(245, 246, 248, 1);//[UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:self.title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:RGBACOLOR(174, 17, 41, 1) forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor whiteColor];
    self.bottomLineView = bottomLineView;
    [btn addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(btn);
        make.height.mas_equalTo(2.f);
    }];
}

#pragma mark - life cycle

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super initWithFrame:CGRectZero]) {
        self.title = title;
        [self setUpSubviews];
    }
    return self;
}

@end
