//
//  CXSuperConfigCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperConfigCell.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"
#import "UIImageView+EMWebCache.h"

@interface CXSuperConfigCell ()

/** 名字 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 启用 */
@property (nonatomic, strong) UIButton *enableButton;
/** 停用 */
@property (nonatomic, strong) UIButton *disableButton;

@end

@implementation CXSuperConfigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
            CGRect frame = subview.frame;
            frame.origin.x = self.separatorInset.left;
            frame.size.width = GET_WIDTH(self) - self.separatorInset.left - self.separatorInset.right;
            subview.frame = frame;
        }
    }
}

- (void)setup {
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
    self.disableButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"停用" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(88, 109, 150)] forState:UIControlStateSelected];
        [btn setTitleColor:kColorWithRGB(88, 109, 150) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = kColorWithRGB(88, 109, 150).CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(stateButtonOnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.equalTo(self);
        }];
        btn;
    });
    
    self.enableButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"启用" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(88, 109, 150)] forState:UIControlStateSelected];
        [btn setTitleColor:kColorWithRGB(88, 109, 150) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = kColorWithRGB(88, 109, 150).CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(stateButtonOnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.disableButton.mas_left).offset(-6);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.equalTo(self);
        }];
        btn;
    });
}

#pragma mark - Set
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.enableButton.selected = enable;
    self.disableButton.selected = !enable;
}

#pragma mark - Event
- (void)stateButtonOnTap:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    BOOL enable = sender == self.enableButton;
    if ([self.delegate respondsToSelector:@selector(superConfigCell:willChangeEnableState:atIndexPath:)]) {
        [self.delegate superConfigCell:self willChangeEnableState:enable atIndexPath:self.indexPath];
    }
}

@end
