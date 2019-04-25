//
//  CXSendShareView.m
//  InjoyERP
//
//  Created by wtz on 16/12/1.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "CXSendShareView.h"
#import "UIView+Category.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "SDIMChatViewController.h"
#import "UIView+YYAdd.h"

#define kBgBackgroundcolor RGBACOLOR(80.0,80.0,80.0,0.6)

#define kMiddleLineViewColor RGBACOLOR(239.0,239.0,241.0,1.0)

#define kWhiteBackViewLeftSpace 30.0

#define kWhiteBackViewTopMove 40.0

#define kWhiteBackViewCornerRadios 5.0

#define kSendTitleLabelTopSpace 20.0

#define kSendTitleLabelLeftSpace 20.0

#define kSendTitleLabelFontSize 16.0

#define kSendTitleLabelBottomSpace 10.0

#define kHeadImageViewWidth 40.0

#define kHeadImageViewCornerRadios 3.0

#define kShareNameLabelLeftSpace 15.0

#define kShareNameLabelFontSize 16.0

#define kHeadImageViewBottomSpace 10.0

#define kShareTitleLabelTopSpace 10.0

#define kShareTitleLabelFontSize 14.0

#define kShareTitleLabelTextColor RGBACOLOR(157.0, 157.0, 158.0, 1.0)

#define kShareContentLabelTopSpace 5.0

#define kShareContentLabelFontSize 14.0

#define kShareContentLabelTextColor RGBACOLOR(157.0, 157.0, 158.0, 1.0)

#define kTextViewTopSpace 10.0

#define kTextViewFontSize 14.0

#define kTextViewHeight 34.0

#define kTextViewTextColor RGBACOLOR(195.0, 195.0, 195.0, 1.0)

#define kTextViewBottomSpace 20.0

#define kBtnTopLineColor RGBACOLOR(195.0, 195.0, 195.0, 1.0)

#define kBtnHeight 45.0


@interface CXSendShareView()<UITextViewDelegate>

@property (nonatomic, strong) NSString * shareTitle;

@property (nonatomic, strong) SDCompanyUserModel * shareUserModel;

@property (nonatomic, strong) CXGroupInfo * groupInfo;

@property (nonatomic, strong) NSString * shareContent;

@property (nonatomic, strong) NSString * shareUrl;

@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UIView * whiteBackView;

@property (nonatomic, strong) UILabel * sendTitleLabel;

@property (nonatomic, strong) UIImageView * headImageView;

@property (nonatomic, strong) UILabel * shareNameLabel;

@property (nonatomic, strong) UIView * middleLineView;

@property (nonatomic, strong) UILabel * shareTitleLabel;

@property (nonatomic, strong) UILabel * shareContentLabel;

@property (nonatomic, strong) UITextView * textView;

@property (nonatomic, strong) UIView * btnTopLine;

@property (nonatomic, strong) UIView * btnMiddleLine;

@property (nonatomic, strong) UIButton * cancleBtn;

@property (nonatomic, strong) UIButton * sendBtn;

@property (nonatomic, strong) UIViewController * viewController;

@end

@implementation CXSendShareView

