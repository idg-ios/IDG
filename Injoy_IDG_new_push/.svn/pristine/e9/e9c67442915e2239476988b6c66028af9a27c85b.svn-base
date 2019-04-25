//
//  CXXJSPListApprovalAlertView.m
//  InjoyIDG
//
//  Created by wtz on 2018/4/13.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXXJSPListApprovalAlertView.h"
#import "Masonry.h"
#import "DLRadioButton.h"
#import "NSString+YYAdd.h"
#import "UIView+YYAdd.h"
#import "CXBaseRequest.h"
#import "UIButton+LXMImagePosition.h"

#import "MBProgressHUD+CXCategory.h"
#import "CXWDXJListModel.h"

@interface CXXJSPListApprovalAlertView()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL agree;

@end

@implementation CXXJSPListApprovalAlertView
- (instancetype)initWithWDXJListModel:(CXWDXJListModel *)model{
    self = [super init];
    if(self){
        [self setupSubview];
    }
    return self;
}
- (void)setupSubview{
  //
    self.agree = YES;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
      //bg
    self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgButton.backgroundColor = [UIColor blackColor];
    self.bgButton.alpha = .3;
    //contentView
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [UIColor redColor];
    self.contentView.alpha = 1.0;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(150);
    }];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"批审";
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    //三个按钮
    UIButton *titleButton = [self createButton];
    [titleButton setTitle:@"意见:" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    titleButton.backgroundColor = [UIColor whiteColor];
    UIButton *agreeButton = [self createButton];
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [agreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [agreeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];

    [agreeButton setImage:[UIImage imageNamed:@"cxym_circle_selected"] forState:UIControlStateNormal];
    agreeButton.tag = 1000;
    agreeButton.backgroundColor = [UIColor whiteColor];
    [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    UIButton *unagreeButton = [self createButton];
    [unagreeButton setTitle:@"不同意" forState:UIControlStateNormal];
    [unagreeButton setImage:[UIImage imageNamed:@"cxym_circle_normal"] forState:UIControlStateNormal];
    [unagreeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [unagreeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    unagreeButton.tag = 1001;
    unagreeButton.backgroundColor = [UIColor whiteColor];
    [unagreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSArray *buttonArray = @[titleButton,agreeButton,unagreeButton];
    [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(0);
    }];
    //2个按钮
    UIButton *submitButton = [self createButton];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setImage:[UIImage imageNamed:@"approval_save"] forState:UIControlStateNormal];
    submitButton.tag = 2000;
    submitButton.backgroundColor = [UIColor redColor];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIButton *cancelButton = [self createButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"approval_cancel"] forState:UIControlStateNormal];
    cancelButton.tag = 2001;
    cancelButton.backgroundColor = kColorWithRGB(217.f, 217.f, 217.f);
    [cancelButton setTitleColor:kColorWithRGB(86, 86, 86) forState:UIControlStateNormal];
    NSArray *bottomButtonArray = @[submitButton,cancelButton];
    [bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:40 leadSpacing:40 tailSpacing:40];
    [bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(-5);
    }];
}

- (UIButton *)createButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.titleLabel.font = kFontSizeForDetail;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    return button;
}
- (void)buttonClick:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    NSLog(@"%@===title === %@",sender,title);
    UIButton *agreeButton = [self viewWithTag:1000];
    UIButton *unagreeButton = [self viewWithTag:1001];
    if ([title isEqualToString:@"不同意"]) {
        [agreeButton setImage:[UIImage imageNamed:@"cxym_circle_normal"] forState:UIControlStateNormal];
        [unagreeButton setImage:[UIImage imageNamed:@"cxym_circle_selected"] forState:UIControlStateNormal];
        self.agree = NO;
    }
    if ([title isEqualToString:@"同意"]) {
        [unagreeButton setImage:[UIImage imageNamed:@"cxym_circle_normal"] forState:UIControlStateNormal];
        [agreeButton setImage:[UIImage imageNamed:@"cxym_circle_selected"] forState:UIControlStateNormal];
        self.agree = YES;
    }
    
    if ([title isEqualToString:@"提交"]) {
        [self dismiss];
        if (self.back) {
            self.back(self.agree);
        }
    }else if([title isEqualToString:@"取消"]){
        [self dismiss];
    }
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    [UIView animateWithDuration:.25 animations:^{
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [window addSubview:self];
    }];
}
- (void)dismiss{
    [self.contentView removeFromSuperview];
    [self   removeFromSuperview];
}
@end

