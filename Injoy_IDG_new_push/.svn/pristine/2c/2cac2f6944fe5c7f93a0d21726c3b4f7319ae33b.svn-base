//
//  MailParseBuild.m
//  EmlTest
//
//  Created by mengxianzhi on 15-4-14.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//

#import "MailBuild.h"

@interface MailBuild()

@property (copy , nonatomic) NSMutableArray *mutableListTo;
@property (copy , nonatomic) NSMutableArray *mutableListCc;
@property (copy , nonatomic) NSMutableArray *mutableListBcc;
@property (strong , nonatomic) NSMutableArray *partsList;

@end

@implementation MailBuild

- (instancetype) init{
    self = [super init];
    if (self) {
        _mutableListTo = [[NSMutableArray alloc]init];
        _mutableListCc = [[NSMutableArray alloc]init];
        _mutableListBcc = [[NSMutableArray alloc]init];
        _partsList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)buildEmlTheme:(NSString *)theme mailBody:(NSString *)mailBody mailToDic:(NSArray *)mailToListDic mailFrom:(NSString *)mailFrom mailCCDic:(NSArray *)mailCcListDic mailBCCDic:(NSArray *)mailBccListDic imageList:(NSArray *)fileDataList fileNameList:(NSArray *)fileNameList emlData:(EmlData)emlDataBlock{
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    
    MCOAddress *fromAdd = [MCOAddress addressWithDisplayName:[self mailNikName:mailFrom]
                                                     mailbox:mailFrom];
    
    //收件人
    for (int to = 0 ; to < mailToListDic.count ; to ++) {
        NSString *toSender = [[[mailToListDic objectAtIndex:to] allValues] objectAtIndex:0];
        MCOAddress *toAdd = [MCOAddress addressWithDisplayName:[self mailNikName:toSender] mailbox:toSender];
        [_mutableListTo addObject:toAdd];
    }
    //抄送人
    for (int cc = 0 ; cc < mailCcListDic.count ; cc ++) {
        NSString *ccSender = [[[mailCcListDic objectAtIndex:cc] allValues] objectAtIndex:0];
        
        MCOAddress *ccAdd = [MCOAddress addressWithDisplayName:[self mailNikName:ccSender]
                                                       mailbox:ccSender];
        [_mutableListCc addObject:ccAdd];
        
    }
    //密送人
    for (int bcc = 0 ; bcc < mailBccListDic.count ; bcc ++) {
        NSString *bccSender = [[[mailBccListDic objectAtIndex:bcc] allValues] objectAtIndex:0];
        
        MCOAddress *bccAdd = [MCOAddress addressWithDisplayName:[self mailNikName:bccSender]
                                                        mailbox:bccSender];
        [_mutableListBcc addObject:bccAdd];
        
    }
    [[builder header] setFrom:fromAdd];
    [[builder header] setTo:_mutableListTo];
    [[builder header] setCc:_mutableListCc];
    [[builder header] setBcc:_mutableListBcc];
    [[builder header] setSubject:[NSString stringWithCString:[theme UTF8String] encoding:NSUTF8StringEncoding]];
    [builder setHTMLBody:mailBody];
    
    NSMutableArray *mocattachmentList = [[NSMutableArray alloc]initWithCapacity:fileNameList.count];
    
    if (fileNameList.count > 0) {
        for (int a = 0; a < fileNameList.count; a ++) {
            NSString *fileName = [fileNameList objectAtIndex:a];
            NSData *fileData = [fileDataList objectAtIndex:a];
            MCOAttachment *mocattachment = [MCOAttachment attachmentWithData:fileData filename:fileName];
            [mocattachmentList addObject:mocattachment];
        }
    }
    builder.attachments = mocattachmentList;
    NSData * rfc822Data = [builder data];
    if (emlDataBlock) {
        emlDataBlock(rfc822Data);
    }
}

- (NSString *)mailNikName:(NSString *)mail{
    return [[mail componentsSeparatedByString:@"@"] objectAtIndex:0];
}

@end
