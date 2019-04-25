//
//  CXIDGConferenceInformationListModel.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXIDGConferenceInformationListModel : NSObject

/** opinionId ID Long */
@property (nonatomic, strong) NSNumber * opinionId;
/** approvedByName 批审人 String */
@property (nonatomic, copy) NSString * approvedByName;
/** conclusion 结论 String */
@property (nonatomic, copy) NSString * conclusion;
/** opinionDate 日期 String */
@property (nonatomic, copy) NSString * opinionDate;
/** opinionTypeName 会议类型 String */
@property (nonatomic, copy) NSString * opinionTypeName;
/** remarks 会议讨论内容 String html代码片段 */
@property (nonatomic, copy) NSString * remarks;
/** editByName 维护人 String */
@property (nonatomic, copy) NSString * editByName;
/** teamName 负责人 array 只有负责人才有批审功能 */
@property (nonatomic, strong) NSArray<NSString *>* team;

@end