- (id)initWithShareTitle:(NSString *)shareTitle AndShareUser:(SDCompanyUserModel *)shareUserModel AndCXGroupInfo:(CXGroupInfo *)groupInfo AndShareContent:(NSString *)shareContent AndShareUrl:(NSString *)shareUrl AndController:(UIViewController *)viewController
{
    if (self = [super init]) {
        self.shareTitle = shareTitle;
        self.shareUserModel = shareUserModel;
        self.groupInfo = groupInfo;
        self.shareContent = shareContent;
        self.shareUrl = shareUrl;
        self.viewController = viewController;
        
        if(self.shareTitle == nil || (self.shareTitle != nil && [self.shareTitle length] <= 0)){
            TTAlert(@"分享标题缺失");
            return nil;
        }
        if(self.shareContent == nil || (self.shareContent != nil && [self.shareContent length] <= 0)){
            TTAlert(@"分享内容缺失");
            return nil;
        }
        if(self.shareUrl == nil || (self.shareUrl != nil && [self.shareUrl length] <= 0)){
            TTAlert(@"分享链接缺失");
            return nil;
        }

        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    _bgView = [[UIView alloc] init];
    _bgView.frame = KEY_WINDOW.frame;
    _bgView.backgroundColor = kBgBackgroundcolor;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap)];
    [_bgView addGestureRecognizer:tap];
    [KEY_WINDOW addSubview:_bgView];
    
    _whiteBackView = [[UIView alloc] init];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    _whiteBackView.userInteractionEnabled = YES;
    _whiteBackView.layer.cornerRadius = kWhiteBackViewCornerRadios;
    _whiteBackView.clipsToBounds = YES;
    [KEY_WINDOW addSubview:_whiteBackView];
    
    _sendTitleLabel = [[UILabel alloc] init];
    _sendTitleLabel.text = @"发送给:";
    _sendTitleLabel.font = [UIFont boldSystemFontOfSize:kSendTitleLabelFontSize];
    [_sendTitleLabel sizeToFit];
    _sendTitleLabel.frame = CGRectMake(kSendTitleLabelLeftSpace, kSendTitleLabelTopSpace, _sendTitleLabel.size.width, _sendTitleLabel.size.height);
    _sendTitleLabel.textColor = [UIColor blackColor];
    _sendTitleLabel.backgroundColor = [UIColor clearColor];
    [_whiteBackView addSubview:_sendTitleLabel];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.frame = CGRectMake(kSendTitleLabelLeftSpace, CGRectGetMaxY(_sendTitleLabel.frame) + kSendTitleLabelBottomSpace, kHeadImageViewWidth, kHeadImageViewWidth);
    _headImageView.layer.cornerRadius = kHeadImageViewCornerRadios;
    _headImageView.clipsToBounds = YES;
    if(_groupInfo){
        _headImageView.image = [CXIMHelper getImageFromGroup:_groupInfo];
    }else{
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.shareUserModel.icon] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    }
    [_whiteBackView addSubview:_headImageView];
    
    _shareNameLabel = [[UILabel alloc] init];
    if(_groupInfo){
        _shareNameLabel.text = _groupInfo.groupName;
    }else{
        _shareNameLabel.text = _shareUserModel.name;
    }
    _shareNameLabel.font = [UIFont boldSystemFontOfSize:kShareNameLabelFontSize];
    [_shareNameLabel sizeToFit];
    _shareNameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + kShareNameLabelLeftSpace, CGRectGetMinY(_headImageView.frame) + (kHeadImageViewWidth - kShareNameLabelFontSize)/2, _shareNameLabel.size.width, _shareNameLabel.size.height);
    _shareNameLabel.textColor = [UIColor blackColor];
    _shareNameLabel.backgroundColor = [UIColor clearColor];
    [_whiteBackView addSubview:_shareNameLabel];
    
    _middleLineView = [[UIView alloc] init];
    _middleLineView.frame = CGRectMake(kSendTitleLabelLeftSpace, CGRectGetMaxY(_headImageView.frame) + kHeadImageViewBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kSendTitleLabelLeftSpace, 0.5);
    _middleLineView.backgroundColor = kMiddleLineViewColor;
    [_whiteBackView addSubview:_middleLineView];
    
    _shareTitleLabel = [[UILabel alloc] init];
    _shareTitleLabel.text = _shareTitle;
    _shareTitleLabel.numberOfLines = 0;
    _shareTitleLabel.font = [UIFont systemFontOfSize:kShareTitleLabelFontSize];
    CGSize shareTitleLabelSize = [_shareTitleLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kSendTitleLabelLeftSpace, LONG_MAX)];
    _shareTitleLabel.frame = CGRectMake(kSendTitleLabelLeftSpace, CGRectGetMaxY(_middleLineView.frame) + kShareTitleLabelTopSpace, shareTitleLabelSize.width, shareTitleLabelSize.height);
    _shareTitleLabel.textColor = kShareTitleLabelTextColor;
    _shareTitleLabel.backgroundColor = [UIColor clearColor];
    [_whiteBackView addSubview:_shareTitleLabel];
    
    _shareContentLabel = [[UILabel alloc] init];
    _shareContentLabel.text = _shareContent;
    _shareContentLabel.numberOfLines = 0;
    _shareContentLabel.font = [UIFont systemFontOfSize:kShareContentLabelFontSize];
    CGSize shareContentLabelSize = [_shareContentLabel sizeThatFits:CGSizeMake(Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kSendTitleLabelLeftSpace, LONG_MAX)];
    _shareContentLabel.frame = CGRectMake(kSendTitleLabelLeftSpace, CGRectGetMaxY(_shareTitleLabel.frame) + kShareContentLabelTopSpace, shareContentLabelSize.width, shareContentLabelSize.height);
    _shareContentLabel.textColor = kShareTitleLabelTextColor;
    _shareContentLabel.backgroundColor = [UIColor clearColor];
    [_whiteBackView addSubview:_shareContentLabel];

    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(kSendTitleLabelLeftSpace, CGRectGetMaxY(_shareContentLabel.frame) + kTextViewTopSpace, Screen_Width - 2*kWhiteBackViewLeftSpace - 2*kSendTitleLabelLeftSpace, kTextViewHeight);
    _textView.textColor = kTextViewTextColor;
    _textView.font = [UIFont systemFontOfSize:kTextViewFontSize];
    _textView.returnKeyType = UIReturnKeySend;
    _textView.spellCheckingType = UITextSpellCheckingTypeNo;
    _textView.delegate = self;
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.layer.borderColor = RGBACOLOR(232.0, 239.0, 232.0, 1.0).CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 3.0;
    _textView.text = @"给朋友留言";
    _textView.textColor = [UIColor grayColor];
    [_whiteBackView addSubview:_textView];
    
    _btnTopLine = [[UIView alloc] init];
    _btnTopLine.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + kTextViewBottomSpace, Screen_Width - 2*kWhiteBackViewLeftSpace, 0.5);
    _btnTopLine.backgroundColor = kBtnTopLineColor;
    [_whiteBackView addSubview:_btnTopLine];
    
    _btnMiddleLine = [[UIView alloc] init];
    _btnMiddleLine.frame = CGRectMake((Screen_Width - 2*kWhiteBackViewLeftSpace - 0.5)/2, CGRectGetMaxY(_btnTopLine.frame), 0.5, kBtnHeight);
    _btnMiddleLine.backgroundColor = kBtnTopLineColor;
    [_whiteBackView addSubview:_btnMiddleLine];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(_btnTopLine.frame), (Screen_Width - 2*kWhiteBackViewLeftSpace - 0.5)/2, kBtnHeight);
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_cancleBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake((Screen_Width - 2*kWhiteBackViewLeftSpace - 0.5)/2 + 0.5, CGRectGetMaxY(_btnTopLine.frame), (Screen_Width - 2*kWhiteBackViewLeftSpace - 0.5)/2, kBtnHeight);
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateHighlighted];
    [_sendBtn setTitleColor:RGBACOLOR(44.0, 179.0, 36.0, 1.0) forState:UIControlStateNormal];
    [_sendBtn setTitleColor:RGBACOLOR(44.0, 179.0, 36.0, 1.0) forState:UIControlStateHighlighted];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_sendBtn];
    
    _whiteBackView.frame = CGRectMake(kWhiteBackViewLeftSpace, (Screen_Height - CGRectGetMaxY(_sendBtn.frame))/2 - kWhiteBackViewTopMove, Screen_Width - 2*kWhiteBackViewLeftSpace, CGRectGetMaxY(_sendBtn.frame));
}

