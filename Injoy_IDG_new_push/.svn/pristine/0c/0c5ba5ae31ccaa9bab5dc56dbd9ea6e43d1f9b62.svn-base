//
//  STMCOIMAPSession.m
//  StoryClient
//
//  Created by mengxianzhi on 15-5-11.
//  Copyright (c) 2015年 LiuQi. All rights reserved.
//  IMAP协议

#import "STMCOIMAPSession.h"
//#import "STEmailData+Oper.h"

static STMCOIMAPSession *imapSession = nil;

@implementation STMCOIMAPSession

///// 创建新的缓存对象
+ (STMCOIMAPSession *)getSessionInstanct
{
    @synchronized(self) {
        if (imapSession == nil) {
            imapSession = [[STMCOIMAPSession alloc]init];
        }
    }
    return imapSession;
}

///// 清除Session
- (void)clearSesstionInstance{
    imapSession = nil;
}

///// imap账号检测
- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                       port:(int)port
                    oauth2Token:(NSString *)oauth2Token
            loadUserResultBlock:(STLoadUserResult)loadUserResultBlock;
{

    self.imapSession = [[self class] getSessionInstanct];
    self.imapSession.hostname = hostname;
    self.imapSession.username = username;
    self.imapSession.password = password;
    self.imapSession.port = port;//993 SSL协议端口号
    self.imapSession.timeout = 60.0;
    if (oauth2Token != nil)
    {
        self.imapSession.OAuth2Token = oauth2Token;
        self.imapSession.authType = MCOAuthTypeXOAuth2;
    }
    self.imapSession.connectionType = MCOConnectionTypeTLS;
    self.imapSession.connectionLogger = ^(void * connectionID, MCOConnectionLogType type, NSData * data)
    {
        if (type != MCOConnectionLogTypeSentPrivate) {
            NSLog(@"事件日志:[connectionID:%p],[type:%ld],[withData: %@]", connectionID, (long)type, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    };
    self.messages = nil;
    self.totalNumberOfInboxMessages = -1;
    
    NSLog(@"imap协议检测邮箱账号密码");
    self.imapCheckOp = [self.imapSession checkAccountOperation];
    [self.imapCheckOp start:^(NSError *error) {
        // 5 密码错误
        if (error == nil) {
            if (loadUserResultBlock) {
                loadUserResultBlock(YES);
            }
        } else {
            if (loadUserResultBlock) {
                loadUserResultBlock(NO);
            }
            NSLog(@"imap协议检测邮箱账号密码失败，失败信息:%@",error.description);
        }
        self.imapCheckOp = nil;
    }];
}

///// 加载邮件
- (void)loadLastNMessages:(NSUInteger)nMessages andEmailHeaderDataBlock:(SDEmailHeaderData)emailHeader
{
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
     MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
     MCOIMAPMessagesRequestKindFlags);
    
    NSString *inboxFolder = @"INBOX";
    MCOIMAPFolderInfoOperation *inboxFolderInfo = [self.imapSession folderInfoOperation:inboxFolder];
    
    [inboxFolderInfo start:^(NSError *error, MCOIMAPFolderInfo *info)
     {
         BOOL totalNumberOfMessagesDidChange =
         self.totalNumberOfInboxMessages != [info messageCount];
         self.totalNumberOfInboxMessages = [info messageCount];
         NSUInteger numberOfMessagesToLoad = MIN(self.totalNumberOfInboxMessages, nMessages);
         
         if (error.code == 5) {//密码错误
             if (_sessionDelgate) {
                 [_sessionDelgate refreshMailResultStatus:[NSString stringWithFormat:@"%ld",(long)error.code]];
                 return ;
             }
         }
         if (numberOfMessagesToLoad == 0)
         {
             if (_sessionDelgate) {
                 [_sessionDelgate refreshMailisMoreMail:NO];
             }
             return;
         }
         MCORange fetchRange;
         if (!totalNumberOfMessagesDidChange && self.messages.count)
         {
             numberOfMessagesToLoad -= self.messages.count;
             
             fetchRange =
             MCORangeMake(self.totalNumberOfInboxMessages -
                          self.messages.count -
                          (numberOfMessagesToLoad - 1),
                          (numberOfMessagesToLoad - 1));
         }
         else
         {
             fetchRange = MCORangeMake(self.totalNumberOfInboxMessages - (numberOfMessagesToLoad - 1),(numberOfMessagesToLoad - 1));
         }
         
         self.imapMessagesFetchOp =
         [self.imapSession fetchMessagesByNumberOperationWithFolder:inboxFolder
                                                        requestKind:requestKind
                                                            numbers:[MCOIndexSet indexSetWithRange:fetchRange]
         ];
         
         [self.imapMessagesFetchOp setProgress:^(unsigned int progress){
             NSLog(@"Progress: %u of %lu", progress, (unsigned long)numberOfMessagesToLoad);
         }];
         [self.imapMessagesFetchOp start:
          ^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages)
          {
              NSLog(@"fetched all messages.");
              NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"header.date" ascending:NO];
              NSMutableArray *combinedMessages = [NSMutableArray arrayWithArray:messages];
              [combinedMessages addObjectsFromArray:self.messages];
              self.messages = [combinedMessages sortedArrayUsingDescriptors:@[sort]];
              
              if ([self.messages count] > 0) {
                  if (emailHeader) {
                      emailHeader(self.messages);
                  }
              }
          }];
     }];
}

///// 时间转换为字符串
- (NSString *)dataFormatString:(NSDate *)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString* timeStr = [formatter stringFromDate:date];
    return timeStr;
}

///// 根据index获取邮件详情
- (void)loadMailDetailWithIndex:(int)index andEmailDataBlock:(SDEmailData)emailData
{
    MCOIMAPFetchContentOperation *op = [self.imapSession fetchMessageOperationWithFolder:@"INBOX" uid:index];
    [op start:^(NSError * error, NSData * messageData) {
        if (error == nil)
        {
            if (emailData) {
                emailData(messageData);
            }
        }
    }];
}
@end

