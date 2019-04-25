//
//  CXUserStateCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXUserStateCell.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"
#import "UIImageView+EMWebCache.h"

@interface CXUserStateCell ()

/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 部门 */
@property (nonatomic, strong) UILabel *deptLabel;
/** 职位 */
@property (nonatomic, strong) UILabel *jobLabel;
/** 启用 */
@property (nonatomic, strong) UIButton *enableButton;
/** 停用 */
@property (nonatomic, strong) UIButton *disableButton;

@end

@implementation CXUserStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
        self.deptLabel.hidden = YES;
        self.jobLabel.hidden = YES;
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
            subview.frame =frame;
        }
    }
}

- (void)setup {
    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        imageView;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(15);
//            make.bottom.equalTo(self.avatarImageView.mas_centerY).offset(-2.5);
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
    self.deptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(153, 153, 153);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.avatarImageView.mas_centerY).offset(2.5);
        }];
        label;
    });
    
    self.jobLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(153, 153, 153);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deptLabel.mas_right).offset(8);
            make.top.equalTo(self.deptLabel);
        }];
        label;
    });
    
    self.disableButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"停用" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(236, 72, 72)] forState:UIControlStateSelected];
        [btn setTitleColor:kColorWithRGB(154, 154, 154) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = kColorWithRGB(154, 154, 154).CGColor;
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
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(236, 72, 72)] forState:UIControlStateSelected];
        [btn setTitleColor:kColorWithRGB(154, 154, 154) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = kColorWithRGB(154, 154, 154).CGColor;
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
- (void)setAvatarUrl:(NSString *)avatarUrl {
    _avatarUrl = avatarUrl;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:Image(@"temp_user_head") options:EMSDWebImageRetryFailed];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setDept:(NSString *)dept {
    _dept = dept;
    self.deptLabel.text = dept;
}

- (void)setJob:(NSString *)job {
    _job = job;
    self.jobLabel.text = job;
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.enableButton.selected = enable;
    self.disableButton.selected = !enable;
    if (enable) {
        self.enableButton.layer.borderWidth = 0;
        self.disableButton.layer.borderWidth = 1;
    }
    else {
        self.enableButton.layer.borderWidth = 1;
        self.disableButton.layer.borderWidth = 0;
    }
}

#pragma mark - Event
- (void)stateButtonOnTap:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    BOOL enable = sender == self.enableButton;
    if ([self.delegate respondsToSelector:@selector(userStateCell:willChangeEnableState:atIndexPath:)]) {
        [self.delegate userStateCell:self willChangeEnableState:enable atIndexPath:self.indexPath];
    }
}

@end
