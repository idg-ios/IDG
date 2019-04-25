//
//  CXIMHelper.m
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXIMHelper.h"
#import "SDDataBaseHelper.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMLib.h"
#import "CXLoaclDataManager.h"

//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

@implementation CXIMHelper

+ (CXGroupMember *)getGroupMemberByIMAcocount:(NSString *)imAccount
{
    CXGroupMember * member = [[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:imAccount];
    return member;
}

+ (NSArray<CXGroupMember *> *)getGroupMembersByIMAcocountArray:(NSArray<NSString *> *)imAccountArray
{
    NSMutableArray * groupMembers = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSString * imAccount in imAccountArray){
        CXGroupMember * member = [[CXLoaclDataManager sharedInstance] getGroupUserFromLocalContactsDicWithIMAccount:imAccount];
        [groupMembers addObject:member];
    }
    return groupMembers;
}

+ (SDCompanyUserModel*)getUserByUserId:(NSInteger)userId
{
    return [[SDDataBaseHelper shareDB] getUser:userId];
}

+ (SDCompanyUserModel*)getUserByIMAccount:(NSString*)account
{
    SDCompanyUserModel * userModel = [[CXLoaclDataManager sharedInstance]getUserFromLocalFriendsDicWithIMAccount:account];
    return userModel;
    //    SDCompanyUserModel * userModel = [[SDCompanyUserModel alloc] init];
    //    userModel = [[SDDataBaseHelper shareDB] getUserByhxAccount:account];
    //    if(userModel.userId){
    //        if(userModel.name != nil){
    //            userModel.realName = userModel.name;
    //        }
    //        else if(userModel.realName != nil){
    //            userModel.name = userModel.realName;
    //        }
    //        if(userModel.name == nil || (userModel.name != nil && [userModel.name length] <= 0)){
    //            userModel.name = account;
    //            userModel.realName = account;
    //        }
    //        return userModel;
    //    }else{
    //        userModel.imAccount = account;
    //        userModel.hxAccount = account;
    //        userModel.name = account;
    //        userModel.realName = account;
    //        userModel.icon = @"";
    //        return userModel;
    //    }
    //    else{
    //        NSArray * groups = [[CXIMService sharedInstance].groupManager loadGroupsFromDB];
    //        for(CXGroupInfo * group in groups){
    //            if([group.ownerDetail.userId isEqualToString:account]){
    //                userModel.imAccount = group.ownerDetail.userId;
    //                userModel.hxAccount = group.ownerDetail.userId;
    //                userModel.name = (group.ownerDetail.name==nil||[group.ownerDetail.name length]<=0)?group.ownerDetail.userId:group.ownerDetail.name;
    //                userModel.realName = (group.ownerDetail.name==nil||[group.ownerDetail.name length]<=0)?group.ownerDetail.userId:group.ownerDetail.name;
    //                userModel.icon = group.ownerDetail.icon;
    //
    //                if(userModel.name != nil){
    //                    userModel.realName = userModel.name;
    //                }
    //                else if(userModel.realName != nil){
    //                    userModel.name = userModel.realName;
    //                }
    //                if(userModel.name == nil || (userModel.name != nil && [userModel.name length] <= 0)){
    //                    userModel.name = account;
    //                    userModel.realName = account;
    //                }
    //
    //                return userModel;
    //            }
    //            for(CXGroupMember * member in group.members){
    //                if([member.userId isEqualToString:account]){
    //                    userModel.imAccount = member.userId;
    //                    userModel.hxAccount = member.userId;
    //                    userModel.icon = member.icon;
    //                    if(userModel.name != nil){
    //                        userModel.realName = userModel.name;
    //                    }
    //                    else if(userModel.realName != nil){
    //                        userModel.name = userModel.realName;
    //                    }
    //                    if(userModel.name == nil || (userModel.name != nil && [userModel.name length] <= 0)){
    //                        userModel.name = account;
    //                        userModel.realName = account;
    //                    }
    //                    return userModel;
    //                }
    //            }
    //        }
    //
    //        if(userModel.imAccount == nil){
    //            userModel.imAccount = account;
    //            userModel.hxAccount = account;
    //            userModel.name = account;
    //            userModel.realName = account;
    //            userModel.icon = @"";
    //            return userModel;
    //        }
    //        //搜索人
    //        NSString * path = [NSString stringWithFormat:@"%@friend/s/%@.json",urlPrefix,account];
    //        NSURL *url = [NSURL URLWithString:path];
    //        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //        //添加header
    //        NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    //        [mutableRequest addValue:[NSString stringWithFormat:@"%@", VAL_token] forHTTPHeaderField:@"token"];
    //        request = [mutableRequest copy];
    //        NSURLResponse *res;
    //        NSError *err;
    //        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:(&res) error:&err];
    //        NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSData* JSONData = [s dataUsingEncoding:NSUTF8StringEncoding];
    //        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    //        if([dic[@"status"] integerValue] == 200){
    //            if(dic[@"data"] && [dic[@"data"] count] > 0){
    //                userModel.imAccount = dic[@"data"][0][@"imAccount"];
    //                userModel.hxAccount = dic[@"data"][0][@"imAccount"];
    //                userModel.name = (dic[@"data"][0][@"name"]==nil||[dic[@"data"][0][@"name"] length]<=0)?dic[@"data"][0][@"imAccount"]:dic[@"data"][0][@"name"];
    //                userModel.realName = (dic[@"data"][0][@"name"]==nil||[dic[@"data"][0][@"name"] length]<=0)?dic[@"data"][0][@"imAccount"]:dic[@"data"][0][@"name"];
    //                userModel.icon = dic[@"data"][0][@"icon"];
    //            }
    //        }
    //        return userModel;
    
    //    }
    //    return userModel;
}



