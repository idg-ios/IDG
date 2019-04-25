//
//  CXXJSPListApprovalAlertView.h
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXWDXJListModel;

typedef void(^CXXJSPListApprovalAlertViewAgreeBlock)(void);
typedef void(^CXXJSPListApprovalAlertViewUnagreeBlock)(NSString *remark);

@interface CXXJSPListApprovalAlertView : UIView

@property (nonatomic, copy) CXXJSPListApprovalAlertViewAgreeBlock agreeBlock;
@property (nonatomic, copy) CXXJSPListApprovalAlertViewUnagreeBlock unagreeBlock;
@property( nonatomic, copy) void (^back)(BOOL agree);

- (instancetype)initWithWDXJListModel:(CXWDXJListModel *)model;
- (void)show;
//- (instancetype)initWithApplyId:(NSNumber *)applyId applyUser:(NSString *)applyUser;
//
//@property(copy, nonatomic) void (^callBack)(void);
//@property (nonatomic, strong) UIViewController *vc;
//
//- (void)show;
//
//- (void)dismiss;

@end
