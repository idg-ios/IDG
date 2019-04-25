//
// Created by ^ on 2017/10/24.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXTopButtonView.h"
#import "Masonry.h"

@interface CXTopButtonView ()
@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UILabel *titleLabel;
@end

@implementation CXTopButtonView

- (void)coverBtnEvent {
    if (self.callBack) {
        self.callBack();
    }
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image style:(CXTopViewStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {

        UIColor *color = kColorWithRGB(80.f, 125.f, 204.f); /** < 蓝色 */
        UIColor *bgColor = RGBACOLOR(230.f, 236.f, 250.f, 1.f); /** < 淡蓝白色 */

        self.layer.cornerRadius = 2.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = color.CGColor;
        self.backgroundColor = bgColor;

        CGFloat spacing = 5.f;
        CGFloat width = 35.f;

        _imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeCenter;

        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(width);
        }];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(spacing);
            make.top.mas_equalTo(spacing);
            make.right.equalTo(self).offset(-spacing);
            make.bottom.equalTo(self).offset(-spacing);
        }];

        if (style == imageWithBlueColor) {
            _imageView.backgroundColor = color;
            _titleLabel.textColor = color;
        }
        if (style == withoutBlueColor) {
            _titleLabel.textColor = color;
        }
        if (style == titleWithBlueColor) {
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.backgroundColor = color;
            self.backgroundColor = color;
            _imageView.backgroundColor = bgColor;
        }

        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverBtn addTarget:self action:@selector(coverBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverBtn];
        [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end