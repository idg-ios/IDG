//
//  SDCustomTextPicker.h
//  SDMarketingManagement
//
//  Created by Mac on 15-5-27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "CXStaticDataModel.h"
#import "CXStaticDataModel2.h"
#import <UIKit/UIKit.h>

typedef void (^selectTextCallBack)(NSString* text);
typedef void (^selectStaticTextCallBack)(NSString* text, NSString* value);
typedef void (^selectCallBack)(NSString* text, NSInteger idx);
typedef void (^CXTextPickerCancelAction)(void);

//回调选中的年月
typedef void (^selectYearMonthCallBack)(NSString* year, NSString* month);

@interface SDCustomTextPicker : UIView

@property (weak, nonatomic) IBOutlet UILabel* cancelLabel;
@property (weak, nonatomic) IBOutlet UIButton* canButton;

- (IBAction)beSure:(id)sender;
- (IBAction)beCancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView* pickerView;
@property (strong, nonatomic) NSArray* pickerData;
/// 点取消的回调
@property (copy, nonatomic) CXTextPickerCancelAction cancelAction;
/**
 *  已经选中的值回传
 */
@property (strong, nonatomic) NSString* selectedRowData;
@property (nonatomic, copy) selectTextCallBack textCallBack;
@property (nonatomic, copy) selectStaticTextCallBack staticTextCallBack;
/** 带索引的回调 */
@property (nonatomic, copy) selectCallBack selectCallBack;
@property (strong, nonatomic) NSArray<__kindof CXStaticDataModel*>* staticModelData;
/**
 *  基础资料－货品品牌、货品类型专用
 */
@property (strong, nonatomic) NSArray<__kindof CXStaticDataModel2*>* staticModelData2;

//回调选中的年月
@property (nonatomic, copy) selectYearMonthCallBack yearMonthCallBack;

@end
