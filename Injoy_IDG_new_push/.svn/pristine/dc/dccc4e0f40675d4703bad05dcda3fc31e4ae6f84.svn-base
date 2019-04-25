//
// Created by ^ on 2017/10/30.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXApprovalAlertView.h"
#import "Masonry.h"
#import "DLRadioButton.h"
#import "NSString+YYAdd.h"
#import "UIView+YYAdd.h"
#import "CXBaseRequest.h"
#import "UIButton+LXMImagePosition.h"

#import "MBProgressHUD+CXCategory.h"

@interface CXApprovalAlertView () <UITextViewDelegate>
@property(weak, nonatomic) UIView *coverView;
@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString *suggestion;
@property(weak, nonatomic) UITextView *textView;
@property(strong, nonatomic) DLRadioButton *radioButton_1;
@property(strong, nonatomic) DLRadioButton *radioButton_2;
@property(nonatomic, strong) NSString *title;
@end

@implementation CXApprovalAlertView {
    /// 主键id
    NSString *_bid;
    /// 审批id
    long _btype;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.content = trim(textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        self.content = trim(textView.text);
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - instance function

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];

    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = kDialogCoverBackgroundColor;
    [window addSubview:coverView];
    self.coverView = coverView;
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];

    [coverView addSubview:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(coverView);
        make.height.mas_equalTo(m_approval_height * 5);
        make.left.equalTo(coverView).offset(20.f);
        make.right.equalTo(coverView).offset(-20.f);
    }];
    
    self.radioButton_1.selected = YES;
    [self dLRadioButtonAction:self.radioButton_1];
}

- (void)dismiss {
    [self.coverView removeFromSuperview];
    [self removeFromSuperview];
}

CGFloat m_approval_height = 50.f;

- (void)dLRadioButtonAction:(DLRadioButton *)sender {
    self.suggestion = sender.titleLabel.text;
}

- (void)setUpCenterView:(UIView *)centerView {
    CGFloat margin = 10.f;

    UILabel *title_1 = [[UILabel alloc] init];
    title_1.font = kFontSizeForDetail;
    title_1.text = @"意见：";
    [centerView addSubview:title_1];

    [title_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin * 2);
        make.top.equalTo(centerView).offset(margin);
        make.width.mas_equalTo(55.f);
    }];

    self.radioButton_1 = [[DLRadioButton alloc] init];
    [centerView addSubview:self.radioButton_1];
    // radioButton_1.icon = [UIImage imageNamed:@"CXPayUnselect"];
    // radioButton_1.iconSelected = [UIImage imageNamed:@"CXPaySelect"];
    self.radioButton_1.iconSize = [UIImage imageNamed:@"CXPayUnselect"].size.width;
    self.radioButton_1.iconColor = [UIColor redColor];
    self.radioButton_1.indicatorColor = [UIColor redColor];
    [self.radioButton_1 addTarget:self action:@selector(dLRadioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.radioButton_1 setTitle:@"同意" forState:UIControlStateNormal];
    [self.radioButton_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.radioButton_1.titleLabel setFont:kFontSizeForDetail];

    [self.radioButton_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title_1.mas_right).offset(margin);
        make.top.equalTo(centerView).offset(margin);
        make.width.mas_equalTo(70.f);
    }];

    self.radioButton_2 = [[DLRadioButton alloc] init];
    [centerView addSubview:self.radioButton_2];
    self.radioButton_2.iconSize = self.radioButton_1.iconSize;
    // radioButton_2.icon = [UIImage imageNamed:@"CXPayUnselect"];
    // radioButton_2.iconSelected = [UIImage imageNamed:@"CXPaySelect"];
    self.radioButton_2.iconColor = [UIColor redColor];
    self.radioButton_2.indicatorColor = [UIColor redColor];
    [self.radioButton_2 addTarget:self action:@selector(dLRadioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.radioButton_2 setTitle:@"不同意" forState:UIControlStateNormal];
    [self.radioButton_2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.radioButton_2.titleLabel setFont:kFontSizeForDetail];

    [self.radioButton_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.radioButton_1.mas_right).offset(margin * 3);
        make.top.equalTo(centerView).offset(margin);
        make.width.mas_equalTo(80.f);
    }];

    self.radioButton_1.otherButtons = @[self.radioButton_2];

    // 分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
