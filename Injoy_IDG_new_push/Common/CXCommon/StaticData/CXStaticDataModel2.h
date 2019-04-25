//
//  CXStaticDataModel2.h
//  SDMarketingManagement
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 静态数据模型 */
@interface CXStaticDataModel2 : NSObject

/** id */
@property (nonatomic, assign) NSInteger ID;
/** 编码 */
@property (nonatomic, copy) NSString *code;
/** 名称 */
@property (nonatomic, copy) NSString *name;

@end
