//
//  NSDictionary+CXCategory.h
//  SDMarketingManagement
//
//  Created by fanzhong on 16/5/26.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CXCategory)

/** 移除null值 */
- (instancetype)removeNSNull;

/** 是否需要下一个审批人(通过返回结果里面的flows调用) */
@property (nonatomic, assign, readonly) BOOL isNeedNextApproval;

@end
