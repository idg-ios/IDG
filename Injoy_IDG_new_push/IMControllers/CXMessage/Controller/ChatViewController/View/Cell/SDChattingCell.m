//
//  SDChattingCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingCell.h"
#import "SDChattingTextCell.h"
#import "SDChattingImageCell.h"
#import "SDChattingLocationCell.h"
#import "SDChattingVoiceCell.h"
#import "SDChattingSystemNotifyCell.h"
#import "SDChattingFileCell.h"
#import "SDChattingVideoCell.h"
#import "UIView+Category.h"
#import "UIImageView+EMWebCache.h"
#import "CXIMHelper.h"
#import "SDChatMapViewController.h"
#import "CXLoaclDataManager.h"

#define kLockImageWidth 12
#define kDeleteMessageCountViewWidth kLockImageWidth

@interface SDChattingCell () <UIAlertViewDelegate>

@property (nonatomic,strong) UIMenuController *menuController;

@end

@implementation SDChattingCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewLongPressed:)]];
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"im_message_location"] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(locationBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_locationBtn];
    }
    return _locationBtn;
}

- (UIButton *)readOrUnReadBtn {
    if (!_readOrUnReadBtn) {
        _readOrUnReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readOrUnReadBtn.frame = CGRectMake(0, 0, 35, 18);
        _readOrUnReadBtn.backgroundColor = RGBACOLOR(47.0, 161.0, 76.0, 1.0);
        [_readOrUnReadBtn setTitle:@"送达" forState:UIControlStateNormal];
        [_readOrUnReadBtn setTitle:@"送达" forState:UIControlStateHighlighted];
        [_readOrUnReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_readOrUnReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _readOrUnReadBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _readOrUnReadBtn.layer.cornerRadius = 5.0;
        _readOrUnReadBtn.clipsToBounds = YES;
        [self.contentView addSubview:_readOrUnReadBtn];
    }
    return _readOrUnReadBtn;
}

- (UIActivityIndicatorView *)sendingStatusIndicator{
    if (!_sendingStatusIndicator) {
        _sendingStatusIndicator = [[UIActivityIndicatorView alloc] init];
        _sendingStatusIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _sendingStatusIndicator.hidden = YES;
        [self.contentView addSubview:_sendingStatusIndicator];
    }
    return _sendingStatusIndicator;
}

- (UIButton *)failedResendBtn{
    if (!_failedResendBtn) {
        _failedResendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failedResendBtn setBackgroundImage:[UIImage imageNamed:@"message-send-fail"] forState:UIControlStateNormal];
        [_failedResendBtn addTarget:self action:@selector(failResendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _failedResendBtn.hidden = YES;
        [self.contentView addSubview:_failedResendBtn];
    }
    return _failedResendBtn;
}

-(UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
        _timeLabel.layer.cornerRadius = 3;
        _timeLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UIImageView *)burnAfterReadLockAndUnLockView{
    if(_burnAfterReadLockAndUnLockView == nil){
        _burnAfterReadLockAndUnLockView = [[UIImageView alloc] init];
        if(self.isFromSelf){
            _burnAfterReadLockAndUnLockView.image = [UIImage imageNamed:@"unLock"];
            _burnAfterReadLockAndUnLockView.highlightedImage = [UIImage imageNamed:@"unLock"];
        }else{
            _burnAfterReadLockAndUnLockView.image = [UIImage imageNamed:@"lock"];
            _burnAfterReadLockAndUnLockView.highlightedImage = [UIImage imageNamed:@"lock"];
        }
        [self.contentView addSubview:_burnAfterReadLockAndUnLockView];
    }
    return _burnAfterReadLockAndUnLockView;
}

-(UIView *)deleteMessageCountView{
    if(_deleteMessageCountView == nil){
        _deleteMessageCountView = [[UIView alloc] init];
        _deleteMessageCountView.backgroundColor = [UIColor redColor];
        _deleteMessageCountView.layer.cornerRadius = kDeleteMessageCountViewWidth/2;
        _deleteMessageCountView.clipsToBounds = YES;
        [self.contentView addSubview:_deleteMessageCountView];
    }
    return _deleteMessageCountView;
}

-(UILabel *)deleteTimeCountLabel{
    if(_deleteTimeCountLabel == nil){
        _deleteTimeCountLabel = [[UILabel alloc] init];
        _deleteTimeCountLabel.textAlignment = NSTextAlignmentCenter;
        _deleteTimeCountLabel.font = [UIFont systemFontOfSize:8];
        _deleteTimeCountLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_deleteTimeCountLabel];
    }
    return _deleteTimeCountLabel;
}

#pragma mark - 外部方法
+(NSString *)identifierForContentType:(CXIMMessageContentType)type{
    NSString *identifier = @"";
    switch (type) {
            // 文本内容
        case CXIMMessageContentTypeText:
            identifier = NSStringFromClass(SDChattingTextCell.class);
            break;
            
            // 图片
        case CXIMMessageContentTypeImage:
        {
            identifier = NSStringFromClass(SDChattingImageCell.class);
            break;
        }
            
            // 位置
        case CXIMMessageContentTypeLocation:
        {
            identifier = NSStringFromClass(SDChattingLocationCell.class);
            break;
        }
            
            // 语音
        case CXIMMessageContentTypeVoice:
        {
            identifier = NSStringFromClass(SDChattingVoiceCell.class);
            break;
        }
            
            // 系统通知
        case CXIMMessageContentTypeSystemNotify:
        {
            identifier = NSStringFromClass(SDChattingSystemNotifyCell.class);
            break;
        }
            
            // 文件
        case CXIMMessageContentTypeFile:
        {
            identifier = NSStringFromClass(SDChattingFileCell.class);
            break;
        }
            // 视频
        case CXIMMessageContentTypeVideo:
        {
            identifier = NSStringFromClass(SDChattingVideoCell.class);
            break;
        }
        default:
            NSAssert(NO, @"不支持的消息类型");
            break;
    }
    return identifier;
}

+(SDChattingCell *)createCellForIdentifier:(NSString *)identifier{
    Class cellClass = NSClassFromString(identifier);
    SDChattingCell *cell = [[cellClass alloc] init];
    return cell;
}

#pragma mark - 子类属性
- (NSString *)chatter {
    return self.isFromSelf ? self.message.receiver : self.message.sender;
}

- (BOOL)isNeedDisplayTime{
    NSInteger span = labs((_message.sendTime.integerValue - self.compareTime) / 1000);
    BOOL needDisplayTime = span >= 10*60;
    return needDisplayTime;
}

- (BOOL)isGroupChat {
    return self.message.type == CXIMMessageTypeGroupChat;
}

- (BOOL)isFromSelf {
    return [self.message.sender isEqualToString:VAL_HXACCOUNT];
}

- (BOOL)isChatMessage {
    return self.message.body.type != CXIMMessageContentTypeSystemNotify;
}

- (BOOL)isNeedDisplayNickname {
    return self.message.type == CXIMMessageTypeGroupChat && !self.isFromSelf;
}

- (BOOL)isNeedDisplayLocationBtn {
    if (self.isChatMessage && !self.isGroupChat && self.message.ext[@"location"] && !self.isFromSelf && VAL_OPEN_GET_LOCATION && VAL_ENABLE_GET_LOCATION && self.canSeeLocation) {
        return YES;
    }
    return NO;
}

- (BOOL)isNeedDisplayReadOrUnReadBtn {
    if (self.isChatMessage && !self.isGroupChat && self.message.status == CXIMMessageStatusSendSuccess && self.isFromSelf && self.message.readAsk != CXIMMessageReadFlagNoFlag && !self.isNotNeedShowReadOrUnRead && VAL_OPEN_READ_FLAG) {
        return YES;
    }
    return NO;
}

- (BOOL)isBurnAfterReadMessage {
    if ([self.message.ext[@"isBurnAfterRead"] isEqualToString:@(YES).stringValue]) {
        return YES;
    }
    return NO;
}

#pragma mark - 子类方法
-(UITableView *)getTableView{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            return (UITableView *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UIMenuController
- (UIMenuController *)menuController{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    return _menuController;
}

- (void)contentViewLongPressed:(UILongPressGestureRecognizer *)gesture{
    if (![self respondsToSelector:NSSelectorFromString(@"containerView")]) {
        return;
    }
    UIView *containerView = [self valueForKey:@"containerView"];
    CGPoint location = containerView ? [gesture locationInView:containerView] : CGPointZero;
    if (!containerView || !CGRectContainsPoint(containerView.bounds, location)) {
        return;
    }
    [self becomeFirstResponder];
    NSMutableArray *menuItems = [NSMutableArray array];
    if ([self menuItemEnabled:SDChattingCellMenuItemCopy]) {
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyTapped)]];
    }
    if ([self menuItemEnabled:SDChattingCellMenuItemDelete]){
        [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(delTapped)]];
    }
    if(!self.isBurnAfterReadMessage){
        if ([self menuItemEnabled:SDChattingCellMenuItemForward]){
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardTapped)]];
        }
    }
    self.menuController.menuItems = menuItems;
    [self.menuController setTargetRect:containerView.frame inView:self];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (BOOL)menuItemEnabled:(SDChattingCellMenuItem)item{
    if(self.isBurnAfterReadMessage){
        return item == SDChattingCellMenuItemDelete;
    }
    return item == SDChattingCellMenuItemDelete || item == SDChattingCellMenuItemForward;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyTapped)) {
        return YES;
    }
    if (action == @selector(delTapped)) {
        return YES;
    }
    if (action == @selector(forwardTapped)) {
        return YES;
    }
    return NO;
}

