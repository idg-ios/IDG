//
//  CXIDGMessageListTableViewCell.m
//  InjoyIDG
//
//  Created by wtz on 2017/12/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGMessageListTableViewCell.h"
#import "UIView+Category.h"

#define kImageLeftSpace 10.0
#define kImageTopSpace 10.0
#define kImageRightSpace 10.0
#define kImageWidth (2*(kTitleLabelTopSpace - kImageTopSpace) + kTitleLabelFontSize)
#define kTitleLabelTopSpace 13.0
#define kTitleLabelFontSize 16.0
#define kTitleLabelTextColor [UIColor blackColor]
#define kTimeLabelFontSize 12.0
#define kTimeLabelTextColor RGBACOLOR(196.0, 196.0, 196.0, 1.0)
#define kContentLabelTopSpace 7.0
#define kContentLabelFontSize 14.0
#define kContentLabelTextColor RGBACOLOR(196.0, 196.0, 196.0, 1.0)

@interface CXIDGMessageListTableViewCell()

@property (nonatomic, strong) CXIDGMessageListModel * model;
@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation CXIDGMessageListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_leftImageView){
        [_leftImageView removeFromSuperview];
        _leftImageView = nil;
    }
    _leftImageView = [[UIImageView alloc] init];
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _titleLabel.textColor = kTitleLabelTextColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    _timeLabel.textColor = kTimeLabelTextColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_contentLabel){
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
    _contentLabel.textColor = kContentLabelTextColor;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setCXIDGMessageListModel:(CXIDGMessageListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    if(self.type == RSType){
        _leftImageView.image = [UIImage imageNamed:@"CXIDGMSGPIC"];
        _leftImageView.highlightedImage = [UIImage imageNamed:@"CXIDGMSGPIC"];
    }else{
        _leftImageView.image = [UIImage imageNamed:@"LCXXICON"];
        _leftImageView.highlightedImage = [UIImage imageNamed:@"LCXXICON"];
    }
    _leftImageView.frame = CGRectMake(kImageLeftSpace, kImageTopSpace, kImageWidth, kImageWidth);
    [self.contentView addSubview:_leftImageView];
    
    _timeLabel.text = !_model.createTime||[_model.createTime length] <= 0?@" ":_model.createTime;
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(Screen_Width - kImageLeftSpace - _timeLabel.size.width, kTitleLabelTopSpace + (kTitleLabelFontSize - kTimeLabelFontSize)/2, _timeLabel.size.width, kTimeLabelFontSize);
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel.text = !_model.contentModel.title||[_model.contentModel.title length] <= 0?@" ":_model.contentModel.title;
    _titleLabel.frame = CGRectMake(kImageLeftSpace + kImageWidth + kImageRightSpace, kTitleLabelTopSpace, Screen_Width - kImageLeftSpace - _timeLabel.size.width - (kImageLeftSpace + kImageWidth + kImageRightSpace), kTitleLabelFontSize);
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel.text = !_model.contentModel.msg||[_model.contentModel.msg length] <= 0?@" ":_model.contentModel.msg;
    CGSize contentLabelSize = [_contentLabel sizeThatFits:CGSizeMake(Screen_Width - kImageLeftSpace - kImageWidth - kImageRightSpace - kImageLeftSpace, MAXFLOAT)];
    _contentLabel.frame = CGRectMake(kImageLeftSpace + kImageWidth + kImageRightSpace, kTitleLabelTopSpace + kTitleLabelFontSize + kContentLabelTopSpace, Screen_Width - kImageLeftSpace - kImageWidth - kImageRightSpace - kImageLeftSpace, contentLabelSize.height);
    [self.contentView addSubview:_contentLabel];
}

+ (CGFloat)getCXIDGMessageListTableViewCellHeightWithCXIDGMessageListModel:(CXIDGMessageListModel *)model
{
    UIImageView * leftImageView = [[UIImageView alloc] init];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    titleLabel.textColor = kTitleLabelTextColor;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    timeLabel.textColor = kTimeLabelTextColor;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
    contentLabel.textColor = kContentLabelTextColor;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    
    leftImageView.frame = CGRectMake(kImageLeftSpace, kImageTopSpace, kImageWidth, kImageWidth);
    
    timeLabel.text = !model.createTime||[model.createTime length] <= 0?@" ":model.createTime;
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(Screen_Width - kImageLeftSpace - timeLabel.size.width, kTitleLabelTopSpace + (kTitleLabelFontSize - kTimeLabelFontSize)/2, timeLabel.size.width, kTimeLabelFontSize);
    
    titleLabel.text = !model.contentModel.title||[model.contentModel.title length] <= 0?@" ":model.contentModel.title;
    titleLabel.frame = CGRectMake(kImageLeftSpace + kImageWidth + kImageRightSpace, kTitleLabelTopSpace, Screen_Width - kImageLeftSpace - timeLabel.size.width - (kImageLeftSpace + kImageWidth + kImageRightSpace), kTitleLabelFontSize);
    
    contentLabel.text = !model.contentModel.msg||[model.contentModel.msg length] <= 0?@" ":model.contentModel.msg;
    CGSize contentLabelSize = [contentLabel sizeThatFits:CGSizeMake(Screen_Width - kImageLeftSpace - kImageWidth - kImageRightSpace - kImageLeftSpace, MAXFLOAT)];
    contentLabel.frame = CGRectMake(kImageLeftSpace + kImageWidth + kImageRightSpace, kTitleLabelTopSpace + kTitleLabelFontSize + kContentLabelTopSpace, Screen_Width - kImageLeftSpace - kImageWidth - kImageRightSpace - kImageLeftSpace, contentLabelSize.height);
    
    return CGRectGetMaxY(contentLabel.frame) +kTitleLabelTopSpace;
}

@end
