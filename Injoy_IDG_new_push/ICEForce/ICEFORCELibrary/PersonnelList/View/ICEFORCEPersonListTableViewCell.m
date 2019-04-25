//
//  ICEFORCEPersonListTableViewCell.m
//  InjoyIDG
//
//  Created by 念念不忘必有回响 on 2019/4/18.
//  Copyright © 2019 Injoy. All rights reserved.
//

#import "ICEFORCEPersonListTableViewCell.h"

@interface ICEFORCEPersonListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation ICEFORCEPersonListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ICEFORCEPersonListModel *)model{
    _model = model;
    
    self.userName.text = model.userName;
    self.selectButton.selected = model.isSelect;
    
}
- (IBAction)selectRow:(UIButton *)sender {
    
    if ([self.delegateCell respondsToSelector:@selector(selectCell:selectButton:selectIndex:)]) {
        [self.delegateCell selectCell:self selectButton:sender selectIndex:self.path];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
