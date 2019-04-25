//
//  ICEFORCEProjectShareViewController.h
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/17.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICEFORCEProjectShareViewController : SDRootViewController

/** 推荐项目名称 必须 */
@property (nonatomic ,strong) NSString *pjName;
/** 项目ID 必须*/
@property (nonatomic ,strong) NSString *projId;
@end

NS_ASSUME_NONNULL_END
