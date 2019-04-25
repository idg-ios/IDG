//
//  CXEditLabel.h
//  SDMarketingManagement
//
//  Created by lancely on 5/20/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

@class CXMyCustomerModel;
//#import "CXMyCustomerModel.h"
#import "CXStaticDataModel.h"
#import "SDCompanyUserModel.h"
#import <UIKit/UIKit.h>
#import "CXUserModel.h"

/** 自定义选择器文本字段key */
UIKIT_EXTERN NSString *const CXEditLabelCustomPickerTextKey;
/** 自定义选择器值字段key */
UIKIT_EXTERN NSString *const CXEditLabelCustomPickerValueKey;
UIKIT_EXTERN NSString *flagStr;

/** 输入类型 */
typedef NS_ENUM(NSInteger, CXEditLabelInputType) {
    /** 文字 */
            CXEditLabelInputTypeText = UIKeyboardTypeDefault, // = 0
    /** 字符 */
            CXEditLabelInputTypeASCII = UIKeyboardTypeASCIICapable, // = 1
    /** 数字和标点 */
            CXEditLabelInputTypeNumbersAndPunctuation = UIKeyboardTypeNumbersAndPunctuation, // = 2
    /** 0~9的数字 */
            CXEditLabelInputTypeNumber = UIKeyboardTypeNumberPad, // = 4
    /** 手机号 */
            CXEditLabelInputTypePhone = UIKeyboardTypePhonePad, // = 5
    /** 数值 */
            CXEditLabelInputTypeDecimal = UIKeyboardTypeDecimalPad, // = 8
    /** 审批人 */
            CXEditLabelInputTypeApproval = 100,
    /** 抄送 */
            CXEditLabelInputTypeCC = 101,
    /** 客户 */
            CXEditLabelInputTypeClient = 102,
    /** 静态数据 */
            CXEditLabelInputTypeStaticData = 103,
    /** 日期 */
            CXEditLabelInputTypeDate = 104,
    /** 年月 */
            CXEditLabelInputTypeYearMonth = 105,
    /** 年份 */
            CXEditLabelInputTypeYear = 106,
    /** 自定义选择 */
            CXEditLabelInputTypeCustomPicker = 107,
    /** 员工 */
            CXEditLabelInputTypeStaff = 108,
    /** 支付方式 */
            CXEditLabelInputTypeAccount = 109,
    /** 自定义电话 数字和 -  */
            CXEditLabelInputTypeCustomPhone = 110,
    /** 日期和时间 */
            CXEditLabelInputTypeDateAndTime = 111,
    /** 使用人 */
            CXEditLabelInputTypeSYR = 112,
    /** 下属 */
            CXEditLabelInputTypeXS = 113,
    /** 发送 */
            CXEditLabelInputTypeFS = 114,
    /** 协作人 */
            CXEditLabelInputTypeXZR = 115,
    /** 出差城市 */
            CXEditLabelInputTypeCity = 116
};

/** 可编辑的label */
@interface CXEditLabel : UIView

#pragma mark - 选项
/** 是否允许编辑(默认YES) */
@property(nonatomic, assign, getter=isAllowEditing) BOOL allowEditing;
/** 头部缩进(默认为0) */
//@property (nonatomic, assign) NSInteger headIndent;
/** 尾部缩进(默认为0) */
//@property (nonatomic, assign) NSInteger tailIndent;
/** 行间距(默认0) */
//@property (nonatomic, assign) CGFloat spacing;
/** 输入类型(默认CXEditLabelInputTypeText) */
@property(nonatomic, assign) CXEditLabelInputType inputType;
/** 设置最长字符数，多出将被截断(默认为0，不限制) */
@property(nonatomic, assign) NSInteger maxLength;
/** 显示下拉箭头(下拉选择类型默认为YES，其他默认为NO) */
@property(nonatomic, assign) BOOL showDropdown;
/** 显示白色下拉箭头(下拉选择类型默认为YES，其他默认为NO) */
@property(nonatomic, assign) BOOL showWhiteDropdown;

