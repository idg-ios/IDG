//
//  CXInternalbulletinCellTableViewCell.m
//  InjoyIDG
//
//  Created by ^ on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXInternalbulletinCellTableViewCell.h"
#import "Masonry.h"

@interface CXInternalbulletinCellTableViewCell()
@property(nonatomic, strong)UIImageView *imgCon;
@property(nonatomic, strong)UILabel *lineLabel;
@end

@implementation CXInternalbulletinCellTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    self.imgCon = [[UIImageView alloc]initWithImage:Image(@"pic_pdf.png")];
    [self.contentView addSubview:_imgCon];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.font = KCXCellOneTitleFontSize;
    self.firstLabel.textColor = [UIColor blackColor];
    //self.titleLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.font = KCXCellOneTimeFontSize;
    self.secondLabel.textColor = [UIColor lightGrayColor];
    [self.secondLabel setTextAlignment:NSTextAlignmentRight];
    //self.timeLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.secondLabel];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
    [self.contentView addSubview:self.lineLabel];
    
    [self.imgCon mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgCon.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(Screen_Width-85);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(150);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.4);
        make.height.mas_equalTo(0.4);
        make.width.mas_equalTo(Screen_Width);
    }];
}
@end
