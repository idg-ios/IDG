//
//  CXOAMoneyView.m
//  SDMarketingManagement
//
//  Created by huashao on 16/4/18.
//  Copyright © 2016年 slovelys. All rights reserved.

#import "CXOAMoneyView.h"
#import "UIView+YYAdd.h"
#import "YYText.h"
#import "CXStaticDataHelper.h"

#define kMoneyUnitWidth 13.f

@implementation CXOAMoneyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        self.userInteractionEnabled = YES;
        //创建界面
        [self setupMoneyView];

        //添加点击手势
        UITapGestureRecognizer *tapGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyViewTap:)];
        [self addGestureRecognizer:tapGecognizer];
    }
    return self;
}

#pragma mark-- 金钱视图点击事件

- (void)moneyViewTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(selectedMoneyView:)]) {
        [self.delegate selectedMoneyView:(CXOAMoneyView *) tap.view];
    }
}

#pragma mark-- 创建金钱输入视图

- (void)setupMoneyView {
    //申请金额
    self.moneyTitle = [[UILabel alloc] init];
    [self addSubview:self.moneyTitle];

    NSRange range = NSMakeRange(2, 5);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"金额 (小写)："];
    attributedString.yy_font = kFontSizeForDetail;
    attributedString.yy_alignment = NSTextAlignmentLeft;
    [attributedString yy_setColor:[UIColor lightGrayColor] range:range];
    [attributedString yy_setFont:[UIFont systemFontOfSize:12.f] range:range];
    self.moneyTitle.attributedText = attributedString;

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, kLineHeight) text:attributedString];
    self.moneyTitle.frame = CGRectMake(5.f, 0, textLayout.textBoundingSize.width, kLineHeight);

    int count = 9;

    self.moneyView = [[UIView alloc] initWithFrame:CGRectMake(self.moneyTitle.right, 5, kMoneyUnitWidth * count, 30)];
    self.moneyView.layer.masksToBounds = YES;
    self.moneyView.layer.borderWidth = 2.f;
    self.moneyView.layer.borderColor = kColorWithRGB(174, 204, 255).CGColor;
    [self addSubview:self.moneyView];

    for (NSInteger i = 0; i < count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMoneyUnitWidth * i, 0, kMoneyUnitWidth, 30)];
        label.font = [UIFont systemFontOfSize:11.f];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100 + i;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = kColorWithRGB(174, 204, 255).CGColor;
        label.layer.borderWidth = 1.f;
        [self.moneyView addSubview:label];
    }
    //上面添加一条灰线
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(kMoneyUnitWidth * 1 - 1.f, 0, 2, 30)];
    darkView.backgroundColor = kColorWithRGB(232, 186, 196);
    [self.moneyView addSubview:darkView];

    //上面添加一条灰线
    UIView *secondDarkView = [[UIView alloc] initWithFrame:CGRectMake(kMoneyUnitWidth * 4 - 1.f, 0, 2, 30)];
    secondDarkView.backgroundColor = kColorWithRGB(184, 182, 183);
    [self.moneyView addSubview:secondDarkView];

    //上面添加一条红线
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kMoneyUnitWidth * 7 - 1.f, 0, 2, 30)];
    redView.backgroundColor = kColorWithRGB(194, 174, 175);
    [self.moneyView addSubview:redView];

    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moneyView.frame) + 5.f, 0, 20.f, kLineHeight)];
    self.unitLabel.text = @"元";
    self.unitLabel.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:self.unitLabel];

    //币种
    self.currency = [[CXEditLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.unitLabel.frame) + kFormViewMargin, kFormViewMargin / 2.f - 3.f, self.frame.size.width - CGRectGetMaxX(self.unitLabel.frame) - 2 * kFormViewMargin, kLineHeight)];
    self.currency.inputType = CXEditLabelInputTypeCustomPicker;
    self.currency.pickerTextArray = [[[CXStaticDataHelper sharedInstance] getStaticDataWithType:CXStaticDataTypeCurrency] valueForKey:@"name"];
    self.currency.pickerValueArray = [[[CXStaticDataHelper sharedInstance] getStaticDataWithType:CXStaticDataTypeCurrency] valueForKey:@"value"];
    self.currency.title = @"币种：";
    [self addSubview:self.currency];
}

- (void)setMonney:(double)monney {
    _monney = monney;
    if (monney) {
        NSString *s = [[NSString stringWithFormat:@"%.2lf", monney] stringByReplacingOccurrencesOfString:@"." withString:@"."];
        if (s.length > 11) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"金钱数据超过9位数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            _monney = 0.f;
            return;
        }
        NSInteger i = 108;
        for (NSInteger i = 100; i < 109; i++) {
            UILabel *label = (UILabel *) [self.moneyView viewWithTag:i];
            label.text = nil;
        }
        for (NSInteger j = s.length - 1; j >= 0; j--) {
            NSString *t = [s substringWithRange:NSMakeRange(j, 1)];
            NSLog(@"---->> t:%@   i:%d", t, i);
            [self setCellLabel:t tag:i];
            i--;
        }
    } else {
        for (NSInteger i = 100; i < 109; i++) {
            UILabel *label = (UILabel *) [self.moneyView viewWithTag:i];
            label.text = nil;
        }
    }
}

- (void)setCellLabel:(NSString *)moneyNumber tag:(NSInteger)tag {
    if ([[self.moneyView viewWithTag:tag] isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *) [self.moneyView viewWithTag:tag];
        label.text = moneyNumber;
    }
}

- (void)setViewEditOrNot:(BOOL)bl {
    self.currency.allowEditing = bl;
    self.currency.showDropdown = bl;
    self.moneyView.userInteractionEnabled = bl;
    self.userInteractionEnabled = bl;
}

@end
