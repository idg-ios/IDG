//
//  CXDDXVoiceMeetingListCell.m
//  InjoyDDXXST
//
//  Created by wtz on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXVoiceMeetingListCell.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"

#define kPlayImageViewWidth 32

#define kTimeAndPlayImageViewSpace 10

@interface CXDDXVoiceMeetingListCell()

@property (strong, nonatomic) CXDDXVoiceMeetingListModel * model;
/// 群组头像
@property (strong, nonatomic) UIImageView* groupImageView;
/// 群组标题
@property (strong, nonatomic) UILabel* groupTitleLabel;
/// 有多少人
@property (strong, nonatomic) UILabel* groupMemberCountLabel;
/// 群组时间
@property (strong, nonatomic) UILabel* groupTimeLabel;

@end

@implementation CXDDXVoiceMeetingListCell

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
    _groupTitleLabel.textAlignment = NSTextAlignmentLeft;
    _groupTitleLabel.backgroundColor = [UIColor clearColor];
    _groupTitleLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupTitleLabel.textColor = [UIColor blackColor];
    
    if(_groupMemberCountLabel){
        [_groupMemberCountLabel removeFromSuperview];
        _groupMemberCountLabel = nil;
    }
    _groupMemberCountLabel = [[UILabel alloc] init];
    _groupMemberCountLabel.textAlignment = NSTextAlignmentLeft;
    _groupMemberCountLabel.backgroundColor = [UIColor clearColor];
    _groupMemberCountLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupMemberCountLabel.textColor = SDCellTimeColor;
    
    UIImageView * playImageView = [[UIImageView alloc] init];
    playImageView.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - kPlayImageViewWidth, (SDCellHeight - kPlayImageViewWidth)/2, kPlayImageViewWidth, kPlayImageViewWidth);
    playImageView.image = [UIImage imageNamed:@"voiceConferenceCellPlay"];
    playImageView.highlightedImage = [UIImage imageNamed:@"voiceConferenceCellPlay"];
    [self.contentView addSubview:playImageView];
    
    if(_groupTimeLabel){
        [_groupTimeLabel removeFromSuperview];
        _groupTimeLabel = nil;
    }
    _groupTimeLabel = [[UILabel alloc] init];
    _groupTimeLabel.textAlignment = NSTextAlignmentRight;
    _groupTimeLabel.backgroundColor = [UIColor clearColor];
    _groupTimeLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _groupTimeLabel.textColor = SDCellTimeColor;
    
}

- (void)setCXDDXVoiceMeetingListModel:(CXDDXVoiceMeetingListModel *)model;
{
    self.model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _groupImageView.image = [CXIMHelper getImageFromVoiceMeetingIconString:_model.icon AndMeetingMemberCount:[_model.count integerValue]];
    [self.contentView addSubview:_groupImageView];
    
    _groupTitleLabel.text = _model.title;
    [_groupTitleLabel sizeToFit];
    [self.contentView addSubview:_groupTitleLabel];
    
    _groupMemberCountLabel.text = [NSString stringWithFormat:@"(%zd)",[_model.count integerValue]];
    [_groupMemberCountLabel sizeToFit];
    [self.contentView addSubview:_groupMemberCountLabel];
    
    _groupTimeLabel.text = [self transformedTimeWithTime:_model.createTime];
    [_groupTimeLabel sizeToFit];
    [self.contentView addSubview:_groupTimeLabel];
    
    _groupTimeLabel.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - kPlayImageViewWidth - kTimeAndPlayImageViewSpace - _groupTimeLabel.size.width, (SDCellHeight - SDChatterDisplayNameFont)/2, _groupTimeLabel.size.width, SDChatterDisplayNameFont);
    
    if(_groupTitleLabel.size.width > CGRectGetMinX(_groupTimeLabel.frame) - SDHeadImageViewLeftSpacing - _groupMemberCountLabel.size.width - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth)){
        _groupMemberCountLabel.frame = CGRectMake(CGRectGetMaxX(_groupTitleLabel.frame) + SDHeadImageViewLeftSpacing, (SDCellHeight - SDChatterDisplayNameFont)/2, _groupMemberCountLabel.size.width, SDChatterDisplayNameFont);
        
        _groupTitleLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2 - 2, CGRectGetMinX(_groupTimeLabel.frame) - SDHeadImageViewLeftSpacing - _groupMemberCountLabel.size.width - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth), SDChatterDisplayNameFont + 4);
    }else{
        _groupMemberCountLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth + _groupTitleLabel.size.width, (SDCellHeight - SDChatterDisplayNameFont)/2, _groupMemberCountLabel.size.width, SDChatterDisplayNameFont);
    }
    
    _groupTitleLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2 - 2, CGRectGetMinX(_groupTimeLabel.frame) - SDHeadImageViewLeftSpacing - _groupMemberCountLabel.size.width - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth), SDChatterDisplayNameFont + 4);
}

- (NSString *)transformedTimeWithTime:(NSString *)createTime{
    if([createTime length] < 16){
        return createTime;
    }
    NSMutableString *time = [NSMutableString string];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *now = [NSDate date];
    NSString *nowTimeStr = [formatter stringFromDate:now];
    NSString *now_year = [nowTimeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *now_month = [nowTimeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *now_day = [nowTimeStr substringWithRange:NSMakeRange(8, 2)];
    
    NSString *send_year = [createTime substringWithRange:NSMakeRange(0, 4)];
    NSString *send_month = [createTime substringWithRange:NSMakeRange(5, 2)];
    NSString *send_day = [createTime substringWithRange:NSMakeRange(8, 2)];
    NSString *send_hour = [createTime substringWithRange:NSMakeRange(11, 2)];
    NSString *send_minute = [createTime substringWithRange:NSMakeRange(14, 2)];
    
    // 同年
    BOOL isSameYear = [now_year isEqualToString:send_year] ;
    // 同月
    BOOL isSameMonth = [now_month isEqualToString:send_month];
    // 同日
    BOOL isSameDay = [now_day isEqualToString:send_day];
    if (isSameYear) {
        // 同月
        if (isSameMonth) {
            // 同一天
            if (isSameDay) {
                if (send_hour.intValue <= 9) {
                    [time appendFormat:@"早上%@:%@",send_hour,send_minute];
                }
                else if (send_hour.intValue <= 12) {
                    [time appendFormat:@"上午%@:%@",send_hour,send_minute];
                }
                else{
                    [time appendFormat:@"下午%d:%@",send_hour.intValue - 12 , send_minute];
                }
            }
            // 不同一天
            else{
                NSInteger daySpan = labs(send_day.intValue - now_day.intValue);
                if (daySpan == 1) {
                    [time appendString:@"昨天"];
                }
                else if(daySpan == 2){
                    [time appendString:@"前天"];
                }
                else{
                    [time appendFormat:@"%@-%@ ",send_month,send_day];
                }
                [time appendFormat:@"%@:%@",send_hour,send_minute];
            }
        }
        // 不同月
        else{
            [time appendFormat:@"%@-%@ %@:%@",send_month,send_day,send_hour,send_minute];
        }
    }
    // 不同年
    else{
        [time appendString:createTime];
    }
    
    return time;
}

@end
