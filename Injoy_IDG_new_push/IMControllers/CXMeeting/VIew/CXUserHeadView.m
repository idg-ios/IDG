//
//  CXUserHeadView.m
//  SDMarketingManagement
//
//  Created by haihualai on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXUserHeadView.h"
#import "UIImageView+EMWebCache.h"

@interface CXUserHeadView ()
@property (strong, nonatomic) SDCompanyUserModel* currentUserModel;
@end

@implementation CXUserHeadView

- (UIButtonType)buttonType
{
    return UIButtonTypeCustom;
}

float labelHeight = 20.f;
#define user_head_img [UIImage imageNamed:@"temp_user_head"]

- (instancetype)initWithUserModel:(SDCompanyUserModel*)userModel
{
    if (self = [super init]) {
        self.currentUserModel = userModel;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;

        UIImageView* imageView = [[UIImageView alloc] init];
        [imageView setImage:user_head_img];
        imageView.frame = CGRectMake(5, 0, 50.f, 50.f);
        [self addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:userModel.icon] placeholderImage:user_head_img options:EMSDWebImageRetryFailed];

        UILabel* userNameLabel = [[UILabel alloc] init];
        userNameLabel.font = [UIFont systemFontOfSize:14.f];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        userNameLabel.text = [userModel realName];
        userNameLabel.textColor = [UIColor lightGrayColor];
        userNameLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, 60.f, 20.f);
        [self addSubview:userNameLabel];
        [self addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(60.f, 80.f);
}

- (void)btnEvent:(UIButton*)sender
{
    if ([self.userHeadViewDelegate respondsToSelector:@selector(touchButtonEvent:)]) {
        [self.userHeadViewDelegate touchButtonEvent:self.currentUserModel];
    }
}

@end
