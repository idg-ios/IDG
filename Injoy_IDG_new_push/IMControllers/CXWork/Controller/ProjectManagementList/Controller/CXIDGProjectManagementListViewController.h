//
//  CXIDGProjectManagementListViewController.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXIDGProjectManagementListViewController : SDRootViewController

/** 搜索文字 */
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic) BOOL isSuperSearch;

/** 标题 */
@property (nonatomic, copy) NSString *titleName;

@end
