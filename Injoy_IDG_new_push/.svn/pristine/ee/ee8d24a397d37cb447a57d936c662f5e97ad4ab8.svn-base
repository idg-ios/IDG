//
//  NSString+CXCategory.m
//  SDMarketingManagement
//
//  Created by lancely on 5/11/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "NSString+CXCategory.h"

@implementation NSString (CXCategory)

+(NSString *)replaceCharacterWithNullValue:(id)value{
    if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    }else if (value == nil){
        return @"";
    }
    return @"";
}

- (NSString *)timeStringToDateString {
    NSString *dateSeparator = @"";
    if ([self rangeOfString:@"/"].location != NSNotFound) {
        dateSeparator = @"/";
    }
    else if ([self rangeOfString:@"-"].location != NSNotFound) {
        dateSeparator = @"-";
    }
    if (dateSeparator.length <= 0) {
        return nil;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss", dateSeparator, dateSeparator];
    NSDate *date = [fmt dateFromString:self];
    fmt.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd", dateSeparator, dateSeparator];
    return [fmt stringFromDate:date];
}

- (NSAttributedString *)getIndentAttributedTextWithIndent:(CGFloat)indentValue {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 对齐方式
    style.alignment = NSTextAlignmentLeft;
    // 首行缩进
    style.firstLineHeadIndent = indentValue;
    // 头部缩进
    style.headIndent = indentValue;
    // 尾部缩进
    style.tailIndent = -indentValue;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self attributes:@{ NSParagraphStyleAttributeName : style}];
    return attrText;
}

@end
