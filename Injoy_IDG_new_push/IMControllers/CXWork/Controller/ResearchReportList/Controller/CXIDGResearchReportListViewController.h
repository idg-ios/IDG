//
//  CXIDGResearchReportListViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/2/26.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"

@interface CXIDGResearchReportListViewController : SDRootViewController

/** 搜索文字 */
@property (nonatomic, copy) NSString *searchText;

@property (nonatomic) BOOL isSuperSearch;

/** 标题 */
@property (nonatomic, copy) NSString *titleName;

@end
