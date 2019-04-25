//
//  CXAnnexsView.m
//  SDMarketingManagement
//
//  Created by admin on 16/4/28.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXAnnexTwoView.h"

@interface CXAnnexTwoView()

//标题
@property (nonatomic, weak) UILabel *annexLabel;
//图片
@property (nonatomic, weak) UIImageView *iconImageView;
//显示关系信息
@property (nonatomic, weak) UILabel *contactLabel;
//附件删除
@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation CXAnnexTwoView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 7.f, 30.f, 30.f)];
        [self addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        //标题
        UILabel *annexLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.f, 7.f, Screen_Width - 85.f, 30.f)];
        annexLabel.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:annexLabel];
        self.annexLabel = annexLabel;
        
        UIImage *deleteImage = [UIImage imageNamed:@"approval_annex_delete"];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(Screen_Width - 35.f, (44.f - deleteImage.size.height * 0.7)/2.f, deleteImage.size.width * 0.7, deleteImage.size.height * 0.7)];
        [deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(deleteAnnexInfo) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;
    }
    
    return self;
}

#pragma mark -- 删除对应的附件信息
-(void)deleteAnnexInfo
{
    NSInteger type = [self getAnnexType];
    if ([self.delegate respondsToSelector:@selector(approvalAnnex:dataType:)]) {
        [self.delegate approvalAnnex:self dataType:type];
    }
}

#pragma mark -- 获取要删除信息的type,1为关联联系人，2为关联客户，3为录音,4为定位
-(NSInteger)getAnnexType
{
    NSInteger type = 0;
    if ([NSString containWithSelectedStr:_contactTitle contain:@"关联联系人:"]) {
        type = 1;
    }else if ([NSString containWithSelectedStr:_contactTitle contain:@"关联客户:"]) {
        type = 2;
    }else if ([NSString containWithSelectedStr:_contactTitle contain:@"录音:"]) {
        type = 3;
    }else{
        type = 4;
    }
    
    return type;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)setContactTitle:(NSString *)contactTitle
{
    _contactTitle = contactTitle;
    self.annexLabel.text = contactTitle;
}

-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.iconImageView.image = [UIImage imageNamed:imageName];
}

@end
