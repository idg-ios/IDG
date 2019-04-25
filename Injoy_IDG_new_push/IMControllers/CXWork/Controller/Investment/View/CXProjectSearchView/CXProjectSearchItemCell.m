//
//  CXProjectSearchItemCell.m
//  InjoyIDG
//
//  Created by cheng on 2017/12/18.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXProjectSearchItemCell.h"
#import "Masonry.h"

@interface CXProjectSearchItemCell ()

/** 文字label */
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CXProjectSearchItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        label;
    });
}

- (void)setHighlighted:(BOOL)highlighted {}

- (void)setSelected:(BOOL)selected {}

- (void)setText:(NSString *)text {
    _text = text;
    [self setContent];
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    self.textLabel.layer.borderWidth = checked ? 1 : 0;
    self.textLabel.layer.borderColor = kColorWithRGB(236, 72, 73).CGColor;
    self.textLabel.backgroundColor = checked ? [UIColor whiteColor] : kColorWithRGB(245, 246, 248);
    
    [self setContent];
}

- (void)setContent {
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] init];
    
    if (self.checked) {
        NSTextAttachment *imgAttmt = [[NSTextAttachment alloc] init];
        UIImage *img = [UIImage imageNamed:@"tick"];
        imgAttmt.image = img;
        imgAttmt.bounds = CGRectMake(0, -2, img.size.width, img.size.height);
        [atts appendAttributedString:[NSAttributedString attributedStringWithAttachment:imgAttmt]];
    }
    
    NSDictionary<NSAttributedStringKey, id> *attributes = @{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: self.checked ? kColorWithRGB(236, 72, 73) : [UIColor lightGrayColor]
                                                            };
    [atts appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attributes]];
    [atts appendAttributedString:[[NSAttributedString alloc] initWithString:self.text ?: @"" attributes:attributes]];
    self.textLabel.attributedText = atts;
}

@end
