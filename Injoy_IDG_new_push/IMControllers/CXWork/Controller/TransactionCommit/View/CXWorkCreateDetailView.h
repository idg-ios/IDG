//
//  CXWorkCreateDetailView.h
//  InjoyERP
//
//  Created by wtz on 16/11/21.
//  Copyright © 2016年 slovelys. All rights reserved.
//

/** 展现模式 */
typedef NS_ENUM(NSInteger, CXWorkCreateDetailViewMode) {
    /** 创建 */
    CXWorkCreateDetailViewModeCreate = 0,
    /** 只读 */
    CXWorkCreateDetailViewModeReadOnly = 1
};

#import <UIKit/UIKit.h>
#import "CXTextView.h"

@protocol CXWorkCreateDetailViewReloadHeightDelegate <NSObject>

@optional
//输入文字后会改变View的高度，用此代理方法来刷新view的高度
- (void)workCreateDetailViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight;

@end

@interface CXWorkCreateDetailView : UIView

@property (nonatomic,strong) NSString * theContentText;
@property (nonatomic, strong) UILabel *holdLable;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic,weak) id<CXWorkCreateDetailViewReloadHeightDelegate> delegate;
//初始化
- (id)initWithTitle:(NSString *)title andFrame:(CGRect)frame AndCXContentDetailViewMode:(CXWorkCreateDetailViewMode)contentDetailViewMode;
//如果是只读模式，初始化后调用该方法赋值
- (void)setContentText:(NSString *)contentText;
//清空
-(void)clearAll;

@end
