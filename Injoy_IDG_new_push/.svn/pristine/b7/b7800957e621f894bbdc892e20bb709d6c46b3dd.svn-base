//
//  SDWebSocketManager.m
//  SDMarketingManagement
//
//  Created by Rao on 15/12/14.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDWebSocketManager.h"
#import "SDWebSocketModel.h"

@interface SDWebSocketManager () <CXIMSocketManagerDelegate>

@property (nonatomic, strong, readonly) CXIMSocketManager* socketManager;

@end

@implementation SDWebSocketManager

static SDWebSocketManager* m_SDWebSocketManager = nil;

- (CXIMSocketManager*)socketManager
{
    return [CXIMService sharedInstance].socketManager;
}

+ (instancetype)shareWebSocketManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == m_SDWebSocketManager) {
            m_SDWebSocketManager = [[self alloc] initExt];
            [m_SDWebSocketManager.socketManager addDelegate:m_SDWebSocketManager];
        }
    });
    return m_SDWebSocketManager;
}

- (instancetype)initExt
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [m_SDWebSocketManager.socketManager removeDelegate:self];
}

- (void)closeSocket
{
    [self.socketManager closeSocket];
}

#pragma mark - CXIMSocketManagerDelegate
- (void)socketManagerDidConnected:(CXIMSocketManager*)socketManager
{
    NSLog(@"Websocket Connected");
}

- (void)socketManager:(CXIMSocketManager*)socketManager didReceiveMessage:(NSString*)message
{
    NSLog(@"Received \"%@\"", message);
    if ([message isKindOfClass:[NSString class]]) {
        NSData* jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* webSocketDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        
        int revceivedType = [[webSocketDict valueForKey:@"type"] intValue];
        if (revceivedType == 18) {
            //这里解决被挤下线时重连socket问题
            [self closeSocket];
            return;
        }
        BOOL isOnline = revceivedType != offlineMessage_respone;
        int theCrcCode = [[webSocketDict valueForKey:@"crcCode"] intValue];
        NSString* textMsg = [webSocketDict valueForKey:@"textMsg"];
    
        if ([textMsg length] && theCrcCode == 0xabef0101) {
            NSMutableDictionary* textMsgDict = [[NSJSONSerialization JSONObjectWithData:[textMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil] mutableCopy];
            [self handleTextMsgDict:textMsgDict WebSocketDict:webSocketDict IsOnline:isOnline];
        }
    }
}

- (void)socketManager:(CXIMSocketManager*)socketManager disConnectWithCode:(NSInteger)code reason:(NSString*)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Websocket disConnect, Code:%ld, Reason:%@", (long)code, reason);
}

