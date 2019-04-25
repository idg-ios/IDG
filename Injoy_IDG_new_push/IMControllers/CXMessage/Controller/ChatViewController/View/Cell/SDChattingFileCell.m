//
//  SDChattingFileCell.m
//  SDIMApp
//
//  Created by lancely on 3/25/16.
//  Copyright © 2016 Rao. All rights reserved.
//

#import "SDChattingFileCell.h"
#import "SDChatFileView.h"
#import "Masonry.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"

@interface SDChattingFileCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) SDChatFileView *fileView;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIButton * backBtn;

@end

@implementation SDChattingFileCell

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
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:13];
    self.nicknameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.nicknameLabel];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.contentView addSubview:self.containerView];
    
    self.fileView = [[SDChatFileView alloc] init];
    [self.containerView addSubview:self.fileView];
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
        self.nicknameLabel.text = [CXIMHelper getRealNameByAccount:message.sender];
        self.nicknameLabel.x = CGRectGetMaxX(self.avatarImageView.frame) + 12;
        self.nicknameLabel.y = self.avatarImageView.y;
        [self.nicknameLabel sizeToFit];
    }
    
    // 文件信息
    CXIMFileMessageBody *body = (CXIMFileMessageBody *)message.body;
    self.fileView.file = body;
    self.fileView.size = CGSizeMake(170, 100);
    
    
    if (isNeedDisplayNickname) {
        self.fileView.origin = CGPointMake(0, 1);
    }
    else{
        self.fileView.origin = CGPointMake(0, 0);
    }
    
    
    
    // 气泡
    self.containerView.size = self.fileView.size;
    self.containerView.size = CGSizeMake(self.containerView.size.width + self.fileView.x * 2, self.containerView.size.height + self.fileView.y * 2);
    
    if (isNeedDisplayNickname) {
        self.containerView.y = CGRectGetMaxY(self.nicknameLabel.frame) + 1;
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

@end
