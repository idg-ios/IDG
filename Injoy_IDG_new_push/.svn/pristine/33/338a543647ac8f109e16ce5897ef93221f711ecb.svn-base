//
//  CXNoticeDetailViewController.m
//  InjoyIDG
//
//  Created by cheng on 2017/11/27.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXNoticeDetailViewController.h"
#import "HttpTool.h"
#import "Masonry.h"
#import "UIView+YYAdd.h"
#import "CXIDGBackGroundViewUtil.h"

@interface CXNoticeDetailViewController ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLabel;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CXNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self getDetail:self.eid];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 左右的间距
    CGFloat margin = 8;
    self.titleLabel.left = margin;
    self.titleLabel.top = 15;
    self.titleLabel.size = [self.titleLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.scrollView) - 2 * margin, CGFLOAT_MAX)];
    
    self.contentLabel.top = GET_MAX_Y(self.titleLabel) + 20;
    self.contentLabel.left = margin;
    self.contentLabel.size = [self.contentLabel sizeThatFits:CGSizeMake(GET_WIDTH(self.scrollView) - 2 * margin, CGFLOAT_MAX)];
    
    self.scrollView.contentSize = CGSizeMake(0, GET_MAX_Y(self.contentLabel) + 10);
    self.scrollView.backgroundColor = [CXIDGBackGroundViewUtil colorWithText:VAL_USERNAME AndTextColor:nil];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.RootTopView setNavTitle:@"公告通知"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(navHigh);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        }];
        scrollView;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.numberOfLines = 0;
        [self.scrollView addSubview:label];
        label;
    });
    
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        [self.scrollView addSubview:label];
        label;
    });
}

- (void)getDetail:(NSInteger)eid {
    HUD_SHOW(nil);
    NSString *path = [NSString stringWithFormat:@"/comNotice/detail/%zd.json", eid];
    [HttpTool getWithPath:path params:nil success:^(NSDictionary *JSON) {
        HUD_HIDE;
        if ([JSON[@"status"] intValue] == 200) {
            NSString *title = JSON[@"data"][@"comNotice"][@"title"];
            NSString *content = JSON[@"data"][@"comNotice"][@"remark"];
            self.titleLabel.text = title;
            self.contentLabel.text = content;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
        else {
            CXAlert(JSON[@"msg"]);
        }
    } failure:^(NSError *error) {
        HUD_HIDE;
        CXAlert(KNetworkFailRemind);
    }];
}

@end
