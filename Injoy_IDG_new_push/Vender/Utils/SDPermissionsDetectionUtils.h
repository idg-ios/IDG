//
//  SDPermissionsDetectionUtils.h
//  SDIMApp
//
//  Created by wtz on 16/3/16.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDPermissionsDetectionUtils : NSObject
//检测录像和拍照是否可用
+ (BOOL)checkMediaFree;
//检测相册是否可用
+ (BOOL)checkImagePickerFree;
//录音权限
+ (BOOL)checkCanRecordFree;
//判断定位服务
+ (BOOL)checkGetLocationFree;

@end
