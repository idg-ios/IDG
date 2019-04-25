//
//  MailParse.m
//  EmlTest
//
//  Created by mengxianzhi on 15-4-14.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//

#import "MailParse.h"

@implementation MailParse

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cc = [[NSMutableArray alloc]init];
        self.to = [[NSMutableArray alloc]init];
        self.bcc = [[NSMutableArray alloc]init];
        self.attachnames = [[NSMutableArray alloc]init];
        self.attachdatas = [[NSMutableArray alloc]init];
    }
    return self;
}
//-ObjC
- (void)prepareForParserData:(NSData *)emlData shouldReloadTableBlock:(void (^)(MailParse *mailParser, NSString *bodyHtml))shouldReloadTableBlock{
    
    MCOMessageParser * parser = [[MCOMessageParser alloc] initWithData:emlData];
    NSString * text = [parser htmlBodyRendering];
    id mainPart = [parser mainPart];
    
    if ([mainPart isKindOfClass:[MCOMultipart class]]) {
        for (id onePart in [mainPart parts]) {
            if ([onePart isKindOfClass:[MCOAttachment class]]) {
                MCOAttachment *attachMent = (MCOAttachment *)onePart;
                if (attachMent.filename) {
                    [self.attachnames addObject:attachMent.filename];
                    [self.attachdatas addObject:attachMent.data];
                }
            }
        }
    }
    
    if ([mainPart isKindOfClass:[MCOAttachment class]]) {
        if ([mainPart isKindOfClass:[MCOAttachment class]]) {
            MCOAttachment *attachMent = (MCOAttachment *)mainPart;
            
            if (attachMent.filename) {
                [self.attachnames addObject:attachMent.filename];
                [self.attachdatas addObject:attachMent.data];
            }
        }
    }
    self.htmlBody = parser.htmlBodyRendering;
    self.textBody = parser.plainTextRendering;
    self.from = parser.header.from.nonEncodedRFC822String;
    
    
    for (int tt = 0; tt < parser.header.to.count; tt++) {
        NSString *t = [[parser.header.to objectAtIndex:tt] nonEncodedRFC822String];
        [self.to addObject:t];
    }
    
    for (int ccc  = 0; ccc < parser.header.cc.count; ccc++) {
        NSString *c = [[parser.header.cc objectAtIndex:ccc] nonEncodedRFC822String];
        [self.cc addObject:c];
    }
    for (int bbb  = 0; bbb < parser.header.bcc.count; bbb++) {
        NSString *bb = [[parser.header.bcc objectAtIndex:bbb] nonEncodedRFC822String];
        [self.bcc addObject:bb];
    }
    self.subject = parser.header.subject;
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString* dateStr = [dateFormater stringFromDate:parser.header.date];
    self.senderTime = dateStr;
    self.havePart = parser.attachments.count > 0? YES : NO;
    if (shouldReloadTableBlock) {
        shouldReloadTableBlock(self,text);
    }
}


@end
