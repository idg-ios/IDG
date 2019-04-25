//
//  MailUtils.m
//  StoryClient
//
//  Created by mengxianzhi on 15-1-9.
//  Copyright (c) 2015年 LiuQi. All rights reserved.
//

#import "STMailUtils.h"

#define SYSTEM_VERSION ([[UIDevice currentDevice].systemVersion floatValue])

@implementation STMailUtils

+ (instancetype)shareInstance
{
    static STMailUtils *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (CGFloat)widthForText:(NSString *)text maxWidth:(CGFloat)maxWidth fontOfSize:(CGFloat)fontOfSize
{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (SYSTEM_VERSION >= 7.0) {
        //设置计算文本时字体的大小
        
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontOfSize]};
        
        return [text boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.width;
        
    }else{
        CGSize size = CGSizeMake(maxWidth, 1000);
        return [text sizeWithFont:[UIFont systemFontOfSize:fontOfSize] constrainedToSize:size].width;
    }
#endif
    
    
}

+ (CGFloat)heightForText:(NSString *)text maxHigh:(CGFloat)maxHigh fontOfSize:(CGFloat)fontOfSize
{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (SYSTEM_VERSION >= 7.0) {
        //设置计算文本时字体的大小
        
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]};
        
        return [text boundingRectWithSize:CGSizeMake(maxHigh, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
        
    }else{
        CGSize size = CGSizeMake(maxHigh, 1000);
        return [text sizeWithFont:[UIFont systemFontOfSize:fontOfSize] constrainedToSize:size].height;
    }
#endif
    
    
}


+ (CGSize)boundingRectWithSize:(CGSize)size stringStr:(NSString *)stringStr fondSize:(CGFloat)fontOfSize
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]};
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if (SYSTEM_VERSION >= 7.0) {
        CGSize retSize = [stringStr boundingRectWithSize:size
                                                 options:\
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
        
        return retSize;
    }else{
        return [stringStr sizeWithFont:[UIFont systemFontOfSize:fontOfSize] constrainedToSize:size];
    }
#endif
}

///// 1
+ (NSMutableString *)getMailHead{
    NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"<br><br/><div style=\"font-size:12px;padding:2px 0;\">------------------&nbsp;原始邮件&nbsp;------------------</div><div style=\"font-size:12px;background:#f0f0f0;color:#212121;padding:8px!important;border-radius:4px;line-height:1.5;\"><div><b>发件人:</b>"]];
    return  mutab;
}
///// 2
+ (NSMutableString *)getSendMan:(NSString *)title mailSub:(NSString *)mailSub{
    NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@&lt;%@&gt;</div><div><b>",title,mailSub]];
    return  mutab;
}
///// 3
+ (NSMutableString *)getSendTime:(NSString *)timeStr{
    NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"发送时间:</b> %@ </div><div><b>",timeStr]];
    return  mutab;
    
}
///// 4
+ (NSMutableString *)getToMan:(NSString *)title mailNo:(NSString *)mailNo isHaveSendName:(BOOL)flg{
    if (flg) {
        NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"收件人:</b> %@&lt;%@><br/>",title,mailNo]];
        return  mutab;
    }else{
        NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@&lt;%@><br/>",title,mailNo]];
        return  mutab;
    }
}
///// 5
+ (NSMutableString *)getCCMan:(NSString *)title mailNo:(NSString *)mailNo isHaveSendMan:(BOOL)flg{
    if (flg) {
        NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"<b>抄送:</b> %@&lt;%@&gt<br/>",title,mailNo]];
        return  mutab;
    }else{
        NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@&lt;%@&gt<br/>",title,mailNo]];
        return  mutab;
    }
}
///// 6
+(NSMutableString *)getMailTheme:(NSString *)theme{
    NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"</div><div><b>主题:</b>%@</div></div><br/>",theme]];
    return  mutab;
}
///// 7
+(NSMutableString *)getHtml{
    NSMutableString *mutab = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"<html</div></body></html>"]];
    return  mutab;
}

//邮箱是否合法
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
