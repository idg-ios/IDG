//
//  CXFormHeaderView.m
//  InjoyYJ1
//
//  Created by cheng on 2017/7/24.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXFormHeaderView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "NSDate+YYAdd.h"
#import "UIView+YYAdd.h"
#import "CXDatePickerView.h"

CGFloat const CXFormHeaderViewHeight = 57;

@interface CXFormHeaderView ()

/** 头像 */
@property(nonatomic, strong) UIImageView *avatarImageView;
/** 名字 */
@property(nonatomic, strong) UILabel *nameLabel;
/** 部门 */
@property(nonatomic, strong) UILabel *deptLabel;
/** 日期 */
@property(nonatomic, strong) UILabel *dateLabel;
/** 编号 */
@property(nonatomic, strong) UILabel *numberLabel;

@end

@implementation CXFormHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setDefault];
    }
    return self;
}

- (void)setDefault {
    self.avatar = VAL_Icon;
    self.name = VAL_USERNAME;
    self.dept = [NSString stringWithFormat:@"%@    %@", VAL_DpName, VAL_Job];
    self.date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    self.number = @"";
    self.displayNumber = YES;
    self.dateAllowEditing = NO;
}

- (void)setup {
    self.avatarImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:Image(@"temp_user_head")];
        [self addSubview:imageView];
        imageView;
    });

    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(44.f, 44.f, 44.f);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFontSizeForForm;
        [self addSubview:label];
        label;
    });

    self.deptLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(134.f, 134.f, 134.f);
        label.font = kFontTimeSizeForForm;
        if (Screen_Width > 320) {
            [self addSubview:label];
        }
        label;
    });

    self.dateLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(134.f, 134.f, 134.f);
        label.text = @"日期：";
        label.font = kFontTimeSizeForForm;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapped:)]];
        [self addSubview:label];
        label;
    });

    self.numberLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kColorWithRGB(134.f, 134.f, 134.f);
        label.text = @"编号：";
        label.font = kFontTimeSizeForForm;
        [self addSubview:label];
        label;
    });
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
    if (!_avatar) {
        return;
    }
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:Image(@"temp_user_head") success:^(UIImage *image, BOOL cached) {

    }                             failure:^(NSError *error) {

    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    [self reLayout];
}

- (void)setDept:(NSString *)dept {
    _dept = dept;
    self.deptLabel.text = dept;
    [self reLayout];
}

- (void)setDate:(NSString *)date {
    _date = date;
    self.dateLabel.text = [NSString stringWithFormat:@"日期：%@", date];
    [self reLayout];
}

- (void)setNumber:(NSString *)number {
    _number = number;
    self.numberLabel.text = [NSString stringWithFormat:@"编号：%@", number];
    [self reLayout];
}

- (void)setDisplayNumber:(BOOL)displayNumber {
    _displayNumber = displayNumber;
    self.numberLabel.hidden = !displayNumber;
    [self reLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat wOffset = Screen_Width / 320.0;

    self.avatarImageView.height = GET_HEIGHT(self) * 0.7;
    self.avatarImageView.width = GET_HEIGHT(self.avatarImageView);
    self.avatarImageView.left = 8 * wOffset;
    self.avatarImageView.centerY = GET_HEIGHT(self) * 0.5;
    self.avatarImageView.layer.cornerRadius = GET_HEIGHT(self.avatarImageView) * 0.5;
    self.avatarImageView.layer.masksToBounds = YES;

    self.nameLabel.left = GET_MAX_X(self.avatarImageView) + 8 * wOffset;
    self.nameLabel.bottom = GET_HEIGHT(self) * 0.5 - 2;
    // 名字最多5个字的宽度
    // CGFloat maxWidth = [@"哈哈哈哈哈" sizeWithFont:self.nameLabel.font maxSize:CGSizeMake(FLT_MAX, FLT_MAX)].width;
    // self.nameLabel.size = [self.nameLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];

    self.deptLabel.left = self.nameLabel.left;
    self.deptLabel.top = GET_HEIGHT(self) * 0.5 + 2;
    [self.deptLabel sizeToFit];

    [self.dateLabel sizeToFit];
    [self.numberLabel sizeToFit];

    self.nameLabel.left = self.deptLabel.left;
    self.nameLabel.size = self.deptLabel.size;

    // 显示编号
    if (self.displayNumber) {
        // 日期更长，那么日期靠右
        if (GET_WIDTH(self.dateLabel) > GET_WIDTH(self.numberLabel)) {
            self.dateLabel.right = GET_WIDTH(self) - 8 * wOffset;
            self.dateLabel.bottom = GET_HEIGHT(self) * 0.5 - 2;
            self.numberLabel.left = GET_MIN_X(self.dateLabel);
            self.numberLabel.top = GET_HEIGHT(self) * 0.5 + 2;
        }
            // 编号更长
        else {
            self.numberLabel.right = GET_WIDTH(self) - 8 * wOffset;
            self.numberLabel.top = GET_HEIGHT(self) * 0.5 + 2;
            self.dateLabel.left = GET_MIN_X(self.numberLabel);
            self.dateLabel.bottom = GET_HEIGHT(self) * 0.5 - 2;
        }
    }
        // 不显示编号
    else {
        self.dateLabel.centerY = GET_HEIGHT(self) * 0.5;
        self.dateLabel.right = GET_WIDTH(self) - 8 * wOffset;
    }
}

- (void)reLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)dateLabelTapped:(UITapGestureRecognizer *)ges {
    @weakify(self);
    if (self.dateAllowEditing) {
        CXDatePickerView *picker = [[CXDatePickerView alloc] init];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.dateContent = self.date;
        picker.selectDateCallBack = ^(NSString *selectDate) {
            @strongify(self);
            self.date = selectDate;
        };
        [picker show];
    }
}

@end
