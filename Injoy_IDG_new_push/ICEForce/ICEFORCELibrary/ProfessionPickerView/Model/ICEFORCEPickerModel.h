//
//  ICEFORCEPickerModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEPickerModel : NSObject

@property (nonatomic ,copy) NSString *codeKey;
@property (nonatomic ,copy) NSString *typeKey;
@property (nonatomic ,copy) NSString *codeNameZhCn;
@property (nonatomic ,copy) NSString *codeNameEnUs;
@property (nonatomic ,copy) NSString *codeNameZhTw;
@property (nonatomic ,strong) NSNumber *hasChild;
@property (nonatomic ,strong) NSArray *children;

+(id)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
