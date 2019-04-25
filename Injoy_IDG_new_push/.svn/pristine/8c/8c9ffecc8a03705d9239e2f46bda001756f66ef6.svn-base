//
//  SDChattingVideoCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SDVideoHelper.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"
#import "UIImageView+WebCache.h"
#import "CXLoaclDataManager.h"

@interface SDChattingVideoCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIImageView *videoImageView;
@property (nonatomic,strong) UIButton *videoplayBtn;
@property (nonatomic,strong) MPMoviePlayerViewController *player;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UIImageView *downloadImageView;

@end

static NSMutableDictionary *thumbnails_;

@implementation SDChattingVideoCell

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)]) {
        [self initCell];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCell{
    [super initCell];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"avatar-user"];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:13];
    self.nicknameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.nicknameLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)]];
    [self.contentView addSubview:self.containerView];
    
    self.videoImageView = [[UIImageView alloc] init];
    [self.containerView addSubview:self.videoImageView];
    
    self.videoplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.videoplayBtn setBackgroundImage:[UIImage imageNamed:@"chat_view_play_mormal"] forState:UIControlStateNormal];
    
    self.videoplayBtn.imageView.userInteractionEnabled = NO;
    [self.videoplayBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView insertSubview:self.videoplayBtn aboveSubview:self.videoImageView];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.containerView insertSubview:self.loadingView aboveSubview:self.videoImageView];
    
    self.downloadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-video-down"]];
    [self.containerView insertSubview:self.downloadImageView aboveSubview:self.videoImageView];
    
    thumbnails_ = thumbnails_ ?: @{}.mutableCopy;
    
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
    self.loadingView.hidden =  YES;
    self.videoplayBtn.hidden = YES;
    self.downloadImageView.hidden = YES;
    
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
    
    // 阅后即焚消息
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        [self.videoplayBtn setBackgroundImage:[UIImage imageNamed:@"chat_view_play_burnAfterRead"] forState:UIControlStateNormal];
    }
    else {
        [self.videoplayBtn setBackgroundImage:[UIImage imageNamed:@"chat_view_play_mormal"] forState:UIControlStateNormal];
    }
    
    CXIMVideoMessageBody *body = (CXIMVideoMessageBody *)message.body;
    
    UIImage *thumbnailImage = thumbnails_[message.ID];
    if (thumbnailImage) {
        self.videoImageView.image = thumbnailImage;
    }
    else {
        thumbnailImage = [body thumbnailImage];
        thumbnails_[message.ID] = thumbnailImage;
    }
    
    // 设置缩略图
    self.videoImageView.image = thumbnailImage;
    
    self.videoImageView.size = CGSizeMake(160, 160);
    
    
    if (isNeedDisplayNickname) {
        self.videoImageView.origin = CGPointMake(0, 1);
    }
    else{
        self.videoImageView.origin = CGPointMake(0, 0);
    }
    
    // 气泡
    self.containerView.size = self.videoImageView.size;
    self.containerView.size = CGSizeMake(self.containerView.size.width + self.videoImageView.x * 2, self.containerView.size.height + self.videoImageView.y * 2);
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
    UIImage * backImage = [UIImage imageNamed:isFromSelf?@"CXChatWhiteCellSendBorderBackGroundImage":@"CXChatWhiteCellReceiveBorderBackGroundImage"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:30];
    
    if (isFromSelf) {
        _backBtn.frame = CGRectMake(self.containerView.x, self.containerView.y + 1, self.videoImageView.size.width + 5, self.containerView.size.height - 2);
    }
    else{
        _backBtn.frame = CGRectMake(self.containerView.x - 5, self.containerView.y + 1, self.videoImageView.size.width + 5, self.containerView.size.height - 2);
    }
    
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    // 播放按钮
    self.videoplayBtn.size = CGSizeMake(55, 55);
    self.videoplayBtn.centerX = self.containerView.size.width / 2.0;
    self.videoplayBtn.centerY = self.containerView.size.height / 2.0;
    self.cellHeight = CGRectGetMaxY(self.containerView.frame);
    
    self.loadingView.centerX = self.containerView.size.width / 2.0;
    self.loadingView.centerY = self.containerView.size.height / 2.0;
    
    //    self.downloadImageView.centerX = self.containerView.size.width / 2.0;
    //    self.downloadImageView.centerY = self.containerView.size.height / 2.0;
    
    if ([body isFileExist]) {
        self.videoplayBtn.hidden = NO;
    }
    else {
        if (body.downloadState == CXIMFileDownloadStateDownloading) {
            self.loadingView.hidden = NO;
        }
        else {
            //            self.downloadImageView.hidden = NO;
            self.videoplayBtn.hidden = NO;
        }
    }
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

-(void)playVideo{
    CXIMVideoMessageBody *body = (CXIMVideoMessageBody *)self.message.body;
    if (body.downloadState == CXIMFileDownloadStateDownloading) {
        return;
    }
    //---------------------------------修改8.12－－－－－－－－－－－－－－-
    //这里点击缩略图开始根据视频的url来下载小视频，下载完成后，再次点击小视频播放
    if (![body isFileExist]) {
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
        self.videoplayBtn.hidden = YES;
        //        self.downloadImageView.hidden = YES;
        [self.message downloadFileWithProgress:^(float progress) {
            self.loadingView.hidden = NO;
            //            self.downloadImageView.hidden = YES;
            NSLog(@"下载视频:%.2f%%", progress * 100);
        } completion:^(CXIMMessage *message, NSError *error) {
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            if (!error) {
                self.videoplayBtn.hidden = NO;
                [self play:[body fullLocalPath]];
            }
            else {
                //                self.downloadImageView.hidden = NO;
            }
        }];
    }
    else {
        [self play:body.fullLocalPath];
    }
}

- (void)play:(NSString *)videoPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
        self.player.view.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayFinishedNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [self.viewController presentMoviePlayerViewControllerAnimated:self.player];
        if (!self.isGroupChat && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
            [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.message.sender messageIds:@[self.message.ID]];
            self.message.openFlag = CXIMMessageReadFlagReaded;
        }
        // 阅后即焚消息处理
        if (self.isBurnAfterReadMessage && !self.isFromSelf) {
            [super saveBurnAfterReadTime];
        }
    });
}

- (void)receivePlayFinishedNotification:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"播放完成");
    
    // 阅后即焚消息处理
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        [super saveBurnAfterReadTime];
    }
}

@end
