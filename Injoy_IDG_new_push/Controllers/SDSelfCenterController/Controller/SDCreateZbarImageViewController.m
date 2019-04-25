//
//  SDCreateZbarImageViewController.m
//  SDMarketingManagement
//
//  Created by shenhuihui on 15/5/20.
//  Copyright (c) 2015年 slovelys. All rights reserved.
//

#import "SDCreateZbarImageViewController.h"
#import "QRCodeGenerator.h"
#import "HttpTool.h"
#import "SDCompanyUserModel.h"
#import "SDDataBaseHelper.h"
#import "AppDelegate.h"

@interface SDCreateZbarImageViewController ()

@property (nonatomic, strong) SDRootTopView* rootTopView;

@property (nonatomic, strong) UIImage *codeImage;
@property (nonatomic, strong) NSString *imageName;

/// 域名
@property (nonatomic, strong) NSString *urlName;
/// 公司ID
@property (nonatomic, strong) NSString *companyId;
/// 公司账号
@property (nonatomic, strong) NSString *companyAccount;
/// 公司名称
@property (nonatomic, strong) NSString *companyName;
/// 邀请人
@property (nonatomic, strong) NSString *inviteName;
/// 接口返回ID
@property (nonatomic, strong) NSString *inviteId;
/// 二维码内容
@property (nonatomic, strong) NSString *qrString;
/// 复制内容
@property (nonatomic, strong) NSString *fzString;

@property (nonatomic, strong) SDCompanyUserModel *userModel;
@property (strong, nonatomic) SDDataBaseHelper* dataHelper;

@end

@implementation SDCreateZbarImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTopView];
    [self setUpValue];
    [self loadURL];
}

- (void)setUpTopView
{
    _rootTopView = [self getRootTopView];
    
    NSString* version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [_rootTopView setNavTitle:[NSString stringWithFormat:@"下载%@版客户端",version]];
    
    [_rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self action:@selector(leftBtnClick)];
}

- (void)setUpValue
{
    NSUserDefaults* loginDefaults = [NSUserDefaults standardUserDefaults];
    _userModel = [self.dataHelper getUser:[[AppDelegate getUserID] intValue]];
    _companyId = VAL_companyId;
    _companyAccount = [loginDefaults stringForKey:@"companyAccount"];
    _companyName = VAL_CompanyName;
    _inviteName = _userModel.realName;
}

- (SDDataBaseHelper*)dataHelper
{
    if (nil == _dataHelper) {
        _dataHelper = [SDDataBaseHelper shareDB];
    }
    return _dataHelper;
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isFromExternalStaff == NO) {
        SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
        RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
        [tabBarVC setTabBarHidden:YES animated:NO];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isFromExternalStaff == NO) {
        SDRootNavigationController* rootVC = (SDRootNavigationController*)[[UIApplication sharedApplication].windows[0] rootViewController];
        RDVTabBarController* tabBarVC = (RDVTabBarController*)[rootVC viewControllers][0];
        [tabBarVC setTabBarHidden:NO animated:NO];
        
    }
}

#pragma mark 网络获取数据
- (void)loadURL
{
    /*
     // 设置登录参数
     NSString* url = [NSString stringWithFormat:@"%@cxCfg/findByKey", urlPrefix];
     NSDictionary* params = @{@"_key" : @"DN"};
     
     [HttpTool postWithPath:url
     params:params
     success:^(id JSON)
     {
     NSDictionary* dict = JSON;
     NSNumber* status = [dict objectForKey:@"status"];
     
     id msg = [dict objectForKey:@"msg"];
     NSString* message = [NSString stringWithFormat:@"%@", msg];
     if ([message isEqualToString:@"<null>"])
     {
     message = @"";
     }
     if (status.intValue == 200)
     {
     _urlName = dict[@"data"];
     /// 二维码url
     _qrString = [NSString stringWithFormat:@"%@",_urlName];
     NSLog(@"客户端－二维码地址:%@",_qrString);
     // 生成二维码
     [self setQr];
     }
     else {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [alert show];
     }
     }
     failure:^(NSError* error)
     {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:KNetworkFailRemind delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [alert show];
     }];
     */
    _qrString = VAL_IOS_DOWNLOAD;
    [self setQr];
}

///// 生成二维码
- (void)setQr
{
    /// 生成二维码并保存
    _codeImage = [QRCodeGenerator qrImageForString:_qrString imageSize:250.f];
    _codeImage = [self combine:_codeImage];
    
    float size = 250.f;
    
    //二维码对象
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100, size, size)];
    imageView.center = self.view.center;
    imageView.image = _codeImage;
    [self.view addSubview:imageView];
}

- (UIImage *)combine:(UIImage*)outImage
{
    UIImage *innerImage = [UIImage imageNamed:@"about_logo"];
    
    CGSize offScreenSize = CGSizeMake(250, 250);
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, offScreenSize.width, offScreenSize.height);
    [outImage drawInRect:rect];
    
    rect = CGRectMake(100, 100, 50, 50);
    [innerImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}

@end
