//
// Created by ^ on 2017/12/15.
// Copyright (c) 2017 Injoy. All rights reserved.
//

#import "CXConferenceInformationDetailViewController.h"
#import "Masonry.h"

@interface CXConferenceInformationDetailViewController ()
@property(weak, nonatomic) SDRootTopView *rootTopView;
@property(weak, nonatomic) UIWebView *webView;
@end

@implementation CXConferenceInformationDetailViewController

#pragma mark - function

- (void)loadWebView:(NSString *)path {
    NSLog(@":%@", path);
    [self.webView loadHTMLString:path baseURL:nil];
}

#pragma mark - HTTP Request

- (void)findDetailRequest {
    NSString *url = [NSString stringWithFormat:@"%@project/opinion/detail/h.htm", urlPrefix];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest
            requestWithURL:[NSURL URLWithString:url]
               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
           timeoutInterval:10.f];

    [urlRequest setValue:VAL_token forHTTPHeaderField:@"token"];
    [urlRequest setValue:[NSString stringWithFormat:@"%zd", self.opinionId]
      forHTTPHeaderField:@"opinionId"];

    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (!connectionError) {
                                   [self loadWebView:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                               }
                           }];
}

#pragma mark - UI

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    self.rootTopView = rootTopView;
    [rootTopView setNavTitle:@"会议信息"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"]
                             addTarget:self.navigationController
                                action:@selector(popViewControllerAnimated:)];
}

- (void)setUpSubviews {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
        make.top.equalTo(self.rootTopView.mas_bottom);
    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNavBar];
    [self setUpSubviews];

    [self findDetailRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
