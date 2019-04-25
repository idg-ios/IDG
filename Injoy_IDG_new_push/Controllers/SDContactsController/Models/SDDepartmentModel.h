//
//  SDDepartmentModel.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseModel.h"

@interface SDDepartmentModel : SDBaseModel
/// 部门ID
@property(strong, nonatomic) NSNumber *departmentId;
@property(strong, nonatomic) NSNumber *dpId;// 超享+
/// 部门名称
@property(strong, nonatomic) NSString *departmentName;
@property(strong, nonatomic) NSString *dpName;// 超享+
@property(strong, nonatomic) NSString *dpCode;


/// 公司ID
@property(nonatomic, strong) NSNumber *companyId;
/// 上级ID
@property(nonatomic, strong) NSNumber *dpparentid;
/// 部门分类
@property(nonatomic, strong) NSNumber *dpcategory;
@end
