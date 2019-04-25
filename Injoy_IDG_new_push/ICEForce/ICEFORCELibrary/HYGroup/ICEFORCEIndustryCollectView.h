//
//  ICEFORCEIndustryCollectView.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/24.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEIndustryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEIndustryCollectView : UIView
@property (nonatomic,copy) void (^IndustryBlock)(ICEFORCEIndustryModel *model);

@end

NS_ASSUME_NONNULL_END
