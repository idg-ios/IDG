//
//  ICEFORCEProjectScoreViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/21.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEProjectScoreViewController : SDRootViewController
@property (nonatomic,copy) void (^SelectBlock)(NSString *message);

@property (nonatomic ,strong) NSString *projId;
@end

NS_ASSUME_NONNULL_END
