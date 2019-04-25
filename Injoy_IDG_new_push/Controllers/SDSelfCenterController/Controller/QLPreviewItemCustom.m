//
//  QLPreviewItemCustom.m
//  SDMarketingManagement
//
//  Created by admin on 16/1/23.
//  Copyright (c) 2016年 slovelys. All rights reserved.
//

#import "QLPreviewItemCustom.h"

@implementation QLPreviewItemCustom

@synthesize previewItemTitle = _previewItemTitle;
@synthesize previewItemURL   = _previewItemURL;

- (id) initWithTitle:(NSString*)title url:(NSURL*)url
{
    self = [super init];
    if (self != nil) {
        _previewItemTitle = title;
        _previewItemURL   = url;
    }
    return self;
}

-(void)dealloc
{
    _previewItemURL = nil;
    _previewItemTitle = nil;
}

@end
