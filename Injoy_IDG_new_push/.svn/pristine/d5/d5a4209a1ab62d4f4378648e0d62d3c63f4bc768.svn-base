//
//  CXYMPlaceholderTextView.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/7/12.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMPlaceholderTextView.h"

@interface CXYMPlaceholderTextView ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *placeholderLabel;
@end

static CGFloat const CXYMPlaceholderDefaultMargin = 6.0;

@implementation CXYMPlaceholderTextView
#pragma mark setter && getter
- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = false;
        _placeholderLabel.textColor = self.placeholderColor;
        _placeholderLabel.text = self.placeholder;
        _placeholderLabel.hidden = self.text.length != 0;
        _placeholderLabel.font = self.placeholderFont ?: self.font;
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if([_placeholder isEqualToString:placeholder]) return;
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (placeholderColor == nil) return;
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (placeholderFont == nil) return;
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
}

- (void)setTextMaxLength:(NSUInteger)textMaxLength {
    _textMaxLength = textMaxLength;
    [self _cutOffTextIfNeed];
}


- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    if (UIEdgeInsetsEqualToEdgeInsets(textContainerInset, self.textContainerInset)) return;
    [super setTextContainerInset:textContainerInset];
    [self setNeedsUpdateConstraints];
}

- (void)setFont:(UIFont *)font {
    if (font == nil) return;
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self _cutOffTextIfNeed];
    
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self _cutOffTextIfNeed];
}

- (NSUInteger)remainderInputLength {
    if (self.textMaxLength <= 0) return NSNotFound;
    return self.textMaxLength - self.text.length;
}

#pragma mark initialize
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithPlaceholder:(NSString *)placeholder textMaxLength:(NSUInteger)textMaxLength {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.placeholder = placeholder;
        self.textMaxLength = textMaxLength;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIFont *font = self.font;
    self.font = font ?: [UIFont systemFontOfSize:14];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidChanged:) name:UITextViewTextDidChangeNotification object:self];
}

#pragma makr override
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = self.bounds.size.width - self.textContainerInset.left - self.textContainerInset.right - CXYMPlaceholderDefaultMargin * 2;
    CGSize size = [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.placeholderLabel.font} context:nil].size;
    self.placeholderLabel.frame = CGRectMake(self.textContainerInset.left + CXYMPlaceholderDefaultMargin, self.textContainerInset.top, size.width, size.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark observer


- (void)_textDidChanged:(NSNotification *)notification {
    if (notification.object != self) return;
    [self _cutOffTextIfNeed];
    if (self.textDidChangedBlock) {
        self.textDidChangedBlock(self);
    }
}

#pragma mark private
- (void)_cutOffTextIfNeed {
    if (self.textMaxLength > 0 && self.text.length > self.textMaxLength) {
        self.text = [self.text substringToIndex:self.textMaxLength];
        if (self.textOverMaxLengthBlock) {
            self.textOverMaxLengthBlock(self);
        }
    }
    [self _hiddenPlaceholderIfNeed];
}

- (void)_hiddenPlaceholderIfNeed {
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((text && text.length)) {
        self.placeholderLabel.hidden = YES;
    }else {
        self.placeholderLabel.hidden = NO;
    }
}


@end
