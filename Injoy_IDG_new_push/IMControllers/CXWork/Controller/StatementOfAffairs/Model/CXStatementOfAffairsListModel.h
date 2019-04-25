//
//  CXStatementOfAffairsListModel.h
//  InjoyDDXWBG
//
//  Created by wtz on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXStatementOfAffairsListModel : NSObject

/** createTime 创建时间 Sring */
@property (nonatomic, copy) NSString * createTime;
/** eid 主键 Long */
@property (nonatomic, strong) NSNumber * eid;
/** title 报告标题 Sring */
@property (nonatomic, copy) NSString * title;
/** ygId 申请人ID Long */
@property (nonatomic, strong) NSNumber * ygId;
/** ygName 申请人 String */
@property (nonatomic, copy) NSString * ygName;
/** ygDeptId 申请部门ID Long */
@property (nonatomic, strong) NSNumber * ygDeptId;
/** ygDeptName 申请部门 String */
@property (nonatomic, copy) NSString * ygDeptName;
/** statusName 批审状态 String */
@property (nonatomic, copy) NSString * statusName;

@end
