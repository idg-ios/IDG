//
//  ICEFORCERemindTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCERemindTableViewCell.h"

@interface ICEFORCERemindTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *porjNameButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pjContentW;
@property (weak, nonatomic) IBOutlet UILabel *pjContent;

@end

@implementation ICEFORCERemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectData:(UIButton *)sender {
    if ([self.delegateCell respondsToSelector:@selector(selectRemindCell:selectDataSource:)]) {
        [self.delegateCell selectRemindCell:self selectDataSource:self.dataDic];
    }
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.userNameLabel.text = [dataDic objectForKey:@"sourceUser"];
    
    NSString *showDesc = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"showDesc"]];
    
    CGSize size = [MyPublicClass boundingRectWithSize:(CGSizeMake(self.frame.size.width-58, MAXFLOAT)) withTextFont:[UIFont systemFontOfSize:14] content:showDesc];
    self.pjContentW.constant = size.width;
    
    NSString *other = @"@你";
    
    if ([showDesc containsString:other]) {
        
        NSRange range = [showDesc rangeOfString:other];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:showDesc];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:range];
        self.pjContent.attributedText = attributedString;
        
    }else{
        self.pjContent.text = showDesc;
        
    }
    
    NSString *projName = [NSString stringWithFormat:@"#%@#",[dataDic objectForKey:@"projName"]];
    [self.porjNameButton setTitle:projName forState:(UIControlStateNormal)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
