//
//  CXDatePickerView.m
//  InjoyERP
//
//  Created by haihualai on 2017/1/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDatePickerView.h"
#import "UIImage+YYAdd.h"
#import "View+MASAdditions.h"
#import "UIView+YYAdd.h"

@interface CXDatePickerView ()

@property(nonatomic, strong) UIButton *applyButton;

@property(nonatomic, strong) UIButton *cleanButton;

@property(nonatomic, weak) UIView *footerView;

@property(nonatomic, weak) UIDatePicker *datePicker;

@property(nonatomic, weak) UIView *bgView;

@end

@implementation CXDatePickerView

- (instancetype)init {
    if (self = [super init]) {

//        self.frame = CGRectMake((Screen_Width - kDialogWidth) / 2.f, (Screen_Height - (kDialogHeaderHeight + kDialogFooterHeight + 2 * kDialogContentHeight)) / 2.f, kDialogWidth, kDialogHeaderHeight + kDialogFooterHeight + kDialogContentHeight * 2);
        self.frame = [[UIScreen mainScreen] bounds];

        //创建视图
        [self creatUI];
    }
    return self;
}

- (void)show {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    bgView.backgroundColor = kDialogCoverBackgroundColor;
    [KEY_WINDOW addSubview:bgView];
    self.bgView = bgView;
    [KEY_WINDOW addSubview:self];
}

#pragma mark -- 创建界面视图

- (void)creatUI {//修改时间选择器的UI
   

    //日期选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//    datePicker.frame = CGRectMake(0, kDialogHeaderHeight, kDialogWidth, ceil(kDialogContentHeight * 2));
    datePicker.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kTabbarSafeBottomMargin - 216, Screen_Width, 216);
    [datePicker setBackgroundColor:kDialogContentBackgroundColor];
    [self addSubview:datePicker];
    self.datePicker = datePicker;

    //底部视图,顶部视图
//    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, datePicker.bottom - 1.f, kDialogWidth, kDialogFooterHeight)];
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 216-kDialogFooterHeight, Screen_Width, kDialogFooterHeight)];
    [buttomView setBackgroundColor:kDialogHeaderBackgroundColor];
    [self addSubview:buttomView];
    self.footerView = buttomView;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, Screen_Width - 160, kDialogHeaderHeight)];
    titleLabel.font = kDialogTitleFont;
    titleLabel.backgroundColor = kDialogHeaderBackgroundColor;
    titleLabel.text = @"日期选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.footerView addSubview:titleLabel];

    // 确定按钮
    self.applyButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"确%@定", kDialogTextSpacing] forState:UIControlStateNormal];
        button.titleLabel.font = kDialogButtonFont;
//        [button setImage:Image(@"common_save") forState:UIControlStateNormal];
        button.imageEdgeInsets = kDialogButtonImageInsets;
        button.titleEdgeInsets = kDialogButtonTitleInsets;
        [button addTarget:self action:@selector(applyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(kDialogButtonMargin);
            make.right.mas_equalTo(0);
            make.centerY.equalTo(self.footerView);
            make.size.mas_equalTo(CGSizeMake(60, kDialogButtonHeight));
        }];
        button;
    });

    // 清空按钮
    self.cleanButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"取%@消", kDialogTextSpacing] forState:UIControlStateNormal];
        button.titleLabel.font = kDialogButtonFont;
//        [button setImage:Image(@"common_delete") forState:UIControlStateNormal];
        button.imageEdgeInsets = kDialogButtonImageInsets;
        button.titleEdgeInsets = kDialogButtonTitleInsets;
        [button addTarget:self action:@selector(cleanButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(-kDialogButtonMargin);
            make.left.mas_equalTo(0);
            make.centerY.equalTo(self.footerView);
            make.size.equalTo(self.applyButton);
        }];
        button;
    });

}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = datePickerMode;

}


- (void)setDateContent:(NSString *)dateContent {
    if (!dateContent.length || [dateContent isEqualToString:@" "]) {
        return;
    }
    _dateContent = dateContent;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.datePickerMode == UIDatePickerModeDate) {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *date = [dateFormatter dateFromString:dateContent];
    self.datePicker.date = date;
}


- (void)applyButtonTapped:(UIButton *)button {
    NSDate *selectDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.datePickerMode == UIDatePickerModeDate) {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSString *dateStr = [dateFormatter stringFromDate:selectDate];

    //选择日期回调
    if (self.selectDateCallBack) {
        self.selectDateCallBack(dateStr);
    }

    //移除视图
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];

}

- (void)cleanButtonTapped:(UIButton *)button {
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

@end
