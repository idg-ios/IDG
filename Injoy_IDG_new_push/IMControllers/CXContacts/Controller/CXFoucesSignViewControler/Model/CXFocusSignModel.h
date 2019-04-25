//
//  CXFocusSignModel.h
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  关注标签
 */
@interface CXFocusSignModel : NSObject

/**
 *  主键
 */
@property (nonatomic, strong) NSNumber *ID;

/**
 *  公司ID
 */
@property (nonatomic, strong) NSNumber *companyId;

/**
 *  创建人ID
 */
@property (nonatomic, strong) NSNumber *userId;

/**
 *  标签名称
 */
@property (nonatomic, strong) NSString *name;

/**
 *  标签成员总人数
 */
@property (nonatomic, strong) NSNumber *concernCount;

@end
