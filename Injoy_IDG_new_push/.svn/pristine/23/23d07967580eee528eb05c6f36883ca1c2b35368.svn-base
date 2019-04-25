//
//  NSString+TextHelper.m
//  SDMarketingManagement
//
//  Created by Mac on 15-4-28.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "NSString+TextHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TextHelper)

+ (NSString *)digitUppercaseWithMoney:(NSString *)money {
    NSMutableString *moneyStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f", [money doubleValue]]];
    NSArray *MyScale = @[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟"];
    NSArray *MyBase = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];

    NSArray *integerArray = @[@"拾", @"佰", @"仟", @"万", @"拾万", @"佰万", @"仟万", @"亿", @"拾亿", @"佰亿", @"仟亿", @"兆", @"拾兆", @"佰兆", @"仟兆"];


    NSMutableString *M = [[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    for (NSInteger i = moneyStr.length; i > 0; i--) {
        NSInteger MyData = [[moneyStr substringWithRange:NSMakeRange(moneyStr.length - i, 1)] integerValue];
        [M appendString:MyBase[MyData]];

        //判断是否是整数金额
        if (i == moneyStr.length) {
            NSInteger l = [[moneyStr substringFromIndex:1] integerValue];
            if (MyData > 0 &&
                    l == 0) {
                NSString *integerString = @"";
                if (moneyStr.length > 3) {
                    integerString = integerArray[moneyStr.length - 4];
                }
                [M appendString:[NSString stringWithFormat:@"%@%@", integerString, @""]];
                break;
            }
        }

        if ([[moneyStr substringFromIndex:moneyStr.length - i + 1] integerValue] == 0
                && i != 1
                && i != 2) {
            [M appendString:@"元整"];
            break;
        }
        [M appendString:MyScale[i - 1]];
    }
    return M;
}

+ (NSAttributedString *)getAttributedText:(NSString *)textVal {
    return [self attributedString:textVal withRange:NSMakeRange(0, 1) withFontSize:15.f withColor:[UIColor redColor]];
}

+ (NSAttributedString *)getAttributedTitle:(NSString *)titleVal content:(NSString *)contentVal {
    NSAttributedString *titleAttr = [[NSAttributedString alloc] initWithString:titleVal attributes:@{NSFontAttributeName: kFontSizeForDetail}];
    NSAttributedString *contentAttr = [[NSAttributedString alloc] initWithString:contentVal attributes:@{NSFontAttributeName: kFontSizeForForm}];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:titleAttr];
    [attrText appendAttributedString:contentAttr];
    [attrText setAttributes:@{
                    NSForegroundColorAttributeName: [UIColor redColor],
                    NSFontAttributeName: [UIFont fontWithName:@"Arial" size:15.f]}
                      range:NSMakeRange(0, 1)];
    return attrText;
}

- (CGFloat)getWidthExt:(UIFont *)font {
    CGFloat wd = [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    return ceil(wd);
}

- (CGFloat)getHeightExt:(UIFont *)font {
    CGFloat ht = [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    return ceil(ht);
}

- (CGFloat)getHeightExt {
    CGFloat ht = [self sizeWithFont:kFontSizeForForm maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    return ceil(ht);
}

- (CGFloat)getWidth {
    CGFloat wd = [self sizeWithFont:kFontSizeForDetail maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    return ceil(wd);
}

/// 返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName: font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap]; //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

//md5加密
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (BOOL)checkPwd:(NSString *)pwd {
    if (pwd.length >= 6 && pwd.length < 20)
        return YES;
    return NO;
}

- (BOOL)checkAccoutn:(NSString *)str {
    NSString *emailRegex = @"^[a-zA-Z0-9_]+$";
    NSPredicate *account = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [account evaluateWithObject:str];
}

+ (BOOL)checkIsNumber:(NSString *)str {
    NSString *emailRegex = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

- (BOOL)checkEmail:(NSString *)str {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

+ (BOOL)isEmail:(NSString *)mailStr; {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mailStr];
}

+ (BOOL)isChineseCharactersJudge:(NSString *)inputContent {
    NSString *regexStr = @"[\u4e00-\u9fa5]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];

    return [predicate evaluateWithObject:inputContent];
}

- (BOOL)checkMobilePhone:(NSString *)mobileNum {
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(154)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(154)|(15[5-6])|(176)|(170)|(171)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(154)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];

    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkWechat:(NSString *)Wechat {
    NSString *weixin = @"^[a-zA-Z]{1}[-_a-zA-Z0-9]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", weixin];
    BOOL isMatch = [pred evaluateWithObject:Wechat];
    if (isMatch) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkFax:(NSString *)fax {
    NSString *chuanzhen = @"^[+]{0,1}(\\d){1,3}[ ]?([-]?((\\d)|[ ]){1,12})+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chuanzhen];
    BOOL isMatch = [pred evaluateWithObject:fax];
    if (isMatch) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkYB:(NSString *)yb {
    NSString *yob = @"^[1-9]\\d{5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", yob];
    BOOL isMatch = [pred evaluateWithObject:yb];
    if (isMatch) {
        return YES;
    } else {
        return NO;
    }

}


- (BOOL)isWebsite:(NSString *)weisite {
    //    "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-"
    //    + "Z0-9\\.&%\\$\\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{"
    //    + "2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}"
    //    + "[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|"
    //    + "[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-"
    //    + "4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0"
    //    + "-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.[a-zA-Z]{2,4})(\\:[0-9]+)?(/"
    //    + "[^/][a-zA-Z0-9\\.\\,\\?\\'\\\\/\\+&%\\$\\=~_\\-@]*)*$";
    //    NSString *firstString = @"^(http|https)://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$";
    //    NSString *secondString = @"^[a-zA-Z]:(\\[0-9a-zA-Z\u4e00-\u9fa5]*)$";
    NSString *thirdString = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    //    NSPredicate* Pre1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", firstString];
    //    BOOL isFirst1 = [Pre1 evaluateWithObject: weisite];
    //    NSPredicate* Pre2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", secondString];
    //    BOOL isFirst2 = [Pre2 evaluateWithObject: weisite];
    NSPredicate *Pre3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", thirdString];
    BOOL isFirst3 = [Pre3 evaluateWithObject:weisite];

    if (isFirst3) {
        return YES;
    } else {
        return NO;
    }
    return NO;
}

- (BOOL)checkPhone:(NSString *)phoneNum {
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString *PHS = @"([0-9]{3,4}-?)?[0-9]{7,8}";
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    if (([regextestPHS evaluateWithObject:phoneNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

//- (BOOL)isWebsite:(NSString *)weisite
//{
//    NSString *websiteString = @"([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
//    NSPredicate *websitePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",websiteString];
//    return [websitePre evaluateWithObject:weisite];
//}
//匹配QQ
- (BOOL)validateQQNum:(NSString *)qqNum {
    NSString *qqNumRegex = @"[1-9][0-9]{4,}";
    NSPredicate *qqNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqNumRegex];
    return [qqNumTest evaluateWithObject:qqNum];
}

//匹配邮编
- (BOOL)isCodeNumber:(NSString *)codeNum {
    NSString *codeRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    return [codeTest evaluateWithObject:codeNum];
}

+ (BOOL)hasTheRightToVisit:(NSString *)code {
    NSInteger menuCompanyLevel = 0;
    NSString *isIn = @"no";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger companyLevel = [[userDefaults valueForKey:KCompanylevel] integerValue];
    NSArray *menuList = [userDefaults valueForKey:KMenuList];
    for (NSDictionary *dict in menuList) {
        if ([[dict valueForKey:@"code"] isEqualToString:code]) {
            isIn = [dict valueForKey:@"isIn"];
            menuCompanyLevel = [[dict valueForKey:@"companyLevel"] integerValue];
            break;
        }
    }
    if (menuCompanyLevel <= companyLevel && [isIn isEqualToString:@"yes"]) {
        return YES;
    } else {
        //return YES;
        TTAlert(@"您没有权限使用该功能");
        return NO;
    }
}

+ (BOOL)hasTheRightToShow:(NSString *)code {
    NSInteger menuCompanyLevel = 0;
    NSString *isIn = @"no";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger companyLevel = [[userDefaults valueForKey:KCompanylevel] integerValue];
    NSArray *menuList = [userDefaults valueForKey:KMenuList];
    for (NSDictionary *dict in menuList) {
        if ([[dict valueForKey:@"code"] isEqualToString:code]) {
            isIn = [dict valueForKey:@"isIn"];
            menuCompanyLevel = [[dict valueForKey:@"companyLevel"] integerValue];
            break;
        }
    }
    if (menuCompanyLevel <= companyLevel && [isIn isEqualToString:@"yes"]) {
        return YES;
    } else {
        //return YES;
        return NO;
    }
}

+ (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSMutableString *currentTime = [NSMutableString string];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date year]]]];
    [currentTime appendString:@"-"];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date month]]]];
    [currentTime appendString:@"-"];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date day]]]];
    [currentTime appendString:@""];
    [currentTime appendString:@" "];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date hour]]]];
    [currentTime appendString:@":"];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date minute]]]];
    [currentTime appendString:@":"];
    [currentTime appendString:[NSString stringWithFormat:@"%@", [currentTime calNum:[date seconds]]]];
    return currentTime;
}

