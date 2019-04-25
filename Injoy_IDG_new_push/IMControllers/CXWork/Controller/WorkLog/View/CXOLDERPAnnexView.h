//
//  CXOLDERPAnnexView.h
//  InjoyYJ1
//
//  Created by wtz on 2017/8/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

@interface CXOLDERPAnnexView : UIView<UIImagePickerControllerDelegate,
ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate>

/** 控制器，用于打开相册和相机 */
@property(nonatomic, weak) UIViewController *vc;

@property(nonatomic, assign) BOOL isDetail;

/// 所有图片数组
@property(nonatomic, strong) NSMutableArray *AllAnnexDataArray;
/**
 *  图片、声音、文件字典 (详情时必须传进来)
 */
@property(nonatomic, strong) NSMutableArray *annexDataArray;
/**
 *  图片、声音、文件字典 (新建时选择好附件重新点击附件时必须传进来)
 */
@property(nonatomic, strong) NSMutableDictionary *annexDataDict;
/** 大表单未提交情况下把已提交的图片，语音传过来 */
@property(nonatomic, strong) NSMutableArray *sendDataArray;

- (void)putImageVoiceData;

//清空所有附件数据
- (void)cleanData;

- (id)initWithFrame:(CGRect)frame AndViewWidth:(CGFloat)viewWidth;

- (id)initWithFrame:(CGRect)frame AndViewWidth:(CGFloat)viewWidth AndIsOnlyPicture:(BOOL)isOnlyPicture;

@end
