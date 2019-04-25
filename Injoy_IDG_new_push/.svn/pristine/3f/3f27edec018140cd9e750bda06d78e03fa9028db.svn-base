//
//  CXDepartmentUserListCell.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDepartmentUserListCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface CXDepartmentUserListCell()

@property (nonatomic, strong) NSString * member;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * memberLabel;
@property (nonatomic, strong) UILabel * jobLabel;

@end

@implementation CXDepartmentUserListCell

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
    
    if(_jobLabel){
        [_jobLabel removeFromSuperview];
        _jobLabel = nil;
    }
    _jobLabel = [[UILabel alloc] init];
    _jobLabel.frame = CGRectMake(Screen_Width - 220,0,180,SDCellHeight);
    _jobLabel.textAlignment = NSTextAlignmentRight;
    _jobLabel.backgroundColor = [UIColor clearColor];
    _jobLabel.textColor = RGBACOLOR(130.0, 130.0, 130.0, 1.0);
    _jobLabel.font = [UIFont systemFontOfSize:14.0];
}

- (void)setMember:(NSString *)member
{
    _member = member;
    [self layoutUI];
}

- (void)layoutUI
{
    SDCompanyUserModel * user = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:self.member];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[user.icon isKindOfClass:[NSNull class]]?@"":user.icon]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    _memberLabel.text = user.name;
    [self.contentView addSubview:_memberLabel];
    
    _jobLabel.text = user.job;
    [self.contentView addSubview:_jobLabel];
}

@end
