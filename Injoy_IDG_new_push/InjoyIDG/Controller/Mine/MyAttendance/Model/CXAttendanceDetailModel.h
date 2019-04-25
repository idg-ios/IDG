//
//  CXAttendanceDetailModel.h
//  InjoyYJ1
//
//  Created by cheng on 2017/8/29.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXAttendanceDetailModel : NSObject

/** 主键 */
@property (nonatomic, assign) NSInteger eid;
/** 用户id */
@property (nonatomic, assign) NSInteger userId;
/** 签到时间 */
@property (nonatomic, copy) NSString *upTime;
/** 签到经纬度 */
@property (nonatomic, copy) NSString *upLocat;
/** 签到位置 */
@property (nonatomic, copy) NSString *upLocation;
/** 签退时间 */
@property (nonatomic, copy) NSString *outTime;
/** 签退经纬度 */
@property (nonatomic, copy) NSString *outLocat;
/** 签退位置 */
@property (nonatomic, copy) NSString *outLocation;

@end
