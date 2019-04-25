//
//  CXDailyMeetingMonthListCell.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDailyMeetingDayListCell.h"
#import "Masonry.h"
#import "CXDailyMeetingModel.h"
#import "NSDate+YYAdd.h"

@interface CXDailyMeetingDayListCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 时间段 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 状态 */
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation CXDailyMeetingDayListCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = RGBACOLOR(31.0, 34.0, 40.0, 1.0);
        label.font = [UIFont systemFontOfSize:18.0];
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0);
            make.top.equalTo(self.contentView.mas_top).offset(20.0);
            make.right.lessThanOrEqualTo(self.contentView).offset(-63.0);
        }];
        label;
    });
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(132, 142, 153);
        label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.0);
        }];
        label;
    });
    
    self.statusLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
        label;
    });
}

#pragma mark - Get Set

- (void)setFrame:(CGRect)frame {
    // 顶部与上一个cell有1.0pt的间距
    CGFloat topMargin = 1.0;
    frame.origin.y += topMargin;
    frame.size.height -= topMargin;
    [super setFrame:frame];
}

- (void)setMeetingModel:(CXDailyMeetingModel *)meetingModel {
    _meetingModel = meetingModel;
    static NSString * const format = @"yyyy-MM-dd HH:mm:ss";
    
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
        statusText = @"待开始";
    }
    if (nowTimestamp > endTimestamp) {
        color = CXDailyMeetingColorComplete;
        statusText = @"已结束";
    }
    
    // 标题
    self.titleLabel.text = meetingModel.title;
    
    if (self.isShowYear == NO) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    }else{
        // 时间
        if ([startDate isEqualToString:endDate]) { // 在同一天 2017-11-27 9:00 - 10:00
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", startDate, startTime, endTime];
        }else { // 不在同一天 2017-11-27 23:00 - 2017-11-28 00:30
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@", startDate, startTime, endDate, endTime];
        }
    }
    // 状态
    self.statusLabel.text = statusText;
    self.statusLabel.textColor = color;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

