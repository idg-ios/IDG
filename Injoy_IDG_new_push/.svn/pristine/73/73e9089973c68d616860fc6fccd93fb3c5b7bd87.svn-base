//
//  CXTitleHeaderView.m
//  SDMarketingManagement
//
//  Created by cheng on 5/6/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXTitleHeaderView.h"
#import "UIView+YYAdd.h"

@interface CXTitleHeaderView()

/** 标题数组 */
@property (nonatomic, copy) NSArray<NSString *> *titles;
/** 宽度比 */
@property (nonatomic, copy) NSArray<NSNumber *> *widthRatios;
/** 宽度 */
@property (nonatomic, copy) NSArray<NSNumber *> *widths;

@property (nonatomic, strong) NSMutableArray<UIView *> *vLines;
@property (nonatomic, strong) NSMutableArray<UIView *> *hLines;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation CXTitleHeaderView

#pragma mark - Get & Set
- (NSMutableArray<UILabel *> *)textLabels {
    if (!_textLabels) {
        _textLabels = [NSMutableArray array];
    }
    return _textLabels;
}

- (NSMutableArray<UIView *> *)vLines {
    if (!_vLines) {
        _vLines = [NSMutableArray array];
    }
    return _vLines;
}

- (NSMutableArray<UIView *> *)hLines {
    if (!_hLines) {
        _hLines = [NSMutableArray array];
    }
    return _hLines;
}

- (void)setLineColor:(UIColor *)lineColor {
    self->_lineColor = lineColor;
    [self.hLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = lineColor;
    }];
    [self.vLines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = lineColor;
    }];
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:Image(@"CXOASearch") forState:UIControlStateNormal];
        _searchButton.backgroundColor = UIColorFromHex(0xc4d7bd);
        
        if (self.isFromSetting) {
            [_searchButton setImage:Image(@"CXOASearch1") forState:UIControlStateNormal];
            _searchButton.backgroundColor = kColorWithRGB(255, 218, 164);
        }
        
        [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchButton];
    }
    return _searchButton;
}

- (void)setShowSearchButton:(BOOL)showSearchButton {
    self->_showSearchButton = showSearchButton;
    self->_searchButton.hidden = !showSearchButton;
}

#pragma mark - Initialize

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles widthRatios:(NSArray<NSNumber *> *)widthRatios {
    if (self  = [super init]) {
        self.titles = titles;
        self.widthRatios = widthRatios;
        [self setup];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths {
    if (self = [super init]) {
        self.titles = titles;
        self.widths = widths;
        [self setup];
    }
    return self;
}

- (void)setup {
    if (self.widthRatios) {
        NSAssert(self.titles.count && self.widthRatios.count && (self.titles.count == self.widthRatios.count), @"参数错误");
    }
    else if (self.widths) {
        NSAssert(self.titles.count && self.widths.count && (self.titles.count == self.widths.count), @"参数错误");
    }
    self.backgroundColor = kTitleHeaderViewBackgroundColor;
    
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *titleLabel = [self createLabelWithTitle:title];
        titleLabel.tag = idx;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapped:)]];
        [self.textLabels addObject:titleLabel];
    }];
    
    for (NSInteger i = 0; i < self.titles.count - 1; i++) {
        UIView *line = [self createLineView];
        [self.vLines addObject:line];
    }
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *line = [self createLineView];
        [self.hLines addObject:line];
    }
}

+ (instancetype)headerViewWithTitles:(NSArray<NSString *> *)titles widthRatios:(NSArray<NSNumber *> *)widthRatios {
    return [[CXTitleHeaderView alloc] initWithTitles:titles widthRatios:widthRatios];
}

+ (instancetype)headerViewWithTitles:(NSArray<NSString *> *)titles widths:(NSArray<NSNumber *> *)widths {
    return [[CXTitleHeaderView alloc] initWithTitles:titles widths:widths];
}

#pragma mark - 创建控件
- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    if ([title isKindOfClass:NSString.class]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^.*?(\\(.*?\\))$" options:kNilOptions error:nil];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:title options:kNilOptions range:NSMakeRange(0, title.length)];
        if (matches.count) {
            NSRange regexGroupRange = [matches.firstObject rangeAtIndex:1];
            NSString *mainTitle = [title substringToIndex:regexGroupRange.location];
            NSString *subTitle = [title substringWithRange:regexGroupRange];
            subTitle = [@" " stringByAppendingString:subTitle];
            NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
            [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:mainTitle attributes:@{ NSFontAttributeName : kTopHeadFont }]];
            [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:subTitle attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:kTopHeadFont.pointSize * .75] }]];
            label.attributedText = attrText;
        }
        else {
            label.text = title;
            label.font = kTopHeadFont;
        }
    }
    else if ([title isKindOfClass:NSAttributedString.class]) {
        label.attributedText = (NSAttributedString *)title;
        label.font = kTopHeadFont;
    }
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    return label;
}

- (UIView *)createLineView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kTableViewLineColor;
    [self addSubview:view];
    return view;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [self.textLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull titleLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = 0;
        if (idx != 0) {
            UILabel *prevLabel = self.textLabels[idx - 1];
            x = CGRectGetMaxX(prevLabel.frame);
        }
        static CGFloat y = 0;
        CGFloat width = 0;
        if (self.widthRatios) {
            CGFloat ratio = self.widthRatios[idx].floatValue;
            width = CGRectGetWidth(self.frame) * ratio;
        }
        else {
            width = self.widths[idx].floatValue;
        }
        CGFloat height = CGRectGetHeight(self.frame);
        titleLabel.frame = CGRectMake(x, y, width, height);
        
        // 设置竖分割线
        if (idx != self.textLabels.count - 1) {
            UIView *vLine = self.vLines[idx];
            vLine.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 1, height);
        }
    }];
    
    // 设置横分割线
    [self.hLines enumerateObjectsUsingBlock:^(UIView * _Nonnull hLine, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            hLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
        }
        else if (idx == 1) {
            hLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
        }
    }];
    
    // 搜索按钮
    if (self.showSearchButton) {
        self.searchButton.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame) * 0.8, CGRectGetHeight(self.frame));
        // 重新设置第一列标题位置
        UILabel *firstLabel = self.textLabels.firstObject;
        firstLabel.left = GET_WIDTH(self.searchButton);
        firstLabel.width = GET_WIDTH(firstLabel) - GET_WIDTH(self.searchButton);
    }
}

#pragma mark - Event

- (void)titleLabelTapped:(UITapGestureRecognizer *)gestureRec {
    UILabel *titleLabel = (UILabel *)gestureRec.view;
    NSInteger index = titleLabel.tag;
    if (index == self.titles.count -1) {
        if ([self.delegate respondsToSelector:@selector(titleHeaderViewClickInLastLabel)]) {
            [self.delegate titleHeaderViewClickInLastLabel];
        }
    }
    if ([self.delegate respondsToSelector:@selector(titleHeaderView:didTapTitleLabel:atIndex:)]) {
        [self.delegate titleHeaderView:self didTapTitleLabel:titleLabel atIndex:index];
    }
}

- (void)searchButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(titleHeaderView:didTapSearchButton:)]) {
        [self.delegate titleHeaderView:self didTapSearchButton:sender];
    }
}

@end
