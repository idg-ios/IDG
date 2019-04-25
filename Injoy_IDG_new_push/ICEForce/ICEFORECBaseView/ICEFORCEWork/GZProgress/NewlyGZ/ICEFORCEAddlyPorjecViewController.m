//
//  ICEFORCEAddlyPorjecViewController.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEAddlyPorjecViewController.h"

#import "HttpTool.h"
#import "PlayerManager.h"
#import "MBProgressHUD+CXCategory.h"

#import "ICEFORCESelectListView.h"

#import "RecorderManager.h"


@interface ICEFORCEAddlyPorjecViewController ()<UITextViewDelegate,PlayingDelegate,RecordingDelegate>


@property (nonatomic ,strong) UITextView *textView;

@property (nonatomic ,strong) MyPublicTextField *textField;

@property (nonatomic ,strong) UIButton *voiceButton;


@property (nonatomic ,strong) UIButton *playButton;
@property (nonatomic ,strong) UIButton *delectVoiceButton;
@property (nonatomic ,strong) UIImageView *playImageView;

@property (nonatomic ,strong) NSMutableArray *voiceDataArray;

@property (nonatomic ,strong) NSString *voicePath;
@property (nonatomic ,assign) NSInteger audioTime;

@property (nonatomic ,strong) ICEFORCESelectListView *listView;

@property (nonatomic ,strong) NSArray *dataArray;


#pragma mark - 语音录入部分
@property (nonatomic ,strong) UIImageView *voiceImageView;
@property (nonatomic ,strong) NSMutableArray *voiceImageArray;
@property(nonatomic, strong) RecorderManager *recordManager;


@end

@implementation ICEFORCEAddlyPorjecViewController

#pragma mark - 懒加载

-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc]init];
    }
    return _voiceButton;
}
-(UIButton *)delectVoiceButton{
    if (!_delectVoiceButton) {
        _delectVoiceButton = [[UIButton alloc]init];
        [_delectVoiceButton setImage:[UIImage imageNamed:@"im-members-remove"] forState:(UIControlStateNormal)];
        _delectVoiceButton.hidden = YES;
    }
    return _delectVoiceButton;
}
-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc]init];
        _playButton.hidden = YES;
    }
    return _playButton;
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
-(NSMutableArray *)voiceDataArray{
    if (!_voiceDataArray) {
        _voiceDataArray = [[NSMutableArray alloc]init];
    }
    return _voiceDataArray;
}
-(ICEFORCESelectListView *)listView{
    if (!_listView) {
        _listView = [[ICEFORCESelectListView alloc]init];
        _listView.hidden = YES;
    }
    return _listView;
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
    [rootTopView setNavTitle:@"新建跟踪进展"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
    
    [rootTopView setUpRightBarItemTitle:@"保存" addTarget:self action:@selector(saveData:)];
    
    MyPublicTextField *oldField = [[MyPublicTextField alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(rootTopView.frame), self.view.frame.size.width, 55))];
    oldField.textRectDx = 8;
    oldField.editingRectDx = 8;
    oldField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    oldField.backgroundColor = [UIColor whiteColor];
    oldField.placeholder = @"选择项目名称";
    [self.view addSubview:oldField];
    [oldField addTarget:self action:@selector(editChange:) forControlEvents:(UIControlEventEditingChanged)];
    self.textField = oldField;
    
    self.textView = [[UITextView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(oldField.frame)+20, self.view.frame.size.width, 200))];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入项目跟踪进展内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
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
    
    self.voiceButton.frame = CGRectMake(15,  ScreenHeight-K_Height_Origin_TabBar-50, self.view.frame.size.width-30, 50);
    [self.voiceButton setTitle:@"按住说话" forState:(UIControlStateNormal)];
    self.voiceButton.backgroundColor = RGBA(79, 172, 239, 1);
    [self.voiceButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:self.voiceButton];
