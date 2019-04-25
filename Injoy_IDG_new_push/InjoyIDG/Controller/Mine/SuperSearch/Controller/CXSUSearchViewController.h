//
//  CXSUSearchViewController.h
//  InjoyYJ1
//
//  Created by cheng on 2017/8/17.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

/** 超级用户搜索 */
@interface CXSUSearchViewController : SDRootViewController

/** 大菜单 */
@property (nonatomic, copy) NSString *menu;

/**
 初始化方法

 @param menu 大菜单名称 eg. 我的办公
 @return instance
 */
- (instancetype)initWithMenu:(NSString *)menu;

@end
