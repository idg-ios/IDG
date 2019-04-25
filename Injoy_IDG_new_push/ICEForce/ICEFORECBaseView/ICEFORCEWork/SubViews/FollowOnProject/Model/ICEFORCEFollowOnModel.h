//
//  ICEFORCEFollowOnModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEFollowOnModel : NSObject

/** 行业Code */
@property (nonatomic ,copy) NSString *comIndu;
/** 行业，翻译 */
@property (nonatomic ,copy) NSString *comInduStr;
/**  */
@property (nonatomic ,copy) NSString *comPhaseStr;
/**  */
@property (nonatomic ,copy) NSString *enDesc;
/**  */
@property (nonatomic ,copy) NSString *followUpStatus;
/**  */
@property (nonatomic ,copy) NSString *headCity;
/**  */
@property (nonatomic ,copy) NSString *headCityStr;
/**  */
@property (nonatomic ,copy) NSString *headCount;
/** 行业小组，选择 */
@property (nonatomic ,copy) NSString *indusGroup;
/** 行业小组，翻译 */
@property (nonatomic ,copy) NSString *indusGroupStr;
/**  */
@property (nonatomic ,copy) NSString *projDDManagerNames;
/**  */
@property (nonatomic ,copy) NSString *projDDManagers;
/**  */
@property (nonatomic ,copy) NSString *projDirectorNames;
/**  */
@property (nonatomic ,copy) NSString *projDirectors;
/** 项目ID */
@property (nonatomic ,copy) NSString *projId;
/** 项目投后状态 */
@property (nonatomic ,copy) NSString *projInvestedStatus;
/**  */
@property (nonatomic ,copy) NSString *projLawyerNames;
/**  */
@property (nonatomic ,copy) NSString *projLawyers;
/**  */
@property (nonatomic ,copy) NSString *projLevel;
/**  */
@property (nonatomic ,copy) NSString *projManagerNames;
/** 项目负责人 */
@property (nonatomic ,copy) NSString *projManagers;
/** 项目名称 */
@property (nonatomic ,copy) NSString *projName;
/**  */
@property (nonatomic ,copy) NSString *projNameEn;
/**  */
@property (nonatomic ,copy) NSString *projObserverNames;
/**  */
@property (nonatomic ,copy) NSString *projObservers;
/**  */
@property (nonatomic ,copy) NSString *projPartnerNames;
/**  */
@property (nonatomic ,copy) NSString *projPartners;
/**  */
@property (nonatomic ,copy) NSString *projSourStr;
/** 项目小组成员姓名 */
@property (nonatomic ,copy) NSString *projTeamNames;
/** 项目小组成员ID */
@property (nonatomic ,copy) NSString *projTeams;
/** 项目类型 */
@property (nonatomic ,copy) NSString *projType;
/**  */
@property (nonatomic ,copy) NSString *secondGroupStr;
/** 项目阶段 */
@property (nonatomic ,copy) NSString *stsId;
/**  */
@property (nonatomic ,copy) NSString *stsIdAbbStr;
/** 项目阶段，翻译 */
@property (nonatomic ,copy) NSString *stsIdStr;
/** 描述 */
@property (nonatomic ,copy) NSString *zhDesc;

+(id)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
