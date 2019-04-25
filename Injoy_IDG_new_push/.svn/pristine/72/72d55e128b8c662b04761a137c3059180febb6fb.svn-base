//
//  STMCOPOPSession.m
//  StoryClient
//
//  Created by mengxianzhi on 15-5-20.
//  Copyright (c) 2015年 LiuQi. All rights reserved.
//  pop协议

#import "STMCOPOPSession.h"
//#import "STEmailData+Oper.h"

static STMCOPOPSession *popSession = nil;

@implementation STMCOPOPSession

///// 创建新的缓存对象
+ (STMCOPOPSession *)getSessionInstanct
{
    @synchronized(self) {
        if (popSession == nil) {
            popSession = [[STMCOPOPSession alloc]init];
        }
    }
    return popSession;
}

///// 清除Session
- (void)clearSesstionInstance{
    popSession = nil;
}

///// pop协议账号检测
- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                           port:(int)port
            loadUserResultBlock:(STLoadUserResult)loadUserResultBlock
{
    self.popSession = [[self class] getSessionInstanct];
    self.popSession.hostname = hostname;
    self.popSession.username = username;
    self.popSession.password = password;
    self.popSession.connectionType = MCOConnectionTypeTLS;
    self.popSession.port = port;//110 非SSL协议端口号
    self.popSession.timeout = 60.0;

    /// 验证账户
    NSLog(@"pop协议检测邮箱账号密码");
    MCOPOPOperation * op = [self.popSession checkAccountOperation];
    [op start:^(NSError * error)
    {
        if (error == nil) {
            if (loadUserResultBlock) {
                loadUserResultBlock(YES);
            }
        }else{
            NSLog(@"pop协议检测邮箱账号密码失败，失败信息:%@",error.description);
            if (loadUserResultBlock) {
                loadUserResultBlock(NO);
            }
        }
    }];
    
}

///// 获取邮件头部信息
- (void)loadLastNMessagesWithEmailHeaderDataBlock:(SDEmailHeaderData)emailHeader
{
    MCOPOPFetchMessagesOperation *fetch = [self.popSession fetchMessagesOperation];
    [fetch start:^(NSError *error, NSArray *message)
    {
        if (error == nil)
        {
            message = [[message reverseObjectEnumerator] allObjects];

            if ([message count] > 0)
            {
                if (message.count > kMailNumber)
                {
                    /// 要50封邮件
                    NSRange range = NSMakeRange(0, kMailNumber);
                    NSArray *arrayLast = [message subarrayWithRange:range];
                    if (emailHeader) {
                        emailHeader(arrayLast);
                    }
                } else {
                    // 回调邮件头部数据
                    if (emailHeader) {
                        emailHeader(message);
                    }
                }
            }else{
                if (emailHeader) {
                    emailHeader(@[@"没有头部"]);
                }
            }
        }
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
    MCOPOPFetchMessageOperation *op = [self.popSession fetchMessageOperationWithIndex:index];
    [op start:^(NSError * error, NSData * messageData) {
        // messageData is the RFC 822 formatted message data.
        if (error == nil)
        {
            if (emailData) {
                emailData(messageData);
            }
        }
    }];
}

@end
