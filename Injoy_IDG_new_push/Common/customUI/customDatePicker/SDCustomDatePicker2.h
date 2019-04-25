//
//  SDCustomDatePicker.h
//  SDMarketingManagement
//
//  Created by Mac on 15-5-18.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishDateDelegate2 <NSObject>
- (void)getTime:(NSString*)time;

@end

/// 回调选择的时间
typedef void (^datePickerSelectCallBack2)(NSString* selectDate);
typedef void (^datePickerDateCallBack2)(NSDate* date) ;
// 回调选择的时间 yyyy-MM-dd
typedef void (^datePickerSelectCallBackDateMode2)(NSString *selectDate);

/// 时间选择器
@interface SDCustomDatePicker2 : UIView

- (IBAction)beSure:(id)sender;
- (IBAction)beCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, weak) id<FinishDateDelegate2> delegate2;
@property (nonatomic, copy) datePickerSelectCallBack2 selectCallBack2;
@property (nonatomic, copy) datePickerDateCallBack2 dateCallBack2;
@property (nonatomic, copy) datePickerSelectCallBackDateMode2 selectCallBackModeDate2;

@property (nonatomic ,assign) BOOL isVisitTime;

// 接受传过来的时间值
@property (nonatomic, strong) NSDate *myDate;

// 如果值是来自超信,需要显示时分秒
@property (nonatomic, assign) BOOL isFromCXTravel;

@end
