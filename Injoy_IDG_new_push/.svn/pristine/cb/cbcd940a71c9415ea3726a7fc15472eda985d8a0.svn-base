//
//  CXIMMemberItem.m
//  SDMarketingManagement
//
//  Created by lancely on 4/26/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXIMMemberItem.h"
#import "SDCompanyUserModel.h"
#import "UIButton+EMWebCache.h"
#import "UIView+Category.h"

@interface CXIMMemberItem ()

@end

@implementation CXIMMemberItem

- (instancetype)init {
    if (self = [super init]) {
        [self setTitleColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}

- (void)setUserModel:(SDCompanyUserModel *)userModel {
    self->_userModel = userModel;
    
    [self sd_setImageWithURL:[NSURL URLWithString:(userModel.icon&&![userModel.icon isKindOfClass:[NSNull class]]&&userModel.icon.length) ? userModel.icon : @""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self setTitle:userModel.name forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.size = CGSizeMake(50, 50);
    self.imageView.centerX = kItemWidth / 2.0;
    self.imageView.y = 5;
    
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 5;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = kItemWidth / 2.0;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGRect rect = self.titleLabel.frame;
    self.titleLabel.frame = CGRectMake(rect.origin.x + (rect.size.width - (SDHeadWidth + 40))/2, rect.origin.y, SDHeadWidth + 40, rect.size.height);
}

@end
