//
//  CXInputDialogView.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/30.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXInputDialogView : UIView

/** 标题（默认是搜索） */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 确定的回调 */
@property (nonatomic, copy) void(^onApplyWithContent)(NSString *content);

- (void)show;

- (void)dismiss;

@end
