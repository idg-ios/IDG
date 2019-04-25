//
//  ICEFORECIntroduceDetailViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/15.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORECIntroduceDetailViewController.h"

#import "CXTextView.h"
#import "HttpTool.h"
#import "PlayerManager.h"
#import "MBProgressHUD+CXCategory.h"

#import "RecorderManager.h"

@interface ICEFORECIntroduceDetailViewController ()<UITextViewDelegate,CXTextViewDelegate,PlayingDelegate,RecordingDelegate>

@property (nonatomic ,strong) UITextView *textView;

@property (nonatomic ,strong) NSMutableArray *selectVoiceArr;

@property (nonatomic ,strong) UIButton *playButton;
@property (nonatomic ,strong) UIButton *delectVoiceButton;
@property (nonatomic ,strong) UIImageView *playImageView;

@property (nonatomic ,strong) NSString *voicePath;
@property (nonatomic ,assign) float voiceTiem;


@property (nonatomic ,strong) NSArray *dataArray;

#pragma mark - 语音录入部分
@property (nonatomic ,strong) UIImageView *voiceImageView;
@property (nonatomic ,strong) NSMutableArray *voiceImageArray;
@property(nonatomic, strong) RecorderManager *recordManager;

@end

@implementation ICEFORECIntroduceDetailViewController


-(NSMutableArray *)selectVoiceArr{
    if (!_selectVoiceArr) {
        _selectVoiceArr = [[NSMutableArray alloc]init];
    }
    return _selectVoiceArr;
}


-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc]init];
        _playButton.backgroundColor = [UIColor whiteColor];
        _playButton.hidden = YES;
    }
    return _playButton;
}
-(UIButton *)delectVoiceButton{
    if (!_delectVoiceButton) {
        _delectVoiceButton = [[UIButton alloc]init];
        [_delectVoiceButton setImage:[UIImage imageNamed:@"im-members-remove"] forState:(UIControlStateNormal)];
        _delectVoiceButton.hidden = YES;
    }
    return _delectVoiceButton;
}
-(UIImageView *)playImageView{
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc]init];
        _playImageView.image = [UIImage imageNamed:@"chat_receiver_audio_voice_playing_003"];
        _playImageView.contentMode = UIViewContentModeCenter;
        _playImageView.hidden = YES;
    }
    return _playImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSubView];
    [self loadVoiceInput];
}

#pragma mark - 语音录入部分

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

-(void)loadVoiceInput{
    
    self.recordManager = [RecorderManager sharedManager];
    self.recordManager.delegate = self;
    
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
    
    
    
}
#pragma mark- 语音播放部分
-(void)loadSubView{
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"介绍项目"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveData:)];
    
    self.textView = [[UITextView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, 300))];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:13];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
    UIButton *videoButton = [[UIButton alloc]initWithFrame:(CGRectMake(15,  ScreenHeight-K_Height_Origin_TabBar-50, self.view.frame.size.width-30, 50))];
    [videoButton setTitle:@"按住说话" forState:(UIControlStateNormal)];
    videoButton.backgroundColor = RGBA(79, 172, 239, 1);
    [videoButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [videoButton addTarget:self action:@selector(holdToTalk:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:videoButton];
    
    [videoButton addTarget:self action:@selector(voiceStart:) forControlEvents:UIControlEventTouchDown];
    [videoButton addTarget:self action:@selector(voiceEnd:) forControlEvents:UIControlEventTouchUpInside];
    [videoButton addTarget:self action:@selector(voiceOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [videoButton addTarget:self action:@selector(voiceExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [MyPublicClass layerMasksToBoundsForAnyControls:videoButton cornerRadius:5 borderColor:nil borderWidth:0];
    
    self.playButton.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame)+15, 100, 40);
    [self.playButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.playButton];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.playButton cornerRadius:5 borderColor:nil borderWidth:0];
    [self.playButton addTarget:self action:@selector(playVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.delectVoiceButton.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame)-10, CGRectGetMinY(self.playButton.frame)-8, 16, 16);
    [self.view addSubview:self.delectVoiceButton];
    [self.delectVoiceButton addTarget:self action:@selector(delectVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<=3; i++) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"chat_receiver_audio_voice_playing_00%d",i]];
        [imageArray addObject:imageName];
    }
    
    self.playImageView.frame = CGRectMake(15, CGRectGetMaxY(self.textView.frame)+15, 20, 40);
    self.playImageView.animationImages = imageArray;
    self.playImageView.animationDuration = 1;
    [self.view addSubview:self.playImageView];
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view endEditing:NO];
    CXTextView *text = [[CXTextView alloc]initWithKeyboardType:(UIKeyboardTypeDefault)];
    text.delegate = self;
    text.textString = textView.text;
    [KEY_WINDOW addSubview:text];
}

