//
//  ChatMoreView.h
//  im
//
//  Created by lancely on 16/1/13.
//  Copyright © 2016年 chaselen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatMoreViewDelegate;

//更多View的是单聊还是群聊类型
typedef NS_ENUM(NSInteger, ChatMoreViewType) {
    ChatMoreViewNotGroupType        = 0,
    ChatMoreViewGroupType           = 1,
};

// 按钮类型
typedef NS_ENUM(NSInteger,ChatMoreViewButtonType){
    ChatMoreViewButtonTypePhoto = 0, // 照片
    ChatMoreViewButtonTypeLocation = 1, // 位置
    ChatMoreViewButtonTypeCamera = 2, // 照相机
    ChatMoreViewButtonTypeVideo = 3, // 视频
    ChatMoreViewButtonTypeAudioCall = 4, // 语音通话
    ChatMoreViewButtonTypeVideoCall = 5, // 视频通话
    ChatMoreViewButtonTypeBurnAfterReading = 6 // 阅后即焚
};

@interface ChatMoreView : UIView

@property (nonatomic,weak) id<ChatMoreViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame AndChatMoreViewType:(ChatMoreViewType)type;
@end

@protocol ChatMoreViewDelegate <NSObject>

@optional
-(void)chatMoreView:(ChatMoreView *)moreView didTapButtonWithType:(ChatMoreViewButtonType)type;

@end
