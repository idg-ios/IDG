//
//  CXYJNewColleaguesModel.h
//  InjoyYJ1
//
//  Created by wtz on 2017/9/5.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXYJNewColleaguesModel : NSObject

/**新同事消息的ID*/
@property (nonatomic, copy) NSString * messageId;
/**新同事入职时间*/
@property (nonatomic, copy) NSString * joinTime;
/**新同事部门Id*/
@property (nonatomic, copy) NSString * deptId;
/**新同事部门名称*/
@property (nonatomic, copy) NSString * deptName;
/**新同事名字*/
@property (nonatomic, copy) NSString * name;
/**新同事职务*/
@property (nonatomic, copy) NSString * job;
/**新同事头像*/
@property (nonatomic, copy) NSString * icon;
/**新同事部门名称imAccount*/
@property (nonatomic, copy) NSString * imAccount;

@end