-(void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text{
    self.textView.text = text;
}

#pragma mark - 语音界面弹出
-(void)holdToTalk:(UIButton *)sender{
    
  
   
    
}

#pragma mark - 语音代理
- (void)voicePath:(NSString *)voicePath withduration:(float)duration{
    
    
    [self.selectVoiceArr removeAllObjects];
    
    if (voicePath.length) {
        NSData *voiceData = [[NSData alloc] initWithContentsOfFile:voicePath];
        
        SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
        model.fileName = @"iceforceVoice.spx";
        model.fileData = voiceData;
        model.mimeType = @"sound/amr";
        model.duration = [NSString stringWithFormat:@"%f", duration];
        [self.selectVoiceArr addObject:model];
    }
    
    
    if (self.selectVoiceArr.count != 0) {
        self.voicePath = voicePath;
        self.playImageView.animationRepeatCount = ceilf(duration);
        self.voiceTiem = ceilf(duration);
        _playButton.hidden = NO;
        _playImageView.hidden = NO;
        _delectVoiceButton.hidden = NO;
    }
    
}

#pragma mark - 语音上传
- (void)annexUpLoad{
    
    NSDictionary *files = @{
                            @"files": @[self.selectVoiceArr.firstObject]
                            };
    [MBProgressHUD showHUDForView:self.view text:@"请稍候..."];
    NSMutableDictionary *voiceDic = [[NSMutableDictionary alloc]init];
    [HttpTool multipartPostWithPath:@"/annex/fileUpload" params:nil files:files success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSDictionary *dataDic = [[JSON objectForKey:@"data"] objectAtIndex:0];
            [voiceDic setValue:self.textView.text forKey:@"zhDesc"];
            [voiceDic setValue:[dataDic objectForKey:@"createTime"] forKey:@"createTime"];
            [voiceDic setValue:[dataDic objectForKey:@"fileSize"] forKey:@"fileSize"];
            [voiceDic setValue:[dataDic objectForKey:@"name"] forKey:@"name"];
            [voiceDic setValue:[dataDic objectForKey:@"path"] forKey:@"path"];
            [voiceDic setValue:[dataDic objectForKey:@"showType"] forKey:@"showType"];
            [voiceDic setValue:[dataDic objectForKey:@"srcName"] forKey:@"srcName"];
            [voiceDic setValue:[dataDic objectForKey:@"type"] forKey:@"type"];
            [voiceDic setValue:[dataDic objectForKey:@"userId"] forKey:@"userId"];
            ICEFORECVoiceModel *model = [ICEFORECVoiceModel modelWithDict:voiceDic];
            [self loadBolckModel:model];
            
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:2.0];
    }];
}
#pragma mark - 保存按钮点击
-(void)saveData:(UIButton *)sender{
    NSString *textViewString = self.textView.text;
    
    if ([MyPublicClass stringIsNull:textViewString] && self.selectVoiceArr.count == 0) {
        ICEFORECVoiceModel *model = nil;
        [self loadBolckModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (![MyPublicClass stringIsNull:textViewString] && self.selectVoiceArr.count == 0) {
            NSDictionary *textViewDic = @{@"zhDesc":textViewString};
            ICEFORECVoiceModel *model = [ICEFORECVoiceModel modelWithDict:textViewDic];
            [self loadBolckModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.selectVoiceArr.count != 0) {
            [self annexUpLoad];
        }
        
        
    }
    
}
-(void)loadBolckModel:(ICEFORECVoiceModel *)model{
    if (self.introduceDetailBlock) {
        model.voiceTime = self.voiceTiem;
        self.introduceDetailBlock(model);
    }
}

#pragma mark - 语音播放
-(void)playVoice:(UIButton *)sender{
    
    if ((sender.selected =! sender.selected)) {
        
        [self startAnimating];
        [self startVoice];
    }else{
        [self stopAnimating];
        [self stopVoice];
        
    }
    
}

#pragma mark - 删除语音
-(void)delectVoice:(UIButton *)sender{
    
    self.delectVoiceButton.hidden = YES;
    self.playButton.hidden = YES;
    self.playImageView.hidden = YES;
    [self.selectVoiceArr removeAllObjects];
    [self startAnimating];
    [self stopAnimating];
}

#pragma mark - 播放本地语音文件
- (void)startVoice{
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    if ([manger fileExistsAtPath:self.voicePath]) {
        
        PlayerManager *playManager = [PlayerManager sharedManager];
        [playManager playAudioWithFileName:self.voicePath delegate:self];
    }else{
        CXAlert(@"播放失败,文件不存在");
    }
}

// 播放录音文件
- (void)playNetWorkAudioByPath:(NSString *)audioPath {
    PlayerManager *playManager = [PlayerManager sharedManager];
    [playManager playAudioWithFileName:audioPath delegate:self];
    
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
    [self stopAnimating];
    
}


#pragma mark - ImageView动画
-(void)startAnimating{
    [self.playImageView startAnimating];
}

-(void)stopAnimating{
    [self.playImageView stopAnimating];
}

#pragma mark - 以下是语音录入部分

//录音开始
-(void)voiceStart:(UIButton *)sender{
    
    [self.textView resignFirstResponder];
    
    self.voiceImageView.hidden = NO;
    self.recordManager.fileName = @"iceforceVoice";
    [self startVoiceAnimating];
    [self.recordManager startRecording];
}
//录音结束
-(void)voiceEnd:(UIButton *)sender{
    self.voiceImageView.hidden = YES;
    
    [self stopVoiceAnimating];
    
    [self.recordManager stopRecording];
    
    self.recordManager.fileName =nil;
    
    
}
-(void)voiceOutside:(UIButton *)sender{
    self.voiceImageView.hidden = YES;
    [self stopVoiceAnimating];
    
}
-(void)voiceExit:(UIButton *)sender{
    
    self.voiceImageView.hidden = NO;
    [self stopVoiceAnimating];
    self.recordManager.fileName =nil;
    self.voiceImageView.image = [UIImage imageNamed:@"sendVoiceCancleImage"];
    [self.recordManager cancelRecording];
    
}

#pragma mark - ImageView语音录入动画
-(void)startVoiceAnimating{
    [self.voiceImageView startAnimating];
}

-(void)stopVoiceAnimating{
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
            [self stopAnimating];
            [self stopVoiceAnimating];
            self.playButton.hidden = YES;
            self.playImageView.hidden = YES;
            self.delectVoiceButton.hidden = YES;
            [self recordingStopped];
        });
        
    }else{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self voicePath:filePath withduration:interval];
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
    
    [self stopVoiceAnimating];
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
