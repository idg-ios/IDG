//
//  CXVideoPlayView.m
//  InjoyIDG
//
//  Created by HelloIOS on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXVideoPlayView.h"
#import "UIView+YYAdd.h"

@implementation CXVideoPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    
    return self;
}

-(void)setup{
    self.headerImage = [[UIImageView alloc] init];
    self.headerImage.frame = CGRectMake(0,0,Screen_Width/5,Screen_Height/5);
    [self addSubview:self.headerImage];
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.frame = CGRectMake(0, (Screen_Height/5-20)/2, Screen_Width/5, 20);
    self.tipsLabel.text = @"正在呼叫。。。";
    self.tipsLabel.font = [UIFont systemFontOfSize:10];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.textColor = [UIColor whiteColor];
    [self.headerImage addSubview:self.tipsLabel];
    
//    self.videoPlay = [[RTCEAGLVideoView alloc] init];
//    self.videoPlay.frame = CGRectMake(0, 0, Screen_Width/5, Screen_Height/5);
//    self.videoPlay.backgroundColor = [UIColor clearColor];
//    [self.headerImage addSubview:self.videoPlay];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
