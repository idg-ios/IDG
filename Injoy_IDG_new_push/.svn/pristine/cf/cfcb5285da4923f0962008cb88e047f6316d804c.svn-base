//
//  CXWorkCircleDetailCommentCell.m
//  InjoyERP
//
//  Created by wtz on 16/11/25.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXWorkCircleDetailCommentCell.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"

#define kWorkHeadImageWidth 40
#define kGrayBackGroundViewMoveLeft 3
#define kCellGrayBackGroundViewNeedLeftOffset 2.5
#define kWorkCircleDetailCommentTableViewCellHeight 100
#define kWorkCircleDetailCommentHeadLeftSpace 10
#define kNameLeftSpace 5.0
#define kNameMiddleSpace 3.0
#define kNameFontSize 15.0
#define kTimeFontSize 13.0
#define kWorkCircleDetailCommentHeadWidth (kNameFontSize + kNameMiddleSpace + kNameFontSize)
#define kCommentTextBottomSpace (10.0)
#define kNameTextColor [UIColor grayColor]
#define kTimeTextColor [UIColor grayColor]

@interface CXWorkCircleDetailCommentCell()

@property (nonatomic, strong) CXWorkCircleDetailCommentModel * model;
@property (nonatomic, strong) UIView * grayBackGroundView;
@property (nonatomic, strong) UIImageView * commentHeadImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * commentLabel;


@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation CXWorkCircleDetailCommentCell

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
    _grayBackGroundView.backgroundColor = RGBACOLOR(242.0, 241.0, 246.0, 1.0);
    _grayBackGroundView.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft- kCellGrayBackGroundViewNeedLeftOffset, 0, Screen_Width - (kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkCircleDetailCommentHeadLeftSpace, 100);
    
    if(_commentHeadImageView){
        [_commentHeadImageView removeFromSuperview];
        _commentHeadImageView = nil;
    }
    _commentHeadImageView = [[UIImageView alloc] init];
    _commentHeadImageView.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace, kWorkCircleDetailCommentHeadLeftSpace, kWorkCircleDetailCommentHeadWidth, kWorkCircleDetailCommentHeadWidth);
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    _nameLabel.textColor = kNameTextColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
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
    _bottomLineView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setCXWorkCircleDetailCommentModel:(CXWorkCircleDetailCommentModel *)model
{
    _model = model;
    [self layoutUI];
}

- (void)layoutUI
{
    _grayBackGroundView.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kCellGrayBackGroundViewNeedLeftOffset, 0, Screen_Width - (kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkCircleDetailCommentHeadLeftSpace, [CXWorkCircleDetailCommentCell getCellHeightWithCXWorkCircleDetailCommentModel:self.model] - 1);
    [self.contentView addSubview:_grayBackGroundView];
    
    _timeLabel.text = self.model.createTime;
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(CGRectGetWidth(_grayBackGroundView.frame) - kWorkCircleDetailCommentHeadLeftSpace - _timeLabel.size.width, kWorkCircleDetailCommentHeadLeftSpace, _timeLabel.size.width, kTimeFontSize);
    [_grayBackGroundView addSubview:_timeLabel];
    
    if(self.model.commentByUserIcon != nil && [self.model.commentByUserIcon length] > 0){
        [self.commentHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.model.commentByUserIcon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [_grayBackGroundView addSubview:self.commentHeadImageView];
        
        _nameLabel.text = self.model.commentByUserName;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@：%@",self.model.commentUserName,self.model.commentText]];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(2, self.model.commentUserName.length)];
        _commentLabel.attributedText = text;
    }else{
        [self.commentHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.model.commentUserIcon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        [_grayBackGroundView addSubview:self.commentHeadImageView];
        
        _nameLabel.text = self.model.commentUserName;
        
        _commentLabel.text = [NSString stringWithFormat:@"%@",self.model.commentText];
    }
    
    _nameLabel.frame = CGRectMake(kWorkCircleDetailCommentHeadLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace, kWorkCircleDetailCommentHeadLeftSpace, CGRectGetMinX(_timeLabel.frame) - (kWorkCircleDetailCommentHeadLeftSpace + kWorkCircleDetailCommentHeadWidth + kNameLeftSpace), kNameFontSize);
    [_grayBackGroundView addSubview:_nameLabel];
    
    CGSize commentLabelSize = [_commentLabel sizeThatFits:CGSizeMake(Screen_Width - (kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkCircleDetailCommentHeadLeftSpace - kWorkCircleDetailCommentHeadLeftSpace - kWorkCircleDetailCommentHeadWidth - kNameLeftSpace - kWorkCircleDetailCommentHeadLeftSpace, LONG_MAX)];
    _commentLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + kNameMiddleSpace, commentLabelSize.width, commentLabelSize.height);
    [_grayBackGroundView addSubview:_commentLabel];
    
    _bottomLineView.frame = CGRectMake(0, [CXWorkCircleDetailCommentCell getCellHeightWithCXWorkCircleDetailCommentModel:self.model] - 1, Screen_Width - (kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkCircleDetailCommentHeadLeftSpace, 1);
    [_grayBackGroundView addSubview:_bottomLineView];
}

+ (CGFloat)getCellHeightWithCXWorkCircleDetailCommentModel:(CXWorkCircleDetailCommentModel *)model
{
    UILabel * commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    commentLabel.textColor = kNameTextColor;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.numberOfLines = 0;
    if(model.commentByUserIcon != nil && [model.commentByUserIcon length] > 0){
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@：%@",model.commentUserName,model.commentText]];
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor orangeColor]
                     range:NSMakeRange(2, model.commentUserName.length)];
        commentLabel.attributedText = text;
    }else{
        commentLabel.text = [NSString stringWithFormat:@"%@",model.commentText];
    }
    CGSize commentLabelSize = [commentLabel sizeThatFits:CGSizeMake(Screen_Width - (kWorkCircleDetailCommentHeadLeftSpace + kWorkHeadImageWidth + kWorkCircleDetailCommentHeadLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkCircleDetailCommentHeadLeftSpace - kWorkCircleDetailCommentHeadLeftSpace - kWorkCircleDetailCommentHeadWidth - kNameLeftSpace - kWorkCircleDetailCommentHeadLeftSpace, LONG_MAX)];
    CGFloat height = kWorkCircleDetailCommentHeadLeftSpace + kNameFontSize + kNameMiddleSpace + commentLabelSize.height + kCommentTextBottomSpace;
    return height;
}

@end
