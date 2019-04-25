//
//  CXBusinessTripEditHeaderView.h
//  InjoyIDG
//
//  Created by ^ on 2018/5/17.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXBussinessTripEditViewController.h"
#import "CXBusinessTripEditDataManager.h"
typedef void (^frameUpdate) ();
@interface CXBusinessTripEditHeaderView : UIView
@property(nonatomic, copy)frameUpdate viewUpdate;
@property(nonatomic, strong)NSArray *cityArray;
@property(nonatomic, strong)CXBusinessTripEditDataManager *dataManager;
- (bool)checkData;
- (id)initWithFrame:(CGRect)frame dataModel:(CXBusinessTripEditDataManager *)dataManager andType:(VCType)type;
@end
