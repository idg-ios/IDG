//
//  CXTopView.h
//  InjoyDDXWBG
//
//  Created by ^ on 2017/10/20.
//  Copyright © 2017年 Injoy. All rights reserved.
//


#import <UIKit/UIKit.h>

extern CGFloat CXTopViewHeight;

@interface CXTopView : UIView
- (instancetype)initWithTitles:(NSArray *)titles;

- (instancetype)initWithTitles:(NSArray *)titles style:(CXTopViewStyle)style;

/*
 * 判断当前是哪个按钮
 */
@property(copy, nonatomic) void (^callBack)(NSString *title);
@end
