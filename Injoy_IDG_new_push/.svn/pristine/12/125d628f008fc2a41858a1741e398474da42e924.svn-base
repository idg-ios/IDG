//
//  CXIMImageMessageBody.h
//  SDIMLib
//
//  Created by cheng on 16/8/5.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXIMFileMessageBody.h"
#import "CXIMDimensionsInfo.h"
@class UIImage;

/** 图片消息体 */
@interface CXIMImageMessageBody : CXIMFileMessageBody

/** 图片尺寸 */
@property (nonatomic, strong) CXIMDimensionsInfo *imageDimensions;

/**
 *  图片消息体的初始化方法
 *
 *  @param image 图片对象
 *
 *  @return 图片消息体
 */
+ (instancetype)bodyWithImage:(UIImage *)image;

@end
