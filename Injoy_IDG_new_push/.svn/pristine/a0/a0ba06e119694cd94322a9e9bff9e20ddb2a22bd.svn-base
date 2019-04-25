//
//  CXDailyMeetingDetailModel.h
//  InjoyIDG
//
//  Created by cheng on 2017/12/21.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXDailyMeetingConst.h"

@class CXDailyMeetingDetailInfo;
@interface CXDailyMeetingDetailModel : NSObject

/** 附件 */
@property (nonatomic, copy) NSArray<NSDictionary *> *annexList;
/** 会议参与人 */
@property (nonatomic, copy) NSArray<NSDictionary *> *ccList;
/** 参与组名 */
@property (nonatomic, copy) NSArray<NSString *> *groupNames;
/** 会议详细信息 */
@property (nonatomic, strong) CXDailyMeetingDetailInfo *meet;

@end

@interface CXDailyMeetingDetailInfo : NSObject

/** 会议id */
@property (nonatomic, assign) NSInteger eid;
/** 创建人id */
@property (nonatomic, assign) NSInteger createId;
/** 开始时间 */
@property (nonatomic, copy) NSString *startTime;
/** 结束时间 */
@property (nonatomic, copy) NSString *endTime;
/** 会议地点 */
@property (nonatomic, copy) NSString *meetPlace;
/** 会议标题 */
@property (nonatomic, copy) NSString *title;
/** 会议种类 */
@property (nonatomic, assign) CXDailyMeetingType type;
/** 会议内容 */
@property (nonatomic, copy) NSString *remark;

@end
