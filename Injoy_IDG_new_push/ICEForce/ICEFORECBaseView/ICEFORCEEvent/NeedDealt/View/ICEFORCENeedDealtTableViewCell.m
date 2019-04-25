//
//  ICEFORCENeedDealtTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/20.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCENeedDealtTableViewCell.h"

@interface ICEFORCENeedDealtTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *pjState;

@property (weak, nonatomic) IBOutlet UILabel *pjContent;
@property (weak, nonatomic) IBOutlet UIButton *projNameButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pjNameButtonW;


@end

@implementation ICEFORCENeedDealtTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectData:(UIButton *)sender {
    if ([self.delegateCell respondsToSelector:@selector(selectNeedDealtCell:selectDataSource:)]) {
        [self.delegateCell selectNeedDealtCell:self selectDataSource:self.dataDic];
    }
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    self.pjState.text = [dataDic objectForKey:@"busType"];
    
    NSString *pjName = [NSString stringWithFormat:@"#%@#",[dataDic objectForKey:@"projName"]];
    
    CGSize size = [MyPublicClass boundingRectWithSize:(CGSizeMake(self.frame.size.width-115, MAXFLOAT)) withTextFont:[UIFont systemFontOfSize:14] content:pjName];
    self.pjNameButtonW.constant = size.width+10;
    
    [self.projNameButton setTitle:pjName forState:(UIControlStateNormal)];
  
    
    NSString *showDesc = [dataDic objectForKey:@"showDesc"];
    
   
    self.pjContent.text = showDesc;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
