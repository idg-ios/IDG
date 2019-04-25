//
//  CXTMTProjectSearchView.m
//  InjoyIDG
//
//  Created by wtz on 2018/2/28.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXTMTProjectSearchView.h"
#import "CXProjectSearchItemCell.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "HttpTool.h"
#import "NSString+YYAdd.h"
#import "UIButton+LXMImagePosition.h"

@interface CXTMTProjectSearchView()<UISearchBarDelegate>

/** 背景白色 */
@property (nonatomic, strong) UIView *backWhiteView;
/** 搜索栏 */
@property (nonatomic, strong) UISearchBar *searchBar;
/** 报告名称 */
@property (nonatomic, strong) UILabel * bgmcTitleLable;
/** 报告名称TextField */
@property (nonatomic, strong) UITextField * bgmcTextField;
/** 摘要 */
@property (nonatomic, strong) UILabel * zyTitleLable;
/** 摘要TextField */
@property (nonatomic, strong) UITextField * zyTextField;
/** 底部视图 */
@property (nonatomic, strong) UIView *footerView;
/** 重置按钮 */
@property (nonatomic, strong) UIButton *resetButton;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation CXTMTProjectSearchView{
    /** 遮罩层 */
    __weak UIView *_maskView;
}

#define kTitleSpace 10.0
#define kTitleLeftSpace 10.0
#define kTextFontSize 16.0
#define kTextFieldHeight 40.0

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup {
    _backWhiteView = ({
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view;
    });
    
    _searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.showsCancelButton = YES;
        searchBar.placeholder = @"请输入项目名称";
        searchBar.delegate = self;
        [self addSubview:searchBar];
        searchBar;
    });
    
    _bgmcTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"报告名称";
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        //        [self addSubview:label];
        label;
    });
    
    _bgmcTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入报告名称";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        //        [self addSubview:textField];
        textField;
    });
    
    _zyTitleLable = ({
        UILabel * label = [[UILabel alloc] init];
        label.text = @"摘要";
        label.font = [UIFont systemFontOfSize:kTextFontSize];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        //        [self addSubview:label];
        label;
    });
    
    _zyTextField = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入摘要";
        textField.font = [UIFont systemFontOfSize:kTextFontSize];
        textField.backgroundColor = RGBACOLOR(238.0, 239.0, 243.0, 1.0);
        textField.layer.cornerRadius = 3.0;
        textField.clipsToBounds = YES;
        //        [self addSubview:textField];
        textField;
    });
    
    _footerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view;
    });
    
    _resetButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:kColorWithRGB(236, 72, 73) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onResetButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        button;
    });
    
    _searchButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:kColorWithRGB(236, 72, 73)];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderWidth = 1;
        button.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(onSearchButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:button];
        button;
    });
}

- (void)layout {
    self.backWhiteView.frame = CGRectMake(0, 0, Screen_Width, 51.0 + 5*kTitleSpace + 2*kTextFontSize + 2*kTextFieldHeight);
    
    self.searchBar.frame = CGRectMake(0, 0, Screen_Width, 51.0);
    
    self.bgmcTitleLable.frame = CGRectMake(kTitleLeftSpace, self.searchBar.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFontSize);
    
    self.bgmcTextField.frame = CGRectMake(kTitleLeftSpace, self.bgmcTitleLable.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFieldHeight);
    
    self.zyTitleLable.frame = CGRectMake(kTitleLeftSpace, self.bgmcTextField.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFontSize);
    
    self.zyTextField.frame = CGRectMake(kTitleLeftSpace, self.zyTitleLable.bottom + kTitleSpace, Screen_Width - 2*kTitleLeftSpace, kTextFieldHeight);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorWithRGB(241, 241, 241);
    line.frame = CGRectMake(0, self.zyTextField.bottom + kTitleSpace, Screen_Width, 1);
    [self addSubview:line];
    
    self.footerView.frame = CGRectMake(0, line.bottom, Screen_Width, 50);
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 30));
        make.centerY.equalTo(self.footerView);
        make.right.equalTo(self.footerView.mas_centerX).offset(-5);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2-15, 30));
        make.centerY.equalTo(self.footerView);
        make.left.equalTo(self.footerView.mas_centerX).offset(5);
    }];

}

#pragma mark - Public

- (void)showInView:(UIView *)view {
    UIView *maskView = ({
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = kDialogCoverBackgroundColor;
        [view addSubview:maskView];
        [maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        maskView;
    });
    _maskView = maskView;
    [view addSubview:self];
    
    if ([view.viewController isKindOfClass:[SDRootViewController class]]) {
        UIView *rootTopView = [view viewWithTag:kRootTopViewTag];
        if (rootTopView) {
            [view bringSubviewToFront:rootTopView];
        }
    }
}

- (void)hide {
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Private
- (UIView *)addDividingLineInView:(UIView *)superView below:(UIView *)view offset:(CGFloat)offset {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorWithRGB(241, 241, 241);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(offset);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    return line;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self onSearchButtonTap];
    [searchBar resignFirstResponder];
}

#pragma mark - Event
- (void)onResetButtonTap {
    self.searchBar.text = nil;
    self.bgmcTextField.text = nil;
    [self.bgmcTextField resignFirstResponder];
    self.zyTextField.text = nil;
    [self.zyTextField resignFirstResponder];
}

- (void)onSearchButtonTap {
    if (self.onSearchCallback) {
        NSString *keyword = [self.searchBar.text stringByTrim];
        self.onSearchCallback(keyword);
    }
    [self hide];
}

@end
