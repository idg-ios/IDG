//
//  SDWebSocketManager.h
//  SDMarketingManagement
//
//  Created by Rao on 15/12/14.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDWebSocketModel.h"

@interface SDWebSocketManager : NSObject

+ (instancetype)shareWebSocketManager;
- (void)closeSocket;

@end
