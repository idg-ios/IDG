//
//  GSXWListCell.m
//  InjoyIDG
//
//  Created by wtz on 2019/1/17.
//  Copyright © 2019年 Injoy. All rights reserved.
//

#import "GSXWListCell.h"
#import "UIView+Category.h"
#import "UIImageView+EMWebCache.h"

#define kTimeLabelFontSize 12.0
#define kTimeLabelTextColor RGBACOLOR(151.0, 159.0, 169.0, 1.0)
#define kTimeLabelTopSpace 20.0
#define kTimeLabelMargin 4.0
#define kTimeBackViewTopSpace (kTimeLabelTopSpace - kTimeLabelMargin)
#define kTimeLabelBottomSpace 12.0
#define kWhiteBackViewLeftSpace 15.0
#define kTitleLabelLeftSpace 15.0
#define kTitleLabelFontSize 18.0
#define kTitleLabelTextColor RGBACOLOR(50.0, 50.0, 50.0, 1.0)
#define kDigestLabelFontSize 14.0
#define kDigestLabelTextColor RGBACOLOR(48.0, 51.0, 56.0, 1.0)
#define kReadAllLabelFontSize 14.0
#define kReadAllLabelTextColor RGBACOLOR(140.0, 159.0, 169.0, 1.0)

#define kDigestLabelBottomSpace 17.0

@interface GSXWListCell()

@property (nonatomic, strong) CXGSXWListModel * model;
@property (nonatomic, strong) UIView * timeBackView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * whiteBackView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * thumb_urlImageView;
@property (nonatomic, strong) UILabel * digestLabel;
@property (nonatomic, strong) UIView * middleLineView;
@property (nonatomic, strong) UILabel * readAllLabel;
@property (nonatomic, strong) UIImageView * detailImageView;


@end

@implementation GSXWListCell
//新版的图片比例  1068:598

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_timeBackView){
        [_timeBackView removeFromSuperview];
        _timeBackView = nil;
    }
    _timeBackView = [[UIView alloc] init];
    _timeBackView.backgroundColor = RGBACOLOR(237.0, 238.0, 240.0, 1.0);
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    _timeLabel.textColor = kTimeLabelTextColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_whiteBackView){
        [_whiteBackView removeFromSuperview];
        _whiteBackView = nil;
    }
    _whiteBackView = [[UIView alloc] init];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    _whiteBackView.layer.cornerRadius = 5.0;
    _whiteBackView.clipsToBounds = YES;
    _whiteBackView.layer.borderWidth = 0.5;
    _whiteBackView.layer.borderColor = RGBACOLOR(238.0, 237.0, 237.0, 1.0).CGColor;
    
    
    if(_titleLabel){
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    _titleLabel.textColor = kTitleLabelTextColor;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_thumb_urlImageView){
        [_thumb_urlImageView removeFromSuperview];
        _thumb_urlImageView = nil;
    }
    _thumb_urlImageView = [[UIImageView alloc] init];
    
    if(_digestLabel){
        [_digestLabel removeFromSuperview];
        _digestLabel = nil;
    }
    _digestLabel = [[UILabel alloc] init];
    _digestLabel.font = [UIFont systemFontOfSize:kDigestLabelFontSize];
    _digestLabel.textColor = kDigestLabelTextColor;
    _digestLabel.numberOfLines = 0;
    _digestLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _digestLabel.backgroundColor = [UIColor clearColor];
    _digestLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_middleLineView){
        [_middleLineView removeFromSuperview];
        _middleLineView = nil;
    }
    _middleLineView = [[UIView alloc] init];
    _middleLineView.backgroundColor = RGBACOLOR(238.0, 237.0, 237.0, 1.0);
    
    if(_readAllLabel){
        [_readAllLabel removeFromSuperview];
        _readAllLabel = nil;
    }
    _readAllLabel = [[UILabel alloc] init];
    _readAllLabel.font = [UIFont systemFontOfSize:kReadAllLabelFontSize];
    _readAllLabel.textColor = kReadAllLabelTextColor;
    _readAllLabel.backgroundColor = [UIColor clearColor];
    _readAllLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_detailImageView){
        [_detailImageView removeFromSuperview];
        _detailImageView = nil;
    }
    _detailImageView = [[UIImageView alloc] init];
}

