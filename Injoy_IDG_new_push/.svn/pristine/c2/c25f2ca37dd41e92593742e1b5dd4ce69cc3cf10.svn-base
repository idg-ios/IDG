//
//  STMCOIMAPSession.h
//  StoryClient
//
//  Created by mengxianzhi on 15-5-11.
//  Copyright (c) 2015年 LiuQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
#import <UIKit/UIKit.h>

typedef void(^STLoadUserResult)(BOOL isSuccess);
typedef void(^SDEmailHeaderData)(NSArray *messageList);
typedef void(^SDEmailData)(NSData * messageData);

@protocol STMCOIMAPSessionDelgate <NSObject>

- (void)refreshMailResultStatus:(NSString *)code;
- (void)refreshMailisMoreMail:(BOOL)isMoreMain;

@end

@interface STMCOIMAPSession : MCOIMAPSession

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) MCOIMAPSession *imapSession;
@property (nonatomic, strong) MCOIMAPFetchMessagesOperation *imapMessagesFetchOp;
@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic, strong) MCOIMAPOperation *imapCheckOp;
@property (weak, nonatomic) id<STMCOIMAPSessionDelgate> sessionDelgate;

- (void)loadLastNMessages:(NSUInteger)nMessages andEmailHeaderDataBlock:(SDEmailHeaderData)emailHeader;

- (void)clearSesstionInstance;

+ (STMCOIMAPSession *)getSessionInstanct;

- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                           port:(int)port
                    oauth2Token:(NSString *)oauth2Token
            loadUserResultBlock:(STLoadUserResult)loadUserResultBlock;

///// 根据index获取邮件详情
- (void)loadMailDetailWithIndex:(int)index andEmailDataBlock:(SDEmailData)emailData;
@end
