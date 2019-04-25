//
//  CXWDXJListCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXWDXJListModel;

@interface CXWDXJListCell : UITableViewCell

@property (nonatomic, strong) CXWDXJListModel *model;


- (void)setAction:(id)vacationApplicationModel;


//- (void)setApprovalAction:(id)vacationApplicationModel;

@end
