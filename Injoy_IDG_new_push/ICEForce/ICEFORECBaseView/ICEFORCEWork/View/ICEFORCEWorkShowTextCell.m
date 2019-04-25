//
//  ICEFORCEWorkShowTextCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/9.
//  Copyright © 2019 Injoy. All rights reserved.
//


#import "ICEFORCEWorkShowTextCell.h"
#import "PlayerManager.h"


@interface ICEFORCEWorkShowTextCell()<PlayingDelegate>

@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,strong) UIButton *attLabel;

@property (nonatomic ,strong) UILabel *msgLabel;

@property (nonatomic ,strong) UILabel *stateLabel;

@property (nonatomic ,strong) UIView *voiceImage;
@property (nonatomic ,strong) UIButton *playButton;
@property (nonatomic ,strong) UIImageView *playImageView;
@property (nonatomic ,strong) UILabel *voiceTimeLabel;

@property (nonatomic ,strong) UILongPressGestureRecognizer *longGes;


@end

@implementation ICEFORCEWorkShowTextCell

#pragma mark - 懒加载模块

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBA(242, 242, 242, 1);
    }
    return _lineView;
}

-(UIButton *)attLabel{
    if (!_attLabel) {
        _attLabel = [[UIButton alloc]init];
        _attLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_attLabel setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_attLabel addTarget:self action:@selector(jumpProjectDetail:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _attLabel;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.font = [UIFont systemFontOfSize:15];
        _msgLabel.userInteractionEnabled = YES;
        _msgLabel.numberOfLines = 1;
    }
    return _msgLabel;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textColor = [UIColor lightGrayColor];
        _stateLabel.numberOfLines = 1;
    }
    return _stateLabel;
}

-(UIView *)voiceImage{
    if (!_voiceImage) {
        _voiceImage = [[UIView alloc]init];
    }
    return _voiceImage;
}

-(UIButton *)playButton{
    if (!_playButton) {
        
        _playButton = [[UIButton alloc]init];
        [_playButton setImage:[UIImage imageNamed:@"approvalbackground"] forState:(UIControlStateNormal)];
    }
    return _playButton;
}
-(UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc]init];
        _playImageView.image = [UIImage imageNamed:@"chat_receiver_audio_voice_playing_003"];
        _playImageView.contentMode = UIViewContentModeCenter;
    }
    return _playImageView;
}
-(UILabel *)voiceTimeLabel{
    if (!_voiceTimeLabel) {
        _voiceTimeLabel = [[UILabel alloc]init];
        _voiceTimeLabel.textColor = [UIColor lightGrayColor];
        _voiceTimeLabel.font = [UIFont systemFontOfSize:12];
        _voiceTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _voiceTimeLabel;
}

-(UILongPressGestureRecognizer *)longGes{
    if (!_longGes) {
        _longGes = [[UILongPressGestureRecognizer alloc]init];
    }
    return _longGes;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadSubView];

    }
    return self;
}

