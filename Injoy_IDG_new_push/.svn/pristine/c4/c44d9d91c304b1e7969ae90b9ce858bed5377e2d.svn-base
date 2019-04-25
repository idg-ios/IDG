//
//  CXTravalController.h
//  InjoyIDG
//
//  Created by admin on 2017/12/13.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXTravalController.h"
#import "HttpTool.h"

@interface CXTravalController ()
{
    NSString *visitURL;
}

@end

@implementation CXTravalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavBar {
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:@"差旅预定"];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}

- (void)setUpWebView {
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh)];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕

    NSURL* url = [NSURL URLWithString:visitURL];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
    [self.view addSubview:webView];
}

- (void)requestData {
    NSString *url = @"/out/fenbeitong/travel/url.json";
    [self showHudInView:self.view hint:@""];
    [HttpTool getWithPath:url params:nil success:^(NSDictionary *JSON) {
        [self hideHud];
        if ([JSON[@"status"] intValue] == 200) {
            visitURL = JSON[@"data"];
            [self setUpWebView];
        }
        else {
            CXAlert(KNetworkFailRemind);
        }

    } failure:^(NSError *error) {
        [self hideHud];
        CXAlert(KNetworkFailRemind);
    }];
}
@end
