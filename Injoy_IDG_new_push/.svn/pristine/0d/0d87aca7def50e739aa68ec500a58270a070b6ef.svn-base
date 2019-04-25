//
//  CXYMPlaceholderTextView.h
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXYMPlaceholderTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *placeholderFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSUInteger textMaxLength;
@property (nonatomic, readonly) NSUInteger remainderInputLength;
@property (nonatomic, copy) void(^textDidChangedBlock)(CXYMPlaceholderTextView *textView);
@property (nonatomic, copy) void(^textOverMaxLengthBlock)(CXYMPlaceholderTextView *textView);

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                                 textMaxLength:(NSUInteger)textMaxLength;
@end
