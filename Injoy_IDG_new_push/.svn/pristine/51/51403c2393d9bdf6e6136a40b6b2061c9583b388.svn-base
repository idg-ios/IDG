//
//  CXNoticeCell.m
//  InjoyIDG
//
//  Created by cheng on 2017/11/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoticeCell.h"
#import "Masonry.h"

@interface CXNoticeCell ()

/** <#comment#> */
@property (nonatomic, strong) UIImageView *imgView;
/** <#comment#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#comment#> */
@property (nonatomic, strong) UILabel *remarkLabel;
/** <#comment#> */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CXNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imgView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:Image(@"GSTZImg")];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(self.contentView);
        }];
        imageView;
    });
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(174, 174, 174);
        label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        label;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imgView.mas_centerY).offset(-2);
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        }];
        label;
    });
    
    self.remarkLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = kColorWithRGB(174, 174, 174);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_centerY).offset(2);
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        }];
        label;
    });
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path setLineWidth: 1];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [kColorWithRGB(174, 174, 174) set];
    [path stroke];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    self.remarkLabel.text = remark;
}

- (void)setCreateTime:(NSString *)createTime {
    _createTime = createTime;
    self.timeLabel.text = createTime;
}
@end
