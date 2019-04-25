//
//  ICEFORCEFollowOnTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEFollowOnTableViewCell.h"

@interface ICEFORCEFollowOnTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UIButton *indButton;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;


@end

@implementation ICEFORCEFollowOnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [MyPublicClass layerMasksToBoundsForAnyControls:self.baseView cornerRadius:4 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.groupLabel cornerRadius:self.groupLabel.frame.size.height/2 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.stateButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.indButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
    
}

-(void)setModel:(ICEFORCEFollowOnModel *)model{
    _model = model;
    
    self.groupLabel.text = model.indusGroupStr;
    self.projectNameLabel.text = model.projName;
    
    self.userNameLabel.text = model.projManagerNames;
    
    if ([MyPublicClass stringIsNull:model.comInduStr] && [MyPublicClass stringIsNull:model.stsIdStr]) {
        self.stateButton.hidden = YES;
        self.indButton.hidden = YES;
    }else if ([MyPublicClass stringIsNull:model.comInduStr] && ![MyPublicClass stringIsNull:model.stsIdStr]){
        
        self.stateButton.hidden = NO;
        self.indButton.hidden = YES;
        [self.stateButton setTitle: [NSString stringWithFormat:@"  %@  ",model.stsIdStr] forState:(UIControlStateNormal)];
    }else if (![MyPublicClass stringIsNull:model.comInduStr] && [MyPublicClass stringIsNull:model.stsIdStr]){
        
        self.stateButton.hidden = YES;
        self.indButton.hidden = NO;
        
        [self.indButton setTitle:[NSString stringWithFormat:@"  %@  ",model.comIndu] forState:(UIControlStateNormal)];
    }else{
        
        self.stateButton.hidden = NO;
        self.indButton.hidden = NO;
        
        [self.stateButton setTitle:[NSString stringWithFormat:@"  %@  ",model.stsIdStr] forState:(UIControlStateNormal)];
        [self.indButton setTitle:[NSString stringWithFormat:@"  %@  ",model.comInduStr] forState:(UIControlStateNormal)];
    }
    self.conLabel.text = model.zhDesc;
    
    if ([model.stsIdStr isEqualToString:@"PASS"]) {
        self.groupLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.groupLabel.textColor = [UIColor redColor];
    }
}


- (IBAction)stateClick:(UIButton *)sender{
    if ([self.delegateCell respondsToSelector:@selector(showFollowOnRootCell:selectModel:selectButton:)]) {
        [self.delegateCell showFollowOnRootCell:self selectModel:_model selectButton:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
