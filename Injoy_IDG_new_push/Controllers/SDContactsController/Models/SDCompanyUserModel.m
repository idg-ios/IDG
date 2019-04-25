//
//  SDCompanyUserModel.m
//  SDMarketingManagement
//
//  Created by Rao on 15-5-6.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDCompanyUserModel.h"

@implementation SDCompanyUserModel

- (BOOL)isEqual:(id)object
{
    BOOL result = NO;

    if ((nil == object) || NO == [object isKindOfClass:[SDCompanyUserModel class]]) {
        result = NO;
        return result;
    }

    if ([_hxAccount isEqualToString:[object hxAccount]] && [_realName isEqualToString:[object realName]]) {
        result = YES;
    }

    return result;
}

#pragma mark 归档的代理方法
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.job forKey:@"job"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.companyId forKey:@"companyId"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.hxAccount forKey:@"hxAccount"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.managerId forKey:@"managerId"];
    [aCoder encodeObject:self.updateTime forKey:@"updateTime"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeObject:[NSNumber numberWithLong:self.headId] forKey:@"headId"];
    [aCoder encodeObject:self.isKeFu forKey:@"isKeFu"];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.job = [aDecoder decodeObjectForKey:@"job"];
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
        self.companyId = [aDecoder decodeObjectForKey:@"companyId"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.hxAccount = [aDecoder decodeObjectForKey:@"hxAccount"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.managerId = [aDecoder decodeObjectForKey:@"managerId"];
        self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
        self.headId = [[aDecoder decodeObjectForKey:@"headId"] longValue];
        self.isKeFu = [aDecoder decodeObjectForKey:@"isKeFu"];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

+ (NSDictionary*)modelCustomPropertyMapper
{
    return @{ @"userId" : @"eid" };
}

@end
