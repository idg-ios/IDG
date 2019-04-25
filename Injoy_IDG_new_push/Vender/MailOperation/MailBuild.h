//
//  MailParseBuild.h
//  EmlTest
//
//  Created by mengxianzhi on 15-4-14.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MailCore/MailCore.h"
typedef void(^EmlData)(NSData *emlData);

@interface MailBuild : NSObject


- (void)buildEmlTheme:(NSString *)mailTheme mailBody:(NSString *)mailBody mailToDic:(NSArray *)toArrDic mailFrom:(NSString *)mailFrom mailCCDic:(NSArray *)mailCCArrDic mailBCCDic:(NSArray *)mailBCCArrDic imageList:(NSArray *)imageList fileNameList:(NSArray *)fileNameList emlData:(EmlData)emlData;

@end
