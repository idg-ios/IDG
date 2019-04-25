//
//  ICEFORCEQZProjectEditViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/19.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "ICEFORCEPotentialDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEQZProjectEditViewController : SDRootViewController
@property (nonatomic,copy) void (^QZProjectEditBlock)(NSString *message);

@property (nonatomic ,strong) ICEFORCEPotentialDetailModel *model;
@end

NS_ASSUME_NONNULL_END
