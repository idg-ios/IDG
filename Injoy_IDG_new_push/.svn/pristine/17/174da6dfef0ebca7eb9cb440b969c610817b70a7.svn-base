//
//  STSendMail.m
//  mailcore
//
//  Created by mengxianzhi on 15-5-12.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//  发送邮件

#import "STSendMail.h"
#import <CFNetwork/CFNetwork.h>
#import "STMailUtils.h"
#import "MailBuild.h"
@interface STSendMail()
@property (strong , nonatomic) NSMutableArray *mutableListTo;
@property (strong , nonatomic) NSMutableArray *mutableListCc;
@property (strong , nonatomic) NSMutableArray *mutableListBcc;
@property (strong , nonatomic) NSMutableArray *partsList;

@end

@implementation STSendMail

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.mutableListTo = [[NSMutableArray alloc]init];
        self.mutableListCc = [[NSMutableArray alloc]init];
        self.mutableListBcc = [[NSMutableArray alloc]init];
        self.partsList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)sendMailTheme:(NSString *)theme mailContents:(NSString *)mailContents mailAccessoryNameList:(NSArray *)fileNameList mailAccessoryDataList:(NSArray *)fileDataList mailfrom:(NSString *)mailfrom mailToListDic:(NSArray *)mailToListDic mailCcListDic:(NSArray *)mailCcListDic mailBccListDic:(NSArray *)mailBccListDic mailRelayHost:(NSString *)mailRelayHost mailPassWord:(NSString *)mailPassWord hostName:(NSString *)hostname{
    
    MCOSMTPSession *mySmtpSession = [[MCOSMTPSession alloc] init];
    mySmtpSession.hostname = hostname;
    [mySmtpSession setPort:[mailRelayHost intValue]];
    mySmtpSession.username = mailfrom;
    mySmtpSession.password = mailPassWord;
    mySmtpSession.authType = MCOAuthTypeSASLPlain;
    mySmtpSession.connectionType = MCOConnectionTypeTLS;

    [[[MailBuild alloc]init] buildEmlTheme:theme mailBody:mailContents mailToDic:mailToListDic mailFrom:mailfrom mailCCDic:mailCcListDic mailBCCDic:mailBccListDic imageList:fileDataList fileNameList:fileNameList emlData:^(NSData *emlData) {
            MCOSMTPSendOperation *sendOperation = [mySmtpSession sendOperationWithData:emlData];
            [sendOperation start:^(NSError *error) {
                if(error) {
                    if (_sendMailDelgate) {
                        [_sendMailDelgate sendMailStatus:NO];
                    }
                } else {
                    if (_sendMailDelgate) {
                        [_sendMailDelgate sendMailStatus:YES];
                    }
                    NSLog(@"Successfully sent email!");
                }
            }];
        
    }];
    
/*
//    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
//    
//    MCOAddress *fromAdd = [MCOAddress addressWithDisplayName:[self mailNikName:mailfrom]
//                                                     mailbox:mailfrom];
//    
//    //收件人
//    for (int to = 0 ; to < mailToListDic.count ; to ++) {
//        NSString *toSender = [[[mailToListDic objectAtIndex:to] allValues] objectAtIndex:0];
//        MCOAddress *toAdd = [MCOAddress addressWithDisplayName:[self mailNikName:toSender] mailbox:toSender];
//        [_mutableListTo addObject:toAdd];
//    }
//    //抄送人
//    for (int cc = 0 ; cc < mailCcListDic.count ; cc ++) {
//        NSString *ccSender = [[[mailToListDic objectAtIndex:cc] allValues] objectAtIndex:0];
//        
//        MCOAddress *ccAdd = [MCOAddress addressWithDisplayName:[self mailNikName:ccSender]
//                                                       mailbox:ccSender];
//        [_mutableListCc addObject:ccAdd];
//        
//    }
//    //密送人
//    for (int bcc = 0 ; bcc < mailBccListDic.count ; bcc ++) {
//        NSString *bccSender = [[[mailBccListDic objectAtIndex:bcc] allValues] objectAtIndex:0];
//        
//        MCOAddress *bccAdd = [MCOAddress addressWithDisplayName:[self mailNikName:bccSender]
//                                                        mailbox:bccSender];
//        [_mutableListBcc addObject:bccAdd];
//        
//    }
//    [[builder header] setFrom:fromAdd];
//    [[builder header] setTo:_mutableListTo];
//    [[builder header] setCc:_mutableListCc];
//    [[builder header] setBcc:_mutableListBcc];
//    [[builder header] setSubject:[NSString stringWithCString:[theme UTF8String] encoding:NSUTF8StringEncoding]];
//    [builder setHTMLBody:mailContents];
//    
//    NSMutableArray *mocattachmentList = [[NSMutableArray alloc]initWithCapacity:fileNameList.count];
//    
//    if (fileNameList.count > 0) {
//        for (int a = 0; a < fileNameList.count; a ++) {
//            NSString *fileName = [fileNameList objectAtIndex:a];
//            NSData *fileData = [fileDataList objectAtIndex:a];
//            MCOAttachment *mocattachment = [MCOAttachment attachmentWithData:fileData filename:fileName];
//            [mocattachmentList addObject:mocattachment];
//        }
//    }
//    builder.attachments = mocattachmentList;
//    NSData * rfc822Data = [builder data];
//    MCOSMTPSendOperation *sendOperation = [mySmtpSession sendOperationWithData:rfc822Data];
//    [sendOperation start:^(NSError *error) {
//        if(error) {
//            if (_sendMailDelgate) {
//                [_sendMailDelgate sendMailStatus:NO];
//            }
//        } else {
//            if (_sendMailDelgate) {
//                [_sendMailDelgate sendMailStatus:YES];
//            }
//            NSLog(@"Successfully sent email!");
//        }
//    }];
//    sendOperation.progress =^(unsigned int current, unsigned int maximum){
//        
//        NSLog(@"当前进度%d",current);
//    };
    
    
//    MCOSMTPSession *mySmtpSession = [[MCOSMTPSession alloc] init];
//    mySmtpSession.hostname = @"smtp.sina.com";
//    [mySmtpSession setPort:465];
//    mySmtpSession.username = @"objectcore@sina.com";
//    mySmtpSession.password = @"wj1104617199";
//    mySmtpSession.authType = MCOAuthTypeSASLPlain;
//    mySmtpSession.connectionType = MCOConnectionTypeTLS;
//
//    MCOMessageBuilder *mybuilder = [[MCOMessageBuilder alloc] init];
//    MCOAddress *from = [MCOAddress addressWithDisplayName:@"mengxianzhi"
//                                                  mailbox:@"objectcore@sina.com"];
//    MCOAddress *to = [MCOAddress addressWithDisplayName:@"1104617199"
//                                                mailbox:@"1104617199@qq.com"];
//
//    [[mybuilder header] setFrom:from];
//    [[mybuilder header] setTo:@[to]];
//    [[mybuilder header] setSubject:@"theme"];
//    [mybuilder setHTMLBody:@"body"];
//    NSData * myrfc822Data = [mybuilder data];
//
//    MCOSMTPSendOperation *mysendOperation =
//    [mySmtpSession sendOperationWithData:myrfc822Data];
//    [mysendOperation start:^(NSError *error) {
//        if(error) {
//            NSLog(@"Error sending email: %@", error);
//        } else {
//            NSLog(@"Successfully sent email!");
//        }
//    }];
*/
    
}

- (NSString *)mailNikName:(NSString *)mail{
    return [[mail componentsSeparatedByString:@"@"] objectAtIndex:0];
}
@end
