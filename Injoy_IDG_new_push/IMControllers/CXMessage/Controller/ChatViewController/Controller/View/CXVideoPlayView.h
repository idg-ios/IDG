//
//  CXVideoPlayView.h
//  InjoyIDG
//
//  Created by HelloIOS on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebRTC/WebRTC.h>

@interface CXVideoPlayView : UIView

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, strong) RTCEAGLVideoView *videoPlay;
-(instancetype)initWithFrame:(CGRect)frame;

@end
