//
//  SDIMSearchResultCell.m
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "SDIMSearchResultCell.h"
#import "Masonry.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"

@interface SDIMSearchResultCell ()

/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  子标题
 */
@property (nonatomic, strong) UILabel *subtitleLabel;
/**
 *  时间
 */
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation SDIMSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    // 头像
    self.avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.avatarImageView.layer.cornerRadius = CornerRadius;
        self.avatarImageView.layer.masksToBounds = YES;
        make.size.mas_equalTo(CGSizeMake(SDHeadWidth, SDHeadWidth));
        make.leading.mas_equalTo(SDHeadImageViewLeftSpacing);
        make.centerY.equalTo(self.contentView);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"";
    self.titleLabel.textColor = SDChatterDisplayNameColor;
    self.titleLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarImageView.mas_trailing).offset(SDHeadImageViewLeftSpacing);
        make.top.equalTo(self.avatarImageView);
        make.trailing.lessThanOrEqualTo(self.contentView).offset(-SDHeadImageViewLeftSpacing);
    }];
    
    // 子标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"";
    self.subtitleLabel.font = [UIFont systemFontOfSize:SDCellLastMessageFont];
    self.subtitleLabel.textColor = SDCellLastMessageColor;
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.bottom.equalTo(self.avatarImageView);
        make.trailing.lessThanOrEqualTo(self.contentView).offset(-SDHeadImageViewLeftSpacing);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:SDCellTimeFont];
    _timeLabel.textColor = SDCellTimeColor;
    _timeLabel.x = Screen_Width - SDHeadImageViewLeftSpacing - _timeLabel.frame.size.width;
    _timeLabel.y = SDHeadImageViewLeftSpacing + 4;
    [self.contentView addSubview:_timeLabel];
}

- (void)setMessage:(CXIMMessage *)message {
    self->_message = message;
    if (!message) return;
    
    if(self.message.type == CXIMMessageTypeChat){
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[CXIMHelper getUserAvatarUrlByIMMessage:self.message]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    }else if(self.message.type == CXIMMessageTypeGroupChat){
        _avatarImageView.image = [CXIMHelper getGroupHeadImageFromMessage:self.message];
    }
    
    CXIMConversation *conv = [[CXIMService sharedInstance].chatManager loadConversationWithMessageId:message.ID];
    NSString *chatterDisplayName;
    if (message.type == CXIMMessageTypeChat) {
        chatterDisplayName = [CXIMHelper getRealNameByAccount:conv.chatter];
        if(chatterDisplayName == nil || [chatterDisplayName length] <= 0){
            //超级搜索
            chatterDisplayName = [CXIMHelper getRealNameByAccount:_message.receiver];
        }
    }
    else {
        if(conv.chatter && [conv.chatter length] > 0){
            chatterDisplayName = [[CXIMService sharedInstance].groupManager loadGroupForId:conv.chatter].groupName;
        }
        
        if(chatterDisplayName == nil || [chatterDisplayName length] <= 0){
            //超级搜索
            chatterDisplayName = [[CXIMService sharedInstance].groupManager loadGroupForId:_message.receiver].groupName;
        }
    }
    NSString *senderDisplayName = [CXIMHelper getRealNameByAccount:message.sender];
    CXIMTextMessageBody *textBody = (CXIMTextMessageBody *)message.body;
    
    self.titleLabel.text = chatterDisplayName;
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@:%@", senderDisplayName, textBody.textContent];
    
    _timeLabel.text = [self transformedTimeWithMessage:_message];
    [_timeLabel sizeToFit];
    _timeLabel.x = Screen_Width - SDHeadImageViewLeftSpacing - _timeLabel.frame.size.width;
    _timeLabel.y = SDHeadImageViewLeftSpacing + 4;
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + SDHeadImageViewLeftSpacing, _avatarImageView.y + 4, Screen_Width - _timeLabel.frame.size.width - CGRectGetMaxX(_avatarImageView.frame) - SDHeadImageViewLeftSpacing*2, SDChatterDisplayNameFont);
}

- (NSString *)transformedTimeWithMessage:(CXIMMessage *)message{
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
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:[message.sendTime stringValue].longLongValue / 1000];
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
