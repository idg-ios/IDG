//
//  CXDDXVoiceMeetingDetailTableViewCell.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDDXVoiceMeetingDetailTableViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "NSString+TextHelper.h"
#import "PlayerManager.h"

#define kNameLabelLeftSpace 5.0

#define kNameLabelFontSize 12.0

#define kNameLabelBottomSpace 5.0

#define kNameLabelWidth 70.0

#define kNameLabelTopSpace ((SDHeadWidth - kNameLabelFontSize*2 - kNameLabelBottomSpace)/2)

#define kVoiceImageViewLeftSpace 10.0

#define kVoiceImageViewWidth 20.0*25.0/34.0

#define kVoiceImageViewHeight 20.0

// 公共
#define CXIM_DOCUMENT_DIR NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

/** 语音会议目录 */
#define CXIM_VOICEMEETING_DIR [CXIM_DOCUMENT_DIR stringByAppendingPathComponent:@"voiceMeeting"]

@interface CXDDXVoiceMeetingDetailTableViewCell()<PlayingDelegate>

@property (strong, nonatomic) CXDDXVoiceModel * model;

@property (nonatomic,strong) UIImageView *voiceImageView;

@property (strong, nonatomic) UIImageView* headImageView;

@property (strong, nonatomic) UILabel* nameLabel;

@property (strong, nonatomic) UILabel* jobLabel;

@property (nonatomic,strong) UIButton * backBtn;

@property (nonatomic,strong) UIView *containerView;

@end

@implementation CXDDXVoiceMeetingDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGBACOLOR(235.0, 235.0, 235.0, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_backBtn){
        [_backBtn removeFromSuperview];
        _backBtn = nil;
    }
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_backBtn];
    
    if(_voiceImageView){
        [_voiceImageView removeFromSuperview];
        _voiceImageView = nil;
    }
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.image = [UIImage imageNamed:@"chat_receiver_audio_playing3"];
    _voiceImageView.highlightedImage = [UIImage imageNamed:@"chat_receiver_audio_playing3"];
    [self.contentView addSubview:_voiceImageView];
    
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing + SDHeadWidth + kNameLabelLeftSpace, SDHeadImageViewLeftSpacing + kNameLabelTopSpace, kNameLabelWidth, kNameLabelFontSize);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
    _nameLabel.textColor = [UIColor blackColor];
    
    if(_jobLabel){
        [_jobLabel removeFromSuperview];
        _jobLabel = nil;
    }
    _jobLabel = [[UILabel alloc] init];
    _jobLabel.textAlignment = NSTextAlignmentCenter;
    _jobLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing + SDHeadWidth + kNameLabelLeftSpace, SDHeadImageViewLeftSpacing + kNameLabelTopSpace + kNameLabelFontSize + kNameLabelBottomSpace, kNameLabelWidth, kNameLabelFontSize);
    _jobLabel.backgroundColor = [UIColor clearColor];
    _jobLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
    _jobLabel.textColor = SDCellTimeColor;
    
    if(_containerView){
        [_containerView removeFromSuperview];
        _containerView = nil;
    }
    _containerView = [[UIView alloc] init];
//    [_containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    _containerView.userInteractionEnabled = NO;
    [self.contentView addSubview:_containerView];
}

- (void)setCXDDXVoiceModel:(CXDDXVoiceModel *)model;
{
    self.model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:(self.model.icon && ![self.model.icon isKindOfClass:[NSNull class]])?self.model.icon:@""] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = self.model.name;
    [self.contentView addSubview:_nameLabel];
    
    _jobLabel.text = self.model.job;
//    [self.contentView addSubview:_jobLabel];
    
    CGFloat voiceWidth;
    if([self.model.length integerValue] < 3){
        voiceWidth = 150.0/640.0*Screen_Width;
    }else if([self.model.length integerValue] <= 60 && [self.model.length integerValue] >= 3)
    {
        voiceWidth = 150.0/640.0*Screen_Width + (([self.model.length integerValue] - 3)/57.0*(360.0 - 150.0)/640.0*Screen_Width);
    }else{
        voiceWidth = 360.0/640.0*Screen_Width;
    }
    UIImage * backImage = [UIImage imageNamed:@"CXChatWhiteMessageCellBackGroundImage"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:30];
    _backBtn.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + kNameLabelLeftSpace, 10, voiceWidth, SDCellHeight - 20);
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    
    _voiceImageView.frame = CGRectMake(CGRectGetMinX(_backBtn.frame) + kVoiceImageViewLeftSpace, (SDCellHeight - kVoiceImageViewHeight)/2, kVoiceImageViewWidth, kVoiceImageViewHeight);
    
    _containerView.frame = _backBtn.frame;
}

#pragma mark - PlayingDelegate
-(void)playingStoped{
    [self stopPlayVoice];
}

// 点击气泡播放语音
-(void)containerViewTapped{
    [self playVoice];
}

- (void)voiceImageViewActive{
    NSString *role = @"receiver";
    NSMutableArray *animationImages = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"chat_%@_audio_playing%d",role,i];
        UIImage *image = [UIImage imageNamed:imageName];
        if(image){
            [animationImages addObject:image];
        }
    }
    self.voiceImageView.animationImages = animationImages;
    self.voiceImageView.animationDuration = .6;
    self.voiceImageView.animationRepeatCount = 0;
    [self.voiceImageView startAnimating];
}

-(void)playVoice{
    // 文件名
    NSString *fileName = [NSString stringWithFormat:@"%zd.spx", [self.model.eid integerValue]];
    // 文件路径
    NSString * filePath = [CXIM_VOICEMEETING_DIR stringByAppendingPathComponent:fileName];
    [self play:filePath];
}

- (void)play:(NSString *)voicePath {
    [[PlayerManager sharedManager] playAudioWithFileName:voicePath playerType:(DDSpeaker) delegate:self];
    NSString *role = @"receiver";
    NSMutableArray *animationImages = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"chat_%@_audio_playing%d",role,i];
        UIImage *image = [UIImage imageNamed:imageName];
        if(image){
            [animationImages addObject:image];
        }
    }
    self.voiceImageView.animationImages = animationImages;
    self.voiceImageView.animationDuration = .6;
    self.voiceImageView.animationRepeatCount = 0;
    [self.voiceImageView startAnimating];
}

-(void)stopPlayVoice{
    [self.voiceImageView stopAnimating];
}

- (void)reloadImageView{
    if(_voiceImageView){
        [_voiceImageView removeFromSuperview];
        _voiceImageView = nil;
    }
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.image = [UIImage imageNamed:@"chat_receiver_audio_playing3"];
    _voiceImageView.highlightedImage = [UIImage imageNamed:@"chat_receiver_audio_playing3"];
    _voiceImageView.frame = CGRectMake(CGRectGetMinX(_backBtn.frame) + kVoiceImageViewLeftSpace, (SDCellHeight - kVoiceImageViewHeight)/2, kVoiceImageViewWidth, kVoiceImageViewHeight);
    [self.contentView addSubview:_voiceImageView];
}

@end
