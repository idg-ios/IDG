//
//  CXDatePickerView.h
//  InjoyERP
//
//  Created by haihualai on 2017/1/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectDateCallBack)(NSString *selectDate);

@interface CXDatePickerView : UIView

@property (nonatomic, copy)selectDateCallBack selectDateCallBack;

/*
 *   设置时间，打开时间视图，默认会显示设置的时间
 *   传入格式为：yyyy-MM-dd
**/
@property (nonatomic, copy)NSString *dateContent;

/** 日期格式*/
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

-(void)show;

@end
