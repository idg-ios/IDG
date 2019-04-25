//
//  STSendMail.h
//  mailcore
//
//  Created by mengxianzhi on 15-5-12.
//  Copyright (c) 2015年 mengxianzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

typedef void(^SuccessBlock)(BOOL isSuccess);
@protocol STSendMailDelgate <NSObject>

- (void)sendMailStatus:(BOOL) isSuccess;

@end

@interface STSendMail : NSObject

@property (weak,nonatomic) id<STSendMailDelgate>sendMailDelgate;
@property (strong,nonatomic) NSString *mailTheme;   //主题
@property (strong,nonatomic) NSString *mailContents;//内容
@property (strong,nonatomic) NSArray *mailAccessoryDic;//附件
@property (strong,nonatomic) NSString *mailfrom;      //发件人
@property (strong,nonatomic) NSArray *mailToList; //收件人
@property (strong,nonatomic) NSArray *mailCcList; //抄送人
@property (strong,nonatomic) NSArray *mailBccList; //米送人
@property (strong,nonatomic) NSString *mailRelayHost;//发件服务器地址
@property (strong,nonatomic) NSString *mailPassWord;//发件人邮箱密码

- (instancetype) init;

- (void)sendMailTheme:(NSString *)theme mailContents:(NSString *)mailContents mailAccessoryNameList:(NSArray *)fileNameList mailAccessoryDataList:(NSArray *)fileDataList mailfrom:(NSString *)mailfrom mailToListDic:(NSArray *)mailToListDic mailCcListDic:(NSArray *)mailCcListDic mailBccListDic:(NSArray *)mailBccListDic mailRelayHost:(NSString *)mailRelayHost mailPassWord:(NSString *)mailPassWord hostName:(NSString *)hostname;

@end
