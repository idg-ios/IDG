//
//  ICEFORCEPersonListModel.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/18.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEPersonListModel : NSObject

@property (nonatomic ,copy) NSString *createBy;
@property (nonatomic ,copy) NSString *createDate;
@property (nonatomic ,copy) NSString *editBy;
@property (nonatomic ,copy) NSString *editDate;
@property (nonatomic ,copy) NSString *pageNo;
@property (nonatomic ,copy) NSString *pageSize;
@property (nonatomic ,copy) NSString *queryString;
@property (nonatomic ,copy) NSString *remarks;
@property (nonatomic ,copy) NSString *segments;
@property (nonatomic ,strong) NSNumber *showOrder;
@property (nonatomic ,copy) NSString *userAccount;
@property (nonatomic ,copy) NSString *userEmail;
@property (nonatomic ,copy) NSString *userFunction;
@property (nonatomic ,strong) NSNumber *userId;
@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,copy) NSString *userOfficephone;
@property (nonatomic ,copy) NSString *userPassword;
@property (nonatomic ,strong) NSNumber *userTelphone;
@property (nonatomic ,copy) NSString *validFlag;


@property (nonatomic ,assign) BOOL isSelect;

+(id)modelWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
