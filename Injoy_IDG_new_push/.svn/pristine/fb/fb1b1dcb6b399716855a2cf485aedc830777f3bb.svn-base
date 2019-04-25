//
//  CXAllPeoplleWorkCircleCell.m
//  InjoyERP
//
//  Created by wtz on 16/11/23.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXAllPeoplleWorkCircleCell.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "UIView+Category.h"
#import "CXAllPeoplleWorkCircleViewController.h"
#import "HttpTool.h"
#import "CXLoaclDataManager.h"
#import "SDIMPersonInfomationViewController.h"
#import "SDContactsDetailController.h"

#define kWorkHeadImageLeftSpace 10
#define kWorkHeadImageTopSpace 15
#define kWorkHeadImageWidth 40
#define kNameLabelFontSize 15.0
#define kTitleLabelFontSize 14.0
#define kTimeLabelFontSize 12.0
#define kTextColor RGBACOLOR(72.0, 71.0, 76.0, 1.0)
#define kGrayBackGroundViewTopSpace 3
#define kTypeImageLeftSpace 10
#define kTypeImageWidth 25
#define kGrayBackGroundViewMoveLeft 3
#define kWorkTimeLabelTopSpace 10
#define kWorkTimeLabelBottomSpace 15
#define kWorkCellHeight (kWorkHeadImageTopSpace + kNameLabelFontSize + kGrayBackGroundViewTopSpace + kTypeImageLeftSpace + kTypeImageWidth + kTypeImageLeftSpace + kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace)

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

@interface CXAllPeoplleWorkCircleCell()

@property (nonatomic, strong) CXAllPeoplleWorkCircleModel * model;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UIView * isReadRedView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UIView * grayBackGroundView;
@property (nonatomic, strong) UIImageView * typeImageView;
@property (nonatomic, strong) UILabel * titleLabel;
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

@end

@implementation CXAllPeoplleWorkCircleCell

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
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_typeLabel){
        [_typeLabel removeFromSuperview];
        _typeLabel = nil;
    }
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
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
    
    if(_timeLabel){
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeLabelFontSize];
    _timeLabel.textColor = SDCellTimeColor;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    if(_opinionBtn){
        [_opinionBtn removeFromSuperview];
        _opinionBtn = nil;
    }
    _opinionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _opinionBtn.selected = NO;
    [_opinionBtn addTarget:self action:@selector(opinionBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCXAllPeoplleWorkCircleModel:(CXAllPeoplleWorkCircleModel *)model
{
    _model = model;
    _opinionBtn.selected = NO;
    _opinionBackGroundView.hidden = YES;
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
    
    _nameLabel.text = [NSString stringWithFormat:@"%@：",_model.send_name];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, kWorkHeadImageTopSpace, _nameLabel.size.width, kNameLabelFontSize);
    [self.contentView addSubview:_nameLabel];
    
    _typeLabel.text = [self getTypeWithBtypeString:self.model.btype];
    [_typeLabel sizeToFit];
    _typeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame), kWorkHeadImageTopSpace, _typeLabel.size.width, kNameLabelFontSize);
    [self.contentView addSubview:_typeLabel];
    
    _grayBackGroundView.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace - kGrayBackGroundViewMoveLeft, CGRectGetMaxY(_nameLabel.frame) + kGrayBackGroundViewTopSpace, Screen_Width - (CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkHeadImageLeftSpace, kTypeImageLeftSpace*2 + kTypeImageWidth);
    [self.contentView addSubview:_grayBackGroundView];
    
    _typeImageView.image = [UIImage imageNamed:[self getTypeImageNameWithBtypeString:self.model.btype]];
    _typeImageView.highlightedImage = [UIImage imageNamed:[self getTypeImageNameWithBtypeString:self.model.btype]];
    _typeImageView.frame = CGRectMake(kTypeImageLeftSpace, kTypeImageLeftSpace, kTypeImageWidth, kTypeImageWidth);
    [_grayBackGroundView addSubview:_typeImageView];
    
    _titleLabel.text = self.model.name;
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_typeImageView.frame) + kTypeImageLeftSpace, (kTypeImageLeftSpace*2 + kTypeImageWidth - kTitleLabelFontSize)/2 - 1, Screen_Width - (CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace - kGrayBackGroundViewMoveLeft) - kWorkHeadImageLeftSpace - kTypeImageLeftSpace*3 - kTypeImageWidth, kTitleLabelFontSize + 2);
    [_grayBackGroundView addSubview:_titleLabel];
    
    _timeLabel.text = self.model.createTime;
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kWorkHeadImageLeftSpace, CGRectGetMaxY(_grayBackGroundView.frame) + kWorkTimeLabelTopSpace, _timeLabel.size.width, kTimeLabelFontSize);
    [self.contentView addSubview:_timeLabel];
    
    _opinionBtn.frame = CGRectMake(Screen_Width - kWorkHeadImageLeftSpace - kOpinionBtnImageWidth, CGRectGetMaxY(_grayBackGroundView.frame) + kWorkTimeLabelTopSpace - (kOpinionBtnImageHeight - kTimeLabelFontSize)/2, kOpinionBtnImageWidth, kOpinionBtnImageHeight);
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
    _bottomLineView.frame = CGRectMake(0, kWorkCellHeight - 1, Screen_Width, 1);
    _bottomLineView.backgroundColor = RGBACOLOR(231.0, 231.0, 233.0, 1.0);
    
    if(true){
        _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kSelfOpinionBackGroundViewWidth, CGRectGetMaxY(_grayBackGroundView.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kSelfOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
        
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
        _opinionBackGroundView.frame = CGRectMake(CGRectGetMinX(_opinionBtn.frame) - kOpinionBackGroundViewSpace - kOpinionBackGroundViewWidth, CGRectGetMaxY(_grayBackGroundView.frame) + (kWorkTimeLabelTopSpace + kTimeLabelFontSize + kWorkTimeLabelBottomSpace - kOpinionBackGroundViewHeight)/2, kOpinionBackGroundViewWidth, kOpinionBackGroundViewHeight);
        
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
    
    [self.contentView addSubview:_isReadRedView];
    
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
    CXAllPeoplleWorkCircleViewController * allPeoplleWorkCircleViewController = (CXAllPeoplleWorkCircleViewController *)[self viewController];
    allPeoplleWorkCircleViewController.commentModel = self.model;
}

- (void)clearTextViewWithToolViewHidden:(BOOL)hidden
{
    _opinionBtn.selected = NO;
    _opinionBackGroundView.hidden = YES;
    CXAllPeoplleWorkCircleViewController * allPeoplleWorkCircleViewController = (CXAllPeoplleWorkCircleViewController *)[self viewController];
    allPeoplleWorkCircleViewController.textView.text = @"评论";
    allPeoplleWorkCircleViewController.textView.inputView = nil;
    [allPeoplleWorkCircleViewController.textView resignFirstResponder];
    allPeoplleWorkCircleViewController.toolView.hidden = hidden;
}

- (CXAllPeoplleWorkCircleViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[CXAllPeoplleWorkCircleViewController class]]) {
            return (CXAllPeoplleWorkCircleViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)sendCommentWithComment:(NSString *)comment
{
    NSString *url = [NSString stringWithFormat:@"%@workRecord/record",urlPrefix];
    CXAllPeoplleWorkCircleViewController * allPeoplleWorkCircleViewController = (CXAllPeoplleWorkCircleViewController *)[self viewController];
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

@end
