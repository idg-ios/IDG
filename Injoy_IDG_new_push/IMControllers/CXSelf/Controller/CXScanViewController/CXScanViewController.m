//
//  CXScanViewController.m
//  SDMarketingManagement
//
//  Created by fanzhong on 16/4/9.
//  Copyright © 2016年 slovelys. All rights reserved.
//

#import "CXScanViewController.h"
#import "SDRootTopView.h"
#import "QRCodeReaderView.h"
#import "HttpTool.h"
#import "AppDelegate.h"
#import "SDDataBaseHelper.h"
#import "SDIMAddFriendsDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SDDataBaseHelper.h"
#import "SDContactsDetailController.h"
#import "CXIMHelper.h"

@interface CXScanViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}
@end

@implementation CXScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavUI];
    [self InitScan];
    isFirst = YES;
    isPush = NO;
}
- (void)setNavUI
{
    SDRootTopView *topView = [self getRootTopView];
    [topView setNavTitle:@"扫一扫"];
    [topView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}
#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height-navHigh)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = kColorWithRGB(23,23,24);
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
    //    //播放扫描二维码的声音
    //    SystemSoundID soundID;
    //    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    //    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
    
    [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

#pragma mark - 扫描结果处理
- (void)loadViewWithStr:(NSString *)str
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navHigh, Screen_Width, Screen_Height - navHigh)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:str];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //修改服务器页面的meta的值
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *newStr = [alertView.message componentsSeparatedByString:@"?"][1];
    if (buttonIndex == 1) {
        [self loadViewWithStr:newStr];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
    if([str rangeOfString:@"cx:injoy365.cn"].location != NSNotFound){
        //如果扫码得到的字符串包含@"cx:injoy365.cn"则为加好友
        //userId&imAccount&userName&cx:injoy365.cn
        NSArray * strArray = [str componentsSeparatedByString:@"&"];
        if(strArray == nil || (strArray != nil && [strArray count] != 4)){
            TTAlert(@"请求出错");
            return;
        }else{
            if([strArray[1] integerValue] == [[AppDelegate getUserID] integerValue]){
                TTAlert(@"不能加自己为好友");
                return;
            }
            
            NSString * path = [NSString stringWithFormat:@"%@friend/judge",urlPrefix];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setValue:@((long)[strArray[0] integerValue]) forKey:@"friendId"];
            [params setValue:@"cx:injoy365.cn" forKey:@"cxid"];
            
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:@"正在加载数据"];
            [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] integerValue] == 200) {
                    if([JSON[@"data"] integerValue] == 1){
                        [weakSelf hideHud];
                        NSString * alertStr = [NSString stringWithFormat:@"您和%@已经是好友了",strArray[2]];
                        TTAlert(alertStr);
                        SDCompanyUserModel * userModel = [[SDDataBaseHelper shareDB]getUserByUserID:[NSString stringWithFormat:@"%zd",[strArray[0] integerValue]]];
                        SDContactsDetailController *vc = [[SDContactsDetailController alloc] init];
                        vc.userModel = userModel;
                        [self.navigationController pushViewController:vc animated:YES];
                        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
                        }
                        return;
                        
                    }else if([JSON[@"msg"] integerValue] == 0){
                        SDIMAddFriendsDetailsViewController * addFriendsDetailsViewController = [[SDIMAddFriendsDetailsViewController alloc] init];
                        
                        NSString *url = [NSString stringWithFormat:@"%@sysUser/%zd", urlPrefix,[strArray[0] integerValue]];
                        [HttpTool getWithPath:url params:nil success:^(id JSON) {
                            [weakSelf hideHud];
                            NSDictionary *jsonDict = JSON;
                            if ([jsonDict[@"status"] integerValue] == 200) {
                                SDCompanyUserModel *userModel = [SDCompanyUserModel yy_modelWithDictionary:JSON[@"data"]];
                                userModel.userId = @([JSON[@"data"][@"eid"] integerValue]);
                                userModel.hxAccount = userModel.imAccount;
                                userModel.realName = userModel.name;
                                addFriendsDetailsViewController.userModel = userModel;
                                [weakSelf.navigationController pushViewController:addFriendsDetailsViewController animated:YES];
                                if ([weakSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                                    weakSelf.navigationController.interactivePopGestureRecognizer.delegate = nil;
                                }
                            }else{
                                TTAlert(JSON[@"msg"]);
                            }
                        } failure:^(NSError *error) {
                            [weakSelf hideHud];
                            CXAlert(KNetworkFailRemind);
                        }];
                    }
                }else{
                    [weakSelf hideHud];
                    [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        }
    }
    else if([str rangeOfString:@"cx:idgMeetId.cn"].location != NSNotFound){
        //如果扫码得到的字符串包含@"cx:idgMeetIdAndImAccount.cn"则为扫码签到
        //meetId&cx:idgMeetId.cn
        NSArray * strArray = [str componentsSeparatedByString:@"&"];
        if(strArray == nil || (strArray != nil && [strArray count] != 2)){
            TTAlert(@"请求出错");
            return;
        }else{
            NSString * path = [NSString stringWithFormat:@"%@annual/meeting/signin",urlPrefix];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setValue:@([strArray[0] integerValue]) forKey:@"meetId"];
            __weak __typeof(self)weakSelf = self;
            [self showHudInView:self.view hint:@"正在加载数据"];
            [HttpTool postWithPath:path params:params success:^(NSDictionary *JSON) {
                if ([JSON[@"status"] integerValue] == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                    NSString * attentionText = [NSString stringWithFormat:@"%@",JSON[@"data"][@"myTable"]];
                    TTAlert(attentionText);
                }
//                else if ([JSON[@"status"] intValue] == 400) {
//                    [self.view setNeedShowAttentionAndEmptyPictureText:JSON[@"msg"] AndPictureName:@"pic_kzt_wsj"];
//                }
                else{
                    [weakSelf hideHud];
                    [weakSelf.view makeToast:JSON[@"msg"] duration:2 position:@"center"];
                }
            } failure:^(NSError *error) {
                [weakSelf hideHud];
                CXAlert(KNetworkFailRemind);
            }];
        }
    }
    else if ([NSString checkIsNumber:str])
    {
        if (self.scanCallBack) {
            self.scanCallBack(str);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //如果扫码得到的字符串不包含@"cx:injoy365.cn"则为其他
        NSString * codeString = [NSString stringWithFormat:@"%@register/bsRegister.htm",urlPrefix];
        if ([str isEqualToString:codeString] || [str isEqualToString:VAL_IOS_DOWNLOAD] || [str rangeOfString:@"register/toInvitation/"].location != NSNotFound) {//超享
            [self loadViewWithStr:str];
        }else{
            NSString *string = @"可能存在风险，是否打开此链接?";
            NSString *showStr = [string stringByAppendingString:str];
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开链接", nil];
            [alertView show];
        }
    }
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
