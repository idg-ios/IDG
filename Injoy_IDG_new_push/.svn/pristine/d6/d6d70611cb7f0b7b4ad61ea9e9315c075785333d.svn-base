//
//  CXIDGSmallBusinessAssistantCell.m
//  InjoyDDXWBG
//
//  Created by wtz on 2017/11/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXIDGSmallBusinessAssistantCell.h"
#import "UIView+Category.h"
#import "CXIMHelper.h"
#import "CXLoaclDataManager.h"
#import "CXEditLabel.h"

@interface CXIDGSmallBusinessAssistantCell()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) UILabel *nicknameLabel;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UILabel * gsmcLabel;
@property (nonatomic,strong) UILabel * nshLabel;
@property (nonatomic,strong) UILabel * kpdzLabel;
@property (nonatomic,strong) UILabel * zhLabel;
@property (nonatomic,strong) UILabel * khhLabel;
@property (nonatomic,strong) UILabel * dhLabel;
@property (nonatomic,strong) UILabel * gsczLabel;
@property (nonatomic,strong) UILabel * gsmcContentLabel;
@property (nonatomic,strong) UILabel * nshContentLabel;
@property (nonatomic,strong) UILabel * kpdzContentLabel;
@property (nonatomic,strong) UILabel * zhContentLabel;
@property (nonatomic,strong) UILabel * khhContentLabel;
@property (nonatomic,strong) UILabel * dhContentLabel;
@property (nonatomic,strong) UILabel * gsczContentLabel;

@end

@implementation CXIDGSmallBusinessAssistantCell

#define kLeftSpace 10.0

#define kFontSize 17.0

#define kContentLeftSpace 5.0

#define kTextTopSpace 15.0

#define kTextWidth (Screen_Width*6.0/8.0)

