//
//  CXFormLabel.h
//  SDMarketingManagement
//
//  Created by huashao on 16/4/12.
//  Copyright © 2016年 slovelys. All rights reserved.
//  表单的标签

#import <UIKit/UIKit.h>

@class CXFormLabel;
@protocol CXFormLabelDelegate <NSObject>

@optional
/**
 *  返回该表单label 和 label的键盘属性
 *
 *  @param formLabel    CXFormLabel
 *  @param keyboardType 键盘类型：1：正常输入 2：数字键盘
 */
- (void)formLabel:(CXFormLabel *)formLabel keyboardType:(UIKeyboardType) keyboardType;

@end

@interface CXFormLabel : UILabel

//标题
@property (nonatomic, copy) NSString *titile;

//内容
@property (nonatomic, copy) NSString *content;

//placeHoder
@property (nonatomic, copy) NSString *placeHolder;

//上个视图穿过位置
@property (nonatomic, copy) NSString *location;

//位置视图
@property (nonatomic, assign) BOOL isPotionView;

// 键盘类型：1：正常输入 2：数字键盘
@property (nonatomic) UIKeyboardType keyboardType;

@property (nonatomic, weak) id<CXFormLabelDelegate> formLabelDelegate;

- (void)clean;

//改变内容的字体
-(void)changeContentFont:(CGFloat)contentSize;

@property (nonatomic, assign) BOOL isRequired;

@end
