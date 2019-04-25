//
//  SDCustomTextPicker.m
//  SDMarketingManagement
//
//  Created by Mac on 15-5-27.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//  公共的文本选择器

#import "SDCustomTextPicker.h"
@interface SDCustomTextPicker () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSInteger selectedRow;
    NSInteger selectedComponent;
}
@end

@implementation SDCustomTextPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    [self addSubview:_pickerView];
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 162, Screen_Width, 162)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [self sendSubviewToBack:bgView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
}

- (void)setPickerData:(NSArray*)pickerData
{
    _pickerData = pickerData;
    [self.pickerView reloadAllComponents];
}

- (void)setSelectedRowData:(NSString*)selectedRowData
{
    if (![selectedRowData isEqualToString:@""]) {
        NSInteger value = [_pickerData indexOfObject:selectedRowData];
        selectedRow = value;
        [_pickerView selectRow:value inComponent:0 animated:YES];
    }
}

#pragma mark 实现协议UIPickerViewDelegate方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if ([[self.pickerData firstObject] isKindOfClass:[NSArray class]]) {
        return self.pickerData.count;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([[self.pickerData firstObject] isKindOfClass:[NSArray class]]) {
        NSArray* subArray = self.pickerData[component];
        return subArray.count;
    }

    return _pickerData.count;
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
    selectedComponent = component;
}

#pragma mark 实现协议UIPickerViewDelegate方法
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //    selectedRow = row;
    if ([[self.pickerData firstObject] isKindOfClass:[NSArray class]]) {
        return self.pickerData[component][row];
    }
    return [self.pickerData objectAtIndex:row];
}

- (IBAction)beSure:(id)sender
{
    if (self.cancelAction) {
        self.cancelAction();
    }

    [self removeFromSuperview];
}

- (IBAction)beCancel:(id)sender
{
    //回调选中的年月
    if ([self.pickerData isKindOfClass:[NSArray class]]) {
        if (self.yearMonthCallBack) {
            //要回调的年
            NSInteger selectedYear = [self.pickerView selectedRowInComponent:0];
            NSInteger selectedMonth = [self.pickerView selectedRowInComponent:1];
            NSString* selectedYearStr = [[self.pickerData objectAtIndex:0] objectAtIndex:selectedYear];
            NSString* selectedMonthStr = [[self.pickerData objectAtIndex:1] objectAtIndex:selectedMonth];
            self.yearMonthCallBack(selectedYearStr, selectedMonthStr);
        }
    }

    if (self.selectCallBack) {
        selectedRow = [self.pickerView selectedRowInComponent:0];
        if (selectedRow < (int)[_pickerData count]) {
            self.selectCallBack(_pickerData[selectedRow], selectedRow);
        }
    }
    if (self.textCallBack) {
        if (selectedRow < (int)[_pickerData count]) {
            _textCallBack(_pickerData[selectedRow]);
        }
    }
    if (self.staticTextCallBack) {
        NSString* value = nil;
        if (self.staticModelData != nil) {
            for (CXStaticDataModel* model in self.staticModelData) {
                if ([model.name isEqualToString:_pickerData[selectedRow]]) {
                    value = model.value;
                }
            }
        }
        else {
            for (CXStaticDataModel2* model in self.staticModelData2) {
                if ([model.name isEqualToString:_pickerData[selectedRow]]) {
                    value = [NSString stringWithFormat:@"%ld", (long)model.ID];
                }
            }
        }

        if (value.length != 0) {
            if (selectedRow < (int)[_pickerData count]) {
                _staticTextCallBack(_pickerData[selectedRow], value);
            }
        }
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (self.cancelAction) {
        self.cancelAction();
    }
    [self removeFromSuperview];
}

@end