+ (NSString *)compareTime:(NSString *)time {
    if (![time length])
        return @"";

    NSDate *now = [NSDate date];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *myDate = [df dateFromString:time];

    NSTimeInterval timeBetween = [now timeIntervalSinceDate:myDate];

    ///两分钟内发的
    if (timeBetween / 60 <= 2) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    //一个小时内显示多少分钟
    if (timeBetween / 3600 <= 1) {
        return [NSString stringWithFormat:@"%.0f分钟前", timeBetween / 60];
    }
    ///24小时内显示多少个小时
    if (timeBetween / 3600 <= 24) {
        return [NSString stringWithFormat:@"%.0f小时前", timeBetween / 3600];
    }
    //时间超过一个星期直接显示年月日
    if (timeBetween / 86400 > 7) {
        return [time substringToIndex:strlen("yyyy-MM-dd")];
    }
    //时间超过1天且小于一个月显示多少天
    if (timeBetween / 86400 > 1) {
        return [NSString stringWithFormat:@"%.0f天前", timeBetween / 86400];
    }

    return time;
}

- (NSString *)calNum:(long)time {
    if (time < 10)
        return [NSString stringWithFormat:@"0%ld", time];
    return [NSString stringWithFormat:@"%ld", time];
}

+ (NSString *)getUserName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userName"];
}