/*
@interface CXXJSPListApprovalAlertView()<UITextViewDelegate>

@property(weak, nonatomic) UIView *coverView;
@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString *suggestion;
@property(weak, nonatomic) UITextView *textView;
/// applyId
@property(strong, nonatomic) NSNumber *applyId;
/// applyUser
@property(strong, nonatomic) NSString * applyUser;
@property(strong, nonatomic) DLRadioButton *radioButton_1;
@property(strong, nonatomic) DLRadioButton *radioButton_2;

@end

@implementation CXXJSPListApprovalAlertView

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
        make.height.mas_equalTo(rem_approval_height * 3);
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

CGFloat rem_approval_height = 50.f;

- (void)dLRadioButtonAction:(DLRadioButton *)sender {
    self.suggestion = sender.titleLabel.text;
}

- (void)setUpCenterView:(UIView *)centerView {
    CGFloat margin = 10.f;
    CGFloat topMargin = 15.f;
    
    UILabel *title_1 = [[UILabel alloc] init];
    title_1.font = kFontSizeForDetail;
    title_1.text = @"意见：";
    [centerView addSubview:title_1];
    
    [title_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin * 2);
        make.top.equalTo(centerView).offset(topMargin);
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
        make.top.equalTo(centerView).offset(topMargin);
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
        make.top.equalTo(centerView).offset(topMargin);
        make.width.mas_equalTo(80.f);
    }];
    
    self.radioButton_1.otherButtons = @[self.radioButton_2];
    
//    // 分隔线
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [centerView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(title_1.mas_bottom).offset(margin);
//        make.left.equalTo(centerView).offset(margin);
//        make.right.equalTo(centerView).offset(-margin);
//        make.height.mas_equalTo(1.f);
//    }];
//
//    // 滚动视图
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    [centerView addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView).offset(margin);
//        make.left.equalTo(centerView).offset(margin);
//        make.right.equalTo(centerView).offset(-margin);
//        make.bottom.equalTo(centerView).offset(-margin);
//    }];
//
//    NSString *title = @"内容：";
//    CGSize size = [title sizeForFont:kFontSizeForDetail size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect) {margin, margin, size.width, size.height}];
//    titleLabel.font = kFontSizeForDetail;
//    titleLabel.text = title;
//    [scrollView addSubview:titleLabel];
//
//    UITextView *textView = [[UITextView alloc] initWithFrame:(CGRect) {titleLabel.right, titleLabel.top - 5.f, Screen_Width - 40.f - margin - titleLabel.right, 80.f}];
//    self.textView = textView;
//    textView.delegate = self;
//    textView.font = kFontSizeForDetail;
//    textView.textAlignment = NSTextAlignmentLeft;
//    textView.textContainerInset = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
//    [scrollView addSubview:textView];
}

- (void)btnEvent:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    
    if ([@"提交" isEqualToString:title]) {
//        if ([self.suggestion length] == 0) {
//            CXAlert(@"请选择意见");
//            return;
//        }
         __block NSString *reason;
        if ([self.suggestion isEqualToString:@"不同意"]) {
            [self dismiss];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"审批" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入理由";
            }];
            __weak typeof(self) weakSelf = self;

            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                sureAction.enabled = NO;
                [[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:UITextFieldTextDidChangeNotification object:nil];

//                UITextField *reasonTextField = alertController.textFields.firstObject;
//                reason = reasonTextField.text;
//                [self submitWithReason:reason];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:sureAction];
            [alertController addAction:cancelAction];
            [self.vc presentViewController:alertController animated:YES completion:nil];
        }else{
            [self submitWithReason:nil];
        }
        
    }
    if ([@"取消" isEqualToString:title]) {
        [self dismiss];
    }
}
//输入内容为空
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.vc.presentedViewController;
    if (alertController) {
        UITextField *remark = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        if (remark.text == nil || remark.text.length == 0) {
            [MBProgressHUD toastAtCenterForView:self.vc.view text:@"批审意见不能为空" duration:2];
            return;
        }else{
            okAction.enabled = YES;
            [self submitWithReason:remark.text];
            
        }
    }
}
- (void)submitWithReason:(NSString *)reason{
    NSString *url = [NSString stringWithFormat:@"%@holiday/resumption/approve", urlPrefix];
    //此处销假审批的请求
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"applyId"] = _applyId;
    param[@"applyUser"] = _applyUser;
    param[@"signed"] = [self.suggestion isEqualToString:@"同意"] ? @(2) : @(3);
    //        param[@"comments"] = trim(self.textView.text);
    param[@"reason"] = reason ? : @"";
    
    HUD_SHOW(nil);
    [MBProgressHUD showHUDForView:self text:HUDMessage];//添加loading
    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 [MBProgressHUD hideHUDInMainQueueForView:self];//隐藏loading
                                 if ([responseObj[@"status"] intValue] == HTTPSUCCESSOK) {
                                     MAKE_TOAST(responseObj[@"msg"]);
                                     [self dismiss];
                                     if (self.callBack) {
                                         self.callBack();
                                     }
//                                     CXAlertExt(@"提交成功", ^{
//                                         if (self.callBack) {
//                                             self.callBack();
//                                         }
//                                         [self dismiss];
//                                     });
                                 } else {
                                     MAKE_TOAST(responseObj[@"msg"]);
                                 }
                                 HUD_HIDE;
                             }
                             failure:^(NSError *error) {
                                 [MBProgressHUD hideHUDInMainQueueForView:self];//隐藏loading
                                 
                                 HUD_HIDE;
                                 CXAlert(KNetworkFailRemind);
                             }];
    
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
        make.height.mas_equalTo(rem_approval_height);
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
        make.height.mas_equalTo(rem_approval_height);
    }];
    
    [self setUpCenterView:centerView];
    
    // 底部视图
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(rem_approval_height);
    }];
    
    [self setUpBottomView:bottomView];
}

#pragma mark - life cycle

- (instancetype)initWithApplyId:(NSNumber *)applyId applyUser:(NSString *)applyUser; {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, rem_approval_height * 3}]) {
        self.backgroundColor = kColorWithRGB(248.f, 248.f, 248.f);
        _applyId = applyId;
        _applyUser = applyUser;
        [self setUpUI];
    }
    return self;
}


@end
 */
