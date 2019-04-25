//
//  CXReimbursementPaymentDetailViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/19.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXReimbursementApprovalListModel.h"

@interface CXReimbursementPaymentDetailViewController : SDRootViewController

@property (nonatomic) BOOL isApproval;

@property (nonatomic, strong) CXReimbursementApprovalListModel * listModel;

@end
