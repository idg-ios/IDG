//
//  CXGroupInfo.h
//  CXIMLib
//
//  Created by lancely on 1/23/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXGroupMember.h"

/**
 *  群组类型
 */
typedef NS_ENUM(NSInteger, CXGroupType) {
    /**
     *  普通群组
     */
    CXGroupTypeNormal = 1,
    /**
     *  语音会议群组
     */
    CXGroupTypeVoiceConference = 2
};

/** 群组信息 */
@interface CXGroupInfo : NSObject
/** 公司ID */
@property (nonatomic, copy) NSString *companyId;
/** 创建时间（string） */
@property (nonatomic, copy) NSString *createTime;
/** 创建时间（timestamp） */
@property (nonatomic, strong) NSNumber *createTimeMillisecond;
/** 更新时间（string）*/
@property (nonatomic, copy) NSString *updateTime;
/** 更新时间（timestamp）*/
@property (nonatomic, strong) NSNumber *updateTimeMillisecond;
/** 群组ID */
@property (nonatomic, copy) NSString *groupId;
/** 群组名称 */
@property (nonatomic, copy) NSString *groupName;
/** 群主 */
@property (nonatomic, copy) NSString *owner;
/** 群主详细信息 */
@property (nonatomic, strong) CXGroupMember *ownerDetail;
/** 群组类型 */
@property (nonatomic, assign) CXGroupType groupType;
/** 群成员 */
@property (nonatomic, copy) NSArray<CXGroupMember *> *members;

@end
