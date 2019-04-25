//
//  ICEFORCEPersonListViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/18.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "ICEFORCEPersonListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEPersonListViewController : SDRootViewController

/** 存放临时数据 */
@property (nonatomic ,strong) NSMutableArray<ICEFORCEPersonListModel *> *tempArray;

@property (nonatomic ,strong) NSString *titleString;
@property (nonatomic,copy) void (^selectPersonBlock)(NSArray<ICEFORCEPersonListModel *>* dataArry);

@end

NS_ASSUME_NONNULL_END
