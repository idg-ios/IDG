//
//  ICEFORCEPotentialDetailModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEPotentialDetailModel : NSObject
/** 行业ID */
@property (nonatomic ,copy) NSString *comIndu;
/** 行业 */
@property (nonatomic ,copy) NSString *comInduStr;
/**  */
@property (nonatomic ,copy) NSString *currentRound;
/**  */
@property (nonatomic ,copy) NSString *headCity;
/**  */
@property (nonatomic ,copy) NSString *headCityStr;
/** 行业小组ID */
@property (nonatomic ,copy) NSString *indusGroup;
/** 行业小组 */
@property (nonatomic ,copy) NSString *indusGroupStr;
/** 项目ID */
@property (nonatomic ,copy) NSString *projId;
/** 项目负责人名称 */
@property (nonatomic ,copy) NSString *projManagerNames;
/** 项目负责人 */
@property (nonatomic ,copy) NSString *projManagers;
/** 项目组成员名称 */
@property (nonatomic ,copy) NSString *projTeamNames;
/** 项目组成员 */
@property (nonatomic ,copy) NSString *projTeams;

/** 子状态，翻译 */
@property (nonatomic ,copy) NSString *subStsIdStr;
/** 项目名称 */
@property (nonatomic ,copy) NSString *projName;
/** 拟投资金额 */
@property (nonatomic ,strong) NSString *planInvAmount;
/** 项目介绍 */
@property (nonatomic ,copy) NSString *zhDesc;
/** 团队介绍 */
@property (nonatomic ,copy) NSString *teamDesc;
/** 子状态 */
@property (nonatomic ,copy) NSString *subStsId;
/** 项目状态id */
@property (nonatomic ,copy) NSString *stsId;
/** 项目状态 */
@property (nonatomic ,copy) NSString *stsIdStr;


+(id)modelWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
