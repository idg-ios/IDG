//
//  NSDate+Category.m
//  SDIMApp
//
//  Created by lancely on 1/28/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "NSDate+IMCategory.h"

@implementation NSDate (IMCategory)

-(NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end
