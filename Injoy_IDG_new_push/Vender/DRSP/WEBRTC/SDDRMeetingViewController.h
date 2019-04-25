//
//  SDDRMeetingViewController.h
//  SDIMApp
//
//  Created by wtz on 2018/8/25.
//  Copyright © 2018年 Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXGroupMember.h"

typedef NS_ENUM(NSInteger,SDIMSenderOrReceiveType){
    //发起方
    SDIMSenderOrReceiveTypeSender = 0,
    //接受方
    SDIMSenderOrReceiveTypeReceive = 1
};

@interface SDDRMeetingViewController : SDRootViewController

/** 邀请通话的成员 */
@property (nonatomic, strong) NSMutableArray<CXGroupMember *> *memberArray;

/** 发送者接受者类型 */
@property (nonatomic, assign) SDIMSenderOrReceiveType senderOrReceiveType;

/** 房间id */
@property (nonatomic, strong) NSString *roomId;

//语音通话还是视频通话
@property (nonatomic) CXIMMediaCallType audioOrVideoType;
/** 通话邀请人 */
@property (nonatomic, strong) CXGroupMember *owner;

/** 视频屏幕比例 */
@property (nonatomic, assign) CGSize displaySize;
/** 邀请时间 */
@property (nonatomic, strong) NSNumber * receiveCallTime;
/** 是否直接加入 */
@property (nonatomic, assign) BOOL isJoin;

/** 是否视频通话，否则语音通话 */
@property (nonatomic, assign) BOOL isVideo;
@end
