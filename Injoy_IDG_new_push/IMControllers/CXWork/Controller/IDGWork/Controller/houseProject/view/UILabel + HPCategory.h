//
//  UILabel + HPCategory.h
//  InjoyIDG
//
//  Created by ^ on 2018/6/1.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(HPCategory)
@property (nonatomic, copy, setter = setContent:) NSString *content;
@property (nonatomic, copy) void(^needUpdateFrameBlock)(UILabel *label, CGFloat height);
@property (nonatomic, assign) UIEdgeInsets sw_contentInsets;
@end