@property(nonatomic, assign) BOOL showNewDropdown;
/** 是否必填(默认NO) */
@property(nonatomic, assign, getter=isRequired) BOOL required;
/** 标题字体（默认 kFontSizeForDetail） */
@property(nonatomic, strong) UIFont *titleFont;
/** 内容字体（默认 kFontSizeForForm） */
@property(nonatomic, strong) UIFont *contentFont;
@property(nonatomic, assign) BOOL scale;
@property(nonatomic, assign) BOOL fitSize;
#pragma mark - 数据
/** 标题 */
@property(nonatomic, copy) NSString *title;
/** 自定义选择器标题 */
@property(nonatomic, copy) NSString *selectViewTitle;
/** 选择使用人View的title */
@property(nonatomic, copy) NSString *syrViewTitle;
/** 内容 */
@property(nonatomic, copy) NSString *content;
/** 占位字符串 */
@property(nonatomic, copy) NSString *placeholder;
/** 自定义的数据 */
@property(nonatomic, strong) __kindof NSObject *data;

/** 选择的审批人 (CXEditLabelInputTypeApproval) */
@property(nonatomic, strong, readonly) SDCompanyUserModel *selectedApproval;
/** 选择的抄送人数组 (CXEditLabelInputTypeCC) */
@property(nonatomic, copy, readonly) NSArray<CXUserModel *> *selectedCCUsers;
/**
 *
 *  详情传的抄送数据 (CXEditLabelInputTypeCC)
 *  @remark NSArray<NSDictionary *> * 或 NSArray<CXUserModel *> *类型
 */
@property(nonatomic, copy) NSArray<id> *detailCCData;

/** 选中的客户 (CXEditLabelInputTypeClient) */
@property(nonatomic, strong, readonly) CXMyCustomerModel *selectedClient;

/** 静态数据类型 (CXEditLabelInputTypeStaticData) */
@property(nonatomic, copy) NSString *staticDataType;
/** 选择的静态数据模型 (CXEditLabelInputTypeStaticData) */
@property(nonatomic, strong, readonly) CXStaticDataModel *selectedStaticDataModel;
/** 详情静态数据值 (CXEditLabelInputTypeStaticData) */
@property(nonatomic, copy) NSString *detailStaticDataValue;

/** 自定义选择中的文本 (CXEditLabelInputTypeCustomPicker) */
@property(nonatomic, copy) NSArray<NSString *> *pickerTextArray;
/** 自定义选择中的值 可选参数 (CXEditLabelInputTypeCustomPicker) */
@property(nonatomic, copy) NSArray<id> *pickerValueArray;
/** 选择的数据 (CXEditLabelInputTypeCustomPicker) key1 = @"text", key2 = @"value" */
@property(nonatomic, copy) NSDictionary<NSString *, id> *selectedPickerData;

/** 选择的员工 (CXEditLabelInputTypeStaff) */
@property(nonatomic, copy, readonly) SDCompanyUserModel *selectedStaff;
/** 支付方式选择的id (CXEditLabelInputTypeCustomPicker) */
@property(nonatomic, strong) NSNumber *payWayStyle;
/** 支付方式选择的文本 (CXEditLabelInputTypeCustomPicker) */
@property(nonatomic, copy) NSMutableArray<NSString *> *currencyTextArray;

#pragma mark - 回调
/** 需要更新frame的回调 */
@property(nonatomic, copy) void (^needUpdateFrameBlock)(CXEditLabel *editLabel, CGFloat height);
/** 自定义处理 */
@property(nonatomic, copy) void (^didTapLabelBlock)(CXEditLabel *editLabel);
/** 自定义处理 */
@property(nonatomic, copy) void (^customActionBlock)(CXEditLabel *editLabel);
/** 完成编辑的回调 */
@property(nonatomic, copy) void (^didFinishEditingBlock)(CXEditLabel *editLabel);

#pragma mark - 公开方法

/** 清空数据 */
- (void)clean;

/** 获取标题的size */
+ (CGSize)sizeForTitle:(NSString *)title;

@end


@interface CXEditLabel (UILabelProperty)

/** 文字颜色 */
@property(nonatomic) UIColor *textColor;
/** 字体 */
@property(nonatomic) UIFont *font;
/** 行数 */
@property(nonatomic) NSInteger numberOfLines;
/** 文本 */
@property(nonatomic) NSString *text;
/** 富文本 */
@property(nonatomic) NSAttributedString *attributedText;
/** 对齐方式 */
@property(nonatomic) NSTextAlignment textAlignment;

@end

@interface CXEditLabel (HelpProperties)

/** 文本内容的高度 */
@property (readonly) CGFloat textHeight;
/** 上下的间距 */
@property (readonly) CGFloat paddingTopBottom;

@end
