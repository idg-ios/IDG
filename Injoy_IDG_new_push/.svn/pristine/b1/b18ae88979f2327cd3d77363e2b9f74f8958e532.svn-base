//
//  SDSingleMeetingViewController.h
//  SDIMApp
//
//  Created by wtz on 2018/8/24.
//  Copyright © 2018年 Rao. All rights reserved.
//

typedef NS_ENUM(NSInteger,SDIMInitiateOrAcceptCallType){
    /** 发起方 */
    SDIMCallInitiateType = 0,
    /** 接受方 */
    SDIMCallAcceptType = 1
};

@interface SDSingleMeetingViewController : UIViewController

//对方的环信ID
@property (nonatomic,copy) NSString *chatter;
//对方的昵称
@property (nonatomic,copy) NSString *chatterDisplayName;
//语音通话还是视频通话
@property (nonatomic) CXIMMediaCallType audioOrVideoType;
@property (nonatomic, assign) CGSize displaySize;

@property (nonatomic, strong) NSNumber * receiveCallTime;

-(instancetype)initWithInitiateOrAcceptCallType:(SDIMInitiateOrAcceptCallType)type;

@end
