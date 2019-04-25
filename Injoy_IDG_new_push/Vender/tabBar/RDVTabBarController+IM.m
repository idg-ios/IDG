//
//  RDVTabBarController+IM.m
//  SDMarketingManagement
//
//  Created by wtz on 16/3/31.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "RDVTabBarController+IM.h"
#import "RDVTabBarController.h"
#import "SDDataBaseHelper.h"
#import "SDSocketCacheManager.h"
#import "UIViewController+HUD.h"
#import <AVFoundation/AVFoundation.h>
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface RDVTabBarController () <CXIMChatDelegate, CXIMGroupDelegate>
@property (nonatomic, strong) AVAudioPlayer* ringPlayer;
@end

@implementation RDVTabBarController (IM)
- (void)imInit {
    [[CXIMService sharedInstance].chatManager addDelegate:self];
    [[CXIMService sharedInstance].groupManager addDelegate:self];
}

- (void)imDealoc {
    [[CXIMService sharedInstance].chatManager removeDelegate:self];
    [[CXIMService sharedInstance].groupManager removeDelegate:self];
}

//- (void)initRingPlayer{
//    NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"play_completed" ofType:@"mp3"];
//    NSURL* url = [[NSURL alloc] initFileURLWithPath:musicPath];
//
//    self.ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    [self.ringPlayer setVolume:1];
//    self.ringPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
//    NSLog(@"%@",self.ringPlayer);
//}

//播放提示音
- (void)playWaringSound
{
    //    __weak typeof(self) weakSelf = self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if ([weakSelf.ringPlayer prepareToPlay]) {
    //            [weakSelf.ringPlayer play];
    //        }
    //    });
}

#pragma mark - CXIMServiceDelegate
#warning 收到消息播放提示音＋震动
- (void)CXIMService:(CXIMService*)service didReceiveChatMessage:(CXIMMessage*)message
{
    [self playWaringSound];
    NSArray* typeArr0 = @[ sysnotice_socket, notice_socket ];
    NSInteger flag0 = [[SDSocketCacheManager shareCacheManager] getNumFromSocketTypeArr:typeArr0];
    
    NSInteger sysUnreadCount = 0;

    sysUnreadCount = [self.view countNumBadge:IM_SystemMessage,nil];//新版的系统消息推送,显示具体的数量,不再显示0或者1

    [self setReadOrUnRead:flag0 + sysUnreadCount andTypeNum:1];
}

/**
 *  我退出群组
 *
 *  @param service CXIMService对象
 *  @param groupId 群组id
 */
- (void)CXIMService:(CXIMService*)service didSelfExitGroupWithGroupId:(NSString*)groupId time:(NSNumber*)time
{
    //    NSLog(@"我退出群组");
}

/**
 *  我解散群组
 *
 *  @param service     CXIMService对象
 *  @param groupId     群组id
 *  @param dismissTime 解散时间
 */
- (void)CXIMService:(CXIMService*)service didSelfDismissGroupWithGroupId:(NSString*)groupId dismissTime:(NSNumber*)dismissTime
{
    //    NSLog(@"我解散群组");
}

/**
 *  我被邀请加入群组
 *
 *  @param service   CXIMService对象
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param inviter   邀请人
 */
