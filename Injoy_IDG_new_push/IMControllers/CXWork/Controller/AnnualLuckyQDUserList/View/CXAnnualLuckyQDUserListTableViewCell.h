//
//  CXAnnualLuckyQDUserListTableViewCell.h
//  InjoyIDG
//
//  Created by wtz on 2018/1/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXAnnualLuckyQDUserListTableViewCell : UITableViewCell

/** 用户模型 */
@property (nonatomic, strong) CXUserModel *userModel;
/** 是否显示选择 */
@property (nonatomic, assign) BOOL showSelect;
/** 是否选中 */
@property (nonatomic, assign, getter=isUserSelected) BOOL userSelected;

- (void)setUserModel:(CXUserModel *)userModel;

@end
