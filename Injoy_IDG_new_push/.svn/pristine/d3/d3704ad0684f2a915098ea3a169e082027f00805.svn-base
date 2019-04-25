//
//  CXMineDialogView.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXMineDialogView;
@protocol CXMineDialogViewContentSource <NSObject>

@required

/** 内容 */
- (UIView *)contentViewOfDialogView:(CXMineDialogView *)dialogView;
/** 高度 */
- (CGFloat)heightForContentView:(UIView *)contentView ofDialogView:(CXMineDialogView *)dialogView;

@end

@protocol CXMineDialogViewDelegate <NSObject>
@optional
- (void)dialogViewDidTapPrimaryButton:(CXMineDialogView *)dialogView;
- (void)dialogViewDidTapSecondaryButton:(CXMineDialogView *)dialogView;
@end

@interface CXMineDialogView : UIView

/** 标题 */
@property (nonatomic, copy) NSString *title;
@property (readonly) UIView *contentView;
/** 主按钮 */
@property (nonatomic, strong, readonly) UIButton *primaryButton;
/** 次按钮 */
@property (nonatomic, strong, readonly) UIButton *secondaryButton;
/** 内容来源 */
@property (nonatomic, weak) id<CXMineDialogViewContentSource> contentSource;
@property (nonatomic, weak) id<CXMineDialogViewDelegate> delegate;

- (void)show;
- (void)dismiss;
- (void)reload;

@end
