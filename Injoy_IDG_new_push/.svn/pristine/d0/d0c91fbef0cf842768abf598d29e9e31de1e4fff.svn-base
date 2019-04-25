//
//  SDMenuView.h
//  SDMarketingManagement
//
//  Created by admin on 15/12/17.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDMenuView;
@protocol SDMenuViewDelegate <NSObject>

@optional
///// 选中回调indexPath和名称
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName;

-(void)menuView:(SDMenuView *)menuView returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName;

@end

@interface SDMenuView : UIView

///// 文字数据
@property (nonatomic, strong) NSArray* dataArray;
///// 图片数组
@property (nonatomic, strong) NSArray* imageArray;

@property (nonatomic, weak)id<SDMenuViewDelegate> delegate;

@property (nonatomic, assign) BOOL isPresentview;

/// 初始化
- (instancetype)initWithDataArray:(NSArray*)dataArray andImageNameArray:(NSArray*)imageArray;

@end
