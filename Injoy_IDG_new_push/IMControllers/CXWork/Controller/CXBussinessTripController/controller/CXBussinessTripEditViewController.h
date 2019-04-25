//
//  CXBussinessTripEditViewController.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/16.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
typedef NS_ENUM(NSInteger, VCType) {
    isCreate = 0,
    isDetail = 1,
    isApproval = 3
};
@interface CXBussinessTripEditViewController : SDRootViewController
@property(nonatomic, copy)void (^callBack)();
@property(nonatomic, assign)NSInteger eid;
@property(nonatomic, strong)NSString *applyId;
@property(nonatomic, assign)VCType type;

@property (nonatomic) NSUInteger approvalStatue;//1审批中,2同意,3驳回
@end
