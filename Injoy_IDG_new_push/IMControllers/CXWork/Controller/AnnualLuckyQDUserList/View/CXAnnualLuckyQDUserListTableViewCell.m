//
//  CXAnnualLuckyQDUserListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXAnnualLuckyQDUserListTableViewCell.h"
#import "CXUserModel.h"
#import "UIView+YYAdd.h"
#import "UIImageView+EMWebCache.h"
#import "CXUserModel.h"

@interface CXAnnualLuckyQDUserListTableViewCell()

/** headImageView */
@property (nonatomic, strong) UIImageView *headImageView;
/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 选中状态的view */
@property (nonatomic, strong) UIImageView *stateImageView;


@end

@implementation CXAnnualLuckyQDUserListTableViewCell

#define kImageSpace 10.0

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.headImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        label;
    });
    
    self.stateImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView;
    });
}

- (void)setUserModel:(CXUserModel *)userModel {
    _userModel = userModel;
    self.nameLabel.text = userModel.name;
}

- (void)setShowSelect:(BOOL)showSelect {
    _showSelect = showSelect;
    self.stateImageView.hidden = !showSelect;
}

- (void)setUserSelected:(BOOL)userSelected {
    _userSelected = userSelected;
    self.stateImageView.image = [UIImage imageNamed:userSelected ? @"onSelected" : @"outSelected"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.stateImageView.frame = CGRectMake(kImageSpace, kImageSpace, GET_HEIGHT(self.contentView) - 2*kImageSpace, GET_HEIGHT(self.contentView) - 2*kImageSpace);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:(_userModel.icon && ![_userModel.icon isKindOfClass:[NSNull class]])?_userModel.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = GET_HEIGHT(self.contentView) / 2;
    self.nameLabel.left = GET_HEIGHT(self.contentView) + 15.0;
    
    [self.stateImageView sizeToFit];
    self.stateImageView.centerY = GET_HEIGHT(self.contentView) / 2;
    self.stateImageView.right = GET_WIDTH(self.contentView) - 10;
}

@end
