//
//  CXIDGCurrentAnnualMeetingModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/1/8.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGCurrentAnnualMeetingModel : NSObject

/** address 年会地址 String */
@property (nonatomic, copy) NSString * address;
/** eid 年会ID Long */
@property (nonatomic, strong) NSNumber * eid;
/** meetTime 年会时间 String */
@property (nonatomic, copy) NSString * meetTime;
/** remark 日常安排 String */
@property (nonatomic, copy) NSString * remark;
/** title 年会主题 String */
@property (nonatomic, copy) NSString * title;
/** year 年份 String */
@property (nonatomic, copy) NSString * year;
/** picUrl 相册链接 String */
@property (nonatomic, copy) NSString * picUrl;
/** isVote 是否投过票 int 1投过票 0没投票 */
@property (nonatomic, strong) NSNumber * isVote;
/** startVote 是否开启投票 int 1开启 0未开启 */
@property (nonatomic, strong) NSNumber * startVote;


@end
