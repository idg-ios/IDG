//
//  CXWorkCreateDetailView.m
//  InjoyERP
//
//  Created by wtz on 16/11/21.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXWorkCreateDetailView.h"
#import "CXFormLabel.h"
#import "UIView+Category.h"

@interface CXWorkCreateDetailView()<CXTextViewDelegate>

@property (nonatomic) CXWorkCreateDetailViewMode workCreateDetailViewMode;
@property (nonatomic, strong) UILabel *normalLable;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation CXWorkCreateDetailView

- (id)initWithTitle:(NSString *)title andFrame:(CGRect)frame AndCXContentDetailViewMode:(CXWorkCreateDetailViewMode)workCreateDetailViewMode{
    self = [super init];
    if (self) {
        self.workCreateDetailViewMode = workCreateDetailViewMode;
        self.backgroundColor = [UIColor whiteColor];
        [self setFrame:frame];
        self.title = title;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _normalLable = [[UILabel alloc] init];
    _normalLable.text = self.title;
    _normalLable.font = kFontSizeForForm;
    _normalLable.textAlignment = NSTextAlignmentLeft;
    [_normalLable sizeToFit];
    _normalLable.frame = CGRectMake(kFormViewMargin, (kCellHeight - kFontSizeValueForForm)/2, _normalLable.size.width, kFontSizeValueForForm);
    _normalLable.backgroundColor = [UIColor clearColor];
    [self addSubview:_normalLable];
    
    if (_contentLable == nil) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.backgroundColor = [UIColor clearColor];
        _contentLable.userInteractionEnabled = YES;
        _contentLable.font = kFontSizeForForm;
        _contentLable.frame = CGRectMake(CGRectGetMaxX(_normalLable.frame), (kCellHeight - kFontSizeValueForForm)/2, self.frame.size.width - CGRectGetMaxX(_normalLable.frame) - kFormViewMargin, 0);
        [self addSubview:_contentLable];
    }
    
    if (_holdLable == nil) {
        _holdLable = [[UILabel alloc] init];
        _holdLable.text = @"";
        _holdLable.textColor = [UIColor lightGrayColor];
        _holdLable.font = kFontTimeSizeForForm;
        _holdLable.backgroundColor = [UIColor clearColor];
        [_holdLable sizeToFit];
        _holdLable.frame = CGRectMake(CGRectGetMaxX(_normalLable.frame),CGRectGetMinY(_normalLable.frame) + 1,_holdLable.size.width,kFontSizeValueForForm);
        [self addSubview:_holdLable];
    }
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGBACOLOR(139, 144, 136, 1.0);
    _lineView.frame = CGRectMake(0, kCellHeight - 1, Screen_Width, 1);
    [self addSubview:_lineView];
    
    if(self.workCreateDetailViewMode == CXWorkCreateDetailViewModeCreate){
        //添加手势
        UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestAction:)];
        [self addGestureRecognizer:tapgest];
    }
}

- (void)setContentText:(NSString *)contentText
{
    if (_holdLable != nil) {
        [_holdLable removeFromSuperview];
    }
    self.contentLable.numberOfLines = 0;
    self.contentLable.text = contentText;
    self.theContentText = contentText;
    CGSize size = [_contentLable sizeThatFits:CGSizeMake(self.frame.size.width - CGRectGetMaxX(_normalLable.frame) - kFormViewMargin, MAXFLOAT)];
    self.contentLable.frame = CGRectMake(CGRectGetMaxX(_normalLable.frame), (kCellHeight - kFontSizeValueForForm)/2 - 1, size.width, size.height);
    
    
    
    CGFloat labelHeight = size.height;
    CGFloat viewHeight = labelHeight + kCellHeight - kFontSizeValueForForm;
    if(viewHeight < kCellHeight){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kCellHeight)];
        viewHeight = kCellHeight;
    }else{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight)];
    }
    
    if([contentText isEqualToString:@""] || !contentText){
        _lineView.frame = CGRectMake(0, kCellHeight - 1, Screen_Width, 1);
    }else{
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLable.frame) - 1 + (kCellHeight - kFontSizeValueForForm)/2, Screen_Width, 1);
    }
    [self workCreateDetailViewReloadHeightWithThirdViewHeight:viewHeight];
}

-(void)clearAll
{
    [self setContentText:@""];
    _lineView.frame = CGRectMake(0, kCellHeight - 1, Screen_Width, 1);
}
/*
 填写备注
 */
- (void)tapgestAction:(UIGestureRecognizer *)gest
{
    NSLog(@"contentView = %@",gest.view);
    CXTextView *keyboard = [[CXTextView alloc] initWithKeyboardType:UIKeyboardTypeDefault];
    keyboard.textString = _contentLable.text;
    keyboard.maxLengthOfString = 1000;
    keyboard.delegate = self;
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:keyboard];
}
/*
 CXTextViewDelegate 用户输入的文本 按发送调用
 */
-(void)textView:(CXTextView *)textView textWhenTextViewFinishEdit:(NSString *)text
{
    if (_holdLable != nil) {
        [_holdLable removeFromSuperview];
    }
    self.contentLable.numberOfLines = 0;
    self.contentLable.text = text;
    self.theContentText = text;
    CGSize size = [_contentLable sizeThatFits:CGSizeMake(self.frame.size.width - CGRectGetMaxX(_normalLable.frame) - kFormViewMargin, MAXFLOAT)];
    self.contentLable.frame = CGRectMake(CGRectGetMaxX(_normalLable.frame), (kCellHeight - kFontSizeValueForForm)/2 - 1, size.width, size.height);
    
    
    CGFloat labelHeight = size.height;
    CGFloat viewHeight = labelHeight + kCellHeight - kFontSizeValueForForm;
    if(viewHeight < kCellHeight){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kCellHeight)];
        viewHeight = kCellHeight;
    }else{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight)];
    }
    if([self.contentLable.text isEqualToString:@""] || !self.contentLable.text){
        _lineView.frame = CGRectMake(0, kCellHeight - 1, Screen_Width, 1);
    }else{
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLable.frame) - 1 + (kCellHeight - kFontSizeValueForForm)/2, Screen_Width, 1);
    }
    
    [self workCreateDetailViewReloadHeightWithThirdViewHeight:viewHeight];
}

- (void)workCreateDetailViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(workCreateDetailViewReloadHeightWithThirdViewHeight:)]){
        [self.delegate workCreateDetailViewReloadHeightWithThirdViewHeight:viewHeight];
    }
}

@end