//    [self.voiceButton addTarget:self action:@selector(setVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.voiceButton cornerRadius:5 borderColor:nil borderWidth:0];
    [self.voiceButton addTarget:self action:@selector(voiceStart:) forControlEvents:UIControlEventTouchDown];
    [self.voiceButton addTarget:self action:@selector(voiceEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton addTarget:self action:@selector(voiceOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.voiceButton addTarget:self action:@selector(voiceExit:) forControlEvents:UIControlEventTouchDragExit];
  
    
    
    //从项目详情列表中进来
    if (![MyPublicClass stringIsNull:self.pjNameID]) {
        [self.textField setEnabled:NO];
        self.textField.text = self.pjName;
    }
    
}

#pragma mark - 获取项目名称(含请求)
-(void)editChange:(UITextField *)textField{
    
    [self loadPjListServiceForName:textField.text];
    
}
#pragma mark - 语音播放
-(void)playVoice:(UIButton *)sender{
    
    if ((sender.selected =! sender.selected)) {
        
        [self startAnima];
        [self startVoice];
    }else{
        [self stopAnima];
        [self stopVoice];
        
    }
    
}
#pragma mark - 删除语音
-(void)delectVoice:(UIButton *)sender{
    
    self.delectVoiceButton.hidden = YES;
    self.playButton.hidden = YES;
    self.playImageView.hidden = YES;
    [self.voiceDataArray removeAllObjects];
    [self stopAnima];
    [self stopVoice];
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
#pragma mark - 语音录入
-(void)setVoice:(UIButton *)sender{
    
  
}



#pragma mark - 语音代理
- (void)voicePath:(NSString *)voicePath withduration:(float)duration{
    
    [self.voiceDataArray removeAllObjects];
    
    if (voicePath.length) {
        NSData *voiceData = [[NSData alloc] initWithContentsOfFile:voicePath];
        
        SDUploadFileModel *model = [[SDUploadFileModel alloc] init];
        model.fileName = @"iceforceVoice.spx";
        model.fileData = voiceData;
        model.mimeType = @"sound/amr";
        model.duration = [NSString stringWithFormat:@"%f", duration];
        [self.voiceDataArray addObject:model];
    }
    
    if (self.voiceDataArray.count != 0) {
        
        self.voicePath = voicePath;
        self.playImageView.animationRepeatCount = ceilf(duration);
        _audioTime = ceilf(duration);
        _playButton.hidden = NO;
        _playImageView.hidden = NO;
        _delectVoiceButton.hidden = NO;
    }
    
}
#pragma mark - 跟踪进展保存
-(void)saveData:(UIButton *)sender{
    
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    self.listView.hidden = YES;
    
    if ([MyPublicClass stringIsNull:self.textField.text]) {
        CXAlert(@"请输入项目名称");
        return;
    }
    
    if ([MyPublicClass stringIsNull:self.pjNameID]) {
        CXAlert(@"请在列表中选择项目");
        return;
    }
    if ((self.voiceDataArray.count == 0) && ([MyPublicClass stringIsNull:self.textView.text])) {
        
        CXAlert(@"请选择添加语音或内容");
        return;
    }
    
    if ((self.voiceDataArray.count>0) && (![MyPublicClass stringIsNull:self.textView.text])) {
        
        CXAlert(@"语音与内容只能选其一");
        return;
    }
    
    if (![MyPublicClass stringIsNull:self.textView.text]) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:self.pjNameID forKey:@"projId"];
        [dic setValue:self.textView.text forKey:@"note"];
        [dic setValue:@"TEXT" forKey:@"noteType"];
        [dic setValue:VAL_Account forKey:@"createBy"];
        [dic setValue:self.validDate forKey:@"validDate"];
        [self loadUpdateGzService:dic];
    }else{
        [self annexUpLoad];
    }
    
}
#pragma mark - 跟踪进展数据提交
-(void)loadUpdateGzService:(NSMutableDictionary *)dataDic{
    
    [MBProgressHUD showHUDForView:self.view text:@"跟踪进展提交中..."];
    
#pragma mark - 临时
    [HttpTool postWithPath:PUT_PROJ_Note params:dataDic success:^(id JSON) {
        
                NSInteger status = [JSON[@"status"] integerValue];
                if (status == 200) {
        
                      [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
                    if (self.AddlPJRefreshBlock) {
                        self.AddlPJRefreshBlock(@"刷新吧,少年!");
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                     [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
                }
        
            } failure:^(NSError *error) {
        
                [MBProgressHUD hideHUDInMainQueueForView:self.view];
                [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
            }];
    
//    [HttpTool putWithPath:PUT_PROJ_Note params:dataDic success:^(id JSON) {
//
//        NSInteger status = [JSON[@"status"] integerValue];
//        if (status == 200) {
//
//              [MBProgressHUD toastAtCenterForView:self.view text:@"提交成功" duration:1.0];
//            if (self.AddlPJRefreshBlock) {
//                self.AddlPJRefreshBlock(@"刷新吧,少年!");
//            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }else{
//             [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
//        }
//
//    } failure:^(NSError *error) {
//
//        [MBProgressHUD hideHUDInMainQueueForView:self.view];
//        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
//    }];
    
}
#pragma mark - 语音上传
- (void)annexUpLoad{
    
    NSDictionary *files = @{
                            @"files": @[self.voiceDataArray.firstObject]
                            };
    [MBProgressHUD showHUDForView:self.view text:@"语音上传中..."];
    [HttpTool multipartPostWithPath:@"/annex/fileUpload" params:nil files:files success:^(id JSON) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSDictionary *dataDic = [[JSON objectForKey:@"data"] objectAtIndex:0];
            NSString *voiceURL = [dataDic objectForKey:@"path"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:self.pjNameID forKey:@"projId"];
            [dic setValue:voiceURL forKey:@"note"];
            [dic setValue:@"AUDIO" forKey:@"noteType"];
            [dic setValue:@(self.audioTime) forKey:@"audioTime"];
            [dic setValue:VAL_Account forKey:@"createBy"];
            [self loadUpdateGzService:dic];
            
            
        } else {
            [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDInMainQueueForView:self.view];
        [MBProgressHUD toastAtCenterForView:self.view text:@"提交失败,请稍后重试" duration:1.0];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    self.listView.hidden = YES;
    
}


#pragma mark - 语音播放动画
-(void)startAnima{
    [self.playImageView startAnimating];
}

-(void)stopAnima{
    [self.playImageView stopAnimating];
}

#pragma mark - 获取项目名称的列表请求
-(void)loadPjListServiceForName:(NSString *)pjName{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:pjName forKey:@"projName"];
    [dic setValue:VAL_Account forKey:@"username"];
    
    [HttpTool postWithPath:POST_PROJ_Query_SelectList params:dic success:^(id JSON) {
        
        NSInteger status = [JSON[@"status"] integerValue];
        if (status == 200) {
            
            NSArray *dataArray = [[JSON objectForKey:@"data"] objectForKey:@"data"];
            [self loadListViewData:dataArray];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 项目列表展示
-(void)loadListViewData:(NSArray *)dataArray{
    self.listView.hidden = NO;
    CXWeakSelf(self);
    CGFloat H;
    if (dataArray.count < 5) {
        H = dataArray.count *50;
    }else{
        H = 300;
    }
    self.listView.frame = CGRectMake(15, CGRectGetMaxY(self.textField.frame)+4, self.view.frame.size.width-30, H);
    self.listView.dataArray = dataArray;
    self.listView.dataKey = @"projName";
    [self.view addSubview:self.listView];
    [self.listView reloadData];
    _listView.selectListData = ^(NSDictionary * _Nonnull dataSource) {
        weakself.textField.text = [dataSource objectForKey:@"projName"];
        weakself.pjNameID = [dataSource objectForKey:@"projId"];
    };
    
    
}


#pragma mark - 以下是语音录入部分

//录音开始
-(void)voiceStart:(UIButton *)sender{
    [self.textField resignFirstResponder];
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
            [self stopAnima];
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
