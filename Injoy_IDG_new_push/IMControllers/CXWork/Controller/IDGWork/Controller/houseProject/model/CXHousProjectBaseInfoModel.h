//
//  CXHousProjectBaseInfoModel.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXHousProjectBaseInfoModel : NSObject
/***立项日期***/
@property (nonatomic, copy) NSString *inDate;
/*** 行业小组 ***/
@property (nonatomic, copy) NSString *indusGroupName;
/*** 投资类型 ***/
@property (nonatomic, copy) NSString *investType;
/*** ID ***/
@property (nonatomic, copy) NSString *projId;
/*** 项目负责人 ***/
@property (nonatomic, copy) NSString *projManagerNames;
/*** 项目名称 ***/
@property (nonatomic, copy) NSString *projName;
/*** 项目名称（英文）***/
@property (nonatomic, copy) NSString *projNameEn;
/*** 项目进展 ***/
@property (nonatomic, copy) NSString *projProgress;
/*** 项目来源 ***/
@property (nonatomic, copy) NSString *projSour;
/*** 来源人 ***/
@property (nonatomic, copy) NSString *projSourPer;
/*** 项目阶段 ***/
@property (nonatomic, copy) NSString *projSts;
/*** 小组成员 ***/
@property (nonatomic, copy) NSArray* projTeam;
/*** 物业类型 ***/
@property (nonatomic, copy) NSString *propertyType;
/*** 业务介绍 ***/
@property (nonatomic, copy) NSString *zhDesc;


@end
