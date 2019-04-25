//
//  ICEFORCEPickerViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEFORCEPickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEPickerViewController : UIViewController
@property (nonatomic,copy) void (^SelectBlock)(ICEFORCEPickerModel *model);


@property (nonatomic ,strong) NSArray *dataArray;


@end

NS_ASSUME_NONNULL_END
