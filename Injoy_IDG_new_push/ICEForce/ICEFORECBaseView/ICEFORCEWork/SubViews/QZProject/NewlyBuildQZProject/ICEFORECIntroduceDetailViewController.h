//
//  ICEFORECIntroduceDetailViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/15.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "ICEFORECVoiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORECIntroduceDetailViewController : SDRootViewController
@property (nonatomic,copy) void (^introduceDetailBlock)(ICEFORECVoiceModel* model);

@end

NS_ASSUME_NONNULL_END
