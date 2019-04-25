//
//  CXLiaoLiaoListView.m
//  InjoyDDXWBG
//
//  Created by admin on 17/10/19.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXLiaoliaoListView.h"
#import "UIImageView+EMWebCache.h"

#define kBadgeImageWidth 12.0

@interface CXLiaoliaoListView()


// 会话内容
@property (nonatomic,strong) UILabel *conversationLabel;
// 时间
@property (nonatomic,strong) UILabel *timeLabel;

//badgeButton
@property (nonatomic, strong) UIButton * badgeBtn;

@end

@implementation CXLiaoliaoListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesturRecognizer];
    
    _avatarImageView = [[UIImageView alloc] init];
    [self addSubview:_avatarImageView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    _nicknameLabel.textColor = SDChatterDisplayNameColor;
    [self addSubview:_nicknameLabel];
    
    _badgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _badgeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    _badgeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0.5, 0, 0);
    _badgeBtn.userInteractionEnabled = NO;
    [self addSubview:_badgeBtn];
    
    _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SDCellHeight-0.5, Screen_Width, 0.5)];
    _linelabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_linelabel];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    _avatarImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _avatarImageView.layer.cornerRadius = CornerRadius;
    _avatarImageView.layer.masksToBounds = YES;
    
    _nicknameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + SDHeadImageViewLeftSpacing, _avatarImageView.frame.origin.y + 4, Screen_Width - _timeLabel.frame.size.width - CGRectGetMaxX(_avatarImageView.frame) - SDHeadImageViewLeftSpacing*2, SDChatterDisplayNameFont);
}

-(void)tapAction:(id)tap
{
    if (self.liaoliaolistViewClickBlock) {
        self.liaoliaolistViewClickBlock();
    }
}

@end