//解析服务器数据
- (void)handleTextMsgDict:(NSDictionary*)textMsgDict WebSocketDict:(NSDictionary*)webSocketDict IsOnline:(BOOL)isOnline
{
    if ([[textMsgDict allKeys] count]) {
        if (isOnline) {
            //发送已读推送回执给服务器告诉服务器不要再发这条推送消息了
            SDWebSocketModel* sendModel = [[SDWebSocketModel alloc] init];
            sendModel.from = VAL_HXACCOUNT;
            sendModel.messageId = [webSocketDict valueForKey:@"messageId"];
            sendModel.mediaType = 1;
            sendModel.type = [NSNumber numberWithInt:answer_respone];
            [self.socketManager send:[sendModel description]];

            //处理textMsgDict
            [self handlePushMessageWithTextMsgDict:textMsgDict];
        }
        
        //如果是离线消息
        else{
            NSMutableArray* keyArray = [NSMutableArray array];
            for (NSString* key in [textMsgDict allKeys]) {
                [keyArray addObject:key];
            }
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:keyArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString* trimmingStr1 = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString* messaageBodyStr = [trimmingStr1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            //发送已读推送回执给服务器告诉服务器不要再发这条推送消息了
            SDWebSocketModel* sendModel = [[SDWebSocketModel alloc] init];
            sendModel.from = VAL_HXACCOUNT;
            sendModel.textMsg = messaageBodyStr;
            sendModel.mediaType = 1;
            sendModel.type = [NSNumber numberWithInt:answer_respone];
            [self.socketManager send:[sendModel description]];

            //遍历取出离线数据字典
            for (NSMutableDictionary* dict in [textMsgDict allValues]) {
                //处理离线消息中的textMsgDict,dict和在线消息中的textMsgDict数据结构相同
                [self handlePushMessageWithTextMsgDict:dict];
            }
        }
    }
}

//处理textMsgDict
- (void)handlePushMessageWithTextMsgDict:(NSDictionary*)textMsgDict{
    NSString * type = [NSString stringWithFormat:@"%ld",(long)[textMsgDict[@"type"] integerValue]];
    NSString * bType = [NSString stringWithFormat:@"%ld",(long)[textMsgDict[@"btype"] integerValue]];

    if([type isEqualToString:APPROVE_MINE]){//系统消息的判断条件,请假完成-出差完成
        if ([bType isEqualToString:IM_PUSH_QJ] ||//请假
            [bType isEqualToString:IM_PUSH_CLSP]) {//出差
            //保存到key为IM_SystemMessage
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_SystemMessage];
        }
        
    }
    else if([type isEqualToString:IM_PUSH_PROGRESS]){//系统消息的判断条件,销假完成
        if ([bType isEqualToString:IM_PUSH_XIAO]) {//我的销假
            //保存到key为IM_SystemMessage
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_SystemMessage];
        }
        
    }
    
    //我的申请，被审批完成的推送
    if([type isEqualToString:APPROVE_MINE]){
        //我的请假
        if([bType isEqualToString:IM_PUSH_QJ]){
            //保存到key为2
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_QJ];
            return;
        }
        //我的出差
        else if([bType isEqualToString:IM_PUSH_CLSP]){
            //保存到key为15
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_CLSP];
            return;
        }
        //我的销假
        else if([bType isEqualToString:IM_PUSH_XIAO]){
            //保存到key为14
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_XIAO];
            return;
        }
    }
    //给我的审批
    else if([type isEqualToString:APPROVE_FOR_ME]){
        //请假审批
        if([bType isEqualToString:IM_PUSH_QJ]){
            //保存到key为222
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_CK];
            return;
        }
        //差旅审批
        else if([bType isEqualToString:IM_PUSH_CLSP]){
            //保存到key为1515
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_CLSP2];
            return;
        }
        //销假审批
        else if([bType isEqualToString:IM_PUSH_XIAO]){
            //保存到key为1414
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_XIAO2];
            return;
        }
        //报销审批
        else if([bType isEqualToString:IM_PUSH_BS]){
            //保存到key为1717
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_BSPS];
            return;
        }
    }
    //消息-几个大佬能收到所有人的推送。
    else if([type isEqualToString:IM_PUSH_PUSH_HOLIDAY]){
        //保存到key为1203
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_PUSH_HOLIDAY];
        return;
    }
    //流程消息
    else if([type isEqualToString:IM_PUSH_PROGRESS]){
        //我的销假
        if([bType isEqualToString:IM_PUSH_XIAO]){
            //保存到key为14
            [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_XIAO];
        }
        //保存到key为1205
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_PROGRESS];
        return;
    }
    //日常会议
    else if([type isEqualToString:IM_PUSH_CS] && [bType isEqualToString:IM_PUSH_DM]){
        //保存到key为9
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_DM];
        return;
    }
    //公司通知
    else if([type isEqualToString:IM_PUSH_CS] || ([type isEqualToString:IM_PUSH_GSTZ] && [bType isEqualToString:IM_PUSH_GT])){
        //保存到key为8
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_GT];
        return;
    }
    //弹幕
    else if([type isEqualToString:PUSH_BARRAGE] && [bType isEqualToString:NH_CODE]){
        //代码保存key13
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:NH_CODE];
        return;
    }
    //公众号
    else if([type isEqualToString:IM_PUSH_ZBKB]){
        //保存到key为12
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_ZBKB];
        return;
    }
    //newsletter
    else if([type isEqualToString:IM_PUSH_NEWSLETTER]){
        //保存到key为1206
        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_NEWSLETTER];
        return;
    }
//    //公司新闻
//    else if([type isEqualToString:IM_PUSH_GSXW]){
//        //保存到key为1209
//        [self savePushMessageWithTextMsgDict:textMsgDict SaveType:IM_PUSH_GSXW];
//        return;
//    }
}

//保存推送消息到NSUserDefaults
-(void)savePushMessageWithTextMsgDict:(NSDictionary*)textMsgDict SaveType:(NSString *)saveType{
    NSMutableDictionary *pushes = [VAL_PUSHES mutableCopy];
    if (!pushes) {
        pushes = [NSMutableDictionary dictionary];
        VAL_PUSHES_RESET(pushes);
    }
    NSMutableArray *textMsgs;
    textMsgs = [VAL_PUSHES_MSGS(saveType) mutableCopy];
    if (!textMsgs) {
        textMsgs = [NSMutableArray array];
    }
    [textMsgs addObject:textMsgDict];
    pushes[saveType] = textMsgs;
    VAL_PUSHES_RESET(pushes);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceivePushNotificationKey object:nil userInfo:@{kPushTypeKey :saveType, kPushMsgKey : textMsgDict}];
}

@end
