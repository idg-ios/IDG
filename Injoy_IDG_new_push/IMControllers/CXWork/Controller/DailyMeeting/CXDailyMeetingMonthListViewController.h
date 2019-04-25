//
//  CXDailyMeetingMonthListViewController.h
//  InjoyIDG
//
//  Created by cheng on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

typedef NS_ENUM(NSInteger, CXDailyMeetingListType) {
    /** 所有会议 */
    CXDailyMeetingListTypeAll,
    /** 我的会议 */
    CXDailyMeetingListTypeMine
};

@interface CXDailyMeetingMonthListViewController : SDRootViewController

/** 列表类型  */
@property (nonatomic, assign) CXDailyMeetingListType type;

@end