#pragma mark 是否包含了某个字符串

+ (BOOL)containWithSelectedStr:(NSString *)selectedString contain:(NSString *)containStr {
    if (!selectedString.length) {
        return NO;
    }

    NSMutableString *mutableStr = [NSMutableString string];
    for (NSInteger i = 0; i < selectedString.length; i++) {

        if (mutableStr.length) {
            [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
        }
        for (NSInteger j = i; j < selectedString.length; j++) {

            NSString *str = [selectedString substringWithRange:NSMakeRange(j, 1)];
            [mutableStr appendString:str];

            if ([mutableStr isEqualToString:containStr]) {
                return YES;
            }
        }
    }

    return NO;
}

#pragma mark 是否全部都是空格

+ (BOOL)containBlankSpaceWithSelectedStr:(NSString *)selectedString {
    if (!selectedString.length) {
        return NO;
    }
    for (NSInteger i = 0; i < selectedString.length; i++) {
        NSString *str = [selectedString substringWithRange:NSMakeRange(i, 1)];
        if (![str isEqualToString:@" "]) {
            return NO;
        }
    }

    return YES;
}

#pragma mark 时间格式转换

+ (NSString *)changeTimeDataByTimeStr:(NSString *)timeStr {
    if (!timeStr.length) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentData = [dateFormatter dateFromString:timeStr];

    CFTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:currentData];

    if (timeInterval < 60.f) {
        return [NSString stringWithFormat:@"%ld秒前", (long) timeInterval];
    } else if (timeInterval < 60 * 60.f) {
        return [NSString stringWithFormat:@"%ld分钟前", (long) (timeInterval / 60.f)];
    } else if (timeInterval < 60 * 60 * 24.f) {
        return [NSString stringWithFormat:@"%ld小时前", (long) (timeInterval / 3600.f)];
    } else if (timeInterval < 60 * 60 * 24 * 7.f) {
        return [NSString stringWithFormat:@"%ld天前", (long) (timeInterval / (3600.f * 24))];
    } else {
        return timeStr;
    }
}

