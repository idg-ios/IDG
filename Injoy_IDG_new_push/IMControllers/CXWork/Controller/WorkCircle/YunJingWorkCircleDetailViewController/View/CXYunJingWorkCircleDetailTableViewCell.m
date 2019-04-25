//
//  CXYunJingWorkCircleDetailTableViewCell.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/23.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYunJingWorkCircleDetailTableViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDContactsDetailController.h"
#import "CXLoaclDataManager.h"

#define kWorkHeadImageWidth 40
#define kGrayBackGroundViewMoveLeft 3
#define kCellGrayBackGroundViewNeedLeftOffset 2.5
#define kWorkCircleDetailCommentTableViewCellHeight 100
#define kWorkHeadImageLeftSpace 10
#define kWorkCircleDetailCommentHeadLeftSpace (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace)

#define kNameLeftSpace 5.0
#define kNameMiddleSpace 5.0
#define kNameFontSize 15.0
#define kTimeFontSize 13.0
#define kWorkCircleDetailCommentHeadWidth (kNameFontSize + kNameMiddleSpace + kNameFontSize)
#define kCommentTextBottomSpace (10.0)
#define kNameTextColor [UIColor grayColor]
#define kTimeTextColor [UIColor grayColor]

@interface CXYunJingWorkCircleDetailTableViewCell()

@property (nonatomic, strong) CXWorkCircleDetailRecordModel * model;
@property (nonatomic, strong) UIView * grayBackGroundView;
@property (nonatomic, strong) UIImageView * commentHeadImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * nameBtn;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation CXYunJingWorkCircleDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_grayBackGroundView){
        [_grayBackGroundView removeFromSuperview];
        _grayBackGroundView = nil;
    }
    _grayBackGroundView = [[UIView alloc] init];
    _grayBackGroundView.backgroundColor = RGBACOLOR(243.0, 243.0, 245.0, 1.0);
    _grayBackGroundView.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace, 0, Screen_Width - kWorkCircleDetailCommentHeadLeftSpace - kWorkCircleDetailCommentHeadLeftSpace, 100);
    
    if(_commentHeadImageView){
        [_commentHeadImageView removeFromSuperview];
        _commentHeadImageView = nil;
    }
    _commentHeadImageView = [[UIImageView alloc] init];
    _commentHeadImageView.frame = CGRectMake(kWorkHeadImageLeftSpace, kWorkHeadImageLeftSpace, kWorkCircleDetailCommentHeadWidth, kWorkCircleDetailCommentHeadWidth);
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    _nameLabel.textColor = RGBACOLOR(91.0, 106.0, 140.0, 1.0);
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_nameBtn){
        [_nameBtn removeFromSuperview];
        _nameBtn = nil;
    }
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameBtn addTarget:self action:@selector(headImageViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeFontSize];
    _timeLabel.textColor = kTimeTextColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_commentLabel){
        [_commentLabel removeFromSuperview];
        _commentLabel = nil;
    }
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    _commentLabel.textColor = kNameTextColor;
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    _commentLabel.numberOfLines = 0;
    
    if(_bottomLineView){
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = RGBACOLOR(231.0, 231.0, 233.0, 1.0);
}

- (void)setCXWorkCircleDetailRecordModel:(CXWorkCircleDetailRecordModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _grayBackGroundView.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace, 0, Screen_Width - kWorkCircleDetailCommentHeadLeftSpace - kWorkHeadImageLeftSpace, [CXYunJingWorkCircleDetailTableViewCell getCellHeightWithCXWorkCircleDetailRecordModel:self.model] - 0.5);
    [self.contentView addSubview:_grayBackGroundView];
    
    NSString * month = [self.model.createTime substringToIndex:2];
    NSString * day = [self.model.createTime substringWithRange:NSMakeRange(3, 2)];
    NSString * hmTime = [self.model.createTime substringFromIndex:6];
    _timeLabel.text = [NSString stringWithFormat:@"%@月%@日 %@",month,day,hmTime];
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(CGRectGetWidth(_grayBackGroundView.frame) - kWorkHeadImageLeftSpace - _timeLabel.size.width, kWorkHeadImageLeftSpace, _timeLabel.size.width, kTimeFontSize);
    [_grayBackGroundView addSubview:_timeLabel];
    
    [self.commentHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.model.send_icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    self.commentHeadImageView.userInteractionEnabled = YES;
    [self.commentHeadImageView addGestureRecognizer:tap];
    [_grayBackGroundView addSubview:self.commentHeadImageView];
    
    _nameLabel.text = self.model.userName;
    
    _commentLabel.text = [NSString stringWithFormat:@"%@",self.model.remark];
    
    _nameLabel.frame = CGRectMake(kWorkHeadImageLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace, kWorkHeadImageLeftSpace, CGRectGetMinX(_timeLabel.frame) - (kWorkHeadImageLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace), kNameFontSize);
    _nameBtn.frame = _nameLabel.frame;
    [_grayBackGroundView addSubview:_nameLabel];
    [_grayBackGroundView addSubview:_nameBtn];
    
    CGSize commentLabelSize = [_commentLabel sizeThatFits:CGSizeMake((Screen_Width - kWorkCircleDetailCommentHeadLeftSpace - kWorkHeadImageLeftSpace) - kWorkHeadImageLeftSpace - (kWorkHeadImageLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace), LONG_MAX)];
    _commentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kNameMiddleSpace, commentLabelSize.width, commentLabelSize.height);
    [_grayBackGroundView addSubview:_commentLabel];
    
    _bottomLineView.frame = CGRectMake(0, [CXYunJingWorkCircleDetailTableViewCell getCellHeightWithCXWorkCircleDetailRecordModel:self.model] - 0.5, Screen_Width - kWorkCircleDetailCommentHeadLeftSpace - kWorkHeadImageLeftSpace, 0.5);
    [_grayBackGroundView addSubview:_bottomLineView];
}

+ (CGFloat)getCellHeightWithCXWorkCircleDetailRecordModel:(CXWorkCircleDetailRecordModel *)model
{
    UILabel * commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    commentLabel.textColor = kNameTextColor;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.numberOfLines = 0;
    commentLabel.text = [NSString stringWithFormat:@"%@",model.remark];
    CGSize commentLabelSize = [commentLabel sizeThatFits:CGSizeMake((Screen_Width - kWorkCircleDetailCommentHeadLeftSpace - kWorkHeadImageLeftSpace) - kWorkHeadImageLeftSpace - (kWorkHeadImageLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace), LONG_MAX)];
    CGFloat height = kWorkHeadImageLeftSpace + kNameFontSize + kNameMiddleSpace + commentLabelSize.height + kCommentTextBottomSpace;
    return height;
}

- (void)headImageViewClick
{
    NSLog(@"%@",VAL_HXACCOUNT);
    if([_model.imAccount isEqualToString:VAL_HXACCOUNT]){
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
        pivc.imAccount = _model.imAccount;
        [[self viewController].navigationController pushViewController:pivc animated:YES];
        if ([[self viewController].navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self viewController].navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = _model.imAccount;
        pivc.canPopViewController = YES;
        [[self viewController].navigationController pushViewController:pivc animated:YES];
        if ([[self viewController].navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self viewController].navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

@end
