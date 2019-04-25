//
//  CXNewColleagueCell.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNewColleagueCell.h"
#import "Masonry.h"
#import "UIImage+YYAdd.h"
#import "UIImageView+EMWebCache.h"

@interface CXNewColleagueCell ()

/** <#comment#> */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** <#comment#> */
@property (nonatomic, strong) UILabel *nameLabel;
/** <#comment#> */
@property (nonatomic, strong) UIButton *agreeButton;
/** <#comment#> */
@property (nonatomic, strong) UIButton *rejectButton;

@end

@implementation CXNewColleagueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setup {
    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(self.contentView);
        }];
        imageView;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImageView.mas_right).offset(12);
            make.centerY.equalTo(self.contentView);
        }];
        label;
    });
    
    self.rejectButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"拒绝" forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setTitleColor:kColorWithRGB(154, 154, 154) forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = kColorWithRGB(154, 154, 154).CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(buttonOnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.equalTo(self);
        }];
        btn;
    });
    
    self.agreeButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"同意" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:kColorWithRGB(236, 72, 72)] forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 3;
//        btn.layer.borderColor = kColorWithRGB(88, 109, 150).CGColor;
//        btn.layer.borderWidth = 1;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(buttonOnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rejectButton.mas_left).offset(-6);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.equalTo(self);
        }];
        btn;
    });
}

- (void)setColleageModel:(CXNewColleagueModel *)colleageModel {
    _colleageModel = colleageModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:colleageModel.icon] placeholderImage:Image(@"temp_user_head") options:(EMSDWebImageRetryFailed)];
    self.nameLabel.text = colleageModel.name;
}

- (void)buttonOnTap:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(newColleagueCell:willHandle:atIndexPath:)]) {
        BOOL isAgree = button == self.agreeButton;
        NSIndexPath *indexPath = [[self getTableView] indexPathForCell:self];
        [self.delegate newColleagueCell:self willHandle:isAgree atIndexPath:indexPath];
    }
}

- (UITableView *)getTableView{
    for (UIView *next = self.superview; next; next = next.superview) {
        if ([next isKindOfClass:[UITableView class]]) {
            return (UITableView *)next;
        }
    }
    return nil;
}

@end
