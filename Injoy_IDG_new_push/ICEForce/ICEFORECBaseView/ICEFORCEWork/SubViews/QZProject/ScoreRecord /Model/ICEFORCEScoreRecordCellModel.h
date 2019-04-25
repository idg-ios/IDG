//
//  ICEFORCEScoreRecordCellModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEScoreRecordCellModel : NSObject

@property (nonatomic ,copy) NSString *rateId;
@property (nonatomic ,copy) NSString *projId;

/** 项目名称 */
@property (nonatomic ,copy) NSString *projName;
/** 打分人 */
@property (nonatomic ,copy) NSString *scoreName;
/** 团队评分 */
@property (nonatomic ,copy) NSString *teamScore;
/** 业务评分 */
@property (nonatomic ,copy) NSString *businessScore;
/** 评论 */
@property (nonatomic ,copy) NSString *comment;
/** 打分时间，时间类型 */
@property (nonatomic ,copy) NSString *createTime;
/** 发起打分时间，时间类型 */
@property (nonatomic ,copy) NSString *scoreDate;


+(id)modelWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
