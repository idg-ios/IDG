//
//  CXMyselfWorkTableViewCell.m
//  InjoyERP
//
//  Created by wtz on 16/11/23.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXMyselfWorkTableViewCell.h"
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

@interface CXMyselfWorkTableViewCell()

@property (nonatomic, strong) CXAllPeoplleWorkCircleModel * model;
@property (nonatomic, strong) UILabel * dayLabel;
@property (nonatomic, strong) UILabel * monthLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UIView * grayBackGroundView;
@property (nonatomic, strong) UIImageView * typeImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation CXMyselfWorkTableViewCell

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
    
    if(_typeLabel){
        [_typeLabel removeFromSuperview];
        _typeLabel = nil;
    }
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:kTypeLabelFontSize];
    _typeLabel.textColor = [UIColor blackColor];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_grayBackGroundView){
        [_grayBackGroundView removeFromSuperview];
        _grayBackGroundView = nil;
    }
    _grayBackGroundView = [[UIView alloc] init];
    _grayBackGroundView.backgroundColor = RGBACOLOR(242.0, 241.0, 246.0, 1.0);
    
    if(_typeImageView){
        [_typeImageView removeFromSuperview];
        _typeImageView = nil;
    }
    _typeImageView = [[UIImageView alloc] init];
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _titleLabel.textColor = kTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_bottomLineView){
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.frame = CGRectMake(0, kMyselfWorkCellHeight - 1, Screen_Width, 1);
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
    
    _typeLabel.text = [self getTypeWithBtypeString:self.model.btype];
    [_typeLabel sizeToFit];
    _typeLabel.frame = CGRectMake(CGRectGetMaxX(_monthLabel.frame) + kTimeLeftSpace, kTimeTopSpace, _typeLabel.size.width, kTypeLabelFontSize);
    [self.contentView addSubview:_typeLabel];
    
    _grayBackGroundView.frame = CGRectMake(CGRectGetMaxX(_monthLabel.frame) + kTimeLeftSpace - kGrayBackGroundViewMoveLeft, CGRectGetMaxY(_typeLabel.frame) + kGrayBackGroundViewTopSpace, Screen_Width - (CGRectGetMaxX(_monthLabel.frame) + kTimeLeftSpace - kGrayBackGroundViewMoveLeft) - kTimeLeftSpace, kTypeImageLeftSpace*2 + kTypeImageWidth);
    [self.contentView addSubview:_grayBackGroundView];
    
    _typeImageView.image = [UIImage imageNamed:[self getTypeImageNameWithBtypeString:self.model.btype]];
    _typeImageView.highlightedImage = [UIImage imageNamed:[self getTypeImageNameWithBtypeString:self.model.btype]];
    _typeImageView.frame = CGRectMake(kTypeImageLeftSpace, kTypeImageLeftSpace, kTypeImageWidth, kTypeImageWidth);
    [_grayBackGroundView addSubview:_typeImageView];
    
    _titleLabel.text = self.model.name;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_typeImageView.frame) + kTypeImageLeftSpace, (kTypeImageLeftSpace*2 + kTypeImageWidth - kTitleLabelFontSize)/2 - 1, Screen_Width - (CGRectGetMaxX(_monthLabel.frame) + kTimeLeftSpace - kGrayBackGroundViewMoveLeft) - kTimeLeftSpace - kTypeImageLeftSpace*3 - kTypeImageWidth, kTitleLabelFontSize + 2);
    [_grayBackGroundView addSubview:_titleLabel];
    
    [self.contentView addSubview:_bottomLineView];
}

- (NSString *)getTypeWithBtypeString:(NSString *)btype
{
    if([btype isEqualToString:@"30"]){
        return @"请假申请";
    }
    else if([btype isEqualToString:@"31"]){
        return @"事务报告";
    }
    else if([btype isEqualToString:@"32"]){
        return @"借支申请";
    }
    else if([btype isEqualToString:@"34"]){
        return @"工作日志";
    }
    return @"业绩报告";
}

- (NSString *)getTypeImageNameWithBtypeString:(NSString *)btype
{
    if([btype isEqualToString:@"30"]){
        return @"LeaveToSubmit";
    }
    else if([btype isEqualToString:@"31"]){
        return @"TransactionCommit";
    }
    else if([btype isEqualToString:@"32"]){
        return @"BorrowingSubmission";
    }
    else if([btype isEqualToString:@"34"]){
        return @"workLog";
    }
    return @"PerformanceReport";
}

@end
