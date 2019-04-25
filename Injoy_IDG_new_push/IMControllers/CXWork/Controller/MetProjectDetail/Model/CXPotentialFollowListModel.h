//
//  CXPotentialFollowListModel.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXPotentialFollowListModel : NSObject

/** devDate 日期 Sring */
@property(nonatomic,copy)NSString * devDate;
/** followPerson 与会者 Sring */
@property(nonatomic,copy)NSString * followPerson;
/** devId 跟进情况ID Long */
@property(nonatomic,strong)NSNumber * devId;
/** invFlowUp 跟进状态 Long flowUp 继续跟进   abandon 放弃  WS 观望 */
@property(nonatomic,copy)NSString * invFlowUp;
/** keyNote keyNote String */
@property(nonatomic,copy)NSString * keyNote;
/** projId 项目ID Long */
@property(nonatomic,strong)NSNumber * projId;

@end
