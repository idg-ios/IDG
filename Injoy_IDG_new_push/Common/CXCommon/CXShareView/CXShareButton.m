//
//  CXShareButton.m
//  InjoyCRM
//
//  Created by cheng on 16/8/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXShareButton.h"
#import "UIView+YYAdd.h"

IB_DESIGNABLE
@implementation CXShareButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.size = CGSizeEqualToSize(self.imageSize, CGSizeZero) ? CGSizeMake(GET_WIDTH(self), GET_WIDTH(self)) : self.imageSize;
    self.imageView.layer.cornerRadius = GET_WIDTH(self.imageView) / 2;
    self.imageView.top = 0;
    self.imageView.centerX = GET_WIDTH(self) * .5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.width = GET_WIDTH(self);
    self.titleLabel.bottom = GET_HEIGHT(self);
    self.titleLabel.left = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
