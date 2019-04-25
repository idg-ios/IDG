//
//  CXNewsCommonCell.m
//  SDMarketingManagement
//
//  Created by admin on 16/4/19.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXNewsCommonCell.h"
#import "Masonry.h"

#define paddingTopHeight ((kCellHeight - 20) / 2)
@implementation CXNewsCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        self.theKey = [[UILabel alloc] init];
        self.theKey.font = kFontSizeForDetail;
        //        self.theKey.textAlignment = NSTextAlignmentRight;
        //        self.theKey.backgroundColor = [UIColor lightGrayColor];
        self.theKey.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.theKey];

        self.theValue = [[UILabel alloc] init];
        self.theValue.font = kFontSizeForForm;
        self.theValue.numberOfLines = 0;
        self.theValue.textColor = [UIColor blackColor];
        //        self.theValue.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.theValue];

        self.theLine = [[UILabel alloc] init];
        self.theLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.theLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat height = self.frame.size.height;
    // CGFloat width = self.frame.size.width;

    self.theKey.frame = CGRectMake(5, paddingTopHeight, 85, 20);
    self.theValue.frame = CGRectMake(85, 10, Screen_Width - 90, height - 20.f);
    self.theLine.frame = CGRectMake(5, self.frame.size.height - 0.5, Screen_Width - 20, 0.5);
}

@end
