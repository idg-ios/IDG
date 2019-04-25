//
//  CXDDXVoiceMeetingDetailModel.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXDDXVoiceMeetingDetailUserModel.h"
#import "CXDDXVoiceMeetingDetailVedioMeetModel.h"

@interface CXDDXVoiceMeetingDetailModel : NSObject
//会议参与者
@property (nonatomic, strong) NSArray<CXDDXVoiceMeetingDetailUserModel *> * ccList;

@property (nonatomic, strong) CXDDXVoiceMeetingDetailVedioMeetModel * vedioMeetModel;

@end