-(void)loadSubView{
    
    [self addSubview:self.lineView];
    [self addSubview:self.attLabel];
    [self addSubview:self.msgLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.voiceImage];
    
   
   
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    
    if (self.options != ICEFORCEWorkShowOptionGif && _isLongPress == YES) {
        
        [self.longGes addTarget:self action:@selector(longPressCellHandle:)];
        [self.msgLabel addGestureRecognizer:self.longGes];
    }
    
    self.lineView.frame = CGRectMake(15, CGRectGetHeight(self.frame)-1, self.frame.size.width-15, 1);
    
    
    NSString *selectString = [NSString stringWithFormat:@"#%@#",self.selectString];
    
    CGFloat stringW = [self selectAttString:selectString];
    CGFloat H = self.frame.size.height;
    CGFloat W = self.frame.size.width;
   
    self.attLabel.frame = CGRectMake(15, 0, stringW ,H - 1 );
    
    self.msgLabel.text = self.attString;
    self.stateLabel.text = [NSString stringWithFormat:@"#%@#",self.stateString];
    [self.attLabel setTitle:selectString forState:(UIControlStateNormal)];
    switch (self.options) {
        case ICEFORCEWorkShowOptionAttText:{
            
            self.voiceImage.hidden = YES;
            self.stateLabel.hidden = YES;
            self.msgLabel.hidden = NO;

            self.msgLabel.frame = CGRectMake(CGRectGetMaxX(self.attLabel.frame)+8, 0,W - CGRectGetMaxX(self.attLabel.frame) - 15 - 8 , H);
            
        }
            break;
        case ICEFORCEWorkShowOptionText:{
            
            self.voiceImage.hidden = YES;
            self.stateLabel.hidden = NO;
            self.msgLabel.hidden = NO;

            CGFloat msgW = [self selectAttString:self.attString];

            self.msgLabel.frame = CGRectMake(CGRectGetMaxX(self.attLabel.frame)+ 8, 0, msgW , H);
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.msgLabel.frame)+ 8, 0, W - CGRectGetMaxX(self.msgLabel.frame)-15-8, H);

        }
            break;
        case ICEFORCEWorkShowOptionGif:{
            
            self.stateLabel.hidden = YES;
            self.msgLabel.hidden = YES;
            self.voiceImage.hidden = NO;
            
            self.voiceImage.frame = CGRectMake(CGRectGetMaxX(self.attLabel.frame)+ 8, 0, 100, H);
            
            [self playVocie];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 点击下载语音文件

-(void)playVocie{
    self.playButton.frame = CGRectMake(0, 0, self.voiceImage.frame.size.width, self.voiceImage.frame.size.height);
    [self.playButton setBackgroundColor:[UIColor whiteColor]];
    [self.voiceImage addSubview:self.playButton];
    
    [self.playButton addTarget:self action:@selector(playVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<=3; i++) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"chat_receiver_audio_voice_playing_00%d",i]];
        [imageArray addObject:imageName];
    }
    
    self.playImageView.frame = CGRectMake(15, 0, 20, self.voiceImage.frame.size.height);
    self.playImageView.animationImages = imageArray;
    self.playImageView.animationDuration = 1;
    if (self.voiceTime == 0) {
        self.playImageView.animationRepeatCount = 5;
    }else{
        self.playImageView.animationRepeatCount = self.voiceTime;
    }
    [self.voiceImage addSubview:self.playImageView];
    
    
    self.voiceTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playImageView.frame)+4, 10, self.voiceImage.frame.size.width- CGRectGetMaxX(self.playImageView.frame)-4, 20);
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld“",self.voiceTime];
    [self.voiceImage addSubview:self.voiceTimeLabel];
}
#pragma mark - 语音播放
-(void)playVoice:(UIButton *)sender{
    
    if ((sender.selected =! sender.selected)) {
        [self uploadVoice];
        [self startAnima];
//        [self startVoice];
    }else{
        [self stopAnima];
        [self stopVoice];
        
    }
    
}
#pragma mark - 下载语音
-(void)uploadVoice{
    
    NSString *voiceURL = self.voiceUrl;
    NSURL *url = [NSURL URLWithString:voiceURL];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/voice/iceforceVoice.spx", docDirPath];
    [audioData writeToFile:filePath atomically:YES];
    [self startVoice:filePath];
}

#pragma mark - 播放本地语音文件
- (void)startVoice:(NSString *)path{
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    if ([manger fileExistsAtPath:path]) {
        
        PlayerManager *playManager = [PlayerManager sharedManager];
        [playManager playAudioWithFileName:path delegate:self];
    }else{
        CXAlert(@"播放失败,文件不存在");
        [self stopAnima];
        [self stopVoice];
    }
}
#pragma amrk - 暂定语音
-(void)stopVoice{
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager stopPlaying];
}
#pragma mark - 语音播放代理
- (void)playingStoped{
    
}
- (void)dealloc {
    //暂停录音播放
    [self stopVoice];
    [self stopAnima];
    
}

#pragma mark - 语音播放动画
-(void)startAnima{
    [self.playImageView startAnimating];
}

-(void)stopAnima{
    [self.playImageView stopAnimating];
}

-(CGFloat)selectAttString:(NSString *)attString{
    
     CGFloat w = [MyPublicClass widthWithFont:[UIFont systemFontOfSize:15] constrainedToHeight:self.frame.size.height-1 content:attString];
    return w;
}

#pragma mark - 项目点击跳转
-(void)jumpProjectDetail:(UIButton *)sender{
   
    if ([self.delegateCell respondsToSelector:@selector(showTextCell:selectIndex:)]) {
        [self.delegateCell showTextCell:self selectIndex:self.indexPath];
    }
}

#pragma mark - 语音
-(void)loadShowGif{
    
}

#pragma mark - 长按提示
-(void)longPressCellHandle:(UILongPressGestureRecognizer *)gesture

{
    
    [self becomeFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyBtnPressed:)];
    
    menuController.menuItems = @[copyItem];
    
    CGFloat x = gesture.view.frame.origin.x;
    CGFloat y = gesture.view.frame.origin.y;
    CGFloat w = gesture.view.frame.size.width;
    CGFloat h = gesture.view.frame.size.height;
    
    [menuController setTargetRect:CGRectMake(x, y+15, w, h) inView:gesture.view.superview];
    
    [menuController setMenuVisible:YES animated:YES];
    
    [UIMenuController sharedMenuController].menuItems=nil;
    
}

#pragma mark - 长按方法
-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem{
    
    if ([self.delegateCell respondsToSelector:@selector(showTextCell:jumpDescDetail:)]) {
        [self.delegateCell showTextCell:self jumpDescDetail:self.msgLabel.text];
    }
}

-(BOOL)canBecomeFirstResponder

{
    
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if (action == @selector(menuCopyBtnPressed:)) {
        
        return YES;
        
    }
    
    return NO;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
