//
//  CXNormalCell.m
//  SDMarketingManagement
//
//  Created by lancely on 5/9/16.
//  Copyright © 2016 slovelys. All rights reserved.
//

#import "CXNormalCell.h"
#import "UIView+YYAdd.h"

@interface CXNormalCell ()

/** 宽度比数组 */
@property(nonatomic, copy, readonly) NSArray<NSNumber *> *widthRatios;
/** 宽度数组 */
@property(nonatomic, copy, readonly) NSArray<NSNumber *> *widths;
/** 垂直分割线数组 */
@property(nonatomic, strong) NSMutableArray<UIView *> *vLines;
/** 底部水平分割线 */
@property(nonatomic, weak) UIView *hLine;

@end

@implementation CXNormalCell

#pragma mark - Get&Set

- (NSMutableArray<CXNormalCellLabel *> *)textLabels {
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

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self->_indexPath = indexPath;
    // 偶数行
    if ((indexPath.row + 1) % 2 == 0) {
        self.backgroundColor = kEvenCellBackgroundColor;
    }
        // 奇数行
    else {
        self.backgroundColor = kOddCellBackgroundColor;
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    self->_lineColor = lineColor;
    [self.vLines enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.backgroundColor = lineColor;
    }];
    self.hLine.backgroundColor = lineColor;
}

- (NSMutableDictionary *)ext {
    if (!_ext) {
        _ext = NSMutableDictionary.dictionary;
    }
    return _ext;
}

- (void)setHLineHeight:(CGFloat)hLineHeight {
    _hLineHeight = hLineHeight;
}

#pragma mark - Initialize

- (instancetype)initWithWidthRatios:(NSArray<NSNumber *> *)widthRatios reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self->_widthRatios = widthRatios;
        [self setup];
    }
    return self;
}

- (instancetype)initWithWidths:(NSArray<NSNumber *> *)widths reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self->_widths = widths;
        [self setup];
    }
    return self;
}

+ (instancetype)cellWithWidthRatios:(NSArray<NSNumber *> *)widthRatios reuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithWidthRatios:widthRatios reuseIdentifier:reuseIdentifier];
}

+ (instancetype)cellWithWidths:(NSArray<NSNumber *> *)widths reuseIdentifier:(NSString *)reuseIdentifier {
    return [[self alloc] initWithWidths:widths reuseIdentifier:reuseIdentifier];
}

#pragma mark - Setup

- (void)setup {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.hLineHeight = 1;

    if (self.widthRatios) {
        NSAssert(self.widthRatios && self.widthRatios.count > 0, @"参数错误");
    } else if (self.widths) {
        NSAssert(self.widths && self.widths.count > 0, @"参数错误");
    }

    NSInteger count = self.widthRatios ? self.widthRatios.count : self.widths.count;

    // 创建标题
    for (NSInteger i = 0; i < count; i++) {
        CXNormalCellLabel *label = [self createCellLabel];
        label.currentColumn = i;
        [self.textLabels addObject:label];
    }

    // 竖线
    for (NSInteger i = 0; i < count - 1; i++) {
        UIView *line = [self createLineView];
        [self.vLines addObject:line];
    }

    // 底部横线
    UIView *line = [self createLineView];
    line.tag = 'B';
    self.hLine = line;
}

#pragma mark - 创建控件

- (CXNormalCellLabel *)createCellLabel {
    CXNormalCellLabel *label = [[CXNormalCellLabel alloc] init];
    label.font = kFontSizeForForm;
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)createLineView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kTableViewLineColor;
    [self.contentView addSubview:view];
    return view;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    // 布局标题
    [self.textLabels enumerateObjectsUsingBlock:^(UILabel *_Nonnull label, NSUInteger idx, BOOL *_Nonnull stop) {
        CGFloat x = 0;
        if (idx != 0) {
            UILabel *prevLabel = self.textLabels[idx - 1];
            x = CGRectGetMaxX(prevLabel.frame);
        }
        CGFloat y = 0;
        CGFloat width = kNilOptions;
        if (self.widthRatios) {
            width = CGRectGetWidth(self.contentView.frame) * self.widthRatios[idx].floatValue;
        } else {
            width = self.widths[idx].floatValue;
        }
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        label.frame = CGRectMake(x, y, width, height);
    }];

    // 布局垂直分割线
    [self.vLines enumerateObjectsUsingBlock:^(UIView *_Nonnull line, NSUInteger idx, BOOL *_Nonnull stop) {
        CGFloat x = CGRectGetMaxX(self.textLabels[idx].frame);
        CGFloat y = 0;
        CGFloat width = 1;
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        line.frame = CGRectMake(x, y, width, height);
    }];

    // 布局底部分割线
    self.hLine.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - self.hLineHeight, CGRectGetWidth(self.contentView.frame), self.hLineHeight);
}

#pragma mark - Action

- (void)cellTapped:(UITapGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self];
    CXNormalCellLabel *currentSelectedLabel = nil;
    for (CXNormalCellLabel *label in self.textLabels) {
        if (CGRectContainsPoint(label.frame, pt)) {
            currentSelectedLabel = label;
            break;
        }
    }

    UIViewController *vc = self.viewController;
    if ([vc respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        SEL selector = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
        IMP imp = [vc methodForSelector:selector];
        void (*func)(id, SEL, UITableView *, NSIndexPath *) = (void *) imp;
        func(vc, selector, [self getTableView], self->_indexPath);
    }
    if ([self.delegate respondsToSelector:@selector(normalCell:tappedAtIndexPath:)]) {
        [self.delegate normalCell:self tappedAtIndexPath:self.indexPath];
    }

    if ([self.delegate respondsToSelector:@selector(normalCell:tappedAtIndexPath:currentColumn:)]) {
        [self.delegate normalCell:self tappedAtIndexPath:self.indexPath currentColumn:currentSelectedLabel.currentColumn];
    }
}

#pragma mark - 处理

- (UITableView *)weakTableView {
    return [self getTableView];
}

- (UITableView *)getTableView {
    UITableView *tableView;
    for (UIView *view = self.superview; view; view = view.superview) {
        if ([view isKindOfClass:UITableView.class]) {
            tableView = (UITableView *)view;
            break;
        }
    }
    return tableView;
}

@end


@implementation CXNormalCellLabel

- (void)setImage:(UIImage *)image {
    self->_image = image;
    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    att.image = image;
    self.attributedText = [NSAttributedString attributedStringWithAttachment:att];
}

@end

