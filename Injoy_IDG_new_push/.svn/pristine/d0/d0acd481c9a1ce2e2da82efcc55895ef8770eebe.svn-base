//
//  SDConversationCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDConversationCell.h"
#import "UIView+Category.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "NSString+CXYMCategory.h"
#import "NSDate+CXYMCategory.h"

#define kBadgeImageWidth 16.0

@interface SDConversationCell()

// 头像
@property (nonatomic,strong) UIImageView *avatarImageView;
// 昵称
@property (nonatomic,strong) UILabel *nicknameLabel;
// 会话内容
@property (nonatomic,strong) UILabel *conversationLabel;
// 时间
@property (nonatomic,strong) UILabel *timeLabel;

//badgeButton
@property (nonatomic, strong) UIButton * badgeBtn;

@end

@implementation SDConversationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    return self;
}

-(void)initCell{
    _avatarImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_avatarImageView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _nicknameLabel.textColor = SDChatterDisplayNameColor;
    [self.contentView addSubview:_nicknameLabel];
    
    _badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _badgeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _badgeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5, 0, 0);
    _badgeBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_badgeBtn];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:SDCellTimeFont];
    _timeLabel.textColor = SDCellTimeColor;
    [self.contentView addSubview:_timeLabel];
    
    _conversationLabel = [[UILabel alloc] init];
    _conversationLabel.font = [UIFont systemFontOfSize:SDCellLastMessageFont];
    _conversationLabel.textColor = SDCellLastMessageColor;
    [self.contentView addSubview:_conversationLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat space = (20.0 - SDHeadImageViewLeftSpacing);
    
    _avatarImageView.origin = CGPointMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing);
    _avatarImageView.size = CGSizeMake(SDHeadWidth, SDHeadWidth);
    _avatarImageView.layer.cornerRadius = CornerRadius;
    _avatarImageView.layer.masksToBounds = YES;
    
    if(_conversation.unreadNumber > 99){
        _badgeBtn.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) - kBadgeImageWidth/2, CGRectGetMinY(_avatarImageView.frame) - kBadgeImageWidth/2, kBadgeImageWidth, kBadgeImageWidth);
    }else{
        _badgeBtn.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) - kBadgeImageWidth/2, CGRectGetMinY(_avatarImageView.frame) - kBadgeImageWidth/2, kBadgeImageWidth, kBadgeImageWidth);
    }
    
    [_timeLabel sizeToFit];
    _timeLabel.x = Screen_Width - SDHeadImageViewLeftSpacing - _timeLabel.frame.size.width;
    _timeLabel.y = _avatarImageView.y + space;
    
    _nicknameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + SDHeadImageViewLeftSpacing, _avatarImageView.y + space, Screen_Width - _timeLabel.frame.size.width - CGRectGetMaxX(_avatarImageView.frame) - SDHeadImageViewLeftSpacing*2, SDChatterDisplayNameFont + 2.0);
    
    _conversationLabel.frame = CGRectMake(_nicknameLabel.x, CGRectGetMaxY(_nicknameLabel.frame) + 8 - 2.0, Screen_Width - _nicknameLabel.x - SDHeadImageViewLeftSpacing, SDCellLastMessageFont + 2);
}

static NSString *kNormalTextMessageType = @"[文本]";

