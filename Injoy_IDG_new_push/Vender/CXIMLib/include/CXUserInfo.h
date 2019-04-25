//
//  CXUserInfo.h
//  CXIMLib
//
//  Created by lancely on 1/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户信息
 */
@interface CXUserInfo : NSObject

/**
 *  账号
 */
@property (nonatomic,copy) NSString *account;

/**
 *  创建时间
 */
@property (nonatomic,strong) NSNumber *createTime;

/**
 *  uin
 */
@property (nonatomic,copy) NSString *uin;

@end
