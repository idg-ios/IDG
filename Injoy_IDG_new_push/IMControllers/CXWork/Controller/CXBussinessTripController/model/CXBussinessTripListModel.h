//
//  CXBussinessTripListModel.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXBussinessTripListModel : NSObject
@property(nonatomic, strong)NSString *apply; //申请人账号
@property(nonatomic, strong)NSString *applyId;
@property(nonatomic, assign)long businessId; //主键
@property(nonatomic, strong)NSString *applyDate; //申请日期
@property(nonatomic, strong)NSDecimalNumber *budget; //出差预算金额
@property(nonatomic, strong)NSArray *city; //出差城市
@property(nonatomic, strong)NSString *remark; //出差事由
@property(nonatomic, strong)NSString *currentApprove; // 当前审批人账号
@property(nonatomic, assign)int isApprove; // 批审状态
@property(nonatomic, strong)NSString *reason; // 批审理由
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *realName;

@end