- (void)copyTapped{
    if ([self.delegate respondsToSelector:@selector(chattingCell:didTapMenuItem:message:)]) {
        [self.delegate chattingCell:self didTapMenuItem:SDChattingCellMenuItemCopy message:self.message];
    }
}

- (void)delTapped{
    if ([self.delegate respondsToSelector:@selector(chattingCell:didTapMenuItem:message:)]) {
        [self.delegate chattingCell:self didTapMenuItem:SDChattingCellMenuItemDelete message:self.message];
    }
}

- (void)forwardTapped{
    if ([self.delegate respondsToSelector:@selector(chattingCell:didTapMenuItem:message:)]) {
        [self.delegate chattingCell:self didTapMenuItem:SDChattingCellMenuItemForward message:self.message];
    }
}


#pragma mark - 初始化cell
-(void)initCell{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - set方法
-(void)setMessage:(CXIMMessage *)message{
    _message = message;
    SDCompanyUserModel *userModel;
    
    if([self isGroupChat]){
        userModel = [[CXLoaclDataManager sharedInstance] getUserByGroupId:self.message.receiver AndIMAccount:message.sender];
    }else{
        userModel = [CXIMHelper getUserByIMAccount:message.sender];
    }
    
    if (![message.body isKindOfClass:[CXIMSystemNotifyMessageBody class]]) {
        // 头像
        UIImageView *avatarImageView = [self valueForKey:@"avatarImageView"];
        if (avatarImageView) {
            [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", (userModel.icon&&![userModel.icon isKindOfClass:[NSNull class]]&&userModel.icon.length) ? userModel.icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
        }
        
        // 昵称
        UILabel *nicknameLabel = [self valueForKey:@"nicknameLabel"];
        if (nicknameLabel) {
            nicknameLabel.hidden = !self.isNeedDisplayNickname;
        }
    }
    
    // 时间
    self.timeLabel.hidden = !self.isNeedDisplayTime;
    if (self.isNeedDisplayTime) { // 显示时间
        self.timeLabel.text = [NSString stringWithFormat:@" %@ ", message.transformedTime];
        [self.timeLabel sizeToFit];
        self.timeLabel.y = kTimeLabelTopBottomMargin - 5;
        self.timeLabel.centerX = Screen_Width * .5;
    }
    
    if(self.isFromSelf && message.readAsk == CXIMMessageReadFlagReaded){
        [self.readOrUnReadBtn setTitle:@"已读" forState:UIControlStateNormal];
        [self.readOrUnReadBtn setTitle:@"已读" forState:UIControlStateHighlighted];
    }else{
        [self.readOrUnReadBtn setTitle:@"送达" forState:UIControlStateNormal];
        [self.readOrUnReadBtn setTitle:@"送达" forState:UIControlStateHighlighted];
    }
    
    self.sendingStatusIndicator.hidden = message.status != CXIMMessageStatusSending;
    self.sendingStatusIndicator.hidden ? [self.sendingStatusIndicator stopAnimating] : [self.sendingStatusIndicator startAnimating];
    self.failedResendBtn.hidden = message.status != CXIMMessageStatusSendFailed;
    
    if([message.ext[@"isBurnAfterRead"] isEqualToString:@"1"]){
        self.burnAfterReadLockAndUnLockView.hidden = NO;
    }else{
        self.burnAfterReadLockAndUnLockView.hidden = YES;
    }
    
    self.deleteMessageCountView.hidden = YES;
    self.deleteTimeCountLabel.hidden = YES;
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * messageDeleteTimeCountDic = [[ud objectForKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]] mutableCopy ] ?: @{}.mutableCopy;
    if(messageDeleteTimeCountDic && [messageDeleteTimeCountDic count] >0){
        [messageDeleteTimeCountDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            if([key isEqualToString:self.message.ID]){
                self.deleteMessageCountView.hidden = NO;
                self.deleteTimeCountLabel.hidden = NO;
                self.deleteTimeCountLabel.text = obj;
                *stop = YES;
            }
        }];
    }
}

