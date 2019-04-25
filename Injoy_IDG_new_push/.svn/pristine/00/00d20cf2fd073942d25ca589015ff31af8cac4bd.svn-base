//
//  SDIMAddFriendsDetailsViewController.m
//  SDMarketingManagement
//
//  Created by wtz on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "SDIMAddFriendsDetailsViewController.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Category.h"
#import "SDIMPersonInfomationViewController.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"

//13位时间戳
#define kTimestamp ((long long)([[NSDate date] timeIntervalSince1970] * 1000))

@interface SDIMAddFriendsDetailsViewController()<UIAlertViewDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;

@end


@implementation SDIMAddFriendsDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.view.backgroundColor = SDBackGroudColor;
    
    // 导航栏
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:LocalString(@"详细资料")];
    
    UILabel* navtitleLabel = self.rootTopView.navTitleLabel;
    UseAutoLayout(navtitleLabel);
    
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(backBtnClick)];
    
    UIView * backWhiteView = [[UIView alloc] init];
    backWhiteView.frame = CGRectMake(0, navHigh + 15, Screen_Width, SDCellHeight);
    backWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backWhiteView];
    
    UIImageView * headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [headImageView addGestureRecognizer:tapGesture];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [backWhiteView addSubview:headImageView];
    
    UILabel * nameLabel = [[UILabel alloc] init];
    if(_userModel.name != nil){
        _userModel.realName = _userModel.name;
    }
    else if(_userModel.realName != nil){
        _userModel.name = _userModel.realName;
    }
    if(_userModel.name == nil || (_userModel.name != nil && [_userModel.name length] <= 0)){
        _userModel.name = _userModel.imAccount;
        _userModel.realName = _userModel.imAccount;
    }

    self.userModel.name = self.userModel.realName;
    nameLabel.text = self.userModel.name;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SDChatterDisplayNameColor;
    nameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    [nameLabel sizeToFit];
    nameLabel.x = CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing;
    nameLabel.y = CGRectGetMinY(headImageView.frame);
    [backWhiteView addSubview:nameLabel];
    
    UIImageView * sexImageView = [[UIImageView alloc] init];
    sexImageView.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + SDHeadImageViewLeftSpacing, CGRectGetMinY(headImageView.frame) - 2, 20, 20);
    if(self.userModel.sex && ![self.userModel.sex isKindOfClass:[NSNull class]] && [self.userModel.sex integerValue] == 0){
        sexImageView.image = [UIImage imageNamed:@"contact_women"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"contact_man"];
    }
    [backWhiteView addSubview:sexImageView];
    
    nameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing, CGRectGetMinY(headImageView.frame), Screen_Width - SDHeadImageViewLeftSpacing - 20 - SDHeadImageViewLeftSpacing - (CGRectGetMaxX(headImageView.frame) + SDHeadImageViewLeftSpacing), SDChatterDisplayNameFont);
    
    UIWebView * showImageWebView = [[UIWebView alloc] initWithFrame:CGRectMake(SDHeadImageViewLeftSpacing, CGRectGetMaxY(backWhiteView.frame) + 15, Screen_Width-SDHeadImageViewLeftSpacing*2, (Screen_Width-SDHeadImageViewLeftSpacing*2)*32/67)];
    showImageWebView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    showImageWebView.scalesPageToFit = YES;
    NSURL* url = [NSURL URLWithString:KContactInfoADURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [showImageWebView loadRequest:request];//加载
    [self.view addSubview:showImageWebView];
    
    UIButton * addToContactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addToContactsBtn.frame = CGRectMake(SDHeadImageViewLeftSpacing, CGRectGetMaxY(showImageWebView.frame) + 15, Screen_Width - SDHeadImageViewLeftSpacing*2, 55);
    addToContactsBtn.layer.cornerRadius = 5;
    addToContactsBtn.clipsToBounds = YES;
    addToContactsBtn.backgroundColor = SDBtnGreenColor;
    [addToContactsBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    [addToContactsBtn setTitle:@"添加到通讯录" forState:UIControlStateHighlighted];
    [addToContactsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addToContactsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [addToContactsBtn addTarget:self action:@selector(addToContactsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addToContactsBtn];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction:(id)sender
{
    SDIMPersonInfomationViewController* pivc = [[SDIMPersonInfomationViewController alloc] init];
    pivc.canPopViewController = YES;
    pivc.imAccount = _userModel.imAccount;
    [self.navigationController pushViewController:pivc animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)addToContactsBtnClick
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"你需要发送验证申请，等对方通过" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //发送验证申请
        NSString * path = [NSString stringWithFormat:@"%@friend/send",urlPrefix];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        [params setValue:self.userModel.imAccount forKey:@"friendImaccount"];
        [params setValue:@((long)[self.userModel.userId integerValue]) forKey:@"friendId"];
        [params setValue:self.userModel.realName?self.userModel.realName:@"" forKey:@"friendName"];
        [params setValue:self.userModel.icon?self.userModel.icon:@"" forKey:@"friendIcon"];
        UITextField * textField = [alertView textFieldAtIndex:0];
        if(textField.text == nil || (textField.text != nil && [textField.text length] <= 0)){
            [params setValue:@"无" forKey:@"remark"];
        }else{
            [params setValue:textField.text forKey:@"remark"];
        }
        [params setValue:@(kTimestamp).stringValue forKey:@"createTime"];
        __weak __typeof(self)weakSelf = self;
        [self showHudInView:self.view hint:@"正在加载数据"];
        [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
            [weakSelf hideHud];
            if ([JSON[@"status"] integerValue] == 200) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                TTAlert(@"已成功发送好友邀请");
            }
//            else if ([JSON[@"status"] intValue] == 400) {
//                [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//            }
            else{
                [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
            }
        } failure:^(NSError *error) {
            [weakSelf hideHud];
            CXAlert(KNetworkFailRemind);
        }];

    }
}

@end
