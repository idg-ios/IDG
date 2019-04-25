//
//  NSMutableArray+CXCategory.m
//  SDMarketingManagement
//
//  Created by lancely on 5/28/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "NSMutableArray+CXCategory.h"

@implementation NSMutableArray (CXCategory)

+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // Cast of C pointer type 'CFMutableArrayRef' (aka 'struct __CFArray *') to Objective-C pointer type 'id' requires a bridged cast
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
    // return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}


@end
