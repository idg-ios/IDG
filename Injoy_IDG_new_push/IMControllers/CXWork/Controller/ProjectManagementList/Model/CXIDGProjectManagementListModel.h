//
//  CXIDGProjectManagementListModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGProjectManagementListModel : NSObject

/** projName 名称 Sring */
@property (nonatomic, copy) NSString * projName;
/** projId ID Long */
@property (nonatomic, strong) NSNumber * projId;
/** projManagerName 负责人 String */
@property (nonatomic, copy) NSString * projManagerName;
/** induName 行业 String */
@property (nonatomic, copy) NSString * induName;
/** business 简介 String */
@property (nonatomic, copy) NSString * business;
/** projGroup 图标对应的类型 long */
@property (nonatomic, strong) NSNumber * projGroup;
/** projStage 阶段 String 已经删除了 */
@property (nonatomic, copy) NSString * projStage;

@end
