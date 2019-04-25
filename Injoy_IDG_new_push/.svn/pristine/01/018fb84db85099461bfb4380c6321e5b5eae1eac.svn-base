//
//  CXDepartmentUtil.h
//  InjoyYJ1
//
//  Created by wtz on 2017/8/10.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXDepartmentModel.h"

@interface CXDepartmentUtil : NSObject

singleton_interface(CXDepartmentUtil)

/**
 *  从服务器获取所有部门静态数据
 */
- (void)getDepartmentDataFromServer;

/**
 *  获取所有部门静态数据
 *
 *  @return 静态数据模型数组
 */
- (NSArray<CXDepartmentModel *> *)getAllDepartmentStaticData;

/**
 *  获取所有部门id数组
 *
 *  @return 部门ID数组
 */
- (NSArray<NSNumber *> *)getDepartmentIDArray;

/**
 *  获取所有部门名称数组
 *
 *  @return 部门名称数组
 */
- (NSArray<NSString *> *)getDepartmentNameArray;

/**
 *  根据部门名字获取部门对象
 *
 *  @return 部门对象
 */
- (CXDepartmentModel *)getDepartmentModelWithName:(NSString *)name;

/**
 *  根据部门EID获取部门对象
 *
 *  @return 部门对象
 */
- (CXDepartmentModel *)getDepartmentModelWithEID:(NSNumber *)eid;

@end
