//
//  CXYMProjectListCell.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXYMProjectModel;

@interface CXYMProjectListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *projectTypeImageView;///<项目类别标志图
@property (nonatomic, strong) UILabel *peojectNameLabel;///<项目名称
@property (nonatomic, strong) UILabel *projectTypeLabel;///<项目类别名称
@property (nonatomic, strong) UILabel *projectDescribeLabel;///<项目描述
@property (nonatomic, strong) UILabel *projectMajorLabel;///<项目负责人

@property (nonatomic, strong) CXYMProjectModel *project;
@end
