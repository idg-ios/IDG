//
//  CXCommonTemplateModel.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/31.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXCommonTemplateModel.h"

@implementation CXCommonTemplateModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"] ? : @"";
        _publishTime = dictionary[@"publishTime"] ? : @"";
        _eid = [NSString stringWithFormat:@"%@",dictionary[@"eid"]] ? : @"";
    }
    return self;
}

+ (NSArray <CXCommonTemplateModel *> *)commonTemplateArrayWithArray:(NSArray *)array{
    if([array isKindOfClass:[NSArray class]] == NO) return  nil;
    if(array == nil || array.count == 0) return nil;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if([dic isKindOfClass:[NSDictionary class]] == NO) return  nil;
        CXCommonTemplateModel *model = [[[self class] alloc] initWithDictionary:dic];
        [mutableArray addObject:model];
    }
    return mutableArray;
}

@end
