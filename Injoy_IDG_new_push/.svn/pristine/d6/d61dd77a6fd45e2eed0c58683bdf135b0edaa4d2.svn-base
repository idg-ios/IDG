//
//  MailParse.h
//  EmlTest
//
//  Created by mengxianzhi on 15-4-14.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <MailCore/MailCore.h>

@interface MailParse : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSMutableArray *to;
@property (nonatomic, strong) NSMutableArray *cc;
@property (nonatomic, strong) NSMutableArray *bcc;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *textBody;
@property (nonatomic, strong) NSString *htmlBody;

@property (nonatomic, strong) NSMutableArray *attachnames;
@property (nonatomic, strong) NSMutableArray *attachdatas;

@property (nonatomic,strong) NSString *senderTime;

@property (nonatomic, strong) NSData *emlData;
//是否有附件
@property (nonatomic, assign) BOOL havePart;

- (void)prepareForParserData:(NSData *)emlData shouldReloadTableBlock:(void (^)(MailParse *mailParser, NSString *bodyHtml))shouldReloadTableBlock;

@end
