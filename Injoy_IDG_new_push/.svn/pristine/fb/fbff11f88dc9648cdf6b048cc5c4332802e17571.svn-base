//
//  SDDeleteGroupMemberCell.m
//  SDIMApp
//
//  Created by wtz on 16/3/15.
//  Copyright © 2016年 Rao. All rights reserved.
//

#import "SDDeleteGroupMemberCell.h"
#import "SDChatManager.h"
#import "UIImageView+EMWebCache.h"
#import "SDDataBaseHelper.h"
#import "CXIMHelper.h"

@interface SDDeleteGroupMemberCell()

@property (nonatomic, strong) NSString * member;
@property (nonatomic) BOOL selct;
@property (nonatomic,strong) UIImageView * headImageView;
@property (nonatomic,strong) UILabel * memberLabel;
@property (nonatomic,strong) UIImageView * selectedImageView;

@end


@implementation SDDeleteGroupMemberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _member = [NSString stringWithFormat:@""];
        _selct = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutCell];
    }
    return self;
}

- (void)layoutCell
{
    if(_headImageView){
        [_headImageView removeFromSuperview];
        _headImageView = nil;
    }
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(SDHeadImageViewLeftSpacing, SDHeadImageViewLeftSpacing, SDHeadWidth, SDHeadWidth);
    _headImageView.layer.cornerRadius = CornerRadius;
    _headImageView.clipsToBounds = YES;
    
    if(_memberLabel){
        [_memberLabel removeFromSuperview];
        _memberLabel = nil;
    }
    _memberLabel = [[UILabel alloc] init];
    _memberLabel.frame = CGRectMake(SDHeadImageViewLeftSpacing*2 + SDHeadWidth, (SDCellHeight - SDChatterDisplayNameFont)/2, Screen_Width - 15 - SDHeadImageViewLeftSpacing - 20 - (SDHeadImageViewLeftSpacing*2 + SDHeadWidth) - SDHeadImageViewLeftSpacing, SDChatterDisplayNameFont);
    _memberLabel.textAlignment = NSTextAlignmentLeft;
    _memberLabel.backgroundColor = [UIColor clearColor];
    _memberLabel.font = [UIFont systemFontOfSize:SDChatterDisplayNameFont];
    
    if(_selectedImageView){
        [_selectedImageView removeFromSuperview];
        _selectedImageView = nil;
    }
    _selectedImageView = [[UIImageView alloc] init];
    _selectedImageView.frame = CGRectMake(Screen_Width - 15 - SDHeadImageViewLeftSpacing - 20, (SDCellHeight - 20)/2, 20, 20);
    if(_selct){
        _selectedImageView.image = [UIImage imageNamed:@"selected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"selected"];
    }else{
        _selectedImageView.image = [UIImage imageNamed:@"unSelected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"unSelected"];
    }
}

- (void)setMember:(NSString *)member AndSelected:(BOOL)selected
{
    _member = member;
    _selct = selected;
    [self layoutUI];
}

- (void)layoutUI
{
    NSString * icon = [CXIMHelper getUserAvatarUrlByIMAccount:_member];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", icon.length ? icon : @""]] placeholderImage:[UIImage imageNamed:@"temp_user_head"] options:EMSDWebImageRetryFailed];
    [self.contentView addSubview:_headImageView];
    
    NSString * name = [CXIMHelper getRealNameByAccount:_member];
    _memberLabel.text = name;
    [self.contentView addSubview:_memberLabel];
    
    if(_selct){
        _selectedImageView.image = [UIImage imageNamed:@"selected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"selected"];
    }else{
        _selectedImageView.image = [UIImage imageNamed:@"unSelected"];
        _selectedImageView.highlightedImage = [UIImage imageNamed:@"unSelected"];
    }
    [self.contentView addSubview:_selectedImageView];
}
@end
