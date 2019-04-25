//
//  CXMailEditController.h
//  InjoyYJ1
//
//  Created by admin on 17/7/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

typedef void (^ReturnRefreshListBlock)();

@interface CXMailEditController : SDRootViewController

/** 表单类型 */
@property (nonatomic, assign) CXFormType formType;

@property (nonatomic, strong) NSString *sendtype;
@property (strong,nonatomic) NSString *receiveUser;
@property (nonatomic, strong) NSString *mailSubject;
@property (nonatomic, strong) NSData *messageData;
@property (nonatomic, strong) NSString *mailAddress;
@property (nonatomic, copy) ReturnRefreshListBlock returnRefreshBlock;

@end
