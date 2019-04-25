//
//  SDChattingShareCell.m
//  InjoyERP
//
//  Created by wtz on 16/12/8.
//  Copyright © 2016年 Injoy. All rights reserved.
//

#import "SDChattingShareCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"
#import "UIImageView+EMWebCache.h"
#import "CXLoaclDataManager.h"

#define kTopBackViewHeight 35.5
#define kTopBackViewAppImageViewleftSpace 4.0
#define kShareTitleLabelFontSize 26.0
#define kShareTitleLabelFont 14.0
#define kShareContentLabelFontSize 14.0
#define kShareContentLabelLeftSpace 4.0
#define kShareContentLabelTopSpace 8.0

#define kShareContentTitleLabelFontSize 14.0

@interface SDChattingShareCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *topBackBottomView;
@property (nonatomic,strong) UIImageView *appImageView;
@property (nonatomic,strong) UILabel *shareTitleLabel;
@property (nonatomic,strong) UIView *topBackViewBottomLineView;
@property (nonatomic,strong) UILabel *shareContentTitleLabel;
@property (nonatomic,strong) UILabel *shareContentContentLabel;
@property (nonatomic,strong) UIButton * backBtn;

@end

@implementation SDChattingShareCell

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
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    [self.contentView addSubview:self.containerView];
    
    self.topBackBottomView = [[UIView alloc] init];
    self.topBackBottomView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.topBackBottomView];
    
    self.topBackView = [[UIView alloc] init];
    self.topBackView.backgroundColor = [UIColor clearColor];
    self.topBackView.layer.cornerRadius = 5;
    self.topBackView.clipsToBounds = YES;
    [self.containerView addSubview:self.topBackView];
    
    self.appImageView = [[UIImageView alloc] init];
    [self.appImageView sd_setImageWithURL:[NSURL URLWithString:self.message.ext[@"shareDic"][@"shareIconUrl"]] placeholderImage:[UIImage imageNamed:@"shareAppImageView"] options:EMSDWebImageRetryFailed];
    [self.topBackView addSubview:self.appImageView];
    
    self.shareTitleLabel = [[UILabel alloc] init];
    self.shareTitleLabel.font = [UIFont systemFontOfSize:kShareTitleLabelFont];
    self.shareTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.shareTitleLabel.textColor = [UIColor blackColor];
    [self.topBackView addSubview:self.shareTitleLabel];
    
    self.topBackViewBottomLineView = [[UIView alloc] init];
    self.topBackViewBottomLineView.backgroundColor = RGBACOLOR(170.0, 170.0, 170.0, 1.0);
    [self.containerView addSubview:self.topBackViewBottomLineView];
    
    self.shareContentTitleLabel = [[UILabel alloc] init];
    self.shareContentTitleLabel.font = [UIFont systemFontOfSize:kShareContentTitleLabelFontSize];
    self.shareContentTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.shareContentTitleLabel.numberOfLines = 0;
    self.shareContentTitleLabel.textColor = [UIColor blackColor];
    [self.containerView addSubview:self.shareContentTitleLabel];
    
    self.shareContentContentLabel = [[UILabel alloc] init];
    self.shareContentContentLabel.font = [UIFont systemFontOfSize:kShareContentTitleLabelFontSize];
    self.shareContentContentLabel.textAlignment = NSTextAlignmentLeft;
    self.shareContentContentLabel.numberOfLines = 0;
    self.shareContentContentLabel.textColor = [UIColor blackColor];
    [self.containerView addSubview:self.shareContentContentLabel];
    
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
    
    if (isFromSelf) {
        self.topBackBottomView.frame = CGRectMake(0.5, 15.5, 202, kTopBackViewHeight - 15);
        
        self.topBackView.frame = CGRectMake(0.5, 0.5, 202, kTopBackViewHeight);
        
        self.topBackViewBottomLineView.frame = CGRectMake(0.5, CGRectGetMaxY(self.topBackBottomView.frame) - 0.5, 202, 0.5);
        
        self.shareContentTitleLabel.textColor = [UIColor blackColor];
        
        self.shareContentContentLabel.textColor = [UIColor blackColor];
    }
    else{
        self.topBackBottomView.frame = CGRectMake(2.5, 15.5, 202, kTopBackViewHeight - 15);
        
        self.topBackView.frame = CGRectMake(2.5, 0.5, 202, kTopBackViewHeight);
        
        self.topBackViewBottomLineView.frame = CGRectMake(2.5, CGRectGetMaxY(self.topBackBottomView.frame) - 0.5, 202, 0.5);
        
        self.shareContentTitleLabel.textColor = [UIColor blackColor];
        
        self.shareContentContentLabel.textColor = [UIColor blackColor];
    }
    
    self.appImageView.frame = CGRectMake(kTopBackViewAppImageViewleftSpace, (kTopBackViewHeight - 0.5 - kShareTitleLabelFontSize)/2, kShareTitleLabelFontSize, kShareTitleLabelFontSize);
    
    self.shareTitleLabel.text = self.message.ext[@"shareDic"][@"shareTitle"];
    self.shareTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.appImageView.frame) + kTopBackViewAppImageViewleftSpace, (kTopBackViewHeight - 0.5 - kShareTitleLabelFontSize)/2, 205 - 3*kShareContentLabelLeftSpace - kShareTitleLabelFontSize, kShareTitleLabelFontSize);
    
    
    NSArray * contents;
    if([self.message.ext[@"shareDic"][@"shareContent"] containsString:@" "]){
        contents = [self.message.ext[@"shareDic"][@"shareContent"] componentsSeparatedByString:@" "];
    }else{
        contents = @[self.message.ext[@"shareDic"][@"shareContent"]];
    }
    self.shareContentTitleLabel.text = contents[0];
    CGSize shareContentLabelSize = [self.shareContentTitleLabel sizeThatFits:CGSizeMake(205 - kShareContentLabelLeftSpace*2, LONG_MAX)];
    self.shareContentTitleLabel.frame = CGRectMake(kShareContentLabelLeftSpace, CGRectGetMaxY(self.topBackViewBottomLineView.frame) + kShareContentLabelTopSpace, 205 - 2*kShareContentLabelLeftSpace, shareContentLabelSize.height);
    
    // 气泡
    self.containerView.size = CGSizeMake(205, CGRectGetMaxY(self.shareContentTitleLabel.frame) + kShareContentLabelTopSpace);
    
    if([contents count] > 1){
        self.shareContentContentLabel.text = contents[1];
        CGSize shareContentLabelSize = [self.shareContentContentLabel sizeThatFits:CGSizeMake(205 - kShareContentLabelLeftSpace*2, LONG_MAX)];
        self.shareContentContentLabel.frame = CGRectMake(kShareContentLabelLeftSpace, CGRectGetMaxY(self.shareContentTitleLabel.frame) + kShareContentLabelTopSpace, 205 - 2*kShareContentLabelLeftSpace, shareContentLabelSize.height);
        // 气泡
        self.containerView.size = CGSizeMake(205, CGRectGetMaxY(self.shareContentContentLabel.frame) + kShareContentLabelTopSpace);
    }else{
        self.shareContentContentLabel.text = @"";
        self.shareContentContentLabel.frame = CGRectZero;
        // 气泡
        self.containerView.size = CGSizeMake(205, CGRectGetMaxY(self.shareContentTitleLabel.frame) + kShareContentLabelTopSpace);
    }
    
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
    
    //气泡背景CXChatShareMessageCellBackGroundImage-1
    UIImage * backImage = [UIImage imageNamed:isFromSelf?@"CXChatShareMessageCellBackGroundImage":@"CXChatWhiteMessageCellBackGroundImage"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:30];
    
    
    if (isFromSelf) {
        _backBtn.frame = CGRectMake(self.containerView.x, self.containerView.y, self.containerView.size.width + 5, self.containerView.size.height);
    }
    else{
        _backBtn.frame = CGRectMake(self.containerView.x - 5, self.containerView.y, self.containerView.size.width + 5, self.containerView.size.height);
    }
    
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    
    // cell高度
    self.cellHeight = CGRectGetMaxY(self.containerView.frame);
}

- (void)containerViewTapped
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.message.ext[@"shareDic"][@"shareUrl"]]];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

@end
