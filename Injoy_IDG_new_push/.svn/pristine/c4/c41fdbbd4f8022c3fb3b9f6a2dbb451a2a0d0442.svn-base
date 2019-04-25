//
//  CXVersionsAlertView.h
//  SDMarketingManagement
//
//  Created by lancely on 6/16/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXVersionsAlertView : UIView

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *content;

/** 点击了忽略 */
@property (nonatomic, copy) void (^ignoreButtonTapped)(CXVersionsAlertView *alertView);
/** 点击了更新 */
@property (nonatomic, copy) void (^updateButtonTapped)(CXVersionsAlertView *alertView);

typedef void (^buttonTapped)();;

/** 显示 */
- (void)show;

/** 隐藏 */
- (void)dismiss;

@end
