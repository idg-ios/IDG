//
//  CXAllPeoplleWorkCircleModel.h
//  InjoyERP
//
//  Created by wtz on 16/11/23.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXAllPeoplleWorkCircleModel : NSObject

/** btype */
@property (nonatomic, copy) NSString *btype;
/** 创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** eid */
@property (nonatomic, strong) NSNumber *eid;
/** isReder */
@property (nonatomic, strong) NSNumber *isReder;
/** 标题 */
@property (nonatomic, copy) NSString *name;
/** send_icon */
@property (nonatomic, copy) NSString *send_icon;
/** send_imAccount */
@property (nonatomic, copy) NSString *send_imAccount;
/** send_name */
@property (nonatomic, copy) NSString *send_name;
/** userId */
@property (nonatomic, strong) NSNumber *userId;
/** send_name */
@property (nonatomic, copy) NSString *remark;

@end