-(void)setConversation:(CXIMConversation *)conversation{
    _conversation = conversation;
    
    SDCompanyUserModel *userModel = [CXIMHelper getUserByIMAccount:conversation.chatter];
    
    if(conversation.type == CXIMMessageTypeChat) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:(userModel.icon && ![userModel.icon isKindOfClass:[NSNull class]])?userModel.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        _nicknameLabel.text = userModel.realName?userModel.realName:conversation.chatter;
    }
    else {
        _avatarImageView.image = conversation.chatter?[CXIMHelper getGroupHeadImageFromConversation:conversation]:[UIImage imageNamed:@"groupPublicHeader"];
        _nicknameLabel.text = conversation.chatter?[[CXIMService sharedInstance].groupManager loadGroupForId:conversation.chatter].groupName:[NSString stringWithFormat:@"推广群"];
    }
    
    NSString *desc;
    if(conversation.latestMessage.body.type == CXIMMessageContentTypeText && conversation.latestMessage.ext[@"shareDic"]){
        desc = @"[分享]";
    }else{
        desc = conversation.chatter?[self getMessageDescriptionFromType:conversation.latestMessage.body.type body:conversation.latestMessage.body]:[NSString stringWithFormat:@"推广群管理员邀请你加入群聊"];
    }
    NSString *text = desc;
    // 群组消息显示发送人
    if (conversation.type == CXIMMessageTypeGroupChat && conversation.latestMessage) {
        // 系统通知直接显示消息
        if (conversation.latestMessage.body.type == CXIMMessageContentTypeSystemNotify) {
            text = desc;
        }
        else{
            if ([conversation.latestMessage.sender isEqualToString:VAL_HXACCOUNT]) {
                text = desc;
            }
            else {
                NSString *senderDisplayName = [CXIMHelper getUserByIMAccount:conversation.latestMessage.sender].realName;
                text = [NSString stringWithFormat:@"%@:%@",senderDisplayName,desc];
            }
        }
    }
    _conversationLabel.text = text;
    _timeLabel.text = conversation.latestMessage.transformedTime;
    
    if([conversation.chatter isEqualToString:@"通知公告"]){
        _avatarImageView.image = [UIImage imageNamed:@"GSTZImg"];
        _timeLabel.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"] length] > 0)?[self transformedTimeWithTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GT_Time"]]:@"";
    }else if([conversation.chatter isEqualToString:@"公众号"]){
        _avatarImageView.image = [UIImage imageNamed:@"ZBKBImg"];
        _timeLabel.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"] length] > 0)?[self transformedTimeWithTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_ZBKB_Time"]]:@"";
    }else if([conversation.chatter isEqualToString:@"内刊"]){
        _avatarImageView.image = [UIImage imageNamed:@"icon_xtxx"];
        _timeLabel.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NK_Push_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NK_Push_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NK_Push_Time"] length] > 0)?[self transformedTimeWithTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NK_Push_Time"]]:@"";
    }else if([conversation.chatter isEqualToString:@"系统消息"]){
        _avatarImageView.image = [UIImage imageNamed:@"cxym_chat_systemMessage"];
        _timeLabel.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"] length] > 0)?[self transformedTimeWithTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_SYSTEM_Push_Time"]]:@"";
    }else if([conversation.chatter isEqualToString:@"Newsletter"]){
        _avatarImageView.image = [UIImage imageNamed:@"cxym_chat_newsletter"];
        NSString * time = ([[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"] length] > 0)?[self transformNewsletterTimeStr:[[NSUserDefaults standardUserDefaults] objectForKey:@"CX_NEWSLETTER_Push_Time"]]:@"";
        _timeLabel.text = time;
    }else if([conversation.chatter isEqualToString:@"公司新闻"]){
        _avatarImageView.image = [UIImage imageNamed:@"ZBKBImg"];
        _timeLabel.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] isKindOfClass:[NSString class]] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"] length] > 0)?[self transformedTimeWithTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"IM_PUSH_GSXW_Time"]]:@"";
    }
    
    
    if (conversation.unreadNumber > 0 && conversation.unreadNumber < 100) {
        [_badgeBtn setBackgroundImage:[UIImage imageNamed:@"badgeBackGroundImage"] forState:UIControlStateNormal];
        [_badgeBtn setBackgroundImage:[UIImage imageNamed:@"badgeBackGroundImage"] forState:UIControlStateHighlighted];
        [_badgeBtn setTitle:[NSString stringWithFormat:@"%zd",conversation.unreadNumber] forState:UIControlStateNormal];
        [_badgeBtn setTitle:[NSString stringWithFormat:@"%zd",conversation.unreadNumber] forState:UIControlStateHighlighted];
    }else if(conversation.unreadNumber > 99){
        [_badgeBtn setBackgroundImage:[UIImage imageNamed:@"badgeBackGroundImage"] forState:UIControlStateNormal];
        [_badgeBtn setBackgroundImage:[UIImage imageNamed:@"badgeBackGroundImage"] forState:UIControlStateHighlighted];
        [_badgeBtn setTitle:[NSString stringWithFormat:@"%zd",conversation.unreadNumber] forState:UIControlStateNormal];
        [_badgeBtn setTitle:[NSString stringWithFormat:@"%zd",conversation.unreadNumber] forState:UIControlStateHighlighted];
    }else{
        [_badgeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_badgeBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [_badgeBtn setTitle:@"" forState:UIControlStateNormal];
        [_badgeBtn setTitle:@"" forState:UIControlStateHighlighted];
    }
}

- (NSString *)transformNewsletterTimeStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:timeStr.longLongValue / 1000];
    NSString *sendTimeStr = [formatter stringFromDate:sendDate];
    return sendTimeStr;
}

-(NSString *)getMessageDescriptionFromType:(CXIMMessageContentType)type body:(CXIMMessageBody *)body{
    NSString *description = @"";
    switch (type) {
        case CXIMMessageContentTypeFile:
            description = @"[文件]";
            break;
        case CXIMMessageContentTypeText:
        {
            CXIMTextMessageBody *textBody = (CXIMTextMessageBody *)body;
            description = textBody.textContent;
            break;
        }
        case CXIMMessageContentTypeImage:
            description = @"[图片]";
            break;
        case CXIMMessageContentTypeVideo:
            description = @"[视频]";
            break;
        case CXIMMessageContentTypeVoice:
            description = @"[语音]";
            break;
        case CXIMMessageContentTypeLocation:
        {
            CXIMLocationMessageBody *locationBody = (CXIMLocationMessageBody *)body;
            description = [NSString stringWithFormat:@"[位置]%@",locationBody.address];
            break;
        }
        case CXIMMessageContentTypeSystemNotify:
        {
            CXIMSystemNotifyMessageBody *notifyBody = (CXIMSystemNotifyMessageBody *)body;
            description = notifyBody.notifyContent;
            break;
        }
        default:
            break;
    }
    return description;
}

- (NSString *)transformedTimeWithTime:(NSString *)timeStr{
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
    
    NSDate *sendDate = [NSDate dateWithTimeIntervalSince1970:timeStr.longLongValue / 1000];
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
