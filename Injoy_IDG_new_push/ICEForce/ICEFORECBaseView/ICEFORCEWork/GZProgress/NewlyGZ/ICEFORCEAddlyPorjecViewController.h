//
//  ICEFORCEAddlyPorjecViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "ICEFORECVoiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEAddlyPorjecViewController : SDRootViewController

/** 项目id 详情界面必须传 */
@property (nonatomic ,strong) NSString *pjNameID;
/** 项目名称 详情界面必须传 */
@property (nonatomic ,strong) NSString *pjName;

/** 进行待办是必须传的参数 */
@property (nonatomic ,strong) NSString *validDate;




@property (nonatomic,copy) void (^AddlPJRefreshBlock)(NSString *messgae);


@end

NS_ASSUME_NONNULL_END
