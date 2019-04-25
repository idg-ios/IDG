//
//  CXMineFormBuilder.h
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXEditLabel.h"
#import "SDRootViewController.h"

@class CXMineFormItem;
@interface CXMineFormBuilder : NSObject

/** 表单类型 */
@property (nonatomic, assign) CXFormType formType;
/** 创建/修改的api地址 */
@property (nonatomic, copy) NSString *submitUrl;
/** 详情的id */
@property (nonatomic, assign) NSUInteger eid;
/** 详情的api地址 */
@property (nonatomic, copy) NSString *detailUrl;
/** 控制器标题 */
@property (nonatomic, copy) NSString *title;
/** 控制器 */
@property (nonatomic, strong, readonly) SDRootViewController *viewController;
/** 提交成功后的回调 */
@property (nonatomic, copy) void(^onPostSuccess)();

- (CXMineFormItem *)addFormItem:(CXMineFormItem *)formItem;

- (void)addAnnexItem;

@end

@interface CXMineFormItem : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** <#comment#> */
@property (nonatomic, copy) NSString *placeholder;
/** 对应接口的字段名（新建/修改） */
@property (nonatomic, copy) NSString *filedName;
/** 值（默认为nil） */
@property (nonatomic, copy) NSString *value;
/** 输入类型 */
@property (nonatomic, assign) CXEditLabelInputType inputType;
/** 是否必填（默认为YES） */
@property (nonatomic, assign) BOOL required;
/** 对应编辑的label */
@property (nonatomic, weak) CXEditLabel *editLabel;

- (instancetype)initWithTitle:(NSString *)title filedName:(NSString *)filedName inputType:(CXEditLabelInputType)inputType;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder filedName:(NSString *)filedName inputType:(CXEditLabelInputType)inputType;

@end
