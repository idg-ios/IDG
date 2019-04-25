//
//  CXYunJingWorkCircleMyselfCell.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYunJingWorkCircleMyselfCell.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"

#define kTimeLeftSpace 10
#define kTimeTopSpace 15
#define kDayLabelFontSize 16.0
#define kMonthLabelFontSize 12.0
#define kTypeLabelFontSize 15.0
#define kTitleLabelFontSize 14.0
#define kTextColor RGBACOLOR(72.0, 71.0, 76.0, 1.0)
#define kGrayBackGroundViewTopSpace 3
#define kTypeImageLeftSpace 10
#define kTypeImageWidth 25
#define kGrayBackGroundViewMoveLeft 3
#define kGrayBackGroundViewBottomSpace 15
#define kMyselfWorkCellHeight (kTimeTopSpace + kTypeLabelFontSize + kGrayBackGroundViewTopSpace + kTypeImageLeftSpace + kTypeImageWidth + kTypeImageLeftSpace + kGrayBackGroundViewBottomSpace)
#define kBottomLineViewTopSpace 15.0

@interface CXYunJingWorkCircleMyselfCell()

@property (nonatomic, strong) CXAllPeoplleWorkCircleModel * model;
@property (nonatomic, strong) UILabel * dayLabel;
@property (nonatomic, strong) UILabel * monthLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation CXYunJingWorkCircleMyselfCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_dayLabel){
        [_dayLabel removeFromSuperview];
        _dayLabel = nil;
    }
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.font = [UIFont systemFontOfSize:kDayLabelFontSize];
    _dayLabel.textColor = [UIColor blackColor];
    _dayLabel.backgroundColor = [UIColor clearColor];
    _dayLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_monthLabel){
        [_monthLabel removeFromSuperview];
        _monthLabel = nil;
    }
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.font = [UIFont systemFontOfSize:kMonthLabelFontSize];
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.backgroundColor = [UIColor clearColor];
    _monthLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_contentLabel){
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kTypeLabelFontSize];
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_bottomLineView){
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGBACOLOR(231.0, 231.0, 233.0, 1.0);
}

- (void)setCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _dayLabel.text = [NSString stringWithFormat:@"%@",[self.model.createTime substringWithRange:NSMakeRange(3, 2)]];
    [_dayLabel sizeToFit];
    _dayLabel.frame = CGRectMake(kTimeLeftSpace, kTimeTopSpace, _dayLabel.size.width, kDayLabelFontSize);
    [self.contentView addSubview:_dayLabel];
    
    _monthLabel.text = [NSString stringWithFormat:@"%@月",[self.model.createTime substringToIndex:2]];
    [_monthLabel sizeToFit];
    _monthLabel.frame = CGRectMake(CGRectGetMaxX(_dayLabel.frame), kTimeTopSpace + (kDayLabelFontSize - kMonthLabelFontSize), _monthLabel.size.width, kMonthLabelFontSize);
    [self.contentView addSubview:_monthLabel];
    
    _contentLabel.text = self.model.remark;
    CGSize size = [_contentLabel sizeThatFits:CGSizeMake(Screen_Width - kTimeLeftSpace - CGRectGetMaxX(_monthLabel.frame) - kTimeLeftSpace, LONG_MAX)];
    _contentLabel.frame = CGRectMake(CGRectGetMaxX(_monthLabel.frame) + kTimeLeftSpace, kTimeTopSpace, size.width, size.height);
    [self.contentView addSubview:_contentLabel];
    
    _bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame) + kBottomLineViewTopSpace - 1, Screen_Width, 1);
    
    [self.contentView addSubview:_bottomLineView];
}

+ (CGFloat)getCXMyselfWorkTableViewCellHeightWithCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model
{
    UILabel * dayLabel = [[UILabel alloc] init];
    dayLabel.font = [UIFont systemFontOfSize:kDayLabelFontSize];
    dayLabel.text = [NSString stringWithFormat:@"%@",[model.createTime substringWithRange:NSMakeRange(3, 2)]];
    [dayLabel sizeToFit];
    dayLabel.frame = CGRectMake(kTimeLeftSpace, kTimeTopSpace, dayLabel.size.width, kDayLabelFontSize);
    [dayLabel sizeToFit];
    
    UILabel * monthLabel = [[UILabel alloc] init];
    monthLabel.font = [UIFont systemFontOfSize:kMonthLabelFontSize];
    monthLabel.text = [NSString stringWithFormat:@"%@月",[model.createTime substringToIndex:2]];
    [monthLabel sizeToFit];
    monthLabel.frame = CGRectMake(CGRectGetMaxX(dayLabel.frame), kTimeTopSpace + (kDayLabelFontSize - kMonthLabelFontSize), monthLabel.size.width, kMonthLabelFontSize);
    [monthLabel sizeToFit];
    
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kTypeLabelFontSize];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = model.remark;
    CGSize size = [contentLabel sizeThatFits:CGSizeMake(Screen_Width - kTimeLeftSpace - CGRectGetMaxX(monthLabel.frame) - kTimeLeftSpace, LONG_MAX)];
    contentLabel.frame = CGRectMake(CGRectGetMaxX(monthLabel.frame) + kTimeLeftSpace, kTimeTopSpace, size.width, size.height);

    
    return CGRectGetMaxY(contentLabel.frame) + kBottomLineViewTopSpace;
}

@end
