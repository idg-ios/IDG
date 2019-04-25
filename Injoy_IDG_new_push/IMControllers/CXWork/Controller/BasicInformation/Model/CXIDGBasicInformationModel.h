//
//  CXIDGBasicInformationModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGBasicInformationModel : NSObject

/** business 业务介绍 String */
@property (nonatomic, copy) NSString * business;
/** city 城市 String */
@property (nonatomic, copy) NSString * city;
/** comPhaseName 企业阶段 String */
@property (nonatomic, copy) NSString * comPhaseName;
/** induName 行业 String */
@property (nonatomic, copy) NSString * induName;
/** invRoundName 融资轮次 String */
@property (nonatomic, copy) NSString * invRoundName;
/** projDDManagerName 尽调负责人 String */
@property (nonatomic, copy) NSString * projDDManagerName;
/** projGroupName 行业小组 String */
@property (nonatomic, copy) NSString * projGroupName;
/** projLawyerName 项目律师 String */
@property (nonatomic, copy) NSString * projLawyerName;
/** projManagerName 项目负责人 String */
@property (nonatomic, copy) NSString * projManagerName;
/** projSourName 来源渠道 String */
@property (nonatomic, copy) NSString * projSourName;
/** projSourPer 来源人 String */
@property (nonatomic, copy) NSString * projSourPer;
/** projStageName 投资阶段 String */
@property (nonatomic, copy) NSString * projStageName;
/** inDate 立项日期 String */
@property (nonatomic, copy) NSString * inDate;
/** teamName 小组成员 Array */
@property (nonatomic, strong) NSArray<NSString *> * teamName;
@property (nonatomic, strong) NSArray<NSString *> * teamNameArray;
/** contributors contributors String */
@property (nonatomic, copy) NSArray<NSString *> * contributorsArray;

@property (nonatomic, strong) NSArray *contributors;

@end