//    lineView.frame = CGRectMake(0, title_1.bottom, 100, 1);
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_1.mas_bottom).offset(margin);
        make.left.equalTo(centerView).offset(margin);
        make.right.equalTo(centerView).offset(-margin);
        make.height.mas_equalTo(1.f);
    }];

    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [centerView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).offset(margin);
        make.left.equalTo(centerView).offset(margin);
        make.right.equalTo(centerView).offset(-margin);
        make.bottom.equalTo(centerView).offset(-margin);
    }];

    NSString *title = @"内容：";
    CGSize size = [title sizeForFont:kFontSizeForDetail size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect) {margin, margin, size.width, size.height}];
    titleLabel.font = kFontSizeForDetail;
    titleLabel.text = title;
    [scrollView addSubview:titleLabel];

    UITextView *textView = [[UITextView alloc] initWithFrame:(CGRect) {titleLabel.right, titleLabel.top - 5.f, Screen_Width - 40.f - margin - titleLabel.right, 80.f}];
    self.textView = textView;
    textView.font = kFontSizeForDetail;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textContainerInset = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
    textView.delegate = self;
    [scrollView addSubview:textView];
}
- (void)travelPSSubmit{
//    if(!trim(self.textView.text).length){
//        CXAlert(@"请填写批审原因！");
//        return;
//    }
    NSString *url = [NSString stringWithFormat:@"%@travel/doApprove",urlPrefix];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"eid"] = _bid;
    param[@"isApprove"] = [self.suggestion isEqualToString:@"同意"] ? @(2) : @(3);
    param[@"reason"] = trim(self.textView.text);
    
//    HUD_SHOW(nil);
    [MBProgressHUD showHUDForView:self text:HUDMessage];
    
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 if ([responseObj[@"status"] intValue] == HTTPSUCCESSOK) {
                                     CXAlertExt(@"提交成功", ^{
                                         if (self.callBack) {
                                             self.callBack();
                                         }
                                         [self dismiss];
                                     });
                                 } else {
                                     MAKE_TOAST(responseObj[@"msg"]);
                                 }
//                                 HUD_HIDE;
                                 [MBProgressHUD hideHUDInMainQueueForView:self];
                             }
                             failure:^(NSError *error) {
//                                 HUD_HIDE;
                                 [MBProgressHUD hideHUDInMainQueueForView:self];
                                 CXAlert(KNetworkFailRemind);
                             }];
}
- (void)btnEvent:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];

    if ([@"提交" isEqualToString:title]) {
        if ([self.suggestion length] == 0) {
            CXAlert(@"请选择意见");
            return;
        }
        if([self.title isEqualToString:@"出差"]){
            [self travelPSSubmit];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@holiday/approve", urlPrefix];
        //审批提交,新需求


        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"applyId"] = _bid;
        param[@"approveId"] = @(_btype);
        param[@"isApprove"] = [self.suggestion isEqualToString:@"同意"] ? @(1) : @(2);
        param[@"reason"] = trim(self.textView.text);

//        HUD_SHOW(nil);
        [MBProgressHUD showHUDForView:self text:HUDMessage];
        
        [CXBaseRequest postResultWithUrl:url
                                   param:param
                                 success:^(id responseObj) {
                                     if ([responseObj[@"status"] intValue] == HTTPSUCCESSOK) {
                                         CXAlertExt(@"提交成功", ^{
                                             if (self.callBack) {
                                                 self.callBack();
                                             }
                                             [self dismiss];
                                         });
                                     } else {
                                         MAKE_TOAST(responseObj[@"msg"]);
                                     }
//                                     HUD_HIDE;
                                     [MBProgressHUD hideHUDInMainQueueForView:self];
                                 }
                                 failure:^(NSError *error) {
//                                     HUD_HIDE;
                                     [MBProgressHUD hideHUDInMainQueueForView:self];
                                     CXAlert(KNetworkFailRemind);
                                 }];
    }
    if ([@"取消" isEqualToString:title]) {
        [self dismiss];
    }
}

- (void)setUpBottomView:(UIView *)bottomView {
    CGFloat margin = 20.f;
    CGFloat width = 100.f;
    CGFloat height = 35.f;

    // 提交
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:okBtn];
    [okBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setImage:[UIImage imageNamed:@"approval_save"] forState:UIControlStateNormal];
    [okBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [okBtn setImagePosition:LXMImagePositionLeft spacing:5.f];
    [okBtn setBackgroundColor:[UIColor redColor]];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_centerX).offset(-margin);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];

    // 取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:kColorWithRGB(86.f, 86.f, 86.f) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"approval_cancel"] forState:UIControlStateNormal];
    [cancelBtn setImagePosition:LXMImagePositionLeft spacing:5.f];
    [cancelBtn setBackgroundColor:kColorWithRGB(217.f, 217.f, 217.f)];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_centerX).offset(margin);
        make.centerY.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
}

- (void)setUpUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    titleLabel.text = @"批  审";

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(m_approval_height);
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self);
    }];

    // 中间视图
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(m_approval_height * 3);
    }];

    [self setUpCenterView:centerView];

    // 底部视图
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(m_approval_height);
    }];

    [self setUpBottomView:bottomView];
}

#pragma mark - life cycle

- (instancetype)initWithBid:(NSString *)bid btype:(BusinessType)btype {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, m_approval_height * 5}]) {
        self.backgroundColor = kColorWithRGB(248.f, 248.f, 248.f);
        _bid = bid;
        _btype = btype;
        [self setUpUI];
    }
    return self;
}
- (instancetype)initWithBid:(NSString *)bid btype:(BusinessType)btype andTitle:(NSString *)title{
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, m_approval_height * 5}]) {
        self.backgroundColor = kColorWithRGB(248.f, 248.f, 248.f);
        _bid = bid;
        _btype = btype;
        _title = title;
        [self setUpUI];
    }
    return self;
}
@end
