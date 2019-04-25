//
//  CXIDGAnnualLuckyDrawQDCodeViewController.m
//  InjoyIDG
//
//  Created by wtz on 2018/1/10.
//  Copyright © 2018年 Injoy. All rights reserved.
//

#import "CXIDGAnnualLuckyDrawQDCodeViewController.h"
#import "SDMenuView.h"
#import "QRCodeGenerator.h"

#define kFilePath [NSString stringWithFormat:@"%@/Documents/QD", NSHomeDirectory()]

@interface CXIDGAnnualLuckyDrawQDCodeViewController ()<SDMenuViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) SDRootTopView* rootTopView;
@property (nonatomic, strong) UITableView* myTableView;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) UIImage * qrImage;
//选择菜单
@property (nonatomic, strong) SDMenuView* selectMemu;
//用来判断右上角的菜单是否显示
@property (nonatomic) BOOL isSelectMenuSelected;

@end

@implementation CXIDGAnnualLuckyDrawQDCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTopView];
    [self setQrImage];
    _isSelectMenuSelected = NO;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGestureEvent:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGestureRecognizer locationInView:nil];
        //由于这里获取不到右上角的按钮，所以用location来获取到按钮的范围，把它排除出去
        if (![_selectMemu pointInside:[_selectMemu convertPoint:location fromView:self.view.window] withEvent:nil] && !(location.x > Screen_Width - 50 && location.y < navHigh)) {
            [self selectMenuViewDisappear];
        }
    }
}

- (void)selectMenuViewDisappear
{
    _isSelectMenuSelected = NO;
    [_selectMemu removeFromSuperview];
    _selectMemu = nil;
}

- (void)sendMsgBtnEvent:(UIButton*)sender
{
    if (!_isSelectMenuSelected) {
        _isSelectMenuSelected = YES;
        NSArray* dataArray = @[ @"保存到手机"];
        NSArray* imageArray = @[ @"saveQRCodeImage"];
        _selectMemu = [[SDMenuView alloc] initWithDataArray:dataArray andImageNameArray:imageArray];
        _selectMemu.delegate = self;
        [self.view addSubview:_selectMemu];
        [self.view bringSubviewToFront:_selectMemu];
    }
    else {
        [self selectMenuViewDisappear];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self selectMenuViewDisappear];
}

///// 导航条
- (void)setUpTopView
{
    self.rootTopView = [self getRootTopView];
    [self.rootTopView setNavTitle:@"签到二维码"];
    
    // 返回按钮
    [self.rootTopView setUpLeftBarItemImage:[UIImage imageNamed:@"back.png"] addTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.rootTopView setUpRightBarItemImage:[UIImage imageNamed:@"add.png"] addTarget:self action:@selector(sendMsgBtnEvent:)];
}

#pragma mark - SDMenuViewDelegate
- (void)returnCardID:(NSInteger)cardID withCardName:(NSString*)cardName
{
    [self selectMenuViewDisappear];
    
    if (cardID == 0) {
        [self saveImageToIphoneWithImage:self.qrImage];
    }
}

#pragma mark - 生成二维码
- (void)setQrImage
{
    _imageName = [NSString stringWithFormat:@"签到二维码_%@.png",VAL_USERID];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", kFilePath, _imageName];
    
    // 判断该路径是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // 判断该文件夹存不存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:kFilePath])
        {
            // 新建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:kFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    //生成二维码的字符串，meetId&imAccount&cx:idgMeetIdAndImAccount.cn
    NSString * codeString = [NSString stringWithFormat:@"%zd&cx:idgMeetId.cn",[self.currentAnnualMeetingModel.eid integerValue]];
    
    /// 生成二维码并保存
    self.qrImage = [QRCodeGenerator qrImageForString:codeString imageSize:200.0];
    self.qrImage = [self combine:self.qrImage];
    BOOL finishyet = [UIImagePNGRepresentation(self.qrImage) writeToFile:filePath atomically:YES];
    
    if (finishyet) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0,navHigh + (Screen_Height - navHigh - Screen_Width*4/5)/2, Screen_Width, Screen_Width*4/5);
        imageView.image = self.qrImage;
        imageView.highlightedImage = self.qrImage;
        [self.view addSubview:imageView];
    }else{
        TTAlert(@"创建二维码失败，请清理您的手机内存");
    }
}

- (UIImage *) combine:(UIImage*)innerImage
{
    UIImage *outImage = [UIImage imageNamed:@"newqrSao"];
    
    CGSize offScreenSize = CGSizeMake(outImage.size.width, outImage.size.height);
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, offScreenSize.width, offScreenSize.height);
    [outImage drawInRect:rect];
    
    rect = CGRectMake(100, 10, 300, 300);
    [innerImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imagez;
}

- (void)saveImageToIphoneWithImage:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error) {
        TTAlert(@"保存成功");
    }else{
        TTAlert(@"保存失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
