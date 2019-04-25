//
//  ICEFORCEPerAndGupTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/12.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPerAndGupTableViewCell.h"
@interface ICEFORCEPerAndGupTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *projectState;
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end

@implementation ICEFORCEPerAndGupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [MyPublicClass layerMasksToBoundsForAnyControls:self.baseView cornerRadius:4 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.projectState cornerRadius:self.projectState.frame.size.height/2 borderColor:nil borderWidth:0];
   
}



-(void)setModel:(ICEFORCEPotentialProjectmModel *)model{
    _model = model;
    
    if (![MyPublicClass stringIsNull:model.stsIdStr]) {
        
        if ([model.stsIdStr isEqualToString:@"PASS"]) {
            self.projectState.textColor = [UIColor grayColor];
            [self.stateButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
            [MyPublicClass layerMasksToBoundsForAnyControls:self.stateButton cornerRadius:2 borderColor:[UIColor lightGrayColor] borderWidth:1];
        }else{
            self.projectState.textColor = [UIColor redColor];
             [self.stateButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            [MyPublicClass layerMasksToBoundsForAnyControls:self.stateButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
            
        }
        
        [self.stateButton setTitle:[NSString stringWithFormat:@"  %@  ",model.stsIdStr] forState:(UIControlStateNormal)];
        [self.stateButton addTarget:self action:@selector(clickState:) forControlEvents:(UIControlEventTouchUpInside)];
        if (model.followUpStatus.integerValue == 0) {
            [self.starButton setImage:[UIImage imageNamed:@"blank_star"] forState:(UIControlStateNormal)];
        }else if (model.followUpStatus.integerValue == 1){
            [self.starButton setImage:[UIImage imageNamed:@"half_star"] forState:(UIControlStateNormal)];
        }else{
            [self.starButton setImage:[UIImage imageNamed:@"full_star"] forState:(UIControlStateNormal)];
        }
        
         [self.starButton addTarget:self action:@selector(clickState:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    
    
    
    self.projectName.text = model.projName;
    self.projectState.text = model.indusGroupStr;
    self.contentText.text = model.zhDesc;
    
}
-(void)clickState:(UIButton *)sender{
    if ([self.delegateCell respondsToSelector:@selector(showStateCell:selectModel:selectButton:)]) {
        [self.delegateCell showStateCell:self selectModel:self.model selectButton:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
