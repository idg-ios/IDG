//
//  CXYMActionSheetView.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionSheetSelectedBlock)(NSInteger index, NSString *title);

@interface CXYMActionSheetView : UIView

@property (nonatomic, copy) ActionSheetSelectedBlock block;
@property (nonatomic, strong) UIColor *headBackgroudColor;///<头部背景色

@property (nonatomic, strong) UIColor *sureButtonTextColor;///<确定按钮文本颜色
@property (nonatomic, strong) UIColor *sureButtonTextFont;///<确定按钮文本字号

@property (nonatomic, strong) UIColor *cancelButtonTextColor;///<取消按钮文本颜色
@property (nonatomic, strong) UIColor *cancelButtonTextFont;///<取消按钮文本字号


- (instancetype)initWithTitle:(NSString *)title sheetArray:(NSArray <NSString *> *)sheetArray;

- (void)show;
- (void)dismiss;
@end
