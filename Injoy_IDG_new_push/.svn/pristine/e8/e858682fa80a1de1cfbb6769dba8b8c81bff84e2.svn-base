//
//  SDPermissionsDetectionUtils.m
//  SDIMApp
//
//  Created by wtz on 16/3/16.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import "SDPermissionsDetectionUtils.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation SDPermissionsDetectionUtils

//检测录像和拍照是否可用
+ (BOOL)checkMediaFree
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        return NO;
    }
    return YES;
}

//检测相册
+ (BOOL)checkImagePickerFree
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

//判断录音权限
+ (BOOL)checkCanRecordFree

{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

//判断定位服务
+ (BOOL)checkGetLocationFree
{
    return [CLLocationManager locationServicesEnabled];
}


@end
