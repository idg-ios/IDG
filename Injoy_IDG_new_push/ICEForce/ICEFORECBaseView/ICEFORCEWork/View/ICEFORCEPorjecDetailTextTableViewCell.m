//
//  ICEFORCEPorjecDetailTextTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/11.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPorjecDetailTextTableViewCell.h"
#import "YYText.h"
#import "PlayerManager.h"



@interface ICEFORCEPorjecDetailTextTableViewCell()<PlayingDelegate>

@property (weak, nonatomic) IBOutlet UIView *subsView;

@property (nonatomic ,strong) YYLabel *yyLabel;

@property (nonatomic ,strong) UILabel *pjLabel;
@property (nonatomic ,strong) UIView *voiceImage;
@property (nonatomic ,strong) UIButton *playButton;
@property (nonatomic ,strong) UIImageView *playImageView;
@property (nonatomic ,strong) UILabel *voiceTimeLabel;

@end

@implementation ICEFORCEPorjecDetailTextTableViewCell

-(YYLabel *)yyLabel{
    if (!_yyLabel) {
        _yyLabel = [[YYLabel alloc]init];
        _yyLabel.font = [UIFont systemFontOfSize:15];
        _yyLabel.numberOfLines = 0;
        _yyLabel.textColor = [UIColor blackColor];
    }
    return _yyLabel;
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
-(UILabel *)pjLabel{
    if (!_pjLabel) {
        _pjLabel = [[UILabel alloc]init];
        _pjLabel.font = [UIFont systemFontOfSize:15];
        _pjLabel.textColor = [UIColor blueColor];
    }
    return _pjLabel;
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
    
    [self loadSubView];
}


-(void)loadSubView{
    [MyPublicClass layerMasksToBoundsForAnyControls:self.iconImageView cornerRadius:15 borderColor:nil borderWidth:0];
    [self.subsView addSubview:self.yyLabel];
    [self.subsView addSubview:self.voiceImage];
    [self.subsView addSubview:self.pjLabel];
    
}

-(void)setDetailModel:(ICEFORCEWorkProjectModel *)detailModel{
    
    _detailModel = detailModel;
    
    NSString *contentType;
    NSString *followType;
    if ([MyPublicClass stringIsNull:detailModel.pjId]) {
        NSString *string = [detailModel.createTime substringToIndex:10];
        self.dateTime.text = string;
        
        self.userName.text = detailModel.followName;
        contentType  = detailModel.contentType;
        
        followType  = detailModel.followType;
    }else{
        NSString *string = [detailModel.createDate substringToIndex:10];
        self.dateTime.text = string;

        self.userName.text = detailModel.createByName;
        contentType  = detailModel.noteType;
        
        followType  = detailModel.followType;
    }
    
    
    if ([contentType isEqualToString:@"TEXT"] ) {
        
        NSString *pjName;
        NSString *all;
        if ([MyPublicClass stringIsNull:self.detailModel.pjId]) {
           pjName = [NSString stringWithFormat:@"#%@#",detailModel.projName];
             NSString *descString = detailModel.showDesc;
             all = [NSString stringWithFormat:@"%@ %@",pjName,descString];
        }else{
            all = detailModel.note;
        }

        CGRect rect = [self selectAttString:all];
        
        self.voiceImage.hidden = YES;
        
        if (detailModel.isShowMore == YES) {
            self.subsViewH.constant = rect.size.height;
            detailModel.dscHeight = self.subsViewH.constant;

        }else{
            self.subsViewH.constant = 49;
            detailModel.dscHeight = 49;
        }
        
        if (![followType isEqualToString:@"UPDATE_STATE"]) {
        
             self.yyLabel.frame = CGRectMake(0, 0,ScreenWidth-100, self.subsViewH.constant);
            
            if ([MyPublicClass stringIsNull:self.detailModel.pjId]) {
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",all]];
                NSRange range = [all rangeOfString:pjName];
                
                [attString yy_setTextHighlightRange:range color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    NSLog(@"卧槽，居然能点击%@",text);
                    //    if ([self.delegateCell respondsToSelector:@selector(showTextCell:selectText:)]) {
                    //        [self.delegateCell showTextCell:self selectText:sender.currentTitle];
                    //    }
                }];
                
                self.yyLabel.attributedText = attString;
            }else{
                self.yyLabel.text = all;
            }

            
        }else{
            
            self.yyLabel.frame = CGRectMake(0, 0,ScreenWidth-100, self.subsViewH.constant);
            NSString *pjState = [NSString stringWithFormat:@"#%@#",detailModel.projState];
            
            NSString *stateAll = [NSString stringWithFormat:@"%@%@",all,pjState];
            
            NSMutableAttributedString *stateAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",stateAll]];
            NSRange range = [stateAll rangeOfString:pjName];
            NSRange pjStateRange = [stateAll rangeOfString:pjState];
            
            
            [stateAtt yy_setTextHighlightRange:range color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"卧槽，居然能点击%@",[text attributedSubstringFromRange:range]);
                //    if ([self.delegateCell respondsToSelector:@selector(showTextCell:selectText:)]) {
                //        [self.delegateCell showTextCell:self selectText:sender.currentTitle];
                //    }
            }];
            
            [stateAtt yy_setTextHighlightRange:pjStateRange color:[UIColor lightGrayColor] backgroundColor:nil userInfo:nil];
            
            self.yyLabel.attributedText = stateAtt;
            
        }
    }else{
        self.voiceImage.hidden = NO;
        if ([MyPublicClass stringIsNull:self.detailModel.pjId]) {
            
            NSString *pjName = [NSString stringWithFormat:@"#%@#",detailModel.projName];
            CGRect h = [self selectAttString:pjName];
            self.pjLabel.frame = CGRectMake(0, 0, h.size.width+10, self.subsView.frame.size.height);
            self.pjLabel.text = pjName;
            self.voiceImage.frame = CGRectMake(CGRectGetMaxX(self.pjLabel.frame), 0, 100, self.subsView.frame.size.height);
        }else{
            self.voiceImage.frame = CGRectMake(0, 0, 100, self.subsView.frame.size.height);
        }
       
       
        
        [self playVocie];
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
    if (self.detailModel.audioTime.integerValue == 0) {
        self.playImageView.animationRepeatCount = 5;
    }else{
        self.playImageView.animationRepeatCount = self.detailModel.audioTime.integerValue;
    }
    [self.voiceImage addSubview:self.playImageView];
    
    self.voiceTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playImageView.frame)+4, 10, self.voiceImage.frame.size.width- CGRectGetMaxX(self.playImageView.frame)-4, 20);
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%ld“",self.detailModel.audioTime.integerValue];
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
    
    NSString *voiceURL = self.detailModel.url;
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


-(CGRect)selectAttString:(NSString *)attString{
    
    CGRect rect = [MyPublicClass stringHeightByWidth:ScreenWidth-100 title:attString font:[UIFont systemFontOfSize:15]];
    return rect;
}




#pragma mark - 项目点击跳转
-(void)loadShowText{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.attString];
    NSRange range = [self.attString rangeOfString:self.selectString];
    
    [attString yy_setTextHighlightRange:range color:[UIColor blueColor] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"卧槽，居然能点击");
        //    if ([self.delegateCell respondsToSelector:@selector(showTextCell:selectText:)]) {
        //        [self.delegateCell showTextCell:self selectText:sender.currentTitle];
        //    }
    }];
    self.yyLabel.attributedText = attString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
