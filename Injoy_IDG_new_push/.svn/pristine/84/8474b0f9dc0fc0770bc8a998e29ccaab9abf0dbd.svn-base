//
//  CXYMNewsLetterDetailViewController.m
//  InjoyIDG
//
//  Created by yuemiao on 2018/8/11.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXYMNewsLetterDetailViewController.h"
#import "CXYMNewsLetter.h"
#import "Masonry.h"

@interface CXYMNewsLetterDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) CXYMNewsLetter *newsLetter;

@end

@implementation CXYMNewsLetterDetailViewController


-(instancetype)initWithNewsLetter:(CXYMNewsLetter *)newsLetter{
    self = [super init];
    if(self){
        _newsLetter = newsLetter;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.RootTopView setNavTitle:self.newsLetter.docName ? : @" "];
    [self.RootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self setupWebView];
}
-(void)setupWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
     [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(navHigh);
         make.left.right.mas_equalTo(0);
         make.bottom.equalTo(self.view).offset(-kTabbarSafeBottomMargin);
     }];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@news/letter/pdf/view/%ld.htm?eid=%ld&token=%@",urlPrefix,[self.newsLetter.docId integerValue],[self.newsLetter.docId integerValue],VAL_token]];
    ///news/letter/pdf/view/{eid}.htm
    NSURLRequest *request = [NSURLRequest
                             requestWithURL:url
                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                             timeoutInterval:10.f];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
