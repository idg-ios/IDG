//
//  CXUserSelectCell.h
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXUserModel;
@interface CXUserSelectCell : UITableViewCell

/** 用户模型 */
@property (nonatomic, strong) CXUserModel *userModel;
/** 是否显示选择 */
@property (nonatomic, assign) BOOL showSelect;
/** 是否选中 */
@property (nonatomic, assign, getter=isUserSelected) BOOL userSelected;

@end
