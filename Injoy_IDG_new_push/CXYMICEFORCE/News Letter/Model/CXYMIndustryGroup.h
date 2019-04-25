//
//  CXYMIndustryGroup.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXYMIndustryGroup : NSObject

@property (nonatomic, strong) NSNumber *deptId;///<小组id
@property (nonatomic, copy) NSString *deptName;///<小组名称
@property (nonatomic, copy) NSString *deptOrder;///<序号
@property (nonatomic, copy) NSString *induFlag;///<标签

@end