#define kTitleColor RGBACOLOR(110.0, 110.0, 110.0, 1.0)

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
    self.nicknameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nicknameLabel.textColor = RGBACOLOR(84.0, 84.0, 84.0, 1.0);
    [self.contentView addSubview:self.nicknameLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.backBtn];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.layer.cornerRadius = 5;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTapped)]];
    [self.contentView addSubview:self.containerView];
    
    self.gsmcLabel = [[UILabel alloc] init];
    self.gsmcLabel.backgroundColor = [UIColor clearColor];
    self.gsmcLabel.textAlignment = NSTextAlignmentLeft;
    self.gsmcLabel.textColor = kTitleColor;
    self.gsmcLabel.text = @"公司名称：";
    self.gsmcLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.gsmcLabel sizeToFit];
    self.gsmcLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace, self.gsmcLabel.size.width, kFontSize);
    [self.containerView addSubview:self.gsmcLabel];
    
    self.gsmcContentLabel = [[UILabel alloc] init];
    self.gsmcContentLabel.backgroundColor = [UIColor clearColor];
    self.gsmcContentLabel.textAlignment = NSTextAlignmentLeft;
    self.gsmcContentLabel.textColor = [UIColor blackColor];
    self.gsmcContentLabel.numberOfLines = 0;
    self.gsmcContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.gsmcContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.gsmcContentLabel];
    
    self.nshLabel = [[UILabel alloc] init];
    self.nshLabel.backgroundColor = [UIColor clearColor];
    self.nshLabel.textAlignment = NSTextAlignmentLeft;
    self.nshLabel.textColor = kTitleColor;
    self.nshLabel.text = @"纳税号：";
    self.nshLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.nshLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace, self.nshLabel.size.width, kFontSize);
    [self.nshLabel sizeToFit];
    [self.containerView addSubview:self.nshLabel];
    
    self.nshContentLabel = [[UILabel alloc] init];
    self.nshContentLabel.backgroundColor = [UIColor clearColor];
    self.nshContentLabel.textAlignment = NSTextAlignmentLeft;
    self.nshContentLabel.textColor = [UIColor blackColor];
    self.nshContentLabel.numberOfLines = 0;
    self.nshContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nshContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.nshContentLabel];
    
    self.kpdzLabel = [[UILabel alloc] init];
    self.kpdzLabel.backgroundColor = [UIColor clearColor];
    self.kpdzLabel.textAlignment = NSTextAlignmentLeft;
    self.kpdzLabel.textColor = kTitleColor;
    self.kpdzLabel.text = @"开票地址：";
    self.kpdzLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.kpdzLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace, self.kpdzLabel.size.width, kFontSize);
    [self.kpdzLabel sizeToFit];
    [self.containerView addSubview:self.kpdzLabel];
    
    self.kpdzContentLabel = [[UILabel alloc] init];
    self.kpdzContentLabel.backgroundColor = [UIColor clearColor];
    self.kpdzContentLabel.textAlignment = NSTextAlignmentLeft;
    self.kpdzContentLabel.textColor = [UIColor blackColor];
    self.kpdzContentLabel.numberOfLines = 0;
    self.kpdzContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.kpdzContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.kpdzContentLabel];
    
    self.zhLabel = [[UILabel alloc] init];
    self.zhLabel.backgroundColor = [UIColor clearColor];
    self.zhLabel.textAlignment = NSTextAlignmentLeft;
    self.zhLabel.textColor = kTitleColor;
    self.zhLabel.text = @"账户：";
    self.zhLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.zhLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace, self.zhLabel.size.width, kFontSize);
    [self.zhLabel sizeToFit];
    [self.containerView addSubview:self.zhLabel];
    
    self.zhContentLabel = [[UILabel alloc] init];
    self.zhContentLabel.backgroundColor = [UIColor clearColor];
    self.zhContentLabel.textAlignment = NSTextAlignmentLeft;
    self.zhContentLabel.textColor = [UIColor blackColor];
    self.zhContentLabel.numberOfLines = 0;
    self.zhContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.zhContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.zhContentLabel];
    
    self.khhLabel = [[UILabel alloc] init];
    self.khhLabel.backgroundColor = [UIColor clearColor];
    self.khhLabel.textAlignment = NSTextAlignmentLeft;
    self.khhLabel.textColor = kTitleColor;
    self.khhLabel.text = @"开户行：";
    self.khhLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.khhLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace, self.khhLabel.size.width, kFontSize);
    [self.khhLabel sizeToFit];
    [self.containerView addSubview:self.khhLabel];
    
    self.khhContentLabel = [[UILabel alloc] init];
    self.khhContentLabel.backgroundColor = [UIColor clearColor];
    self.khhContentLabel.textAlignment = NSTextAlignmentLeft;
    self.khhContentLabel.textColor = [UIColor blackColor];
    self.khhContentLabel.numberOfLines = 0;
    self.khhContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.khhContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.khhContentLabel];
    
    self.dhLabel = [[UILabel alloc] init];
    self.dhLabel.backgroundColor = [UIColor clearColor];
    self.dhLabel.textAlignment = NSTextAlignmentLeft;
    self.dhLabel.textColor = kTitleColor;
    self.dhLabel.text = @"电话：";
    self.dhLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.dhLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace, self.dhLabel.size.width, kFontSize);
    [self.dhLabel sizeToFit];
    [self.containerView addSubview:self.dhLabel];
    
    self.dhContentLabel = [[UILabel alloc] init];
    self.dhContentLabel.backgroundColor = [UIColor clearColor];
    self.dhContentLabel.textAlignment = NSTextAlignmentLeft;
    self.dhContentLabel.textColor = [UIColor blackColor];
    self.dhContentLabel.numberOfLines = 0;
    self.dhContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.dhContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.dhContentLabel];
    
    self.gsczLabel = [[UILabel alloc] init];
    self.gsczLabel.backgroundColor = [UIColor clearColor];
    self.gsczLabel.textAlignment = NSTextAlignmentLeft;
    self.gsczLabel.textColor = kTitleColor;
    self.gsczLabel.text = @"公司传真：";
    self.gsczLabel.font = [UIFont systemFontOfSize:kFontSize];
    self.gsczLabel.frame = CGRectMake(kLeftSpace, kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace + kFontSize + kTextTopSpace, self.gsczLabel.size.width, kFontSize);
    [self.gsczLabel sizeToFit];
    [self.containerView addSubview:self.gsczLabel];
    
    self.gsczContentLabel = [[UILabel alloc] init];
    self.gsczContentLabel.backgroundColor = [UIColor clearColor];
    self.gsczContentLabel.textAlignment = NSTextAlignmentLeft;
    self.gsczContentLabel.textColor = [UIColor blackColor];
    self.gsczContentLabel.numberOfLines = 0;
    self.gsczContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.gsczContentLabel.font = [UIFont systemFontOfSize:kFontSize];
    [self.containerView addSubview:self.gsczContentLabel];
    
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
    
    self.avatarImageView.image = [UIImage imageNamed:@"QIYEXIAOZHUSHOU"];
    self.avatarImageView.highlightedImage = [UIImage imageNamed:@"QIYEXIAOZHUSHOU"];
    
    self.gsmcContentLabel.text = self.model.companyName&&[self.model.companyName length]>0?self.model.companyName:@" ";
    CGSize gsmcSize = [self.gsmcContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.gsmcContentLabel.frame = CGRectMake(CGRectGetMaxX(self.gsmcLabel.frame) + kContentLeftSpace, CGRectGetMinY(self.gsmcLabel.frame), gsmcSize.width, gsmcSize.height);
    
    self.nshLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.gsmcContentLabel.frame) + kTextTopSpace, self.nshLabel.size.width, self.nshLabel.size.height);
    self.nshContentLabel.text = self.model.taxNumber&&[self.model.taxNumber length]>0?self.model.taxNumber:@" ";
    CGSize nshSize = [self.nshContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.nshContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.gsmcContentLabel.frame) + kTextTopSpace, nshSize.width, nshSize.height);
    
    self.kpdzLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.nshContentLabel.frame) + kTextTopSpace, self.kpdzLabel.size.width, self.kpdzLabel.size.height);
    self.kpdzContentLabel.text = self.model.invoiceAddress&&[self.model.invoiceAddress length]>0?self.model.invoiceAddress:@" ";
    CGSize kpdzSize = [self.kpdzContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.kpdzContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.nshContentLabel.frame) + kTextTopSpace, kpdzSize.width, kpdzSize.height);
    
    self.zhLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.kpdzContentLabel.frame) + kTextTopSpace, self.zhLabel.size.width, self.zhLabel.size.height);
    self.zhContentLabel.text = self.model.account&&[self.model.account length]>0?self.model.account:@" ";
    CGSize zhSize = [self.zhContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.zhContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.kpdzContentLabel.frame) + kTextTopSpace, zhSize.width, zhSize.height);
    
    self.khhLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.zhContentLabel.frame) + kTextTopSpace, self.khhLabel.size.width, self.khhLabel.size.height);
    self.khhContentLabel.text = self.model.openBank&&[self.model.openBank length]>0?self.model.openBank:@" ";
    CGSize khhSize = [self.khhContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.khhContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.zhContentLabel.frame) + kTextTopSpace, khhSize.width, khhSize.height);
    
    self.dhLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.khhContentLabel.frame) + kTextTopSpace, self.dhLabel.size.width, self.dhLabel.size.height);
    self.dhContentLabel.text = self.model.telephone&&[self.model.telephone length]>0?self.model.telephone:@" ";
    CGSize dhSize = [self.dhContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.dhContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.khhContentLabel.frame) + kTextTopSpace, dhSize.width, dhSize.height);
    
    self.gsczLabel.frame = CGRectMake(kLeftSpace, CGRectGetMaxY(self.dhContentLabel.frame) + kTextTopSpace, self.gsczLabel.size.width, self.gsczLabel.size.height);
    self.gsczContentLabel.text = self.model.fax&&[self.model.fax length]>0?self.model.fax:@" ";
    CGSize gsczSize = [self.gsczContentLabel sizeThatFits:CGSizeMake(kTextWidth - 2*kLeftSpace - self.gsmcLabel.frame.size.width - kContentLeftSpace, MAXFLOAT)];
    self.gsczContentLabel.frame = CGRectMake(CGRectGetMinX(self.gsmcContentLabel.frame), CGRectGetMaxY(self.dhContentLabel.frame) + kTextTopSpace, gsczSize.width, gsczSize.height);
    
    // 气泡
    self.containerView.size = CGSizeMake(kTextWidth , CGRectGetMaxY(self.gsczContentLabel.frame) + kTextTopSpace);
    self.containerView.y = self.avatarImageView.y;
    self.containerView.x = CGRectGetMaxX(self.avatarImageView.frame) + 10;
    
    //气泡背景
    UIImage * backImage = [UIImage imageNamed:isFromSelf?@"CXChatGreenMessageCellBackGroundImage":@"CXChatWhiteMessageCellBackGroundImage"];
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

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [super subClassLayoutSubviews];
}

- (BOOL)menuItemEnabled:(CXProjectCollaborationChattingCellMenuItem)item{
    return YES;
}

#pragma mark - Action
- (void)containerViewTapped {
    if (self.isBurnAfterReadMessage && !self.isFromSelf && self.message.openFlag == CXIMMessageReadFlagUnRead) {
        [[CXIMService sharedInstance].chatManager sendMessageReadAskForChatter:self.chatter messageIds:@[self.message.ID]];
        self.message.openFlag = CXIMMessageReadFlagReaded;
        self.message = self.message;
        self.burnAfterReadLockAndUnLockView.hidden = YES;
        [super saveBurnAfterReadTime];
    }
}

@end
