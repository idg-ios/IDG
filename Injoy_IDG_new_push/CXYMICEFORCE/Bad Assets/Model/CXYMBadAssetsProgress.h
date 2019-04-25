//
//  CXYMBadAssetsProgress.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/21.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXYMBadAssetsProgress : NSObject

@property (nonatomic, strong) NSNumber *actionId;///<主键
@property (nonatomic, copy) NSString *projId;///<项目id
@property (nonatomic, copy) NSString *actionDate;///<时间
@property (nonatomic, copy) NSString *actionContent;///<最新进展
@property (nonatomic, copy) NSString *editDate;///<更新日期


@end
