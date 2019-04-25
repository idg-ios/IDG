//
//  CXLogisticsViewController.m
//  InjoyDDXWBG
//
//  Created by cheng on 2017/10/25.
//  Copyright © 2017年 Injoy. All rights reserved.
//

#import "CXLogisticsViewController.h"

@interface CXLogisticsViewController () <UIWebViewDelegate>

/** <#comment#> */
@property (nonatomic, strong)  UIWebView *webView;

@end

@implementation CXLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    HUD_SHOW(nil);
    NSURL *url = [NSURL URLWithString:@"http://m.kuaidi100.com/index_all.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setup {
    [self.RootTopView setNavTitle:@"物流查询"];
    [self.RootTopView setUpLeftBarItemImage:Image(@"back") addTarget:self action:@selector(goBack)];
    
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
        webView.delegate = self;
        webView.scrollView.bounces = NO;
        [self.view addSubview:webView];
        webView;
    });
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    HUD_HIDE;
    
    NSString *js = @" \
    $('#input .smart-header').remove(); \
    $('footer.main').remove(); \
    $('#select .smart-footer').remove(); \
    $('#result #saveBtn').remove(); \
    $('#queryResult').nextAll().remove(); \
    $('#notfind .smart-opera-btn').remove(); \
    $('#select .smart-word-ul li:last').remove(); \
    $('#result .smart-result').css('margin-bottom', '0'); \
    ";
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    HUD_HIDE;
    CXAlert(KNetworkFailRemind);
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
