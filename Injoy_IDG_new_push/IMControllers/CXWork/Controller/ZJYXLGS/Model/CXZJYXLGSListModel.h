//
//  CXZJYXLGSListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/5/22.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXZJYXLGSListModel : NSObject

/** createDate 时间 Sring */
@property (nonatomic, copy) NSString * createDate;
/** indusType 行业 String */
@property (nonatomic, copy) NSString * indusType;
/** projId ID Long */
@property (nonatomic, strong) NSNumber * projId;
/** projManagerName 项目经理 String */
@property (nonatomic, copy) NSString * projManagerName;
/** projName 项目名称 String */
@property (nonatomic, copy) NSString * projName;

@property (nonatomic, strong) NSNumber *projGroup;
@end
