//
//  CXIDGConferenceInformationListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXIDGConferenceInformationListModel.h"

typedef void (^spwcCallBack)();

@interface CXIDGConferenceInformationListTableViewCell : UITableViewCell

//审批完成之后的回调
@property (copy, nonatomic) spwcCallBack spwcCallBack;

- (void)setCXIDGConferenceInformationListModel:(CXIDGConferenceInformationListModel *)model;

+ (CGFloat)getCXIDGConferenceInformationListTableViewCellHeightWithCXIDGConferenceInformationListModel:(CXIDGConferenceInformationListModel *)model;

@end
