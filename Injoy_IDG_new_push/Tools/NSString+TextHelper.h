//
//  NSString+TextHelper.h
//  SDMarketingManagement
//
//  Created by Mac on 15-4-28.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "NSDate+Category.h"
#import <Foundation/Foundation.h>

@interface NSString (TextHelper)

+ (NSString *)digitUppercaseWithMoney:(NSString *)money;

+ (NSAttributedString *)getAttributedText:(NSString *)textVal;

+ (NSAttributedString *)getAttributedTitle:(NSString *)titleVal content:(NSString *)contentVal;

- (CGFloat)getHeightExt:(UIFont *)font;

- (CGFloat)getWidthExt:(UIFont *)font;

- (CGFloat)getHeightExt;

- (CGFloat)getWidth;

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

- (NSString *)md5:(NSString *)str;

- (BOOL)checkPwd:(NSString *)pwd;

- (BOOL)checkAccoutn:(NSString *)str;

- (BOOL)checkEmail:(NSString *)str;

- (BOOL)checkMobilePhone:(NSString *)mobileNum;

- (BOOL)checkWechat:(NSString *)Wechat;

- (BOOL)checkFax:(NSString *)fax;

- (BOOL)checkYB:(NSString *)yb;

- (BOOL)checkPhone:(NSString *)phoneNum;

- (BOOL)isWebsite:(NSString *)weisite;

- (BOOL)validateQQNum:(NSString *)qqNum;

- (BOOL)isCodeNumber:(NSString *)codeNum;

+ (NSString *)getCurrentTime;

+ (NSString *)getUserName;

+ (BOOL)checkIsNumber:(NSString *)str;

+ (NSString *)compareTime:(NSString *)time;

+ (BOOL)isEmail:(NSString *)mailStr;

+ (BOOL)isChineseCharactersJudge:(NSString *)inputContent;

+ (NSString *)md5:(NSString *)str;

/**
 * 是否有权限访问
 */
+ (BOOL)hasTheRightToVisit:(NSString *)code;

/**
 * 是否显示相关功能
 */
+ (BOOL)hasTheRightToShow:(NSString *)code;

//判断是否包含某一字符串
#pragma mark 是否包含了某个字符串

+ (BOOL)containWithSelectedStr:(NSString *)selectedString contain:(NSString *)containStr;

#pragma mark 是否全部都是空格

+ (BOOL)containBlankSpaceWithSelectedStr:(NSString *)selectedString;

//时间格式转换
+ (NSString *)changeTimeDataByTimeStr:(NSString *)timeStr;

+ (NSString *)getLocalDateFormateUTCDateString:(NSString *)utcDateString;

+ (NSString *)getLocalDateFormateUTCDate:(NSDate *)utcDate;

#pragma mark unicode 转汉字

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//获取系统当前时间的年月日
+ (NSString *)getCurrentTimeYearMonthDay;

/**
 *  隐藏字符串
 *
 *  @param title    文本
 *  @param range    范围（开始索引，长度）
 *  @param fontSize 字号
 *
 *  @return 富文本
 */
+ (NSAttributedString *)hideString:(NSString *)title withRange:(NSRange)range withFontSize:(CGFloat)fontSize;

/**
 *  设置字符串富文本
 *
 *  @param title    文本
 *  @param range    范围（开始索引，长度）
 *  @param fontSize 字号
 *  @param color    颜泽
 *
 *  @return 富文本
 */
+ (NSAttributedString *)attributedString:(NSString *)title withRange:(NSRange)range withFontSize:(CGFloat)fontSize withColor:(UIColor *)color;

/**
 *  根据下标截取字符串拼接成...
 *
 *  @param index 下标
 *
 *  @return 拼接后的字符串
 */
+ (NSString *)substring:(NSString *)str ToIndex:(int)index;

//获取当前时间
+ (NSString *)getCurrentDate;

/** 获取中文的--年--月 */
+ (NSString *)getChineseYearMonthDate;

/** 获取中文的--年 */
+ (NSString *)getChineseYearDate;

/**
 
 *  数字截取相应的整数部分和小数部分
 
 *
 
 *  @param text    要截取的数据
 
 *  @param num    整数部分位数
 
 *  @param decimal 小数部分位数
 
 *
 
 *  @return 需要的字符串
 
 */

+ (NSString *)textWithText:(NSString *)text addNumWithCount:(int)num addDecimalWithCount:(int)decimal;
@end
