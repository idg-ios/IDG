//
//  CXIMSocketManager.h
//  CXIMLib
//
//  Created by lancely on 2/2/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIM-Singleton.h"
@class CXIMSocketModel;

typedef NS_ENUM(NSInteger,CXIMSocketState){
    CXIMSocketState_CONNECTING   = 0,
    CXIMSocketState_OPEN         = 1,
    CXIMSocketState_CLOSING      = 2,
    CXIMSocketState_CLOSED       = 3,
};

@class CXIMSocketManager;

@protocol CXIMSocketManagerDelegate <NSObject>

@optional
- (void)socketManagerDidConnected:(CXIMSocketManager *)socketManager;
- (void)socketManager:(CXIMSocketManager *)socketManager didReceiveMessage:(NSString *)message;
- (void)socketManager:(CXIMSocketManager *)socketManager disConnectWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@interface CXIMSocketManager : NSObject

singleton_interface(CXIMSocketManager)

@property (nonatomic,assign,readonly) CXIMSocketState state;

- (void)addDelegate:(id<CXIMSocketManagerDelegate>)delegate;
- (void)removeDelegate:(id<CXIMSocketManagerDelegate>)delegate;
- (void)loginWithAccount:(NSString *)account password:(NSString *)password completion:(void(^)(NSError *error))completionBlock;

/**
 *  发送消息(NSString或CXIMSocketModel)
 *
 *  @param data <#data description#>
 */
- (void)send:(id)data;

- (void)closeSocket;

- (void)reconnectWithCompletion:(void(^)(NSError *error))loginCompletionBlock;

@end
