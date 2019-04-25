//
//  CXVoiceConferenceListCell.m
//  InjoyCRM
//
//  Created by wtz on 16/8/27.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXVoiceConferenceListCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"

#define kGroupTitleLabelWidth 100

#define kGroupMemberCountLabelWidth 40

#define kGroupTimeLabelWidth 45

#define kPlayImageViewWidth 32

#define kTimeAndPlayImageViewSpace 17

@interface CXVoiceConferenceListCell()

@property (strong, nonatomic) CXGroupInfo * group;
/// 群组头像
@property (strong, nonatomic) UIImageView* groupImageView;
/// 群组标题
@property (strong, nonatomic) UILabel* groupTitleLabel;
/// 有多少人
@property (strong, nonatomic) UILabel* groupMemberCountLabel;
/// 群组时间
@property (strong, nonatomic) UILabel* groupTimeLabel;

@end

@implementation CXVoiceConferenceListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_groupImageView){
        [_groupImageView removeFromSuperview];
        _groupImageView = nil;
    }
    _groupImageView = [[UIImageView alloc]init];
    _groupImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _groupImageView.layer.cornerRadius = CornerRadius;
    _groupImageView.clipsToBounds = YES;
    
    if(_groupTitleLabel){
        [_groupTitleLabel removeFromSuperview];
        _groupTitleLabel = nil;
    }
    _groupTitleLabel = [[UILabel alloc] init];
    _groupTitleLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, kGroupTitleLabelWidth, SDChatterDisplayNameFont);
    _groupTitleLabel.textAlignment = NSTextAlignmentRight;
    _groupTitleLabel.backgroundColor = [UIColor clearColor];
    _groupTitleLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupTitleLabel.textColor = [UIColor blackColor];
    
    if(_groupMemberCountLabel){
        [_groupMemberCountLabel removeFromSuperview];
        _groupMemberCountLabel = nil;
    }
    _groupMemberCountLabel = [[UILabel alloc] init];
    _groupMemberCountLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth + kGroupTitleLabelWidth + SDHeadImageViewLeftSpacing, (SDCellHeight - SDChatterDisplayNameFont)/2, kGroupMemberCountLabelWidth, SDChatterDisplayNameFont);
    _groupMemberCountLabel.textAlignment = NSTextAlignmentLeft;
    _groupMemberCountLabel.backgroundColor = [UIColor clearColor];
    _groupMemberCountLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupMemberCountLabel.textColor = SDCellTimeColor;
    
    UIImageView * playImageView = [[UIImageView alloc] init];
    playImageView.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - kPlayImageViewWidth - SDHeadImageViewLeftSpacing, (SDCellHeight - kPlayImageViewWidth)/2, kPlayImageViewWidth, kPlayImageViewWidth);
    playImageView.image = [UIImage imageNamed:@"voiceConferenceCellPlay"];
    playImageView.highlightedImage = [UIImage imageNamed:@"voiceConferenceCellPlay"];
    [self.contentView addSubview:playImageView];
    
    if(_groupTimeLabel){
        [_groupTimeLabel removeFromSuperview];
        _groupTimeLabel = nil;
    }
    _groupTimeLabel = [[UILabel alloc] init];
    _groupTimeLabel.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - kPlayImageViewWidth - SDHeadImageViewLeftSpacing - kGroupTimeLabelWidth - kTimeAndPlayImageViewSpace, (SDCellHeight - SDChatterDisplayNameFont)/2, kGroupTimeLabelWidth, SDChatterDisplayNameFont);
    _groupTimeLabel.textAlignment = NSTextAlignmentRight;
    _groupTimeLabel.backgroundColor = [UIColor clearColor];
    _groupTimeLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupTimeLabel.textColor = SDCellTimeColor;
    
}

- (void)setGroup:(CXGroupInfo *)aGroup;
{
    _group = aGroup;
    [self layoutUI];
}

- (void)layoutUI
{
    _groupImageView.image = [CXIMHelper getImageFromGroup:_group];
    [self.contentView addSubview:_groupImageView];
    
    _groupTitleLabel.text = _group.groupName;
    [self.contentView addSubview:_groupTitleLabel];
    
    _groupMemberCountLabel.text = [NSString stringWithFormat:@"(%zd)",[_group.members count]];
    [self.contentView addSubview:_groupMemberCountLabel];
    
    NSDate* dt = [NSDate dateWithTimeIntervalSince1970:[_group.createTimeMillisecond doubleValue] / 1000];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; //设置成中国阳历
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:dt];
    NSString* minuteStr = nil;
    if ((int)[comps minute] > 9) {
        minuteStr = [NSString stringWithFormat:@"%d", (int)[comps minute]];
    }
    else {
        minuteStr = [NSString stringWithFormat:@"0%d", (int)[comps minute]];
    }
    _groupTimeLabel.text = [NSString stringWithFormat:@"%d:%@", (int)[comps hour], minuteStr];
    [self.contentView addSubview:_groupTimeLabel];
}


@end
