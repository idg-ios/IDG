//
//  SDChattingLocationCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingLocationCell.h"
#import "SDChatLocationView.h"
#import "Masonry.h"
#import "UIView+Category.h"
#import "SDChatMapViewController.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface SDChattingLocationCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) SDChatLocationView *locationView;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIButton * backBtn;

@end

@implementation SDChattingLocationCell

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)]) {
        [self initCell];
    }
    return self;
}

-(void)initCell{
    [super initCell];
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = [UIImage imageNamed:@"avatar-user"];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:13];
    self.nicknameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.nicknameLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.containerView];
    
    self.locationView = [[SDChatLocationView alloc] init];
    [self.locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTapped)]];
    [self.containerView addSubview:self.locationView];
    
    [super cellDidLoad];
}

-(void)setMessage:(CXIMMessage *)message{
    [super setMessage:message];
    
    // 是否自己发送的消息
    BOOL isFromSelf = [message.sender isEqualToString:VAL_HXACCOUNT];
    // 是否显示时间
    BOOL isNeedDisplayTime = self.isNeedDisplayTime;
    // 是否显示昵称
    BOOL isNeedDisplayNickname = message.type == CXIMMessageTypeGroupChat && !isFromSelf;
    
    self.containerView.backgroundColor = [UIColor clearColor];
    
    // 头像
    if (isNeedDisplayTime) {
        self.avatarImageView.y = CGRectGetMaxY(self.timeLabel.frame) + kTimeLabelTopBottomMargin;
    }
    else{
        self.avatarImageView.y = kTimeLabelTopBottomMargin;
    }
    self.avatarImageView.size = CGSizeMake(40, 40);
    if (isFromSelf) {
        self.avatarImageView.x = Screen_Width - 10 - self.avatarImageView.size.width;
    }
    else{
        self.avatarImageView.x = 10;
    }
    
    // 昵称(群聊+别人发出的消息才显示)
    if (isNeedDisplayNickname) {
        if([self isGroupChat]){
            self.nicknameLabel.text = [[CXLoaclDataManager sharedInstance] getUserByGroupId:self.message.receiver AndIMAccount:message.sender].name;
        }else{
            self.nicknameLabel.text = [CXIMHelper getRealNameByAccount:message.sender];
        }
        self.nicknameLabel.x = CGRectGetMaxX(self.avatarImageView.frame) + 12;
        self.nicknameLabel.y = self.avatarImageView.y;
        [self.nicknameLabel sizeToFit];
    }
    
    // 位置
    CXIMLocationMessageBody *body = (CXIMLocationMessageBody *)message.body;
    self.locationView.location = body.address;
    self.locationView.size = CGSizeMake(170, 100);
    
    
    if (isNeedDisplayNickname) {
        self.locationView.origin = CGPointMake(0, 1);
    }
    else{
        self.locationView.origin = CGPointMake(0, 0);
    }
    
    
    
    
    // 气泡
    self.containerView.size = self.locationView.size;
    self.containerView.size = CGSizeMake(self.containerView.size.width + self.locationView.x * 2, self.containerView.size.height + self.locationView.y * 2);
    if (isNeedDisplayNickname) {
        self.containerView.y = CGRectGetMaxY(self.nicknameLabel.frame);
    }
    else{
        self.containerView.y = self.avatarImageView.y;
    }
    if (isFromSelf) {
        self.containerView.x = self.avatarImageView.x - 10 - self.containerView.size.width;
    }
    else{
        self.containerView.x = CGRectGetMaxX(self.avatarImageView.frame) + 10;
    }
    
    //气泡背景
    UIImage * backImage = [UIImage imageNamed:isFromSelf?@"CXChatWhiteCellSendBorderBackGroundImage":@"CXChatWhiteCellReceiveBorderBackGroundImage"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:30];
    
    if (isFromSelf) {
        _backBtn.frame = CGRectMake(self.containerView.x, self.containerView.y + 1, self.containerView.size.width + 5, self.containerView.size.height - 2);
    }
    else{
        _backBtn.frame = CGRectMake(self.containerView.x - 5, self.containerView.y + 1, self.containerView.size.width + 5, self.containerView.size.height - 2);
    }
    
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    
    
    self.cellHeight = CGRectGetMaxY(self.containerView.frame);
    
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

#pragma mark 点击地图
-(void)locationViewTapped{
    CXIMLocationMessageBody *body = (CXIMLocationMessageBody *)self.message.body;
    SDChatMapViewController *locationController = [[SDChatMapViewController alloc] initWithLocation:CLLocationCoordinate2DMake(body.clLocationCoordinate2D.latitude, body.clLocationCoordinate2D.longitude)];
    locationController.address = body.address;
    locationController.showAddressAnnotation = YES;
    [self.viewController.navigationController pushViewController:locationController animated:YES];
    if ([self.viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.viewController.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

@end
