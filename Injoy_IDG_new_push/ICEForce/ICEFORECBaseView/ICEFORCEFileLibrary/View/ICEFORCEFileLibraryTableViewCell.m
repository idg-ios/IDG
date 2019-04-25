//
//  ICEFORCEFileLibraryTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/25.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEFileLibraryTableViewCell.h"

@interface ICEFORCEFileLibraryTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *projecyTagButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UIButton *projectStateButton;
@property (weak, nonatomic) IBOutlet UIButton *projectInButton;
@property (weak, nonatomic) IBOutlet UILabel *projectContLabell;


@end
@implementation ICEFORCEFileLibraryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [MyPublicClass layerMasksToBoundsForAnyControls:self.baseView cornerRadius:4 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.groupLabel cornerRadius:self.groupLabel.frame.size.height/2 borderColor:nil borderWidth:0];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.projectStateButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
    [MyPublicClass layerMasksToBoundsForAnyControls:self.projectInButton cornerRadius:2 borderColor:[MyPublicClass colorWithHexString:@"#007AFF"] borderWidth:1];
    
    
}
-(void)setModel:(ICEFORCEFileLibraryModel *)model{
    _model = model;
    
    self.groupLabel.text = model.indusGroupStr;
    self.projectNameLabel.text = model.projName;
    
    if ([MyPublicClass stringIsNull:model.projInvestedStatus]) {
        self.projecyTagButton.hidden = YES;
    }else{
        self.projecyTagButton.hidden = NO;
        if ([model.projInvestedStatus isEqualToString:@"A"]) {
            self.projecyTagButton.backgroundColor = [UIColor redColor];
        }else if ([model.projInvestedStatus isEqualToString:@"G"]){
            self.projecyTagButton.backgroundColor = [UIColor greenColor];
        }else if ([model.projInvestedStatus isEqualToString:@"W"]){
            self.projecyTagButton.backgroundColor = [UIColor orangeColor];
        }else{
            self.projecyTagButton.backgroundColor = [UIColor blueColor];
        }
        [self.projecyTagButton setTitle:model.projInvestedStatus forState:(UIControlStateNormal)];
    }
    
    [self.userNameButton setTitle:model.projManagerNames forState:(UIControlStateNormal)];
    
    if ([MyPublicClass stringIsNull:model.comInduStr] && [MyPublicClass stringIsNull:model.stsIdStr]) {
        self.projectStateButton.hidden = YES;
        self.projectInButton.hidden = YES;
    }else if ([MyPublicClass stringIsNull:model.comInduStr] && ![MyPublicClass stringIsNull:model.stsIdStr]){
        
        self.projectStateButton.hidden = NO;
        self.projectInButton.hidden = YES;
        [self.projectStateButton setTitle: [NSString stringWithFormat:@"  %@  ",model.stsIdStr] forState:(UIControlStateNormal)];
    }else if (![MyPublicClass stringIsNull:model.comInduStr] && [MyPublicClass stringIsNull:model.stsIdStr]){
        
        self.projectStateButton.hidden = YES;
        self.projectInButton.hidden = NO;
        
        [self.projectInButton setTitle:[NSString stringWithFormat:@"  %@  ",model.comIndu] forState:(UIControlStateNormal)];
    }else{
        
        self.projectStateButton.hidden = NO;
        self.projectInButton.hidden = NO;
        
        [self.projectStateButton setTitle:[NSString stringWithFormat:@"  %@  ",model.stsIdStr] forState:(UIControlStateNormal)];
        [self.projectInButton setTitle:[NSString stringWithFormat:@"  %@  ",model.comInduStr] forState:(UIControlStateNormal)];
    }
    self.projectContLabell.text = model.zhDesc;
    
    if ([model.stsIdStr isEqualToString:@"PASS"]) {
        self.groupLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.groupLabel.textColor = [UIColor redColor];
    }
    
    
}

- (IBAction)stateClick:(UIButton *)sender{
    if ([self.delegateCell respondsToSelector:@selector(showAlreadyRootCell:selectModel:selectButton:)]) {
        [self.delegateCell showAlreadyRootCell:self selectModel:_model selectButton:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
