//
//  CXPromotionSettingsView.m
//  InjoyERP
//
//  Created by wtz on 2017/5/11.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXPromotionSettingsView.h"
#import "CXFormLabel.h"
#import "UIView+Category.h"

@interface CXPromotionSettingsView()<CXTextViewDelegate>

@property (nonatomic) CXPromotionSettingsViewMode promotionSettingsViewMode;
@property (nonatomic, strong) UILabel *normalLable;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) NSString * holdLabelText;

@end

@implementation CXPromotionSettingsView

- (id)initWithTitle:(NSString *)title andFrame:(CGRect)frame AndCXPromotionSettingsViewMode:(CXPromotionSettingsViewMode)promotionSettingsViewMode AndHoldLabelText:(NSString *)text{
    self = [super init];
    if (self) {
        self.promotionSettingsViewMode = promotionSettingsViewMode;
        self.backgroundColor = [UIColor whiteColor];
        [self setFrame:frame];
        self.title = title;
        self.holdLabelText = text;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _normalLable = [[UILabel alloc] init];
    _normalLable.text = self.title;
    _normalLable.font = kFontSizeForDetail;
    _normalLable.textAlignment = NSTextAlignmentLeft;
    [_normalLable sizeToFit];
    _normalLable.frame = CGRectMake(kFormViewMargin, (kCellHeight - kFontSizeValueForForm)/2, _normalLable.size.width, kFontSizeValueForForm);
    _normalLable.backgroundColor = [UIColor clearColor];
    [self addSubview:_normalLable];
    
    if (_contentLable == nil) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.backgroundColor = [UIColor clearColor];
        _contentLable.userInteractionEnabled = YES;
        _contentLable.font = [UIFont systemFontOfSize:14.5];
        _contentLable.frame = CGRectMake(CGRectGetMaxX(_normalLable.frame), (kCellHeight - kFontSizeValueForForm)/2, self.frame.size.width - CGRectGetMaxX(_normalLable.frame) - kFormViewMargin, 0);
        [self addSubview:_contentLable];
    }
    
    if (_holdLable == nil) {
        _holdLable = [[UILabel alloc] init];
        _holdLable.text = self.holdLabelText;
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
    
    if(self.promotionSettingsViewMode == CXPromotionSettingsViewModeCreate){
        //添加手势
        UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestAction:)];
        [self addGestureRecognizer:tapgest];
    }
}

- (void)setLineColor:(UIColor *)color
{
    self.lineView.backgroundColor = color;
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
    [self.delegate promotionSettingsViewReloadHeightWithThirdViewHeight:viewHeight AndHoldLabelText:self.holdLabelText];
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
    
    [self.delegate promotionSettingsViewReloadHeightWithThirdViewHeight:viewHeight AndHoldLabelText:self.holdLabelText];
}

- (void)promotionSettingsViewReloadHeightWithThirdViewHeight:(CGFloat)viewHeight AndHoldLabelText:(NSString *)holdLabelText
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(promotionSettingsViewReloadHeightWithThirdViewHeight:AndHoldLabelText:)]){
        [self.delegate promotionSettingsViewReloadHeightWithThirdViewHeight:viewHeight AndHoldLabelText:self.holdLabelText];
    }
}

@end
