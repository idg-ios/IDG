//
//  ICEFORCEScoreRecordModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEScoreRecordModel : NSObject


/** 项目ID */
@property (nonatomic ,copy) NSString *projId;
/** 打分人数 */
@property (nonatomic ,strong) NSNumber *scoreCount;
/** 打分日期 */
@property (nonatomic ,copy) NSString *scoreDate;

@property (nonatomic ,assign) BOOL isShowSection;

+(id)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
