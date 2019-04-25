//
//  SDChattingVoiceCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingVoiceCell.h"
#import "PlayerManager.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface SDChattingVoiceCell () <PlayingDelegate>

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIImageView *voiceImageView;
@property (nonatomic,strong) UILabel *voiceLabel;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIView *voiceReadFlagView;

@end

@implementation SDChattingVoiceCell

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
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    [self.contentView addSubview:self.containerView];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:13];
    self.nicknameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.nicknameLabel];
    
    self.voiceImageView = [[UIImageView alloc] init];
    [self.containerView addSubview:self.voiceImageView];
    
    self.voiceLabel = [[UILabel alloc] init];
    self.voiceLabel.textColor = SDCellTimeColor;
    [self.contentView addSubview:self.voiceLabel];
    
    self.voiceReadFlagView = [[UIView alloc] init];
    self.voiceReadFlagView.backgroundColor = [UIColor redColor];
    self.voiceReadFlagView.size = CGSizeMake(8, 8);
    self.voiceReadFlagView.layer.cornerRadius = CGRectGetWidth(self.voiceReadFlagView.frame) * .5;
    self.voiceReadFlagView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.voiceReadFlagView];
    
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
    
    CXIMVoiceMessageBody *body = (CXIMVoiceMessageBody *)message.body;
    CGFloat voiceWidth;
    if([body.length integerValue] < 3){
        voiceWidth = 150.0/640.0*Screen_Width;
    }else if([body.length integerValue] <= 60 && [body.length integerValue] >= 3){
        voiceWidth = 150.0/640.0*Screen_Width + (([body.length integerValue] - 3)/57.0*(360.0 - 150.0)/640.0*Screen_Width);
    }else{
        voiceWidth = 360.0/640.0*Screen_Width;
    }
    
    // 气泡
    if (isNeedDisplayNickname) {
        self.containerView.size = CGSizeMake(voiceWidth, 41);
    }
    else{
        self.containerView.size = CGSizeMake(voiceWidth, 40);
    }
    
    
    if (isNeedDisplayNickname) {
        self.containerView.y = CGRectGetMaxY(self.nicknameLabel.frame);
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
    
    // 语音图片
    NSString *imgName = isFromSelf ? @"chat_sender_audio_playing3" : @"chat_receiver_audio_playing3";
    // 阅后即焚消息
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        imgName = @"redchat_receiver_audio_playing3";
    }
    
    self.voiceImageView.image = [UIImage imageNamed:imgName];
    self.voiceImageView.size = CGSizeMake(20.0*25.0/34.0, 20.0);
    self.voiceImageView.centerY = self.containerView.size.height * .5;
    if (isFromSelf) {
        self.voiceImageView.x = self.containerView.size.width - 9 - self.voiceImageView.size.width;
    }
    else{
        self.voiceImageView.x = 12;
    }
    
    // 语音文字
    self.voiceLabel.text = [NSString stringWithFormat:@"%@\"",body.length];
    [self.voiceLabel sizeToFit];
    self.voiceLabel.centerY = self.containerView.centerY + 5;
    if (isFromSelf) {
        self.voiceLabel.x = self.containerView.x - 5 - self.voiceLabel.size.width;
    }
    else{
        self.voiceLabel.x = CGRectGetMaxX(self.containerView.frame) + 5;
    }
    
    if (!isFromSelf && !body.isVoiceReaded) {
        self.voiceReadFlagView.hidden = NO;
        self.voiceReadFlagView.y = self.backBtn.y + 3;
        self.voiceReadFlagView.x = CGRectGetMinX(self.voiceLabel.frame) + 3;
    }
    else {
        self.voiceReadFlagView.hidden = YES;
        self.voiceLabel.centerY = self.containerView.centerY;
    }
    
    self.cellHeight = CGRectGetMaxY(self.containerView.frame);
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

#pragma mark - PlayingDelegate
-(void)playingStoped{
    [self stopPlayVoice];
}

// 点击气泡播放语音
-(void)containerViewTapped{
    [self playVoice];
}

-(void)playVoice{
    CXIMVoiceMessageBody *body = (CXIMVoiceMessageBody *)self.message.body;
    if (!self.isGroupChat && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
        [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.message.sender messageIds:@[self.message.ID]];
        self.message.openFlag = CXIMMessageReadFlagReaded;
    }
    
    if (body.downloadState == CXIMFileDownloadStateDownloading) {
        return;
    }
    //---------------------------------修改8.12－－－－－－－－－－－－－－-
    //这里先用获取到的url下载语音文件，然后下载完成后直接播放，并且播放时播放动画，并且更新语音消息为已读
    // 播放
    if (![body isFileExist]) {
        [self.message downloadFileWithProgress:^(float progress) {
            NSLog(@"下载语音:%.2f%%", progress * 100);
        } completion:^(CXIMMessage *message, NSError *error) {
            if (!error) {
                [self play:[body fullLocalPath]];
            }
        }];
    }
    else {
        [self play:[body fullLocalPath]];
    }
}

- (void)play:(NSString *)voicePath {
    CXIMVoiceMessageBody *body = (CXIMVoiceMessageBody *)self.message.body;
    [[PlayerManager sharedManager] playAudioWithFileName:voicePath playerType:(DDSpeaker) delegate:self];
    
    // 动画
    BOOL isFromSelf = [self.message.sender isEqualToString:VAL_HXACCOUNT];
    NSString *role = isFromSelf ? @"sender" : @"receiver";
    NSMutableArray *animationImages = [NSMutableArray array];
    for (int i = 1; i < 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"chat_%@_audio_playing%d",role,i];
        UIImage *image = [UIImage imageNamed:imageName];
        if(image){
            [animationImages addObject:image];
        }
    }
    // 阅后即焚消息
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        [animationImages removeAllObjects];
        for (int i = 1; i < 3; i++) {
            NSString *imageName = [NSString stringWithFormat:@"redchat_%@_audio_playing%d",role,i];
            UIImage *image = [UIImage imageNamed:imageName];
            if(image){
                [animationImages addObject:image];
            }
        }
    }
    
    self.voiceImageView.animationImages = animationImages;
    self.voiceImageView.animationDuration = .6;
    self.voiceImageView.animationRepeatCount = 0;
    [self.voiceImageView startAnimating];
    
    body.voiceReaded = YES;
    // 更新语音消息为已读
    [[CXIMService sharedInstance].chatManager updateMessageBody:self.message];
    
    self.voiceReadFlagView.hidden = YES;
    self.voiceLabel.centerY = self.containerView.centerY;
    
}

-(void)stopPlayVoice{
    [self.voiceImageView stopAnimating];
    // 阅后即焚消息处理
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        [super saveBurnAfterReadTime];
    }
}

@end
