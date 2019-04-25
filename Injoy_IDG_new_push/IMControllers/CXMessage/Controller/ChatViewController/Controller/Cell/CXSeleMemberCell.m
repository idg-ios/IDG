//
//  CXSeleMemberCell.m
//  InjoyIDG
//
//  Created by HelloIOS on 2018/7/18.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXSeleMemberCell.h"

@implementation CXSeleMemberCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadSubView];
    }
    
    return self;
}

-(void)loadSubView{
    
    self.selectImage = [[UIImageView alloc] init];
    self.selectImage.frame = CGRectMake(10, 20, 20, 20);
    [self.contentView addSubview:self.selectImage];
    
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.frame = CGRectMake(CGRectGetMaxX(self.selectImage.frame)+10, 10, 40, 40);
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    self.nickName = [[UILabel alloc] init];
    self.nickName.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame)+10, 10, Screen_Width-CGRectGetMaxX(self.headerImageView.frame)-20, self.frame.size.height);
    self.nickName.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.nickName];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 59, Screen_Width, 1);
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
