//
//  CXShareView.m
//  InjoyCRM
//
//  Created by cheng on 16/8/25.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXShareView.h"
#import "UMSocial.h"
#import "UIImage+YYAdd.h"
//#import "CXShareSelectContactViewController.h"
#import "UIView+YYAdd.h"
#import "NSString+YYAdd.h"
//#import "CXIsPayUserView.h"
//#import "CXOrderConfirmViewController.h"
#import "CXShareButton.h"
#import "Masonry.h"

@interface CXShareView ()
/** 内容视图 */
@property (weak, nonatomic) IBOutlet UIView *contentView;
/** 主内容view宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 标题高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;
/** 按钮容器 */
@property (weak, nonatomic) IBOutlet UIView *buttonView;
/** 微博 */
@property (weak, nonatomic) IBOutlet CXShareButton *weiboButton;
/** 微信 */
@property (weak, nonatomic) IBOutlet CXShareButton *wechatButton;
/** 朋友圈 */
@property (weak, nonatomic) IBOutlet CXShareButton *timelineButton;
/** QQ */
@property (weak, nonatomic) IBOutlet CXShareButton *qqButton;
/** QQ空间 */
@property (weak, nonatomic) IBOutlet CXShareButton *qzoneButton;
/** 个体富 */
@property (weak, nonatomic) IBOutlet CXShareButton *appButton;
/** 底部视图高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;
/** 底部视图 */
@property (weak, nonatomic) IBOutlet UIView *footerView;
/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/** 取消按钮宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonWidthConstraint;
/** 取消按钮高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@end

@implementation CXShareView

#pragma mark - LifeCycle

+ (instancetype)view {
    CXShareView *shareView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    shareView.shareToAppEnabled = YES;
    shareView.needPay = YES;
    [[NSNotificationCenter defaultCenter] addObserver:shareView selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    return shareView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"CXShareView dealloc");
}

#pragma mark - Public

- (void)show {
    UIView *containerView = [[UIApplication sharedApplication].delegate window];
    [self showInView:containerView];
}

- (void)showInView:(__kindof UIView *)view {
    
    // 是体验账号
    if ([urlPrefix hasPrefix:experienceString]) {
        CXAlert(@"体验账号不能分享");
        return;
    }
    
    self.shareTitle = [self.shareTitle stringByTrim];
    self.shareContent = [self.shareContent stringByTrim];
    self.shareUrl = [self.shareUrl stringByTrim];
    if (!self.shareTitle.length || !self.shareUrl.length) {
        CXAlert(kShareEmptyTips);
        return;
    }
    
    NSString *isPay = [[NSUserDefaults standardUserDefaults] valueForKey:@"isPay"];
    if (NO && self.needPay && [isPay isEqualToString:@"0"]) {
//        CXIsPayUserView *exampleView = [[CXIsPayUserView alloc] init];
//        @weakify(exampleView);
//        exampleView.didConfirmCallback = ^(BOOL yes) {
//            @strongify(exampleView);
//            NSString *status = yes ? @"0" : @"1";
//            [exampleView dismiss];
//            if ([status isEqualToString:@"1"])
//            {
//                CXOrderConfirmViewController *orderview = [[CXOrderConfirmViewController alloc] init];
//                UINavigationController *nav = (UINavigationController *) KEY_WINDOW.rootViewController;
//                [nav pushViewController:orderview animated:YES];
//                if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//                    nav.interactivePopGestureRecognizer.delegate = nil;
//                }
//            }
//        };
//        [exampleView show];
    }
    else {
        self.frame = view.bounds;
        
        // 分享按钮
        CGFloat buttonMargin = 5 * (Screen_Width / 375);
#if 0
        if (self.shareToAppEnabled) { // 3按钮 微信-QQ-个体富
            [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 60));
                make.center.equalTo(self.buttonView);
            }];
            [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.qqButton);
                make.centerY.equalTo(self.qqButton);
                make.trailing.equalTo(self.qqButton.mas_leading).offset(-buttonMargin);
            }];
            self.appButton.hidden = NO;
            [self.appButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.qqButton);
                make.centerY.equalTo(self.qqButton);
                make.leading.equalTo(self.qqButton.mas_trailing).offset(buttonMargin);
            }];
        }
        else { // 2按钮 微信-QQ
            [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 60));
                make.centerY.equalTo(self.buttonView);
                make.leading.equalTo(self.buttonView.mas_centerX).offset(buttonMargin / 2);
            }];
            [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(self.qqButton);
                make.centerY.equalTo(self.qqButton);
                make.trailing.equalTo(self.buttonView.mas_centerX).offset(-buttonMargin / 2);
            }];
            self.appButton.hidden = YES;
        }
#endif
      
        // 微博-微信-朋友圈
        
        [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.center.equalTo(self.buttonView);
        }];
        [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.wechatButton);
            make.centerY.equalTo(self.wechatButton);
            make.trailing.equalTo(self.wechatButton.mas_leading).offset(-buttonMargin);
        }];
        [self.timelineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.wechatButton);
            make.centerY.equalTo(self.wechatButton);
            make.leading.equalTo(self.wechatButton.mas_trailing).offset(buttonMargin);
        }];
        
        // 内容宽度
//        self.contentViewWidthConstraint.constant = kDialogWidth;
//        self.contentViewWidthConstraint.constant = Screen_Width;
        // 标题
        self.titleLabel.backgroundColor = kDialogHeaderBackgroundColor;
        self.titleLabelHeightConstraint.constant = kDialogHeaderHeight;
        self.titleLabel.font = kDialogTitleFont;
        // 底部
        self.buttonView.backgroundColor = kDialogContentBackgroundColor;
        self.footerView.backgroundColor = kDialogHeaderBackgroundColor;
        self.footerViewHeightConstraint.constant = kDialogFooterHeight;
        // 取消按钮
//        self.cancelButtonWidthConstraint.constant = kDialogButtonWidth;
//        self.cancelButtonHeightConstraint.constant = kDialogButtonHeight;
//        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.cancelButton setBackgroundImage:[UIImage imageWithColor:kDialogButtonBackgroundColor] forState:UIControlStateNormal];
//        self.cancelButton.titleLabel.font = kDialogButtonFont;
//        [self.cancelButton setTitle:[NSString stringWithFormat:@"取%@消", kDialogTextSpacing] forState:UIControlStateNormal];
        
        self.cancelButtonWidthConstraint.constant = Screen_Width;
        self.cancelButtonHeightConstraint.constant = kDialogFooterHeight;
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = self.titleLabel.font;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        self.titleLabel.backgroundColor = RGBACOLOR(255, 255, 255, 0.93);
        self.buttonView.backgroundColor = RGBACOLOR(255, 255, 255, 0.93);
        self.footerView.backgroundColor = RGBACOLOR(230, 230, 230, 0.93);
        self.cancelButton.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.textColor = kColorWithRGB(66, 66, 66);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [view addSubview:self];
        NSLog(@"\nshareUrl:%@\nshareTitle:%@\nshareContent:%@", self.shareUrl, self.shareTitle, self.shareContent);
        
        // 动画
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        CGFloat contentViewHeight = GET_HEIGHT(self.contentView);
        self.contentViewBottomConstraint.constant = contentViewHeight;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.contentViewBottomConstraint.constant = 0;
        self.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            self.alpha = 1;
        }];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    }
}

- (void)dismiss {
    CGFloat contentViewHeight = GET_WIDTH(self.contentView);
    self.contentViewBottomConstraint.constant = contentViewHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)reset {
    self.shareTitle = self.shareContent = self.shareUrl = nil;
}

#pragma mark - Action

/** 取消 */
- (IBAction)cancelBtnTapped:(UIButton *)sender {
    [self dismiss];
}

