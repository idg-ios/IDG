//
//  CXHouseProjectMeetingDetailViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/5/29.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXHouseProjectMeetingDetailViewController.h"
#import "HttpTool.h"
#import "Masonry.h"

@interface CXHouseProjectMeetingDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) NSString * conferenceInformationDetailURL;
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) UIWebView *webView;
@end

@implementation CXHouseProjectMeetingDetailViewController

- (void)setUpSubviews {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    self.webView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"会议详情"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

#pragma mark - view life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setUpNavBar];
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@project/house/opinion/detail/h.htm?opinionId=%zd&token=%@",urlPrefix,[self.model.opinionId integerValue],VAL_token]];
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:url
                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval:10.f];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}


@end