//
//  CXSuperUserSelectCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXSuperUserSelectCell.h"
#import "Masonry.h"
#import "UIImageView+EMWebCache.h"

@interface CXSuperUserSelectCell ()

/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 部门 */
@property (nonatomic, strong) UILabel *deptLabel;
/** 职位 */
@property (nonatomic, strong) UILabel *jobLabel;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation CXSuperUserSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.deptLabel.hidden = YES;
        self.jobLabel.hidden = YES;
    }
    return self;
}

- (void)setup {
    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
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
    
    self.selectButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:Image(@"idg_radio_off") forState:UIControlStateNormal];
        [btn setImage:Image(@"idg_radio_on") forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
        }];
        btn;
    });
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setUserModel:(CXSuperUserModel *)userModel {
    _userModel = userModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:Image(@"temp_user_head") options:(EMSDWebImageRetryFailed)];
    self.nameLabel.text = userModel.name;
    self.deptLabel.text = userModel.deptName;
    self.jobLabel.text = userModel.job;
    self.selectButton.selected = userModel.selected;
}

@end
