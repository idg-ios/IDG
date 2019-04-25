//
//  CXInternalBulletinDetailViewController.m
//  InjoyIDG
//
//  Created by ^ on 2018/1/30.
//  Copyright © 2018年 Injoy. All rights reserved.
//


#import <WebKit/WebKit.h>
#import "CXInternalBulletinDetailViewController.h"
@interface CXInternalBulletinDetailViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic, assign)NSInteger eid;
@property(nonatomic, copy)NSString *subTitle;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic, copy)NSString *fileType;
@property(nonatomic, copy)NSString *urlString;

@end

@implementation CXInternalBulletinDetailViewController

- (id)initWithEid:(NSInteger)eid type:(type)type andTitle:(NSString *)tit{
    if(self = [super init]){
        self.eid = eid;
        self.subTitle = tit;
        self.type = type;
    }
    return  self;
}
- (id)initWithEid:(NSInteger)eid type:(type)type fileType:(NSString *)fileType URLString:(NSString *)URLString andTitle:(NSString *)tit{
    if(self = [super init]){
        self.eid = eid;
        self.subTitle = tit;
        self.type = type;
        self.fileType = fileType;
        self.urlString = URLString;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SDBackGroudColor;
    [self setupNavView];
    [self setUp];
}


#pragma mark_private method
-(void)setupNavView{
    SDRootTopView *rootTopView = [self getRootTopView];
    [rootTopView setNavTitle:self.subTitle];
    [rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}
-(void)setUp{

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-64) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:key_token];
    NSString *urlString = nil;
    if(self.type == isInternalButin){
        urlString = [NSString stringWithFormat:@"%@magazine/pdf/view/%zd.htm?token=%@",urlPrefix,self.eid,token];
    }else if(self.type == isTool){
        urlString = [NSString stringWithFormat:@"%@tool/pdf/view/%zd.htm?token=%@",urlPrefix,self.eid,token];
    }else if (self.type == isFJListH5){
        urlString = [NSString stringWithFormat:@"%@pdf/view/proAnnex/%zd.htm?token=%@", urlPrefix, self.eid, token];
    }
    if(self.urlString){
        urlString = [NSString stringWithFormat:@"%@%@/%zd.htm?token=%@", urlPrefix, self.urlString,self.eid, token];
    }
    if(self.fileType){
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&type=%@",self.fileType]];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    [self showHudInView:self.webView hint:@"页面正在拼命加载中...."];
    
}

#pragma  mark -delegateMethod
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHudWithView:self.webView];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self hideHudWithView:self.webView];
    CXAlert(@"页面加载失败！");
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
