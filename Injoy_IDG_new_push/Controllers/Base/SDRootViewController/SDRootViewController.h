//
//  SDRootViewController.h
//  SDMarketingManagement
//
//  Created by slovelys on 15/4/23.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRootTopView.h"
#import "EMNetworkMonitorDefs.h"
#import "CXHeader.h"

#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

UIKIT_EXTERN NSString *const SDRootViewControllerViewDidLoadNotification;
UIKIT_EXTERN NSInteger const kRootTopViewTag;

@interface SDRootViewController : UIViewController

/** 是否从超级搜索进来 */
@property(nonatomic, assign) BOOL fromSuperSearch;
@property(nonatomic, copy) NSString *functionName;
@property(readonly) SDRootTopView *RootTopView;
@property(assign, nonatomic) CXFormType formType;

/// 获取顶部导航条
- (SDRootTopView *)getRootTopView;

/// 网络状态改变 @Override
- (void)networkChanged:(EMConnectionState)connectionState;

@end
