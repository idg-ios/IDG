//
//  CXExampleBillView.h
//  InjoyERP
//
//  Created by cheng on 17/1/4.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXERPBaseView.h"

@interface CXConfirmView : CXERPBaseView

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *message;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message callback:(void(^)(BOOL yes))callback;

@end
