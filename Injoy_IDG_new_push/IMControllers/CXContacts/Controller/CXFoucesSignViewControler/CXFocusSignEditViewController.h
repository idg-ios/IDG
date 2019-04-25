//
//  CXFocusSignEditViewController.h
//  SDMarketingManagement
//
//  Created by lancely on 4/21/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXFocusSignModel;

/**
 *  关注标签编辑模式
 */
typedef NS_ENUM(NSInteger, CXFocusSignEditMode) {
    /**
     *  修改
     */
    CXFocusSignEditModeModify,
    /**
     *  新建
     */
    CXFocusSignEditModeCreate
};

@interface CXFocusSignEditViewController : SDRootViewController

/**
 *  编辑模式
 */
@property (nonatomic, assign) CXFocusSignEditMode editMode;
/**
 *  关注标签模型
 *  CXFocusSignEditModeModify需要传
 */
@property (nonatomic, strong) CXFocusSignModel *focusSignModel;

/**
 *  保存成功的回调
 */
@property (nonatomic, copy) void(^didSaveSuccessBlock)();

@end
