//
//  SDWebSocketModel.m
//  SDMarketingManagement
//
//  Created by Rao on 15/12/11.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDWebSocketModel.h"
#import "YYModel.h"

@implementation SDWebSocketModel

- (int)crcCode
{
    return 0xabef0101;
}

- (int)socketType
{
    return 1;
}

- (NSString*)from
{
    return VAL_HXACCOUNT;
}

- (NSString*)description
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSNumber numberWithInt:self.crcCode] forKey:@"crcCode"];
    [params setValue:self.messageId forKey:@"messageId"];
    [params setValue:self.from forKey:@"from"];
    [params setValue:self.to forKey:@"to"];
   // [params setValue:self.groupId forKey:@"groupId"];
    [params setValue:self.password forKey:@"password"];
    [params setValue:[NSNumber numberWithInt:self.socketType] forKey:@"socketType"];
    [params setValue:self.type forKey:@"type"];
    [params setValue:self.textMsg forKey:@"textMsg"];
    [params setValue:[NSNumber numberWithInt:self.mediaType] forKey:@"mediaType"];

    return [params yy_modelToJSONString];
}

@end
