//
//  CXReimbursementApprovalAlertView.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXReimbursementApprovalAlertView : UIView

- (instancetype)initWithSubObjId:(NSNumber *)subObjId affairId:(NSNumber *)affairId;

@property(copy, nonatomic) void (^callBack)(void);

- (void)show;

- (void)dismiss;

@end
