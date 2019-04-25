//
//  ICEFORECVoiceModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORECVoiceModel : NSObject


/** 项目介绍 文本内容 */
@property (nonatomic ,copy) NSString *zhDesc;

//语音部分
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,strong) NSNumber *fileSize;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *path;
@property (nonatomic ,strong) NSNumber *showType;
@property (nonatomic ,copy) NSString *srcName;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,strong) NSNumber *userId;
@property (nonatomic ,assign) NSInteger voiceTime;


+(id)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
