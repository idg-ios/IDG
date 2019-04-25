//
//  SDConversationCell.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDConversationCell.h"
#import "UIView+Category.h"
#import "UIView+WZLBadge.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"

@interface SDConversationCell()

// 头像
@property (nonatomic,strong) UIImageView *avatarImageView;
// 昵称
@property (nonatomic,strong) UILabel *nicknameLabel;
// 会话内容
@property (nonatomic,strong) UILabel *conversationLabel;
// 时间
@property (nonatomic,strong) UILabel *timeLabel;

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
    _nicknameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nicknameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    _conversationLabel = [[UILabel alloc] init];
    _conversationLabel.font = [UIFont systemFontOfSize:15];
    _conversationLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_conversationLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _avatarImageView.origin = CGPointMake(8, 8);
    _avatarImageView.size = CGSizeMake(40, 40);
    _avatarImageView.layer.cornerRadius = 5;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nicknameLabel.x = CGRectGetMaxX(_avatarImageView.frame) + 10;
    _nicknameLabel.y = _avatarImageView.y;
    [_nicknameLabel sizeToFit];
    
    [_timeLabel sizeToFit];
    _timeLabel.x = Screen_Width - 8 - _timeLabel.frame.size.width;
    _timeLabel.y = _avatarImageView.y;
    
//    _conversationLabel.x = _nicknameLabel.x;
    _conversationLabel.frame = CGRectMake(_nicknameLabel.x, CGRectGetMaxY(_nicknameLabel.frame) + 5, Screen_Width - _nicknameLabel.x - 8, 15);
//    _conversationLabel.size = [_conversationLabel sizeThatFits:CGSizeMake(self.contentView.width - _conversationLabel.x - 8, FLT_MAX)];
//    _conversationLabel.y = CGRectGetMaxY(_nicknameLabel.frame) + 5;
    
    self.contentView.badge.center = CGPointMake(CGRectGetMaxX(_avatarImageView.frame), _avatarImageView.y);
}

static NSString *kNormalTextMessageType = @"[文本]";

-(void)setConversation:(SDIMConversation *)conversation{
    _conversation = conversation;
    
//    NSString *imgName = conversation.type == SDIMMessageTypeChat ? @"avatar-user" : @"avatar-group";
    SDCompanyUserModel *userModel = [[SDChatManager sharedChatManager] searchUserByHxAccount:conversation.chatter];

    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", userModel.icon.length ? userModel.icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    _nicknameLabel.text = _conversation.chatterDisplayName;
    
    NSString *desc = [self getMessageDescriptionFromType:conversation.latestMessage.contentType body:conversation.latestMessage.body];
    NSString *text = desc;
    // 群组消息显示发送人
    if (conversation.type == SDIMMessageTypeGroupChat) {
        // 系统通知直接显示消息
        if (conversation.latestMessage.contentType == SDIMMessageContentTypeSystemNotify) {
            text = desc;
        }
        else{
            text = [NSString stringWithFormat:@"%@:%@",conversation.latestMessage.senderDisplayName,desc];
        }
    }
    _conversationLabel.text = text;
    _timeLabel.text = conversation.latestMessage.transformedTime;
    
    if (conversation.unreadNumber > 0) {
        [self.contentView showBadgeWithStyle:WBadgeStyleNumber value:conversation.unreadNumber animationType:WBadgeAnimTypeNone];
    }
    else{
        [self.contentView clearBadge];
    }
}

-(NSString *)getMessageDescriptionFromType:(SDIMMessageContentType)type body:(SDIMMessageBody *)body{
    NSString *description = @"";
    switch (type) {
        case SDIMMessageContentTypeFile:
            description = @"[文件]";
            break;
        case SDIMMessageContentTypeText:
        {
            SDIMTextMessageBody *textBody = (SDIMTextMessageBody *)body;
            description = textBody.textContent;
            break;
        }
        case SDIMMessageContentTypeImage:
            description = @"[图片]";
            break;
        case SDIMMessageContentTypeVideo:
            description = @"[视频]";
            break;
        case SDIMMessageContentTypeVoice:
            description = @"[语音]";
            break;
        case SDIMMessageContentTypeLocation:
        {
            SDIMLocationMessageBody *locationBody = (SDIMLocationMessageBody *)body;
            description = [NSString stringWithFormat:@"[位置]%@",locationBody.address];
            break;
        }
        case SDIMMessageContentTypeSystemNotify:
        {
            SDIMSystemNotifyMessageBody *notifyBody = (SDIMSystemNotifyMessageBody *)body;
            description = notifyBody.notifyContent;
            break;
        }
        default:
            break;
    }
    return description;
}

@end