- (void)bgViewTap
{
    [_bgView removeFromSuperview];
    [_whiteBackView removeFromSuperview];
}

- (void)cancleBtnClick
{
    [self bgViewTap];
}

- (void)sendBtnClick
{
    CXIMMessage *message = [[CXIMMessage alloc] init];
    message.sender = VAL_HXACCOUNT;
    if(self.groupInfo){
        message.receiver = self.groupInfo.groupId;
        message.readAsk = CXIMMessageReadFlagNoFlag;
        message.type = CXIMMessageTypeGroupChat;
    }else{
        message.receiver = self.shareUserModel.hxAccount;
        message.readAsk = CXIMMessageReadFlagUnRead;
        message.type = CXIMMessageTypeChat;
    }
    message.body = [CXIMTextMessageBody bodyWithTextContent:[NSString stringWithFormat:@"分享"]];
    NSMutableDictionary *ext = @{}.mutableCopy;
    NSDictionary* extDict = @{ @"shareTitle" : self.shareTitle,
                               @"shareContent" : self.shareContent,
                               @"shareUrl" : self.shareUrl
                               };
    ext[@"shareDic"] = extDict;
    message.ext = ext;
    
    __weak __typeof(self)weakSelf = self;
    [self.viewController showHudInView:self.viewController.view hint:nil];
    [[CXIMService sharedInstance].chatManager sendMessage:message onProgress:nil completion:^(CXIMMessage *message, NSError *error) {
        if(error){
            [weakSelf.viewController hideHud];
            TTAlert(@"分享失败");
            return;
        }else{
            if(self.textView.text && ![self.textView.text isEqualToString:@"给朋友留言"] && [self.textView.text length] > 0){
                CXIMMessage *sendMessage = [[CXIMMessage alloc] init];
                sendMessage.sender = VAL_HXACCOUNT;
                if(self.groupInfo){
                    sendMessage.receiver = self.groupInfo.groupId;
                    sendMessage.readAsk = CXIMMessageReadFlagNoFlag;
                    sendMessage.type = CXIMMessageTypeGroupChat;
                }else{
                    sendMessage.receiver = self.shareUserModel.hxAccount;
                    sendMessage.readAsk = CXIMMessageReadFlagUnRead;
                    sendMessage.type = CXIMMessageTypeChat;
                }
                sendMessage.body = [CXIMTextMessageBody bodyWithTextContent:self.textView.text];
                [[CXIMService sharedInstance].chatManager sendMessage:sendMessage onProgress:nil completion:^(CXIMMessage *message, NSError *error) {
                    if(error){
                        [weakSelf.viewController hideHud];
                        TTAlert(@"分享失败");
                    }else{
                        [weakSelf.viewController hideHud];
                        SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
                        if(self.groupInfo){
                            chatVC.isGroupChat = YES;
                            chatVC.chatter = self.groupInfo.groupId;
                            chatVC.chatterDisplayName = self.groupInfo.groupName;
                        }else{
                            chatVC.isGroupChat = NO;
                            chatVC.chatter = self.shareUserModel.imAccount;
                            chatVC.chatterDisplayName = self.shareUserModel.name;
                        }
                        UINavigationController * nav = (UINavigationController *)KEY_WINDOW.rootViewController;
                        [nav pushViewController:chatVC animated:YES];
                    }
                }];
            }
            else{
                [weakSelf.viewController hideHud];
                SDIMChatViewController *chatVC = [[SDIMChatViewController alloc] init];
                if(self.groupInfo){
                    chatVC.isGroupChat = YES;
                    chatVC.chatter = self.groupInfo.groupId;
                    chatVC.chatterDisplayName = self.groupInfo.groupName;
                }else{
                    chatVC.isGroupChat = NO;
                    chatVC.chatter = self.shareUserModel.imAccount;
                    chatVC.chatterDisplayName = self.shareUserModel.name;
                }
                UINavigationController * nav = (UINavigationController *)KEY_WINDOW.rootViewController;
                [nav pushViewController:chatVC animated:YES];
            }
        }
    }];

    [self bgViewTap];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"给朋友留言"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"给朋友留言";
    }
}

@end
