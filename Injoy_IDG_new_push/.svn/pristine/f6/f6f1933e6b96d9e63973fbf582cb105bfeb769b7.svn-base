//
// Created by ^ on 2017/12/13.
// Copyright (c) 2017 Injoy. All rights reserved.
//

const CGFloat CXTopScrollView_height = 50.f;

#import "CXTopScrollView.h"
#import "CXTopScrollSubView.h"

@interface CXTopScrollView () <UIScrollViewDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;

@property(copy, nonatomic) NSArray *titlesArr;

@property(copy, nonatomic) NSMutableArray *viewArr;
/// 记录上次选择的view
@property(weak, nonatomic) CXTopScrollSubView *oldSelectedView;
@end

@implementation CXTopScrollView

#pragma mark - get & set

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex {
    NSAssert(currentSelectIndex < self.viewArr.count, @"超过视图数量");
    _currentSelectIndex = currentSelectIndex;
    CXTopScrollSubView *tempView = self.viewArr[currentSelectIndex];
    __weak CXTopScrollSubView *weak_tempView = tempView;
    tempView.callBack(weak_tempView);
}

- (NSMutableArray *)viewArr {
    if (nil == _viewArr) {
        _viewArr = [[NSMutableArray alloc] init];
    }
    return _viewArr;
}

- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXTopScrollView_height}];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - function

- (void)subScrollViewAction:(CXTopScrollSubView *)scrollSubView {
    if (self.scrollView.contentSize.width < GET_WIDTH(self.scrollView)) {
        return;
    }

    BOOL flag = NO;

    if (self.oldSelectedView) {
        flag = self.oldSelectedView.viewTag < scrollSubView.viewTag;
    }
    if (CGRectGetMidX(scrollSubView.frame) > GET_WIDTH(_scrollView) / 2.f) {
        // 中间偏右
        if (_scrollView.contentSize.width < GET_WIDTH(_scrollView) / 2.f + CGRectGetMidX(scrollSubView.frame)) {
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - GET_WIDTH(_scrollView), 0.f) animated:YES];
        } else {
            [_scrollView setContentOffset:CGPointMake(CGRectGetMidX(scrollSubView.frame) - GET_WIDTH(_scrollView) / 2.f, 0.f) animated:YES];
        }
    } else {
        // 中间偏左
        [_scrollView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
    }

    if (self.callBack) {
        self.callBack(self.titlesArr[scrollSubView.viewTag - 1], scrollSubView.viewTag, flag);
    }
}

- (void)setUpSubviews {
    const CGFloat subWidth = ([UIScreen mainScreen].bounds.size.width) / 4.f;

    CGFloat contentWidth = self.titlesArr.count * subWidth;

    int count = (int) [self.titlesArr count];

    @weakify(self);

    for (int i = 0; i < count; i++) {
        NSString *title = self.titlesArr[i];
        CXTopScrollSubView *subView = [[CXTopScrollSubView alloc] initWithTitle:title];
        [self.viewArr addObject:subView];
        if (i == self.currentSelectIndex) {
            self.oldSelectedView = subView;
        }

        subView.callBack = ^(CXTopScrollSubView *view) {
            @strongify(self);
            for (CXTopScrollSubView *scrollSubView in self.scrollView.subviews) {
                [scrollSubView setSelected:NO];
            }
            [view setSelected:YES];
            [self subScrollViewAction:view];
            self.oldSelectedView = view;
        };

        subView.frame = (CGRect) {i * subWidth, 0.f, subWidth, CXTopScrollView_height};
        subView.viewTag = i + 1;
        [self.scrollView addSubview:subView];
    }

    self.scrollView.contentSize = CGSizeMake(contentWidth, CXTopScrollView_height);
}

#pragma mark - life cycle

- (instancetype)initWithTitles:(NSArray *)titlesArr {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXTopScrollView_height}]) {
        self.titlesArr = titlesArr;

        [self setUpSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSAssert(YES, @"");
    }
    return self;
}

@end
