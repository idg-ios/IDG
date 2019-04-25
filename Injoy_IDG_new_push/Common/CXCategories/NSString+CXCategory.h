//
//  NSString+CXCategory.h
//  SDMarketingManagement
//
//  Created by lancely on 5/11/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CXCategory)

//如果后台返回的字符串是null则赋值为空字符串
+ (NSString *)replaceCharacterWithNullValue:(id)value;

/**
 *  长时间字符串转日期字符串
 *
 *  @return 日期
 */
- (NSString *)timeStringToDateString;

/**
 *  带缩进的富文本
 *
 *  @param indentValue 缩进值
 *
 *  @return 富文本
 */
- (NSAttributedString *)getIndentAttributedTextWithIndent:(CGFloat)indentValue;

@end
