//
//  CXWorkCircleNewCommentListTableViewCell.m
//  InjoyERP
//
//  Created by wtz on 16/12/6.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXWorkCircleNewCommentListTableViewCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"

#define kTimeLabelFontSize 12.0

#define kTimeLabelTextColor RGBACOLOR(149.0, 149.0, 149.0, 1.0)

#define kTimeLabelTopSpace 10.0

#define kCommentLabelFontSize 14.0

#define kNameLabelFontSize 14.0

#define kNameLabelBottomSpace 10.0

#define kNameLabelLeftSpace 10.0

#define kHeadImageViewLeftSpace 10.0

#define kHeadImageViewWidth (kNameLabelFontSize + kNameLabelBottomSpace + kCommentLabelFontSize)

#define kTitleLabelBackViewWidth 60.0

#define kTitleLabelBackViewLeftSpace 60.0

#define kTitleLabelBackViewBackGroundColor RGBACOLOR(243.0, 243.0, 243.0, 1.0)

#define kTitleLabelFontSize 12.0

#define kTitleLabelLeftSpace 7.0

@interface CXWorkCircleNewCommentListTableViewCell()

@property (nonatomic, strong) CXWorkCircleCommentPushModel * workCircleCommentPushModel;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * titleLabelBackView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation CXWorkCircleNewCommentListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(kHeadImageViewLeftSpace, kHeadImageViewLeftSpace, kHeadImageViewWidth, kHeadImageViewWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kNameLabelLeftSpace, kHeadImageViewLeftSpace, Screen_Width - CGRectGetMaxX(_headImageView.frame) - kNameLabelLeftSpace - kHeadImageViewLeftSpace - kTitleLabelBackViewWidth - kTitleLabelBackViewLeftSpace, kNameLabelFontSize);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
    
    if(_commentLabel){
        [_commentLabel removeFromSuperview];
        _commentLabel = nil;
    }
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    _commentLabel.numberOfLines = 0;
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.font = [UIFont systemFontOfSize:kCommentLabelFontSize];
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = kTimeLabelTextColor;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
}

- (void)setWorkCircleCommentPushModel:(CXWorkCircleCommentPushModel *)workCircleCommentPushModel
{
    _workCircleCommentPushModel = workCircleCommentPushModel;
    [self layoutUI];
}

- (void)layoutUI
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[self.workCircleCommentPushModel.icon isKindOfClass:[NSNull class]]?@"":self.workCircleCommentPushModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = self.workCircleCommentPushModel.userName;
    [self.contentView addSubview:_nameLabel];
    
    _commentLabel.text = self.workCircleCommentPushModel.remark;
    CGSize commentLabelSize = [_commentLabel sizeThatFits:CGSizeMake(Screen_Width - CGRectGetMaxX(_headImageView.frame) - kNameLabelLeftSpace - kHeadImageViewLeftSpace , LONG_MAX)];
    _commentLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kNameLabelLeftSpace, CGRectGetMaxY(_nameLabel.frame) + kNameLabelBottomSpace, commentLabelSize.width, commentLabelSize.height);
    [self.contentView addSubview:_commentLabel];
    
    NSTimeInterval time=([self.workCircleCommentPushModel.createTime.stringValue doubleValue] + 28800)/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    _timeLabel.text = currentDateStr;
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kNameLabelLeftSpace, CGRectGetMaxY(_commentLabel.frame) + kTimeLabelTopSpace, Screen_Width, kTimeLabelFontSize);
    [self.contentView addSubview:_timeLabel];
}

+ (CGFloat)getWorkCircleCommentCellHeightWithWorkCircleCommentModel:(CXWorkCircleCommentPushModel *)model
{
    UILabel * commentLabel = [[UILabel alloc] init];
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:kCommentLabelFontSize];
    commentLabel.text = model.remark;
    CGSize commentLabelSize = [commentLabel sizeThatFits:CGSizeMake(Screen_Width - (kHeadImageViewLeftSpace + kHeadImageViewWidth) - kNameLabelLeftSpace - kHeadImageViewLeftSpace, LONG_MAX)];
    CGFloat cellHeight = kHeadImageViewLeftSpace + kNameLabelFontSize + kNameLabelBottomSpace + commentLabelSize.height + kTimeLabelTopSpace + kTimeLabelFontSize + kHeadImageViewLeftSpace;
    return cellHeight;
}

@end