- (void)CXIMService:(CXIMService*)service didAddedIntoGroup:(NSString*)groupName groupId:(NSString*)groupId inviter:(NSString*)inviter time:(NSNumber*)time
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] != nil){
        long timeSpace = (long)[[NSDate date] timeIntervalSince1970] - [[ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] longLongValue];
        if (timeSpace < 2) {
            NSError *error;
            NSDictionary * inviterDic = [NSJSONSerialization JSONObjectWithData:[inviter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            if (error) {
                inviter = [CXIMHelper getUserByIMAccount:inviter].name?[CXIMHelper getUserByIMAccount:inviter].name:inviter;
            }
            else {
                inviter = inviterDic[@"name"];
            }
            //            NSString* content = [NSString stringWithFormat:@"%@邀请你加入群聊", inviter];
            NSString *groupName1 = groupName;
            if ([groupName hasSuffix:@"群"]) {
                groupName1 = [groupName substringToIndex:groupName.length - 1];
            }
//            // 推广群前面要再加一句
//            if ([CXIMHelper isSystemGroup:groupId] && [groupName containsString:@"推广"]) {
//                NSString *content = [NSString stringWithFormat:@"%@邀请你加入群聊", inviter];
//                // -1保证这句在前面
//                [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:@(time.longLongValue - 1)];
//            }
            NSString *content = [NSString stringWithFormat:@"你已加入“%@”群，和大家打个招呼吧", groupName1];
            [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
            return;
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:groupId completion:^(CXGroupInfo *group, NSError *error) {
            if(!error){
                [[CXLoaclDataManager sharedInstance]updateLocalDataWithGroupId:group.groupId AndGroup:group];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]];
            }
        }];
    });
    NSError *error;
    NSDictionary * inviterDic = [NSJSONSerialization JSONObjectWithData:[inviter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
        inviter = [CXIMHelper getUserByIMAccount:inviter].name?[CXIMHelper getUserByIMAccount:inviter].name:inviter;
    }
    else {
        inviter = inviterDic[@"name"];
    }
    //    NSString* content = [NSString stringWithFormat:@"%@邀请你加入群聊", inviter];
    NSString *groupName1 = groupName;
    if ([groupName hasSuffix:@"群"]) {
        groupName1 = [groupName substringToIndex:groupName.length - 1];
    }
//    // 推广群前面要再加一句
//    if ([CXIMHelper isSystemGroup:groupId] && [groupName containsString:@"推广"]) {
//        NSString *content = [NSString stringWithFormat:@"%@邀请你加入群聊", inviter];
//        // -1保证这句在前面
//        [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:@(time.longLongValue - 1)];
//    }
    NSString *content = [NSString stringWithFormat:@"你已加入“%@”群，和大家打个招呼吧", groupName1];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

/**
 *  成员被移出群组
 *
 *  @param service   CXIMService对象
 *  @param member    成员
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param owner     群主
 */
- (void)CXIMService:(CXIMService*)service didMembers:(NSArray<NSString*>*)members removedFromGroup:(NSString*)groupName groupId:(NSString*)groupId byOwner:(NSString*)owner time:(NSNumber*)time
{
    if ([owner isEqualToString:service.chatManager.currentAccount]) {
        owner = @"我";
    }else{
        owner = [[CXLoaclDataManager sharedInstance]getUserByGroupId:groupId AndIMAccount:owner].name;
    }
    NSMutableArray* names = [NSMutableArray array];
    for (NSString* user in members) {
        [names addObject:[[CXLoaclDataManager sharedInstance] getUserByGroupId:groupId AndIMAccount:user].name];
    }
    NSString* nameStr = [names componentsJoinedByString:@","];
    NSString* content = [NSString stringWithFormat:@"%@将%@移出群聊", owner, nameStr];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

/**
 *  我被移出群组/群解散
 *
 *  @param service   CXIMService对象
 *  @param groupName 群组名称
 *  @param groupId   群组id
 */
- (void)CXIMService:(CXIMService*)service didRemovedFromGroup:(NSString*)groupName groupId:(NSString*)groupId time:(NSNumber*)time
{
    //    NSLog(@"我被移出群组/群解散");
    [self showHint:[NSString stringWithFormat:@"我被移出群聊%@", groupName] yOffset:-150.0];
}

/**
 *  群组名称被修改
 *
 *  @param service   CXIMService对象
 *  @param groupName 新的群组名称
 *  @param groupId   群组id
 *  @param owner     群主
 */
- (void)CXIMService:(CXIMService*)service didChangedGroupName:(NSString*)groupName groupId:(NSString*)groupId byOwner:(NSString*)owner time:(NSNumber*)time
{
    if ([owner isEqualToString:service.chatManager.currentAccount]) {
        owner = @"我";
    }
    else {
        owner = [CXIMHelper getUserByIMAccount:owner].name?[CXIMHelper getUserByIMAccount:owner].name:owner;
    }
    NSString* content = [NSString stringWithFormat:@"%@将群组名称修改为%@", owner, groupName];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

/**
 *  我邀请xxx加入群组
 *
 *  @param service   CXIMService对象
 *  @param members   成员列表
 *  @param groupName 群组名称
 *  @param groupId   群组id
 */
- (void)CXIMService:(CXIMService*)service didSelfInviteMembers:(NSArray<NSString*>*)members intoGroup:(NSString*)groupName groupId:(NSString*)groupId time:(NSNumber*)time
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] != nil){
        long timeSpace = (long)[[NSDate date] timeIntervalSince1970] - [[ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] longLongValue];
        if (timeSpace < 2) {
            NSMutableArray* names = [NSMutableArray array];
            for (NSDictionary* userDic in members) {
                [names addObject:[CXIMHelper getUserByIMAccount:userDic[@"userId"]].name?[CXIMHelper getUserByIMAccount:userDic[@"userId"]].name:userDic[@"userId"]];
            }
            NSString* nameStr = [names componentsJoinedByString:@","];
            NSString* content = [NSString stringWithFormat:@"我邀请%@加入群聊", nameStr];
            [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
            return;
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:groupId completion:^(CXGroupInfo *group, NSError *error) {
            if(!error){
                [[CXLoaclDataManager sharedInstance]updateLocalDataWithGroupId:group.groupId AndGroup:group];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]];
            }
        }];
    });
    
    
    NSMutableArray* names = [NSMutableArray array];
    for (NSDictionary* userDic in members) {
        [names addObject:[CXIMHelper getUserByIMAccount:userDic[@"userId"]].name?[CXIMHelper getUserByIMAccount:userDic[@"userId"]].name:userDic[@"userId"]];
    }
    NSString* nameStr = [names componentsJoinedByString:@","];
    NSString* content = [NSString stringWithFormat:@"我邀请%@加入群聊", nameStr];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

