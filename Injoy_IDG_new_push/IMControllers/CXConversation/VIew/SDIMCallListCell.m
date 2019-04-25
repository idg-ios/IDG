//
//  SDIMCallListCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/23.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMCallListCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"

@interface SDIMCallListCell()

@property (nonatomic,strong) UIImageView * avatarImageView;
/**
 *  通话对象
 */
@property (nonatomic,strong) UILabel * chatterDisplayNameLabel;
/**
 *  状态图
 */
@property (nonatomic, strong)UIImageView *statusImageView;
/**
 *  时间
 */
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation SDIMCallListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_avatarImageView){
        [_avatarImageView removeFromSuperview];
        _avatarImageView = nil;
    }
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _avatarImageView.layer.cornerRadius = CornerRadius;
    _avatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    if(_chatterDisplayNameLabel){
        [_chatterDisplayNameLabel removeFromSuperview];
        _chatterDisplayNameLabel = nil;
    }
    _chatterDisplayNameLabel = [[UILabel alloc] init];
    _chatterDisplayNameLabel.textAlignment = NSTextAlignmentLeft;
    _chatterDisplayNameLabel.backgroundColor = [UIColor clearColor];
    _chatterDisplayNameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    [self.contentView addSubview:_chatterDisplayNameLabel];
    
    if(_statusImageView){
        [_statusImageView removeFromSuperview];
        _statusImageView = nil;
    }
    _statusImageView = [[UIImageView alloc] init];
    _statusImageView.frame = CGRectMake(Screen_Width - SDHeadImageViewLeftSpacing - 24, (SDCellHeight - 24)/2, 24, 24);
    [self.contentView addSubview:_statusImageView];
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:SDAdditionalInformationNormalFont];
    _timeLabel.textColor = SDCellTimeColor;
    [self.contentView addSubview:_timeLabel];
}

- (void)setCallRecord:(CXIMCallRecord *)callRecord
{
    SDCompanyUserModel *userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:callRecord.chatter];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", (userModel.icon&&![userModel.icon isKindOfClass:[NSNull class]]&&userModel.icon.length) ? userModel.icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    self.chatterDisplayNameLabel.text = userModel.realName;
    self.timeLabel.text = [self transformedTime:callRecord.time.longLongValue];

    [_timeLabel sizeToFit];
    _timeLabel.x = Screen_Width - SDHeadImageViewLeftSpacing - 24 - SDHeadImageViewLeftSpacing - _timeLabel.size.width;
    _timeLabel.y = (SDCellHeight - SDAdditionalInformationNormalFont)/2;
    
    _chatterDisplayNameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, _timeLabel.frame.origin.x - SDHeadImageViewLeftSpacing - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth), SDChatterDisplayNameFont);
    
    self.statusImageView.image = [self statusImageForType:callRecord.type status:callRecord.status];
}

- (UIImage *)statusImageForType:(CXIMCallRecordType)type status:(CXIMCallRecordStatus)status {
    NSString *imageName = @"";
    // 接入
    if (type == CXIMCallRecordTypeIn) {
        if (status == CXIMCallRecordStatusFailed) {
            imageName = @"call_missed";
        }
        else {
            imageName = @"call_answered";
        }
    }
    else if (type == CXIMCallRecordTypeOut) {
        if (status == CXIMCallRecordStatusFailed) {
            imageName = @"call_missed_failure";
        }
        else {
            imageName = @"call_dialed";
        }
    }
    return [UIImage imageNamed:imageName];
}

-(NSString *)transformedTime:(long long)ts{
    NSMutableString *time = [NSMutableString string];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    //    [formatter setLocalizedDateFormatFromTemplate:@"yyyy-MM-dd HH:mm"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *now = [NSDate date];
    NSString *nowTimeStr = [formatter stringFromDate:now];
    NSString *now_year = [nowTimeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *now_month = [nowTimeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *now_day = [nowTimeStr substringWithRange:NSMakeRange(8, 2)];
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:ts / 1000];
    NSString *sendTimeStr = [formatter stringFromDate:sendDate];
    NSString *send_year = [sendTimeStr substringWithRange:NSMakeRange(0, 4)];
    NSString *send_month = [sendTimeStr substringWithRange:NSMakeRange(5, 2)];
    NSString *send_day = [sendTimeStr substringWithRange:NSMakeRange(8, 2)];
    NSString *send_hour = [sendTimeStr substringWithRange:NSMakeRange(11, 2)];
    NSString *send_minute = [sendTimeStr substringWithRange:NSMakeRange(14, 2)];
    
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
        [time appendString:[formatter stringFromDate:sendDate]];
    }
    
    return time;
}

@end
