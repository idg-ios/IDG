//
//  CXSignListUserModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/1/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXSignListUserModel : NSObject

/** hignIcon 头像高清照片 String */
@property (nonatomic, copy) NSString * hignIcon;
/** icon 头像 String */
@property (nonatomic, copy) NSString * icon;
/** imAccount im账号 String */
@property (nonatomic, copy) NSString * imAccount;
/** name 名称 String */
@property (nonatomic, copy) NSString * name;
/** userId 用户ID Long */
@property (nonatomic, strong) NSNumber * userId;

@end
