//
//  CXRecordView.m
//  SDMarketingManagement
//
//  Created by Rao on 16/4/13.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXRecordView.h"
#import "EMCDDeviceManager.h"

@interface CXRecordView () {
    NSTimer* _timer;
    // 显示动画的ImageView
    UIImageView* _recordAnimationView;
    // 提示文字
    UILabel* _textLabel;
}
@end

@implementation CXRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];

        UIImage* bgImage = [UIImage imageNamed:@"voice_1"];
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 35, bgImage.size.width, bgImage.size.height)];

        _recordAnimationView.image = bgImage;
        [self addSubview:_recordAnimationView];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                        self.bounds.size.height - 30,
                                                        self.bounds.size.width - 10,
                                                        25)];

        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

// 录音按钮按下
- (void)recordButtonTouchDown
{
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString* fileName = [NSString stringWithFormat:@"%d%d", (int)time, x];

    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError* error){
        //
    }];

    // 需要根据声音大小切换recordView动画
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/// 手指在录音按钮内部时离开
- (void)recordButtonTouchUpInside
{
    [_timer invalidate];
}

/// 手指在录音按钮外部时离开
- (void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}

/// 手指移动到录音按钮内部
- (void)recordButtonDragInside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    _textLabel.backgroundColor = [UIColor clearColor];
}

/// 手指移动到录音按钮外部
- (void)recordButtonDragOutside
{
    _textLabel.text = NSLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
    _textLabel.backgroundColor = [UIColor blackColor];
}

- (void)setVoiceImage
{
    _recordAnimationView.image = [UIImage imageNamed:@"voice_1"];
    double voiceSound = 0.f;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if (0 < voiceSound <= 0.07) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_1"]];
    }
    else if (0.07 < voiceSound <= 0.14) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_2"]];
    }
    else if (0.14 < voiceSound <= 0.21) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_3"]];
    }
    else if (0.21 < voiceSound <= 0.28) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_4"]];
    }
    else if (0.28 < voiceSound <= 0.35) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_5"]];
    }
    else if (0.35 < voiceSound <= 0.42) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_6"]];
    }
    else if (0.42 < voiceSound <= 0.49) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_6"]];
    }
    else if (0.49 < voiceSound <= 0.56) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_7"]];
    }
    else if (0.56 < voiceSound <= 0.63) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_7"]];
    }
    else if (0.63 < voiceSound <= 0.70) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"voice_7"]];
    }
}

@end
