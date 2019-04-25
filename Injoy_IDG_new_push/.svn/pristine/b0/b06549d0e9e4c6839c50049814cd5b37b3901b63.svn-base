//
//  CXLabelTextVIew.m
//  SDMarketingManagement
//
//  Created by wtz on 16/5/16.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXLabelTextView.h"

@interface CXLabelTextView()

@property (nonatomic ,strong) UILabel * textLabel;

//是否是金钱要加元
@property (nonatomic, assign) BOOL isMoney;

@end

@implementation CXLabelTextView
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self setupMainView];
    }
    return self;
}

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType AndLabel:(UILabel *)label{
    if (self = [super init])
    {
        self.isMoney = NO;
        self.textLabel = label;
        if(_isMoney){
            self.textString = [self getTextWithOutYuan:self.textLabel.text];
        }else{
            self.textString = self.textLabel.text;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        [self setupMainViewWithKeyboardType:keyboardType];
    }
    return self;

}

-(id)initWithKeyboardType:(UIKeyboardType )keyboardType AndLabel:(UILabel *)label AndIsMoney:(BOOL)isMoney
{
    if (self = [super init])
    {
        self.isMoney = isMoney;
        self.textLabel = label;
        if(_isMoney){
            self.textString = [self getTextWithOutYuan:self.textLabel.text];
        }else{
            self.textString = self.textLabel.text;
        }
        
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
        TTAlert([NSString stringWithFormat:@"输入内容已经达到%lu字",(unsigned long)_maxLengthOfString]);
        textView.text = [textView.text substringToIndex:_maxLengthOfString];
        if(_isMoney){
            self.textLabel.text = [self getTextWithYuan:textView.text];
        }else{
            self.textLabel.text = textView.text;
        }
        
        [self keyboardWillHidden:nil];
        return;
    }
    CGSize size = [textView sizeThatFits:CGSizeMake(Screen_Width-Interval*2, CGFLOAT_MAX)];
    _bgView.frame = CGRectMake(0, Screen_Height-_keyboardHeight-size.height-4, Screen_Width, size.height+4);
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
        if(_isMoney){
            self.textLabel.text = [self getTextWithYuan:textView.text];
        }else{
            self.textLabel.text = textView.text;
        }
        [self keyboardWillHidden:nil];
        return NO;
    }
    return YES;
}

- (void) keyboardWillShown:(NSNotification *) notif
{
    
    if ([self.delegate respondsToSelector:@selector(textWhenTextViewBeginEdit)])
    {
        _textView.text = [self.delegate textWhenTextViewBeginEdit];
        
    }
    if (![self.textString isKindOfClass:[NSNull class]] && self.textString.length >0)
    {
        _textView.text = self.textString;
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
    _bgView.frame = CGRectMake(0, Screen_Height-keyboardSize.height-_frameHeight, Screen_Width, _frameHeight);
    _textView.frame = CGRectMake(Interval, 2, Screen_Width-Interval*2, size.height);
    
    if ([self.delegate respondsToSelector:@selector(textView:heightWhenTextViewEdit:)])
    {
        [self.delegate textView:self heightWhenTextViewEdit:_keyboardHeight+_frameHeight];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_isMoney){
        self.textLabel.text = [self getTextWithYuan:_textView.text];
    }else{
        self.textLabel.text = _textView.text;
    }
    
    [self.delegate textView:self textWhenTextViewFinishingEdit:_textView.text];
    [self endEditing:YES];
}

- (void)keyboardWillHidden:(NSNotification *) notif
{
    __weak __typeof(self)weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(textView:heightWhenTextViewEdit:)])
    {
        [weakSelf.delegate textView:self heightWhenTextViewEdit:0];
    }
    if ([weakSelf.delegate respondsToSelector:@selector(textView:textWhenTextViewFinishingEdit:)])
    {
        [weakSelf.delegate textView:self textWhenTextViewFinishingEdit:_textView.text];
    }
    [weakSelf removeFromSuperview];
}

- (NSString *)getTextWithOutYuan:(NSString *)text
{
    NSString * getString = text;
    if([text isEqualToString:@""]){
        return getString;
    }
    NSString *lastString = [text substringFromIndex:([text length]-1)];
    if([lastString isEqualToString:@"元"]){
        getString = [text substringToIndex:([text length]-1)];
    }
    return getString;
}

- (NSString *)getTextWithYuan:(NSString *)text
{
    NSString *getString = [self getTextWithOutYuan:text];
    if([getString isEqualToString:@""]){
        return @"";
    }
    getString = [NSString stringWithFormat:@"%@元",getString];
    return getString;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