/** 分享到app */
- (IBAction)shareToApp:(id)sender {
    NSLog(@"分享到APP");
    //    TTAlert(@"暂未开通此功能，敬请期待！");
    //    [self dismiss];
    //    return;
    
//    CXShareSelectContactViewController *shareSelectContactViewController = [[CXShareSelectContactViewController alloc] init];
//    shareSelectContactViewController.shareTitle = self.shareTitle;
//    shareSelectContactViewController.shareContent = self.shareContent;
//    shareSelectContactViewController.shareUrl = self.shareUrl;
//    UINavigationController *nav = (UINavigationController *) KEY_WINDOW.rootViewController;
//    [nav pushViewController:shareSelectContactViewController animated:YES];
//    [self dismiss];
}


//- (IBAction)shareToApp:(UIButton *)sender {
//    
//}

/** 分享到微信好友 */
- (IBAction)shareToWechatFriend:(UIButton *)sender {
    NSLog(@"分享到微信好友");
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:Image(@"AppIcon60x60") location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismiss];
}

/** 分享到微信朋友圈 */
- (IBAction)shareToWechatTimeline:(id)sender {
    NSLog(@"分享到朋友圈");
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:Image(@"AppIcon60x60") location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismiss];
}

/** 分享到QQ */
- (IBAction)shareToQQ:(id)sender {
    NSLog(@"分享到QQ好友");
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:Image(@"AppIcon60x60") location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismiss];
}

/** 分享到QQ空间 */
- (IBAction)shareToQZone:(id)sender {
    NSLog(@"分享到QQ空间");
    [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.shareContent image:Image(@"AppIcon60x60") location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismiss];
}

/** 分享到新浪微博 */
- (IBAction)shareToSinaWeibo:(id)sender {
    NSLog(@"分享到新浪微博");
    NSString *shareContent = [self.shareTitle stringByAppendingString:self.shareUrl];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:shareContent image:Image(@"AppIcon60x60") location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    [self dismiss];
}

/** 复制链接 */
- (IBAction)copyLink:(id)sender {
    [UIPasteboard generalPasteboard].string = self.shareUrl;
    NSLog(@"复制链接->%@", self.shareUrl);
    MAKE_TOAST(@"复制成功");
    [self dismiss];
}

#pragma mark - Notification

- (void)loginStateChange:(NSNotification *)noti {
    BOOL loginSuccess = [noti.object boolValue];
    if (!loginSuccess) {
//        [self dismiss];
    }
}

@end
