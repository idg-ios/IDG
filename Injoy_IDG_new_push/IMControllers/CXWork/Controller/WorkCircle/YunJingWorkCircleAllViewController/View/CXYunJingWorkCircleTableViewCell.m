//
//  CXYunJingWorkCircleTableViewCell.m
//  InjoyYJ1
//
//  Created by wtz on 2017/8/22.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXYunJingWorkCircleTableViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"
#import "CXYunJingWorkCircleAllViewController.h"
#import "HttpTool.h"
#import "CXLoaclDataManager.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDContactsDetailController.h"

#define kWorkHeadImageLeftSpace 10
#define kWorkHeadImageTopSpace 15
#define kWorkHeadImageWidth 40
#define kNameLabelFontSize 15.0
#define kContentLabelFontSize 15.0
#define kTimeLabelFontSize 12.0
#define kTextColor RGBACOLOR(72.0, 71.0, 76.0, 1.0)
#define kContentLabelTopSpace 10.0
#define kContentLabelLeftSpace 0.0
#define kShowAllBtnFontSize 15.0
#define kShowAllBtnLeftOffset 3.0
#define kShowAllBtnLeftSpace 5.0
#define kShowAllBtnWidth 38.0
#define kShowAllBtnHeight 16.0
#define kWorkTimeLabelTopSpace 10.0
#define kWorkTimeLabelBottomSpace 15

#define kOpinionBtnImageWidth 22
#define kOpinionBtnImageHeight 14
#define kOpinionBackGroundViewCornerRadius 5.0
#define kOpinionBackGroundViewWidth 208
#define kOpinionBackGroundViewHeight 33
#define kOpinionBackGroundViewSpace 1

#define kOpinionBackGroundViewImageLeftSpace 10
#define kOpinionBackGroundViewImageWidth 13
#define kOpinionBackGroundViewMiddleSpace 5
#define kOpinionBackGroundViewLabelFont kOpinionBackGroundViewImageWidth
#define kOpinionBackGroundViewLabelTextColor [UIColor whiteColor]
#define kOpinionBackGroundViewLineTopSpace 5

#define kSelfOpinionBackGroundViewWidth 64.0

#define kIsReadRedViewWidth 12.0

#define kMaxContentHeight 50.0

@interface CXYunJingWorkCircleTableViewCell()

@property (nonatomic, strong) NSString * allContent;

@property (nonatomic, strong) CXAllPeoplleWorkCircleModel * model;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UIButton * nameBtn;

@property (nonatomic, strong) UIView * isReadRedView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * showAllBtn;


@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * opinionBackGroundView;
@property (nonatomic, strong) UIButton * opinionBtn;
@property (nonatomic, strong) UIView * bottomLineView;

@property (nonatomic, strong) UIImageView * agreeImageView;
@property (nonatomic, strong) UILabel * agreeLabel;
@property (nonatomic, strong) UIButton * agreeBtn;
@property (nonatomic, strong) UIView * firstLineView;

@property (nonatomic, strong) UIImageView * refuseImageView;
@property (nonatomic, strong) UILabel * refuseLabel;
@property (nonatomic, strong) UIButton * refuseBtn;
@property (nonatomic, strong) UIView * secondLineView;

@property (nonatomic, strong) UIImageView * commentImageView;
@property (nonatomic, strong) UILabel * commentLabel;
@property (nonatomic, strong) UIButton * commentBtn;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end

