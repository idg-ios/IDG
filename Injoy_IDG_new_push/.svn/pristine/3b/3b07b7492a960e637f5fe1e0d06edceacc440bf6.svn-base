//
//  SDClientContactModel.m
//  SDMarketingManagement
//
//  Created by slovelys on 15/5/21.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDClientContactModel.h"

@interface SDClientContactModel()

@property (nonatomic, strong)NSArray *dataArray;

@end
@implementation SDClientContactModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"model:<%p>,realName = %@,compID = %d",self,self.realName,self.compID];
}

#pragma mark 归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.linkId forKey:@"linkId"];
    [aCoder encodeObject:self.userPic forKey:@"userPic"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeObject:self.dept forKey:@"dept"];
    [aCoder encodeObject:self.cel forKey:@"cel"];
    [aCoder encodeObject:self.telephone forKey:@"telephone"];
    [aCoder encodeObject:self.compName forKey:@"compName"];
    [aCoder encodeInt:self.compID forKey:@"compID"];
    [aCoder encodeObject:self.webside forKey:@"webside"];
    [aCoder encodeObject:self.fax forKey:@"fax"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.weChat forKey:@"weChat"];
    [aCoder encodeObject:self.sinaBlog forKey:@"sinaBlog"];
    [aCoder encodeInt:self.relation forKey:@"relation"];
    [aCoder encodeInt:self.intimacy forKey:@"intimacy"];
    [aCoder encodeInt:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birth forKey:@"birth"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
    [aCoder encodeObject:self.interest forKey:@"interest"];
    [aCoder encodeInt64:self.userId forKey:@"userId"];
}

#pragma mark 解档
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.linkId = [aDecoder decodeIntForKey:@"linkId"];
        self.userPic = [aDecoder decodeObjectForKey:@"userPic"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.position = [aDecoder decodeObjectForKey:@"position"];
        self.dept = [aDecoder decodeObjectForKey:@"dept"];
        self.cel = [aDecoder decodeObjectForKey:@"cel"];
        self.telephone = [aDecoder decodeObjectForKey:@"telephone"];
        self.compName = [aDecoder decodeObjectForKey:@"compName"];
        self.compID = [aDecoder decodeIntForKey:@"compID"];
        self.webside = [aDecoder decodeObjectForKey:@"webside"];
        self.fax = [aDecoder decodeObjectForKey:@"fax"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.weChat = [aDecoder decodeObjectForKey:@"weChat"];
        self.sinaBlog = [aDecoder decodeObjectForKey:@"sinaBlog"];
        self.relation = [aDecoder decodeIntForKey:@"relation"];
        self.intimacy = [aDecoder decodeIntForKey:@"intimacy"];
        self.sex = [aDecoder decodeIntForKey:@"sex"];
        self.birth = [aDecoder decodeObjectForKey:@"birth"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
        self.interest = [aDecoder decodeObjectForKey:@"interest"];
        self.userId = [aDecoder decodeInt64ForKey:@"userId"];
        
    }
    return self;
}

@end
