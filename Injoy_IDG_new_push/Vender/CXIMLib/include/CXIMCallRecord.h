//
//  CXIMCallRecord.h
//  CXIMLib
//
//  Created by lancely on 4/8/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  通话类型
 */
typedef NS_ENUM(NSInteger, CXIMCallRecordType) {
    /**
     *  接入
     */
    CXIMCallRecordTypeIn = 1,
    /**
     *  拨出
     */
    CXIMCallRecordTypeOut = 2
};

/**
 *  通话状态
 */
typedef NS_ENUM(NSInteger, CXIMCallRecordStatus) {
    /**
     *  未接通
     */
    CXIMCallRecordStatusFailed = 0,
    /**
     *  接通
     */
    CXIMCallRecordStatusSuccess = 1
};

@interface CXIMCallRecord : NSObject

/**
 *  记录id
 */
@property (nonatomic, strong, readonly) NSNumber *ID;

/**
 *  会话人
 */
@property (nonatomic, copy, readonly) NSString *chatter;

/**
 *  通话类型
 */
@property (nonatomic, assign, readonly) CXIMCallRecordType type;

/**
 *  通话状态
 */
@property (nonatomic, assign, readonly) CXIMCallRecordStatus status;

/**
 *  是否响应
 */
@property (nonatomic, assign, getter=isResponded) BOOL responded;

/**
 *  通话时间
 */
@property (nonatomic, strong, readonly) NSNumber *time;

- (instancetype)initWithChatter:(NSString *)chatter type:(CXIMCallRecordType)type status:(CXIMCallRecordStatus)status time:(NSNumber *)time;

+ (instancetype)recordWithChatter:(NSString *)chatter type:(CXIMCallRecordType)type status:(CXIMCallRecordStatus)status time:(NSNumber *)time;

@end
