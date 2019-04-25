//
//  ICEFORECVoiceViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/16.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ICEFORECVoiceDelegate <NSObject>

@optional
- (void)voicePath:(NSString *)voicePath withduration:(float)duration;

@end

@interface ICEFORECVoiceViewController : SDRootViewController

@property (nonatomic ,assign) id <ICEFORECVoiceDelegate>delegate;

@property (nonatomic,copy) void (^voiceTimeBlock)(BOOL isVoice);

-(void)dismissView;
@end

NS_ASSUME_NONNULL_END