+ (NSString*)getRealNameByAccount:(NSString*)account
{
    return ([self getUserByIMAccount:account].name==nil||[[self getUserByIMAccount:account].name length]<=0)?[self getUserByIMAccount:account].imAccount:[self getUserByIMAccount:account].name;
}

+ (NSString*)getUserAvatarUrlByIMAccount:(NSString*)account
{
    SDCompanyUserModel* userModel = [self getUserByIMAccount:account];
    return [NSString stringWithFormat:@"%@", (userModel.icon && ![userModel.icon isKindOfClass:[NSNull class]] && userModel.icon.length >0) ? userModel.icon : @""];
}

+ (UIImage*)getImageFromGroup:(CXGroupInfo*)aGroup
{
    if ([aGroup.members count] > 0) {
        NSMutableArray* urlArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (CXGroupMember* member in aGroup.members) {
            if ([member.icon length]) {
                [urlArr addObject:member.icon];
            }else{
                [urlArr addObject:@""];
            }
        }
        [urlArr insertObject:aGroup.ownerDetail.icon?aGroup.ownerDetail.icon:@"" atIndex:0];
        
        return [self createImageFromUrl:urlArr];
    }
    
    return [UIImage imageNamed:@"groupPublicHeader"];
}

+ (UIImage*)getImageFromVoiceMeetingIconString:(NSString*)iconString AndMeetingMemberCount:(NSInteger)count
{
    SDCompanyUserModel * myselfUserModel = [[CXLoaclDataManager sharedInstance] getUserFromLocalFriendsDicWithIMAccount:VAL_HXACCOUNT];
    NSMutableArray* urlArr = [[NSMutableArray alloc] initWithCapacity:0];
    if([iconString isKindOfClass:[NSNull class]]){
        [urlArr insertObject:myselfUserModel.icon&&![myselfUserModel.icon isKindOfClass:[NSNull class]]?myselfUserModel.icon:@"http://zschun.blob.core.chinacloudapi.cn/erp/bc3758c8f8b34e209b09059a5fdb9c7d.jpg" atIndex:0];
        for(NSInteger i = 0;i<count - 1;i++){
            [urlArr addObject:@"http://zschun.blob.core.chinacloudapi.cn/erp/bc3758c8f8b34e209b09059a5fdb9c7d.jpg"];
        }
        return [self createImageFromUrl:urlArr];
    }
    if(iconString && [iconString length] > 0){
        NSArray * iconArray = [iconString componentsSeparatedByString:@","];
        for(NSString * icon in iconArray){
            if ([icon length]) {
                [urlArr addObject:icon];
            }else{
                [urlArr addObject:@"http://zschun.blob.core.chinacloudapi.cn/erp/bc3758c8f8b34e209b09059a5fdb9c7d.jpg"];
            }
        }
    }
    if([urlArr count] < count){
        for(NSInteger i = 0;i<count - [urlArr count];i++){
            [urlArr addObject:@"http://zschun.blob.core.chinacloudapi.cn/erp/bc3758c8f8b34e209b09059a5fdb9c7d.jpg"];
        }
    }
    return [self createImageFromUrl:urlArr];
}

