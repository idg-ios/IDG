//
//  SDChatViewControllerChange.h
//  SDIMApp
//
//  Created by wtz on 16/3/10.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDIMChatViewController : SDRootViewController

@property (nonatomic,copy) NSString *chatter;
@property (nonatomic,copy) NSString *chatterDisplayName;

@property (nonatomic,assign) BOOL isGroupChat;

//从密语进入聊天界面，开始就是阅后即焚
@property (nonatomic) BOOL isSecretLanguage;

//用来记录超级搜索需要滚动到的消息
@property (nonatomic,strong) CXIMMessage * scrollMessage;

//本地数据库搜索，直接定位到该条数据
@property (nonatomic,strong)CXIMMessage * searchMessage;

//超级搜索搜索到的消息数组
@property (nonatomic, strong)NSArray * superSearchMessages;

//用来进行阅后即焚的删除消息的定时器（cell点击之后代理调用开始计时器，每隔一秒就从@"Message_Delete_Time_Count_Dic"_IMID中取出字典刷新UI，如果字典中含有0秒的消息，则删除该条消息，如果@"Message_Delete_Time_Count_Dic"_IMID清空，则停止定时器）
@property (nonatomic, strong) NSTimer * burnMessagesAfterReadTimer;

// 发送消息
-(void)send:(CXIMMessage *)message completion:(SendMessageCompletionBlock)completionBlock;

@end
