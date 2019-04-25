//
//  CXDailyMeetingConst.h
//  InjoyIDG
//
//  Created by cheng on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#ifndef CXDailyMeetingConst_h
#define CXDailyMeetingConst_h

/** 会议类型 */
typedef NS_ENUM(NSInteger, CXDailyMeetingType) {
    /** 未知 */
    CXDailyMeetingTypeUnkown = 0,
    /** 普通 */
    CXDailyMeetingTypeNormal = 1,
    /** 周会 */
    CXDailyMeetingTypeWeek = 2,
    /** 月会 */
    CXDailyMeetingTypeMonth = 3
};

/** 详情页显示会议类型的背景颜色 */
#define CXDailyMeetingTypeBackgroundColor kColorWithRGB(232, 74, 73)

/** 未开始会议的蓝颜色 */
#define CXDailyMeetingColorNotStarted kColorWithRGB(174, 17, 41)
/** 进行中会议的黄颜色 */
#define CXDailyMeetingColorInProgress kColorWithRGB(255, 163, 70)
/** 已结束会议的红颜色 */
#define CXDailyMeetingColorComplete kColorWithRGB(132, 142, 153)

#endif /* CXDailyMeetingConst_h */
