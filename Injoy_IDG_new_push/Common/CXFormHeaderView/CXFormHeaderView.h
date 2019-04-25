//
//  CXFormHeaderView.h
//  InjoyYJ1
//
//  Created by cheng on 2017/7/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 默认高度 */
UIKIT_EXTERN CGFloat const CXFormHeaderViewHeight;

/** 表单头部的视图 */
@interface CXFormHeaderView : UIView

/** 头像 */
@property(nonatomic, copy) NSString *avatar;
/** 名字 */
@property(nonatomic, copy) NSString *name;
/** 部门 */
@property(nonatomic, copy) NSString *dept;
/** 日期 */
@property(nonatomic, copy) NSString *date;
/** 编号 */
@property(nonatomic, copy) NSString *number;

/** 是否显示编号（默认是YES） */
@property(nonatomic, assign) BOOL displayNumber;
/** 是否能修改日期（默认是NO） */
@property(nonatomic, assign) BOOL dateAllowEditing;

@end
