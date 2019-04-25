//
//  CXTextView.h
//  SDMarketingManagement
//
//  Created by Longfei on 16/4/12.
//  Copyright © 2016年 slovelys. All rights reserved.
//  文字输入键盘

/*
 
  CXTextView *textView = [[CXTextView alloc] init];//需要文本输入的创建(默认键盘)
 CXTextView *textView = [[CXTextView alloc] initWithKeyboardType:];//特定键盘
  textView.delegate = self; //设置代理

 UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
 [mainWindow addSubview:keyboard]; // 添加
   -(void)textWhenTextViewFinishEdit:(NSString *)text                          //代理方法获得输入文本
 
 */

#import <UIKit/UIKit.h>

@class CXTextView;
@protocol CXTextViewDelegate <NSObject>

///用户输入的文本 按发送调用
-(void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text;

@optional

//开始编辑的时候已经编辑的文本
-(NSString *)textWhenTextViewBeginEdit;

//键盘显示的时候的高度
-(void)textView:(CXTextView *)textView heightWhenTextViewEdit:(CGFloat)height;

@end

@interface CXTextView : UIView<UITextViewDelegate>

///允许输入的最大
@property (nonatomic, assign) NSUInteger maxLengthOfString;

///原本输入的文本
@property(nonatomic, copy) NSString *textString;

@property(nonatomic, assign) BOOL isMoneyView;

//差旅  出差原因
@property (nonatomic, assign) BOOL isReasonView;

//加班申请
@property (nonatomic, assign) BOOL isFromWorkOverTime;

@property(nonatomic, assign) id<CXTextViewDelegate>delegate;

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType;

@end
