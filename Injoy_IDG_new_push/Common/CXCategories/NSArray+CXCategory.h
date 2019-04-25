//
//  NSArray+CXCategory.h
//  SDMarketingManagement
//
//  Created by lancely on 5/17/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CXCategory)

/** NSArray<SDCompanyUserModel *> *转换为api参数*/
@property (nonatomic, copy, readonly) NSString *ccParam;

/** 是否需要下一个审批人(通过返回结果里面的flows调用) */
@property (nonatomic, assign, readonly) BOOL isNeedNextApproval;

@end
