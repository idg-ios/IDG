//
//  SDRecordViewController.h
//  SDMarketingManagement
//
//  Created by shenhuihui on 15/5/19.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDRootViewController.h"
@protocol setUpVideo <NSObject>

@optional
- (void)setUpVideo:(NSString *)videoPath withduration:(float)duration;

@end

@interface SDRecordViewController : SDRootViewController

@property id <setUpVideo> delegate;

@end
