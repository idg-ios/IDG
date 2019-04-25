//
//  CXYMProjectModel.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMProjectModel.h"
#import "NSString+CXCategory.h"

@implementation CXYMProjectModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _projectID = dictionary[@""];
        _projectType = [dictionary[@""] integerValue];
        _projectTypeName = dictionary[@""];
        _projectName = dictionary[@""] ;
        _projectDestribute = dictionary[@""];
    }
    return self;
}

+(NSArray <CXYMProjectModel *> *)projectArrayWithArray:(NSArray *)array{
    if (array == nil || array.count == 0) return nil;
    NSMutableArray *projectArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        CXYMProjectModel *project = [[[self class] alloc] initWithDictionary:dictionary];
        [projectArray addObject:project];
    }
    return projectArray;
}
@end

@implementation CXYMEventModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _eventID = dictionary[@""];
        _eventType = [dictionary[@""] integerValue];
        _eventTypeName = dictionary[@""];
        _eventName = dictionary[@""];
        _eventDestribute = dictionary[@""];
    }
    return self;
}
+ (NSArray <CXYMEventModel *> *)eventArrayWithArray:(NSArray *)array{
    if (array == nil || array.count == 0) return nil;
    NSMutableArray *eventArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        CXYMEventModel *event = [[[self class] alloc] initWithDictionary:dictionary];
        [eventArray addObject:event];
    }
    return eventArray;
}
@end

@implementation CXYMBadAssetsModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        //        _projId = dictionary[@"projId"];
        _projInDate = dictionary[@"projInDate"] ? : @" ";
        _dealLeadName = ![dictionary[@"dealLeadName"] isEqual:[NSNull class]] ? dictionary[@"dealLeadName"]: @" ";
        _dealLegalName = ![dictionary[@"dealLegalName"] isEqual:[NSNull class]] ? dictionary[@"dealLegalName"]: @" ";
        _ename = dictionary[@"ename"] ? : @" ";
        _grade = ![dictionary[@"grade"] isEqual:[NSNull class]] ? dictionary[@"grade"]: @" ";
        _indusName = ![dictionary[@"indusName"] isEqual:[NSNull class]] ? dictionary[@"indusName"] : @" ";
    }
    return self;
}
+ (NSArray<CXYMBadAssetsModel *>*)badAssetsArrayWithArray:(NSArray *)array{
    if (array == nil || array.count == 0) return nil;
    NSMutableArray *badAssetsArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        CXYMBadAssetsModel *badAssets = [[[self class] alloc] initWithDictionary:dictionary];
        [badAssetsArray addObject:badAssets];
    }
    return badAssetsArray;
}

@end


