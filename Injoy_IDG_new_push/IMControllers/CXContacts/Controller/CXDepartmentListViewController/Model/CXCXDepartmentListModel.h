//
//  CXCXDepartmentListModel.h
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXCXDepartmentListModel : NSObject

/** 部门ID Long */
@property (nonatomic, strong) NSNumber * deptId;
/** 部门名称 Sring */
@property (nonatomic, copy) NSString * deptName;
/** 部门人数 int */
@property (nonatomic, copy) NSNumber * num;


@end
