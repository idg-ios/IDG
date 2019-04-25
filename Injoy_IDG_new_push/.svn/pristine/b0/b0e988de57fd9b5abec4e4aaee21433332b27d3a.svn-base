//
//  CXTopView.m
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXTopView.h"
#import "Masonry.h"
#import "CXTopButtonView.h"

CGFloat CXTopViewHeight = 52.f;

@interface CXTopView ()
@property(copy, nonatomic, readonly) NSArray *titles;
@property(assign, nonatomic) CXTopViewStyle cxTopViewStyle;
@end

@implementation CXTopView

#pragma mark - instance function

- (void)setUpSubViews {
    self.backgroundColor = RGBACOLOR(230.f, 236.f, 250.f, 1.f);

    CGFloat spacing = 20.f;
    CGFloat leftRightMargin = 5.f;

    @weakify(self);

    UIImage *leftImage = nil;
    if (self.cxTopViewStyle == imageWithBlueColor) {
        leftImage = [UIImage imageNamed:@"add_1"];
    }
    if (self.cxTopViewStyle == withoutBlueColor ||
            self.cxTopViewStyle == titleWithBlueColor) {
        leftImage = [UIImage imageNamed:@"add_2"];
    }

    CXTopButtonView *leftBtn = [[CXTopButtonView alloc] initWithTitle:self.titles.firstObject image:leftImage style:self.cxTopViewStyle];
    leftBtn.callBack = ^{
        @strongify(self);
        if (self.callBack) {
            self.callBack(self.titles.firstObject);
        }
    };
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_centerX).offset(-spacing);
        make.left.mas_greaterThanOrEqualTo(self.mas_left).mas_offset(leftRightMargin);
    }];

    UIImage *rightImage = nil;
    if (self.cxTopViewStyle == imageWithBlueColor) {
        rightImage = [UIImage imageNamed:@"search_1"];
    }
    if (self.cxTopViewStyle == withoutBlueColor ||
            self.cxTopViewStyle == titleWithBlueColor) {
        rightImage = [UIImage imageNamed:@"search_2"];
    }

    CXTopButtonView *rightBtn = [[CXTopButtonView alloc] initWithTitle:self.titles.lastObject image:rightImage style:self.cxTopViewStyle];
    rightBtn.callBack = ^{
        @strongify(self);
        if (self.callBack) {
            self.callBack(self.titles.lastObject);
        }
    };
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(spacing);
        make.right.mas_lessThanOrEqualTo(self.mas_right).mas_offset(-leftRightMargin);
    }];
}

#pragma mark - life cycle

- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super initWithFrame:CGRectZero]) {
        _titles = [titles copy];
        NSAssert([titles count] == 2, @"按钮数量只有2个");
        _cxTopViewStyle = imageWithBlueColor;
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles style:(CXTopViewStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        _titles = [titles copy];
        NSAssert([titles count] == 2, @"按钮数量只有2个");
        _cxTopViewStyle = style;
        [self setUpSubViews];
    }
    return self;
}

@end
