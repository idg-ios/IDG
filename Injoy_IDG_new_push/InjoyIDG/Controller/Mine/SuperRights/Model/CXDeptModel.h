//
//  CXDeptModel.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXDeptModel : NSObject

/** 部门id */
@property (nonatomic, assign) NSInteger eid;
/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 是否选择 */
@property (nonatomic, assign) BOOL selected;

@end
