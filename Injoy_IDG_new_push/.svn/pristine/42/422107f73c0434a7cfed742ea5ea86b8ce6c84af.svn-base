//
//  CXProjectCollaborationChattingImageCell.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/2.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXProjectCollaborationChattingImageCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Category.h"
#import "CXProjectCollaborationImageViewController.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"

@interface CXProjectCollaborationChattingImageCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UIImageView *imageContentView;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UILabel *jobLabel;
@property (nonatomic,strong) UIButton * backBtn;

@end

static NSMutableDictionary *images_;

@implementation CXProjectCollaborationChattingImageCell

#define kImageMaxWidth 200.0
#define kImageMaxHeight 150.0

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
    self.nicknameLabel.font = [UIFont systemFontOfSize:16];
    self.nicknameLabel.textColor = RGBACOLOR(84.0, 84.0, 84.0, 1.0);
    [self.contentView addSubview:self.nicknameLabel];
    
    self.jobLabel = [[UILabel alloc] init];
    self.jobLabel.font = [UIFont systemFontOfSize:13.0];
    self.jobLabel.textColor = RGBACOLOR(152.0, 152.0, 152.0, 1.0);
    [self.contentView addSubview:self.jobLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    [self.contentView addSubview:self.containerView];
    
    self.imageContentView = [[UIImageView alloc] init];
    [self.containerView addSubview:self.imageContentView];
    
    images_ = images_ ?: @{}.mutableCopy;
    
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
    
    if (isNeedDisplayNickname && [self isGroupChat] && !isFromSelf) {
        self.jobLabel.x = CGRectGetMaxX(self.nicknameLabel.frame) + 3;
        self.jobLabel.y = self.nicknameLabel.y + 3;
        [self.jobLabel sizeToFit];
        self.jobLabel.hidden = NO;
    }else{
        self.jobLabel.hidden = YES;
    }
    
    // 图片
    CXIMImageMessageBody *body = (CXIMImageMessageBody *)self.message.body;
    CGSize dimentions = CGSizeMake(90, 160);
    self.imageContentView.image = nil;
    
    // 阅后即焚消息
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        dimentions = CGSizeMake(60, 60);
        UIImage *placeholderImage = [UIImage imageNamed:@"burnAfterReadCoverImage"];
        self.imageContentView.image = placeholderImage;
    }
    else {
        if ([body isFileExist]) {
            UIImage *image = images_[message.ID];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:body.fullLocalPath];;
                images_[message.ID] = image;
            }
            dimentions = image.size;
            self.imageContentView.image = image;
        }
        else {
            
            [message downloadFileWithProgress:^(float progress) {
                
            } completion:^(CXIMMessage *message, NSError *error) {
                [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
    }
    CGSize scaledImageSize = scaledSizeFunc(dimentions, kImageMaxWidth, kImageMaxHeight);
    
    
    self.imageContentView.size = CGSizeMake(scaledImageSize.width + 10, scaledImageSize.height + 10);
    
    
    if (isNeedDisplayNickname) {
        self.imageContentView.origin = CGPointMake(0, 1);
    }
    else{
        self.imageContentView.origin = CGPointMake(0, 0);
    }
    
    // 气泡
    self.containerView.size = self.imageContentView.size;
    self.containerView.size = CGSizeMake(self.containerView.size.width + self.imageContentView.x * 2, self.containerView.size.height + self.imageContentView.y * 2);
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
    
    if(CGRectGetMaxY(self.containerView.frame) < 40){
        self.cellHeight = 40;
    }else{
        self.cellHeight = CGRectGetMaxY(self.containerView.frame);
    }
}

- (void)setJob:(NSString *)job{
    self.jobLabel.text = job;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

// 等比缩放
CGSize scaledSizeFunc(CGSize originSize,CGFloat maxW,CGFloat maxH){
    CGSize size = CGSizeZero;
    if (originSize.width > originSize.height) {
        // 大于最大宽度
        if (originSize.width > maxW) {
            size.width = maxW;
            size.height = maxW / originSize.width * originSize.height;
        }
        else{
            size = originSize;
        }
    }
    else{
        // 大于最大高度
        if (originSize.height > maxH) {
            size.height = maxH;
            size.width = maxH /originSize.height * originSize.width;
        }
        else{
            size = originSize;
        }
    }
    return size;
}

- (void)containerViewTapped{
    // 阅后即焚消息
    if (self.isBurnAfterReadMessage && !self.isFromSelf) {
        CXIMImageMessageBody *body = (CXIMImageMessageBody *)self.message.body;
        if ([body isFileExist]) {
            CXProjectCollaborationImageViewController *vc = [[CXProjectCollaborationImageViewController alloc] init];
            vc.viewController = self.viewController;
            vc.image = [UIImage imageWithContentsOfFile:body.fullLocalPath];
            [self.viewController presentViewController:vc animated:YES completion:nil];
            if (!self.isGroupChat && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
                [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.message.sender messageIds:@[self.message.ID]];
                self.message.openFlag = CXIMMessageReadFlagReaded;
            }
            // 阅后即焚消息处理
            if (self.isBurnAfterReadMessage && !self.isFromSelf) {
                [super saveBurnAfterReadTime];
            }
        }
        else {
            [self.message downloadFileWithProgress:^(float progress) {
                
            } completion:^(CXIMMessage *message, NSError *error) {
                if (!error) {
                    [self containerViewTapped];
                }
            }];
        }
    }
    else {
        CXProjectCollaborationImageViewController *vc = [[CXProjectCollaborationImageViewController alloc] init];
        vc.image = self.imageContentView.image;
        vc.viewController = self.viewController;
        [self.viewController presentViewController:vc animated:YES completion:nil];
    }
}


@end
