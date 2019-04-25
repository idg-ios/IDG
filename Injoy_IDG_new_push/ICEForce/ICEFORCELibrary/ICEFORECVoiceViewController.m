//
//  ICEFORECVoiceViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/16.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORECVoiceViewController.h"
#import "RecorderManager.h"

@interface ICEFORECVoiceViewController ()<RecordingDelegate>

@property (nonatomic ,strong) UIImageView *voiceImageView;
@property (nonatomic ,strong) NSMutableArray *voiceImageArray;
@property(nonatomic, strong) RecorderManager *recordManager;
@property (nonatomic ,strong) NSString *removePath;

@end

@implementation ICEFORECVoiceViewController

-(UIImageView *)voiceImageView{
    if (!_voiceImageView) {
        _voiceImageView = [[UIImageView alloc]init];
        _voiceImageView.image = [UIImage imageNamed:@"newvoiceChatImage001"];
        
    }
    return _voiceImageView;
}
-(NSMutableArray *)voiceImageArray{
    if (!_voiceImageArray) {
        _voiceImageArray = [[NSMutableArray alloc]init];
    }
    return _voiceImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
}
-(void)loadSubView{
    
    self.recordManager = [RecorderManager sharedManager];
    self.recordManager.delegate = self;
    //    self.removePath = self.recordManager.fileName;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    
    for (int i  = 0;i < 7 ; i++) {
        UIImage *imageNames = [UIImage imageNamed:[NSString stringWithFormat:@"newvoiceChatImage00%d",i]];
        [self.voiceImageArray addObject:imageNames];
    }
    
    
    self.voiceImageView.frame = CGRectMake(0, 0, 125, 125);
    self.voiceImageView.center = CGPointMake(Screen_Width/2.f, Screen_Height/2.f);
    self.voiceImageView.animationImages = self.voiceImageArray;
    self.voiceImageView.animationDuration = 1.5f;
    self.voiceImageView.animationRepeatCount = 0;
    self.voiceImageView.hidden = YES;
    [self.view addSubview:self.voiceImageView];
    
    UILabel *voiceLabel = [[UILabel alloc]initWithFrame:(CGRectMake((ScreenWidth-120)/2, ScreenHeight-K_Height_Origin_TabBar-128, 120, 20))];
    voiceLabel.textColor = [UIColor whiteColor];
    voiceLabel.font = [UIFont systemFontOfSize:14];
    voiceLabel.text = @"按住说话";
    voiceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:voiceLabel];
    
    UIButton *voiceButton = [[UIButton alloc]initWithFrame:(CGRectMake((ScreenWidth-66)/2,CGRectGetMaxY(voiceLabel.frame)+8, 66, 66))];
    [voiceButton setImage:[UIImage imageNamed:@"record_button"] forState:(UIControlStateNormal)];
    [self.view addSubview:voiceButton];
    [voiceButton addTarget:self action:@selector(voiceStart:) forControlEvents:UIControlEventTouchDown];
    [voiceButton addTarget:self action:@selector(voiceEnd:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButton addTarget:self action:@selector(voiceOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [voiceButton addTarget:self action:@selector(voiceExit:) forControlEvents:UIControlEventTouchDragExit];
    
}
//录音开始
-(void)voiceStart:(UIButton *)sender{
    self.voiceImageView.hidden = NO;
    self.recordManager.fileName = @"iceforceVoice";
    [self startAnimating];
    [self.recordManager startRecording];
}
//录音结束
-(void)voiceEnd:(UIButton *)sender{
    self.voiceImageView.hidden = YES;
    
    [self stopAnimating];
    
    [self.recordManager stopRecording];
    
    self.recordManager.fileName =nil;
    
    
    [self dismissView];
}
-(void)voiceOutside:(UIButton *)sender{
    self.voiceImageView.hidden = YES;
    [self stopAnimating];
    
}
-(void)voiceExit:(UIButton *)sender{
    
    self.voiceImageView.hidden = NO;
    [self stopAnimating];
    self.recordManager.fileName =nil;
    self.voiceImageView.image = [UIImage imageNamed:@"sendVoiceCancleImage"];
    [self.recordManager cancelRecording];
    
}
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    [self dismissView];
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark ImageView动画
-(void)startAnimating{
    [self.voiceImageView startAnimating];
}

-(void)stopAnimating{
    [self.voiceImageView stopAnimating];
}

#pragma mark - 语音代理
- (void)levelMeterChanged:(float)levelMeter{
    NSLog(@"%f",levelMeter);
}
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval{
    if (interval < 1.0) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            TTAlert(@"录音时间太短");
            if (self.voiceTimeBlock) {
                self.voiceTimeBlock(YES);
            }
            [self recordingStopped];
        });
        
    }else{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(voicePath:withduration:)]) {
                [self.delegate voicePath:filePath withduration:ceilf(interval)];
            }
        });
        
        
    }
    
}
- (void)recordingTimeout{
    
    [self toolViewRecordBtnTouchUpInside];
    TTAlert(@"录音已到最大时长");
}
- (void)recordingStopped{
    
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *docment = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *file = [docment stringByAppendingPathComponent:[NSString stringWithFormat:@"voice/iceforceVoice.spx"]];
    
    if ([manger fileExistsAtPath:file]) {
        [manger removeItemAtPath:file error:nil];
    }
    
}
- (void)recordingFailed:(NSString *)failureInfoString{
    
}

// 录音完毕
-(void)toolViewRecordBtnTouchUpInside
{
    [self.recordManager stopRecording];
    self.voiceImageView.hidden = YES;
    
    [self stopAnimating];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
