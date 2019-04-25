//
// Created by ^ on 2017/11/28.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXTravelSystemViewController.h"
#import "Masonry.h"
#import "CXBaseRequest.h"

@interface CXTravelSystemViewController () <UIWebViewDelegate>
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) UIWebView *webView;
@end

@implementation CXTravelSystemViewController

#pragma mark - instance function

- (void)loadWebView:(NSString *)path {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", path]];
    NSURLRequest *request = [NSURLRequest
            requestWithURL:url
               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
           timeoutInterval:10.f];
    [_webView loadRequest:request];
}

#pragma mark - HTTP request

- (void)findTravelUrl {
    NSString *url = [NSString stringWithFormat:@"%@rule/travel.htm", urlPrefix];
    [self loadWebView:url];
}

#pragma mark - UI

- (void)setUpSubviews {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scalesPageToFit = NO;
    webView.backgroundColor = [UIColor whiteColor];
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
    [rootTopView setNavTitle:@"差旅制度"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

#pragma mark - view life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavBar];
    [self setUpSubviews];
    [self findTravelUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

@end
