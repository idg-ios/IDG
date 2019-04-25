//
// Created by ^ on 2017/11/22.
// Copyright (c) 2017 Injoy. All rights reserved.
//

/// 我的休假信息
@interface CXHolidayInfoModel : SDBaseModel
/// 数值码
@property(assign, nonatomic) int code;
/// 假期类型
@property(copy, nonatomic) NSString *name;
/// 请假最小单位
@property(assign, nonatomic) CGFloat minDay;
/// 可请天数
@property(assign, nonatomic) int availableDay;
/// 假期总天数
@property(strong, nonatomic) NSNumber *totalDays;

@end
