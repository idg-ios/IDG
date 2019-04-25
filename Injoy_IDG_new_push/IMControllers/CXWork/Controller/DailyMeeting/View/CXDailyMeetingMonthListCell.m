//
//  CXDailyMeetingMonthListCell.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDailyMeetingMonthListCell.h"
#import "Masonry.h"
#import "CXDailyMeetingModel.h"
#import "NSDate+YYAdd.h"

@interface CXDailyMeetingMonthListCell ()

/** 会议类型的线条 */
@property (nonatomic, strong) UIView *typeLineView;
/** 日 */
@property (nonatomic, strong) UILabel *dayLabel;
/** 年月 */
@property (nonatomic, strong) UILabel *yearMonthLabel;
/** 竖线 */
@property (nonatomic, strong) UIView *vLine;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 时间段 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 状态 */
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation CXDailyMeetingMonthListCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.typeLineView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(4);
        }];
        view;
    });
    
    // 左右的间隔(基于dayLabel中心)
    CGFloat dayLabelMarginLR = 35;
    self.dayLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:24];
        label.textColor = [UIColor blackColor];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.typeLineView.mas_right).offset(dayLabelMarginLR);
            make.top.equalTo(self.contentView.mas_top).offset(7);
        }];
        label;
    });
    
    self.yearMonthLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = kColorWithRGB(104, 104, 104);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-7);
            make.centerX.equalTo(self.dayLabel);
        }];
        label;
    });
    
    self.vLine = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kColorWithRGB(222, 222, 222);
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLabel.mas_centerX).offset(dayLabelMarginLR);
            make.width.equalTo(@1);
            make.height.equalTo(self.contentView).multipliedBy(0.68);
            make.centerY.equalTo(self.contentView);
        }];
        view;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vLine.mas_right).offset(12);
            make.top.equalTo(self.dayLabel);
            make.right.lessThanOrEqualTo(self.contentView).offset(-60);
        }];
        label;
    });
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = self.yearMonthLabel.textColor;
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.centerY.equalTo(self.yearMonthLabel);
        }];
        label;
    });
    
    self.statusLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        label;
    });
}

#pragma mark - Get Set

- (void)setFrame:(CGRect)frame {
    // 顶部与上一个cell有10pt的间距
    CGFloat topMargin = 10;
    frame.origin.y += topMargin;
    frame.size.height -= topMargin;
    [super setFrame:frame];
}

- (void)setMeetingModel:(CXDailyMeetingModel *)meetingModel {
    _meetingModel = meetingModel;
    static NSString * const format = @"yyyy-MM-dd HH:mm:ss";
    
    // startMonth: 2017-12
    NSString *startMonth = [[NSDate dateWithString:meetingModel.startTime format:format] stringWithFormat:@"yyyy-MM"];
    // startDay: 09
    NSString *startDay = [[NSDate dateWithString:meetingModel.startTime format:format] stringWithFormat:@"dd"];
    // startDate: 2017-12-09
    NSString *startDate = [[NSDate dateWithString:meetingModel.startTime format:format] stringWithFormat:@"yyyy-MM-dd"];
    // startTime: 9:00
    NSString *startTime = [[NSDate dateWithString:meetingModel.startTime format:format] stringWithFormat:@"H:mm"];
    // endDate: 2017-12-09
    NSString *endDate = [[NSDate dateWithString:meetingModel.endTime format:format] stringWithFormat:@"yyyy-MM-dd"];
    // endTime: 10:00
    NSString *endTime = [[NSDate dateWithString:meetingModel.endTime format:format] stringWithFormat:@"H:mm"];
    
    // 开始时间戳
    NSTimeInterval startTimestamp = [NSDate dateWithString:meetingModel.startTime format:format].timeIntervalSince1970;
    // 结束时间戳
    NSTimeInterval endTimestamp = [NSDate dateWithString:meetingModel.endTime format:format].timeIntervalSince1970;
    // 当前时间戳
    NSTimeInterval nowTimestamp = [NSDate date].timeIntervalSince1970;
    
    // 左边线条颜色，状态
    UIColor *color = CXDailyMeetingColorInProgress;
    NSString *statusText = @"进行中";
    if (nowTimestamp < startTimestamp) {
        color = CXDailyMeetingColorNotStarted;
        statusText = @"未开始";
    }
    if (nowTimestamp > endTimestamp) {
        color = CXDailyMeetingColorComplete;
        statusText = @"已结束";
    }
    
    // 设置左边线条颜色
    self.typeLineView.backgroundColor = color;
    
    // 天
    self.dayLabel.text = startDay;
    
    // 月份
    self.yearMonthLabel.text = startMonth;
    
    // 标题
    self.titleLabel.text = meetingModel.title;
    
    // 时间
    if ([startDate isEqualToString:endDate]) { // 在同一天 9:00 - 11:30
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    }
    else { // 不在同一天 23:00 - 2017-12-10 00:30
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@ %@", startTime, endDate, endTime];
    }
    
    // 状态
    self.statusLabel.text = statusText;
    self.statusLabel.textColor = self.typeLineView.backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *c1 = self.typeLineView.backgroundColor;
    UIColor *c2 = self.vLine.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.typeLineView.backgroundColor = c1;
    self.vLine.backgroundColor = c2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *c1 = self.typeLineView.backgroundColor;
    UIColor *c2 = self.vLine.backgroundColor;
    [super setSelected:selected animated:animated];
    self.typeLineView.backgroundColor = c1;
    self.vLine.backgroundColor = c2;
}

@end
