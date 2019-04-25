//
//  CXMetProjectListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/2/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXMetProjectListModel : NSObject

/** bizDesc 业务介绍 Sring */
@property(nonatomic,copy)NSString * bizDesc;
/** comIndus 行业 Sring */
@property(nonatomic,copy)NSString * comIndus;
/** invDate 时间 String */
@property(nonatomic,copy)NSString * invDate;
/** projId ID Long */
@property(nonatomic,strong)NSNumber * projId;
/** projName 项目名称 String */
@property(nonatomic,copy)NSString * projName;
/** userName 负责人 String */
@property(nonatomic,copy)NSString * userName;
@property (nonatomic, strong)NSNumber *projGroup;

@end
