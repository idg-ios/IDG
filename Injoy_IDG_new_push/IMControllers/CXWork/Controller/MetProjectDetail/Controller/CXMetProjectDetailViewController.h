//
//  CXMetProjectDetailViewController.h
//  InjoyIDG
//
//  Created by wtz on 2018/3/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXMetProjectListModel.h"

@interface CXMetProjectDetailViewController : SDRootViewController

@property (nonatomic, strong) CXMetProjectListModel * listModel;

- (void)loadData;

@end
