//
//  SDIMGroupMembersCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/22.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMGroupMembersCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface SDIMGroupMembersCell()

@property (nonatomic, strong) NSString * member;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * memberLabel;
@property (nonatomic, strong) NSString * groupId;

@end

@implementation SDIMGroupMembersCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _member = [NSString stringWithFormat:@""];
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
    
    if(_memberLabel){
        [_memberLabel removeFromSuperview];
        _memberLabel = nil;
    }
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, Screen_Width - 15 - SDHeadImageViewLeftSpacing - 20 - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth) - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
    _memberLabel.textAlignment = NSTextAlignmentLeft;
    _memberLabel.backgroundColor = [UIColor clearColor];
    _memberLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
}

- (void)setMember:(NSString *)member AndGroupId:(NSString *)groupId
{
    _member = member;
    self.groupId = groupId;
    [self layoutUI];
}

- (void)layoutUI
{
    SDCompanyUserModel * user;
    if(self.groupId){
        user = [[CXLoaclDataManager sharedInstance] getUserByGroupId:self.groupId AndIMAccount:_member];
    }else{
        user = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsDicWithIMAccount:_member];
    }
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", user.icon.length ? user.icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    _memberLabel.text = user.name;
    [self.contentView addSubview:_memberLabel];
}

@end
