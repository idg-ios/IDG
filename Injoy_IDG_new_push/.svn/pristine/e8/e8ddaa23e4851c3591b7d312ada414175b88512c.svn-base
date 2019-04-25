//
//  CXUserSelectCell.m
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXUserSelectCell.h"
#import "CXUserModel.h"
#import "UIView+YYAdd.h"

@interface CXUserSelectCell ()

/** 名字label */
@property (nonatomic, strong) UILabel *nameLabel;
/** 选中状态的view */
@property (nonatomic, strong) UIImageView *stateImageView;

@end

@implementation CXUserSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
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
    
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = GET_HEIGHT(self.contentView) / 2;
    self.nameLabel.left = 15;
    
    [self.stateImageView sizeToFit];
    self.stateImageView.centerY = GET_HEIGHT(self.contentView) / 2;
    self.stateImageView.right = GET_WIDTH(self.contentView) - 10;
}

@end
