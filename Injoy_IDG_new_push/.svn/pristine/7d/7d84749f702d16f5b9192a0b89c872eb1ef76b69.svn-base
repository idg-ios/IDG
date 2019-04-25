//
//  CXProjectCollaborationChattingTextCell.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXProjectCollaborationChattingTextCell.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface CXProjectCollaborationChattingTextCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *textContentLabel;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UILabel *jobLabel;
@property (nonatomic,strong) UIButton * backBtn;

@end

@implementation CXProjectCollaborationChattingTextCell

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)]) {
        [self initCell];
    }
    return self;
}

-(void)initCell{
    [super initCell];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"avatar-user"];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nicknameLabel.textColor = RGBACOLOR(84.0, 84.0, 84.0, 1.0);
    [self.contentView addSubview:self.nicknameLabel];
    
    self.jobLabel = [[UILabel alloc] init];
    self.jobLabel.font = [UIFont systemFontOfSize:13.0];
    self.jobLabel.textColor = RGBACOLOR(152.0, 152.0, 152.0, 1.0);
    [self.contentView addSubview:self.jobLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    [self.contentView addSubview:self.containerView];
    
    self.textContentLabel = [[UILabel alloc] init];
    self.textContentLabel.font = [UIFont systemFontOfSize:SDMainMessageFont];
    self.textContentLabel.numberOfLines = 0;
    self.textContentLabel.preferredMaxLayoutWidth = 180;
    [self.containerView addSubview:self.textContentLabel];
    
    [super cellDidLoad];
}

-(void)setMessage:(CXIMMessage *)message{
    [super setMessage:message];
    
    // 是否自己发送的消息
    BOOL isFromSelf = [message.sender isEqualToString:VAL_HXACCOUNT];
    // 是否显示时间
    BOOL isNeedDisplayTime = self.isNeedDisplayTime;
    // 是否显示昵称
    BOOL isNeedDisplayNickname = message.type == CXIMMessageTypeGroupChat && !isFromSelf;
    
    self.containerView.backgroundColor = [UIColor clearColor];
    
    CXIMTextMessageBody *body = (CXIMTextMessageBody *)message.body;
    
    // 头像
    if (isNeedDisplayTime) {
        self.avatarImageView.y = CGRectGetMaxY(self.timeLabel.frame) + kTimeLabelTopBottomMargin;
    }
    else{
        self.avatarImageView.y = kTimeLabelTopBottomMargin;
    }
    self.avatarImageView.size = CGSizeMake(40, 40);
    if (isFromSelf) {
        self.avatarImageView.x = Screen_Width - 10 - self.avatarImageView.size.width;
    }
    else{
        self.avatarImageView.x = 10;
    }
    
    // 昵称(群聊+别人发出的消息才显示)
    if (isNeedDisplayNickname) {
        if([self isGroupChat]){
            self.nicknameLabel.text = [[CXLoaclDataManager sharedInstance] getUserByGroupId:self.message.receiver AndIMAccount:message.sender].name;
        }else{
            self.nicknameLabel.text = [CXIMHelper getRealNameByAccount:message.sender];
        }
        self.nicknameLabel.x = CGRectGetMaxX(self.avatarImageView.frame) + 12;
        self.nicknameLabel.y = self.avatarImageView.y;
        [self.nicknameLabel sizeToFit];
    }
    
    if (isNeedDisplayNickname && [self isGroupChat] && !isFromSelf) {
        self.jobLabel.x = CGRectGetMaxX(self.nicknameLabel.frame) + 3;
        self.jobLabel.y = self.nicknameLabel.y + 3;
        [self.jobLabel sizeToFit];
        self.jobLabel.hidden = NO;
    }else{
        self.jobLabel.hidden = YES;
    }
    
    // 文字内容
    self.textContentLabel.text = nil;
    self.textContentLabel.attributedText = nil;
    if (self.isBurnAfterReadMessage && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
        static NSMutableAttributedString *att;
        if (!att) {
            att = [[NSMutableAttributedString alloc] init];
            [att appendAttributedString:[[NSAttributedString alloc] initWithString:@"点击查看 "
                                                                        attributes:@{
                                                                                     NSForegroundColorAttributeName : [UIColor grayColor]
                                                                                     }]];
            NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
            textAtt.image = [UIImage imageNamed:@"T"];
            textAtt.bounds = CGRectMake(0, -2, 15, 15);
            [att appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAtt]];
        }
        self.textContentLabel.attributedText = att;
    }
    else {
        self.textContentLabel.text = body.textContent;
    }
    self.textContentLabel.size = [self.textContentLabel sizeThatFits:CGSizeMake(Screen_Width - 140, FLT_MAX)];
    //    self.textContentLabel.size = CGSizeMake(self.textContentLabel.size.width, MAX(30, self.textContentLabel.size.height));
    
    static CGFloat margin = 10;
    if (isFromSelf) {
        self.textContentLabel.origin = CGPointMake(9, margin);
    }
    else{
        self.textContentLabel.origin = CGPointMake(12, margin);
    }
    
    // 气泡
    self.containerView.size = self.textContentLabel.size;
    self.containerView.size = CGSizeMake(self.textContentLabel.size.width + margin * 2, self.textContentLabel.size.height + self.textContentLabel.y * 2);
    if (isNeedDisplayNickname) {
        self.containerView.y = CGRectGetMaxY(self.nicknameLabel.frame) + 1;
    }
    else{
        self.containerView.y = self.avatarImageView.y;
    }
    if (isFromSelf) {
        self.containerView.x = self.avatarImageView.x - 10 - self.containerView.size.width;
    }
    else{
        self.containerView.x = CGRectGetMaxX(self.avatarImageView.frame) + 10;
    }
    
    //气泡背景
    UIImage * backImage = [UIImage imageNamed:isFromSelf?@"CXChatGreenMessageCellBackGroundImage":@"CXChatWhiteMessageCellBackGroundImage"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:30];
    
    
    if (isFromSelf) {
        _backBtn.frame = CGRectMake(self.containerView.x, self.containerView.y, self.containerView.size.width + 5, self.containerView.size.height);
    }
    else{
        _backBtn.frame = CGRectMake(self.containerView.x - 5, self.containerView.y, self.containerView.size.width + 5, self.containerView.size.height);
    }
    
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    
    // cell高度
    self.cellHeight = CGRectGetMaxY(self.containerView.frame);
}

- (void)setJob:(NSString *)job{
    self.jobLabel.text = job;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

- (BOOL)menuItemEnabled:(CXProjectCollaborationChattingCellMenuItem)item{
    return YES;
}

#pragma mark - Action
- (void)containerViewTapped {
    if (self.isBurnAfterReadMessage && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
        [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.chatter messageIds:@[self.message.ID]];
        self.message.openFlag = CXIMMessageReadFlagReaded;
        self.message = self.message;
        self.burnAfterReadLockAndUnLockView.hidden = YES;
        [super saveBurnAfterReadTime];
    }
}

@end
