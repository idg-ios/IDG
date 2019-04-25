//
//  SDCustomDatePicker.m
//  SDMarketingManagement
//
//  Created by Mac on 15-5-18.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  公共的日期选择器

#import "SDCustomDatePicker2.h"

@implementation SDCustomDatePicker2

- (void)awakeFromNib
{
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height-162, Screen_Width, 162)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [self sendSubviewToBack:bgView];
}

///点击取消的按钮
- (IBAction)beSure:(id)sender
{
    
    NSDate* selected = [_datePicker date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0800"]; //修改时区为东8区
    NSString* time = [dateFormatter stringFromDate:selected];
    NSRange range = [time rangeOfString:@"+"];
    
    time = [time substringToIndex:range.location - 1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeModeDate = [formatter stringFromDate:selected];
    
    if (self.isFromCXTravel) {
        
        formatter.dateFormat = @"yyyy-MM-dd";
         timeModeDate = [formatter stringFromDate:selected];
    }
    
    if ([self.delegate2 respondsToSelector:@selector(getTime:)]) {
        [self.delegate2 getTime:time];
    }
    else if (self.selectCallBack2) {
        self.selectCallBack2(time);
    }
    if(self.dateCallBack2)
    {
        self.dateCallBack2(selected);
    }
    else if (self.selectCallBackModeDate2) {
        self.selectCallBackModeDate2(timeModeDate);
    }
    
    [self removeFromSuperview];
}

/////点击确定的按钮
- (IBAction)beCancel:(id)sender
{
    [self removeFromSuperview];
}

-(void)setMyDate:(NSDate *)myDate
{
    _myDate = myDate;
    if (_myDate) {
        // 设置时区
        [_datePicker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
        
        // 设置当前显示时间
        [_datePicker setDate:_myDate animated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self removeFromSuperview];
}

@end
