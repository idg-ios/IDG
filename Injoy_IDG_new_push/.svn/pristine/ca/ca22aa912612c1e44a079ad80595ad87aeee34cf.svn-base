//
//  CXPromotionSettingsView.h
//  InjoyERP
//
//  Created by wtz on 2017/5/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

/** 展现模式 */
typedef NS_ENUM(NSInteger, CXPromotionSettingsViewMode) {
    /** 创建 */
    CXPromotionSettingsViewModeCreate = 0,
    /** 只读 */
    CXPromotionSettingsViewModeReadOnly = 1
};

#import <UIKit/UIKit.h>
#import "CXTextView.h"

@protocol CXPromotionSettingsViewReloadHeightDelegate <NSObject>

@optional
//输入文字后会改变View的高度，用此代理方法来刷新view的高度
- (void)promotionSettingsViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight AndHoldLabelText:(NSString *)holdLabelText;

@end

@interface CXPromotionSettingsView : UIView

@property (nonatomic,strong) NSString * theContentText;
@property (nonatomic, strong) UILabel *holdLable;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic,weak) id<CXPromotionSettingsViewReloadHeightDelegate> delegate;
//初始化
- (id)initWithTitle:(NSString *)title andFrame:(CGRect)frame AndCXPromotionSettingsViewMode:(CXPromotionSettingsViewMode)promotionSettingsViewMode AndHoldLabelText:(NSString *)text;
//初始化后调用该方法赋值
- (void)setContentText:(NSString *)contentText;
//设置下方线的颜色
- (void)setLineColor:(UIColor *)color;

//清空
-(void)clearAll;

@end
