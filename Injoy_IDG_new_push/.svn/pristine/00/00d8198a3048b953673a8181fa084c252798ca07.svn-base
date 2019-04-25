/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMRemarkImageView.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"

@implementation EMRemarkImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _editing = NO;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 51, 51)];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [self addSubview:_imageView];

        CGFloat rHeight = _imageView.frame.size.height / 3;
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_imageView.frame), _imageView.frame.size.width, rHeight)];
        _remarkLabel.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin;
        _remarkLabel.clipsToBounds = YES;
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.font = [UIFont systemFontOfSize:10.0];
        _remarkLabel.backgroundColor = [UIColor clearColor];
        _remarkLabel.textColor = [UIColor blackColor];
        [self addSubview:_remarkLabel];
    }
    return self;
}

- (void)setRemark:(NSString*)remark
{
    _remark = remark;
    _remarkLabel.text = _remark;
}

- (void)setImage:(UIImage*)image
{
    SDCompanyUserModel* userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:self.hxAccount];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", (userModel.icon.length ? userModel.icon : @" ")]];
    _image = image;
    [_imageView sd_setImageWithURL:url placeholderImage:image options:EMSDWebImageRefreshCached];
}

@end
