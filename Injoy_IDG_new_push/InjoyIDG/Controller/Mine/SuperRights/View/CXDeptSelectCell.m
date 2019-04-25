//
//  CXDeptSelectCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXDeptSelectCell.h"
#import "Masonry.h"

@interface CXDeptSelectCell ()

/** 部门名称 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 选择按钮 */
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation CXDeptSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
    _selectButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:Image(@"unSelected") forState:UIControlStateNormal];
        [btn setImage:Image(@"selected") forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self).offset(-15);
        }];
        btn;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setDeptModel:(CXDeptModel *)deptModel {
    _deptModel = deptModel;
    self.nameLabel.text = deptModel.name;
    self.selectButton.selected = deptModel.selected;
}

@end