#pragma mark - Action
// 点击了位置按钮
- (void)locationBtnTapped {
    if (self.message.ext[@"location"]) {
        CXIMLocationInfo *location = [CXIMLocationInfo yy_modelWithJSON:self.message.ext[@"location"]];
        SDChatMapViewController *locationController = [[SDChatMapViewController alloc] initWithLocation:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
        locationController.address = location.address;
        locationController.showAddressAnnotation = YES;
        [self.viewController.navigationController pushViewController:locationController animated:YES];
        if ([self.viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.viewController.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

// 点击了头像
- (void)avatarImageViewTapped {
    if ([self.delegate respondsToSelector:@selector(chattingCell:didTapAvatar:)]) {
        [self.delegate chattingCell:self didTapAvatar:NULL];
    }
}

//启动阅后即焚定时器
- (void)startBurnAfterReadTimer{
    [self.delegate chattingCell:self didStartBurnMessagesAfterReadTimer:NULL];
}

- (void)failResendBtnClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重新发送消息?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:(@selector(chattingCell:didTapSendFailedBtn:))]){
            [self.delegate chattingCell:self didTapSendFailedBtn:NULL];
        }
    }
}

#pragma mark - 子类调用
- (void)subClassLayoutSubviews {
    self.locationBtn.hidden = !self.isNeedDisplayLocationBtn;
    self.readOrUnReadBtn.hidden = !self.isNeedDisplayReadOrUnReadBtn;
    if (![self respondsToSelector:NSSelectorFromString(@"backBtn")]) {
        return;
    }
    UIView *bubbleView = [self valueForKey:@"backBtn"];
    [self.locationBtn sizeToFit];
    [self.sendingStatusIndicator sizeToFit];
    [self.failedResendBtn sizeToFit];
    
    self.burnAfterReadLockAndUnLockView.width = kLockImageWidth;
    self.burnAfterReadLockAndUnLockView.height = kLockImageWidth;
    if(self.isFromSelf){
        self.burnAfterReadLockAndUnLockView.centerY = CGRectGetMinY(bubbleView.frame);
        self.burnAfterReadLockAndUnLockView.centerX = CGRectGetMinX(bubbleView.frame);
    }else{
        self.burnAfterReadLockAndUnLockView.centerY = CGRectGetMinY(bubbleView.frame);
        self.burnAfterReadLockAndUnLockView.centerX = CGRectGetMaxX(bubbleView.frame);
        
        self.deleteMessageCountView.frame = self.burnAfterReadLockAndUnLockView.frame;
        self.deleteTimeCountLabel.frame = self.burnAfterReadLockAndUnLockView.frame;
    }
    
    self.locationBtn.centerY = bubbleView.centerY;
    self.readOrUnReadBtn.centerY = bubbleView.centerY;
    self.sendingStatusIndicator.centerY = bubbleView.centerY;
    self.failedResendBtn.centerY = bubbleView.centerY;
    if (self.isNeedDisplayLocationBtn) {
        if ([self isKindOfClass:[SDChattingVoiceCell class]]) {
            UILabel *voiceLabel = [self valueForKey:@"voiceLabel"];
            if (self.isFromSelf) {
                if(self.isNeedDisplayReadOrUnReadBtn){
                    self.readOrUnReadBtn.x = voiceLabel.x - 10 - self.readOrUnReadBtn.size.width;
                    self.sendingStatusIndicator.x = self.readOrUnReadBtn.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }else{
                    self.sendingStatusIndicator.x = voiceLabel.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }
            }
            else {
                self.locationBtn.x = CGRectGetMaxX(voiceLabel.frame) + 10;
                self.sendingStatusIndicator.x = CGRectGetMaxX(_locationBtn.frame) + 10;
                self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
            }
        }
        else {
            if (self.isFromSelf) {
                if(self.isNeedDisplayReadOrUnReadBtn){
                    self.readOrUnReadBtn.x = bubbleView.x - 10 - self.readOrUnReadBtn.size.width;
                    self.sendingStatusIndicator.x = self.readOrUnReadBtn.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }else{
                    self.sendingStatusIndicator.x = bubbleView.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }
            }
            else {
                self.locationBtn.x = CGRectGetMaxX(bubbleView.frame) + 10;
                self.sendingStatusIndicator.x = CGRectGetMaxX(self.locationBtn.frame) + 10;
                self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
            }
        }
    }else{
        if ([self isKindOfClass:[SDChattingVoiceCell class]]) {
            UILabel *voiceLabel = [self valueForKey:@"voiceLabel"];
            if (self.isFromSelf) {
                if(self.isNeedDisplayReadOrUnReadBtn){
                    self.readOrUnReadBtn.x = voiceLabel.x - 10 - self.readOrUnReadBtn.size.width;
                    self.sendingStatusIndicator.x = self.readOrUnReadBtn.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }else{
                    self.sendingStatusIndicator.x = voiceLabel.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }
            }
            else {
                self.sendingStatusIndicator.x = CGRectGetMaxX(voiceLabel.frame) + 10;
                self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
            }
        }
        else {
            if (self.isFromSelf) {
                if(self.isNeedDisplayReadOrUnReadBtn){
                    self.readOrUnReadBtn.x = bubbleView.x - 10 - self.readOrUnReadBtn.size.width;
                    self.sendingStatusIndicator.x = self.readOrUnReadBtn.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }else{
                    self.sendingStatusIndicator.x = bubbleView.x - 10 - self.sendingStatusIndicator.size.width;
                    self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
                }
            }
            else {
                self.sendingStatusIndicator.x = CGRectGetMaxX(bubbleView.frame) + 10;
                self.failedResendBtn.x = self.sendingStatusIndicator.x + 2.5;
            }
        }
        
    }
}

- (void)cellDidLoad {
    if([self respondsToSelector:NSSelectorFromString(@"avatarImageView")]){
        UIImageView *avatarImageView = [self valueForKey:@"avatarImageView"];
        avatarImageView.userInteractionEnabled = YES;
        [avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewTapped)]];
    }
}

- (void)saveBurnAfterReadTime {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * messageDeleteTimeCountDic = [[ud objectForKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]] mutableCopy ] ?: @{}.mutableCopy;
    [messageDeleteTimeCountDic setObject:self.message.ext[@"burnAfterReadTime"] forKey:self.message.ID];
    [ud setObject:messageDeleteTimeCountDic forKey:[NSString stringWithFormat:@"Message_Delete_Time_Count_Dic_%@_%@",VAL_HXACCOUNT,self.chatter]];
    [ud synchronize];
    [self startBurnAfterReadTimer];
}

@end