// 创建头像
+ (UIImage*)createImageFromUrl:(NSArray*)urlArr
{
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    headView.layer.borderWidth = 1.0f;
    
    if ([urlArr count] > 9) {
        urlArr = [urlArr subarrayWithRange:NSMakeRange(0, 9)];
    }
    
    UIImage* defaultImage = [UIImage imageNamed:@"temp_user_head"];
    
    float jg = 2.0f; // 顶部和底部的间隔.2个头像之间的间隔.左右间隔.
    
    EMSDWebImageOptions imageOptions = EMSDWebImageRetryFailed;
    
    switch ([urlArr count]) {
            
        case 2: {
            // 2人聊天
            float ht = (50 - 3 * jg) / 2.0f;
            float wd = ht;
            
            UIImageView* imageView_1 = [[UIImageView alloc] initWithImage:defaultImage];
            imageView_1.frame = CGRectMake(jg, 14, wd, ht);
            [imageView_1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[0]]] placeholderImage:defaultImage options:imageOptions];
            [headView addSubview:imageView_1];
            
            UIImageView* imageView_2 = [[UIImageView alloc] initWithImage:defaultImage];
            imageView_2.frame = CGRectMake(ht + 2 * jg, 14, wd, ht);
            [imageView_2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[1]]] placeholderImage:defaultImage options:imageOptions];
            [headView addSubview:imageView_2];
        } break;
            
        case 3: {
            // 3人聊天
            float ht = (50 - 3 * jg) / 2.0f;
            float wd = ht;
            
            UIImageView* imageView_1 = [[UIImageView alloc] initWithImage:defaultImage];
            imageView_1.frame = CGRectMake(15, jg, wd, ht);
            [imageView_1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[0]]] placeholderImage:defaultImage options:imageOptions];
            [headView addSubview:imageView_1];
            
            UIImageView* imageView_2 = [[UIImageView alloc] initWithImage:defaultImage];
            imageView_2.frame = CGRectMake(jg, CGRectGetMaxY(imageView_1.frame) + jg, wd, ht);
            [imageView_2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[1]]] placeholderImage:defaultImage options:imageOptions];
            [headView addSubview:imageView_2];
            
            UIImageView* imageView_3 = [[UIImageView alloc] initWithImage:defaultImage];
            imageView_3.frame = CGRectMake(CGRectGetMaxX(imageView_2.frame) + jg, CGRectGetMaxY(imageView_1.frame) + jg, wd, ht);
            [imageView_3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[2]]] placeholderImage:defaultImage options:imageOptions];
            [headView addSubview:imageView_3];
            
        } break;
        case 4: {
            // 4人聊天
            float ht = (50 - 3 * jg) / 2.0f;
            float wd = ht;
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                if (i < 2) {
                    imageView.frame = CGRectMake(jg * (i + 1) + i * wd, jg, wd, ht);
                }
                else {
                    imageView.frame = CGRectMake(jg * ((i - 2) + 1) + (i - 2) * wd, wd + 2 * jg, wd, ht);
                }
            }
        } break;
        case 5: {
            float ht = (50 - 4 * jg) / 3.0f;
            float wd = ht;
            
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                if (i == 0) {
                    imageView.frame = CGRectMake(10, 10, wd, ht);
                }
                else if (i == 1) {
                    float x = 10 + wd + jg;
                    imageView.frame = CGRectMake(x, 10, wd, ht);
                }
                else if (i > 1) {
                    float y = 10 + ht + jg;
                    imageView.frame = CGRectMake(jg * ((i - 2) + 1) + (i - 2) * wd, y, wd, ht);
                }
            }
        } break;
        case 6: {
            float ht = (50 - 4 * jg) / 3.0f;
            float wd = ht;
            float x = 0, y = 0;
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                
                if (i < 3) {
                    x = jg * (i + 1) + i * wd;
                    y = 10;
                }
                else {
                    x = jg * ((i % 3) + 1) + (i % 3) * wd;
                    y = 10 + ht + jg;
                }
                imageView.frame = CGRectMake(x, y, wd, ht);
            }
        } break;
        case 7: {
            float ht = (50 - 4 * jg) / 3.0f;
            float wd = ht;
            float x = 0, y = 0;
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                if (i == 0) {
                    x = jg + wd + jg;
                    y = jg;
                }
                else if (i > 0 && i < 4) {
                    x = jg * (((i + 2) % 3) + 1) + ((i + 2) % 3) * wd;
                    y = jg + ht + jg;
                }
                else {
                    x = jg * (((i + 2) % 3) + 1) + ((i + 2) % 3) * wd;
                    y = jg + ht + jg + ht + jg;
                }
                imageView.frame = CGRectMake(x, y, wd, ht);
            }
        } break;
        case 8: {
            float ht = (50 - 4 * jg) / 3.0f;
            float wd = ht;
            float x = 0, y = 0;
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                if (i < 2) {
                    if (i == 0) {
                        x = 10;
                        y = jg;
                    }
                    else {
                        x = 10 + wd + jg;
                        y = jg;
                    }
                }
                else if (i >= 2 && i <= 4) {
                    x = jg * (((i + 1) % 3) + 1) + ((i + 1) % 3) * wd;
                    y = jg + ht + jg;
                }
                else {
                    x = jg * (((i + 1) % 3) + 1) + ((i + 1) % 3) * wd;
                    y = jg + ht + jg + ht + jg;
                }
                imageView.frame = CGRectMake(x, y, wd, ht);
            }
        } break;
        case 9: {
            float ht = (50 - 4 * jg) / 3.0f;
            float wd = ht;
            float x = 0, y = 0;
            for (int i = 0; i < [urlArr count]; i++) {
                UIImageView* imageView = [[UIImageView alloc] initWithImage:defaultImage];
                [headView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlArr[i]]] placeholderImage:defaultImage options:imageOptions];
                
                if (i < 3) {
                    x = jg * (i + 1) + i * wd;
                    y = jg;
                }
                else if (i >= 3 && i < 6) {
                    x = jg * ((i % 3) + 1) + (i % 3) * wd;
                    y = jg + ht + jg;
                }
                else if (i >= 6) {
                    x = jg * ((i % 3) + 1) + (i % 3) * wd;
                    y = jg + ht + jg + ht + jg;
                }
                imageView.frame = CGRectMake(x, y, wd, ht);
            }
        } break;
    }
    
    return [headView.subviews count] > 0 ? [self snapshot:headView] : nil;
}

