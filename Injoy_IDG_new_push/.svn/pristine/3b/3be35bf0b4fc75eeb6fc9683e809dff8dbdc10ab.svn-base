//
//  SDCircleLabel.m
//  SDMarketingManagement
//
//  Created by Rao on 15/12/15.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDCircleLabel.h"

@implementation SDCircleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, 18.f, 18.f);
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];

        self.textAlignment = NSTextAlignmentCenter;
        self.font = kFontForAppFunction;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setUnreadCount:(NSInteger)unreadCount
{
    self.hidden = YES;
    if (unreadCount > 0) {
        if (unreadCount < 9) {
            self.font = [UIFont systemFontOfSize:13.f];
        }
        else if (unreadCount > 9 && unreadCount < 99) {
            self.font = [UIFont systemFontOfSize:12.f];
        }
        else {
            self.font = [UIFont systemFontOfSize:10.f];
        }
        self.text = [NSString stringWithFormat:@"%ld", (long)unreadCount];
        [self setNeedsLayout];
        self.hidden = NO;
    }
    _unreadCount = unreadCount;
}

@end
