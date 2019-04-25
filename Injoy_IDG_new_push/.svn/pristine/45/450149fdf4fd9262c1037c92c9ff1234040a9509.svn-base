//
//  SDIMGroupListCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMGroupListCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"

@interface SDIMGroupListCell()

@property (nonatomic, strong) CXGroupInfo * group;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * groupLabel;

@end

@implementation SDIMGroupListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_groupLabel){
        [_groupLabel removeFromSuperview];
        _groupLabel = nil;
    }
    _groupLabel = [[UILabel alloc] init];
    _groupLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, Screen_Width - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth) - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
    _groupLabel.textAlignment = NSTextAlignmentLeft;
    _groupLabel.backgroundColor = [UIColor clearColor];
    _groupLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
}

- (void)setGroup:(CXGroupInfo *)aGroup;
{
    _group = aGroup;
    [self layoutUI];
}

- (void)layoutUI
{
    _headImageView.image = [CXIMHelper getImageFromGroup:_group];
    [self.contentView addSubview:_headImageView];
    
    _groupLabel.text = _group.groupName;
    [self.contentView addSubview:_groupLabel];
}


@end
