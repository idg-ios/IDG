//
//  UIColor+CXYMCategory.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "UIColor+CXYMCategory.h"

@implementation UIColor (CXYMCategory)

- (CGFloat)red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}


- (CGFloat)green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

+(UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *newHexString = hexString;
    if ([hexString hasPrefix:@"#"]) {
        newHexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    }
    NSScanner *scanner = [NSScanner scannerWithString:newHexString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}
+(UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorFromHexString:hexString];
    return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:alpha];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
