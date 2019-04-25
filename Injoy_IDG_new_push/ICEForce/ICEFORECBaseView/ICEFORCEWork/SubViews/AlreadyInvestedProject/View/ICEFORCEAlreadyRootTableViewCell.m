//
//  ICEFORCEAlreadyRootTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEAlreadyRootTableViewCell.h"

@interface ICEFORCEAlreadyRootTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *gtoupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *projectStateButton;
@property (weak, nonatomic) IBOutlet UILabel *projectContLabel;
@property (weak, nonatomic) IBOutlet UIButton *projecyTagButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation ICEFORCEAlreadyRootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    [MyPublicClass layerMasksToBoundsForAnyControls:self.baseView cornerRadius:4 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.gtoupNameLabel cornerRadius:self.gtoupNameLabel.frame.size.height/2 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.projectStateButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
    
}

-(void)setModel:(ICEFORCEAlreadyRootModel *)model{
    _model = model;
    
    self.gtoupNameLabel.text = model.indusGroupStr;
    self.projectNameLabel.text = model.projName;
    
    if ([MyPublicClass stringIsNull:model.projInvestedStatus]) {
        self.projecyTagButton.hidden = YES;
    }else{
        self.projecyTagButton.hidden = NO;
        if ([model.projInvestedStatus isEqualToString:@"A"]) {
            self.projectStateButton.backgroundColor = [UIColor redColor];
        }else if ([model.projInvestedStatus isEqualToString:@"G"]){
             self.projectStateButton.backgroundColor = [UIColor greenColor];
        }else if ([model.projInvestedStatus isEqualToString:@"W"]){
             self.projectStateButton.backgroundColor = [UIColor orangeColor];
        }else{
             self.projectStateButton.backgroundColor = [UIColor blueColor];
        }
        
        [self.projectStateButton setTitle:model.projInvestedStatus forState:(UIControlStateNormal)];
    }
    
    if ([MyPublicClass stringIsNull:model.comInduStr]) {
        self.projectStateButton.hidden = YES;
    }else{
        self.projectStateButton.hidden = NO;
        [self.projectStateButton setTitle:model.comInduStr forState:(UIControlStateNormal)];
    }
    
    self.projectContLabel.text = model.zhDesc;
    self.userNameLabel.text = model.projManagerNames;
    
}
- (IBAction)stateClick:(UIButton *)sender {
    if ([self.delegateCell respondsToSelector:@selector(showAlreadyRootCell:selectModel:selectButton:)]) {
        [self.delegateCell showAlreadyRootCell:self selectModel:_model selectButton:sender];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