- (void)setCXIDGNewTZGGListModel:(CXGSXWListModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _timeLabel.text = _model.createTime?_model.createTime:@" ";
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake((Screen_Width - _timeLabel.size.width)/2, kTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
    
    _timeBackView.frame = CGRectMake((Screen_Width - _timeLabel.size.width)/2 - kTimeLabelMargin, kTimeBackViewTopSpace, _timeLabel.size.width + 2*kTimeLabelMargin, kTimeLabelFontSize + 2*kTimeLabelMargin);
    
    [self.contentView addSubview:_timeBackView];
    [self.contentView addSubview:_timeLabel];
    
    if(_model.cover && [_model.cover length] > 0){
        [_thumb_urlImageView sd_setImageWithURL:[NSURL URLWithString:(_model.cover && ![_model.cover isKindOfClass:[NSNull class]])?_model.cover:@""] placeholderImage:[UIImage imageNamed:@""] options:EMSDWebImageRetryFailed];
        _thumb_urlImageView.frame = CGRectMake(0, 0, Screen_Width - 2*kWhiteBackViewLeftSpace, ([@(598.0) doubleValue] * (Screen_Width - 2*kWhiteBackViewLeftSpace)/[@(1068.0) doubleValue]));
        [_whiteBackView addSubview:_thumb_urlImageView];
        
        _titleLabel.text = !_model.title||[_model.title length] <= 0?@" ":_model.title;
        CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        _titleLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_thumb_urlImageView.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, titleLabelSize.height);
        [_whiteBackView addSubview:_titleLabel];
        
        _digestLabel.text = @" ";
        _digestLabel.frame = CGRectZero;
        
        _middleLineView.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_titleLabel.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, 0.5);
        [_whiteBackView addSubview:_middleLineView];
        
        _readAllLabel.text = !_model.remark||[_model.remark length] <= 0?@" ":_model.remark;
        [_readAllLabel sizeToFit];
        _readAllLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_middleLineView.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace - 6.0 - 7.0, kReadAllLabelFontSize);
        [_whiteBackView addSubview:_readAllLabel];
        
        _detailImageView.image = [UIImage imageNamed:@"DetailImage"];
        _detailImageView.highlightedImage = [UIImage imageNamed:@"DetailImage"];
        _detailImageView.frame = CGRectMake(Screen_Width - 2*kWhiteBackViewLeftSpace - kTitleLabelLeftSpace - 6.0, CGRectGetMinY(_readAllLabel.frame) + 1.0, 6.0, 12.0);
        [_whiteBackView addSubview:_detailImageView];
    }else{
        _thumb_urlImageView.frame = CGRectZero;
        
        _titleLabel.text = !_model.title||[_model.title length] <= 0?@" ":_model.title;
        CGSize titleLabelSize = [_titleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        _titleLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_thumb_urlImageView.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, titleLabelSize.height);
        [_whiteBackView addSubview:_titleLabel];
        
        _digestLabel.text = !_model.remark||[_model.remark length] <= 0?@" ":_model.remark;
        CGSize digestLabelSize = [_digestLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        _digestLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_titleLabel.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, digestLabelSize.height);
        [_whiteBackView addSubview:_digestLabel];
        
        _middleLineView.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_digestLabel.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, 0.5);
        [_whiteBackView addSubview:_middleLineView];
        
        _readAllLabel.text = @"查看全文";
        [_readAllLabel sizeToFit];
        _readAllLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(_middleLineView.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace - 6.0 - 7.0, kReadAllLabelFontSize);
        [_whiteBackView addSubview:_readAllLabel];
        
        _detailImageView.image = [UIImage imageNamed:@"DetailImage"];
        _detailImageView.highlightedImage = [UIImage imageNamed:@"DetailImage"];
        _detailImageView.frame = CGRectMake(Screen_Width - 2*kWhiteBackViewLeftSpace - kTitleLabelLeftSpace - 6.0, CGRectGetMinY(_readAllLabel.frame) + 1.0, 6.0, 12.0);
        [_whiteBackView addSubview:_detailImageView];
    }
    
    _whiteBackView.frame = CGRectMake(kWhiteBackViewLeftSpace, CGRectGetMaxY(_timeBackView.frame) + kTimeLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace, CGRectGetMaxY(_readAllLabel.frame) + kDigestLabelBottomSpace);
    [self.contentView addSubview:_whiteBackView];
}

