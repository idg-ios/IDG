//
//  CXIMSystemNotifyMessageBody.h
//  CXIMLib
//
//  Created by lancely on 2/18/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "CXIMMessageBody.h"

@interface CXIMSystemNotifyMessageBody : CXIMMessageBody

/**
 *  通知内容
 */
@property (nonatomic,copy) NSString *notifyContent;

+ (instancetype)bodyWithNotifyConetnt:(NSString *)notifyConetnt;

@end
