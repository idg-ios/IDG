//
// Created by ^ on 2017/10/24.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXBottomShareView.h"
#import "Masonry.h"
#import "CXEditLabel.h"

const CGFloat CXBottomShareViewHeight = 50.f;

@interface CXBottomShareView ()
/** < 内容 */
@property(strong, nonatomic) CXEditLabel *shareLabel;
@property(copy, nonatomic) NSArray *ccArr;
@end

@implementation CXBottomShareView

/** < 表单的分割线 */
- (UIView *)createFormSeperatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    return line;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, Screen_Width, CXBottomShareViewHeight)]) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *topLine = [self createFormSeperatorLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(2.f);
        }];

        UIView *bottomLine = [self createFormSeperatorLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(2.f);
        }];

        _shareLabel = [[CXEditLabel alloc] init];
        _shareLabel.title = @" 分享：";
        _shareLabel.inputType = CXEditLabelInputTypeCC;
        [self addSubview:_shareLabel];

        @weakify(self);
        _shareLabel.didFinishEditingBlock = ^(CXEditLabel *editLabel) {
            @strongify(self);
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for (CXUserModel *selectMember in editLabel.selectedCCUsers) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setValue:@(selectMember.eid) forKey:@"eid"];
                [dic setValue:selectMember.name forKey:@"name"];
                [dic setValue:selectMember.imAccount forKey:@"imAccount"];
                [dataArray addObject:dic];
            }
            self.ccArr = [dataArray copy];
        };

        [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.center.equalTo(self);
            make.top.equalTo(topLine.mas_bottom);
            make.bottom.equalTo(bottomLine.mas_top);
        }];
    }
    return self;
}

#pragma mark - get & set

- (void)setCC:(NSArray *)cc {
    self.shareLabel.allowEditing = NO;
    self.shareLabel.showDropdown = NO;
    if ([cc count]) {
        self.shareLabel.detailCCData = cc;
    }
}

- (NSString *)getValue {
    return [self.ccArr yy_modelToJSONString];
}

@end
