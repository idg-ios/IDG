//
//  CXLabelTextVIew.h
//  SDMarketingManagement
//
//  Created by wtz on 16/5/16.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXLabelTextView;
@protocol CXLabelTextViewDelegate <NSObject>

///用户输入的文本 按发送调用
-(void)textView:(CXLabelTextView *)textView textWhenTextViewFinishingEdit:(NSString *)text;

@optional

//开始编辑的时候已经编辑的文本
-(NSString *)textWhenTextViewBeginEdit;

//键盘显示的时候的高度
-(void)textView:(CXLabelTextView *)textView heightWhenTextViewEdit:(CGFloat)height;

@end

@interface CXLabelTextView : UIView<UITextViewDelegate>

///允许输入的最大
@property (nonatomic, assign) NSUInteger maxLengthOfString;

///原本输入的文本
@property(nonatomic, copy) NSString *textString;

@property(nonatomic, assign) BOOL isMoneyView;

//差旅  出差原因
@property (nonatomic, assign) BOOL isReasonView;

//加班申请
@property (nonatomic, assign) BOOL isFromWorkOverTime;




@property(nonatomic, weak) id<CXLabelTextViewDelegate>delegate;

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType AndLabel:(UILabel *)label;

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType AndLabel:(UILabel *)label AndIsMoney:(BOOL)isMoney;

@end
