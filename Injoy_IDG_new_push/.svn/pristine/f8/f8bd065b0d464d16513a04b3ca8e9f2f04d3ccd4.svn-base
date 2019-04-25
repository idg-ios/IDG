//
//  SDCustomDatePicker.h
//  SDMarketingManagement
//
//  Created by Mac on 15-5-18.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishDateDelegate <NSObject>

@optional
- (void)getTime:(NSString*)time;
-(void)clickCancelButton;

@end

/// 回调选择的时间
typedef void (^datePickerSelectCallBack)(NSString* selectDate);
typedef void (^datePickerDateCallBack)(NSDate* date) ;
// 回调选择的时间 yyyy-MM-dd
typedef void (^datePickerSelectCallBackDateMode)(NSString *selectDate);

/// 时间选择器
@interface SDCustomDatePicker : UIView
- (IBAction)beSure:(id)sender;
- (IBAction)beCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, weak) id<FinishDateDelegate> delegate;
@property (nonatomic, copy) datePickerSelectCallBack selectCallBack;
@property (nonatomic, copy) datePickerDateCallBack dateCallBack;
@property (nonatomic, copy) datePickerSelectCallBackDateMode selectCallBackModeDate;

@property (nonatomic ,assign) BOOL isVisitTime;

// 接受传过来的时间值
@property (nonatomic, strong) NSDate *myDate;

@end
