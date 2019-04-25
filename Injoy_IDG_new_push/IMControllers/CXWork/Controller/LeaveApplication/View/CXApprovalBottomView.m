//
// Created by ^ on 2017/10/30.
// Copyright (c) 2017 Injoy. All rights reserved.
//

const CGFloat CXApprovalBottomViewHeight = 50.f;

#import "CXApprovalBottomView.h"
#import "Masonry.h"
#import "CXConfirmView.h"
#import "CXBaseRequest.h"

@interface CXApprovalBottomView ()
@property(copy, nonatomic) NSString *type;
@property(assign, nonatomic) int eid;
@end

@implementation CXApprovalBottomView

- (void)remindRequest {
    NSString *url = [NSString stringWithFormat:@"%@%@/approval/remind", urlPrefix, self.type];

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"eid"] = @(self.eid);

    [CXBaseRequest postResultWithUrl:url
                               param:param
                             success:^(id responseObj) {
                                 if (HTTPSUCCESSOK == [[responseObj valueForKeyPath:@"status"] intValue]) {
                                     CXAlert(responseObj[@"msg"]);
                                 } else {
                                     MAKE_TOAST([responseObj valueForKeyPath:@"msg"]);
                                 }
                             } failure:^(NSError *error) {
                CXAlert(KNetworkFailRemind);
            }];
}

- (void)btnEvent:(UIButton *)sender {
    [CXConfirmView showWithTitle:@"提示" message:@"是否发送提醒?" callback:^(BOOL yes) {
        if (yes) {
            [self remindRequest];
        }
    }];
}

- (void)setUpSubViews {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kColorWithRGB(241.f, 240.f, 246.f);
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(topView);
        make.height.mas_equalTo(20.f);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:kColorWithRGB(85.f, 128.f, 201.f) forState:UIControlStateNormal];
    [btn setTitle:@"提醒批阅" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
    }];
}

- (instancetype)initWithType:(NSString *)type eid:(int)eid {
    if (self = [super initWithFrame:(CGRect) {0.f, 0.f, Screen_Width, CXApprovalBottomViewHeight}]) {
        self.type = type;
        self.eid = eid;

        [self setUpSubViews];
    }
    return self;
}

@end
