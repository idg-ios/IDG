//
//  SDDepartmentRealModel.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseModel.h"

@interface SDDepartmentRealModel : SDBaseModel
/// 部门ID
@property (nonatomic, strong) NSNumber* deptId;
@property (nonatomic, strong) NSNumber* dpId;//超享+
/// 用户ID
@property (nonatomic, strong) NSNumber* userId;

@end
