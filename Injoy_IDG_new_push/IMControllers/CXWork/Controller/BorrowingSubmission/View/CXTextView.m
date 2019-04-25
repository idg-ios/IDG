//
//  CXTextView.m
//  SDMarketingManagement
//
//  Created by Longfei on 16/4/12.
//  Copyright © 2016年 slovelys. All rights reserved.
//  文字输入键盘

#import "CXTextView.h"

@interface CXTextView()

//第一次达到限定字数
@property(nonatomic, assign) BOOL isFirstTextLimit;

@end

@implementation CXTextView
{
    CGFloat _keyboardHeight;
    CGFloat _frameHeight;
    UITextView *_textView;
    UIView *_bgView;
}

-(id)init
{
    if (self = [super init])
    {
        self.isFirstTextLimit = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self setupMainView];
    }
    return self;
}

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self setupMainViewWithKeyboardType:keyboardType];
    }
    return self;
}

-(void)setupMainView
{
    _keyboardHeight = 0;
    _frameHeight = 34;
    if (!_maxLengthOfString)
    {
        _maxLengthOfString = 1000;
    }
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.backgroundColor = [UIColor clearColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 34)];
    _bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_bgView];
    _textView= [[UITextView alloc] initWithFrame:CGRectMake(Interval, 2, Screen_Width-Interval*2, 30)];
    _textView.layer.cornerRadius = 2;
    _textView.layer.masksToBounds = YES;
    _textView.returnKeyType = UIReturnKeySend;
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    [_bgView addSubview:_textView];
}

-(void)setupMainViewWithKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardHeight = 0;
    _frameHeight = 34;
    if (!_maxLengthOfString)
    {
        _maxLengthOfString = 1000;
    }
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.backgroundColor = [UIColor clearColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 34)];
    _bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_bgView];
    _textView= [[UITextView alloc] initWithFrame:CGRectMake(Interval, 2, Screen_Width-Interval*2, 30)];
    _textView.layer.cornerRadius = 2;
    _textView.layer.masksToBounds = YES;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.keyboardType = keyboardType;
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    [_bgView addSubview:_textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >_maxLengthOfString)
    {
        if (self.isFirstTextLimit) {
            self.isFirstTextLimit = NO;
            TTAlert([NSString stringWithFormat:@"输入内容已经达到%lu字",(unsigned long)_maxLengthOfString]);
        }
        textView.text = [textView.text substringToIndex:_maxLengthOfString];
        if ([self.delegate respondsToSelector:@selector(textView:textWhenTextViewFinishEdit:)])
        {
            [self.delegate textView:self textWhenTextViewFinishEdit:textView.text];
            [self keyboardWillHidden:nil];
        }
        return;
    }
  CGSize size = [textView sizeThatFits:CGSizeMake(Screen_Width-Interval*2, CGFLOAT_MAX)];
    _bgView.frame = CGRectMake(0, Screen_Height-_keyboardHeight-size.height-4 + kTabbarSafeBottomMargin, Screen_Width, size.height+4);
    _textView.frame = CGRectMake(Interval, 2, Screen_Width-Interval*2, size.height);
    _frameHeight=size.height+4;
    if ([self.delegate respondsToSelector:@selector(textView:heightWhenTextViewEdit:)])
    {
        [self.delegate textView:self heightWhenTextViewEdit:_keyboardHeight+_frameHeight];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        __weak typeof (self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(textView:textWhenTextViewFinishEdit:)])
        {
            [weakSelf.delegate textView:weakSelf textWhenTextViewFinishEdit:textView.text];
            [weakSelf keyboardWillHidden:nil];
        }
        return NO;
    }
    return YES;
}

- (void)keyboardWillShown:(NSNotification *)notif
{
    __weak typeof (self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(textWhenTextViewBeginEdit)])
    {
        _textView.text = [self.delegate textWhenTextViewBeginEdit];
        
    }
    if (![self.textString isKindOfClass:[NSNull class]] && weakSelf.textString.length >0)
    {
        _textView.text = weakSelf.textString;
    }
    CGSize size = [_textView sizeThatFits:CGSizeMake(Screen_Width-Interval*2, CGFLOAT_MAX)];
    _frameHeight=size.height+4;
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (keyboardSize.height == 0)
    {
        return;
    }
    _keyboardHeight = keyboardSize.height;
    _bgView.frame = CGRectMake(0, Screen_Height-keyboardSize.height-_frameHeight + kTabbarSafeBottomMargin, Screen_Width, _frameHeight);
    _textView.frame = CGRectMake(Interval, 2, Screen_Width-Interval*2, size.height);
    
    if ([self.delegate respondsToSelector:@selector(textView:heightWhenTextViewEdit:)])
    {
        [self.delegate textView:weakSelf heightWhenTextViewEdit:_keyboardHeight+_frameHeight];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    __weak typeof (self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(textView: textWhenTextViewFinishEdit:)])
    {
        [self.delegate textView:weakSelf textWhenTextViewFinishEdit:_textView.text];
    }
    [self endEditing:YES];
}

- (void) keyboardWillHidden:(NSNotification *) notif
{
    __weak typeof (self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(textView:heightWhenTextViewEdit:)])
    {
        [self.delegate textView:weakSelf heightWhenTextViewEdit:0];
    }
    [weakSelf removeFromSuperview];
}

-(void)dealloc
{
    _textView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