@implementation CXYunJingWorkCircleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
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
    _headImageView.frame = CGRectMake(kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, kWorkHeadImageWidth, kWorkHeadImageWidth);
    
    if(_isReadRedView){
        [_isReadRedView removeFromSuperview];
        _isReadRedView = nil;
    }
    _isReadRedView = [[UIView alloc] init];
    _isReadRedView.backgroundColor = [UIColor redColor];
    _isReadRedView.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) - kIsReadRedViewWidth/2, CGRectGetMinY(_headImageView.frame) - kIsReadRedViewWidth/2, kIsReadRedViewWidth, kIsReadRedViewWidth);
    _isReadRedView.layer.cornerRadius = kIsReadRedViewWidth/2;
    _isReadRedView.clipsToBounds = YES;
    _isReadRedView.hidden = YES;
    
    
    if(_nameLabel){
        [_nameLabel removeFromSuperview];
        _nameLabel = nil;
    }
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
    _nameLabel.textColor = RGBACOLOR(91.0, 106.0, 140.0, 1.0);
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_nameBtn){
        [_nameBtn removeFromSuperview];
        _nameBtn = nil;
    }
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameBtn addTarget:self action:@selector(headImageViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_contentLabel){
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_showAllBtn){
        [_showAllBtn removeFromSuperview];
        _showAllBtn = nil;
    }
    _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showAllBtn.selected = NO;
    [_showAllBtn addTarget:self action:@selector(showAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    _timeLabel.textColor = RGBACOLOR(143.0, 143.0, 143.0, 1.0);
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionBtn){
        [_opinionBtn removeFromSuperview];
        _opinionBtn = nil;
    }
    _opinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _opinionBtn.selected = NO;
    [_opinionBtn addTarget:self action:@selector(opinionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.type = LessAllShowCellType;
}

- (void)setCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model AndNSIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _opinionBtn.selected = NO;
    _opinionBackGroundView.hidden = YES;
    self.indexPath = indexPath;
    if((model.isReder && ![model.isReder isKindOfClass:[NSNull class]] && [model.isReder integerValue] == 1) || model.userId.integerValue == [VAL_USERID integerValue]){
        _isReadRedView.hidden = YES;
    }else{
        _isReadRedView.hidden = NO;
    }
    [self layoutUI];
}

- (void)layoutUI
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.send_icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewClick)];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",_model.send_name];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, _nameLabel.size.width, kNameLabelFontSize);
    [self.contentView addSubview:_nameLabel];
    
    _nameBtn.frame = _nameLabel.frame;
    [self.contentView addSubview:_nameBtn];
    
    self.allContent = _model.remark;
    _contentLabel.text = self.allContent;
    _contentLabel.size = CGSizeMake(Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), MAXFLOAT);
    [_contentLabel sizeToFit];
    
    if(self.type == LessAllShowCellType){
        if(_contentLabel.size.height > kMaxContentHeight){
            self.type = MoreNotAllShowCellType;
        }else{
            self.type = LessAllShowCellType;
        }
    }
    if(self.type == MoreNotAllShowCellType){
        _contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), kMaxContentHeight);
        
        _showAllBtn.hidden = NO;
        _showAllBtn.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace - kShowAllBtnLeftOffset), CGRectGetMaxY(_contentLabel.frame) + kShowAllBtnLeftSpace, kShowAllBtnWidth, kShowAllBtnHeight);
        [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
        [_showAllBtn setTitle:@"全文" forState:UIControlStateHighlighted];
        [_showAllBtn setTitleColor:RGBACOLOR(87.0, 105.0, 163.0, 1.0) forState:UIControlStateNormal];
        [_showAllBtn setTitleColor:RGBACOLOR(87.0, 105.0, 163.0, 1.0) forState:UIControlStateHighlighted];
        _showAllBtn.titleLabel.font = [UIFont systemFontOfSize:kShowAllBtnFontSize];
        //下面有全部按钮，点击换self.type = MoreAllShowCellType，刷新cell
    }else if(self.type == MoreAllShowCellType){
        _contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), _contentLabel.size.height);
        
        _showAllBtn.hidden = NO;
        _showAllBtn.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace - kShowAllBtnLeftOffset), CGRectGetMaxY(_contentLabel.frame) + kShowAllBtnLeftSpace, kShowAllBtnWidth, kShowAllBtnHeight);
        _showAllBtn.titleLabel.text = @"收起";
        [_showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
        [_showAllBtn setTitle:@"收起" forState:UIControlStateHighlighted];
        [_showAllBtn setTitleColor:RGBACOLOR(87.0, 105.0, 163.0, 1.0) forState:UIControlStateNormal];
        [_showAllBtn setTitleColor:RGBACOLOR(87.0, 105.0, 163.0, 1.0) forState:UIControlStateHighlighted];
        _showAllBtn.titleLabel.font = [UIFont systemFontOfSize:kShowAllBtnFontSize];
        //下面有收起按钮，点击换self.type = MoreNotAllShowCellType，刷新cell
    }else if(self.type == LessAllShowCellType){
        _contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), _contentLabel.size.height);
        
        _showAllBtn.hidden = YES;
    }
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_showAllBtn];
    
    _timeLabel.text = self.model.createTime;
    [_timeLabel sizeToFit];
    if(self.type == MoreNotAllShowCellType || self.type == MoreAllShowCellType){
        _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, CGRectGetMaxY(_showAllBtn.frame) + kWorkTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
    }else{
        _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, CGRectGetMaxY(_contentLabel.frame) + kWorkTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
    }
    [self.contentView addSubview:_timeLabel];
    
    if(self.type == MoreNotAllShowCellType || self.type == MoreAllShowCellType){
        _opinionBtn.frame = CGRectMake(Screen_Width - kWorkHeadImageLeftSpace - kOpinionBtnImageWidth, CGRectGetMaxY(_showAllBtn.frame) + kWorkTimeLabelTopSpace - (kOpinionBtnImageHeight - kTimeLabelFontSize)/2, kOpinionBtnImageWidth, kOpinionBtnImageHeight);
    }else{
        _opinionBtn.frame = CGRectMake(Screen_Width - kWorkHeadImageLeftSpace - kOpinionBtnImageWidth, CGRectGetMaxY(_contentLabel.frame) + kWorkTimeLabelTopSpace - (kOpinionBtnImageHeight - kTimeLabelFontSize)/2, kOpinionBtnImageWidth, kOpinionBtnImageHeight);
    }
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateNormal];
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateHighlighted];
    [_opinionBtn setBackgroundImage:[UIImage imageNamed:@"opinionBtnImage"] forState:UIControlStateSelected];
    [self.contentView addSubview:_opinionBtn];
    
    if(_opinionBackGroundView){
        [_opinionBackGroundView removeFromSuperview];
        _opinionBackGroundView = nil;
    }
    _opinionBackGroundView = [[UIView alloc] init];
    _opinionBackGroundView.backgroundColor = RGBACOLOR(77.0, 82.0, 84.0, 1.0);
    _opinionBackGroundView.layer.cornerRadius = kOpinionBackGroundViewCornerRadius;
    _opinionBackGroundView.clipsToBounds = YES;
    _opinionBackGroundView.hidden = YES;
    
    if(_bottomLineView){
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(_timeLabel.frame) + kWorkTimeLabelBottomSpace, Screen_Width, 1);
    _bottomLineView.backgroundColor = RGBACOLOR(231.0, 231.0, 233.0, 1.0);
    
    if(true){
        if(self.type == MoreNotAllShowCellType || self.type == MoreAllShowCellType){
            _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kSelfOpinionBackGroundViewWidth, CGRectGetMaxY(_showAllBtn.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kSelfOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
            
        }else{
            _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kSelfOpinionBackGroundViewWidth, CGRectGetMaxY(_contentLabel.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kSelfOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
            
        }
        
        if(_commentImageView){
            [_commentImageView removeFromSuperview];
            _commentImageView = nil;
        }
        _commentImageView = [[UIImageView alloc] init];
        _commentImageView.image = [UIImage imageNamed:@"commentBtnImage"];
        _commentImageView.highlightedImage = [UIImage imageNamed:@"commentBtnImage"];
        _commentImageView.frame = CGRectMake(kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
        [_opinionBackGroundView addSubview:_commentImageView];
        
        if(_commentLabel){
            [_commentLabel removeFromSuperview];
            _commentLabel = nil;
        }
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
        _commentLabel.textColor = kOpinionBackGroundViewLabelTextColor;
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        _commentLabel.text = @"意见";
        [_commentLabel sizeToFit];
        _commentLabel.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _commentLabel.size.width, kOpinionBackGroundViewLabelFont);
        [_opinionBackGroundView addSubview:_commentLabel];
        
        if(_commentBtn){
            [_commentBtn removeFromSuperview];
            _commentBtn = nil;
        }
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(0, 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _commentLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_opinionBackGroundView addSubview:_commentBtn];
        
    }else{
        if(self.type == MoreNotAllShowCellType || self.type == MoreAllShowCellType){
            _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kOpinionBackGroundViewWidth, CGRectGetMaxY(_showAllBtn.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
            
        }else{
            _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kOpinionBackGroundViewWidth, CGRectGetMaxY(_contentLabel.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
            
        }
        
        if(_agreeImageView){
            [_agreeImageView removeFromSuperview];
            _agreeImageView = nil;
        }
        _agreeImageView = [[UIImageView alloc] init];
        _agreeImageView.image = [UIImage imageNamed:@"agreeBtnImage"];
        _agreeImageView.highlightedImage = [UIImage imageNamed:@"agreeBtnImage"];
        _agreeImageView.frame = CGRectMake(kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
        [_opinionBackGroundView addSubview:_agreeImageView];
        
        if(_agreeLabel){
            [_agreeLabel removeFromSuperview];
            _agreeLabel = nil;
        }
        _agreeLabel = [[UILabel alloc] init];
        _agreeLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
        _agreeLabel.textColor = kOpinionBackGroundViewLabelTextColor;
        _agreeLabel.backgroundColor = [UIColor clearColor];
        _agreeLabel.textAlignment = NSTextAlignmentLeft;
        _agreeLabel.text = @"同意";
        [_agreeLabel sizeToFit];
        _agreeLabel.frame = CGRectMake(CGRectGetMaxX(_agreeImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _agreeLabel.size.width, kOpinionBackGroundViewLabelFont);
        [_opinionBackGroundView addSubview:_agreeLabel];
        
        if(_agreeBtn){
            [_agreeBtn removeFromSuperview];
            _agreeBtn = nil;
        }
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.frame = CGRectMake(0, 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _agreeLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
        [_agreeBtn addTarget:self action:@selector(aggreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_opinionBackGroundView addSubview:_agreeBtn];
        
        if(_firstLineView){
            [_firstLineView removeFromSuperview];
            _firstLineView = nil;
        }
        _firstLineView = [[UIView alloc] init];
        _firstLineView.backgroundColor = [UIColor blackColor];
        _firstLineView.frame = CGRectMake(CGRectGetMaxX(_agreeLabel.frame) + kOpinionBackGroundViewImageLeftSpace + 1, kOpinionBackGroundViewLineTopSpace, 1, kOpinionBackGroundViewHeight - 2*kOpinionBackGroundViewLineTopSpace);
        [_opinionBackGroundView addSubview:_firstLineView];
        
        if(_refuseImageView){
            [_refuseImageView removeFromSuperview];
            _refuseImageView = nil;
        }
        _refuseImageView = [[UIImageView alloc] init];
        _refuseImageView.image = [UIImage imageNamed:@"refuseBtnImage"];
        _refuseImageView.highlightedImage = [UIImage imageNamed:@"refuseBtnImage"];
        _refuseImageView.frame = CGRectMake(CGRectGetMaxX(_firstLineView.frame) + kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
        [_opinionBackGroundView addSubview:_refuseImageView];
        
        if(_refuseLabel){
            [_refuseLabel removeFromSuperview];
            _refuseLabel = nil;
        }
        _refuseLabel = [[UILabel alloc] init];
        _refuseLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
        _refuseLabel.textColor = kOpinionBackGroundViewLabelTextColor;
        _refuseLabel.backgroundColor = [UIColor clearColor];
        _refuseLabel.textAlignment = NSTextAlignmentLeft;
        _refuseLabel.text = @"不同意";
        [_refuseLabel sizeToFit];
        _refuseLabel.frame = CGRectMake(CGRectGetMaxX(_refuseImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _refuseLabel.size.width, kOpinionBackGroundViewLabelFont);
        [_opinionBackGroundView addSubview:_refuseLabel];
        
        if(_refuseBtn){
            [_refuseBtn removeFromSuperview];
            _refuseBtn = nil;
        }
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.frame = CGRectMake(CGRectGetMaxX(_firstLineView.frame), 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _refuseLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
        [_refuseBtn addTarget:self action:@selector(refuseBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_opinionBackGroundView addSubview:_refuseBtn];
        
        if(_secondLineView){
            [_secondLineView removeFromSuperview];
            _secondLineView = nil;
        }
        _secondLineView = [[UIView alloc] init];
        _secondLineView.backgroundColor = [UIColor blackColor];
        _secondLineView.frame = CGRectMake(CGRectGetMaxX(_refuseLabel.frame) + kOpinionBackGroundViewImageLeftSpace + 1, kOpinionBackGroundViewLineTopSpace, 1, kOpinionBackGroundViewHeight - 2*kOpinionBackGroundViewLineTopSpace);
        [_opinionBackGroundView addSubview:_secondLineView];
        
        if(_commentImageView){
            [_commentImageView removeFromSuperview];
            _commentImageView = nil;
        }
        _commentImageView = [[UIImageView alloc] init];
        _commentImageView.image = [UIImage imageNamed:@"commentBtnImage"];
        _commentImageView.highlightedImage = [UIImage imageNamed:@"commentBtnImage"];
        _commentImageView.frame = CGRectMake(CGRectGetMaxX(_secondLineView.frame) + kOpinionBackGroundViewImageLeftSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewImageWidth)/2, kOpinionBackGroundViewImageWidth, kOpinionBackGroundViewImageWidth);
        [_opinionBackGroundView addSubview:_commentImageView];
        
        if(_commentLabel){
            [_commentLabel removeFromSuperview];
            _commentLabel = nil;
        }
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:kOpinionBackGroundViewLabelFont];
        _commentLabel.textColor = kOpinionBackGroundViewLabelTextColor;
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        _commentLabel.text = @"意见";
        [_commentLabel sizeToFit];
        _commentLabel.frame = CGRectMake(CGRectGetMaxX(_commentImageView.frame) + kOpinionBackGroundViewMiddleSpace, (kOpinionBackGroundViewHeight - kOpinionBackGroundViewLabelFont)/2, _commentLabel.size.width, kOpinionBackGroundViewLabelFont);
        [_opinionBackGroundView addSubview:_commentLabel];
        
        if(_commentBtn){
            [_commentBtn removeFromSuperview];
            _commentBtn = nil;
        }
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(CGRectGetMaxX(_secondLineView.frame), 0, kOpinionBackGroundViewImageLeftSpace + kOpinionBackGroundViewImageWidth + kOpinionBackGroundViewMiddleSpace + _commentLabel.size.width + kOpinionBackGroundViewImageLeftSpace, kOpinionBackGroundViewHeight);
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_opinionBackGroundView addSubview:_commentBtn];
    }
    [self.contentView addSubview:_opinionBackGroundView];
    
//    [self.contentView addSubview:_isReadRedView];
    
    [self.contentView addSubview:_bottomLineView];
}

- (void)showAllBtnClick
{
    if(self.type == MoreNotAllShowCellType){
        self.type = MoreAllShowCellType;
    }else if(self.type == MoreAllShowCellType){
        self.type = MoreNotAllShowCellType;
    }
    if(self.updateCellHeightCallBack){
        self.updateCellHeightCallBack(self.indexPath,self.type);
    }
}

- (void)opinionBtnClick
{
    _opinionBtn.selected = !_opinionBtn.selected;
    if(_opinionBtn.selected){
        _opinionBackGroundView.hidden = NO;
    }else{
        _opinionBackGroundView.hidden = YES;
    }
}

- (void)aggreeBtnClick
{
    [self clearTextViewWithToolViewHidden:YES];
    [self sendCommentWithComment:@"同意"];
}

- (void)refuseBtnBtnClick
{
    [self clearTextViewWithToolViewHidden:YES];
    [self sendCommentWithComment:@"不同意"];
}

- (void)commentBtnClick
{
    [self clearTextViewWithToolViewHidden:NO];
    CXYunJingWorkCircleAllViewController * allPeoplleWorkCircleViewController = (CXYunJingWorkCircleAllViewController *)[self viewController];
    allPeoplleWorkCircleViewController.commentModel = self.model;
}

- (void)clearTextViewWithToolViewHidden:(BOOL)hidden
{
    _opinionBtn.selected = NO;
    _opinionBackGroundView.hidden = YES;
    CXYunJingWorkCircleAllViewController * allPeoplleWorkCircleViewController = (CXYunJingWorkCircleAllViewController *)[self viewController];
    allPeoplleWorkCircleViewController.textView.text = @"评论";
    allPeoplleWorkCircleViewController.textView.inputView = nil;
    [allPeoplleWorkCircleViewController.textView resignFirstResponder];
    allPeoplleWorkCircleViewController.toolView.hidden = hidden;
}

- (CXYunJingWorkCircleAllViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[CXYunJingWorkCircleAllViewController class]]) {
            return (CXYunJingWorkCircleAllViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)sendCommentWithComment:(NSString *)comment
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/record",urlPrefix];
    CXYunJingWorkCircleAllViewController * allPeoplleWorkCircleViewController = (CXYunJingWorkCircleAllViewController *)[self viewController];
    [allPeoplleWorkCircleViewController showHudInView:allPeoplleWorkCircleViewController.view hint:nil];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.model.eid forKey:@"l_bid"];
    [params setValue:self.model.btype forKey:@"l_type"];
    [params setValue:comment forKey:@"s_remark"];
    
    [HttpTool multipartPostFileDataWithPath:url params:params dataAry:nil success:^(id JSON) {
        [allPeoplleWorkCircleViewController hideHud];
        NSDictionary *jsonDict = JSON;
        if ([jsonDict[@"status"] integerValue] == 200) {
            TTAlert(@"发送评论成功");
        }else{
            TTAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        [allPeoplleWorkCircleViewController hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}

- (void)headImageViewClick
{
    if([_model.send_imAccount isEqualToString:VAL_HXACCOUNT]){
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.canPopViewController = YES;
        pivc.imAccount = _model.send_imAccount;
        [[self viewController].navigationController pushViewController:pivc animated:YES];
        if ([[self viewController].navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self viewController].navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
        pivc.imAccount = _model.send_imAccount;
        pivc.canPopViewController = YES;
        [[self viewController].navigationController pushViewController:pivc animated:YES];
        if ([[self viewController].navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self viewController].navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

+ (CGFloat)getYujingCellHeightWithModel:(CXAllPeoplleWorkCircleModel *)model AndType:(ShowCellType)type
{
    NSString * allContent = model.remark;
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:kContentLabelFontSize];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = allContent;
    contentLabel.size = CGSizeMake(Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), MAXFLOAT);
    [contentLabel sizeToFit];
    if(type == LessAllShowCellType){
        if(contentLabel.size.height > kMaxContentHeight){
            type = MoreNotAllShowCellType;
        }else{
            type = LessAllShowCellType;
        }
    }
    
    UIButton * showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(type == MoreNotAllShowCellType){
        contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), kMaxContentHeight);
        
        showAllBtn.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace - kShowAllBtnLeftOffset), CGRectGetMaxY(contentLabel.frame) + kShowAllBtnLeftSpace, kShowAllBtnWidth, kShowAllBtnHeight);
    }else if(type == MoreAllShowCellType){
        contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), contentLabel.size.height);
        showAllBtn.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace - kShowAllBtnLeftOffset), CGRectGetMaxY(contentLabel.frame) + kShowAllBtnLeftSpace, kShowAllBtnWidth, kShowAllBtnHeight);
    }else if(type == LessAllShowCellType){
        contentLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), (kWorkHeadImageLeftSpace + kNameLabelFontSize) + kContentLabelTopSpace, Screen_Width - kWorkHeadImageLeftSpace - kContentLabelLeftSpace - (kWorkHeadImageLeftSpace + kWorkHeadImageWidth + kWorkHeadImageLeftSpace + kContentLabelLeftSpace), contentLabel.size.height);
    }
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = model.createTime;
    timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    [timeLabel sizeToFit];
    if(type == MoreNotAllShowCellType || type == MoreAllShowCellType){
        timeLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth) + kWorkHeadImageLeftSpace, CGRectGetMaxY(showAllBtn.frame) + kWorkTimeLabelTopSpace, timeLabel.size.width, kTimeLabelFontSize);
    }else{
        timeLabel.frame = CGRectMake((kWorkHeadImageLeftSpace + kWorkHeadImageWidth) + kWorkHeadImageLeftSpace, CGRectGetMaxY(contentLabel.frame) + kWorkTimeLabelTopSpace, timeLabel.size.width, kTimeLabelFontSize);
    }
    
    return CGRectGetMaxY(timeLabel.frame) + kWorkTimeLabelBottomSpace + 1;
}

@end
