//
//  CXPopupsTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2018/6/2.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXPopupsTableViewCell.h"

@interface CXPopupsTableViewCell ()

@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UIImageView *selectImg;

@property (nonatomic,strong) UIView *lineView;


@end
@implementation CXPopupsTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLabel = [[UILabel alloc]init];
        self.selectImg = [[UIImageView alloc]init];
        self.lineView = [[UIView alloc]init];
    }
    return self;
}

-(void)layoutIfNeeded{
    CGFloat h = [self stringHeightByWidth:self.frame.size.width title:self.leftString font:[UIFont systemFontOfSize:16]].size.width;
    CGFloat leftLabelForW = 0.0;
    if (h <= 64) {
        leftLabelForW = 64;
    }else if (h >= self.frame.size.width-40){
         leftLabelForW =  self.frame.size.width-65;
    }else{
        leftLabelForW = h;
    }
    self.leftLabel.frame = CGRectMake(16, (self.frame.size.height-22)/2, leftLabelForW, 22);
    self.leftLabel.font = [UIFont systemFontOfSize:16];
    self.leftLabel.text = self.leftString;
    self.leftLabel.textColor = [UIColor blackColor];
//    self.leftLabel.textColor =  [UIColor colorWithRed:174/255.0 green:17/255.0 blue:41/255.0 alpha:1/1.0];
    [self.contentView addSubview:self.leftLabel];
    
    self.selectImg.frame = CGRectMake(CGRectGetMaxX(self.leftLabel.frame)+8,(self.frame.size.height-16)/2 , 16, 16);
    self.selectImg.image =  [UIImage imageNamed:@"icon_check"];
    self.selectImg.hidden = YES;
    [self.contentView addSubview:self.selectImg];
    
    self.lineView.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    self.lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:244/255.0 alpha:1/1.0];
    [self.contentView addSubview:self.lineView];
}
- (CGRect)stringHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font
{
    CGRect ContentRect = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return ContentRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.leftLabel.textColor =  [UIColor colorWithRed:174/255.0 green:17/255.0 blue:41/255.0 alpha:1/1.0];
        self.selectImg.hidden = NO;
    }else{
        self.leftLabel.textColor = [UIColor blackColor];
        self.selectImg.hidden = YES;
    }
    
    // Configure the view for the selected state
}

@end