+ (CGFloat)getCXIDGNewTZGGListTableViewCellHeightWithCXIDGNewTZGGListModel:(CXGSXWListModel *)model
{
    UIView * timeBackView = [[UIView alloc] init];
    timeBackView.backgroundColor = RGBACOLOR(192.0, 192.0, 192.0, 1.0);
    
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    timeLabel.textColor = kTimeLabelTextColor;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * whiteBackView = [[UIView alloc] init];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.layer.cornerRadius = 3.0;
    whiteBackView.clipsToBounds = YES;
    whiteBackView.layer.borderWidth = 1.0;
    whiteBackView.layer.borderColor = RGBACOLOR(213.0, 213.0, 213.0, 1.0).CGColor;
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
    titleLabel.textColor = kTitleLabelTextColor;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView * thumb_urlImageView = [[UIImageView alloc] init];
    
    UILabel * digestLabel = [[UILabel alloc] init];
    digestLabel.font = [UIFont systemFontOfSize:kDigestLabelFontSize];
    digestLabel.textColor = kDigestLabelTextColor;
    digestLabel.numberOfLines = 0;
    digestLabel.lineBreakMode = NSLineBreakByWordWrapping;
    digestLabel.backgroundColor = [UIColor clearColor];
    digestLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView * middleLineView = [[UIView alloc] init];
    middleLineView.backgroundColor = RGBACOLOR(238.0, 238.0, 238.0, 1.0);
    
    UILabel * readAllLabel = [[UILabel alloc] init];
    readAllLabel.font = [UIFont systemFontOfSize:kReadAllLabelFontSize];
    readAllLabel.textColor = kReadAllLabelTextColor;
    readAllLabel.backgroundColor = [UIColor clearColor];
    readAllLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView * detailImageView = [[UIImageView alloc] init];
    
    timeLabel.text = model.createTime?model.createTime:@" ";
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake((Screen_Width - timeLabel.size.width)/2, kTimeLabelTopSpace, timeLabel.size.width, kTimeLabelFontSize);
    
    timeBackView.frame = CGRectMake((Screen_Width - timeLabel.size.width)/2 - kTimeLabelMargin, kTimeBackViewTopSpace, timeLabel.size.width + 2*kTimeLabelMargin, kTimeLabelFontSize + 2*kTimeLabelMargin);
    
    if(model.cover && [model.cover length] > 0){
        [thumb_urlImageView sd_setImageWithURL:[NSURL URLWithString:(model.cover && ![model.cover isKindOfClass:[NSNull class]])?model.cover:@""] placeholderImage:[UIImage imageNamed:@""] options:EMSDWebImageRetryFailed];
        thumb_urlImageView.frame = CGRectMake(0, 0, Screen_Width - 2*kWhiteBackViewLeftSpace, ([@(598.0) doubleValue] * (Screen_Width - 2*kWhiteBackViewLeftSpace)/[@(1068.0) doubleValue]));
        
        titleLabel.text = !model.title||[model.title length] <= 0?@" ":model.title;
        CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        titleLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(thumb_urlImageView.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, titleLabelSize.height);
        
        middleLineView.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(titleLabel.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, 0.5);
        
        readAllLabel.text = !model.remark||[model.remark length] <= 0?@" ":model.remark;
        [readAllLabel sizeToFit];
        readAllLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(middleLineView.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace - 6.0 - 7.0, kReadAllLabelFontSize);
        
        detailImageView.image = [UIImage imageNamed:@"DetailImage"];
        detailImageView.highlightedImage = [UIImage imageNamed:@"DetailImage"];
        detailImageView.frame = CGRectMake(Screen_Width - 2*kWhiteBackViewLeftSpace - kTitleLabelLeftSpace - 6.0, CGRectGetMinY(readAllLabel.frame) + 1.0, 6.0, 12.0);
    }else{
        thumb_urlImageView.frame = CGRectZero;
        
        titleLabel.text = !model.title||[model.title length] <= 0?@" ":model.title;
        CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        titleLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(thumb_urlImageView.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, titleLabelSize.height);
        
        digestLabel.text = !model.remark||[model.remark length] <= 0?@" ":model.remark;
        CGSize digestLabelSize = [digestLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, MAXFLOAT)];
        digestLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(titleLabel.frame) + kTimeLabelTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, digestLabelSize.height);
        
        middleLineView.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(digestLabel.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace, 0.5);
        
        readAllLabel.text = @"查看全文";
        [readAllLabel sizeToFit];
        readAllLabel.frame = CGRectMake(kTitleLabelLeftSpace, CGRectGetMaxY(middleLineView.frame) + kDigestLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kTitleLabelLeftSpace - 6.0 - 7.0, kReadAllLabelFontSize);
        
        detailImageView.image = [UIImage imageNamed:@"DetailImage"];
        detailImageView.highlightedImage = [UIImage imageNamed:@"DetailImage"];
        detailImageView.frame = CGRectMake(Screen_Width - 2*kWhiteBackViewLeftSpace - kTitleLabelLeftSpace - 6.0, CGRectGetMinY(readAllLabel.frame) + 1.0, 6.0, 12.0);
    }
    
    whiteBackView.frame = CGRectMake(kWhiteBackViewLeftSpace, CGRectGetMaxY(timeBackView.frame) + kTimeLabelBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace, CGRectGetMaxY(readAllLabel.frame) + kDigestLabelBottomSpace);
    
    return CGRectGetMaxY(whiteBackView.frame);
}
@end
