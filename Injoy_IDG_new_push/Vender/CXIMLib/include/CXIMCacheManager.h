//
//  CXIMCacheManager.h
//  CXIMLib
//
//  Created by lancely on 4/29/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIM-Singleton.h"

@interface CXIMCacheManager : NSObject

singleton_interface(CXIMCacheManager)

/**
 *  获取缓存大小（字节）
 *
 *  @return 缓存大小
 */
- (unsigned long long)getCacheSize;

/**
 *  清除缓存
 */
- (void)clearCache:(void(^)())completion;

@end
