//
//  STMCOPOPSession.h
//  StoryClient
//
//  Created by mengxianzhi on 15-5-20.
//  Copyright (c) 2015年 LiuQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

typedef void(^STLoadUserResult)(BOOL isSuccess);
typedef void(^STMessageArray)(NSArray *messageList);
typedef void(^SDEmailHeaderData)(NSArray *messageList);
typedef void(^SDEmailData)(NSData * messageData);

@protocol STMCOPOPSessionDelgate <NSObject>

- (void)popRefreshMailResultStatus:(NSString *)code;
- (void)popRefreshMailisMoreMail:(BOOL)isMoreMain;

@end

@interface STMCOPOPSession : MCOPOPSession

@property (nonatomic, strong) MCOPOPSession *popSession;
@property (nonatomic, strong) MCOPOPFetchMessagesOperation *popMessagesFetchOp;
@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic, strong) MCOPOPOperation *popCheckOp;
@property (weak, nonatomic) id<STMCOPOPSessionDelgate> popSessionDelgate;

- (void)loadLastNMessagesWithEmailHeaderDataBlock:(SDEmailHeaderData)emailHeader;

- (void)clearSesstionInstance;

+ (STMCOPOPSession *)getSessionInstanct;

- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                       port:(int)port
                       loadUserResultBlock:(STLoadUserResult)loadUserResultBlock;

///// 根据index获取邮件详情
- (void)loadMailDetailWithIndex:(int)index andEmailDataBlock:(SDEmailData)emailData;

@end
