//
//  ICEFORCEPotentialDetailTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPotentialDetailTableViewCell.h"
#import "YYText.h"
#import "PlayerManager.h"

@interface ICEFORCEPotentialDetailTableViewCell()<PlayingDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (nonatomic ,strong) YYLabel *yyLabel;

@property (nonatomic ,strong) UIButton *voiceButton;
@property (nonatomic ,strong) UIImageView *playImageView;
@property (nonatomic ,strong) UILabel *voiceTimeLabel;
@end

@implementation ICEFORCEPotentialDetailTableViewCell

-(YYLabel *)yyLabel{
    if (!_yyLabel) {
        _yyLabel = [[YYLabel alloc]init];
        _yyLabel.font = [UIFont systemFontOfSize:15];
        _yyLabel.textColor = [UIColor blackColor];
        _yyLabel.numberOfLines = 0;
    }
    return _yyLabel;
}
-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc]init];
        [_voiceButton setImage:[UIImage imageNamed:@"approvalbackground"] forState:(UIControlStateNormal)];
    }
    return _voiceButton;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)layoutIfNeeded{
    
    NSString *string = [self.model.createDate substringToIndex:10];
    
    NSString *timeString = string;
    
    switch (self.option) {
        case ICEFORCEPotentialDetailCellOptionText:{
            self.yyLabel.frame = CGRectMake(15, 0,self.frame.size.width-30 , self.frame.size.height);
            self.yyLabel.text = self.attString;
            self.yyLabel.numberOfLines = 0;
            [_baseView addSubview:self.yyLabel];
        }
            break;
        case ICEFORCEPotentialDetailCellOptionAttText:{
            
            self.yyLabel.frame = CGRectMake(15, 0,self.frame.size.width-30 , self.frame.size.height);
            [_baseView addSubview:self.yyLabel];
            
            NSString *prjString = [NSString stringWithFormat:@"#%@#",self.model.createByName];
            
            NSString *prjAllString = [NSString stringWithFormat:@"%@%@%@",timeString,prjString,self.model.note];
            
            NSRange range_prj = [prjAllString rangeOfString:prjString];
            
            NSMutableAttributedString *prjAttString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",prjAllString]];
            
            [prjAttString yy_setTextHighlightRange:range_prj color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
            }];
            
            self.yyLabel.attributedText = prjAttString;

        }
            break;
        case ICEFORCEPotentialDetailCellOptionState:{
            
            self.yyLabel.frame = CGRectMake(15, 0,self.frame.size.width-30 , self.frame.size.height);
            [_baseView addSubview:self.yyLabel];
            
            NSString *stateString = [NSString stringWithFormat:@"#%@#",self.model.projState];
            
            NSString *statePrjString = [NSString stringWithFormat:@"#%@#",self.model.createByName];

            
            NSString *stateAllString = [NSString stringWithFormat:@"%@%@%@%@",timeString,statePrjString,self.model.note,stateString];
            
            NSMutableAttributedString *stateAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",stateAllString]];
            
            NSRange range_state = [stateAllString rangeOfString:stateString];
            NSRange range_prj = [stateAllString rangeOfString:statePrjString];
            
            [stateAtt yy_setTextHighlightRange:range_prj color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
            }];
            
            [stateAtt yy_setTextHighlightRange:range_state color:[UIColor lightGrayColor] backgroundColor:nil userInfo:nil];
            
            self.yyLabel.attributedText = stateAtt;
            
        }
            break;
        case ICEFORCEPotentialDetailCellOptionVoice:{
            
            NSString *voiceState;
            NSString *voicePrj;
            NSString *voiceAll;
            NSMutableAttributedString *voiceAtt;
            NSRange voicePrjRange;
            NSRange voiceStateRange;
            if ([MyPublicClass stringIsNull:self.model.projState]) {
               
                voicePrj = [NSString stringWithFormat:@"#%@#",self.model.createByName];
                voiceAll = [NSString stringWithFormat:@"%@%@",timeString,voicePrj];
                
               voiceAtt =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",voiceAll]];
                voicePrjRange = [voiceAll rangeOfString:voicePrj];
                
                
            }else{
                voiceState = [NSString stringWithFormat:@"#%@#",self.model.projState];
                voicePrj = [NSString stringWithFormat:@"#%@#",self.model.followName];
                voiceAll = [NSString stringWithFormat:@"%@%@%@",timeString,voicePrj,voiceState];
                
                voicePrjRange = [voiceAll rangeOfString:voicePrj];

                voiceStateRange = [voiceAll rangeOfString:voiceState];
                
                 voiceAtt =  [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",voiceAll]];
                
                [voiceAtt yy_setTextHighlightRange:voiceStateRange color:[UIColor lightGrayColor] backgroundColor:nil userInfo:nil];
                
            }
            
            [voiceAtt yy_setTextHighlightRange:voicePrjRange color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
            }];
            
            CGRect rect = [MyPublicClass stringHeightByWidth:_baseView.frame.size.width-30 title:voiceAll font:[UIFont systemFontOfSize:15]];
            
            self.yyLabel.frame = CGRectMake(15, 0,rect.size.width, _baseView.frame.size.height);
            [_baseView addSubview:self.yyLabel];
            self.yyLabel.attributedText = voiceAtt;
            
            [self playVocie];
            
        }
            break;
        default:
            break;
    }
   
}

#pragma mark - 点击下载语音文件
-(void)playVocie{
    self.voiceButton.frame = CGRectMake(CGRectGetMaxX(self.yyLabel.frame), 0, 100, _baseView.frame.size.height);
    [_baseView addSubview:self.voiceButton];
    [self.voiceButton setBackgroundColor:[UIColor whiteColor]];
    [self.baseView addSubview:self.voiceButton];
    [self.voiceButton addTarget:self action:@selector(playVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<=3; i++) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"chat_receiver_audio_voice_playing_00%d",i]];
        [imageArray addObject:imageName];
    }
    
    self.playImageView.frame = CGRectMake(CGRectGetMaxX(self.yyLabel.frame)+15, 0, 20, self.baseView.frame.size.height);
    self.playImageView.animationImages = imageArray;
    self.playImageView.animationDuration = 1;
    if (self.model.audioTime.integerValue == 0) {
        self.playImageView.animationRepeatCount = 5;
    }else{
        self.playImageView.animationRepeatCount = self.model.audioTime.integerValue;
    }
    [self.baseView addSubview:self.playImageView];
    
    self.voiceTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playImageView.frame)+4, 10, self.baseView.frame.size.width- CGRectGetMaxX(self.playImageView.frame)-4, 20);
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld“",self.model.audioTime.integerValue];
    [self.baseView addSubview:self.voiceTimeLabel];
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
    
    NSString *voiceURL = self.model.url;
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
