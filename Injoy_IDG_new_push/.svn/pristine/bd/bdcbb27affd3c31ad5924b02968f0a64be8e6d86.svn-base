//
//  SDAttendanceModel.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/1/11.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDAttendanceModel.h"

@implementation SDAttendanceModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<self:%p\n,createTime:%d\n,lz:%@\n,uid:%@\n,userName:%@\n,companyid:%d\n,time:%@\n,fromwhere:%@\n,level:%d\n,remark:%@>",self,self.attenId,self.location,self.userid,self.userName,self.companyid,self.time,self.fromwhere,self.level,self.remark];
}
#pragma mark 实现拷贝的协议
-(id)copyWithZone:(NSZone *)zone
{
    SDAttendanceModel *listModel = [[SDAttendanceModel alloc] init];
    listModel.attenId = self.attenId;
    listModel.location = self.location;
    listModel.userid = self.userid;
    listModel.userName = self.userName;
    listModel.companyid = self.companyid;
    listModel.time = self.time;
    listModel.fromwhere = self.fromwhere;
    listModel.level = self.level;
    listModel.remark = self.remark;
    
    return listModel;
}
@end
