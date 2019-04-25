//
//  SDRecordViewController.m
//  SDMarketingManagement
//
//  Created by shenhuihui on 15/5/19.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRecordViewController.h"
#import "LCVoice.h"
#import "RecorderManager.h"
#import "SDRecordStateView.h"

#define kWriteSoundFilePath  [NSString stringWithFormat:@"%@/Documents/Voice.spx",NSHomeDirectory()]
@interface SDRecordViewController ()<RecordingDelegate>

@property(nonatomic,strong)SDRootTopView *rootTopView;
@property(nonatomic,retain) LCVoice * voice;
@property(nonatomic, strong) RecorderManager *recordManager;
@property (nonatomic, weak) SDRecordStateView *recordStateView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTotalTime;

@end

@implementation SDRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:43/255.f green:45/255.f blue:43/255.f alpha:0.7f];
    _recordManager = [RecorderManager sharedManager];
    _recordManager.delegate = self;
    _recordManager.filename = kWriteSoundFilePath;
    
//    [self setUpNavigationBar];
    [self setUpBtn];
    
    //创建录音状态视图
    [self setUpRecordStateView];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.recordTotalTime = 0;
}

#pragma mark -- 屏幕点击事件
-(void)tapGesture
{
    [self.view removeFromSuperview];
}

-(void)setUpNavigationBar{
    
    _rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"录音"];
    
    // 返回按钮
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* backImage = [UIImage imageNamed:@"back.png"];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UseAutoLayout(backBtn);
    [self.rootTopView addSubview:backBtn];
    
    NSDictionary* leftVal = @{ @"wd" : [NSNumber numberWithFloat:backImage.size.width],
                               @"ht" : [NSNumber numberWithFloat:backImage.size.height]
                               };
    // backBtn宽度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[backBtn(wd)]" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(backBtn)]];
    // backBtn高度
    [self.rootTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn(ht)]-5-|" options:0 metrics:leftVal views:NSDictionaryOfVariableBindings(backBtn)]];
}

-(void)setUpBtn{
    
    self.voice = [[LCVoice alloc] init];
    
    //按住说话
    UILabel *remindLabel = [[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-120.f)/2.f, Screen_Height -110.f - 44.f, 120, 44.f)];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = [UIFont systemFontOfSize:15.f];
    remindLabel.text = @"按住说话";
    [self.view addSubview:remindLabel];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((Screen_Width-66.f)/2.f, Screen_Height -110.f, 66.f, 66.f);
    [button setBackgroundImage:[UIImage imageNamed:@"record_button"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    
    [button addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(hideCancelImage) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(dragExit) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(dragEnter) forControlEvents:UIControlEventTouchDragEnter];
}

#pragma mark 创建录音状态视图
-(void)setUpRecordStateView
{
    SDRecordStateView *recordStateView = [[SDRecordStateView alloc]initWithFrame:CGRectMake(0, 0, 125, 125)];
    recordStateView.center = CGPointMake(Screen_Width/2.f, Screen_Height/2.f);
    [self.view addSubview:recordStateView];
    self.recordStateView = recordStateView;
}

- (void)dragExit {
    self.recordStateView.recordingStateImageView.hidden = YES;
    [self.recordStateView stopAnimating];
    self.recordStateView.recordImageView.hidden = NO;
    self.recordStateView.recordImageView.image = [UIImage imageNamed:@"manager_recordCancel"];
}

- (void)dragEnter {
    self.recordStateView.hidden = NO;
    self.recordStateView.recordingStateImageView.hidden = NO;
    self.recordStateView.recordImageView.image = [UIImage imageNamed:@"manger_record"];
    [self.recordStateView startAnimating];
}

-(void)recordStart
{
    //开始执行动画
    self.recordStateView.hidden = NO;
    self.recordStateView.recordingStateImageView.hidden = NO;
    self.recordStateView.recordImageView.hidden = NO;
    self.recordStateView.recordImageView.image = [UIImage imageNamed:@"manger_record"];
    [self.recordStateView startAnimating];
    
    [_recordManager startRecording];
    
    //启动一个定时器，录音时间超过40秒，自动发送
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countRecordTime:) userInfo:nil repeats:YES];
}

-(void)recordEnd
{
    //结束动画
    self.recordStateView.hidden = YES;
    self.recordStateView.recordingStateImageView.hidden = YES;
    [self.recordStateView stopAnimating];
    
    //销毁定时器
    if (_timer) {
        [_timer invalidate];
    }
    
    [_recordManager stopRecording];
    //返回上一个界面
    [self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -- 录音超过40s，直接发送
-(void)countRecordTime:(NSTimer *)timer
{
    self.recordTotalTime ++;
    if (self.recordTotalTime >= 40.f) {
        self.recordTotalTime = 0;
        //销毁定时器
        [timer invalidate];
        [self recordEnd];
        
    }
}

#pragma mark  实现录音第三个库的代理方法
-(void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    //少于一秒不回调录音
    if (interval < 1.f) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(setUpVideo:withduration:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate setUpVideo:filePath withduration:interval];
        });
    }
    
    [self.view removeFromSuperview];
}

-(void)customLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) recordCancel
{
    //取消动画
    self.recordStateView.hidden = NO;
    self.recordStateView.recordingStateImageView.hidden = YES;
    
    
    [_recordManager cancelRecording];
    [self.view removeFromSuperview];
    
}

-(void)hideCancelImage
{
    self.recordStateView.recordImageView.hidden = YES;
}

@end
