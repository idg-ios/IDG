//
//  CXUserSelectController.h
//  InjoyYJ1
//
//  Created by cheng on 2017/8/7.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "SDRootViewController.h"
#import "CXUserModel.h"

/** 用户选择的控制器 */
@interface CXUserSelectController : SDRootViewController

/** 选人列表类型 */
typedef NS_ENUM(NSInteger, CXUserSelectType) {
    /** 全公司列表 */
    AllMembersType = 1,
    /** 下属列表 */
    SubordinateType = 2,
    /** 上级 */
    SuperiorType = 3
};


/** 是否多选（默认YES） */
@property (nonatomic, assign, getter=isMultiSelect) BOOL multiSelect;

/** 是否只显示，不选择（默认NO） */
@property (nonatomic, assign, getter=isDisplayOnly) BOOL displayOnly;

/** 选人列表类型（默认全公司） */
@property (nonatomic, assign) CXUserSelectType selectType;

/** 已选中的用户 */
@property (nonatomic, copy) NSArray<CXUserModel *> *selectedUsers;

/** 选择后的回调 */
@property (nonatomic, copy) void(^didSelectedCallback)(NSArray<CXUserModel *> *users);

/** eid（type=SuperiorType传） */
@property (nonatomic, assign) NSInteger selectSuperior_eid;

@end
