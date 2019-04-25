
//
//  CXYMProjectModel.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXYMProjectModel : NSObject

@property (nonatomic, copy, readonly) NSString *projectID;///<项目id
@property (nonatomic, assign, readonly) NSInteger projectType;///<项目类型
@property (nonatomic, copy, readonly) NSString *projectName;///<项目名称
@property (nonatomic, copy, readonly) NSString *projectTypeName;///<项目类别名称
@property (nonatomic, copy, readonly) NSString *projectDestribute;///<项目描述


+ (NSArray <CXYMProjectModel *> *)projectArrayWithArray:(NSArray *)array;

@end

@interface CXYMEventModel : NSObject

@property (nonatomic, copy, readonly) NSString *eventID;///<其他项目id
@property (nonatomic, assign, readonly) NSInteger eventType;///<其他项目类型
@property (nonatomic, copy, readonly) NSString *eventName;///<其他项目名称
@property (nonatomic, copy, readonly) NSString *eventTypeName;///<其他项目类别名称
@property (nonatomic, copy, readonly) NSString *eventDestribute;///<其他项目描述


+ (NSArray <CXYMEventModel *> *)eventArrayWithArray:(NSArray *)array;

@end

//不良资产
@interface CXYMBadAssetsModel : NSObject

@property (nonatomic,strong) NSNumber*projId;///<其他项目id
@property (nonatomic, copy) NSString *projInDate;///<日期
@property (nonatomic, copy) NSString *dealLeadName;///<项目负责人
@property (nonatomic, copy) NSString *dealLegalName;///<律师
@property (nonatomic, copy) NSString *ename;///<项目名称
@property (nonatomic, copy) NSString *grade;///<评级
@property (nonatomic, copy) NSString *indusName;///<行业


+ (NSArray <CXYMBadAssetsModel *> *)badAssetsArrayWithArray:(NSArray *)array;

@end

