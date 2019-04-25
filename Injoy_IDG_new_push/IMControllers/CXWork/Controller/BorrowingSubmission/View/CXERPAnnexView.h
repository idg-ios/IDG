//
//  CXERPAnnexView.h
//  InjoyERP
//
//  Created by fanzhong on 16/11/16.
//  Copyright © 2016年 slovelys. All rights reserved.
//

extern const CGFloat CXERPAnnexView_height;

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

/** 附件类型 输入类型 */
typedef NS_ENUM(NSInteger, CXERPAnnexViewType) {
    /** 拍照、图片、语音、附件*/
            CXERPAnnexViewTypeNormal = 10,
    /** 拍照、图片、语音*/
            CXERPAnnexViewTypePhotographAndPicture = 11,
    /** 图片、语音*/
            CXERPAnnexViewTypePictureAndVoice = 12,
    /** 图片、语音、附件*/
            CXERPAnnexViewTypePictureVoiceAndAnnex = 13,
    /** 图片、语音、附件、费用*/
            CXERPAnnexViewTypePictureVoiceAnnexAndCost = 14,
    /** 图片、语音、费用*/
            CXERPAnnexViewTypePictureVoiceAndCost = 15
};

/** 获取资金明细的参数*/
typedef struct {
    /** 业务类型*/
    int type;
    /** 业务ID*/
    long bid;
} FundDetail;

/**
 附件上传的回调 
 annex  上传成功的返回
 */
typedef void(^AnnexUploadCallBackBlock)(NSString *annex);

@interface CXERPAnnexView : UIView <UIImagePickerControllerDelegate,
        ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, copy) NSString *title;

/** 控制器，用于打开相册和相机 */
@property(nonatomic, weak) UIViewController *vc;

/**
 *  图片、声音、文件等 (创建时获取)
 */
@property(nonatomic, strong) NSMutableArray *addAnnexDataArray;

/**
 *  图片、声音、文件等 (详情时必须传进来)
 */
@property(nonatomic, strong) NSMutableArray *detailAnnexDataArray;

/** 作为参数对应的value上传*/
@property(nonatomic, copy) NSString *costString;

/** 详情时获得的列表 不用了 用下面的*/
@property(nonatomic, strong) NSMutableArray *detailCostArray;

/** 资金明细列表查询传入*/
@property(nonatomic, assign) FundDetail fundDetail;

/** 附件上传回调*/
@property(nonatomic, copy) AnnexUploadCallBackBlock annexUploadCallBack;


/**
 *  图片、声音、文件字典 (新建时选择好附件重新点击附件时必须传进来)
 */
//@property(nonatomic, strong) NSMutableDictionary *annexDataDict;

//* 大表单未提交情况下把已提交的图片，语音传过来 
//@property(nonatomic, strong) NSMutableArray *sendDataArray;

//- (void)putImageVoiceData;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame type:(CXERPAnnexViewType)type;

//附件上传
- (void)annexUpLoad;

//清空所有附件数据
- (void)cleanData;

@end
