//
//  CXBussinessTripEditFooterView.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXBusinessTripEditDataManager.h"
#import "CXBussinessTripEditViewController.h"

@interface CXBussinessTripEditFooterView : UIView
@property(nonatomic ,copy)void (^updateFrame)();
@property(nonatomic, strong)CXBusinessTripEditDataManager *dataManager;
@property(nonatomic, assign)VCType type;
@property (nonatomic) NSUInteger approvalStatue;
- (bool)checkData;
- (id)initWithFrame:(CGRect)frame dataModel:(CXBusinessTripEditDataManager *)dataManager andType:(VCType)type approvalStatue:(NSUInteger )approvalStatue;
@end
