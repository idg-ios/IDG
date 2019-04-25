//
//  SDShowPicController.h
//  SDMarketingManagement
//
//  Created by fanzhong on 15/4/27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"

@protocol SDShowPicControllerDegate <NSObject>

@optional
- (void)removeImageByClickTrashBtn:(NSArray *)imageArray;

-(void)removeImageByClickImageModelArray:(NSArray *)imageModelArray;
//相片和相册对象一起回调
- (void)removeImageByClickTrashBtn:(NSArray *)imageArray assetsArray:(NSArray *)assetsArray;

//回调删除图片的索引
- (void)removeImageIndex:(NSInteger)deleteIndex;

@end

@interface SDShowPicController : SDRootViewController
@property(nonatomic,copy)NSArray *imageArray;
@property(nonatomic,assign)NSInteger index;//选择的第几张图片进来的
@property(nonatomic,weak)id<SDShowPicControllerDegate>delegate;
@property(nonatomic,assign)BOOL isTravels;

//来自超信详情界面界面
@property (nonatomic,assign)BOOL isFromDetail;

//从照相库中进来的图片
@property (nonatomic,copy)NSArray *assetsArray;

//审批成功后，隐藏删除按钮
@property (nonatomic, assign) BOOL hideDeleteButton;

@end
