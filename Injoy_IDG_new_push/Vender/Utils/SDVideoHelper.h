//
//  SDVideoHelper.h
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDVideoHelper : NSObject

/**
 * 获取视频第一帧的截图方法
 */
+ (UIImage *)getVideoPreviewImage:(NSString *)videoURL;

@end