// 截取图片
+ (UIImage*)snapshot:(UIView*)view
{
    CGRect rect = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    view.layer.cornerRadius = CornerRadius;
    [view.layer renderInContext:context];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSArray<SDCompanyUserModel*>*)userIdArrayToModelArray:(NSArray<NSNumber*>*)userIdArray
{
    NSMutableArray<SDCompanyUserModel*>* userModels = [NSMutableArray array];
    for (NSNumber* userId in userIdArray) {
        SDCompanyUserModel* user = [[SDDataBaseHelper shareDB] getUserByUserID:userId.stringValue];
        if (!user.userId) {
            continue;
        }
        [userModels addObject:user];
    }
    return [userModels copy];
}

+ (NSArray<SDCompanyUserModel*>*)imAccountArrayToModelArray:(NSArray<NSString*>*)imAccountArray
{
    NSMutableArray<SDCompanyUserModel*>* userModels = [NSMutableArray array];
    for (NSString* imAccount in imAccountArray) {
        SDCompanyUserModel* user = [CXIMHelper getUserByIMAccount:imAccount];
        [userModels addObject:user];
    }
    return [userModels copy];
}

+ (UIImage*)getGroupHeadImageFromConversation:(CXIMConversation*)conversation
{
    NSArray* localGroups = [[CXIMService sharedInstance].groupManager loadGroupsFromDB];
    for (CXGroupInfo* aGroup in localGroups) {
        if ([aGroup.groupId isEqualToString:conversation.chatter]) {
            UIImage* groupHeadImage = [CXIMHelper getImageFromGroup:aGroup];
            return groupHeadImage;
        }
    }
    return nil;
}

+ (NSString*)getUserAvatarUrlByIMMessage:(CXIMMessage*)message
{
    NSString* headUrl;
    if ([message.receiver isEqualToString:VAL_HXACCOUNT]) {
        headUrl = [CXIMHelper getUserAvatarUrlByIMAccount:message.sender];
    }
    else {
        headUrl = [CXIMHelper getUserAvatarUrlByIMAccount:message.receiver];
    }
    return headUrl;
}

+ (UIImage*)getGroupHeadImageFromMessage:(CXIMMessage*)message
{
    NSArray* localGroups = [[CXIMService sharedInstance].groupManager loadGroupsFromDB];
    for (CXGroupInfo* aGroup in localGroups) {
        if ([aGroup.groupId isEqualToString:message.receiver]) {
            UIImage* groupHeadImage = [CXIMHelper getImageFromGroup:aGroup];
            return groupHeadImage;
        }
    }
    return nil;
}

+ (BOOL)isSystemGroup:(NSString *)groupId {
    CXGroupInfo *group = [[CXIMService sharedInstance].groupManager loadGroupForId:groupId];
    if (group) {
        NSString *owner = group.owner;
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[owner dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (!error && [dict isKindOfClass:NSDictionary.class]) {
            owner = dict[@"account"] ?: dict[@"userId"] ?: dict[@"imAccount"];
        }
        if ([owner hasPrefix:@"1000000"]) {
            return YES;
        }
    }
    return NO;
}

@end
