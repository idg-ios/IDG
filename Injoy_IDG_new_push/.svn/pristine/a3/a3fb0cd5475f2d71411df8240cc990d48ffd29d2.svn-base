//
//  CXGroupMember.h
//  CXIMLib
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXGroupMember : NSObject

/**
 *  加入时间
 */
@property (nonatomic, copy) NSString *joinTime;
/**
 *  加入时间戳
 */
@property (nonatomic, strong) NSNumber *joinTimeMillisecond;
/**
 *  成员
 */
@property (nonatomic, copy) NSString *userId;
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** icon */
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)name icon:(NSString *)icon joinTime:(NSString *)joinTime joinTimeMillisecond:(NSNumber *)joinTimeMillisecond;

+ (instancetype)memberWithUserId:(NSString *)userId name:(NSString *)name icon:(NSString *)icon joinTime:(NSString *)joinTime joinTimeMillisecond:(NSNumber *)joinTimeMillisecond;

@end
