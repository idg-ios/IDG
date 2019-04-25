//
//  SDAnnexView.h
//  SDMarketingManagement
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 代理协议 -------------------
@protocol CXAnnexOneViewDelegate <NSObject>

@optional
-(void)removeImageIndex:(NSInteger)deleteIndex;

@end

#pragma mark - 声明 -------------------
@interface CXAnnexOneView : UIView

@property (nonatomic, assign) BOOL isMinSizeImage;

/**
 *  缩略图视图
 */
@property (nonatomic, strong) UIView *thumbView;
/**
 *  缩略图数据源数组
 */
@property (nonatomic, copy) NSMutableArray *imageArray;
/**
 *  图片附件代理方法(根据索引删除图片)
 */
@property (nonatomic, weak) id<CXAnnexOneViewDelegate> delegate;

@end
