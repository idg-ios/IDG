//
//  ICEFORCEWorkProjectModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/11.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICEFORCEWorkProjectModel : NSObject

/** 类型 TEXT,AUDIO */
@property (nonatomic ,copy) NSString *contentType;
/**  */
@property (nonatomic ,copy) NSString *createBy;
/** 创建时间 */
@property (nonatomic ,copy) NSString *createTime;
/** 跟进人id */
@property (nonatomic ,copy) NSString *followId;
/** 跟进人 */
@property (nonatomic ,copy) NSString *followName;
/** 跟进人状态 NEW_NOTES,UPDATE_ */
@property (nonatomic ,copy) NSString *followType;
/** 项目ID */
@property (nonatomic ,copy) NSString *projId;
/** 项目名称 */
@property (nonatomic ,copy) NSString *projName;
/** 项目状态 */
@property (nonatomic ,copy) NSString *projState;
/** 项目类型 */
@property (nonatomic ,copy) NSString *projType;
/** 显示内容 */
@property (nonatomic ,copy) NSString *showDesc;
/** 如果contentType为Audio，返回的是音频的url */
@property (nonatomic ,copy) NSString *url;
/** 用户id */
@property (nonatomic ,copy) NSString *userId;
/**  */
@property (nonatomic ,strong) NSNumber *validFlag;

#pragma mark - 以下是含有id的字段
//自己的
@property (nonatomic ,copy) NSString *pjId;

@property (nonatomic ,strong) NSNumber *audioTime;
@property (nonatomic ,copy) NSString *badProjState;
@property (nonatomic ,copy) NSString *chartFlag;
@property (nonatomic ,copy) NSString *comIndu;
@property (nonatomic ,copy) NSString *comPhase;
@property (nonatomic ,copy) NSString *contributer;
@property (nonatomic ,copy) NSString *createByName;
@property (nonatomic ,copy) NSString *createDate;
@property (nonatomic ,copy) NSString *currentRound;
@property (nonatomic ,copy) NSString *detailTemplateId;
@property (nonatomic ,copy) NSString *editBy;
@property (nonatomic ,copy) NSString *editDate;
@property (nonatomic ,copy) NSString *enDesc;
@property (nonatomic ,copy) NSString *esgFlag;
@property (nonatomic ,copy) NSString *headCity;
@property (nonatomic ,copy) NSString *headCount;
@property (nonatomic ,copy) NSString *idgInvFlag;
@property (nonatomic ,copy) NSString *importantFlag;
@property (nonatomic ,copy) NSString *inDate;
@property (nonatomic ,copy) NSString *inPerson;
@property (nonatomic ,copy) NSString *indusGroup;
@property (nonatomic ,copy) NSString *infoTemplateId;
@property (nonatomic ,copy) NSString *invOrg;
@property (nonatomic ,copy) NSString *invRound;
@property (nonatomic ,copy) NSString *listedFlag;
@property (nonatomic ,copy) NSString *logoPath;
@property (nonatomic ,copy) NSString *note;
@property (nonatomic ,copy) NSString *noteId;
@property (nonatomic ,copy) NSString *noteType;
@property (nonatomic ,copy) NSString *pageNo;
@property (nonatomic ,copy) NSString *pageSize;
@property (nonatomic ,copy) NSString *planInvAmount;
@property (nonatomic ,copy) NSString *projLevel;
@property (nonatomic ,copy) NSString *projNameEn;
@property (nonatomic ,copy) NSString *projSour;
@property (nonatomic ,copy) NSString *projSourPer;
@property (nonatomic ,copy) NSString *reInvestType;
@property (nonatomic ,copy) NSString *reProjProgress;
@property (nonatomic ,copy) NSString *rePropertyType;
@property (nonatomic ,copy) NSString *reSts;
@property (nonatomic ,copy) NSString *registerCity;
@property (nonatomic ,copy) NSString *seatCount;
@property (nonatomic ,copy) NSString *seatFlag;
@property (nonatomic ,copy) NSString *secondGroup;
@property (nonatomic ,copy) NSString *sensitiveFlag;
@property (nonatomic ,copy) NSString *stsId;
@property (nonatomic ,copy) NSString *subStsId;
@property (nonatomic ,copy) NSString *webAppFlag;
@property (nonatomic ,copy) NSString *zhDesc;
/** 行高 */
@property (nonatomic ,assign) double dscHeight;

/** 显示更多 */
@property (nonatomic ,assign) BOOL isShowMore;

+(id)modelWithDict:(NSDictionary *)dict;

@end