+ (NSString *)getLocalDateFormateUTCDateString:(NSString *)utcDateString; {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];

    NSDate *dateFormatted = [dateFormatter dateFromString:utcDateString];
    return [NSString stringWithFormat:@"%@", dateFormatted];
}

+ (NSString *)getLocalDateFormateUTCDate:(NSDate *)utcDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];

    NSString *dateFormatted = [dateFormatter stringFromDate:utcDate];
    return dateFormatted;
}

#pragma mark unicode 转汉字

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {

    if (!unicodeStr.length) {
        return nil;
    }

    NSString *tempStr2 = [unicodeStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];

    [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    return [returnStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

//获取系统当前时间的年月日
+ (NSString *)getCurrentTimeYearMonthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 *  隐藏指定范围的字符串
 *
 *  @param title    原来的字符串
 *  @param range    范围
 *  @param fontSize 字号
 *
 *  @return 富文本
 */
+ (NSAttributedString *)hideString:(NSString *)title withRange:(NSRange)range withFontSize:(CGFloat)fontSize {

    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor],
                    NSFontAttributeName: [UIFont fontWithName:@"Arial" size:fontSize]}
                          range:range];
    return attributeStr;
}

/**
 *  指定范围的字符串富文本
 *
 *  @param title    原来的字符串
 *  @param range    范围
 *  @param fontSize 字号
 *  @param color    颜色
 *
 *  @return 富文本
 */
+ (NSAttributedString *)attributedString:(NSString *)title withRange:(NSRange)range withFontSize:(CGFloat)fontSize withColor:(UIColor *)color {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributeStr setAttributes:@{NSForegroundColorAttributeName: color,
                    NSFontAttributeName: [UIFont fontWithName:@"Arial" size:fontSize]}
                          range:range];
    return attributeStr;
}

+ (NSString *)substring:(NSString *)str ToIndex:(int)index {
    // 判断是否含有中文
    BOOL hasChinese = NO;
    NSUInteger length = [str length];
    for (int i = 0; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            hasChinese = YES;
            break;
        }
    }

    NSString *titleStr;
    if (!hasChinese) {
        // 如果没有中文 下标＊2
        index = index + 3;
    }
    if ([str length] > index) {
        titleStr = [str substringToIndex:index]; //截取掉下标之后的字符串
        titleStr = [NSString stringWithFormat:@"%@...", titleStr];
    } else {
        titleStr = str;
    }
    return titleStr;
}

#pragma mark-- 获取当前时间

+ (NSString *)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

/** 获取中文的--年--月 */
+ (NSString *)getChineseYearMonthDate; {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/** 获取中文的--年 */
+ (NSString *)getChineseYearDate; {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

+ (NSString *)textWithText:(NSString *)text addNumWithCount:(int)num addDecimalWithCount:(int)decimal {
    if ([text containsString:@"."]) {
        NSInteger dianIndenx = [text rangeOfString:@"."].location;
        NSString *freString = [text substringToIndex:dianIndenx];
        NSString *nexString = [text substringFromIndex:dianIndenx + 1];

        if (freString.length > num) {
            TTAlert([NSString stringWithFormat:@"最多只能输入%zd位整数", num]);
            return @"";
        }

        if (nexString.length > decimal) {
            TTAlert([NSString stringWithFormat:@"最多只能输入%zd位小数", decimal]);
            return @"";
        }
    } else {
        if (text.length > num) {
            TTAlert([NSString stringWithFormat:@"最多只能输入%zd位整数", num]);
            return @"";
        }
    }
    return text;
}


@end