/**
 *  xxx邀请xxx加入群组
 *
 *  @param service   CXIMService对象
 *  @param inviter   邀请人
 *  @param members   成员列表
 *  @param groupName 群组名称
 *  @param groupId   群组id
 */
- (void)CXIMService:(CXIMService*)service didSomeone:(NSString*)inviter inviteMembers:(NSArray<NSString*>*)members intoGroup:(NSString*)groupName groupId:(NSString*)groupId time:(NSNumber*)time
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] != nil){
        long timeSpace = (long)[[NSDate date] timeIntervalSince1970] - [[ud objectForKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]] longLongValue];
        if (timeSpace < 2) {
            NSError *error;
            NSDictionary * inviterDic = [NSJSONSerialization JSONObjectWithData:[inviter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            if (error) {
                inviter = [CXIMHelper getUserByIMAccount:inviter].name?[CXIMHelper getUserByIMAccount:inviter].name:inviter;
            }
            else {
                inviter = inviterDic[@"name"];
            }
            NSMutableArray* names = [NSMutableArray array];
            if([members[0] isKindOfClass:[NSDictionary class]]){
                for(NSDictionary * dic in members){
                    [names addObject:dic[@"name"]];
                }
            }else{
                for(NSString * imAccount in members){
                    [names addObject:[CXIMHelper getUserByIMAccount:imAccount].name?[CXIMHelper getUserByIMAccount:imAccount].name:imAccount];
                }
            }
            NSString* nameStr = [names componentsJoinedByString:@","];
            //            NSString* content = [NSString stringWithFormat:@"%@邀请%@加入群组", inviter, nameStr];
            NSString* content = [NSString stringWithFormat:@"%@加入群聊", nameStr];
            [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
            return;
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[CXIMService sharedInstance].groupManager getGroupDetailInfoWithGroupId:groupId completion:^(CXGroupInfo *group, NSError *error) {
            if(!error){
                [[CXLoaclDataManager sharedInstance]updateLocalDataWithGroupId:group.groupId AndGroup:group];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:[NSString stringWithFormat:@"refreshGroup_%@",groupId]];
            }
        }];
    });
    
    
    NSError *error;
    NSDictionary * inviterDic = [NSJSONSerialization JSONObjectWithData:[inviter dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error) {
        inviter = [CXIMHelper getUserByIMAccount:inviter].name?[CXIMHelper getUserByIMAccount:inviter].name:inviter;
    }
    else {
        inviter = inviterDic[@"name"];
    }
    NSMutableArray* names = [NSMutableArray array];
    if([members[0] isKindOfClass:[NSDictionary class]]){
        for(NSDictionary * dic in members){
            [names addObject:dic[@"name"]];
        }
    }else{
        for(NSString * imAccount in members){
            [names addObject:[CXIMHelper getUserByIMAccount:imAccount].name?[CXIMHelper getUserByIMAccount:imAccount].name:imAccount];
        }
    }
    NSString* nameStr = [names componentsJoinedByString:@","];
    //            NSString* content = [NSString stringWithFormat:@"%@邀请%@加入群组", inviter, nameStr];
    NSString* content = [NSString stringWithFormat:@"%@加入群聊", nameStr];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

/**
 *  xxx退出群组
 *
 *  @param service   CXIMService对象
 *  @param members   成员
 *  @param groupName 群组名称
 *  @param groupId   群组id
 *  @param time      时间
 */
- (void)CXIMService:(CXIMService *)service didMembers:(NSArray<NSString *> *)members exitGroup:(NSString *)groupName groupId:(NSString *)groupId time:(NSNumber *)time {
    NSMutableArray* names = [NSMutableArray array];
    for (NSDictionary* user in members) {
        if([user isKindOfClass:[NSString class]]){
            [names addObject:[CXIMHelper getUserByIMAccount:((NSString *)user)].name?[CXIMHelper getUserByIMAccount:((NSString *)user)].name:(NSString *)user];
        }else{
            if(user[@"name"] == nil || [user[@"name"] length] <= 0){
                NSInteger loc = [user[@"userId"] rangeOfString:@"_"].location;
                NSString * name = [NSString stringWithFormat:@"%@",user[@"userId"]];
                if (loc != NSNotFound) {
                    name = [user[@"userId"] substringToIndex:loc];
                }
                [names addObject:name];
            }else{
                [names addObject:user[@"name"]];
            }
        }
    }
    NSString* nameStr = [names componentsJoinedByString:@","];
    NSString* content = [NSString stringWithFormat:@"%@退出群聊", nameStr];
    [self importNotiMessageWithReceiver:groupId receiverDisplayName:groupName Content:content time:time];
}

- (void)CXIMService:(CXIMService *)service didReceiveReadAsksOfChatter:(NSString *)chatter messages:(NSArray<CXIMMessage *> *)messages {
    int tmpMessageCount = 0;
    for (CXIMMessage *message in messages) {
        if ([message.ext[@"isBurnAfterRead"] isEqualToString:@"1"]) {
            tmpMessageCount++;
            [[CXIMService sharedInstance].chatManager removeMessageForId:message.ID];
        }
    }
    if (tmpMessageCount) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CXIM_RefetchMessages_Notification object:nil];
    }
}

- (BOOL)importNotiMessageWithReceiver:(NSString*)receiver receiverDisplayName:(NSString*)receiverDisplayName Content:(NSString*)content time:(NSNumber*)time
{
    CXIMMessage* noti = [[CXIMMessage alloc] initWithChatter:receiver body:[CXIMSystemNotifyMessageBody bodyWithNotifyConetnt:content]];
    noti.type = CXIMMessageTypeGroupChat;
    noti.sender = @"sys";
    noti.status = CXIMMessageStatusSendSuccess;
    noti.readFlag = CXIMMessageReadFlagUnRead;
    noti.sendTime = time;
    BOOL s = [[CXIMService sharedInstance].chatManager saveMessageToDB:noti];
    if (s) {
        // 拿私有变量手动调用代理方法。。
        NSArray<id<CXIMChatDelegate> >* delegates = [[CXIMService sharedInstance].chatManager valueForKey:@"delegates"];
        NSArray * delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<CXIMChatDelegate> delegate in delegatesCopy) {
            if ([delegate respondsToSelector:@selector(CXIMService:didReceiveChatMessage:)]) {
                [delegate CXIMService:[CXIMService sharedInstance] didReceiveChatMessage:noti];
            }
        }
    }
    return s;
}

@end
