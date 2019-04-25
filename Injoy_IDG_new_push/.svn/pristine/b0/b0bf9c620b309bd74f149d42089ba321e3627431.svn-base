//
//  CXFocusSignMemberCell.m
//  SDMarketingManagement
//
//  Created by lancely on 4/22/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXFocusSignMemberCell.h"
#import "SDCompanyUserModel.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"

@interface CXFocusSignMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation CXFocusSignMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUserModel:(SDCompanyUserModel *)userModel {
    self->_userModel = userModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:(userModel.icon&&![userModel.icon  isKindOfClass:[NSNull class]]&&userModel.icon.length)? userModel.icon : @""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    self.nameLabel.text = userModel.realName;
}

- (void)setChecked:(BOOL)checked {
    self->_checked = checked;
    
    self.selectImageView.image = [UIImage imageNamed:checked ? @"selected" : @"unSelected"];
}

- (void)setAllowChecked:(BOOL)allowChecked {
    self->_allowChecked = allowChecked;
    
    self.selectImageView.hidden = !allowChecked;
}

@end
